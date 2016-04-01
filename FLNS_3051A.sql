--------------------------------------------------------
--  DDL for View FLNS_3051A
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."FLNS_3051A" ("FECHA", "PERIOD_DURATION", "FINS_ID", "MME_NAME", "UNIT_ID", "COMP_AVERAGE_LOAD", "COMP_PEAK_LOAD_PERCENT") AS 
  SELECT FECHA, PERIOD_DURATION, FINS_ID, MME_NAME, UNIT_ID, COMP_AVERAGE_LOAD, COMP_PEAK_LOAD_PERCENT
FROM FLNS_3051A_HISTORICAL
WHERE FECHA >= (SELECT SYSDATE - 45 FROM DUAL)
;
