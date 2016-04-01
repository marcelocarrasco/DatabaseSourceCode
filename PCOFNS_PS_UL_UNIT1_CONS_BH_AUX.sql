--------------------------------------------------------
--  DDL for View PCOFNS_PS_UL_UNIT1_CONS_BH_AUX
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."PCOFNS_PS_UL_UNIT1_CONS_BH_AUX" ("FECHA", "PERIOD_DURATION", "FINS_ID", "MME_NAME", "VALOR") AS 
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
               STUB.COMP_PEAK_LOAD_PERCENT VALOR,
               ROW_NUMBER() OVER (PARTITION BY TRUNC(STUB.FECHA),
                                               STUB.PERIOD_DURATION,
                                               STUB.FINS_ID,
                                               STUB.MME_NAME
                                      ORDER BY (COMP_PEAK_LOAD_PERCENT) DESC,
                                               STUB.FECHA DESC) SEQNUM
        FROM (
                SELECT TRUNC(FECHA, 'HH24') FECHA, PERIOD_DURATION, FINS_ID, MME_NAME, SUM(COMP_PEAK_LOAD_PERCENT) AS COMP_PEAK_LOAD_PERCENT
                FROM FLNS_3051A_HISTORICAL
                GROUP BY TRUNC(FECHA, 'HH24')  , PERIOD_DURATION, FINS_ID, MME_NAME
             ) STUB
       )
WHERE SEQNUM = 1
;
