--------------------------------------------------------
--  DDL for View NOKLTE_PS_LUEST_MNC1_VW
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."NOKLTE_PS_LUEST_MNC1_VW" ("MRBTS_ID", "LNBTS_ID", "LNCEL_ID", "MCC_ID", "MNC_ID", "PERIOD_START_TIME", "PERIOD_DURATION", "PERIOD_DURATION_SUM", "SIGN_CONN_ESTAB_COMP", "SIGN_EST_F_RRCCOMPL_MISSING", "SIGN_EST_F_RRCCOMPL_ERROR", "SIGN_CONN_ESTAB_FAIL_RRMRAC", "EPC_INIT_TO_IDLE_UE_NORM_REL", "EPC_INIT_TO_IDLE_DETACH", "EPC_INIT_TO_IDLE_RNL", "EPC_INIT_TO_IDLE_OTHER", "ENB_INIT_TO_IDLE_NORM_REL", "ENB_INIT_TO_IDLE_RNL", "ENB_INIT_TO_IDLE_OTHER", "SIGN_CONN_ESTAB_ATT_MO_S", "SIGN_CONN_ESTAB_ATT_MT", "SIGN_CONN_ESTAB_ATT_MO_D", "SIGN_CONN_ESTAB_ATT_OTHERS", "SIGN_CONN_ESTAB_ATT_EMG", "SIGN_CONN_ESTAB_COMP_EMG", "SIGN_CONN_ESTAB_FAIL_RB_EMG", "SUBFRAME_DRX_ACTIVE_UE", "SUBFRAME_DRX_SLEEP_UE", "PRE_EMPT_UE_CONTEXT_NON_GBR") AS 
  SELECT
F_LTE_GET_GID(3130,LNCEL,LNBTS,MRBTS,NULL,'MRBTS_ID')      AS                          MRBTS_ID,
F_LTE_GET_GID(3130,LNCEL,LNBTS,MRBTS,NULL,'LNBTS_ID')      AS                          LNBTS_ID,
F_LTE_GET_GID(3130,LNCEL,LNBTS,MRBTS,NULL,'LNCEL_ID')      AS                          LNCEL_ID,
MCC                                                        AS                          MCC_ID,
MNC                                                        AS                          MNC_ID,
CAST(startTime AS DATE)                                    AS                          PERIOD_START_TIME,
interval                                                   AS                          PERIOD_DURATION,
interval                                                   AS                          PERIOD_DURATION_SUM,
M8013C5                                                    AS                          SIGN_CONN_ESTAB_COMP,
M8013C6                                                    AS                          SIGN_EST_F_RRCCOMPL_MISSING,
M8013C7                                                    AS                          SIGN_EST_F_RRCCOMPL_ERROR,
M8013C8                                                    AS                          SIGN_CONN_ESTAB_FAIL_RRMRAC,
M8013C9                                                    AS                          EPC_INIT_TO_IDLE_UE_NORM_REL,
M8013C10                                                   AS                          EPC_INIT_TO_IDLE_DETACH,
M8013C11                                                   AS                          EPC_INIT_TO_IDLE_RNL,
M8013C12                                                   AS                          EPC_INIT_TO_IDLE_OTHER,
M8013C13                                                   AS                          ENB_INIT_TO_IDLE_NORM_REL,
M8013C15                                                   AS                          ENB_INIT_TO_IDLE_RNL,
M8013C16                                                   AS                          ENB_INIT_TO_IDLE_OTHER,
M8013C17                                                   AS                          SIGN_CONN_ESTAB_ATT_MO_S,
M8013C18                                                   AS                          SIGN_CONN_ESTAB_ATT_MT,
M8013C19                                                   AS                          SIGN_CONN_ESTAB_ATT_MO_D,
M8013C20                                                   AS                          SIGN_CONN_ESTAB_ATT_OTHERS,
M8013C21                                                   AS                          SIGN_CONN_ESTAB_ATT_EMG,
M8013C26                                                   AS                          SIGN_CONN_ESTAB_COMP_EMG,
M8013C27                                                   AS                          SIGN_CONN_ESTAB_FAIL_RB_EMG,
M8013C24                                                   AS                          SUBFRAME_DRX_ACTIVE_UE,
M8013C25                                                   AS                          SUBFRAME_DRX_SLEEP_UE,
M8013C28                                                   AS                          PRE_EMPT_UE_CONTEXT_NON_GBR

FROM LTE_C_NSN_LUEST_MNC1_AUX
;
