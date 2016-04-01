--------------------------------------------------------
--  DDL for View FLNS_5047A_CONS_MONTH
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."FLNS_5047A_CONS_MONTH" ("FECHA", "PERIOD_DURATION", "FINS_ID", "MME_NAME", "FLNS_5047A") AS 
  SELECT TRUNC(FECHA, 'MONTH') AS FECHA,
       PERIOD_DURATION,
       FINS_ID,
       MME_NAME,
      ROUND(DECODE(AVG(EPS_BEARER_DEFAULT_NBR_DEN),
                    0,
                    0,
                    SUM(EPS_BEARER_DEFAULT_NBR_SUM) / AVG(EPS_BEARER_DEFAULT_NBR_DEN)),
             2) AS FLNS_5047A
  FROM FLNS_5047A_HISTORICAL
 GROUP BY FINS_ID, PERIOD_DURATION, MME_NAME, TRUNC(FECHA, 'MONTH')
;
