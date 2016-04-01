--------------------------------------------------------
--  DDL for View CSFB_REDIR_CR_ATT_HISTORICAL
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."CSFB_REDIR_CR_ATT_HISTORICAL" ("PERIOD_START_TIME", "CO_NAME", "CSFB_REDIR_CR_ATT") AS 
  SELECT T1.PERIOD_START_TIME, O1.CO_NAME, CSFB_REDIR_CR_ATT
FROM NOKLTE_PS_LISHO_MNC1_RAW@OSSRC3 T1,
     UTP_COMMON_OBJECTS@OSSRC3       O1
WHERE T1.LNCEL_ID = O1.CO_GID
AND CO_OC_ID = 3130
AND CO_STATE = 0
;
