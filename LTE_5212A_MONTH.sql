--------------------------------------------------------
--  DDL for View LTE_5212A_MONTH
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."LTE_5212A_MONTH" ("FECHA", "CO_NAME", "INT_ID", "PDCP_SDU_VOL_DL", "LTE_5212A") AS 
  SELECT TRUNC( FECHA  , 'MONTH') AS FECHA,
		CO_NAME, INT_ID,
		SUM(PDCP_SDU_VOL_DL) AS PDCP_SDU_VOL_DL,
      	ROUND(SUM(PDCP_SDU_VOL_DL)/1000000,2) AS LTE_5212A
FROM LTE_5212A_HISTORICAL
GROUP BY TRUNC( FECHA  , 'MONTH'), CO_NAME, INT_ID
;
