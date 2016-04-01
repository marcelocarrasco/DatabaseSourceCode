--------------------------------------------------------
--  DDL for Procedure P_LTE_NSN_PAQ_LCEL_HOUR_INS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HARRIAGUE"."P_LTE_NSN_PAQ_LCEL_HOUR_INS" (P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR)
IS
-- Autor: Paula Fernandez. Fecha: 08.09.2015.
TYPE CUR_TYP IS REF CURSOR;
CUR CUR_TYP;

DML_ERRORS EXCEPTION;
PRAGMA EXCEPTION_INIT(DML_ERRORS, -24381);
    -- LOG --
L_ERRORS NUMBER;
L_ERRNO    NUMBER;
L_MSG    VARCHAR2(4000);
L_IDX    NUMBER;
  -- END LOG --

LIMIT_IN PLS_INTEGER := 100;

TYPE T_ARRAY_TAB IS TABLE OF LTE_NSN_PAQ_LCEL_HOUR%ROWTYPE;
T_ARRAY_COL T_ARRAY_TAB;

 BEGIN
  OPEN CUR FOR

  SELECT  TRUNC(T1.PERIOD_START_TIME, 'HH24')                   AS FECHA,
       T1.MRBTS_ID                                            AS MRBTS_ID,
       T1.LNBTS_ID                                            AS LNBTS_ID,
       T1.LNCEL_ID                                            AS LNCEL_ID,
       NVL(SUM(-120*T1.RSSI_PUSCH_LEVEL_01
       -119*T1.RSSI_PUSCH_LEVEL_02
       -117*T1.RSSI_PUSCH_LEVEL_03
       -115*T1.RSSI_PUSCH_LEVEL_04
       -113*T1.RSSI_PUSCH_LEVEL_05
       -111*T1.RSSI_PUSCH_LEVEL_06
       -109*T1.RSSI_PUSCH_LEVEL_07
       -107*T1.RSSI_PUSCH_LEVEL_08
       -105*T1.RSSI_PUSCH_LEVEL_09
       -103*T1.RSSI_PUSCH_LEVEL_10
       -101*T1.RSSI_PUSCH_LEVEL_11
       -99*T1.RSSI_PUSCH_LEVEL_12
       -97*T1.RSSI_PUSCH_LEVEL_13
       -95*T1.RSSI_PUSCH_LEVEL_14
       -93*T1.RSSI_PUSCH_LEVEL_15
       -91*T1.RSSI_PUSCH_LEVEL_16
       -89*T1.RSSI_PUSCH_LEVEL_17
       -87*T1.RSSI_PUSCH_LEVEL_18
       -85*T1.RSSI_PUSCH_LEVEL_19
       -83*T1.RSSI_PUSCH_LEVEL_20
       -81*T1.RSSI_PUSCH_LEVEL_21
       -80*T1.RSSI_PUSCH_LEVEL_22),0)                         AS  RSSI_PUSCH_UL_NUM,
       NVL(SUM(T1.RSSI_PUSCH_LEVEL_01+
       T1.RSSI_PUSCH_LEVEL_02+
       T1.RSSI_PUSCH_LEVEL_03+
       T1.RSSI_PUSCH_LEVEL_04+
       T1.RSSI_PUSCH_LEVEL_05+
       T1.RSSI_PUSCH_LEVEL_06+
       T1.RSSI_PUSCH_LEVEL_07+
       T1.RSSI_PUSCH_LEVEL_08+
       T1.RSSI_PUSCH_LEVEL_09+
       T1.RSSI_PUSCH_LEVEL_10+
       T1.RSSI_PUSCH_LEVEL_11+
       T1.RSSI_PUSCH_LEVEL_12+
       T1.RSSI_PUSCH_LEVEL_13+
       T1.RSSI_PUSCH_LEVEL_14+
       T1.RSSI_PUSCH_LEVEL_15+
       T1.RSSI_PUSCH_LEVEL_16+
       T1.RSSI_PUSCH_LEVEL_17+
       T1.RSSI_PUSCH_LEVEL_18+
       T1.RSSI_PUSCH_LEVEL_19+
       T1.RSSI_PUSCH_LEVEL_20+
       T1.RSSI_PUSCH_LEVEL_21+
       T1.RSSI_PUSCH_LEVEL_22),0)                             AS RSSI_PUSCH_UL_DEN,
       NVL(SUM (-120*T1.RSSI_PUCCH_LEVEL_01
       -119*T1.RSSI_PUCCH_LEVEL_02
       -117*T1.RSSI_PUCCH_LEVEL_03
       -115*T1.RSSI_PUCCH_LEVEL_04
       -113*T1.RSSI_PUCCH_LEVEL_05
       -111*T1.RSSI_PUCCH_LEVEL_06
       -109*T1.RSSI_PUCCH_LEVEL_07
       -107*T1.RSSI_PUCCH_LEVEL_08
       -105*T1.RSSI_PUCCH_LEVEL_09
       -103*T1.RSSI_PUCCH_LEVEL_10
       -101*T1.RSSI_PUCCH_LEVEL_11
       -99*T1.RSSI_PUCCH_LEVEL_12
       -97*T1.RSSI_PUCCH_LEVEL_13
       -95*T1.RSSI_PUCCH_LEVEL_14
       -93*T1.RSSI_PUCCH_LEVEL_15
       -91*T1.RSSI_PUCCH_LEVEL_16
       -89*T1.RSSI_PUCCH_LEVEL_17
       -87*T1.RSSI_PUCCH_LEVEL_18
       -85*T1.RSSI_PUCCH_LEVEL_19
       -83*T1.RSSI_PUCCH_LEVEL_20
       -81*T1.RSSI_PUCCH_LEVEL_21
       -80*T1.RSSI_PUCCH_LEVEL_22),0)                         AS  RSSI_PUCCH_UL_NUM,
       NVL(SUM (T1.RSSI_PUCCH_LEVEL_01+
       T1.RSSI_PUCCH_LEVEL_02+
       T1.RSSI_PUCCH_LEVEL_03+
       T1.RSSI_PUCCH_LEVEL_04+
       T1.RSSI_PUCCH_LEVEL_05+
       T1.RSSI_PUCCH_LEVEL_06+
       T1.RSSI_PUCCH_LEVEL_07+
       T1.RSSI_PUCCH_LEVEL_08+
       T1.RSSI_PUCCH_LEVEL_09+
       T1.RSSI_PUCCH_LEVEL_10+
       T1.RSSI_PUCCH_LEVEL_11+
       T1.RSSI_PUCCH_LEVEL_12+
       T1.RSSI_PUCCH_LEVEL_13+
       T1.RSSI_PUCCH_LEVEL_14+
       T1.RSSI_PUCCH_LEVEL_15+
       T1.RSSI_PUCCH_LEVEL_16+
       T1.RSSI_PUCCH_LEVEL_17+
       T1.RSSI_PUCCH_LEVEL_18+
       T1.RSSI_PUCCH_LEVEL_19+
       T1.RSSI_PUCCH_LEVEL_20+
       T1.RSSI_PUCCH_LEVEL_21+
       T1.RSSI_PUCCH_LEVEL_22),0)                             AS RSSI_PUCCH_UL_DEN,
       NVL(SUM (-10*T1.SINR_PUSCH_LEVEL_1
       -9*T1.SINR_PUSCH_LEVEL_2
       -7*T1.SINR_PUSCH_LEVEL_3
       -5*T1.SINR_PUSCH_LEVEL_4
       -3*T1.SINR_PUSCH_LEVEL_5
       -1*T1.SINR_PUSCH_LEVEL_6
       +1*T1.SINR_PUSCH_LEVEL_7
       +3*T1.SINR_PUSCH_LEVEL_8
       +5*T1.SINR_PUSCH_LEVEL_9
       +7*T1.SINR_PUSCH_LEVEL_10
       +9*T1.SINR_PUSCH_LEVEL_11
       +11*T1.SINR_PUSCH_LEVEL_12
       +13*T1.SINR_PUSCH_LEVEL_13
       +15*T1.SINR_PUSCH_LEVEL_14
       +17*T1.SINR_PUSCH_LEVEL_15
       +19*T1.SINR_PUSCH_LEVEL_16
       +21*T1.SINR_PUSCH_LEVEL_17
       +23*T1.SINR_PUSCH_LEVEL_18
       +25*T1.SINR_PUSCH_LEVEL_19
       +27*T1.SINR_PUSCH_LEVEL_20
       +29*T1.SINR_PUSCH_LEVEL_21
       +30*T1.SINR_PUSCH_LEVEL_22),0)                         AS  SINR_PUSCH_UL_NUM,
       NVL(SUM(T1.SINR_PUSCH_LEVEL_1+
       T1.SINR_PUSCH_LEVEL_2+
       T1.SINR_PUSCH_LEVEL_3+
       T1.SINR_PUSCH_LEVEL_4+
       T1.SINR_PUSCH_LEVEL_5+
       T1.SINR_PUSCH_LEVEL_6+
       T1.SINR_PUSCH_LEVEL_7+
       T1.SINR_PUSCH_LEVEL_8+
       T1.SINR_PUSCH_LEVEL_9+
       T1.SINR_PUSCH_LEVEL_10+
       T1.SINR_PUSCH_LEVEL_11+
       T1.SINR_PUSCH_LEVEL_12+
       T1.SINR_PUSCH_LEVEL_13+
       T1.SINR_PUSCH_LEVEL_14+
       T1.SINR_PUSCH_LEVEL_15+
       T1.SINR_PUSCH_LEVEL_16+
       T1.SINR_PUSCH_LEVEL_17+
       T1.SINR_PUSCH_LEVEL_18+
       T1.SINR_PUSCH_LEVEL_19+
       T1.SINR_PUSCH_LEVEL_20+
       T1.SINR_PUSCH_LEVEL_21+
       T1.SINR_PUSCH_LEVEL_22),0)                             AS SINR_PUSCH_UL_DEN,
       NVL(SUM (-10*T1.SINR_PUCCH_LEVEL_1
       -9*T1.SINR_PUCCH_LEVEL_2
       -7*T1.SINR_PUCCH_LEVEL_3
       -5*T1.SINR_PUCCH_LEVEL_4
       -3*T1.SINR_PUCCH_LEVEL_5
       -1*T1.SINR_PUCCH_LEVEL_6
       +1*T1.SINR_PUCCH_LEVEL_7
       +3*T1.SINR_PUCCH_LEVEL_8
       +5*T1.SINR_PUCCH_LEVEL_9
       +7*T1.SINR_PUCCH_LEVEL_10
       +9*T1.SINR_PUCCH_LEVEL_11
       +11*T1.SINR_PUCCH_LEVEL_12
       +13*T1.SINR_PUCCH_LEVEL_13
       +15*T1.SINR_PUCCH_LEVEL_14
       +17*T1.SINR_PUCCH_LEVEL_15
       +19*T1.SINR_PUCCH_LEVEL_16
       +21*T1.SINR_PUCCH_LEVEL_17
       +23*T1.SINR_PUCCH_LEVEL_18
       +25*T1.SINR_PUCCH_LEVEL_19
       +27*T1.SINR_PUCCH_LEVEL_20
       +29*T1.SINR_PUCCH_LEVEL_21
       +30*T1.SINR_PUCCH_LEVEL_22),0)                         AS  SINR_PUCCH_UL_NUM,
       NVL(SUM (T1.SINR_PUCCH_LEVEL_1+
       T1.SINR_PUCCH_LEVEL_2+
       T1.SINR_PUCCH_LEVEL_3+
       T1.SINR_PUCCH_LEVEL_4+
       T1.SINR_PUCCH_LEVEL_5+
       T1.SINR_PUCCH_LEVEL_6+
       T1.SINR_PUCCH_LEVEL_7+
       T1.SINR_PUCCH_LEVEL_8+
       T1.SINR_PUCCH_LEVEL_9+
       T1.SINR_PUCCH_LEVEL_10+
       T1.SINR_PUCCH_LEVEL_11+
       T1.SINR_PUCCH_LEVEL_12+
       T1.SINR_PUCCH_LEVEL_13+
       T1.SINR_PUCCH_LEVEL_14+
       T1.SINR_PUCCH_LEVEL_15+
       T1.SINR_PUCCH_LEVEL_16+
       T1.SINR_PUCCH_LEVEL_17+
       T1.SINR_PUCCH_LEVEL_18+
       T1.SINR_PUCCH_LEVEL_19+
       T1.SINR_PUCCH_LEVEL_20+
       T1.SINR_PUCCH_LEVEL_21+
       T1.SINR_PUCCH_LEVEL_22),0)                             AS SINR_PUCCH_UL_DEN,
       NVL(SUM(1*T2.UE_REP_CQI_LEVEL_01+
       2*T2.UE_REP_CQI_LEVEL_02+
       3*T2.UE_REP_CQI_LEVEL_03+
       4*T2.UE_REP_CQI_LEVEL_04+
       5*T2.UE_REP_CQI_LEVEL_05+
       6*T2.UE_REP_CQI_LEVEL_06+
       7*T2.UE_REP_CQI_LEVEL_07+
       8*T2.UE_REP_CQI_LEVEL_08+
       9*T2.UE_REP_CQI_LEVEL_09+
       10*T2.UE_REP_CQI_LEVEL_10+
       11*T2.UE_REP_CQI_LEVEL_11+
       12*T2.UE_REP_CQI_LEVEL_12+
       13*T2.UE_REP_CQI_LEVEL_13+
       14*T2.UE_REP_CQI_LEVEL_14+
       15*T2.UE_REP_CQI_LEVEL_15),0)                          AS  CQI_NUM,
       NVL(SUM(T2.UE_REP_CQI_LEVEL_00+T2.UE_REP_CQI_LEVEL_01+
       T2.UE_REP_CQI_LEVEL_02+T2.UE_REP_CQI_LEVEL_03+
       T2.UE_REP_CQI_LEVEL_04+T2.UE_REP_CQI_LEVEL_05+
       T2.UE_REP_CQI_LEVEL_06+T2.UE_REP_CQI_LEVEL_07+
       T2.UE_REP_CQI_LEVEL_08+T2.UE_REP_CQI_LEVEL_09+
       T2.UE_REP_CQI_LEVEL_10+T2.UE_REP_CQI_LEVEL_11+
       T2.UE_REP_CQI_LEVEL_12+T2.UE_REP_CQI_LEVEL_13+
       T2.UE_REP_CQI_LEVEL_14+T2.UE_REP_CQI_LEVEL_15),0)      AS CQI_DEN

  FROM  NOKLTE_PS_LPQUL_MNC1_RAW T1
  LEFT OUTER JOIN NOKLTE_PS_LPQDL_MNC1_RAW T2
        ON T1.MRBTS_ID = T2.MRBTS_ID
        AND T1.LNBTS_ID = T2.LNBTS_ID
        AND T1.LNCEL_ID = T2.LNCEL_ID
        AND T1.PERIOD_START_TIME = T2.PERIOD_START_TIME
        LEFT OUTER JOIN LTE_NSN_PAQ_LCEL_HOUR T3
        ON T1.MRBTS_ID = T3.MRBTS_ID
        AND T1.LNBTS_ID = T3.LNBTS_ID
        AND T1.LNCEL_ID = T3.LNCEL_ID
        AND TRUNC(T1.PERIOD_START_TIME, 'HH24') = T3.FECHA

  WHERE  T1.PERIOD_START_TIME BETWEEN TO_DATE(P_FECHA_DESDE, 'DD.MM.YYYY HH24')   
                                  AND TO_DATE(P_FECHA_HASTA, 'DD.MM.YYYY HH24')
        AND T3.LNCEL_ID IS NULL
        AND T3.FECHA IS NULL

    GROUP BY TRUNC(T1.PERIOD_START_TIME, 'HH24'), T1.MRBTS_ID, T1.LNBTS_ID, T1.LNCEL_ID;


  LOOP
    FETCH CUR BULK COLLECT INTO T_ARRAY_COL LIMIT LIMIT_IN;
    BEGIN
      FORALL I IN 1 .. T_ARRAY_COL.COUNT SAVE EXCEPTIONS
        INSERT INTO LTE_NSN_PAQ_LCEL_HOUR VALUES T_ARRAY_COL (I);
    EXCEPTION
      WHEN DML_ERRORS THEN
        -- CAPTURE EXCEPTIONS TO PERFORM OPERATIONS DML
             L_ERRORS := SQL%BULK_EXCEPTIONS.COUNT;
                FOR I IN 1 .. L_ERRORS
                LOOP
                    L_ERRNO := SQL%BULK_EXCEPTIONS(I).ERROR_CODE;
                    L_MSG   := SQLERRM(-L_ERRNO);
                    L_IDX   := SQL%BULK_EXCEPTIONS(I).ERROR_INDEX;
                    /*
                    INSERT INTO ERROR_LOG(ID, IMPORT_DATE, SOURCE, TARGET, LNBTS_ID, LNCEL_ID, PERIOD_START_TIME,
                     MCC_ID, MNC_ID, ERROR_NRO, ERROR_MESG)
                    VALUES
                    (SEQ_ERROR_LOG.NEXTVAL,SYSDATE,P_SOURCE1_TABLE,P_TARGET_TABLE,T_ARRAY_COL(L_IDX).LNBTS_ID,
                     T_ARRAY_COL(L_IDX).LNCEL_ID,T_ARRAY_COL(L_IDX).PERIOD_START_TIME,T_ARRAY_COL(L_IDX).MCC_ID,
                     T_ARRAY_COL(L_IDX).MNC_ID, L_ERRNO,L_MSG );
          */
                END LOOP;
    -- END --
    END;
    EXIT WHEN CUR%NOTFOUND;
  END LOOP;
  COMMIT;
  CLOSE CUR;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

/
