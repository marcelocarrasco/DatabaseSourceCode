--------------------------------------------------------
--  DDL for View LTE_5003A
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."LTE_5003A" ("PERIOD_START_TIME", "CO_NAME", "LTE_5003A_NUM", "LTE_5003A_DEN") AS 
  SELECT PERIOD_START_TIME, CO_NAME, LTE_5003A_NUM, LTE_5003A_DEN
FROM LTE_5003A_HISTORICAL
WHERE PERIOD_START_TIME >= (SELECT SYSDATE - 45 FROM DUAL)
;
