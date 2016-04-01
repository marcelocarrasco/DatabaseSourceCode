--------------------------------------------------------
--  DDL for Procedure CORE_CISCO_L71304_GGSN_P
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HARRIAGUE"."CORE_CISCO_L71304_GGSN_P" (P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR)
IS
BEGIN
  MERGE INTO CORE_CISCO_L71304_GGSN_HIST D
  USING (
      SELECT FECHA, FILENAME, ORDEN, SCHEMANAME, GWNAME, SERVID, SERVNAME,
               ROUND( (
                  DLDROPSTATQCI1TOTPKT+
                  DLDROPSTATQCI2TOTPKT+
                  DLDROPSTATQCI3TOTPKT+
                  DLDROPSTATQCI4TOTPKT+
                  DLDROPSTATQCI5TOTPKT+
                  DLDROPSTATQCI6TOTPKT+
                  DLDROPSTATQCI7TOTPKT+
                  DLDROPSTATQCI8TOTPKT+
                  DLDROPSTATQCI9TOTPKT+
                  DLOTHERTOTPKT
                ) ,2) AS DOWNLINK_DROPPED
        FROM(
            SELECT FECHA, FILENAME, ORDEN, SCHEMANAME, GWNAME, SERVID, SERVNAME,
                    ROW_NUMBER() OVER(PARTITION BY SCHEMANAME, GWNAME, SERVID, SERVNAME
                                                     ORDER BY FECHA ASC
                                                     ) AS SEQNUM,
                    DECODE(DLDROPSTATQCI1TOTPKT,0,0,
                    CASE WHEN L_DLDROPSTATQCI1TOTPKT/DLDROPSTATQCI1TOTPKT > 1 THEN -- FIX
                              CASE WHEN ROUND(4294967296/L_DLDROPSTATQCI1TOTPKT,0) = 1 THEN
                                        (4294967296 + DLDROPSTATQCI1TOTPKT - L_DLDROPSTATQCI1TOTPKT)
                                   ELSE -1 END
                         ELSE (DLDROPSTATQCI1TOTPKT - L_DLDROPSTATQCI1TOTPKT)  END ) AS DLDROPSTATQCI1TOTPKT, --OK
                    DECODE(DLDROPSTATQCI2TOTPKT,0,0,
                    CASE WHEN L_DLDROPSTATQCI2TOTPKT/DLDROPSTATQCI2TOTPKT > 1 THEN -- FIX
                              CASE WHEN ROUND(4294967296/L_DLDROPSTATQCI2TOTPKT,0) = 1 THEN
                                        (4294967296 + DLDROPSTATQCI2TOTPKT - L_DLDROPSTATQCI2TOTPKT)
                                   ELSE -1 END
                         ELSE (DLDROPSTATQCI2TOTPKT - L_DLDROPSTATQCI2TOTPKT)  END ) AS DLDROPSTATQCI2TOTPKT, --OK
                    DECODE(DLDROPSTATQCI3TOTPKT,0,0,
                      CASE WHEN L_DLDROPSTATQCI3TOTPKT/DLDROPSTATQCI3TOTPKT > 1 THEN -- FIX
                                CASE WHEN ROUND(4294967296/L_DLDROPSTATQCI3TOTPKT,0) = 1 THEN
                                          (4294967296 + DLDROPSTATQCI3TOTPKT - L_DLDROPSTATQCI3TOTPKT)
                                     ELSE -1 END
                           ELSE (DLDROPSTATQCI3TOTPKT - L_DLDROPSTATQCI3TOTPKT)  END ) AS DLDROPSTATQCI3TOTPKT, --OK
                    DECODE(DLDROPSTATQCI4TOTPKT,0,0,
                      CASE WHEN L_DLDROPSTATQCI4TOTPKT/DLDROPSTATQCI4TOTPKT > 1 THEN -- FIX
                                CASE WHEN ROUND(4294967296/L_DLDROPSTATQCI4TOTPKT,0) = 1 THEN
                                          (4294967296 + DLDROPSTATQCI4TOTPKT - L_DLDROPSTATQCI4TOTPKT)
                                     ELSE -1 END
                           ELSE (DLDROPSTATQCI4TOTPKT - L_DLDROPSTATQCI4TOTPKT)  END ) AS DLDROPSTATQCI4TOTPKT, --OK
                    DECODE(DLDROPSTATQCI5TOTPKT,0,0,
                      CASE WHEN L_DLDROPSTATQCI5TOTPKT/DLDROPSTATQCI5TOTPKT > 1 THEN -- FIX
                                CASE WHEN ROUND(4294967296/L_DLDROPSTATQCI5TOTPKT,0) = 1 THEN
                                          (4294967296 + DLDROPSTATQCI5TOTPKT - L_DLDROPSTATQCI5TOTPKT)
                                     ELSE -1 END
                           ELSE (DLDROPSTATQCI5TOTPKT - L_DLDROPSTATQCI5TOTPKT)  END ) AS DLDROPSTATQCI5TOTPKT, --OK
                    DECODE(DLDROPSTATQCI6TOTPKT,0,0,
                      CASE WHEN L_DLDROPSTATQCI6TOTPKT/DLDROPSTATQCI6TOTPKT > 1 THEN -- FIX
                                CASE WHEN ROUND(4294967296/L_DLDROPSTATQCI6TOTPKT,0) = 1 THEN
                                          (4294967296 + DLDROPSTATQCI6TOTPKT - L_DLDROPSTATQCI6TOTPKT)
                                     ELSE -1 END
                           ELSE (DLDROPSTATQCI6TOTPKT - L_DLDROPSTATQCI6TOTPKT)  END ) AS DLDROPSTATQCI6TOTPKT, --OK
                    DECODE(DLDROPSTATQCI7TOTPKT,0,0,
                      CASE WHEN L_DLDROPSTATQCI7TOTPKT/DLDROPSTATQCI7TOTPKT > 1 THEN -- FIX
                                CASE WHEN ROUND(4294967296/L_DLDROPSTATQCI7TOTPKT,0) = 1 THEN
                                          (4294967296 + DLDROPSTATQCI7TOTPKT - L_DLDROPSTATQCI7TOTPKT)
                                     ELSE -1 END
                           ELSE (DLDROPSTATQCI7TOTPKT - L_DLDROPSTATQCI7TOTPKT)  END ) AS DLDROPSTATQCI7TOTPKT, --OK
                    DECODE(DLDROPSTATQCI8TOTPKT,0,0,
                      CASE WHEN L_DLDROPSTATQCI8TOTPKT/DLDROPSTATQCI8TOTPKT > 1 THEN -- FIX
                                CASE WHEN ROUND(4294967296/L_DLDROPSTATQCI8TOTPKT,0) = 1 THEN
                                          (4294967296 + DLDROPSTATQCI8TOTPKT - L_DLDROPSTATQCI8TOTPKT)
                                     ELSE -1 END
                           ELSE (DLDROPSTATQCI8TOTPKT - L_DLDROPSTATQCI8TOTPKT)  END ) AS DLDROPSTATQCI8TOTPKT, --OK
                    DECODE(DLDROPSTATQCI9TOTPKT,0,0,
                      CASE WHEN L_DLDROPSTATQCI9TOTPKT/DLDROPSTATQCI9TOTPKT > 1 THEN -- FIX
                                CASE WHEN ROUND(4294967296/L_DLDROPSTATQCI9TOTPKT,0) = 1 THEN
                                          (4294967296 + DLDROPSTATQCI9TOTPKT - L_DLDROPSTATQCI9TOTPKT)
                                     ELSE -1 END
                           ELSE (DLDROPSTATQCI9TOTPKT - L_DLDROPSTATQCI9TOTPKT)  END ) AS DLDROPSTATQCI9TOTPKT, --OK
                    DECODE(DLOTHERTOTPKT,0,0,
                      CASE WHEN L_DLOTHERTOTPKT/DLOTHERTOTPKT > 1 THEN -- FIX
                                CASE WHEN ROUND(4294967296/L_DLOTHERTOTPKT,0) = 1 THEN
                                          (4294967296 + DLOTHERTOTPKT - L_DLOTHERTOTPKT)
                                     ELSE -1 END
                           ELSE (DLOTHERTOTPKT - L_DLOTHERTOTPKT)  END ) AS DLOTHERTOTPKT --OK
            FROM (
              SELECT  FECHA, FILENAME, ORDEN, SCHEMANAME, GWNAME, SERVID, SERVNAME,
                        NVL(DATASTATDLDROPSTATQCI1TOTPKT, 0) AS DLDROPSTATQCI1TOTPKT,
                         NVL(LAG (  DATASTATDLDROPSTATQCI1TOTPKT  , 1) OVER (PARTITION BY
                                                          GWNAME ,
                                                          SERVID,
                                                          SERVNAME
                                                          ORDER BY FECHA), 0) AS L_DLDROPSTATQCI1TOTPKT,
                        NVL(DATASTATDLDROPSTATQCI2TOTPKT, 0) AS DLDROPSTATQCI2TOTPKT,
                         NVL(LAG (  DATASTATDLDROPSTATQCI2TOTPKT  , 1) OVER (PARTITION BY
                                                          GWNAME ,
                                                          SERVID,
                                                          SERVNAME
                                                          ORDER BY FECHA), 0) AS L_DLDROPSTATQCI2TOTPKT,
                        NVL(DATASTATDLDROPSTATQCI3TOTPKT, 0) AS DLDROPSTATQCI3TOTPKT,
                         NVL(LAG (  DATASTATDLDROPSTATQCI3TOTPKT  , 1) OVER (PARTITION BY
                                                          GWNAME ,
                                                          SERVID,
                                                          SERVNAME
                                                          ORDER BY FECHA), 0) AS L_DLDROPSTATQCI3TOTPKT,
                        NVL(DATASTATDLDROPSTATQCI4TOTPKT, 0) AS DLDROPSTATQCI4TOTPKT,
                         NVL(LAG (  DATASTATDLDROPSTATQCI4TOTPKT  , 1) OVER (PARTITION BY
                                                          GWNAME ,
                                                          SERVID,
                                                          SERVNAME
                                                          ORDER BY FECHA), 0) AS L_DLDROPSTATQCI4TOTPKT,
                        NVL(DATASTATDLDROPSTATQCI5TOTPKT, 0) AS DLDROPSTATQCI5TOTPKT,
                         NVL(LAG (  DATASTATDLDROPSTATQCI5TOTPKT  , 1) OVER (PARTITION BY
                                                          GWNAME ,
                                                          SERVID,
                                                          SERVNAME
                                                          ORDER BY FECHA), 0) AS L_DLDROPSTATQCI5TOTPKT,
                        NVL(DATASTATDLDROPSTATQCI6TOTPKT, 0) AS DLDROPSTATQCI6TOTPKT,
                         NVL(LAG (  DATASTATDLDROPSTATQCI6TOTPKT  , 1) OVER (PARTITION BY
                                                          GWNAME ,
                                                          SERVID,
                                                          SERVNAME
                                                          ORDER BY FECHA), 0) AS L_DLDROPSTATQCI6TOTPKT,
                        NVL(DATASTATDLDROPSTATQCI7TOTPKT, 0) AS DLDROPSTATQCI7TOTPKT,
                         NVL(LAG (  DATASTATDLDROPSTATQCI7TOTPKT  , 1) OVER (PARTITION BY
                                                          GWNAME ,
                                                          SERVID,
                                                          SERVNAME
                                                          ORDER BY FECHA), 0) AS L_DLDROPSTATQCI7TOTPKT,
                        NVL(DATASTATDLDROPSTATQCI8TOTPKT, 0) AS DLDROPSTATQCI8TOTPKT,
                         NVL(LAG (  DATASTATDLDROPSTATQCI8TOTPKT  , 1) OVER (PARTITION BY
                                                          GWNAME ,
                                                          SERVID,
                                                          SERVNAME
                                                          ORDER BY FECHA), 0) AS L_DLDROPSTATQCI8TOTPKT,
                        NVL(DATASTATDLDROPSTATQCI9TOTPKT, 0) AS DLDROPSTATQCI9TOTPKT,
                         NVL(LAG (  DATASTATDLDROPSTATQCI9TOTPKT  , 1) OVER (PARTITION BY
                                                          GWNAME ,
                                                          SERVID,
                                                          SERVNAME
                                                          ORDER BY FECHA), 0) AS L_DLDROPSTATQCI9TOTPKT,
                        NVL(DATASTATDLOTHERTOTPKT, 0) AS DLOTHERTOTPKT,
                         NVL(LAG (  DATASTATDLOTHERTOTPKT  , 1) OVER (PARTITION BY
                                                          GWNAME ,
                                                          SERVID,
                                                          SERVNAME
                                                          ORDER BY FECHA), 0) AS L_DLOTHERTOTPKT
                  FROM CORE_CISCO_SGW3_GGSN
                   WHERE FECHA BETWEEN  TO_DATE(P_FECHA_DESDE, 'DD.MM.YYYY HH24')
                                 AND TO_DATE(P_FECHA_HASTA, 'DD.MM.YYYY HH24') + (86399 / 86400)
              )
        )
        WHERE SEQNUM > 1
        AND DLDROPSTATQCI1TOTPKT != -1
        AND DLDROPSTATQCI2TOTPKT != -1
        AND DLDROPSTATQCI3TOTPKT != -1
        AND DLDROPSTATQCI4TOTPKT != -1
        AND DLDROPSTATQCI5TOTPKT != -1
        AND DLDROPSTATQCI6TOTPKT != -1
        AND DLDROPSTATQCI7TOTPKT != -1
        AND DLDROPSTATQCI8TOTPKT != -1
        AND DLDROPSTATQCI9TOTPKT != -1
        AND DLOTHERTOTPKT != -1
        ) O
ON (O.FECHA = D.FECHA
    AND O.GWNAME = D.GWNAME
    AND O.SERVNAME = D.SERVNAME
    AND O.schemaname = D.schemaname
    AND O.servid = D.servid )
  WHEN MATCHED THEN UPDATE SET D.DOWNLINK_DROPPED = O.DOWNLINK_DROPPED
  WHEN NOT MATCHED THEN INSERT (
                               D.FECHA                      ,
                               D.FILENAME                   ,
                               D.ORDEN                   ,
                               D.SCHEMANAME ,
                               D.GWNAME   ,
                               D.SERVID   ,
                               D.SERVNAME ,
                               D.DOWNLINK_DROPPED
                               )
                        VALUES (
                               O.FECHA                      ,
                               O.FILENAME                   ,
                               O.ORDEN                   ,
                               O.SCHEMANAME ,
                               O.GWNAME   ,
                               O.SERVID   ,
                               O.SERVNAME ,
                               O.DOWNLINK_DROPPED
                               );

COMMIT;
END;

/
