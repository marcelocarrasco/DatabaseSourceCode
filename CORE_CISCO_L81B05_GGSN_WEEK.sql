--------------------------------------------------------
--  DDL for View CORE_CISCO_L81B05_GGSN_WEEK
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."CORE_CISCO_L81B05_GGSN_WEEK" ("FECHA", "GWNAME", "SERVID", "SERVNAME", "DPCA_NUM_OF_CCAI_TIMEOUTS") AS 
  SELECT TRUNC( FECHA, 'DAY') as FECHA, GWNAME,  SERVID, SERVNAME,
ROUND ((DECODE (SUM(DPCAMSGCCR), 0, 0, SUM(DPCACCAITIMEOUT) / SUM(DPCAMSGCCR))),2) as DPCA_NUM_OF_CCAI_TIMEOUTS
FROM CORE_CISCO_L81B05_GGSN_HIST
GROUP BY  TRUNC( FECHA, 'DAY'), SERVID, SERVNAME,  GWNAME
;
