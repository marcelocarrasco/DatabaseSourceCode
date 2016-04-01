--------------------------------------------------------
--  DDL for View FLNS_3103B_CONS_MONTH
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."FLNS_3103B_CONS_MONTH" ("FECHA", "PERIOD_DURATION", "FINS_ID", "MME_NAME", "FLNS_3103B") AS 
  SELECT TRUNC( FECHA  , 'MONTH') AS FECHA, PERIOD_DURATION, FINS_ID,
       MME_NAME, ROUND (DECODE (AVG(PERIOD_DURATION*60), 0 ,0,
              AVG(FLNS_3103B) / AVG(PERIOD_DURATION*60) ) , 2) AS FLNS_3103B
FROM FLNS_3103B_HISTORICAL
GROUP BY  TRUNC( FECHA  , 'MONTH'), PERIOD_DURATION, FINS_ID, MME_NAME
;
