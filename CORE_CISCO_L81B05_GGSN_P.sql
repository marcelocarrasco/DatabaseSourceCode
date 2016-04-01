--------------------------------------------------------
--  DDL for Procedure CORE_CISCO_L81B05_GGSN_P
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HARRIAGUE"."CORE_CISCO_L81B05_GGSN_P" (P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR)
IS
BEGIN
  MERGE INTO CORE_CISCO_L81B05_GGSN_HIST D
  USING (

      SELECT FECHA, FILENAME, ORDEN, SCHEMANAME, GWNAME, SERVID, SERVNAME, DPCACCAITIMEOUT,DPCAMSGCCR
      FROM(
          SELECT FECHA, FILENAME, ORDEN, SCHEMANAME, GWNAME, SERVID, SERVNAME,
                  ROW_NUMBER() OVER(PARTITION BY SCHEMANAME, GWNAME, SERVID, SERVNAME
                                                   ORDER BY FECHA ASC
                                                   ) AS SEQNUM,
                  DECODE(DPCACCAITIMEOUT,0,0,
                  CASE WHEN L_DPCACCAITIMEOUT/DPCACCAITIMEOUT > 1 THEN -- FIX
                            CASE WHEN ROUND(4294967296/L_DPCACCAITIMEOUT,0) = 1 THEN
                                      (4294967296 + DPCACCAITIMEOUT - L_DPCACCAITIMEOUT)
                                 ELSE -1 END
                       ELSE (DPCACCAITIMEOUT - L_DPCACCAITIMEOUT)  END ) AS DPCACCAITIMEOUT, --OK
                  DECODE(DPCAMSGCCR,0,0,
                  CASE WHEN L_DPCAMSGCCR/DPCAMSGCCR > 1 THEN -- FIX
                            CASE WHEN ROUND(4294967296/L_DPCAMSGCCR,0) = 1 THEN
                                      (4294967296 + DPCAMSGCCR - L_DPCAMSGCCR)
                                 ELSE -1 END
                       ELSE (DPCAMSGCCR - L_DPCAMSGCCR)  END ) AS DPCAMSGCCR --OK
          FROM(
            SELECT  FECHA, FILENAME, ORDEN, SCHEMANAME, GWNAME, SERVID, SERVNAME,
                      NVL(DPCACCAITIMEOUT,0) AS DPCACCAITIMEOUT,
                      NVL(LAG (  DPCACCAITIMEOUT  , 1) OVER (PARTITION BY
                                                          GWNAME,
                                                          SERVID,
                                                          SERVNAME
                                                          ORDER BY FECHA), 0) AS L_DPCACCAITIMEOUT,
                      NVL(DPCAMSGCCR,0) AS DPCAMSGCCR,
                      NVL(LAG (  DPCAMSGCCR  , 1) OVER (PARTITION BY
                                                          GWNAME,
                                                          SERVID,
                                                          SERVNAME
                                                          ORDER BY FECHA), 0) AS L_DPCAMSGCCR
                FROM CORE_CISCO_IMSA_GGSN
                 WHERE FECHA BETWEEN  TO_DATE(P_FECHA_DESDE, 'DD.MM.YYYY HH24')
                               AND TO_DATE(P_FECHA_HASTA, 'DD.MM.YYYY HH24') + (86399 / 86400)
          )
      )
      WHERE SEQNUM > 1
      AND DPCACCAITIMEOUT != -1
      AND DPCAMSGCCR != -1
    ) O
ON (O.FECHA = D.FECHA
    AND O.GWNAME = D.GWNAME
    AND O.schemaname = D.schemaname
    AND O.SERVID = D.SERVID
    AND O.SERVNAME = D.SERVNAME )
  WHEN MATCHED THEN UPDATE SET D.DPCACCAITIMEOUT = O.DPCACCAITIMEOUT,
                              D.DPCAMSGCCR = O.DPCAMSGCCR
  WHEN NOT MATCHED THEN INSERT (
                               D.FECHA                      ,
                               D.FILENAME                   ,
                               D.ORDEN                   ,
                               D.SCHEMANAME ,
                               D.GWNAME   ,
                               D.SERVID,
                               D.SERVNAME,
                               D.DPCACCAITIMEOUT,
                               D.DPCAMSGCCR
                               )
                        VALUES (
                               O.FECHA                      ,
                               O.FILENAME                   ,
                               O.ORDEN                   ,
                               O.SCHEMANAME ,
                               O.GWNAME   ,
                               O.SERVID,
                               O.SERVNAME,
                               O.DPCACCAITIMEOUT,
                               O.DPCAMSGCCR
                               );

COMMIT;
END;

/
