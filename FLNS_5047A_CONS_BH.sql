--------------------------------------------------------
--  DDL for View FLNS_5047A_CONS_BH
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."FLNS_5047A_CONS_BH" ("FECHA", "PERIOD_DURATION", "FINS_ID", "MME_NAME", "FLNS_5047A") AS 
  SELECT hist.FECHA,
       hist.PERIOD_DURATION,
       hist.FINS_ID,
       hist.MME_NAME,
       hist.FLNS_5047A
  FROM (SELECT TRUNC(FECHA, 'HH24') AS FECHA,
               PERIOD_DURATION,
               FINS_ID,
               MME_NAME,
               ROUND(DECODE(AVG(EPS_BEARER_DEFAULT_NBR_DEN),
                    0,
                    0,
                    SUM(EPS_BEARER_DEFAULT_NBR_SUM) / AVG(EPS_BEARER_DEFAULT_NBR_DEN)),
             2) AS FLNS_5047A
          FROM FLNS_5047A_HISTORICAL
         GROUP BY TRUNC(FECHA, 'HH24'), PERIOD_DURATION, FINS_ID, MME_NAME) hist
 INNER JOIN PCOFNS_PS_MULM_MMDU_BH_AUX aux
    ON hist.FECHA = aux.FECHA
   AND hist.FINS_ID = aux.FINS_ID
   AND hist.MME_NAME = aux.MME_NAME
;
