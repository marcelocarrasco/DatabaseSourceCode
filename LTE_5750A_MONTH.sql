--------------------------------------------------------
--  DDL for View LTE_5750A_MONTH
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."LTE_5750A_MONTH" ("FECHA", "CO_NAME", "INT_ID", "LTE_5750A_NUM", "LTE_5750A_DEN", "LTE_5750A", "SAMPLES_CELL_AVAIL", "DENOM_CELL_AVAIL") AS 
  SELECT TRUNC( FECHA  , 'MONTH') AS FECHA,
		CO_NAME, INT_ID,
		SUM(LTE_5750A_NUM) AS LTE_5750A_NUM ,
		SUM(LTE_5750A_DEN) AS LTE_5750A_DEN,
		ROUND ((DECODE (SUM(LTE_5750A_DEN), 0 ,0, SUM(LTE_5750A_NUM) / SUM(LTE_5750A_DEN) ) ) * 100, 2) AS LTE_5750A,
		SUM(SAMPLES_CELL_AVAIL) AS SAMPLES_CELL_AVAIL,
		SUM(DENOM_CELL_AVAIL) AS DENOM_CELL_AVAIL
FROM LTE_5750A_HISTORICAL
GROUP BY TRUNC( FECHA  , 'MONTH'),INT_ID, CO_NAME
;
