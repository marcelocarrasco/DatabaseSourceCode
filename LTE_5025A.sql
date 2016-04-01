--------------------------------------------------------
--  DDL for View LTE_5025A
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."LTE_5025A" ("PERIOD_START_TIME", "CO_NAME", "LTE_5025A_NUM", "LTE_5025A_DEN") AS 
  SELECT PERIOD_START_TIME, CO_NAME, LTE_5025A_NUM, LTE_5025A_DEN
FROM LTE_5025A_HISTORICAL
WHERE PERIOD_START_TIME >= (SELECT SYSDATE - 45 FROM DUAL)
;
