--------------------------------------------------------
--  DDL for View LTE_5060E_HISTORICAL
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."LTE_5060E_HISTORICAL" ("PERIOD_START_TIME", "CO_NAME", "LTE_5060E_NUM_1", "LTE_5060E_DEN_1", "LTE_5060E_NUM_2", "LTE_5060E_DEN_2") AS 
  SELECT T1.PERIOD_START_TIME, O1.CO_NAME,
		SIGN_CONN_ESTAB_COMP AS  LTE_5060E_NUM_1,
		(SIGN_CONN_ESTAB_ATT_MO_S+SIGN_CONN_ESTAB_ATT_MT+SIGN_CONN_ESTAB_ATT_MO_D+SIGN_CONN_ESTAB_ATT_OTHERS+SIGN_CONN_ESTAB_ATT_EMG) AS LTE_5060E_DEN_1,
		(EPS_BEARER_STP_COM_INI_QCI1+ EPS_BEARER_STP_COM_INI_QCI_2 + EPS_BEARER_STP_COM_INI_QCI_3 + EPS_BEARER_STP_COM_INI_QCI_4 + EPS_BEAR_STP_COM_INI_NON_GBR ) AS LTE_5060E_NUM_2,
		(EPS_BEARER_STP_ATT_INI_QCI_1+ EPS_BEARER_STP_ATT_INI_QCI_2 + EPS_BEARER_STP_ATT_INI_QCI_3 + EPS_BEARER_STP_ATT_INI_QCI_4 + EPS_BEAR_STP_ATT_INI_NON_GBR) AS LTE_5060E_DEN_2
FROM NOKLTE_PS_LUEST_MNC1_RAW@OSSRC3.WORLD T1,
	 NOKLTE_PS_LEPSB_MNC1_RAW@OSSRC3.WORLD T2,
     UTP_COMMON_OBJECTS@OSSRC3       O1
WHERE T1.LNCEL_ID = O1.CO_GID
AND T2.LNCEL_ID = T1.LNCEL_ID
AND T2.PERIOD_START_TIME = T1.PERIOD_START_TIME
AND CO_OC_ID = 3130
AND CO_STATE = 0
;
