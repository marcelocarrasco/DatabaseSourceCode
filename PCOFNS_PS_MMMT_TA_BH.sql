--------------------------------------------------------
--  DDL for View PCOFNS_PS_MMMT_TA_BH
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."PCOFNS_PS_MMMT_TA_BH" () AS 
  SELECT A.*
FROM PCOFNS_PS_MMMT_TA_RAW@OSSRC1.WORLD A
INNER JOIN PCOFNS_PS_MMMT_TA_BH_AUX B
ON A.PERIOD_START_TIME = B.PERIOD_START_TIME
AND A.FINS_ID = B.FINS_ID
AND A.TA_ID = B.TA_ID
;
