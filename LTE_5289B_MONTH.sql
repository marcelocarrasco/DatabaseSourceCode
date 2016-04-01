--------------------------------------------------------
--  DDL for View LTE_5289B_MONTH
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."LTE_5289B_MONTH" ("PERIOD_START_TIME", "CO_NAME", "LTE_5289B") AS 
  SELECT TRUNC( PERIOD_START_TIME  , 'MONTH') AS PERIOD_START_TIME, CO_NAME,
			ROUND( AVG(PDCP_DATA_RATE_MEAN_UL),2) AS LTE_5289B
FROM LTE_5289B_HISTORICAL
GROUP BY TRUNC( PERIOD_START_TIME  , 'MONTH'), CO_NAME
;
