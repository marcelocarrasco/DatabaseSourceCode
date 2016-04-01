--------------------------------------------------------
--  DDL for View FLNS_5020A
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."FLNS_5020A" ("FECHA", "PERIOD_DURATION", "FINS_ID", "TA_ID", "MME_NAME", "EPS_DEF_BEARER_ACT_SUCC", "EPS_DEF_BEARER_ACT_FAIL") AS 
  SELECT FECHA, PERIOD_DURATION, FINS_ID, TA_ID,MME_NAME, EPS_DEF_BEARER_ACT_SUCC, EPS_DEF_BEARER_ACT_FAIL
FROM FLNS_5020A_HISTORICAL
WHERE FECHA >= (SELECT SYSDATE - 45 FROM DUAL)
;
