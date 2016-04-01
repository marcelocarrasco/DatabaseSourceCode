--------------------------------------------------------
--  DDL for Procedure CORE_CISCO_L81B01_GGSN_P
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HARRIAGUE"."CORE_CISCO_L81B01_GGSN_P" (P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR)
IS
BEGIN
  MERGE INTO CORE_CISCO_L81B01_GGSN_HIST D
  USING (
        SELECT FECHA,
                 FILENAME,
                 ORDEN,
                 SCHEMANAME,
                 GWNAME,
                 SERVID,
                 SERVNAME,
                 DPCACURSESS
        FROM CORE_CISCO_IMSA_GGSN
        WHERE FECHA BETWEEN  TO_DATE(P_FECHA_DESDE, 'DD.MM.YYYY HH24')
                         AND TO_DATE(P_FECHA_HASTA, 'DD.MM.YYYY HH24') + (86399 / 86400)
        ) O
ON (O.FECHA = D.FECHA
    AND O.GWNAME = D.GWNAME
    AND O.SCHEMANAME = D.SCHEMANAME
    AND O.SERVNAME = D.SERVNAME
    AND O.SERVID = D.SERVID)
  WHEN MATCHED THEN UPDATE SET D.DPCACURSESS = O.DPCACURSESS
  WHEN NOT MATCHED THEN INSERT (
                               D.FECHA                      ,
                               D.FILENAME                   ,
                               D.ORDEN                   ,
                               D.SCHEMANAME ,
                               D.GWNAME   ,
                               D.SERVID,
                               D.SERVNAME,
                               D.DPCACURSESS
                               )
                        VALUES (
                               O.FECHA                      ,
                               O.FILENAME                   ,
                               O.ORDEN                   ,
                               O.SCHEMANAME ,
                               O.GWNAME   ,
                               O.SERVID,
                               O.SERVNAME,
                               O.DPCACURSESS
                               );

COMMIT;
END;

/
