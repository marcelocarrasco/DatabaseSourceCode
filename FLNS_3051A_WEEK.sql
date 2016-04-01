--------------------------------------------------------
--  DDL for View FLNS_3051A_WEEK
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."FLNS_3051A_WEEK" ("FECHA", "PERIOD_DURATION", "FINS_ID", "MME_NAME", "UNIT_ID", "COMP_AVERAGE_LOAD", "COMP_PEAK_LOAD_PERCENT") AS 
  SELECT TRUNC( FECHA  , 'DAY') AS FECHA, PERIOD_DURATION, FINS_ID,
       MME_NAME,UNIT_ID, ROUND(MAX(COMP_AVERAGE_LOAD)/10, 2) AS COMP_AVERAGE_LOAD, MAX(COMP_PEAK_LOAD_PERCENT) AS COMP_PEAK_LOAD_PERCENT
FROM FLNS_3051A_HISTORICAL
GROUP BY  TRUNC( FECHA  , 'DAY') , PERIOD_DURATION, FINS_ID, UNIT_ID,MME_NAME
;
