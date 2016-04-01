--------------------------------------------------------
--  DDL for View LTE_5048B
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."LTE_5048B" ("PERIOD_START_TIME", "CO_NAME", "LTE_5048B_NUM", "LTE_5048B_DEN") AS 
  SELECT PERIOD_START_TIME, CO_NAME, LTE_5048B_NUM, LTE_5048B_DEN
FROM LTE_5048B_HISTORICAL
WHERE PERIOD_START_TIME >= (SELECT SYSDATE - 45 FROM DUAL)
;
