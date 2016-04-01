--------------------------------------------------------
--  DDL for View LTE_140B_HOUR
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."LTE_140B_HOUR" ("FECHA", "CO_NAME", "INT_ID", "LTE_140B_NUM", "LTE_140B_DEN", "LTE_140B", "PUSCH_TRANS_NACK_MCS0", "PUSCH_TRANS_NACK_MCS1", "PUSCH_TRANS_NACK_MCS2", "PUSCH_TRANS_NACK_MCS3", "PUSCH_TRANS_NACK_MCS4", "PUSCH_TRANS_NACK_MCS5", "PUSCH_TRANS_NACK_MCS6", "PUSCH_TRANS_NACK_MCS7", "PUSCH_TRANS_NACK_MCS8", "PUSCH_TRANS_NACK_MCS9", "PUSCH_TRANS_NACK_MCS10", "PUSCH_TRANS_NACK_MCS11", "PUSCH_TRANS_NACK_MCS12", "PUSCH_TRANS_NACK_MCS13", "PUSCH_TRANS_NACK_MCS14", "PUSCH_TRANS_NACK_MCS15", "PUSCH_TRANS_NACK_MCS16", "PUSCH_TRANS_NACK_MCS17", "PUSCH_TRANS_NACK_MCS18", "PUSCH_TRANS_NACK_MCS19", "PUSCH_TRANS_NACK_MCS20", "PUSCH_TRANS_NACK_MCS21", "PUSCH_TRANS_NACK_MCS22", "PUSCH_TRANS_NACK_MCS23", "PUSCH_TRANS_NACK_MCS24", "PUSCH_TRANS_NACK_MCS25", "PUSCH_TRANS_NACK_MCS26", "PUSCH_TRANS_NACK_MCS27", "PUSCH_TRANS_NACK_MCS28", "PUSCH_TRANS_USING_MCS0", "PUSCH_TRANS_USING_MCS1", "PUSCH_TRANS_USING_MCS2", "PUSCH_TRANS_USING_MCS3", "PUSCH_TRANS_USING_MCS4", "PUSCH_TRANS_USING_MCS5", "PUSCH_TRANS_USING_MCS6", "PUSCH_TRANS_USING_MCS7", "PUSCH_TRANS_USING_MCS8", "PUSCH_TRANS_USING_MCS9", "PUSCH_TRANS_USING_MCS10", "PUSCH_TRANS_USING_MCS11", "PUSCH_TRANS_USING_MCS12", "PUSCH_TRANS_USING_MCS13", "PUSCH_TRANS_USING_MCS14", "PUSCH_TRANS_USING_MCS15", "PUSCH_TRANS_USING_MCS16", "PUSCH_TRANS_USING_MCS17", "PUSCH_TRANS_USING_MCS18", "PUSCH_TRANS_USING_MCS19", "PUSCH_TRANS_USING_MCS20", "PUSCH_TRANS_USING_MCS21", "PUSCH_TRANS_USING_MCS22", "PUSCH_TRANS_USING_MCS23", "PUSCH_TRANS_USING_MCS24", "PUSCH_TRANS_USING_MCS25", "PUSCH_TRANS_USING_MCS26", "PUSCH_TRANS_USING_MCS27", "PUSCH_TRANS_USING_MCS28") AS 
  SELECT TO_DATE(SUBSTR( TO_CHAR( FECHA, 'DD/MM/RRRR HH24:MI'), 0, 13),'DD/MM/YYYY HH24:MI') AS FECHA,
    CO_NAME, INT_ID,
    SUM(LTE_140B_NUM) AS LTE_140B_NUM,
    SUM(LTE_140B_DEN) AS LTE_140B_DEN,
    ROUND ( DECODE(SUM(LTE_140B_DEN), 0, 0, SUM(LTE_140B_NUM) / SUM(LTE_140B_DEN)) *100 ,2) AS LTE_140B,
        SUM(PUSCH_TRANS_NACK_MCS0) AS PUSCH_TRANS_NACK_MCS0,
        SUM(PUSCH_TRANS_NACK_MCS1) AS PUSCH_TRANS_NACK_MCS1,
        SUM(PUSCH_TRANS_NACK_MCS2) AS PUSCH_TRANS_NACK_MCS2,
        SUM(PUSCH_TRANS_NACK_MCS3) AS PUSCH_TRANS_NACK_MCS3,
        SUM(PUSCH_TRANS_NACK_MCS4) AS PUSCH_TRANS_NACK_MCS4,
        SUM(PUSCH_TRANS_NACK_MCS5) AS PUSCH_TRANS_NACK_MCS5,
        SUM(PUSCH_TRANS_NACK_MCS6) AS PUSCH_TRANS_NACK_MCS6,
        SUM(PUSCH_TRANS_NACK_MCS7) AS PUSCH_TRANS_NACK_MCS7,
        SUM(PUSCH_TRANS_NACK_MCS8) AS PUSCH_TRANS_NACK_MCS8,
        SUM(PUSCH_TRANS_NACK_MCS9) AS PUSCH_TRANS_NACK_MCS9,
        SUM(PUSCH_TRANS_NACK_MCS10) AS PUSCH_TRANS_NACK_MCS10,
        SUM(PUSCH_TRANS_NACK_MCS11) AS PUSCH_TRANS_NACK_MCS11,
        SUM(PUSCH_TRANS_NACK_MCS12) AS PUSCH_TRANS_NACK_MCS12,
        SUM(PUSCH_TRANS_NACK_MCS13) AS PUSCH_TRANS_NACK_MCS13,
        SUM(PUSCH_TRANS_NACK_MCS14) AS PUSCH_TRANS_NACK_MCS14,
        SUM(PUSCH_TRANS_NACK_MCS15) AS PUSCH_TRANS_NACK_MCS15,
        SUM(PUSCH_TRANS_NACK_MCS16) AS PUSCH_TRANS_NACK_MCS16,
        SUM(PUSCH_TRANS_NACK_MCS17) AS PUSCH_TRANS_NACK_MCS17,
        SUM(PUSCH_TRANS_NACK_MCS18) AS PUSCH_TRANS_NACK_MCS18,
        SUM(PUSCH_TRANS_NACK_MCS19) AS PUSCH_TRANS_NACK_MCS19,
        SUM(PUSCH_TRANS_NACK_MCS20) AS PUSCH_TRANS_NACK_MCS20,
        SUM(PUSCH_TRANS_NACK_MCS21) AS PUSCH_TRANS_NACK_MCS21,
        SUM(PUSCH_TRANS_NACK_MCS22) AS PUSCH_TRANS_NACK_MCS22,
        SUM(PUSCH_TRANS_NACK_MCS23) AS PUSCH_TRANS_NACK_MCS23,
        SUM(PUSCH_TRANS_NACK_MCS24) AS PUSCH_TRANS_NACK_MCS24,
        SUM(PUSCH_TRANS_NACK_MCS25) AS PUSCH_TRANS_NACK_MCS25,
        SUM(PUSCH_TRANS_NACK_MCS26) AS PUSCH_TRANS_NACK_MCS26,
        SUM(PUSCH_TRANS_NACK_MCS27) AS PUSCH_TRANS_NACK_MCS27,
        SUM(PUSCH_TRANS_NACK_MCS28) AS PUSCH_TRANS_NACK_MCS28,
        SUM(PUSCH_TRANS_USING_MCS0) AS PUSCH_TRANS_USING_MCS0,
        SUM(PUSCH_TRANS_USING_MCS1) AS PUSCH_TRANS_USING_MCS1,
        SUM(PUSCH_TRANS_USING_MCS2) AS PUSCH_TRANS_USING_MCS2,
        SUM(PUSCH_TRANS_USING_MCS3) AS PUSCH_TRANS_USING_MCS3,
        SUM(PUSCH_TRANS_USING_MCS4) AS PUSCH_TRANS_USING_MCS4,
        SUM(PUSCH_TRANS_USING_MCS5) AS PUSCH_TRANS_USING_MCS5,
        SUM(PUSCH_TRANS_USING_MCS6) AS PUSCH_TRANS_USING_MCS6,
        SUM(PUSCH_TRANS_USING_MCS7) AS PUSCH_TRANS_USING_MCS7,
        SUM(PUSCH_TRANS_USING_MCS8) AS PUSCH_TRANS_USING_MCS8,
        SUM(PUSCH_TRANS_USING_MCS9) AS PUSCH_TRANS_USING_MCS9,
        SUM(PUSCH_TRANS_USING_MCS10) AS PUSCH_TRANS_USING_MCS10,
        SUM(PUSCH_TRANS_USING_MCS11) AS PUSCH_TRANS_USING_MCS11,
        SUM(PUSCH_TRANS_USING_MCS12) AS PUSCH_TRANS_USING_MCS12,
        SUM(PUSCH_TRANS_USING_MCS13) AS PUSCH_TRANS_USING_MCS13,
        SUM(PUSCH_TRANS_USING_MCS14) AS PUSCH_TRANS_USING_MCS14,
        SUM(PUSCH_TRANS_USING_MCS15) AS PUSCH_TRANS_USING_MCS15,
        SUM(PUSCH_TRANS_USING_MCS16) AS PUSCH_TRANS_USING_MCS16,
        SUM(PUSCH_TRANS_USING_MCS17) AS PUSCH_TRANS_USING_MCS17,
        SUM(PUSCH_TRANS_USING_MCS18) AS PUSCH_TRANS_USING_MCS18,
        SUM(PUSCH_TRANS_USING_MCS19) AS PUSCH_TRANS_USING_MCS19,
        SUM(PUSCH_TRANS_USING_MCS20) AS PUSCH_TRANS_USING_MCS20,
        SUM(PUSCH_TRANS_USING_MCS21) AS PUSCH_TRANS_USING_MCS21,
        SUM(PUSCH_TRANS_USING_MCS22) AS PUSCH_TRANS_USING_MCS22,
        SUM(PUSCH_TRANS_USING_MCS23) AS PUSCH_TRANS_USING_MCS23,
        SUM(PUSCH_TRANS_USING_MCS24) AS PUSCH_TRANS_USING_MCS24,
        SUM(PUSCH_TRANS_USING_MCS25) AS PUSCH_TRANS_USING_MCS25,
        SUM(PUSCH_TRANS_USING_MCS26) AS PUSCH_TRANS_USING_MCS26,
        SUM(PUSCH_TRANS_USING_MCS27) AS PUSCH_TRANS_USING_MCS27,
        SUM(PUSCH_TRANS_USING_MCS28) AS PUSCH_TRANS_USING_MCS28
FROM LTE_140B
GROUP BY TO_DATE(SUBSTR( TO_CHAR( FECHA, 'DD/MM/RRRR HH24:MI'), 0, 13),'DD/MM/YYYY HH24:MI') , INT_ID,CO_NAME
;
