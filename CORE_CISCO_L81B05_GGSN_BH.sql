--------------------------------------------------------
--  DDL for View CORE_CISCO_L81B05_GGSN_BH
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."CORE_CISCO_L81B05_GGSN_BH" ("FECHA", "GWNAME", "SERVID", "SERVNAME", "DPCA_NUM_OF_CCAI_TIMEOUTS") AS 
  SELECT hist.FECHA, hist.GWNAME, hist.SERVID, hist.SERVNAME, hist.DPCA_NUM_OF_CCAI_TIMEOUTS
FROM (
      SELECT TRUNC(FECHA, 'HH24') AS FECHA, GWNAME, SERVID, SERVNAME,
      ROUND ((DECODE (SUM(DPCAMSGCCR), 0, 0, SUM(DPCACCAITIMEOUT) / SUM(DPCAMSGCCR))),2) as DPCA_NUM_OF_CCAI_TIMEOUTS
      FROM CORE_CISCO_L81B05_GGSN_HIST
      GROUP BY TRUNC(FECHA, 'HH24'), SERVID, GWNAME, SERVNAME
) hist
INNER JOIN L81505_L81513_BH_AUX2 aux
ON hist.FECHA = aux.FECHA
;
