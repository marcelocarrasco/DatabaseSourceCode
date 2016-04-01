--------------------------------------------------------
--  DDL for View FLNS_5037A_HISTORICAL
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."FLNS_5037A_HISTORICAL" ("FECHA", "PERIOD_DURATION", "FINS_ID", "MME_NAME", "EPS_MMDU_EMM_DEREG_SUM", "MMDU_EMM_DEREG_DENOM") AS 
  SELECT FLNS.PERIOD_START_TIME AS FECHA,
       FLNS.PERIOD_DURATION,
       FLNS.FINS_ID,
       MO.MME_NAME,
       FLNS.EPS_MMDU_EMM_DEREG_SUM,
       FLNS.MMDU_EMM_DEREG_DENOM
  FROM (SELECT PERIOD_START_TIME,
               PERIOD_DURATION,
               FINS_ID,
               SUM(EPS_MMDU_EMM_DEREG_SUM) AS EPS_MMDU_EMM_DEREG_SUM,
               AVG(MMDU_EMM_DEREG_DENOM) AS MMDU_EMM_DEREG_DENOM
          FROM PCOFNS_PS_MULM_MMDU_RAW
         GROUP BY PERIOD_START_TIME, PERIOD_DURATION, FINS_ID) FLNS
 INNER JOIN (SELECT SGSN_NAME AS MME_NAME, SGSN_ID
               FROM VW_SGSN_OBJECTS
              WHERE VALID_FINISH_DATE > SYSDATE) MO
    ON MO.SGSN_ID = FLNS.FINS_ID
;
