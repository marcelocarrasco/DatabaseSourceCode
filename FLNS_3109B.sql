--------------------------------------------------------
--  DDL for View FLNS_3109B
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."FLNS_3109B" ("FECHA", "PERIOD_DURATION", "FINS_ID", "MME_NAME", "FLNS_3109B") AS 
  SELECT FECHA, PERIOD_DURATION, FINS_ID, MME_NAME,  FLNS_3109B
FROM FLNS_3109B_HISTORICAL
WHERE FECHA >= (SELECT SYSDATE - 45 FROM DUAL)
;
