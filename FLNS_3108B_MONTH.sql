--------------------------------------------------------
--  DDL for View FLNS_3108B_MONTH
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."FLNS_3108B_MONTH" ("FECHA", "PERIOD_DURATION", "FINS_ID", "MME_NAME", "TA_ID", "FLNS_3108B") AS 
  SELECT TRUNC( FECHA  , 'MONTH') AS FECHA, PERIOD_DURATION, FINS_ID,
       MME_NAME,TA_ID, ROUND (DECODE (AVG(PERIOD_DURATION*60), 0 ,0,
              AVG(FLNS_3108B) / AVG(PERIOD_DURATION*60) ) , 2) AS FLNS_3108B
FROM FLNS_3108B_HISTORICAL
GROUP BY  TRUNC( FECHA  , 'MONTH'), PERIOD_DURATION, FINS_ID, TA_ID,MME_NAME
;
