--------------------------------------------------------
--  DDL for View CORE_CISCO_L81B02_GGSN_MONTH
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."CORE_CISCO_L81B02_GGSN_MONTH" ("FECHA", "GWNAME", "SERVID", "SERVNAME", "GX_SESS_TERMINATED") AS 
  SELECT TRUNC( FECHA, 'MONTH') as FECHA, GWNAME,  SERVID, SERVNAME,  SUM(DPCATERM) AS GX_SESS_TERMINATED
FROM CORE_CISCO_L81B02_GGSN_HIST
GROUP BY  TRUNC( FECHA, 'MONTH'), SERVID, SERVNAME,  GWNAME
;
