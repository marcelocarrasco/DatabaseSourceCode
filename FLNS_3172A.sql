--------------------------------------------------------
--  DDL for View FLNS_3172A
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."FLNS_3172A" ("FECHA", "PERIOD_DURATION", "FINS_ID", "MME_NAME", "TA_ID", "FLNS_3172A") AS 
  SELECT FECHA, PERIOD_DURATION, FINS_ID, MME_NAME, TA_ID, FLNS_3172A
FROM FLNS_3172A_HISTORICAL
WHERE FECHA >= (SELECT SYSDATE - 45 FROM DUAL)
;
