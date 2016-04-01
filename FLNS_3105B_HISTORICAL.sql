--------------------------------------------------------
--  DDL for View FLNS_3105B_HISTORICAL
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."FLNS_3105B_HISTORICAL" ("FECHA", "PERIOD_DURATION", "FINS_ID", "MME_NAME", "TA_ID", "FLNS_3105B") AS 
  SELECT FLNS.PERIOD_START_TIME AS FECHA, FLNS.PERIOD_DURATION, FLNS.FINS_ID, MO.MME_NAME, FLNS.TA_ID, FLNS.FLNS_3105B
FROM (
    SELECT t1.PERIOD_START_TIME, t1.PERIOD_DURATION, t1.FINS_ID, t1.TA_ID,
            SUM(EPS_TO_3G_GN_ISHO_SUCC +
			EPS_TO_3G_GN_ISHO_FAIL +
			EPS_TO_3G_GN_ISHO_TRGT_REJE +
			EPS_TO_3G_GN_ISHO_ENB_CNCL -
			SRVCC_PS_AND_CS_HANDOVER_SUCC -
			SRVCC_PS_AND_CS_HO_3G_FAIL) AS FLNS_3105B
    FROM PCOFNS_PS_MMMT_TA_RAW t1
    INNER JOIN PCOFNS_PS_UMLM_FLEXINS_RAW t2
    ON t1.FINS_ID = t2.FINS_ID
    AND t1.PERIOD_START_TIME = t2.PERIOD_START_TIME
    GROUP BY t1.PERIOD_START_TIME, t1.PERIOD_DURATION, t1.FINS_ID, t1.TA_ID
) FLNS
INNER JOIN (
    SELECT SGSN_NAME AS MME_NAME,SGSN_ID FROM VW_SGSN_OBJECTS
    WHERE VALID_FINISH_DATE > SYSDATE
) MO
ON  MO.SGSN_ID = FLNS.FINS_ID
;
