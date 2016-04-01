--------------------------------------------------------
--  DDL for View FLNS_3112A
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."FLNS_3112A" ("FECHA", "PERIOD_DURATION", "FINS_ID", "MME_NAME", "TA_ID", "FLNS_3112A") AS 
  SELECT FECHA, PERIOD_DURATION, FINS_ID, MME_NAME, TA_ID, FLNS_3112A
FROM FLNS_3112A_HISTORICAL
WHERE FECHA >= (SELECT SYSDATE - 45 FROM DUAL)
;
