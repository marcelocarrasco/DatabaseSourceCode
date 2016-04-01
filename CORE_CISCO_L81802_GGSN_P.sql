--------------------------------------------------------
--  DDL for Procedure CORE_CISCO_L81802_GGSN_P
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HARRIAGUE"."CORE_CISCO_L81802_GGSN_P" (P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR)
IS
BEGIN
  MERGE INTO CORE_CISCO_L81802_GGSN_HIST D
  USING (
         SELECT FECHA, FILENAME, ORDEN, SCHEMANAME, GWNAME, CCMSGCCAUPDATE,  CCMSGCCRUPDATE
          FROM(
              SELECT FECHA, FILENAME, ORDEN, SCHEMANAME, GWNAME,
                      ROW_NUMBER() OVER(PARTITION BY SCHEMANAME
                                                       ORDER BY FECHA ASC
                                                       ) AS SEQNUM,
                      DECODE(CCMSGCCAUPDATE,0,0,
                      CASE WHEN L_CCMSGCCAUPDATE/CCMSGCCAUPDATE > 1 THEN -- FIX
                                CASE WHEN ROUND(4294967296/L_CCMSGCCAUPDATE,0) = 1 THEN
                                          (4294967296 + CCMSGCCAUPDATE - L_CCMSGCCAUPDATE)
                                     ELSE -1 END
                           ELSE (CCMSGCCAUPDATE - L_CCMSGCCAUPDATE)  END ) AS CCMSGCCAUPDATE, --OK
                      DECODE(CCMSGCCRUPDATE,0,0,
                      CASE WHEN L_CCMSGCCRUPDATE/CCMSGCCRUPDATE > 1 THEN -- FIX
                                CASE WHEN ROUND(4294967296/L_CCMSGCCRUPDATE,0) = 1 THEN
                                          (4294967296 + CCMSGCCRUPDATE - L_CCMSGCCRUPDATE)
                                     ELSE -1 END
                           ELSE (CCMSGCCRUPDATE - L_CCMSGCCRUPDATE)  END ) AS CCMSGCCRUPDATE --OK
              FROM(
                SELECT  FECHA, FILENAME, ORDEN, SCHEMANAME, GWNAME,
                        NVL(CCMSGCCAUPDATE, 0) AS CCMSGCCAUPDATE,
                         NVL(LAG (  CCMSGCCAUPDATE  , 1) OVER (PARTITION BY
                                                          GWNAME
                                                          ORDER BY FECHA), 0) AS L_CCMSGCCAUPDATE,
                        NVL(CCMSGCCRUPDATE, 0) AS CCMSGCCRUPDATE,
                         NVL(LAG (  CCMSGCCRUPDATE  , 1) OVER (PARTITION BY
                                                          GWNAME
                                                          ORDER BY FECHA), 0) AS L_CCMSGCCRUPDATE
                    FROM CORE_CISCO_PDSNSYSTEM2_GGSN
                     WHERE FECHA BETWEEN  TO_DATE(P_FECHA_DESDE, 'DD.MM.YYYY HH24')
                                   AND TO_DATE(P_FECHA_HASTA, 'DD.MM.YYYY HH24') + (86399 / 86400)
              )
          )
          WHERE SEQNUM > 1
          AND CCMSGCCAUPDATE != -1
          AND CCMSGCCRUPDATE != -1

         ) O
ON (O.FECHA = D.FECHA
    AND O.GWNAME = D.GWNAME
    AND O.SCHEMANAME = D.SCHEMANAME )
  WHEN MATCHED THEN UPDATE SET D.CCMSGCCAUPDATE = O.CCMSGCCAUPDATE,
                                D.CCMSGCCRUPDATE = O.CCMSGCCRUPDATE
  WHEN NOT MATCHED THEN INSERT (
                               D.FECHA                      ,
                               D.FILENAME                   ,
                               D.ORDEN                   ,
                               D.SCHEMANAME ,
                               D.GWNAME   ,
                               D.CCMSGCCAUPDATE,
                               D.CCMSGCCRUPDATE
                               )
                        VALUES (
                               O.FECHA                      ,
                               O.FILENAME                   ,
                               O.ORDEN                   ,
                               O.SCHEMANAME ,
                               O.GWNAME   ,
                               O.CCMSGCCAUPDATE,
                               O.CCMSGCCRUPDATE
                               );

COMMIT;
exception
  WHEN others THEN
    PKG_ERROR_LOG_NEW.P_LOG_ERROR('CORE_CISCO_L81802_GGSN_P',SQLCODE,SQLERRM,'P_FECHA_DESDE '||P_FECHA_DESDE||' P_FECHA_HASTA '||P_FECHA_HASTA);

END;

/
