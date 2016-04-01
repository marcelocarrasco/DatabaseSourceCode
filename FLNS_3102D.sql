--------------------------------------------------------
--  DDL for View FLNS_3102D
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."FLNS_3102D" ("FECHA", "PERIOD_DURATION", "FINS_ID", "MME_NAME", "TA_ID", "FLNS_3102D") AS 
  SELECT FECHA, PERIOD_DURATION, FINS_ID, MME_NAME, TA_ID, FLNS_3102D
FROM FLNS_3102D_HISTORICAL
WHERE FECHA >= (SELECT SYSDATE - 45 FROM DUAL)
;
