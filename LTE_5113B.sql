--------------------------------------------------------
--  DDL for View LTE_5113B
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."LTE_5113B" ("PERIOD_START_TIME", "CO_NAME", "LTE_5113B_NUM", "LTE_5113B_DEN") AS 
  SELECT PERIOD_START_TIME, CO_NAME, LTE_5113B_NUM, LTE_5113B_DEN
FROM LTE_5113B_HISTORICAL
WHERE PERIOD_START_TIME >= (SELECT SYSDATE - 45 FROM DUAL)
;
