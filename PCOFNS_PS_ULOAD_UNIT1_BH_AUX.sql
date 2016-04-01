--------------------------------------------------------
--  DDL for View PCOFNS_PS_ULOAD_UNIT1_BH_AUX
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."PCOFNS_PS_ULOAD_UNIT1_BH_AUX" ("FECHA", "PERIOD_DURATION", "FINS_ID", "MME_NAME", "UNIT_ID", "VALOR") AS 
  SELECT FECHA,
       PERIOD_DURATION,
       FINS_ID,
       MME_NAME,
       UNIT_ID,
       VALOR
  FROM (
        SELECT STUB.FECHA,
               STUB.PERIOD_DURATION,
               STUB.FINS_ID,
               STUB.MME_NAME,
               STUB.UNIT_ID,
               STUB.COMP_PEAK_LOAD_PERCENT VALOR,
               ROW_NUMBER() OVER (PARTITION BY TRUNC(STUB.FECHA),
                                               STUB.PERIOD_DURATION,
                                               STUB.FINS_ID,
                                               STUB.MME_NAME,
                                               STUB.UNIT_ID
                                      ORDER BY (COMP_PEAK_LOAD_PERCENT) DESC,
                                               STUB.FECHA DESC) SEQNUM
        FROM (
                SELECT TRUNC(FECHA, 'HH24') FECHA, PERIOD_DURATION, FINS_ID, MME_NAME,UNIT_ID, SUM(COMP_PEAK_LOAD_PERCENT) AS COMP_PEAK_LOAD_PERCENT
                FROM FLNS_3051A_HISTORICAL
                GROUP BY TRUNC(FECHA, 'HH24')  , PERIOD_DURATION, FINS_ID, UNIT_ID,MME_NAME
             ) STUB
       )
WHERE SEQNUM = 1
;
