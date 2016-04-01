--------------------------------------------------------
--  DDL for View NOKLTE_PS_LPQDL_MNC1_VW
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."NOKLTE_PS_LPQDL_MNC1_VW" ("MRBTS_ID", "LNBTS_ID", "LNCEL_ID", "MCC_ID", "MNC_ID", "PERIOD_START_TIME", "PERIOD_DURATION", "PERIOD_DURATION_SUM", "UE_REP_CQI_LEVEL_00", "UE_REP_CQI_LEVEL_01", "UE_REP_CQI_LEVEL_02", "UE_REP_CQI_LEVEL_03", "UE_REP_CQI_LEVEL_04", "UE_REP_CQI_LEVEL_05", "UE_REP_CQI_LEVEL_06", "UE_REP_CQI_LEVEL_07", "UE_REP_CQI_LEVEL_08", "UE_REP_CQI_LEVEL_09", "UE_REP_CQI_LEVEL_10", "UE_REP_CQI_LEVEL_11", "UE_REP_CQI_LEVEL_12", "UE_REP_CQI_LEVEL_13", "UE_REP_CQI_LEVEL_14", "UE_REP_CQI_LEVEL_15", "CQI_OFF_MIN", "CQI_OFF_MAX", "CQI_OFF_MEAN", "MIMO_OL_DIV", "MIMO_OL_SM", "MIMO_CL_1CW", "MIMO_CL_2CW", "MIMO_SWITCH_OL", "MIMO_SWITCH_CL", "PDCCH_ALLOC_PDSCH_HARQ", "PDCCH_ALLOC_PDSCH_HARQ_NO_RES", "TM8_DUAL_BF_MODE", "TM8_SINGLE_BF_MODE", "TM8_TXDIV_MODE", "TM8_DUAL_USER_SINGLE_BF_MODE") AS 
  SELECT
F_LTE_GET_GID(3130,LNCEL,LNBTS,MRBTS,NULL,'MRBTS_ID')                                MRBTS_ID,
F_LTE_GET_GID(3130,LNCEL,LNBTS,MRBTS,NULL,'LNBTS_ID')                                LNBTS_ID,
F_LTE_GET_GID(3130,LNCEL,LNBTS,MRBTS,NULL,'LNCEL_ID')                                LNCEL_ID,
MCC                                                                                  MCC_ID,
MNC                                                                                  MNC_ID,
CAST(startTime AS DATE)                                                              PERIOD_START_TIME,
interval                                                                             PERIOD_DURATION,
interval                                                                             PERIOD_DURATION_SUM,
M8010C36                                                                             UE_REP_CQI_LEVEL_00,
M8010C37                                                                             UE_REP_CQI_LEVEL_01,
M8010C38                                                                             UE_REP_CQI_LEVEL_02,
M8010C39                                                                             UE_REP_CQI_LEVEL_03,
M8010C40                                                                             UE_REP_CQI_LEVEL_04,
M8010C41                                                                             UE_REP_CQI_LEVEL_05,
M8010C42                                                                             UE_REP_CQI_LEVEL_06,
M8010C43                                                                             UE_REP_CQI_LEVEL_07,
M8010C44                                                                             UE_REP_CQI_LEVEL_08,
M8010C45                                                                             UE_REP_CQI_LEVEL_09,
M8010C46                                                                             UE_REP_CQI_LEVEL_10,
M8010C47                                                                             UE_REP_CQI_LEVEL_11,
M8010C48                                                                             UE_REP_CQI_LEVEL_12,
M8010C49                                                                             UE_REP_CQI_LEVEL_13,
M8010C50                                                                             UE_REP_CQI_LEVEL_14,
M8010C51                                                                             UE_REP_CQI_LEVEL_15,
M8010C52                                                                             CQI_OFF_MIN,
M8010C53                                                                             CQI_OFF_MAX,
M8010C54                                                                             CQI_OFF_MEAN,
M8010C55                                                                             MIMO_OL_DIV,
M8010C56                                                                             MIMO_OL_SM,
M8010C57                                                                             MIMO_CL_1CW,
M8010C58                                                                             MIMO_CL_2CW,
M8010C59                                                                             MIMO_SWITCH_OL,
M8010C60                                                                             MIMO_SWITCH_CL,
M8010C61                                                                             PDCCH_ALLOC_PDSCH_HARQ,
M8010C62                                                                             PDCCH_ALLOC_PDSCH_HARQ_NO_RES,
NULL                                                                                 TM8_DUAL_BF_MODE,
NULL                                                                                 TM8_SINGLE_BF_MODE,
NULL                                                                                 TM8_TXDIV_MODE,
NULL                                                                                 TM8_DUAL_USER_SINGLE_BF_MODE


FROM LTE_C_NSN_LPQDL_MNC1_AUX
;
