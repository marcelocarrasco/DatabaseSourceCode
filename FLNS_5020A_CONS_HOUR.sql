--------------------------------------------------------
--  DDL for View FLNS_5020A_CONS_HOUR
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."FLNS_5020A_CONS_HOUR" ("FECHA", "PERIOD_DURATION", "FINS_ID", "MME_NAME", "FLNS_5020A") AS 
  SELECT TO_DATE(SUBSTR( TO_CHAR( FECHA, 'DD/MM/RRRR HH24:MI'), 0, 13),'DD/MM/YYYY HH24:MI') AS FECHA,
     PERIOD_DURATION,FINS_ID, MME_NAME,ROUND ((DECODE (SUM(EPS_DEF_BEARER_ACT_FAIL), 0 ,0,
              SUM(EPS_DEF_BEARER_ACT_SUCC) / SUM(EPS_DEF_BEARER_ACT_FAIL) ) ) * 100, 2) AS FLNS_5020A
FROM FLNS_5020A
GROUP BY TO_DATE(SUBSTR( TO_CHAR( FECHA, 'DD/MM/RRRR HH24:MI'), 0, 13),'DD/MM/YYYY HH24:MI') , PERIOD_DURATION,
    FINS_ID,MME_NAME
;
