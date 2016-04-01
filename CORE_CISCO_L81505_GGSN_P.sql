--------------------------------------------------------
--  DDL for Procedure CORE_CISCO_L81505_GGSN_P
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HARRIAGUE"."CORE_CISCO_L81505_GGSN_P" (P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR)
IS

BEGIN
  MERGE INTO CORE_CISCO_L81505_GGSN_HIST D
  USING (
          SELECT FECHA, FILENAME, ORDEN, SCHEMANAME, GWNAME, SERVID, SERVNAME,
               ROUND( ( UPLINK_THP_MBPS *8 / ( 15 * 60 )/ 1024 / 1024 ) ,2) AS UPLINK_THP_MBPS
          FROM(
              SELECT FECHA, FILENAME, ORDEN, SCHEMANAME, GWNAME, SERVID, SERVNAME,
                      PREV_VALUE,
                      CVALUE,
                      ROW_NUMBER() OVER(PARTITION BY SCHEMANAME, GWNAME, SERVID, SERVNAME
                                                       ORDER BY FECHA ASC
                                                       ) AS SEQNUM,
                      DECODE(CVALUE,0,0,
                      CASE WHEN PREV_VALUE/CVALUE > 1 THEN -- FIX
                                CASE WHEN ROUND(4294967296/PREV_VALUE,0) = 1 THEN
                                          (4294967296 + CVALUE - PREV_VALUE)
                                     ELSE -1 END
                           ELSE (CVALUE - PREV_VALUE)  END ) AS UPLINK_THP_MBPS --OK
              FROM(
                SELECT  FECHA, FILENAME, ORDEN, SCHEMANAME, GWNAME, SERVID, SERVNAME,
                          NVL(SUBDATASTATTOTUPBYTEFWD,0) AS CVALUE,
                          NVL(LEAD (  SUBDATASTATTOTUPBYTEFWD  , 1) OVER (PARTITION BY
                                                            GWNAME ,
                                                            SERVID,
                                                            SERVNAME
                                                            ORDER BY FECHA DESC), 0) AS PREV_VALUE
                    FROM CORE_CISCO_PGW4_GGSN
                     WHERE FECHA BETWEEN  TO_DATE(P_FECHA_DESDE, 'DD.MM.YYYY HH24')
                                   AND TO_DATE(P_FECHA_HASTA, 'DD.MM.YYYY HH24') + (86399 / 86400)
              )
          )
          WHERE SEQNUM > 1
          AND UPLINK_THP_MBPS != -1
        ) O
ON (O.FECHA = D.FECHA
    AND O.GWNAME = D.GWNAME
    AND O.SERVNAME = D.SERVNAME
    AND O.SCHEMANAME = D.SCHEMANAME
    AND O.SERVID = D.SERVID )
  WHEN MATCHED THEN UPDATE SET D.UPLINK_THP_MBPS = O.UPLINK_THP_MBPS
  WHEN NOT MATCHED THEN INSERT (
                               D.FECHA                      ,
                               D.FILENAME                   ,
                               D.ORDEN                   ,
                               D.SCHEMANAME ,
                               D.GWNAME   ,
                               D.SERVID   ,
                               D.SERVNAME ,
                               D.UPLINK_THP_MBPS
                               )
                        VALUES (
                               O.FECHA                      ,
                               O.FILENAME                   ,
                               O.ORDEN                   ,
                               O.SCHEMANAME ,
                               O.GWNAME   ,
                               O.SERVID   ,
                               O.SERVNAME ,
                               O.UPLINK_THP_MBPS
                               );

COMMIT;
END;

/
