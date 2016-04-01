--------------------------------------------------------
--  DDL for Procedure CORE_CISCO_L71303_GGSN_P
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HARRIAGUE"."CORE_CISCO_L71303_GGSN_P" (P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR)
IS

BEGIN
  MERGE INTO CORE_CISCO_L71303_GGSN_HIST D
  USING (

        SELECT FECHA, FILENAME, ORDEN, SCHEMANAME, GWNAME, SERVID, SERVNAME,
               ROUND( (
                  DATASTATDLQCI1TOTBYTE+
                  DATASTATDLQCI2TOTBYTE+
                  DATASTATDLQCI3TOTBYTE+
                  DATASTATDLQCI4TOTBYTE+
                  DATASTATDLQCI5TOTBYTE+
                  DATASTATDLQCI6TOTBYTE+
                  DATASTATDLQCI7TOTBYTE+
                  DATASTATDLQCI8TOTBYTE+
                  DATASTATDLQCI9TOTBYTE+
                  DATASTATDLOTHERTOTBYTE
                ) * 8 /( 15 * 60 ) / 1000000 ,2) AS DOWNLINK_THROUGHPUT
        FROM(
            SELECT FECHA, FILENAME, ORDEN, SCHEMANAME, GWNAME, SERVID, SERVNAME,
                    ROW_NUMBER() OVER(PARTITION BY SCHEMANAME, GWNAME, SERVID, SERVNAME
                                                     ORDER BY FECHA ASC
                                                     ) AS SEQNUM,
                    DECODE(DATASTATDLQCI1TOTBYTE,0,0,
                    CASE WHEN L_DATASTATDLQCI1TOTBYTE/DATASTATDLQCI1TOTBYTE > 1 THEN -- FIX
                              CASE WHEN ROUND(4294967296/L_DATASTATDLQCI1TOTBYTE,0) = 1 THEN
                                        (4294967296 + DATASTATDLQCI1TOTBYTE - L_DATASTATDLQCI1TOTBYTE)
                                   ELSE -1 END
                         ELSE (DATASTATDLQCI1TOTBYTE - L_DATASTATDLQCI1TOTBYTE)  END ) AS DATASTATDLQCI1TOTBYTE, --OK
                    DECODE(DATASTATDLQCI2TOTBYTE,0,0,
                    CASE WHEN L_DATASTATDLQCI2TOTBYTE/DATASTATDLQCI2TOTBYTE > 1 THEN -- FIX
                              CASE WHEN ROUND(4294967296/L_DATASTATDLQCI2TOTBYTE,0) = 1 THEN
                                        (4294967296 + DATASTATDLQCI2TOTBYTE - L_DATASTATDLQCI2TOTBYTE)
                                   ELSE -1 END
                         ELSE (DATASTATDLQCI2TOTBYTE - L_DATASTATDLQCI2TOTBYTE)  END ) AS DATASTATDLQCI2TOTBYTE, --OK
                    DECODE(DATASTATDLQCI3TOTBYTE,0,0,
                      CASE WHEN L_DATASTATDLQCI3TOTBYTE/DATASTATDLQCI3TOTBYTE > 1 THEN -- FIX
                                CASE WHEN ROUND(4294967296/L_DATASTATDLQCI3TOTBYTE,0) = 1 THEN
                                          (4294967296 + DATASTATDLQCI3TOTBYTE - L_DATASTATDLQCI3TOTBYTE)
                                     ELSE -1 END
                           ELSE (DATASTATDLQCI3TOTBYTE - L_DATASTATDLQCI3TOTBYTE)  END ) AS DATASTATDLQCI3TOTBYTE, --OK
                    DECODE(DATASTATDLQCI4TOTBYTE,0,0,
                      CASE WHEN L_DATASTATDLQCI4TOTBYTE/DATASTATDLQCI4TOTBYTE > 1 THEN -- FIX
                                CASE WHEN ROUND(4294967296/L_DATASTATDLQCI4TOTBYTE,0) = 1 THEN
                                          (4294967296 + DATASTATDLQCI4TOTBYTE - L_DATASTATDLQCI4TOTBYTE)
                                     ELSE -1 END
                           ELSE (DATASTATDLQCI4TOTBYTE - L_DATASTATDLQCI4TOTBYTE)  END ) AS DATASTATDLQCI4TOTBYTE, --OK
                    DECODE(DATASTATDLQCI5TOTBYTE,0,0,
                      CASE WHEN L_DATASTATDLQCI5TOTBYTE/DATASTATDLQCI5TOTBYTE > 1 THEN -- FIX
                                CASE WHEN ROUND(4294967296/L_DATASTATDLQCI5TOTBYTE,0) = 1 THEN
                                          (4294967296 + DATASTATDLQCI5TOTBYTE - L_DATASTATDLQCI5TOTBYTE)
                                     ELSE -1 END
                           ELSE (DATASTATDLQCI5TOTBYTE - L_DATASTATDLQCI5TOTBYTE)  END ) AS DATASTATDLQCI5TOTBYTE, --OK
                    DECODE(DATASTATDLQCI6TOTBYTE,0,0,
                      CASE WHEN L_DATASTATDLQCI6TOTBYTE/DATASTATDLQCI6TOTBYTE > 1 THEN -- FIX
                                CASE WHEN ROUND(4294967296/L_DATASTATDLQCI6TOTBYTE,0) = 1 THEN
                                          (4294967296 + DATASTATDLQCI6TOTBYTE - L_DATASTATDLQCI6TOTBYTE)
                                     ELSE -1 END
                           ELSE (DATASTATDLQCI6TOTBYTE - L_DATASTATDLQCI6TOTBYTE)  END ) AS DATASTATDLQCI6TOTBYTE, --OK
                    DECODE(DATASTATDLQCI7TOTBYTE,0,0,
                      CASE WHEN L_DATASTATDLQCI7TOTBYTE/DATASTATDLQCI7TOTBYTE > 1 THEN -- FIX
                                CASE WHEN ROUND(4294967296/L_DATASTATDLQCI7TOTBYTE,0) = 1 THEN
                                          (4294967296 + DATASTATDLQCI7TOTBYTE - L_DATASTATDLQCI7TOTBYTE)
                                     ELSE -1 END
                           ELSE (DATASTATDLQCI7TOTBYTE - L_DATASTATDLQCI7TOTBYTE)  END ) AS DATASTATDLQCI7TOTBYTE, --OK
                    DECODE(DATASTATDLQCI8TOTBYTE,0,0,
                      CASE WHEN L_DATASTATDLQCI8TOTBYTE/DATASTATDLQCI8TOTBYTE > 1 THEN -- FIX
                                CASE WHEN ROUND(4294967296/L_DATASTATDLQCI8TOTBYTE,0) = 1 THEN
                                          (4294967296 + DATASTATDLQCI8TOTBYTE - L_DATASTATDLQCI8TOTBYTE)
                                     ELSE -1 END
                           ELSE (DATASTATDLQCI8TOTBYTE - L_DATASTATDLQCI8TOTBYTE)  END ) AS DATASTATDLQCI8TOTBYTE, --OK
                    DECODE(DATASTATDLQCI9TOTBYTE,0,0,
                      CASE WHEN L_DATASTATDLQCI9TOTBYTE/DATASTATDLQCI9TOTBYTE > 1 THEN -- FIX
                                CASE WHEN ROUND(4294967296/L_DATASTATDLQCI9TOTBYTE,0) = 1 THEN
                                          (4294967296 + DATASTATDLQCI9TOTBYTE - L_DATASTATDLQCI9TOTBYTE)
                                     ELSE -1 END
                           ELSE (DATASTATDLQCI9TOTBYTE - L_DATASTATDLQCI9TOTBYTE)  END ) AS DATASTATDLQCI9TOTBYTE, --OK
                    DECODE(DATASTATDLOTHERTOTBYTE,0,0,
                      CASE WHEN L_DATASTATDLOTHERTOTBYTE/DATASTATDLOTHERTOTBYTE > 1 THEN -- FIX
                                CASE WHEN ROUND(4294967296/L_DATASTATDLOTHERTOTBYTE,0) = 1 THEN
                                          (4294967296 + DATASTATDLOTHERTOTBYTE - L_DATASTATDLOTHERTOTBYTE)
                                     ELSE -1 END
                           ELSE (DATASTATDLOTHERTOTBYTE - L_DATASTATDLOTHERTOTBYTE)  END ) AS DATASTATDLOTHERTOTBYTE --OK
            FROM (
              SELECT  FECHA, FILENAME, ORDEN, SCHEMANAME, GWNAME, SERVID, SERVNAME,
                        NVL(DATASTATDLQCI1TOTBYTE, 0) AS DATASTATDLQCI1TOTBYTE,
                         NVL(LEAD (  DATASTATDLQCI1TOTBYTE  , 1) OVER (PARTITION BY
                                                          GWNAME ,
                                                          SERVID,
                                                          SERVNAME
                                                          ORDER BY FECHA DESC), 0) AS L_DATASTATDLQCI1TOTBYTE,
                        NVL(DATASTATDLQCI2TOTBYTE, 0) AS DATASTATDLQCI2TOTBYTE,
                         NVL(LEAD (  DATASTATDLQCI2TOTBYTE  , 1) OVER (PARTITION BY
                                                          GWNAME ,
                                                          SERVID,
                                                          SERVNAME
                                                          ORDER BY FECHA DESC), 0) AS L_DATASTATDLQCI2TOTBYTE,
                        NVL(DATASTATDLQCI3TOTBYTE, 0) AS DATASTATDLQCI3TOTBYTE,
                         NVL(LEAD (  DATASTATDLQCI3TOTBYTE  , 1) OVER (PARTITION BY
                                                          GWNAME ,
                                                          SERVID,
                                                          SERVNAME
                                                          ORDER BY FECHA DESC), 0) AS L_DATASTATDLQCI3TOTBYTE,
                        NVL(DATASTATDLQCI4TOTBYTE, 0) AS DATASTATDLQCI4TOTBYTE,
                         NVL(LEAD (  DATASTATDLQCI4TOTBYTE  , 1) OVER (PARTITION BY
                                                          GWNAME ,
                                                          SERVID,
                                                          SERVNAME
                                                          ORDER BY FECHA DESC), 0) AS L_DATASTATDLQCI4TOTBYTE,
                        NVL(DATASTATDLQCI5TOTBYTE, 0) AS DATASTATDLQCI5TOTBYTE,
                         NVL(LEAD (  DATASTATDLQCI5TOTBYTE  , 1) OVER (PARTITION BY
                                                          GWNAME ,
                                                          SERVID,
                                                          SERVNAME
                                                          ORDER BY FECHA DESC), 0) AS L_DATASTATDLQCI5TOTBYTE,
                        NVL(DATASTATDLQCI6TOTBYTE, 0) AS DATASTATDLQCI6TOTBYTE,
                         NVL(LEAD (  DATASTATDLQCI6TOTBYTE  , 1) OVER (PARTITION BY
                                                          GWNAME ,
                                                          SERVID,
                                                          SERVNAME
                                                          ORDER BY FECHA DESC), 0) AS L_DATASTATDLQCI6TOTBYTE,
                        NVL(DATASTATDLQCI7TOTBYTE, 0) AS DATASTATDLQCI7TOTBYTE,
                         NVL(LEAD (  DATASTATDLQCI7TOTBYTE  , 1) OVER (PARTITION BY
                                                          GWNAME ,
                                                          SERVID,
                                                          SERVNAME
                                                          ORDER BY FECHA DESC), 0) AS L_DATASTATDLQCI7TOTBYTE,
                        NVL(DATASTATDLQCI8TOTBYTE, 0) AS DATASTATDLQCI8TOTBYTE,
                         NVL(LEAD (  DATASTATDLQCI8TOTBYTE  , 1) OVER (PARTITION BY
                                                          GWNAME ,
                                                          SERVID,
                                                          SERVNAME
                                                          ORDER BY FECHA DESC), 0) AS L_DATASTATDLQCI8TOTBYTE,
                        NVL(DATASTATDLQCI9TOTBYTE, 0) AS DATASTATDLQCI9TOTBYTE,
                         NVL(LEAD (  DATASTATDLQCI9TOTBYTE  , 1) OVER (PARTITION BY
                                                          GWNAME ,
                                                          SERVID,
                                                          SERVNAME
                                                          ORDER BY FECHA DESC), 0) AS L_DATASTATDLQCI9TOTBYTE,
                        NVL(DATASTATDLOTHERTOTBYTE, 0) AS DATASTATDLOTHERTOTBYTE,
                         NVL(LEAD (  DATASTATDLOTHERTOTBYTE  , 1) OVER (PARTITION BY
                                                          GWNAME ,
                                                          SERVID,
                                                          SERVNAME
                                                          ORDER BY FECHA DESC), 0) AS L_DATASTATDLOTHERTOTBYTE
                  FROM CORE_CISCO_SGW3_GGSN
                   WHERE FECHA BETWEEN  TO_DATE(P_FECHA_DESDE, 'DD.MM.YYYY HH24')
                                 AND TO_DATE(P_FECHA_HASTA, 'DD.MM.YYYY HH24') + (86399 / 86400)
              )
        )
        WHERE SEQNUM > 1
        AND DATASTATDLQCI1TOTBYTE != -1
        AND DATASTATDLQCI2TOTBYTE != -1
        AND DATASTATDLQCI3TOTBYTE != -1
        AND DATASTATDLQCI4TOTBYTE != -1
        AND DATASTATDLQCI5TOTBYTE != -1
        AND DATASTATDLQCI6TOTBYTE != -1
        AND DATASTATDLQCI7TOTBYTE != -1
        AND DATASTATDLQCI8TOTBYTE != -1
        AND DATASTATDLQCI9TOTBYTE != -1
        AND DATASTATDLOTHERTOTBYTE != -1

        ) O
ON (O.FECHA = D.FECHA
    AND O.GWNAME = D.GWNAME
    AND O.SERVNAME = D.SERVNAME
    AND O.schemaname = D.schemaname
    AND O.servid = D.servid )
  WHEN MATCHED THEN UPDATE SET D.DOWNLINK_THROUGHPUT = O.DOWNLINK_THROUGHPUT
  WHEN NOT MATCHED THEN INSERT (
                               D.FECHA                      ,
                               D.FILENAME                   ,
                               D.ORDEN                   ,
                               D.SCHEMANAME ,
                               D.GWNAME   ,
                               D.SERVID   ,
                               D.SERVNAME ,
                               D.DOWNLINK_THROUGHPUT
                               )
                        VALUES (
                               O.FECHA                      ,
                               O.FILENAME                   ,
                               O.ORDEN                   ,
                               O.SCHEMANAME ,
                               O.GWNAME   ,
                               O.SERVID   ,
                               O.SERVNAME ,
                               O.DOWNLINK_THROUGHPUT
                               );

COMMIT;
END;

/
