--------------------------------------------------------
--  DDL for View FLNS_5037A_CONS_DAY
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."FLNS_5037A_CONS_DAY" ("FECHA", "PERIOD_DURATION", "FINS_ID", "MME_NAME", "FLNS_5037A") AS 
  SELECT TO_DATE(SUBSTR(FECHA, 0, 10), 'DD/MM/RRRR') AS FECHA,
       PERIOD_DURATION,
       FINS_ID,
       MME_NAME,
       ROUND(DECODE(SUM(MMDU_EMM_DEREG_DENOM),
                    0,
                    0,
                    SUM(EPS_MMDU_EMM_DEREG_SUM) / SUM(MMDU_EMM_DEREG_DENOM)),
             2) AS FLNS_5037A
  FROM FLNS_5037A_HISTORICAL
 GROUP BY TO_DATE(SUBSTR(FECHA, 0, 10), 'DD/MM/RRRR'),
          PERIOD_DURATION,
          FINS_ID,
          MME_NAME
;
