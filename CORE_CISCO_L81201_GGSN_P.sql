--------------------------------------------------------
--  DDL for Procedure CORE_CISCO_L81201_GGSN_P
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HARRIAGUE"."CORE_CISCO_L81201_GGSN_P" (P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR)
IS

BEGIN
  MERGE INTO CORE_CISCO_L81201_GGSN_HIST D
  USING (
          SELECT FECHA,
                 FILENAME,
                 ORDEN,
                 SCHEMANAME,
                 GWNAME,
                 SERVID,
                 SERVNAME,
                 SESSCUR AS CURRENT_NUM_SESS
          FROM CORE_CISCO_PGW1_GGSN
          WHERE FECHA BETWEEN  TO_DATE(P_FECHA_DESDE, 'DD.MM.YYYY HH24')
                                 AND TO_DATE(P_FECHA_HASTA, 'DD.MM.YYYY HH24') + (86399 / 86400)
        ) O
ON (O.FECHA = D.FECHA
    AND O.GWNAME = D.GWNAME
    AND O.SERVNAME = D.SERVNAME
    AND O.SCHEMANAME = D.SCHEMANAME
    AND O.SERVID = D.SERVID )
  WHEN MATCHED THEN UPDATE SET D.CURRENT_NUM_SESS = O.CURRENT_NUM_SESS
  WHEN NOT MATCHED THEN INSERT (
                               D.FECHA                      ,
                               D.FILENAME                   ,
                               D.ORDEN                   ,
                               D.SCHEMANAME ,
                               D.GWNAME   ,
                               D.SERVID   ,
                               D.SERVNAME ,
                               D.CURRENT_NUM_SESS
                               )
                        VALUES (
                               O.FECHA                      ,
                               O.FILENAME                   ,
                               O.ORDEN                   ,
                               O.SCHEMANAME ,
                               O.GWNAME   ,
                               O.SERVID   ,
                               O.SERVNAME ,
                               O.CURRENT_NUM_SESS
                               );

COMMIT;
END;

/
