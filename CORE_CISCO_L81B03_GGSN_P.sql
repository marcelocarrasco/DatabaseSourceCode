--------------------------------------------------------
--  DDL for Procedure CORE_CISCO_L81B03_GGSN_P
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HARRIAGUE"."CORE_CISCO_L81B03_GGSN_P" (P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR)
IS
BEGIN
  MERGE INTO CORE_CISCO_L81B03_GGSN_HIST D
  USING (

      SELECT FECHA, FILENAME, ORDEN, SCHEMANAME, GWNAME, SERVID, SERVNAME, DPCAMSGCCAINITACC,DPCAMSGCCRINIT
      FROM(
          SELECT FECHA, FILENAME, ORDEN, SCHEMANAME, GWNAME, SERVID, SERVNAME,
                  ROW_NUMBER() OVER(PARTITION BY SCHEMANAME, GWNAME, SERVID, SERVNAME
                                                   ORDER BY FECHA ASC
                                                   ) AS SEQNUM,
                  DECODE(DPCAMSGCCAINITACC,0,0,
                  CASE WHEN L_DPCAMSGCCAINITACC/DPCAMSGCCAINITACC > 1 THEN -- FIX
                            CASE WHEN ROUND(4294967296/L_DPCAMSGCCAINITACC,0) = 1 THEN
                                      (4294967296 + DPCAMSGCCAINITACC - L_DPCAMSGCCAINITACC)
                                 ELSE -1 END
                       ELSE (DPCAMSGCCAINITACC - L_DPCAMSGCCAINITACC)  END ) AS DPCAMSGCCAINITACC, --OK
                  DECODE(DPCAMSGCCRINIT,0,0,
                  CASE WHEN L_DPCAMSGCCRINIT/DPCAMSGCCRINIT > 1 THEN -- FIX
                            CASE WHEN ROUND(4294967296/L_DPCAMSGCCRINIT,0) = 1 THEN
                                      (4294967296 + DPCAMSGCCRINIT - L_DPCAMSGCCRINIT)
                                 ELSE -1 END
                       ELSE (DPCAMSGCCRINIT - L_DPCAMSGCCRINIT)  END ) AS DPCAMSGCCRINIT --OK
          FROM(
            SELECT  FECHA, FILENAME, ORDEN, SCHEMANAME, GWNAME, SERVID, SERVNAME,
                      NVL(DPCAMSGCCAINITACC,0) AS DPCAMSGCCAINITACC,
                      NVL(LAG (  DPCAMSGCCAINITACC  , 1) OVER (PARTITION BY
                                                          GWNAME,
                                                          SERVID,
                                                          SERVNAME
                                                          ORDER BY FECHA), 0) AS L_DPCAMSGCCAINITACC,
                      NVL(DPCAMSGCCRINIT,0) AS DPCAMSGCCRINIT,
                      NVL(LAG (  DPCAMSGCCRINIT  , 1) OVER (PARTITION BY
                                                          GWNAME,
                                                          SERVID,
                                                          SERVNAME
                                                          ORDER BY FECHA), 0) AS L_DPCAMSGCCRINIT
                FROM CORE_CISCO_IMSA_GGSN
                 WHERE FECHA BETWEEN  TO_DATE(P_FECHA_DESDE, 'DD.MM.YYYY HH24')
                               AND TO_DATE(P_FECHA_HASTA, 'DD.MM.YYYY HH24') + (86399 / 86400)
          )
      )
      WHERE SEQNUM > 1
      AND DPCAMSGCCAINITACC != -1
      AND DPCAMSGCCRINIT != -1
    ) O
ON (O.FECHA = D.FECHA
    AND O.GWNAME = D.GWNAME
    AND O.schemaname = D.schemaname
    AND O.SERVID = D.SERVID
    AND O.SERVNAME = D.SERVNAME )
  WHEN MATCHED THEN UPDATE SET D.DPCAMSGCCRINIT = O.DPCAMSGCCRINIT,
                              D.DPCAMSGCCAINITACC = O.DPCAMSGCCAINITACC
  WHEN NOT MATCHED THEN INSERT (
                               D.FECHA                      ,
                               D.FILENAME                   ,
                               D.ORDEN                   ,
                               D.SCHEMANAME ,
                               D.GWNAME   ,
                               D.SERVID,
                               D.SERVNAME,
                               D.DPCAMSGCCRINIT,
                               D.DPCAMSGCCAINITACC
                               )
                        VALUES (
                               O.FECHA                      ,
                               O.FILENAME                   ,
                               O.ORDEN                   ,
                               O.SCHEMANAME ,
                               O.GWNAME   ,
                               O.SERVID,
                               O.SERVNAME,
                               O.DPCAMSGCCRINIT,
                               O.DPCAMSGCCAINITACC
                               );

COMMIT;
END;

/
