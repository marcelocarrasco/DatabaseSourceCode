--------------------------------------------------------
--  DDL for View FLNS_3109B_HOUR
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."FLNS_3109B_HOUR" ("FECHA", "PERIOD_DURATION", "FINS_ID", "MME_NAME", "FLNS_3109B") AS 
  SELECT TO_DATE(SUBSTR( TO_CHAR( FECHA, 'DD/MM/RRRR HH24:MI'), 0, 13),'DD/MM/YYYY HH24:MI') AS FECHA,
      PERIOD_DURATION, FINS_ID, MME_NAME, ROUND (DECODE (SUM(PERIOD_DURATION*60), 0 ,0,
              SUM(FLNS_3109B) / SUM(PERIOD_DURATION*60) ) , 2) AS FLNS_3109B
FROM FLNS_3109B
GROUP BY TO_DATE(SUBSTR( TO_CHAR( FECHA, 'DD/MM/RRRR HH24:MI'), 0, 13),'DD/MM/YYYY HH24:MI') , PERIOD_DURATION,
          FINS_ID, MME_NAME
;
