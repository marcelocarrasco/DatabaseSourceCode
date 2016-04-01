--------------------------------------------------------
--  DDL for View FLNS_3105B_DAY
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."FLNS_3105B_DAY" ("FECHA", "PERIOD_DURATION", "FINS_ID", "MME_NAME", "TA_ID", "FLNS_3105B") AS 
  SELECT TO_DATE( SUBSTR( FECHA, 0, 10), 'DD/MM/RRRR') AS FECHA, PERIOD_DURATION, FINS_ID,
       MME_NAME,TA_ID, ROUND (DECODE (AVG(PERIOD_DURATION*60), 0 ,0,
              AVG(FLNS_3105B) / AVG(PERIOD_DURATION*60) ) , 2) AS FLNS_3105B
FROM FLNS_3105B_HISTORICAL
GROUP BY  TO_DATE( SUBSTR( FECHA, 0, 10), 'DD/MM/RRRR'), PERIOD_DURATION, FINS_ID, TA_ID,MME_NAME
;
