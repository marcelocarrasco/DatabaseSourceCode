--------------------------------------------------------
--  DDL for View CORE_CISCO_L71301_GGSN_DAY
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."CORE_CISCO_L71301_GGSN_DAY" ("FECHA", "GWNAME", "SERVID", "SERVNAME", "UPLINK_THROUGHPUT") AS 
  SELECT TRUNC( FECHA, 'DD') as FECHA, GWNAME, SERVID, SERVNAME, ROUND (AVG(UPLINK_THROUGHPUT), 2) AS UPLINK_THROUGHPUT
FROM CORE_CISCO_L71301_GGSN_HIST
GROUP BY  TRUNC( FECHA, 'DD'), GWNAME, SERVID, SERVNAME
;
