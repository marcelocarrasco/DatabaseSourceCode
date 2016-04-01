--------------------------------------------------------
--  DDL for View LTE_5750A_HISTORICAL
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."LTE_5750A_HISTORICAL" ("FECHA", "CO_NAME", "INT_ID", "LTE_5750A_NUM", "LTE_5750A_DEN", "SAMPLES_CELL_AVAIL", "DENOM_CELL_AVAIL") AS 
  SELECT T1.PERIOD_START_TIME AS FECHA, O1.CO_NAME, O1.CO_GID AS INT_ID,
		SAMPLES_CELL_AVAIL AS LTE_5750A_NUM,
		DENOM_CELL_AVAIL AS LTE_5750A_DEN,
		SAMPLES_CELL_AVAIL,
		DENOM_CELL_AVAIL
FROM NOKLTE_PS_LCELAV_MNC1_RAW@OSSRC3.WORLD T1
INNER JOIN UTP_COMMON_OBJECTS@OSSRC3.WORLD       O1
ON T1.LNCEL_ID = O1.CO_GID
WHERE O1.CO_OC_ID = 3130
AND O1.CO_STATE = 0
;
