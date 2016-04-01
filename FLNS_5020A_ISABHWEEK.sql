--------------------------------------------------------
--  DDL for View FLNS_5020A_ISABHWEEK
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."FLNS_5020A_ISABHWEEK" ("FECHA", "PERIOD_DURATION", "FINS_ID", "MME_NAME", "TA_ID", "FLNS_5020A") AS 
  SELECT TRUNC(hist.FECHA , 'DAY') AS FECHA, hist.PERIOD_DURATION, hist.FINS_ID, hist.MME_NAME, hist.TA_ID,
    ROUND(AVG(hist.FLNS_5020A),2 ) AS FLNS_5020A
FROM(
      SELECT TRUNC(FECHA, 'HH24') AS FECHA, PERIOD_DURATION, FINS_ID, MME_NAME,TA_ID,
        ROUND ((DECODE (SUM(EPS_DEF_BEARER_ACT_FAIL), 0 ,0, SUM(EPS_DEF_BEARER_ACT_SUCC) / SUM(EPS_DEF_BEARER_ACT_FAIL) ) ) * 100, 2) AS FLNS_5020A
      FROM FLNS_5020A_HISTORICAL
      GROUP BY TRUNC(FECHA, 'HH24') , PERIOD_DURATION, FINS_ID, TA_ID, MME_NAME
    ) hist
INNER JOIN (
           SELECT FECHA, FINS_ID, MME_NAME,TA_ID, PERIOD_DURATION, SEQNUM
           FROM (
                  SELECT TRUNC(FECHA , 'DAY') AS FECHA, FINS_ID, TA_ID, PERIOD_DURATION,MME_NAME, ROW_NUMBER()
                        OVER (
                          PARTITION BY TRUNC(FECHA , 'DAY'), FINS_ID, MME_NAME,TA_ID, PERIOD_DURATION
                          ORDER BY VALOR DESC) SEQNUM
                  FROM PCOFNS_PS_SMMT_TA_BH_AUX
                  )
           WHERE SEQNUM < 4
        ) bh
ON bh.FECHA = hist.FECHA
AND bh.FINS_ID = hist.FINS_ID
AND bh.MME_NAME = hist.MME_NAME
AND bh.TA_ID = hist.TA_ID
AND bh.PERIOD_DURATION = hist.PERIOD_DURATION
GROUP BY TRUNC(hist.FECHA , 'DAY'), hist.PERIOD_DURATION, hist.FINS_ID, hist.MME_NAME, hist.TA_ID
;
