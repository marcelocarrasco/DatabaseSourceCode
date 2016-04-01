--------------------------------------------------------
--  DDL for Procedure CORE_CISCO_L71301_GGSN_P
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HARRIAGUE"."CORE_CISCO_L71301_GGSN_P" (P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR)
IS
BEGIN
  MERGE INTO CORE_CISCO_L71301_GGSN_HIST D
  USING (
        SELECT FECHA, FILENAME, ORDEN, SCHEMANAME, GWNAME, SERVID, SERVNAME,
               ROUND( ( (
                  DATASTATULQCI1TOTBYTE+
                  DATASTATULQCI2TOTBYTE+
                  DATASTATULQCI3TOTBYTE+
                  DATASTATULQCI4TOTBYTE+
                  DATASTATULQCI5TOTBYTE+
                  DATASTATULQCI6TOTBYTE+
                  DATASTATULQCI7TOTBYTE+
                  DATASTATULQCI8TOTBYTE+
                  DATASTATULQCI9TOTBYTE
                ) *8 / ( 15 * 60 )/ 1024 / 1024 ) ,2) AS UPLINK_THROUGHPUT
        FROM(
            SELECT FECHA, FILENAME, ORDEN, SCHEMANAME, GWNAME, SERVID, SERVNAME,
                    ROW_NUMBER() OVER(PARTITION BY SCHEMANAME, GWNAME, SERVID, SERVNAME
                                                     ORDER BY FECHA ASC
                                                     ) AS SEQNUM,
                    DECODE(DATASTATULQCI1TOTBYTE,0,0,
                    CASE WHEN L_DATASTATULQCI1TOTBYTE/DATASTATULQCI1TOTBYTE > 1 THEN -- FIX
                              CASE WHEN ROUND(4294967296/L_DATASTATULQCI1TOTBYTE,0) = 1 THEN
                                        (4294967296 + DATASTATULQCI1TOTBYTE - L_DATASTATULQCI1TOTBYTE)
                                   ELSE -1 END
                         ELSE (DATASTATULQCI1TOTBYTE - L_DATASTATULQCI1TOTBYTE)  END ) AS DATASTATULQCI1TOTBYTE, --OK
                    DECODE(DATASTATULQCI2TOTBYTE,0,0,
                    CASE WHEN L_DATASTATULQCI2TOTBYTE/DATASTATULQCI2TOTBYTE > 1 THEN -- FIX
                              CASE WHEN ROUND(4294967296/L_DATASTATULQCI2TOTBYTE,0) = 1 THEN
                                        (4294967296 + DATASTATULQCI2TOTBYTE - L_DATASTATULQCI2TOTBYTE)
                                   ELSE -1 END
                         ELSE (DATASTATULQCI2TOTBYTE - L_DATASTATULQCI2TOTBYTE)  END ) AS DATASTATULQCI2TOTBYTE, --OK
                    DECODE(DATASTATULQCI3TOTBYTE,0,0,
                      CASE WHEN L_DATASTATULQCI3TOTBYTE/DATASTATULQCI3TOTBYTE > 1 THEN -- FIX
                                CASE WHEN ROUND(4294967296/L_DATASTATULQCI3TOTBYTE,0) = 1 THEN
                                          (4294967296 + DATASTATULQCI3TOTBYTE - L_DATASTATULQCI3TOTBYTE)
                                     ELSE -1 END
                           ELSE (DATASTATULQCI3TOTBYTE - L_DATASTATULQCI3TOTBYTE)  END ) AS DATASTATULQCI3TOTBYTE, --OK
                    DECODE(DATASTATULQCI4TOTBYTE,0,0,
                      CASE WHEN L_DATASTATULQCI4TOTBYTE/DATASTATULQCI4TOTBYTE > 1 THEN -- FIX
                                CASE WHEN ROUND(4294967296/L_DATASTATULQCI4TOTBYTE,0) = 1 THEN
                                          (4294967296 + DATASTATULQCI4TOTBYTE - L_DATASTATULQCI4TOTBYTE)
                                     ELSE -1 END
                           ELSE (DATASTATULQCI4TOTBYTE - L_DATASTATULQCI4TOTBYTE)  END ) AS DATASTATULQCI4TOTBYTE, --OK
                    DECODE(DATASTATULQCI5TOTBYTE,0,0,
                      CASE WHEN L_DATASTATULQCI5TOTBYTE/DATASTATULQCI5TOTBYTE > 1 THEN -- FIX
                                CASE WHEN ROUND(4294967296/L_DATASTATULQCI5TOTBYTE,0) = 1 THEN
                                          (4294967296 + DATASTATULQCI5TOTBYTE - L_DATASTATULQCI5TOTBYTE)
                                     ELSE -1 END
                           ELSE (DATASTATULQCI5TOTBYTE - L_DATASTATULQCI5TOTBYTE)  END ) AS DATASTATULQCI5TOTBYTE, --OK
                    DECODE(DATASTATULQCI6TOTBYTE,0,0,
                      CASE WHEN L_DATASTATULQCI6TOTBYTE/DATASTATULQCI6TOTBYTE > 1 THEN -- FIX
                                CASE WHEN ROUND(4294967296/L_DATASTATULQCI6TOTBYTE,0) = 1 THEN
                                          (4294967296 + DATASTATULQCI6TOTBYTE - L_DATASTATULQCI6TOTBYTE)
                                     ELSE -1 END
                           ELSE (DATASTATULQCI6TOTBYTE - L_DATASTATULQCI6TOTBYTE)  END ) AS DATASTATULQCI6TOTBYTE, --OK
                    DECODE(DATASTATULQCI7TOTBYTE,0,0,
                      CASE WHEN L_DATASTATULQCI7TOTBYTE/DATASTATULQCI7TOTBYTE > 1 THEN -- FIX
                                CASE WHEN ROUND(4294967296/L_DATASTATULQCI7TOTBYTE,0) = 1 THEN
                                          (4294967296 + DATASTATULQCI7TOTBYTE - L_DATASTATULQCI7TOTBYTE)
                                     ELSE -1 END
                           ELSE (DATASTATULQCI7TOTBYTE - L_DATASTATULQCI7TOTBYTE)  END ) AS DATASTATULQCI7TOTBYTE, --OK
                    DECODE(DATASTATULQCI8TOTBYTE,0,0,
                      CASE WHEN L_DATASTATULQCI8TOTBYTE/DATASTATULQCI8TOTBYTE > 1 THEN -- FIX
                                CASE WHEN ROUND(4294967296/L_DATASTATULQCI8TOTBYTE,0) = 1 THEN
                                          (4294967296 + DATASTATULQCI8TOTBYTE - L_DATASTATULQCI8TOTBYTE)
                                     ELSE -1 END
                           ELSE (DATASTATULQCI8TOTBYTE - L_DATASTATULQCI8TOTBYTE)  END ) AS DATASTATULQCI8TOTBYTE, --OK
                    DECODE(DATASTATULQCI9TOTBYTE,0,0,
                      CASE WHEN L_DATASTATULQCI9TOTBYTE/DATASTATULQCI9TOTBYTE > 1 THEN -- FIX
                                CASE WHEN ROUND(4294967296/L_DATASTATULQCI9TOTBYTE,0) = 1 THEN
                                          (4294967296 + DATASTATULQCI9TOTBYTE - L_DATASTATULQCI9TOTBYTE)
                                     ELSE -1 END
                           ELSE (DATASTATULQCI9TOTBYTE - L_DATASTATULQCI9TOTBYTE)  END ) AS DATASTATULQCI9TOTBYTE --OK
            FROM (
              SELECT  FECHA, FILENAME, ORDEN, SCHEMANAME, GWNAME, SERVID, SERVNAME,
                        NVL(DATASTATULQCI1TOTBYTE, 0) AS DATASTATULQCI1TOTBYTE,
                          NVL(LEAD (  DATASTATULQCI1TOTBYTE  , 1) OVER (PARTITION BY
                                                          GWNAME ,
                                                          SERVID,
                                                          SERVNAME
                                                          ORDER BY FECHA DESC), 0) AS L_DATASTATULQCI1TOTBYTE,
                        NVL(DATASTATULQCI2TOTBYTE, 0) AS DATASTATULQCI2TOTBYTE,
                         NVL(LEAD (  DATASTATULQCI2TOTBYTE  , 1) OVER (PARTITION BY
                                                          GWNAME ,
                                                          SERVID,
                                                          SERVNAME
                                                          ORDER BY FECHA DESC), 0) AS L_DATASTATULQCI2TOTBYTE,
                        NVL(DATASTATULQCI3TOTBYTE, 0) AS DATASTATULQCI3TOTBYTE,
                         NVL(LEAD (  DATASTATULQCI3TOTBYTE  , 1) OVER (PARTITION BY
                                                          GWNAME ,
                                                          SERVID,
                                                          SERVNAME
                                                          ORDER BY FECHA DESC), 0) AS L_DATASTATULQCI3TOTBYTE,
                        NVL(DATASTATULQCI4TOTBYTE, 0) AS DATASTATULQCI4TOTBYTE,
                         NVL(LEAD (  DATASTATULQCI4TOTBYTE  , 1) OVER (PARTITION BY
                                                          GWNAME ,
                                                          SERVID,
                                                          SERVNAME
                                                          ORDER BY FECHA DESC), 0) AS L_DATASTATULQCI4TOTBYTE,
                        NVL(DATASTATULQCI5TOTBYTE, 0) AS DATASTATULQCI5TOTBYTE,
                         NVL(LEAD (  DATASTATULQCI5TOTBYTE  , 1) OVER (PARTITION BY
                                                          GWNAME ,
                                                          SERVID,
                                                          SERVNAME
                                                          ORDER BY FECHA DESC), 0) AS L_DATASTATULQCI5TOTBYTE,
                        NVL(DATASTATULQCI6TOTBYTE, 0) AS DATASTATULQCI6TOTBYTE,
                         NVL(LEAD (  DATASTATULQCI6TOTBYTE  , 1) OVER (PARTITION BY
                                                          GWNAME ,
                                                          SERVID,
                                                          SERVNAME
                                                          ORDER BY FECHA DESC), 0) AS L_DATASTATULQCI6TOTBYTE,
                        NVL(DATASTATULQCI7TOTBYTE, 0) AS DATASTATULQCI7TOTBYTE,
                         NVL(LEAD (  DATASTATULQCI7TOTBYTE  , 1) OVER (PARTITION BY
                                                          GWNAME ,
                                                          SERVID,
                                                          SERVNAME
                                                          ORDER BY FECHA DESC), 0) AS L_DATASTATULQCI7TOTBYTE,
                        NVL(DATASTATULQCI8TOTBYTE, 0) AS DATASTATULQCI8TOTBYTE,
                         NVL(LEAD (  DATASTATULQCI8TOTBYTE  , 1) OVER (PARTITION BY
                                                          GWNAME ,
                                                          SERVID,
                                                          SERVNAME
                                                          ORDER BY FECHA DESC), 0) AS L_DATASTATULQCI8TOTBYTE,
                        NVL(DATASTATULQCI9TOTBYTE, 0) AS DATASTATULQCI9TOTBYTE,
                         NVL(LEAD (  DATASTATULQCI9TOTBYTE  , 1) OVER (PARTITION BY
                                                          GWNAME ,
                                                          SERVID,
                                                          SERVNAME
                                                          ORDER BY FECHA DESC), 0) AS L_DATASTATULQCI9TOTBYTE
                  FROM CORE_CISCO_SGW2_GGSN
                   WHERE FECHA BETWEEN  TO_DATE(P_FECHA_DESDE, 'DD.MM.YYYY HH24')
                                 AND TO_DATE(P_FECHA_HASTA, 'DD.MM.YYYY HH24') + (86399 / 86400)
              )
        )
        WHERE SEQNUM > 1
        AND DATASTATULQCI1TOTBYTE != -1
        AND DATASTATULQCI2TOTBYTE != -1
        AND DATASTATULQCI3TOTBYTE != -1
        AND DATASTATULQCI4TOTBYTE != -1
        AND DATASTATULQCI5TOTBYTE != -1
        AND DATASTATULQCI6TOTBYTE != -1
        AND DATASTATULQCI7TOTBYTE != -1
        AND DATASTATULQCI8TOTBYTE != -1
        AND DATASTATULQCI9TOTBYTE != -1
      ) O
ON (O.FECHA = D.FECHA
    AND O.GWNAME = D.GWNAME
    AND O.SERVNAME = D.SERVNAME
    AND O.schemaname = D.schemaname
    AND O.servid = D.servid )
  WHEN MATCHED THEN UPDATE SET D.UPLINK_THROUGHPUT = O.UPLINK_THROUGHPUT
  WHEN NOT MATCHED THEN INSERT (
                               D.FECHA                      ,
                               D.FILENAME                   ,
                               D.ORDEN                   ,
                               D.SCHEMANAME ,
                               D.GWNAME   ,
                               D.SERVID   ,
                               D.SERVNAME ,
                               D.UPLINK_THROUGHPUT
                               )
                        VALUES (
                               O.FECHA                      ,
                               O.FILENAME                   ,
                               O.ORDEN                   ,
                               O.SCHEMANAME ,
                               O.GWNAME   ,
                               O.SERVID   ,
                               O.SERVNAME ,
                               O.UPLINK_THROUGHPUT
                               );

COMMIT;
END;

/
