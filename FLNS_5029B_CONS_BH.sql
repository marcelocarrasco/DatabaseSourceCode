--------------------------------------------------------
--  DDL for View FLNS_5029B_CONS_BH
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."FLNS_5029B_CONS_BH" ("FECHA", "PERIOD_DURATION", "FINS_ID", "MME_NAME", "FLNS_5029B") AS 
  SELECT hist.FECHA,
       hist.PERIOD_DURATION,
       hist.FINS_ID,
       hist.MME_NAME,
       hist.FLNS_5029B
  FROM (SELECT TRUNC(FECHA, 'HH24') AS FECHA,
               PERIOD_DURATION,
               FINS_ID,
               MME_NAME,
               ROUND(DECODE(AVG(EPS_ECM_CONN_DENOM),
                            0,
                            0,
                            SUM(EPS_ECM_CONN_SUM) / AVG(EPS_ECM_CONN_DENOM)),
                     2) AS FLNS_5029B
          FROM FLNS_5029B_HISTORICAL
         GROUP BY TRUNC(FECHA, 'HH24'), PERIOD_DURATION, FINS_ID, MME_NAME) hist
 INNER JOIN PCOFNS_PS_UMLM_FNS_CONS_BH_AUX aux
    ON hist.FECHA = aux.FECHA
   AND hist.FINS_ID = aux.FINS_ID
   AND hist.MME_NAME = aux.MME_NAME
;
