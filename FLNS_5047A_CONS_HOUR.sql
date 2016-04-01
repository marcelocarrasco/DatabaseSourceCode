--------------------------------------------------------
--  DDL for View FLNS_5047A_CONS_HOUR
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."FLNS_5047A_CONS_HOUR" ("FECHA", "PERIOD_DURATION", "FINS_ID", "MME_NAME", "FLNS_5047A") AS 
  SELECT TO_DATE(SUBSTR(TO_CHAR(FECHA, 'DD/MM/RRRR HH24:MI'), 0, 13),
               'DD/MM/YYYY HH24:MI') AS FECHA,
       PERIOD_DURATION,
       FINS_ID,
       MME_NAME,
       ROUND(DECODE(AVG(EPS_BEARER_DEFAULT_NBR_DEN),
                    0,
                    0,
                    SUM(EPS_BEARER_DEFAULT_NBR_SUM) / AVG(EPS_BEARER_DEFAULT_NBR_DEN)),
             2) AS FLNS_5047A
  FROM FLNS_5047A_HISTORICAL
 GROUP BY TO_DATE(SUBSTR(TO_CHAR(FECHA, 'DD/MM/RRRR HH24:MI'), 0, 13),
                  'DD/MM/YYYY HH24:MI'),
          PERIOD_DURATION,
          FINS_ID,
          MME_NAME
;
