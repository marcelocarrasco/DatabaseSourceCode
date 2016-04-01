--------------------------------------------------------
--  DDL for View NOKLTE_PS_LCELLT_MNC1_VW
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."NOKLTE_PS_LCELLT_MNC1_VW" ("MRBTS_ID", "LNBTS_ID", "LNCEL_ID", "MCC_ID", "MNC_ID", "PERIOD_START_TIME", "PERIOD_DURATION", "PERIOD_DURATION_SUM", "RLC_SDU_VOL_DL_DCCH", "RLC_SDU_VOL_UL_DCCH", "RLC_PDU_VOL_RECEIVED", "RLC_PDU_VOL_TRANSMITTED", "PDCP_SDU_VOL_UL", "PDCP_SDU_VOL_DL", "PDCP_DATA_RATE_MIN_UL", "PDCP_DATA_RATE_MAX_UL", "PDCP_DATA_RATE_MEAN_UL", "PDCP_DATA_RATE_MIN_DL", "PDCP_DATA_RATE_MAX_DL", "PDCP_DATA_RATE_MEAN_DL", "TB_VOL_PDSCH_MCS0", "TB_VOL_PDSCH_MCS1", "TB_VOL_PDSCH_MCS2", "TB_VOL_PDSCH_MCS3", "TB_VOL_PDSCH_MCS4", "TB_VOL_PDSCH_MCS5", "TB_VOL_PDSCH_MCS6", "TB_VOL_PDSCH_MCS7", "TB_VOL_PDSCH_MCS8", "TB_VOL_PDSCH_MCS9", "TB_VOL_PDSCH_MCS10", "TB_VOL_PDSCH_MCS11", "TB_VOL_PDSCH_MCS12", "TB_VOL_PDSCH_MCS13", "TB_VOL_PDSCH_MCS14", "TB_VOL_PDSCH_MCS15", "TB_VOL_PDSCH_MCS16", "TB_VOL_PDSCH_MCS17", "TB_VOL_PDSCH_MCS18", "TB_VOL_PDSCH_MCS19", "TB_VOL_PDSCH_MCS20", "TB_VOL_PUSCH_MCS0", "TB_VOL_PUSCH_MCS1", "TB_VOL_PUSCH_MCS2", "TB_VOL_PUSCH_MCS3", "TB_VOL_PUSCH_MCS4", "TB_VOL_PUSCH_MCS5", "TB_VOL_PUSCH_MCS6", "TB_VOL_PUSCH_MCS7", "TB_VOL_PUSCH_MCS8", "TB_VOL_PUSCH_MCS9", "TB_VOL_PUSCH_MCS10", "TB_VOL_PUSCH_MCS11", "TB_VOL_PUSCH_MCS12", "TB_VOL_PUSCH_MCS13", "TB_VOL_PUSCH_MCS14", "TB_VOL_PUSCH_MCS15", "TB_VOL_PUSCH_MCS16", "TB_VOL_PUSCH_MCS17", "TB_VOL_PUSCH_MCS18", "TB_VOL_PUSCH_MCS19", "TB_VOL_PUSCH_MCS20", "MAC_SDU_VOL_UL_CCCH", "MAC_SDU_VOL_UL_DCCH", "MAC_SDU_VOL_UL_DTCH", "MAC_SDU_VOL_BCCH", "MAC_SDU_VOL_PCCH", "MAC_SDU_VOL_DL_CCCH", "MAC_SDU_VOL_DL_DCCH", "MAC_SDU_VOL_DL_DTCH", "RRC_UL_VOL", "RRC_DL_VOL", "RLC_SDU_VOL_UL_DTCH", "RLC_SDU_VOL_DL_DTCH", "TB_VOL_PDSCH_MCS21", "TB_VOL_PDSCH_MCS22", "TB_VOL_PDSCH_MCS23", "TB_VOL_PDSCH_MCS24", "TB_VOL_PDSCH_MCS25", "TB_VOL_PDSCH_MCS26", "TB_VOL_PDSCH_MCS27", "TB_VOL_PDSCH_MCS28", "VOL_ORIG_TRANS_DL_SCH_TB", "VOL_RE_REC_UL_SCH_TB", "VOL_RE_TRANS_DL_SCH_TB", "VOL_ORIG_REC_UL_SCH_TB", "PDCP_DATA_RATE_MEAN_UL_QCI_1", "PDCP_DATA_RATE_MEAN_DL_QCI_1", "TB_VOL_PUSCH_MCS21", "TB_VOL_PUSCH_MCS22", "TB_VOL_PUSCH_MCS23", "TB_VOL_PUSCH_MCS24", "TB_VOL_PDSCH_MCS29", "TB_VOL_PDSCH_MCS30", "TB_VOL_PDSCH_MCS31", "RLC_PDU_DL_VOL_CA_SCELL", "ACTIVE_TTI_UL", "ACTIVE_TTI_DL", "IP_TPUT_VOL_UL_QCI_1", "IP_TPUT_TIME_UL_QCI_1", "IP_TPUT_VOL_UL_QCI_2", "IP_TPUT_TIME_UL_QCI_2", "IP_TPUT_VOL_UL_QCI_3", "IP_TPUT_TIME_UL_QCI_3", "IP_TPUT_VOL_UL_QCI_4", "IP_TPUT_TIME_UL_QCI_4", "IP_TPUT_VOL_UL_QCI_5", "IP_TPUT_TIME_UL_QCI_5", "IP_TPUT_VOL_UL_QCI_6", "IP_TPUT_TIME_UL_QCI_6", "IP_TPUT_VOL_UL_QCI_7", "IP_TPUT_TIME_UL_QCI_7", "IP_TPUT_VOL_UL_QCI_8", "IP_TPUT_TIME_UL_QCI_8", "IP_TPUT_VOL_UL_QCI_9", "IP_TPUT_TIME_UL_QCI_9", "IP_TPUT_VOL_DL_QCI_1", "IP_TPUT_TIME_DL_QCI_1", "IP_TPUT_VOL_DL_QCI_2", "IP_TPUT_TIME_DL_QCI_2", "IP_TPUT_VOL_DL_QCI_3", "IP_TPUT_TIME_DL_QCI_3", "IP_TPUT_VOL_DL_QCI_4", "IP_TPUT_TIME_DL_QCI_4", "IP_TPUT_VOL_DL_QCI_5", "IP_TPUT_TIME_DL_QCI_5", "IP_TPUT_VOL_DL_QCI_6", "IP_TPUT_TIME_DL_QCI_6", "IP_TPUT_VOL_DL_QCI_7", "IP_TPUT_TIME_DL_QCI_7", "IP_TPUT_VOL_DL_QCI_8", "IP_TPUT_TIME_DL_QCI_8", "IP_TPUT_VOL_DL_QCI_9", "IP_TPUT_TIME_DL_QCI_9") AS 
  SELECT
