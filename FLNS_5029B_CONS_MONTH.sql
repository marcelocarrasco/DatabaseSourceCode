--------------------------------------------------------
--  DDL for View FLNS_5029B_CONS_MONTH
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."FLNS_5029B_CONS_MONTH" ("FECHA", "PERIOD_DURATION", "FINS_ID", "MME_NAME", "FLNS_5029B") AS 
  SELECT TRUNC(FECHA, 'MONTH') AS FECHA,
       PERIOD_DURATION,
       FINS_ID,
       MME_NAME,
       ROUND(DECODE(AVG(EPS_ECM_CONN_DENOM),
                    0,
                    0,
                    SUM(EPS_ECM_CONN_SUM) / AVG(EPS_ECM_CONN_DENOM)),
             2) AS FLNS_5029B
  FROM FLNS_5029B_HISTORICAL
 GROUP BY FINS_ID, PERIOD_DURATION, MME_NAME, TRUNC(FECHA, 'MONTH')
;
