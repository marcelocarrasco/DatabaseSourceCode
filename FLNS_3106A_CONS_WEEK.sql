--------------------------------------------------------
--  DDL for View FLNS_3106A_CONS_WEEK
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."FLNS_3106A_CONS_WEEK" ("FECHA", "PERIOD_DURATION", "FINS_ID", "MME_NAME", "FLNS_3106A") AS 
  SELECT TRUNC( FECHA  , 'DAY') AS FECHA, PERIOD_DURATION, FINS_ID,
       MME_NAME, ROUND (DECODE (AVG(PERIOD_DURATION*60), 0 ,0,
              AVG(FLNS_3106A) / AVG(PERIOD_DURATION*60) ) , 2) AS FLNS_3106A
FROM FLNS_3106A_HISTORICAL
GROUP BY  TRUNC( FECHA  , 'DAY'), PERIOD_DURATION, FINS_ID, MME_NAME
;
