--------------------------------------------------------
--  DDL for View FLNS_3101A_CONS_MONTH
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."FLNS_3101A_CONS_MONTH" ("FECHA", "PERIOD_DURATION", "FINS_ID", "MME_NAME", "FLNS_3101A") AS 
  SELECT TRUNC( FECHA  , 'MONTH') AS FECHA, PERIOD_DURATION, FINS_ID,
       MME_NAME, ROUND (DECODE (AVG(PERIOD_DURATION*60), 0 ,0,
              AVG(FLNS_3101A) / AVG(PERIOD_DURATION*60) ) , 2) AS FLNS_3101A
FROM FLNS_3101A_HISTORICAL
GROUP BY  TRUNC( FECHA  , 'MONTH'), PERIOD_DURATION, FINS_ID, MME_NAME
;
