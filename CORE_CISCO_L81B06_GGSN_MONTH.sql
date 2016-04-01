--------------------------------------------------------
--  DDL for View CORE_CISCO_L81B06_GGSN_MONTH
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."CORE_CISCO_L81B06_GGSN_MONTH" ("FECHA", "GWNAME", "SERVID", "SERVNAME", "DPCA_NUM_OF_CCAU_TIMEOUTS") AS 
  SELECT TRUNC( FECHA, 'MONTH') as FECHA, GWNAME,  SERVID, SERVNAME,
ROUND ((DECODE (SUM(DPCAMSGCCR), 0, 0, SUM(DPCACCAUTIMEOUT) / SUM(DPCAMSGCCR))),2) as DPCA_NUM_OF_CCAU_TIMEOUTS
FROM CORE_CISCO_L81B06_GGSN_HIST
GROUP BY  TRUNC( FECHA, 'MONTH'), SERVID, SERVNAME,  GWNAME
;
