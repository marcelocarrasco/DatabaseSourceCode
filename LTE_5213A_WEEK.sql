--------------------------------------------------------
--  DDL for View LTE_5213A_WEEK
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."LTE_5213A_WEEK" ("FECHA", "CO_NAME", "INT_ID", "PDCP_SDU_VOL_UL", "LTE_5213A") AS 
  SELECT TRUNC( FECHA  , 'DAY') AS FECHA,
		CO_NAME, INT_ID,
		SUM(PDCP_SDU_VOL_UL) AS PDCP_SDU_VOL_UL,
		ROUND( SUM(PDCP_SDU_VOL_UL)/1000000,2) AS LTE_5213A
FROM LTE_5213A_HISTORICAL
GROUP BY TRUNC( FECHA  , 'DAY'), INT_ID,CO_NAME
;
