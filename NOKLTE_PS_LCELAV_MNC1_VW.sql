--------------------------------------------------------
--  DDL for View NOKLTE_PS_LCELAV_MNC1_VW
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."NOKLTE_PS_LCELAV_MNC1_VW" ("MRBTS_ID", "LNBTS_ID", "LNCEL_ID", "MCC_ID", "MNC_ID", "PERIOD_START_TIME", "PERIOD_DURATION", "PERIOD_DURATION_SUM", "CHNG_TO_CELL_AVAIL", "CHNG_TO_CELL_PLAN_UNAVAIL", "CHNG_TO_CELL_UNPLAN_UNAVAIL", "SAMPLES_CELL_AVAIL", "SAMPLES_CELL_PLAN_UNAVAIL", "SAMPLES_CELL_UNPLAN_UNAVAIL", "DENOM_CELL_AVAIL") AS 
  SELECT
F_LTE_GET_GID(3130,LNCEL,LNBTS,MRBTS,NULL,'MRBTS_ID') AS                             MRBTS_ID,
F_LTE_GET_GID(3130,LNCEL,LNBTS,MRBTS,NULL,'LNBTS_ID') AS                             LNBTS_ID,
F_LTE_GET_GID(3130,LNCEL,LNBTS,MRBTS,NULL,'LNCEL_ID') AS        					           LNCEL_ID,
MCC    										                            AS        				             MCC_ID,
MNC                                                   AS                             MNC_ID,
CAST(startTime AS DATE)									              AS        				             PERIOD_START_TIME,
interval									                            AS        				             PERIOD_DURATION,
interval  									                          AS        					           PERIOD_DURATION_SUM,
M8020C0                                               AS                             CHNG_TO_CELL_AVAIL,
M8020C1                                               AS                             CHNG_TO_CELL_PLAN_UNAVAIL,
M8020C2                                               AS                             CHNG_TO_CELL_UNPLAN_UNAVAIL,
M8020C3                                               AS                             SAMPLES_CELL_AVAIL,
M8020C4                                               AS                             SAMPLES_CELL_PLAN_UNAVAIL,
M8020C5                                               AS                             SAMPLES_CELL_UNPLAN_UNAVAIL,
M8020C6                                               AS                             DENOM_CELL_AVAIL




FROM  LTE_C_NSN_LCELAV_MNC1_AUX
;
