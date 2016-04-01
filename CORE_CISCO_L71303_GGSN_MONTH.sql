--------------------------------------------------------
--  DDL for View CORE_CISCO_L71303_GGSN_MONTH
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."CORE_CISCO_L71303_GGSN_MONTH" ("FECHA", "GWNAME", "SERVID", "SERVNAME", "DOWNLINK_THROUGHPUT") AS 
  SELECT TRUNC( FECHA  , 'MONTH') AS FECHA, GWNAME, SERVID, SERVNAME, ROUND (AVG(DOWNLINK_THROUGHPUT), 2) AS DOWNLINK_THROUGHPUT
FROM CORE_CISCO_L71303_GGSN_HIST
GROUP BY  GWNAME, SERVID, SERVNAME, TRUNC( FECHA  , 'MONTH')
;
