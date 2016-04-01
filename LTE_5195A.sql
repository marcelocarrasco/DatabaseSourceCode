--------------------------------------------------------
--  DDL for View LTE_5195A
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."LTE_5195A" ("PERIOD_START_TIME", "CO_NAME", "LTE_5195A_NUM", "LTE_5195A_DEN") AS 
  SELECT PERIOD_START_TIME, CO_NAME, LTE_5195A_NUM, LTE_5195A_DEN
FROM LTE_5195A_HISTORICAL
WHERE PERIOD_START_TIME >= (SELECT SYSDATE - 45 FROM DUAL)
;
