--------------------------------------------------------
--  DDL for Procedure CORE_CISCO_L71302_GGSN_P
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HARRIAGUE"."CORE_CISCO_L71302_GGSN_P" (P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR)
IS

BEGIN
  MERGE INTO CORE_CISCO_L71302_GGSN_HIST D
  USING (
        SELECT FECHA, FILENAME, ORDEN, SCHEMANAME, GWNAME, SERVID, SERVNAME,
               ROUND( (
                  ULDROPSTATQCI1TOTPKT+
                  ULDROPSTATQCI2TOTPKT+
                  ULDROPSTATQCI3TOTPKT+
                  ULDROPSTATQCI4TOTPKT+
                  ULDROPSTATQCI5TOTPKT+
                  ULDROPSTATQCI6TOTPKT+
                  ULDROPSTATQCI7TOTPKT+
                  ULDROPSTATQCI8TOTPKT+
                  ULDROPSTATQCI9TOTPKT+
                  ULDROPSTATOTHERTOTPKT
                ) ,2) AS UPLINK_DROPPED
        FROM(
            SELECT FECHA, FILENAME, ORDEN, SCHEMANAME, GWNAME, SERVID, SERVNAME,
                    ROW_NUMBER() OVER(PARTITION BY SCHEMANAME, GWNAME, SERVID, SERVNAME
                                                     ORDER BY FECHA ASC
                                                     ) AS SEQNUM,
                    DECODE(ULDROPSTATQCI1TOTPKT,0,0,
                    CASE WHEN L_ULDROPSTATQCI1TOTPKT/ULDROPSTATQCI1TOTPKT > 1 THEN -- FIX
                              CASE WHEN ROUND(4294967296/L_ULDROPSTATQCI1TOTPKT,0) = 1 THEN
                                        (4294967296 + ULDROPSTATQCI1TOTPKT - L_ULDROPSTATQCI1TOTPKT)
                                   ELSE -1 END
                         ELSE (ULDROPSTATQCI1TOTPKT - L_ULDROPSTATQCI1TOTPKT)  END ) AS ULDROPSTATQCI1TOTPKT, --OK
                    DECODE(ULDROPSTATQCI2TOTPKT,0,0,
                    CASE WHEN L_ULDROPSTATQCI2TOTPKT/ULDROPSTATQCI2TOTPKT > 1 THEN -- FIX
                              CASE WHEN ROUND(4294967296/L_ULDROPSTATQCI2TOTPKT,0) = 1 THEN
                                        (4294967296 + ULDROPSTATQCI2TOTPKT - L_ULDROPSTATQCI2TOTPKT)
                                   ELSE -1 END
                         ELSE (ULDROPSTATQCI2TOTPKT - L_ULDROPSTATQCI2TOTPKT)  END ) AS ULDROPSTATQCI2TOTPKT, --OK
                    DECODE(ULDROPSTATQCI3TOTPKT,0,0,
                      CASE WHEN L_ULDROPSTATQCI3TOTPKT/ULDROPSTATQCI3TOTPKT > 1 THEN -- FIX
                                CASE WHEN ROUND(4294967296/L_ULDROPSTATQCI3TOTPKT,0) = 1 THEN
                                          (4294967296 + ULDROPSTATQCI3TOTPKT - L_ULDROPSTATQCI3TOTPKT)
                                     ELSE -1 END
                           ELSE (ULDROPSTATQCI3TOTPKT - L_ULDROPSTATQCI3TOTPKT)  END ) AS ULDROPSTATQCI3TOTPKT, --OK
                    DECODE(ULDROPSTATQCI4TOTPKT,0,0,
                      CASE WHEN L_ULDROPSTATQCI4TOTPKT/ULDROPSTATQCI4TOTPKT > 1 THEN -- FIX
                                CASE WHEN ROUND(4294967296/L_ULDROPSTATQCI4TOTPKT,0) = 1 THEN
                                          (4294967296 + ULDROPSTATQCI4TOTPKT - L_ULDROPSTATQCI4TOTPKT)
                                     ELSE -1 END
                           ELSE (ULDROPSTATQCI4TOTPKT - L_ULDROPSTATQCI4TOTPKT)  END ) AS ULDROPSTATQCI4TOTPKT, --OK
                    DECODE(ULDROPSTATQCI5TOTPKT,0,0,
                      CASE WHEN L_ULDROPSTATQCI5TOTPKT/ULDROPSTATQCI5TOTPKT > 1 THEN -- FIX
                                CASE WHEN ROUND(4294967296/L_ULDROPSTATQCI5TOTPKT,0) = 1 THEN
                                          (4294967296 + ULDROPSTATQCI5TOTPKT - L_ULDROPSTATQCI5TOTPKT)
                                     ELSE -1 END
                           ELSE (ULDROPSTATQCI5TOTPKT - L_ULDROPSTATQCI5TOTPKT)  END ) AS ULDROPSTATQCI5TOTPKT, --OK
                    DECODE(ULDROPSTATQCI6TOTPKT,0,0,
                      CASE WHEN L_ULDROPSTATQCI6TOTPKT/ULDROPSTATQCI6TOTPKT > 1 THEN -- FIX
                                CASE WHEN ROUND(4294967296/L_ULDROPSTATQCI6TOTPKT,0) = 1 THEN
                                          (4294967296 + ULDROPSTATQCI6TOTPKT - L_ULDROPSTATQCI6TOTPKT)
                                     ELSE -1 END
                           ELSE (ULDROPSTATQCI6TOTPKT - L_ULDROPSTATQCI6TOTPKT)  END ) AS ULDROPSTATQCI6TOTPKT, --OK
                    DECODE(ULDROPSTATQCI7TOTPKT,0,0,
                      CASE WHEN L_ULDROPSTATQCI7TOTPKT/ULDROPSTATQCI7TOTPKT > 1 THEN -- FIX
                                CASE WHEN ROUND(4294967296/L_ULDROPSTATQCI7TOTPKT,0) = 1 THEN
                                          (4294967296 + ULDROPSTATQCI7TOTPKT - L_ULDROPSTATQCI7TOTPKT)
                                     ELSE -1 END
                           ELSE (ULDROPSTATQCI7TOTPKT - L_ULDROPSTATQCI7TOTPKT)  END ) AS ULDROPSTATQCI7TOTPKT, --OK
                    DECODE(ULDROPSTATQCI8TOTPKT,0,0,
                      CASE WHEN L_ULDROPSTATQCI8TOTPKT/ULDROPSTATQCI8TOTPKT > 1 THEN -- FIX
                                CASE WHEN ROUND(4294967296/L_ULDROPSTATQCI8TOTPKT,0) = 1 THEN
                                          (4294967296 + ULDROPSTATQCI8TOTPKT - L_ULDROPSTATQCI8TOTPKT)
                                     ELSE -1 END
                           ELSE (ULDROPSTATQCI8TOTPKT - L_ULDROPSTATQCI8TOTPKT)  END ) AS ULDROPSTATQCI8TOTPKT, --OK
                    DECODE(ULDROPSTATQCI9TOTPKT,0,0,
                      CASE WHEN L_ULDROPSTATQCI9TOTPKT/ULDROPSTATQCI9TOTPKT > 1 THEN -- FIX
                                CASE WHEN ROUND(4294967296/L_ULDROPSTATQCI9TOTPKT,0) = 1 THEN
                                          (4294967296 + ULDROPSTATQCI9TOTPKT - L_ULDROPSTATQCI9TOTPKT)
                                     ELSE -1 END
                           ELSE (ULDROPSTATQCI9TOTPKT - L_ULDROPSTATQCI9TOTPKT)  END ) AS ULDROPSTATQCI9TOTPKT, --OK
                    DECODE(ULDROPSTATOTHERTOTPKT,0,0,
                      CASE WHEN L_ULDROPSTATOTHERTOTPKT/ULDROPSTATOTHERTOTPKT > 1 THEN -- FIX
                                CASE WHEN ROUND(4294967296/L_ULDROPSTATOTHERTOTPKT,0) = 1 THEN
                                          (4294967296 + ULDROPSTATOTHERTOTPKT - L_ULDROPSTATOTHERTOTPKT)
                                     ELSE -1 END
                           ELSE (ULDROPSTATOTHERTOTPKT - L_ULDROPSTATOTHERTOTPKT)  END ) AS ULDROPSTATOTHERTOTPKT --OK
            FROM (
              SELECT  FECHA, FILENAME, ORDEN, SCHEMANAME, GWNAME, SERVID, SERVNAME,
                        NVL(DATASTATULDROPSTATQCI1TOTPKT, 0)  AS ULDROPSTATQCI1TOTPKT,
                         NVL(LEAD (  DATASTATULDROPSTATQCI1TOTPKT  , 1) OVER (PARTITION BY
                                                          GWNAME ,
                                                          SERVID,
                                                          SERVNAME
                                                          ORDER BY FECHA DESC), 0) AS L_ULDROPSTATQCI1TOTPKT,
                        NVL(DATASTATULDROPSTATQCI2TOTPKT, 0) AS ULDROPSTATQCI2TOTPKT,
                         NVL(LEAD (  DATASTATULDROPSTATQCI2TOTPKT  , 1) OVER (PARTITION BY
                                                          GWNAME ,
                                                          SERVID,
                                                          SERVNAME
                                                          ORDER BY FECHA DESC), 0) AS L_ULDROPSTATQCI2TOTPKT,
                        NVL(DATASTATULDROPSTATQCI3TOTPKT, 0) AS ULDROPSTATQCI3TOTPKT,
                         NVL(LEAD (  DATASTATULDROPSTATQCI3TOTPKT  , 1) OVER (PARTITION BY
                                                          GWNAME ,
                                                          SERVID,
                                                          SERVNAME
                                                          ORDER BY FECHA DESC), 0) AS L_ULDROPSTATQCI3TOTPKT,
                        NVL(DATASTATULDROPSTATQCI4TOTPKT, 0) AS ULDROPSTATQCI4TOTPKT,
                         NVL(LEAD (  DATASTATULDROPSTATQCI4TOTPKT  , 1) OVER (PARTITION BY
                                                          GWNAME ,
                                                          SERVID,
                                                          SERVNAME
                                                          ORDER BY FECHA DESC), 0) AS L_ULDROPSTATQCI4TOTPKT,
                        NVL(DATASTATULDROPSTATQCI5TOTPKT, 0) AS ULDROPSTATQCI5TOTPKT,
                         NVL(LEAD (  DATASTATULDROPSTATQCI5TOTPKT  , 1) OVER (PARTITION BY
                                                          GWNAME ,
                                                          SERVID,
                                                          SERVNAME
                                                          ORDER BY FECHA DESC), 0) AS L_ULDROPSTATQCI5TOTPKT,
                        NVL(DATASTATULDROPSTATQCI6TOTPKT, 0) AS ULDROPSTATQCI6TOTPKT,
                         NVL(LEAD (  DATASTATULDROPSTATQCI6TOTPKT  , 1) OVER (PARTITION BY
                                                          GWNAME ,
                                                          SERVID,
                                                          SERVNAME
                                                          ORDER BY FECHA DESC), 0) AS L_ULDROPSTATQCI6TOTPKT,
                        NVL(DATASTATULDROPSTATQCI7TOTPKT, 0) AS ULDROPSTATQCI7TOTPKT,
                         NVL(LEAD (  DATASTATULDROPSTATQCI7TOTPKT  , 1) OVER (PARTITION BY
                                                          GWNAME ,
                                                          SERVID,
                                                          SERVNAME
                                                          ORDER BY FECHA DESC), 0) AS L_ULDROPSTATQCI7TOTPKT,
                        NVL(DATASTATULDROPSTATQCI8TOTPKT, 0) AS ULDROPSTATQCI8TOTPKT,
                         NVL(LEAD (  DATASTATULDROPSTATQCI8TOTPKT  , 1) OVER (PARTITION BY
                                                          GWNAME ,
                                                          SERVID,
                                                          SERVNAME
                                                          ORDER BY FECHA DESC), 0) AS L_ULDROPSTATQCI8TOTPKT,
                        NVL(DATASTATULDROPSTATQCI9TOTPKT, 0) AS ULDROPSTATQCI9TOTPKT,
                         NVL(LEAD (  DATASTATULDROPSTATQCI9TOTPKT  , 1) OVER (PARTITION BY
                                                          GWNAME ,
                                                          SERVID,
                                                          SERVNAME
                                                          ORDER BY FECHA DESC), 0) AS L_ULDROPSTATQCI9TOTPKT,
                        NVL(DATASTATULDROPSTATOTHERTOTPKT, 0) AS ULDROPSTATOTHERTOTPKT,
                         NVL(LEAD (  DATASTATULDROPSTATOTHERTOTPKT  , 1) OVER (PARTITION BY
                                                          GWNAME ,
                                                          SERVID,
                                                          SERVNAME
                                                          ORDER BY FECHA DESC), 0) AS L_ULDROPSTATOTHERTOTPKT
                  FROM CORE_CISCO_SGW2_GGSN
                   WHERE FECHA BETWEEN  TO_DATE(P_FECHA_DESDE, 'DD.MM.YYYY HH24')
                                 AND TO_DATE(P_FECHA_HASTA, 'DD.MM.YYYY HH24') + (86399 / 86400)
              )
        )
        WHERE SEQNUM > 1
        AND ULDROPSTATQCI1TOTPKT != -1
        AND ULDROPSTATQCI2TOTPKT != -1
        AND ULDROPSTATQCI3TOTPKT != -1
        AND ULDROPSTATQCI4TOTPKT != -1
        AND ULDROPSTATQCI5TOTPKT != -1
        AND ULDROPSTATQCI6TOTPKT != -1
        AND ULDROPSTATQCI7TOTPKT != -1
        AND ULDROPSTATQCI8TOTPKT != -1
        AND ULDROPSTATQCI9TOTPKT != -1
        AND ULDROPSTATOTHERTOTPKT != -1

        ) O
ON (O.FECHA = D.FECHA
    AND O.GWNAME = D.GWNAME
    AND O.SERVNAME = D.SERVNAME
    AND O.schemaname = D.schemaname
    AND O.servid = D.servid )
  WHEN MATCHED THEN UPDATE SET D.UPLINK_DROPPED = O.UPLINK_DROPPED
  WHEN NOT MATCHED THEN INSERT (
                               D.FECHA                      ,
                               D.FILENAME                   ,
                               D.ORDEN                   ,
                               D.SCHEMANAME ,
                               D.GWNAME   ,
                               D.SERVID   ,
                               D.SERVNAME ,
                               D.UPLINK_DROPPED
                               )
                        VALUES (
                               O.FECHA                      ,
                               O.FILENAME                   ,
                               O.ORDEN                   ,
                               O.SCHEMANAME ,
                               O.GWNAME   ,
                               O.SERVID   ,
                               O.SERVNAME ,
                               O.UPLINK_DROPPED
                               );

COMMIT;
END;

/
