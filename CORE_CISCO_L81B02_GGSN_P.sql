--------------------------------------------------------
--  DDL for Procedure CORE_CISCO_L81B02_GGSN_P
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HARRIAGUE"."CORE_CISCO_L81B02_GGSN_P" (P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR)
IS
BEGIN
  MERGE INTO CORE_CISCO_L81B02_GGSN_HIST D
  USING (

      SELECT FECHA, FILENAME, ORDEN, SCHEMANAME, GWNAME, SERVID, SERVNAME, DPCATERM
      FROM(
          SELECT FECHA, FILENAME, ORDEN, SCHEMANAME, GWNAME, SERVID, SERVNAME,
                  ROW_NUMBER() OVER(PARTITION BY SCHEMANAME, GWNAME, SERVID, SERVNAME
                                                   ORDER BY FECHA ASC
                                                   ) AS SEQNUM,
                  DECODE(DPCATERM,0,0,
                  CASE WHEN L_DPCATERM/DPCATERM > 1 THEN -- FIX
                            CASE WHEN ROUND(4294967296/L_DPCATERM,0) = 1 THEN
                                      (4294967296 + DPCATERM - L_DPCATERM)
                                 ELSE -1 END
                       ELSE (DPCATERM - L_DPCATERM)  END ) AS DPCATERM --OK
          FROM(
            SELECT  FECHA, FILENAME, ORDEN, SCHEMANAME, GWNAME, SERVID, SERVNAME,
                      NVL(DPCATERM,0) AS DPCATERM,
                      NVL(LAG (  DPCATERM  , 1) OVER (PARTITION BY
                                              GWNAME,
                                              SERVID,
                                              SERVNAME
                                              ORDER BY FECHA), 0) AS L_DPCATERM
                FROM CORE_CISCO_IMSA_GGSN
                 WHERE FECHA BETWEEN  TO_DATE(P_FECHA_DESDE, 'DD.MM.YYYY HH24')
                               AND TO_DATE(P_FECHA_HASTA, 'DD.MM.YYYY HH24') + (86399 / 86400)
          )
      )
      WHERE SEQNUM > 1
      AND DPCATERM != -1

    ) O
ON (O.FECHA = D.FECHA
    AND O.GWNAME = D.GWNAME
    AND O.SCHEMANAME = D.SCHEMANAME
    AND O.SERVID = D.SERVID
    AND O.SERVNAME = D.SERVNAME )
  WHEN MATCHED THEN UPDATE SET D.DPCATERM = O.DPCATERM
  WHEN NOT MATCHED THEN INSERT (
                               D.FECHA                      ,
                               D.FILENAME                   ,
                               D.ORDEN                   ,
                               D.SCHEMANAME ,
                               D.GWNAME   ,
                               D.SERVID,
                               D.SERVNAME,
                               D.DPCATERM
                               )
                        VALUES (
                               O.FECHA                      ,
                               O.FILENAME                   ,
                               O.ORDEN                   ,
                               O.SCHEMANAME ,
                               O.GWNAME   ,
                               O.SERVID,
                               O.SERVNAME,
                               O.DPCATERM
                               );

COMMIT;
END;

/
