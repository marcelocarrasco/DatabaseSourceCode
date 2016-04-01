--------------------------------------------------------
--  DDL for View FLNS_5037A_CONS_MONTH
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."FLNS_5037A_CONS_MONTH" ("FECHA", "PERIOD_DURATION", "FINS_ID", "MME_NAME", "FLNS_5037A") AS 
  SELECT TRUNC(FECHA, 'MONTH') AS FECHA,
       PERIOD_DURATION,
       FINS_ID,
       MME_NAME,
       ROUND(DECODE(AVG(MMDU_EMM_DEREG_DENOM),
                    0,
                    0,
                    SUM(EPS_MMDU_EMM_DEREG_SUM) / AVG(MMDU_EMM_DEREG_DENOM)),
             2) AS FLNS_5037A
  FROM FLNS_5037A_HISTORICAL
 GROUP BY FINS_ID, PERIOD_DURATION, MME_NAME, TRUNC(FECHA, 'MONTH')
;
