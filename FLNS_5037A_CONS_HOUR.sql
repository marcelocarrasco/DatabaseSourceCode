--------------------------------------------------------
--  DDL for View FLNS_5037A_CONS_HOUR
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."FLNS_5037A_CONS_HOUR" ("FECHA", "PERIOD_DURATION", "FINS_ID", "MME_NAME", "FLNS_5037A") AS 
  SELECT TO_DATE(SUBSTR(TO_CHAR(FECHA, 'DD/MM/RRRR HH24:MI'), 0, 13),
               'DD/MM/YYYY HH24:MI') AS FECHA,
       PERIOD_DURATION,
       FINS_ID,
       MME_NAME,
       ROUND(DECODE(AVG(MMDU_EMM_DEREG_DENOM),
                    0,
                    0,
                    SUM(EPS_MMDU_EMM_DEREG_SUM) / AVG(MMDU_EMM_DEREG_DENOM)),
             2) AS FLNS_5037A
  FROM FLNS_5037A_HISTORICAL
 GROUP BY TO_DATE(SUBSTR(TO_CHAR(FECHA, 'DD/MM/RRRR HH24:MI'), 0, 13),
                  'DD/MM/YYYY HH24:MI'),
          PERIOD_DURATION,
          FINS_ID,
          MME_NAME
;
