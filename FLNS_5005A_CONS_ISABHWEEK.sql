--------------------------------------------------------
--  DDL for View FLNS_5005A_CONS_ISABHWEEK
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."FLNS_5005A_CONS_ISABHWEEK" ("FECHA", "PERIOD_DURATION", "FINS_ID", "MME_NAME", "FLNS_5005A") AS 
  SELECT TRUNC(hist.FECHA , 'DAY') AS FECHA, hist.PERIOD_DURATION, hist.FINS_ID, hist.MME_NAME,
    ROUND(AVG(hist.FLNS_5005A),2 ) AS FLNS_5005A
FROM(
      SELECT TRUNC(FECHA, 'HH24') AS FECHA, PERIOD_DURATION, FINS_ID, MME_NAME,
        ROUND ((DECODE (SUM(EPS_PERIODIC_TAU_FAIL), 0 ,0, SUM(EPS_PERIODIC_TAU_SUCC) / SUM(EPS_PERIODIC_TAU_FAIL) ) ) * 100, 2) AS FLNS_5005A
      FROM FLNS_5005A_HISTORICAL
      GROUP BY TRUNC(FECHA, 'HH24') , PERIOD_DURATION, FINS_ID, MME_NAME
    ) hist
INNER JOIN (
           SELECT FECHA, FINS_ID, MME_NAME, PERIOD_DURATION, SEQNUM
           FROM (
                  SELECT TRUNC(FECHA , 'DAY') AS FECHA, FINS_ID, PERIOD_DURATION,MME_NAME, ROW_NUMBER()
                        OVER (
                          PARTITION BY TRUNC(FECHA , 'DAY'), FINS_ID, MME_NAME, PERIOD_DURATION
                          ORDER BY VALOR DESC) SEQNUM
                  FROM PCOFNS_PS_MMMT_TA_CONS_BH_AUX
                  )
           WHERE SEQNUM < 4
        ) bh
ON bh.FECHA = hist.FECHA
AND bh.FINS_ID = hist.FINS_ID
AND bh.MME_NAME = hist.MME_NAME
AND bh.PERIOD_DURATION = hist.PERIOD_DURATION
GROUP BY TRUNC(hist.FECHA , 'DAY'), hist.PERIOD_DURATION, hist.FINS_ID, hist.MME_NAME
;
