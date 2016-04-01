--------------------------------------------------------
--  DDL for View FLNS_5008A_HISTORICAL
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."FLNS_5008A_HISTORICAL" ("FECHA", "PERIOD_DURATION", "FINS_ID", "MME_NAME", "TA_ID", "EPS_TAU_SUCC", "EPS_TAU_FAIL") AS 
  SELECT FLNS.PERIOD_START_TIME AS FECHA, FLNS.PERIOD_DURATION, FLNS.FINS_ID, MO.MME_NAME, FLNS.TA_ID, FLNS.EPS_TAU_SUCC, FLNS.EPS_TAU_FAIL
FROM (
      SELECT PERIOD_START_TIME, PERIOD_DURATION, FINS_ID, TA_ID,
              SUM(EPS_TAU_SUCC) AS EPS_TAU_SUCC,
              SUM(EPS_TAU_SUCC + EPS_TAU_FAIL) AS EPS_TAU_FAIL
      FROM PCOFNS_PS_MMMT_TA_RAW
      GROUP BY PERIOD_START_TIME, PERIOD_DURATION, FINS_ID, TA_ID
) FLNS
INNER JOIN (
    SELECT SGSN_NAME AS MME_NAME,SGSN_ID FROM VW_SGSN_OBJECTS
    WHERE VALID_FINISH_DATE > SYSDATE
) MO
ON  MO.SGSN_ID = FLNS.FINS_ID
;
