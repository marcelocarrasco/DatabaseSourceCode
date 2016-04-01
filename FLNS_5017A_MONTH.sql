--------------------------------------------------------
--  DDL for View FLNS_5017A_MONTH
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."FLNS_5017A_MONTH" ("FECHA", "PERIOD_DURATION", "FINS_ID", "TA_ID", "MME_NAME", "FLNS_5017A") AS 
  SELECT TRUNC( FECHA  , 'MONTH') AS FECHA,  PERIOD_DURATION, FINS_ID, TA_ID, MME_NAME,
		ROUND ((DECODE (SUM(EPS_PAGING_FAIL), 0 ,0,
              SUM(EPS_PAGING_SUCC) / SUM(EPS_PAGING_FAIL) ) ) * 100, 2) AS FLNS_5017A
FROM FLNS_5017A_HISTORICAL
GROUP BY   FINS_ID, TA_ID, PERIOD_DURATION,MME_NAME, TRUNC( FECHA  , 'MONTH')
;
