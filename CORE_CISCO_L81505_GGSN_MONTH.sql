--------------------------------------------------------
--  DDL for View CORE_CISCO_L81505_GGSN_MONTH
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."CORE_CISCO_L81505_GGSN_MONTH" ("FECHA", "GWNAME", "SERVID", "SERVNAME", "UPLINK_THP_MBPS") AS 
  SELECT TRUNC( FECHA  , 'MONTH') AS FECHA, GWNAME, SERVID, SERVNAME, ROUND (AVG(UPLINK_THP_MBPS), 2) AS UPLINK_THP_MBPS
FROM CORE_CISCO_L81505_GGSN_HIST
GROUP BY  GWNAME, SERVID, SERVNAME, TRUNC( FECHA  , 'MONTH')
;
