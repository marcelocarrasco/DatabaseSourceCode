--------------------------------------------------------
--  DDL for View FLNS_3287A
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."FLNS_3287A" ("FECHA", "PERIOD_DURATION", "FINS_ID", "MME_NAME", "FLNS_3287A") AS 
  SELECT FECHA, PERIOD_DURATION, FINS_ID, MME_NAME, FLNS_3287A
FROM FLNS_3287A_HISTORICAL
WHERE FECHA >= (SELECT SYSDATE - 45 FROM DUAL)
;
