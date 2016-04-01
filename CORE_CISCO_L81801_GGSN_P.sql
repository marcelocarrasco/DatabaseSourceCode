--------------------------------------------------------
--  DDL for Procedure CORE_CISCO_L81801_GGSN_P
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HARRIAGUE"."CORE_CISCO_L81801_GGSN_P" (P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR)
IS
BEGIN
  MERGE INTO CORE_CISCO_L81801_GGSN_HIST D
  USING (
          SELECT FECHA,
                 FILENAME,
                 ORDEN,
                 SCHEMANAME,
                 GWNAME,
                 CCMSGCCAINITACCEPT,
                 CCMSGCCRINIT
          FROM CORE_CISCO_PDSNSYSTEM2_GGSN
          WHERE FECHA BETWEEN TO_DATE(P_FECHA_DESDE, 'DD.MM.YYYY HH24')
                                 AND TO_DATE(P_FECHA_HASTA, 'DD.MM.YYYY HH24') + (86399 / 86400)
        ) O
ON (O.FECHA = D.FECHA
    AND O.GWNAME = D.GWNAME
    AND O.SCHEMANAME = D.SCHEMANAME)
  WHEN MATCHED THEN UPDATE SET D.CCMSGCCAINITACCEPT = O.CCMSGCCAINITACCEPT,
                               D.CCMSGCCRINIT = O.CCMSGCCRINIT
  WHEN NOT MATCHED THEN INSERT (
                               D.FECHA                      ,
                               D.FILENAME                   ,
                               D.ORDEN                   ,
                               D.SCHEMANAME ,
                               D.GWNAME   ,
                               D.CCMSGCCAINITACCEPT,
                               D.CCMSGCCRINIT
                               )
                        VALUES (
                               O.FECHA                      ,
                               O.FILENAME                   ,
                               O.ORDEN                   ,
                               O.SCHEMANAME ,
                               O.GWNAME   ,
                               O.CCMSGCCAINITACCEPT,
                               O.CCMSGCCRINIT
                               );

COMMIT;
exception
  WHEN others THEN
    PKG_ERROR_LOG_NEW.P_LOG_ERROR('CORE_CISCO_L81801_GGSN_P',SQLCODE,SQLERRM,'P_FECHA_DESDE '||P_FECHA_DESDE||' P_FECHA_HASTA '||P_FECHA_HASTA);
END;

/
