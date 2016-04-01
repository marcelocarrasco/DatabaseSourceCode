--------------------------------------------------------
--  DDL for View LTE_5082A
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."LTE_5082A" ("PERIOD_START_TIME", "CO_NAME", "LTE_5082A_NUM", "LTE_5082A_DEN") AS 
  SELECT PERIOD_START_TIME, CO_NAME, LTE_5082A_NUM, LTE_5082A_DEN
FROM LTE_5082A_HISTORICAL
WHERE PERIOD_START_TIME >= (SELECT SYSDATE - 45 FROM DUAL)
;
