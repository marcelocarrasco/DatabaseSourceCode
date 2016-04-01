--------------------------------------------------------
--  DDL for View FLNS_3111A_HOUR
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."FLNS_3111A_HOUR" ("FECHA", "PERIOD_DURATION", "FINS_ID", "MME_NAME", "TA_ID", "FLNS_3111A") AS 
  SELECT TO_DATE(SUBSTR( TO_CHAR( FECHA, 'DD/MM/RRRR HH24:MI'), 0, 13),'DD/MM/YYYY HH24:MI') AS FECHA,
      PERIOD_DURATION, FINS_ID, MME_NAME,TA_ID, ROUND (DECODE (AVG(PERIOD_DURATION*60), 0 ,0,
              SUM(FLNS_3111A) / AVG(PERIOD_DURATION*60) ) , 2) AS FLNS_3111A
FROM FLNS_3111A
GROUP BY TO_DATE(SUBSTR( TO_CHAR( FECHA, 'DD/MM/RRRR HH24:MI'), 0, 13),'DD/MM/YYYY HH24:MI') , PERIOD_DURATION,
          FINS_ID, TA_ID, MME_NAME
;
