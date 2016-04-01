--------------------------------------------------------
--  DDL for View FLNS_5032B_CONS_DAY
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."FLNS_5032B_CONS_DAY" ("FECHA", "PERIOD_DURATION", "FINS_ID", "MME_NAME", "FLNS_5032B") AS 
  SELECT TO_DATE(SUBSTR(FECHA, 0, 10), 'DD/MM/RRRR') AS FECHA,
       PERIOD_DURATION,
       FINS_ID,
       MME_NAME,
       ROUND(DECODE(SUM(EPS_ECM_IDLE_DENOM),
                    0,
                    0,
                    SUM(EPS_ECM_IDLE_SUM) / SUM(EPS_ECM_IDLE_DENOM)),
             2) AS FLNS_5032B
  FROM FLNS_5032B_HISTORICAL
 GROUP BY TO_DATE(SUBSTR(FECHA, 0, 10), 'DD/MM/RRRR'),
          PERIOD_DURATION,
          FINS_ID,
          MME_NAME
;
