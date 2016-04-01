--------------------------------------------------------
--  DDL for View LTE_5014A_MONTH
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."LTE_5014A_MONTH" ("PERIOD_START_TIME", "CO_NAME", "LTE_5014A_NUM", "LTE_5014A_DEN", "LTE_5014A") AS 
  SELECT TRUNC( PERIOD_START_TIME  , 'MONTH') AS PERIOD_START_TIME, CO_NAME, SUM(LTE_5014A_NUM) AS LTE_5014A_NUM,
SUM(LTE_5014A_DEN) AS LTE_5014A_DEN, ROUND (((DECODE (SUM(LTE_5014A_DEN), 0, 0, SUM(LTE_5014A_NUM) /
  SUM(LTE_5014A_DEN)) )*100),2) AS LTE_5014A
FROM LTE_5014A_HISTORICAL
GROUP BY TRUNC( PERIOD_START_TIME  , 'MONTH'), CO_NAME
;
