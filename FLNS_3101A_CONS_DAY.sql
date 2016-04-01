--------------------------------------------------------
--  DDL for View FLNS_3101A_CONS_DAY
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."FLNS_3101A_CONS_DAY" ("FECHA", "PERIOD_DURATION", "FINS_ID", "MME_NAME", "FLNS_3101A") AS 
  SELECT TO_DATE( SUBSTR( FECHA, 0, 10), 'DD/MM/RRRR') AS FECHA, PERIOD_DURATION, FINS_ID,
       MME_NAME, ROUND (DECODE (AVG(PERIOD_DURATION*60), 0 ,0,
              AVG(FLNS_3101A) / AVG(PERIOD_DURATION*60) ) , 2) AS FLNS_3101A
FROM FLNS_3101A_HISTORICAL
GROUP BY  TO_DATE( SUBSTR( FECHA, 0, 10), 'DD/MM/RRRR'), PERIOD_DURATION, FINS_ID, MME_NAME
;
