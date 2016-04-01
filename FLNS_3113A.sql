--------------------------------------------------------
--  DDL for View FLNS_3113A
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."FLNS_3113A" ("FECHA", "PERIOD_DURATION", "FINS_ID", "MME_NAME", "TA_ID", "FLNS_3113A") AS 
  SELECT FECHA, PERIOD_DURATION, FINS_ID, MME_NAME, TA_ID, FLNS_3113A
FROM FLNS_3113A_HISTORICAL
WHERE FECHA >= (SELECT SYSDATE - 45 FROM DUAL)
;
