--------------------------------------------------------
--  DDL for View FLNS_5005A_CONS_MONTH
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."FLNS_5005A_CONS_MONTH" ("FECHA", "PERIOD_DURATION", "FINS_ID", "MME_NAME", "FLNS_5005A") AS 
  SELECT TRUNC( FECHA  , 'MONTH') AS FECHA, PERIOD_DURATION, FINS_ID, MME_NAME,
      ROUND ((DECODE (SUM(EPS_PERIODIC_TAU_FAIL), 0 ,0,
              SUM(EPS_PERIODIC_TAU_SUCC) / SUM(EPS_PERIODIC_TAU_FAIL) ) ) * 100, 2) AS FLNS_5005A
FROM FLNS_5005A_HISTORICAL
GROUP BY   FINS_ID,  PERIOD_DURATION, MME_NAME, TRUNC( FECHA  , 'MONTH')
;
