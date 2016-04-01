--------------------------------------------------------
--  DDL for View PCOFNS_PS_MULM_MMDU_BH_AUX
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."PCOFNS_PS_MULM_MMDU_BH_AUX" ("FECHA", "PERIOD_DURATION", "FINS_ID", "MME_NAME", "VALOR") AS 
  SELECT FECHA,
       PERIOD_DURATION,
       FINS_ID,
       MME_NAME,
       VALOR
  FROM (
        SELECT STUB.FECHA,
               STUB.PERIOD_DURATION,
               STUB.FINS_ID,
               STUB.MME_NAME,
               STUB.EPS_MMDU_EMM_REG_MAX VALOR,
               ROW_NUMBER() OVER (PARTITION BY TRUNC(STUB.FECHA),
                                               STUB.PERIOD_DURATION,
                                               STUB.FINS_ID,
                                               STUB.MME_NAME
                                      ORDER BY (STUB.EPS_MMDU_EMM_REG_MAX) DESC,
                                               STUB.FECHA DESC) SEQNUM
        FROM (
                SELECT FLNS.PERIOD_START_TIME AS FECHA, FLNS.PERIOD_DURATION, FLNS.FINS_ID, MO.MME_NAME, FLNS.EPS_MMDU_EMM_REG_MAX
                FROM (
                    SELECT PERIOD_START_TIME, PERIOD_DURATION, FINS_ID, SUM(EPS_MMDU_EMM_REG_MAX) AS EPS_MMDU_EMM_REG_MAX
                    FROM PCOFNS_PS_MULM_MMDU_RAW
                    GROUP BY PERIOD_START_TIME, PERIOD_DURATION, FINS_ID
                ) FLNS
                INNER JOIN (
                    SELECT SGSN_NAME AS MME_NAME,SGSN_ID FROM VW_SGSN_OBJECTS
                    WHERE VALID_FINISH_DATE > SYSDATE
                ) MO
                ON  MO.SGSN_ID = FLNS.FINS_ID
             ) STUB
       )
WHERE SEQNUM = 1
;
