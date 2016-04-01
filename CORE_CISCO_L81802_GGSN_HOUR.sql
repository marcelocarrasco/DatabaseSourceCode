--------------------------------------------------------
--  DDL for View CORE_CISCO_L81802_GGSN_HOUR
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."CORE_CISCO_L81802_GGSN_HOUR" ("FECHA", "GWNAME", "DIAMETER_CC_UPDATE_SUCC_R") AS 
  SELECT TRUNC(FECHA, 'HH24') as FECHA, GWNAME,
ROUND (((DECODE (SUM(CCMSGCCRUPDATE), 0, 0, SUM(CCMSGCCAUPDATE) / SUM(CCMSGCCRUPDATE)) )*100),2) as DIAMETER_CC_UPDATE_SUCC_R
FROM CORE_CISCO_L81802_GGSN_HIST
WHERE FECHA >= SYSDATE - 45
GROUP BY TRUNC(FECHA, 'HH24'), GWNAME
;
