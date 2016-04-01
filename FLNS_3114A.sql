--------------------------------------------------------
--  DDL for View FLNS_3114A
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."FLNS_3114A" ("FECHA", "PERIOD_DURATION", "FINS_ID", "MME_NAME", "TA_ID", "FLNS_3114A") AS 
  SELECT FECHA, PERIOD_DURATION, FINS_ID, MME_NAME, TA_ID, FLNS_3114A
FROM FLNS_3114A_HISTORICAL
WHERE FECHA >= (SELECT SYSDATE - 45 FROM DUAL)
;
