--------------------------------------------------------
--  DDL for View FLNS_5037A_CONS_BH
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."FLNS_5037A_CONS_BH" ("FECHA", "PERIOD_DURATION", "FINS_ID", "MME_NAME", "FLNS_5037A") AS 
  SELECT hist.FECHA,
       hist.PERIOD_DURATION,
       hist.FINS_ID,
       hist.MME_NAME,
       hist.FLNS_5037A
  FROM (SELECT TRUNC(FECHA, 'HH24') AS FECHA,
               PERIOD_DURATION,
               FINS_ID,
               MME_NAME,
               ROUND(DECODE(AVG(MMDU_EMM_DEREG_DENOM),
                    0,
                    0,
                    SUM(EPS_MMDU_EMM_DEREG_SUM) / AVG(MMDU_EMM_DEREG_DENOM)),
             2) AS FLNS_5037A
          FROM FLNS_5037A_HISTORICAL
         GROUP BY TRUNC(FECHA, 'HH24'), PERIOD_DURATION, FINS_ID, MME_NAME) hist
 INNER JOIN PCOFNS_PS_MULM_MMDU_BH_AUX aux
    ON hist.FECHA = aux.FECHA
   AND hist.FINS_ID = aux.FINS_ID
   AND hist.MME_NAME = aux.MME_NAME
;
