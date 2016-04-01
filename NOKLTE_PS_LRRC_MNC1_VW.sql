--------------------------------------------------------
--  DDL for View NOKLTE_PS_LRRC_MNC1_VW
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."NOKLTE_PS_LRRC_MNC1_VW" ("MRBTS_ID", "LNBTS_ID", "LNCEL_ID", "MCC_ID", "MNC_ID", "PERIOD_START_TIME", "PERIOD_DURATION", "PERIOD_DURATION_SUM", "REJ_RRC_CONN_RE_ESTAB", "DISC_RRC_PAGING", "RRC_PAGING_MESSAGES", "RRC_PAGING_REQUESTS", "RRC_CON_RE_ESTAB_ATT", "RRC_CON_RE_ESTAB_SUCC", "RRC_CON_RE_ESTAB_ATT_HO_FAIL", "RRC_CON_RE_ESTAB_SUCC_HO_FAIL", "RRC_CON_RE_ESTAB_ATT_OTHER", "RRC_CON_RE_ESTAB_SUCC_OTHER", "REPORT_CGI_REQ", "SUCC_CGI_REPORTS", "RRC_CON_REL_REDIR_H_ENB", "RRC_PAGING_ETWS_CMAS") AS 
  SELECT
F_LTE_GET_GID(3130,LNCEL,LNBTS,MRBTS,NULL,'MRBTS_ID')      AS                          MRBTS_ID,
F_LTE_GET_GID(3130,LNCEL,LNBTS,MRBTS,NULL,'LNBTS_ID')      AS                          LNBTS_ID,
F_LTE_GET_GID(3130,LNCEL,LNBTS,MRBTS,NULL,'LNCEL_ID')      AS                          LNCEL_ID,
MCC                                                        AS                          MCC_ID,
MNC                                                        AS                          MNC_ID,
CAST(startTime AS DATE)                                    AS                          PERIOD_START_TIME,
interval                                                   AS                          PERIOD_DURATION,
interval                                                   AS                          PERIOD_DURATION_SUM,
M8008C0                                                    AS                          REJ_RRC_CONN_RE_ESTAB,
M8008C2                                                    AS                          DISC_RRC_PAGING,
M8008C3                                                    AS                          RRC_PAGING_MESSAGES,
M8008C1                                                    AS                          RRC_PAGING_REQUESTS,
M8008C4                                                    AS                          RRC_CON_RE_ESTAB_ATT,
M8008C5                                                    AS                          RRC_CON_RE_ESTAB_SUCC,
M8008C6                                                    AS                          RRC_CON_RE_ESTAB_ATT_HO_FAIL,
M8008C7                                                    AS                          RRC_CON_RE_ESTAB_SUCC_HO_FAIL,
M8008C8                                                    AS                          RRC_CON_RE_ESTAB_ATT_OTHER,
M8008C9                                                    AS                          RRC_CON_RE_ESTAB_SUCC_OTHER,
M8008C10                                                   AS                          REPORT_CGI_REQ,
M8008C11                                                   AS                          SUCC_CGI_REPORTS,
M8008C15                                                   AS                          RRC_CON_REL_REDIR_H_ENB,
M8008C16                                                   AS                          RRC_PAGING_ETWS_CMAS

FROM LTE_C_NSN_LRRC_MNC1_AUX
;
