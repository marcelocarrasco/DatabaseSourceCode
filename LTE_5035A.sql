--------------------------------------------------------
--  DDL for View LTE_5035A
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."LTE_5035A" ("PERIOD_START_TIME", "CO_NAME", "LTE_5035A_NUM", "LTE_5035A_DEN") AS 
  SELECT PERIOD_START_TIME, CO_NAME, LTE_5035A_NUM, LTE_5035A_DEN
FROM LTE_5035A_HISTORICAL
WHERE PERIOD_START_TIME >= (SELECT SYSDATE - 45 FROM DUAL)
;
