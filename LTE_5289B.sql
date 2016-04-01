--------------------------------------------------------
--  DDL for View LTE_5289B
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."LTE_5289B" ("PERIOD_START_TIME", "CO_NAME", "PDCP_DATA_RATE_MEAN_UL") AS 
  SELECT PERIOD_START_TIME, CO_NAME, PDCP_DATA_RATE_MEAN_UL
FROM LTE_5289B_HISTORICAL
WHERE PERIOD_START_TIME >= (SELECT SYSDATE - 45 FROM DUAL)
;
