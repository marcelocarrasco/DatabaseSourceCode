--------------------------------------------------------
--  DDL for Procedure CORE_CISCO_L81804_GGSN_P
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HARRIAGUE"."CORE_CISCO_L81804_GGSN_P" (P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR)
IS
BEGIN
  MERGE INTO CORE_CISCO_L81804_GGSN_HIST D
  USING (

      SELECT FECHA, FILENAME, ORDEN, SCHEMANAME, GWNAME, CCMSGCCAFINAL,  CCMSGCCRFINAL
          FROM(
              SELECT FECHA, FILENAME, ORDEN, SCHEMANAME, GWNAME,
                      ROW_NUMBER() OVER(PARTITION BY SCHEMANAME
                                                       ORDER BY FECHA ASC
                                                       ) AS SEQNUM,
                      DECODE(CCMSGCCAFINAL,0,0,
                      CASE WHEN L_CCMSGCCAFINAL/CCMSGCCAFINAL > 1 THEN -- FIX
                                CASE WHEN ROUND(4294967296/L_CCMSGCCAFINAL,0) = 1 THEN
                                          (4294967296 + CCMSGCCAFINAL - L_CCMSGCCAFINAL)
                                     ELSE -1 END
                           ELSE (CCMSGCCAFINAL - L_CCMSGCCAFINAL)  END ) AS CCMSGCCAFINAL, --OK
                      DECODE(CCMSGCCRFINAL,0,0,
                      CASE WHEN L_CCMSGCCRFINAL/CCMSGCCRFINAL > 1 THEN -- FIX
                                CASE WHEN ROUND(4294967296/L_CCMSGCCRFINAL,0) = 1 THEN
                                          (4294967296 + CCMSGCCRFINAL - L_CCMSGCCRFINAL)
                                     ELSE -1 END
                           ELSE (CCMSGCCRFINAL - L_CCMSGCCRFINAL)  END ) AS CCMSGCCRFINAL --OK
              FROM(
                SELECT  FECHA, FILENAME, ORDEN, SCHEMANAME, GWNAME,
                        NVL(CCMSGCCAFINAL, 0) AS CCMSGCCAFINAL,
                         NVL(LAG (  CCMSGCCAFINAL  , 1) OVER (PARTITION BY
                                                          GWNAME
                                                          ORDER BY FECHA), 0) AS L_CCMSGCCAFINAL,
                        NVL(CCMSGCCRFINAL, 0) AS CCMSGCCRFINAL,
                         NVL(LAG (  CCMSGCCRFINAL  , 1) OVER (PARTITION BY
                                                          GWNAME
                                                          ORDER BY FECHA), 0) AS L_CCMSGCCRFINAL
                    FROM CORE_CISCO_PDSNSYSTEM2_GGSN
                     WHERE FECHA BETWEEN  TO_DATE(P_FECHA_DESDE, 'DD.MM.YYYY HH24')
                                   AND TO_DATE(P_FECHA_HASTA, 'DD.MM.YYYY HH24') + (86399 / 86400)
              )
          )
          WHERE SEQNUM > 1
          AND CCMSGCCAFINAL != -1
          AND CCMSGCCRFINAL != -1

        ) O
ON (O.FECHA = D.FECHA
    AND O.GWNAME = D.GWNAME
    AND O.SCHEMANAME = D.SCHEMANAME )
  WHEN MATCHED THEN UPDATE SET D.CCMSGCCAFINAL = O.CCMSGCCAFINAL,
                                D.CCMSGCCRFINAL = O.CCMSGCCRFINAL
  WHEN NOT MATCHED THEN INSERT (
                               D.FECHA                      ,
                               D.FILENAME                   ,
                               D.ORDEN                   ,
                               D.SCHEMANAME ,
                               D.GWNAME   ,
                               D.CCMSGCCAFINAL,
                               D.CCMSGCCRFINAL
                               )
                        VALUES (
                               O.FECHA                      ,
                               O.FILENAME                   ,
                               O.ORDEN                   ,
                               O.SCHEMANAME ,
                               O.GWNAME   ,
                               O.CCMSGCCAFINAL,
                               O.CCMSGCCRFINAL
                               );

COMMIT;
exception
  WHEN others THEN
    PKG_ERROR_LOG_NEW.P_LOG_ERROR('CORE_CISCO_L81804_GGSN_P',SQLCODE,SQLERRM,'P_FECHA_DESDE '||P_FECHA_DESDE||' P_FECHA_HASTA '||P_FECHA_HASTA);
END;

/
