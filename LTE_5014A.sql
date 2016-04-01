--------------------------------------------------------
--  DDL for View LTE_5014A
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."LTE_5014A" ("PERIOD_START_TIME", "CO_NAME", "LTE_5014A_NUM", "LTE_5014A_DEN") AS 
  SELECT PERIOD_START_TIME, CO_NAME, LTE_5014A_NUM, LTE_5014A_DEN
FROM LTE_5014A_HISTORICAL
WHERE PERIOD_START_TIME >= (SELECT SYSDATE - 45 FROM DUAL)
;
