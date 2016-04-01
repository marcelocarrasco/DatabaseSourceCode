--------------------------------------------------------
--  DDL for View PRINCIP_COUNTERS_MONTH
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."PRINCIP_COUNTERS_MONTH" ("FECHA", "CO_NAME", "INT_ID", "M8013C6", "M8013C7", "M8013C8", "M8013C27", "M8006C2", "M8006C4", "M8006C3", "M8006C5", "M8006C12", "M8006C14", "M8006C13") AS 
  SELECT TRUNC( FECHA  , 'MONTH') AS FECHA,
	    CO_NAME, INT_ID,
		SUM(M8013C6) AS  M8013C6,
		SUM(M8013C7) AS M8013C7,
		SUM(M8013C8) AS M8013C8,
		SUM(M8013C27) AS M8013C27,
		SUM(M8006C2) AS M8006C2,
		SUM(M8006C4) AS M8006C4,
		SUM(M8006C3) AS M8006C3,
		SUM(M8006C5) AS M8006C5,
		SUM(M8006C12) AS M8006C12,
		SUM(M8006C14) AS M8006C14,
		SUM(M8006C13) AS M8006C13
FROM PRINCIP_COUNTERS_HISTORICAL
GROUP BY TRUNC( FECHA  , 'MONTH'), INT_ID, CO_NAME
;
