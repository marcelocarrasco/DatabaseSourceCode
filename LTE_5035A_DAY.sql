--------------------------------------------------------
--  DDL for View LTE_5035A_DAY
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."LTE_5035A_DAY" ("PERIOD_START_TIME", "CO_NAME", "LTE_5035A_NUM", "LTE_5035A_DEN", "LTE_5035A") AS 
  SELECT TO_DATE( SUBSTR( PERIOD_START_TIME, 0, 10), 'DD/MM/RRRR') AS PERIOD_START_TIME, CO_NAME,
SUM(LTE_5035A_NUM) AS LTE_5035A_NUM,
SUM(LTE_5035A_DEN) AS LTE_5035A_DEN,
ROUND (((DECODE (SUM(LTE_5035A_DEN), 0, 0, SUM(LTE_5035A_NUM) /
  SUM(LTE_5035A_DEN)) )*100),2) AS LTE_5035A
FROM LTE_5035A_HISTORICAL
GROUP BY  TO_DATE( SUBSTR( PERIOD_START_TIME, 0, 10), 'DD/MM/RRRR'), CO_NAME
;
