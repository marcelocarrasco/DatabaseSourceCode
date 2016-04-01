--------------------------------------------------------
--  DDL for View FLNS_5037A_CONS_ISABHWEEK
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."FLNS_5037A_CONS_ISABHWEEK" ("FECHA", "PERIOD_DURATION", "FINS_ID", "MME_NAME", "FLNS_5037A") AS 
  SELECT TRUNC(hist.FECHA, 'DAY') AS FECHA,
       hist.PERIOD_DURATION,
       hist.FINS_ID,
       hist.MME_NAME,
       ROUND(AVG(hist.FLNS_5037A), 2) AS FLNS_5037A
  FROM (SELECT TRUNC(FECHA, 'HH24') AS FECHA,
               PERIOD_DURATION,
               FINS_ID,
               MME_NAME,
               ROUND(DECODE(AVG(MMDU_EMM_DEREG_DENOM),
                    0,
                    0,
                    SUM(EPS_MMDU_EMM_DEREG_SUM) / AVG(MMDU_EMM_DEREG_DENOM)),
             2) AS FLNS_5037A
          FROM FLNS_5037A_HISTORICAL
         GROUP BY TRUNC(FECHA, 'HH24'), PERIOD_DURATION, FINS_ID, MME_NAME) hist
 INNER JOIN (SELECT FECHA, FINS_ID, MME_NAME, PERIOD_DURATION, SEQNUM
               FROM (SELECT TRUNC(FECHA, 'DAY') AS FECHA,
                            FINS_ID,
                            PERIOD_DURATION,
                            MME_NAME,
                            ROW_NUMBER() OVER(PARTITION BY TRUNC(FECHA, 'DAY'), FINS_ID, MME_NAME, PERIOD_DURATION ORDER BY VALOR DESC) SEQNUM
                       FROM PCOFNS_PS_MULM_MMDU_BH_AUX)
              WHERE SEQNUM < 4) bh
    ON bh.FECHA = hist.FECHA
   AND bh.FINS_ID = hist.FINS_ID
   AND bh.MME_NAME = hist.MME_NAME
   AND bh.PERIOD_DURATION = hist.PERIOD_DURATION
 GROUP BY TRUNC(hist.FECHA, 'DAY'),
          hist.PERIOD_DURATION,
          hist.FINS_ID,
          hist.MME_NAME
;
