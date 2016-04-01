--------------------------------------------------------
--  DDL for View FLNS_5032B_CONS_HOUR
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."FLNS_5032B_CONS_HOUR" ("FECHA", "PERIOD_DURATION", "FINS_ID", "MME_NAME", "FLNS_5032B") AS 
  SELECT TO_DATE(SUBSTR(TO_CHAR(FECHA, 'DD/MM/RRRR HH24:MI'), 0, 13),
               'DD/MM/YYYY HH24:MI') AS FECHA,
       PERIOD_DURATION,
       FINS_ID,
       MME_NAME,
       ROUND(DECODE(AVG(EPS_ECM_IDLE_DENOM),
                    0,
                    0,
                    SUM(EPS_ECM_IDLE_SUM) / AVG(EPS_ECM_IDLE_DENOM)),
             2) AS FLNS_5032B
  FROM FLNS_5032B_HISTORICAL
 GROUP BY TO_DATE(SUBSTR(TO_CHAR(FECHA, 'DD/MM/RRRR HH24:MI'), 0, 13),
                  'DD/MM/YYYY HH24:MI'),
          PERIOD_DURATION,
          FINS_ID,
          MME_NAME
;
