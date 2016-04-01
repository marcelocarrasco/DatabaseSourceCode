--------------------------------------------------------
--  DDL for View CSFB_REDIR_CR_ATT
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."CSFB_REDIR_CR_ATT" ("PERIOD_START_TIME", "CO_NAME", "CSFB_REDIR_CR_ATT") AS 
  SELECT PERIOD_START_TIME, CO_NAME, CSFB_REDIR_CR_ATT
FROM CSFB_REDIR_CR_ATT_HISTORICAL
WHERE PERIOD_START_TIME >= (SELECT SYSDATE - 45 FROM DUAL)
;
