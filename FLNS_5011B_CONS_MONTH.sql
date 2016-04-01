--------------------------------------------------------
--  DDL for View FLNS_5011B_CONS_MONTH
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."FLNS_5011B_CONS_MONTH" ("FECHA", "PERIOD_DURATION", "FINS_ID", "MME_NAME", "FLNS_5011B") AS 
  SELECT TRUNC( FECHA  , 'MONTH') AS FECHA, PERIOD_DURATION,FINS_ID, MME_NAME,
    ROUND ((DECODE (SUM(EPS_PATH_SWITCH_X2_FAIL), 0 ,0,
              SUM(EPS_PATH_SWITCH_X2_SUCC) / SUM(EPS_PATH_SWITCH_X2_FAIL) ) ) * 100, 2) AS FLNS_5011B
FROM FLNS_5011B_HISTORICAL
GROUP BY FINS_ID, PERIOD_DURATION,MME_NAME, TRUNC( FECHA  , 'MONTH')
;
