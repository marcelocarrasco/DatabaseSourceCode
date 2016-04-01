--------------------------------------------------------
--  DDL for View FLNS_5008A
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."FLNS_5008A" ("FECHA", "PERIOD_DURATION", "FINS_ID", "TA_ID", "EPS_TAU_SUCC", "EPS_TAU_FAIL", "MME_NAME") AS 
  SELECT FECHA, PERIOD_DURATION, FINS_ID, TA_ID, EPS_TAU_SUCC, EPS_TAU_FAIL, MME_NAME
FROM FLNS_5008A_HISTORICAL
WHERE FECHA >= (SELECT SYSDATE - 45 FROM DUAL)
;
