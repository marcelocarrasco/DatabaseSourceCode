--------------------------------------------------------
--  DDL for View PCOFNS_PS_MMMT_TA_CONS_BH_AUX
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."PCOFNS_PS_MMMT_TA_CONS_BH_AUX" ("FECHA", "PERIOD_DURATION", "FINS_ID", "MME_NAME", "VALOR") AS 
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
               STUB.EPS_ATTACH_SUCC VALOR,
               ROW_NUMBER() OVER (PARTITION BY TRUNC(STUB.FECHA),
                                               STUB.PERIOD_DURATION,
                                               STUB.FINS_ID,
                                               STUB.MME_NAME
                                      ORDER BY (EPS_ATTACH_SUCC) DESC,
                                               STUB.FECHA DESC) SEQNUM
        FROM (
                SELECT TRUNC(FECHA, 'HH24') FECHA, PERIOD_DURATION, FINS_ID, MME_NAME, SUM(EPS_ATTACH_SUCC) AS EPS_ATTACH_SUCC
                FROM FLNS_5001A_HISTORICAL
                GROUP BY TRUNC(FECHA, 'HH24')  , PERIOD_DURATION, FINS_ID, MME_NAME
             ) STUB
       )
WHERE SEQNUM = 1
;
