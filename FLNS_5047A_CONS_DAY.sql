--------------------------------------------------------
--  DDL for View FLNS_5047A_CONS_DAY
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."FLNS_5047A_CONS_DAY" ("FECHA", "PERIOD_DURATION", "FINS_ID", "MME_NAME", "FLNS_5047A") AS 
  SELECT TO_DATE(SUBSTR(FECHA, 0, 10), 'DD/MM/RRRR') AS FECHA,
       PERIOD_DURATION,
       FINS_ID,
       MME_NAME,
      ROUND(DECODE(SUM(EPS_BEARER_DEFAULT_NBR_DEN),
                    0,
                    0,
                    SUM(EPS_BEARER_DEFAULT_NBR_SUM) / SUM(EPS_BEARER_DEFAULT_NBR_DEN)),
             2) AS FLNS_5047A
  FROM FLNS_5047A_HISTORICAL
 GROUP BY TO_DATE(SUBSTR(FECHA, 0, 10), 'DD/MM/RRRR'),
          PERIOD_DURATION,
          FINS_ID,
          MME_NAME
;
