--------------------------------------------------------
--  DDL for View FLNS_5008A_ISABHMONTH
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."FLNS_5008A_ISABHMONTH" ("FECHA", "PERIOD_DURATION", "FINS_ID", "MME_NAME", "TA_ID", "FLNS_5008A") AS 
  SELECT TRUNC(hist.FECHA , 'MONTH') AS FECHA, hist.PERIOD_DURATION, hist.FINS_ID, hist.MME_NAME, hist.TA_ID,
    ROUND(AVG(hist.FLNS_5008A),2 ) AS FLNS_5008A
FROM(
      SELECT TRUNC(FECHA, 'HH24') AS FECHA, PERIOD_DURATION, FINS_ID, MME_NAME,TA_ID,
        ROUND ((DECODE (SUM(EPS_TAU_FAIL), 0 ,0, SUM(EPS_TAU_SUCC) / SUM(EPS_TAU_FAIL) ) ) * 100, 2) AS FLNS_5008A
      FROM FLNS_5008A_HISTORICAL
      GROUP BY TRUNC(FECHA, 'HH24') , PERIOD_DURATION, FINS_ID, TA_ID, MME_NAME
    ) hist
INNER JOIN (
           SELECT FECHA, FINS_ID, MME_NAME,TA_ID, PERIOD_DURATION, SEQNUM
           FROM (
                  SELECT TRUNC(FECHA , 'MONTH') AS FECHA, FINS_ID, TA_ID, PERIOD_DURATION,MME_NAME, ROW_NUMBER()
                        OVER (
                          PARTITION BY TRUNC(FECHA , 'MONTH'), FINS_ID, MME_NAME,TA_ID, PERIOD_DURATION
                          ORDER BY VALOR DESC) SEQNUM
                  FROM PCOFNS_PS_MMMT_TA_BH_AUX
                  )
           WHERE SEQNUM < 4
        ) bh
ON bh.FECHA = hist.FECHA
AND bh.FINS_ID = hist.FINS_ID
AND bh.MME_NAME = hist.MME_NAME
AND bh.TA_ID = hist.TA_ID
AND bh.PERIOD_DURATION = hist.PERIOD_DURATION
GROUP BY TRUNC(hist.FECHA , 'MONTH'), hist.PERIOD_DURATION, hist.FINS_ID, hist.MME_NAME, hist.TA_ID
;
