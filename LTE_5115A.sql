--------------------------------------------------------
--  DDL for View LTE_5115A
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."LTE_5115A" ("PERIOD_START_TIME", "CO_NAME", "LTE_5115A_NUM", "LTE_5115A_DEN") AS 
  SELECT PERIOD_START_TIME, CO_NAME, LTE_5115A_NUM, LTE_5115A_DEN
FROM LTE_5115A_HISTORICAL
WHERE PERIOD_START_TIME >= (SELECT SYSDATE - 45 FROM DUAL)
;
