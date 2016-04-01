--------------------------------------------------------
--  DDL for View FLNS_3218A_DAY
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."FLNS_3218A_DAY" ("FECHA", "PERIOD_DURATION", "FINS_ID", "MME_NAME", "TA_ID", "FLNS_3218A") AS 
  SELECT TO_DATE( SUBSTR( FECHA, 0, 10), 'DD/MM/RRRR') AS FECHA, PERIOD_DURATION, FINS_ID,
       MME_NAME,TA_ID, ROUND (DECODE (AVG(PERIOD_DURATION*60), 0 ,0,
              AVG(FLNS_3218A) / AVG(PERIOD_DURATION*60) ) , 2) AS FLNS_3218A
FROM FLNS_3218A_HISTORICAL
GROUP BY  TO_DATE( SUBSTR( FECHA, 0, 10), 'DD/MM/RRRR'), PERIOD_DURATION, FINS_ID, TA_ID,MME_NAME
;
