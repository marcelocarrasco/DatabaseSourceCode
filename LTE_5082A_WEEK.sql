--------------------------------------------------------
--  DDL for View LTE_5082A_WEEK
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."LTE_5082A_WEEK" ("PERIOD_START_TIME", "CO_NAME", "LTE_5082A_NUM", "LTE_5082A_DEN", "LTE_5082A") AS 
  SELECT TRUNC( PERIOD_START_TIME  , 'DAY') AS PERIOD_START_TIME, CO_NAME,  SUM(LTE_5082A_NUM) AS LTE_5082A_NUM,
SUM(LTE_5082A_DEN) AS LTE_5082A_DEN,
ROUND (((DECODE (SUM(LTE_5082A_DEN), 0, 0, SUM(LTE_5082A_NUM) /
  SUM(LTE_5082A_DEN)) )*100),2) as LTE_5082A
FROM LTE_5082A_HISTORICAL
GROUP BY TRUNC( PERIOD_START_TIME  , 'DAY'), CO_NAME
;
