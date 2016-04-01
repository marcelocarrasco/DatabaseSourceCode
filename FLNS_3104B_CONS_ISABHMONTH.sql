--------------------------------------------------------
--  DDL for View FLNS_3104B_CONS_ISABHMONTH
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."FLNS_3104B_CONS_ISABHMONTH" ("FECHA", "PERIOD_DURATION", "FINS_ID", "MME_NAME", "FLNS_3104B") AS 
  SELECT TRUNC(hist.FECHA , 'MONTH') AS FECHA, hist.PERIOD_DURATION, hist.FINS_ID, hist.MME_NAME,
    ROUND(AVG(hist.FLNS_3104B),2 ) AS FLNS_3104B
FROM(
      SELECT TRUNC(FECHA, 'HH24') AS FECHA, PERIOD_DURATION, FINS_ID, MME_NAME,
        ROUND (DECODE (AVG(PERIOD_DURATION*60), 0 ,0, SUM(FLNS_3104B) / AVG(PERIOD_DURATION*60) ) , 2) AS FLNS_3104B
      FROM FLNS_3104B_HISTORICAL
      GROUP BY TRUNC(FECHA, 'HH24') , PERIOD_DURATION, FINS_ID, MME_NAME
    ) hist
INNER JOIN (
           SELECT FECHA, FINS_ID, MME_NAME, PERIOD_DURATION, SEQNUM
           FROM (
                  SELECT TRUNC(FECHA , 'MONTH') AS FECHA, FINS_ID, PERIOD_DURATION,MME_NAME, ROW_NUMBER()
                        OVER (
                          PARTITION BY TRUNC(FECHA , 'MONTH'), FINS_ID, MME_NAME, PERIOD_DURATION
                          ORDER BY VALOR DESC) SEQNUM
                  FROM PCOFNS_PS_MMMT_TA_CONS_BH_AUX
                  )
           WHERE SEQNUM < 4
        ) bh
ON bh.FECHA = hist.FECHA
AND bh.FINS_ID = hist.FINS_ID
AND bh.MME_NAME = hist.MME_NAME
AND bh.PERIOD_DURATION = hist.PERIOD_DURATION
GROUP BY TRUNC(hist.FECHA , 'MONTH'), hist.PERIOD_DURATION, hist.FINS_ID, hist.MME_NAME
;