F_LTE_GET_GID(3130,LNCEL,LNBTS,MRBTS,NULL,'MRBTS_ID')           MRBTS_ID,
F_LTE_GET_GID(3130,LNCEL,LNBTS,MRBTS,NULL,'LNBTS_ID')           LNBTS_ID,
F_LTE_GET_GID(3130,LNCEL,LNBTS,MRBTS,NULL,'LNCEL_ID')           LNCEL_ID,
MCC                                                             MCC_ID,
MNC                                                             MNC_ID,
CAST(startTime AS DATE)                                         PERIOD_START_TIME,
interval                                                        PERIOD_DURATION,
interval                                                        PERIOD_DURATION_SUM,
M8012C12                                                        RLC_SDU_VOL_DL_DCCH,
M8012C16                                                        RLC_SDU_VOL_UL_DCCH,
M8012C17                                                        RLC_PDU_VOL_RECEIVED,
M8012C18                                                        RLC_PDU_VOL_TRANSMITTED,
M8012C19                                                        PDCP_SDU_VOL_UL,
M8012C20                                                        PDCP_SDU_VOL_DL,
M8012C21                                                        PDCP_DATA_RATE_MIN_UL,
M8012C22                                                        PDCP_DATA_RATE_MAX_UL,
M8012C23                                                        PDCP_DATA_RATE_MEAN_UL,
M8012C24                                                        PDCP_DATA_RATE_MIN_DL,
M8012C25                                                        PDCP_DATA_RATE_MAX_DL,
M8012C26                                                        PDCP_DATA_RATE_MEAN_DL,
M8012C27                                                        TB_VOL_PDSCH_MCS0,
M8012C28                                                        TB_VOL_PDSCH_MCS1,
M8012C29                                                        TB_VOL_PDSCH_MCS2,
M8012C30                                                        TB_VOL_PDSCH_MCS3,
M8012C31                                                        TB_VOL_PDSCH_MCS4,
M8012C32                                                        TB_VOL_PDSCH_MCS5,
M8012C33                                                        TB_VOL_PDSCH_MCS6,
M8012C34                                                        TB_VOL_PDSCH_MCS7,
M8012C35                                                        TB_VOL_PDSCH_MCS8,
M8012C36                                                        TB_VOL_PDSCH_MCS9,
M8012C37                                                        TB_VOL_PDSCH_MCS10,
M8012C38                                                        TB_VOL_PDSCH_MCS11,
M8012C39                                                        TB_VOL_PDSCH_MCS12,
M8012C40                                                        TB_VOL_PDSCH_MCS13,
M8012C41                                                        TB_VOL_PDSCH_MCS14,
M8012C42                                                        TB_VOL_PDSCH_MCS15,
M8012C43                                                        TB_VOL_PDSCH_MCS16,
M8012C44                                                        TB_VOL_PDSCH_MCS17,
M8012C45                                                        TB_VOL_PDSCH_MCS18,
M8012C46                                                        TB_VOL_PDSCH_MCS19,
M8012C47                                                        TB_VOL_PDSCH_MCS20,
M8012C48                                                        TB_VOL_PUSCH_MCS0,
M8012C49                                                        TB_VOL_PUSCH_MCS1,
M8012C50                                                        TB_VOL_PUSCH_MCS2,
M8012C51                                                        TB_VOL_PUSCH_MCS3,
M8012C52                                                        TB_VOL_PUSCH_MCS4,
M8012C53                                                        TB_VOL_PUSCH_MCS5,
M8012C54                                                        TB_VOL_PUSCH_MCS6,
M8012C55                                                        TB_VOL_PUSCH_MCS7,
M8012C56                                                        TB_VOL_PUSCH_MCS8,
M8012C57                                                        TB_VOL_PUSCH_MCS9,
M8012C58                                                        TB_VOL_PUSCH_MCS10,
M8012C59                                                        TB_VOL_PUSCH_MCS11,
M8012C60                                                        TB_VOL_PUSCH_MCS12,
M8012C61                                                        TB_VOL_PUSCH_MCS13,
M8012C62                                                        TB_VOL_PUSCH_MCS14,
M8012C63                                                        TB_VOL_PUSCH_MCS15,
M8012C64                                                        TB_VOL_PUSCH_MCS16,
M8012C65                                                        TB_VOL_PUSCH_MCS17,
M8012C66                                                        TB_VOL_PUSCH_MCS18,
M8012C67                                                        TB_VOL_PUSCH_MCS19,
M8012C68                                                        TB_VOL_PUSCH_MCS20,
M8012C69                                                        MAC_SDU_VOL_UL_CCCH,
M8012C70                                                        MAC_SDU_VOL_UL_DCCH,
M8012C71                                                        MAC_SDU_VOL_UL_DTCH,
/*M8012C72*/ NULL                                               MAC_SDU_VOL_BCCH,
/*M8012C73 */ NULL                                              MAC_SDU_VOL_PCCH,
M8012C74                                                        MAC_SDU_VOL_DL_CCCH,
M8012C75                                                        MAC_SDU_VOL_DL_DCCH,
M8012C76                                                        MAC_SDU_VOL_DL_DTCH,
M8012C77                                                        RRC_UL_VOL,
M8012C78                                                        RRC_DL_VOL,
M8012C79                                                        RLC_SDU_VOL_UL_DTCH,
M8012C80                                                        RLC_SDU_VOL_DL_DTCH,
M8012C81                                                        TB_VOL_PDSCH_MCS21,
M8012C82                                                        TB_VOL_PDSCH_MCS22,
M8012C83                                                        TB_VOL_PDSCH_MCS23,
M8012C84                                                        TB_VOL_PDSCH_MCS24,
M8012C85                                                        TB_VOL_PDSCH_MCS25,
M8012C86                                                        TB_VOL_PDSCH_MCS26,
M8012C87                                                        TB_VOL_PDSCH_MCS27,
M8012C88                                                        TB_VOL_PDSCH_MCS28,
M8012C0                                                        VOL_ORIG_TRANS_DL_SCH_TB,
M8012C1                                                        VOL_RE_REC_UL_SCH_TB,
M8012C2                                                        VOL_RE_TRANS_DL_SCH_TB,
M8012C3                                                        VOL_ORIG_REC_UL_SCH_TB,
M8012C116                                                        PDCP_DATA_RATE_MEAN_UL_QCI_1,
M8012C143                                                        PDCP_DATA_RATE_MEAN_DL_QCI_1,
M8012C144                                                        TB_VOL_PUSCH_MCS21,
M8012C145                                                        TB_VOL_PUSCH_MCS22,
M8012C146                                                        TB_VOL_PUSCH_MCS23,
M8012C147                                                        TB_VOL_PUSCH_MCS24,
/*M8012C148*/ NULL                                               TB_VOL_PDSCH_MCS29,
/*M8012C149*/ NULL                                               TB_VOL_PDSCH_MCS30,
/*M8012C150*/ NULL                                               TB_VOL_PDSCH_MCS31,
M8012C151                                                        RLC_PDU_DL_VOL_CA_SCELL,
M8012C89                                                        ACTIVE_TTI_UL,
M8012C90                                                        ACTIVE_TTI_DL,
M8012C91                                                        IP_TPUT_VOL_UL_QCI_1,
M8012C92                                                        IP_TPUT_TIME_UL_QCI_1,
M8012C93                                                        IP_TPUT_VOL_UL_QCI_2,
M8012C94                                                        IP_TPUT_TIME_UL_QCI_2,
M8012C95                                                        IP_TPUT_VOL_UL_QCI_3,
M8012C96                                                        IP_TPUT_TIME_UL_QCI_3,
M8012C97                                                        IP_TPUT_VOL_UL_QCI_4,
M8012C98                                                        IP_TPUT_TIME_UL_QCI_4,
M8012C99                                                        IP_TPUT_VOL_UL_QCI_5,
M8012C100                                                        IP_TPUT_TIME_UL_QCI_5,
M8012C101                                                        IP_TPUT_VOL_UL_QCI_6,
M8012C102                                                        IP_TPUT_TIME_UL_QCI_6,
M8012C103                                                        IP_TPUT_VOL_UL_QCI_7,
M8012C104                                                        IP_TPUT_TIME_UL_QCI_7,
M8012C105                                                        IP_TPUT_VOL_UL_QCI_8,
M8012C106                                                        IP_TPUT_TIME_UL_QCI_8,
M8012C107                                                        IP_TPUT_VOL_UL_QCI_9,
M8012C108                                                        IP_TPUT_TIME_UL_QCI_9,
M8012C117                                                        IP_TPUT_VOL_DL_QCI_1,
M8012C118                                                        IP_TPUT_TIME_DL_QCI_1,
M8012C119                                                        IP_TPUT_VOL_DL_QCI_2,
M8012C120                                                        IP_TPUT_TIME_DL_QCI_2,
M8012C121                                                        IP_TPUT_VOL_DL_QCI_3,
M8012C122                                                        IP_TPUT_TIME_DL_QCI_3,
M8012C123                                                        IP_TPUT_VOL_DL_QCI_4,
M8012C124                                                        IP_TPUT_TIME_DL_QCI_4,
M8012C125                                                        IP_TPUT_VOL_DL_QCI_5,
M8012C126                                                        IP_TPUT_TIME_DL_QCI_5,
M8012C127                                                        IP_TPUT_VOL_DL_QCI_6,
M8012C128                                                        IP_TPUT_TIME_DL_QCI_6,
M8012C129                                                        IP_TPUT_VOL_DL_QCI_7,
M8012C130                                                        IP_TPUT_TIME_DL_QCI_7,
M8012C131                                                        IP_TPUT_VOL_DL_QCI_8,
M8012C132                                                        IP_TPUT_TIME_DL_QCI_8,
M8012C133                                                        IP_TPUT_VOL_DL_QCI_9,
M8012C134                                                        IP_TPUT_TIME_DL_QCI_9


FROM LTE_C_NSN_LCELLT_MNC1_AUX
;
