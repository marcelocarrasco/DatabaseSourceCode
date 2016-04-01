--------------------------------------------------------
--  DDL for View LTE_5292B
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."LTE_5292B" ("PERIOD_START_TIME", "CO_NAME", "PDCP_DATA_RATE_MEAN_DL") AS 
  SELECT PERIOD_START_TIME, CO_NAME, PDCP_DATA_RATE_MEAN_DL
FROM LTE_5292B_HISTORICAL
WHERE PERIOD_START_TIME >= (SELECT SYSDATE - 45 FROM DUAL)
;
