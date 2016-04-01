--------------------------------------------------------
--  DDL for View LTE_5113B_HOUR_COUNTERS
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."LTE_5113B_HOUR_COUNTERS" ("PERIOD_START_TIME", "CO_NAME", "EPS_BEARER_SETUP_COMPLETIONS", "EPS_BEARER_STP_COM_INI_QCI1", "EPS_BEARER_STP_COM_INI_QCI_2", "EPS_BEARER_STP_COM_INI_QCI_3", "EPS_BEARER_STP_COM_INI_QCI_4", "EPS_BEAR_STP_COM_INI_NON_GBR", "EPS_BEARER_SETUP_ATTEMPTS", "EPS_BEARER_STP_ATT_INI_QCI_1", "EPS_BEARER_STP_ATT_INI_QCI_2", "EPS_BEARER_STP_ATT_INI_QCI_3", "EPS_BEARER_STP_ATT_INI_QCI_4", "EPS_BEAR_STP_ATT_INI_NON_GBR") AS 
  SELECT TO_DATE(SUBSTR( TO_CHAR( PERIOD_START_TIME, 'DD/MM/RRRR HH24:MI'), 0, 13),'DD/MM/YYYY HH24:MI') AS PERIOD_START_TIME, CO_NAME,
SUM(EPS_BEARER_SETUP_COMPLETIONS) AS EPS_BEARER_SETUP_COMPLETIONS,
SUM(EPS_BEARER_STP_COM_INI_QCI1) AS EPS_BEARER_STP_COM_INI_QCI1,
SUM(EPS_BEARER_STP_COM_INI_QCI_2) AS EPS_BEARER_STP_COM_INI_QCI_2,
SUM(EPS_BEARER_STP_COM_INI_QCI_3) AS EPS_BEARER_STP_COM_INI_QCI_3,
SUM(EPS_BEARER_STP_COM_INI_QCI_4) AS EPS_BEARER_STP_COM_INI_QCI_4,
SUM(EPS_BEAR_STP_COM_INI_NON_GBR) AS EPS_BEAR_STP_COM_INI_NON_GBR,
SUM(EPS_BEARER_SETUP_ATTEMPTS) AS EPS_BEARER_SETUP_ATTEMPTS,
SUM(EPS_BEARER_STP_ATT_INI_QCI_1) AS EPS_BEARER_STP_ATT_INI_QCI_1,
SUM(EPS_BEARER_STP_ATT_INI_QCI_2) AS EPS_BEARER_STP_ATT_INI_QCI_2,
SUM(EPS_BEARER_STP_ATT_INI_QCI_3) AS EPS_BEARER_STP_ATT_INI_QCI_3,
SUM(EPS_BEARER_STP_ATT_INI_QCI_4) AS EPS_BEARER_STP_ATT_INI_QCI_4,
SUM(EPS_BEAR_STP_ATT_INI_NON_GBR) AS EPS_BEAR_STP_ATT_INI_NON_GBR
FROM NOKLTE_PS_LEPSB_MNC1_RAW@OSSRC3.WORLD T1,
     UTP_COMMON_OBJECTS@OSSRC3       O1
WHERE T1.LNCEL_ID = O1.CO_GID
AND CO_OC_ID = 3130
AND CO_STATE = 0
AND PERIOD_START_TIME >= (SELECT SYSDATE - 45 FROM DUAL)
GROUP BY TO_DATE(SUBSTR( TO_CHAR( PERIOD_START_TIME, 'DD/MM/RRRR HH24:MI'), 0, 13),'DD/MM/YYYY HH24:MI') , CO_NAME
;
