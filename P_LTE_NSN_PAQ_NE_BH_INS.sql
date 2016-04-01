--------------------------------------------------------
--  DDL for Procedure P_LTE_NSN_PAQ_NE_BH_INS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HARRIAGUE"."P_LTE_NSN_PAQ_NE_BH_INS" (P_ELE_CLASS IN CHAR, P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR)
IS
-- Autor: Mariano Moron. Fecha: 21.09.2015.
DML_ERRORS EXCEPTION;
PRAGMA EXCEPTION_INIT(DML_ERRORS, -24381);
    -- LOG --
L_ERRORS NUMBER;
L_ERRNO    NUMBER;
L_MSG    VARCHAR2(4000);
L_IDX    NUMBER;
  -- END LOG --

LIMIT_IN PLS_INTEGER := 100;

TYPE T_ARRAY_TAB IS TABLE OF LTE_NSN_PAQ_NE_BH%ROWTYPE;
T_ARRAY_COL T_ARRAY_TAB;


CURSOR CUR (ELE_CLASS VARCHAR2, FECHA_DESDE VARCHAR2, FECHA_HASTA VARCHAR2) IS
SELECT
    T1.FECHA                                                    AS FECHA,
    ELE_CLASS                                                   AS ELEMENT_CLASS,
    CASE
        WHEN ELE_CLASS = 'ALM'     THEN NVL(T2.ALM            , 'No Especificado')
        WHEN ELE_CLASS = 'MERCADO' THEN NVL(T2.MERCADO        , 'No Especificado')
        WHEN ELE_CLASS = 'PAIS'    THEN NVL(T2.PAIS           , 'No Especificado')
        WHEN ELE_CLASS = 'CIUDAD'  THEN NVL(T2.CLUSTER_GESTION, 'No Especificado') END AS ELEMENT_ID,
    NVL(SUM(T1.RSSI_PUSCH_UL_NUM)                      ,0 ) AS   RSSI_PUSCH_UL_NUM,
    NVL(SUM(T1.RSSI_PUSCH_UL_DEN)                      ,0 ) AS   RSSI_PUSCH_UL_DEN,
    NVL(SUM(T1.RSSI_PUCCH_UL_NUM)                      ,0 ) AS   RSSI_PUCCH_UL_NUM,
    NVL(SUM(T1.RSSI_PUCCH_UL_DEN)                      ,0 ) AS   RSSI_PUCCH_UL_DEN,
    NVL(SUM(T1.SINR_PUSCH_UL_NUM)                      ,0 ) AS   SINR_PUSCH_UL_NUM,
    NVL(SUM(T1.SINR_PUSCH_UL_DEN)                      ,0 ) AS   SINR_PUSCH_UL_DEN,
    NVL(SUM(T1.SINR_PUCCH_UL_NUM)                      ,0 ) AS   SINR_PUCCH_UL_NUM,
    NVL(SUM(T1.SINR_PUCCH_UL_DEN)                      ,0 ) AS   SINR_PUCCH_UL_DEN,
    NVL(SUM(T1.CQI_NUM)                                ,0 ) AS   CQI_NUM,
    NVL(SUM(T1.CQI_DEN)                                ,0 ) AS   CQI_DEN
    FROM LTE_NSN_PAQ_NE_BH T1
    LEFT OUTER JOIN OBJECTS_SP_LTE_NE T2
    ON T1.ELEMENT_CLASS = T2.ELEMENT_CLASS
    AND T1.ELEMENT_ID = T2.ELEMENT_ID
    AND T1.ELEMENT_CLASS = 'LNBTS'

    WHERE T1.FECHA BETWEEN TO_DATE(FECHA_DESDE, 'DD.MM.YYYY HH24')
                           AND TO_DATE(FECHA_HASTA, 'DD.MM.YYYY HH24')+ (86399 / 86400)

    GROUP BY T1.FECHA , CASE
                            WHEN ELE_CLASS = 'ALM'     THEN NVL(T2.ALM            , 'No Especificado')
                            WHEN ELE_CLASS = 'MERCADO' THEN NVL(T2.MERCADO        , 'No Especificado')
                            WHEN ELE_CLASS = 'PAIS'    THEN NVL(T2.PAIS           , 'No Especificado')
                            WHEN ELE_CLASS = 'CIUDAD'  THEN NVL(T2.CLUSTER_GESTION, 'No Especificado') END;

 BEGIN
  OPEN CUR (P_ELE_CLASS, P_FECHA_DESDE, P_FECHA_HASTA);

  LOOP
    FETCH CUR BULK COLLECT INTO T_ARRAY_COL LIMIT LIMIT_IN;
    BEGIN
      FORALL I IN 1 .. T_ARRAY_COL.COUNT SAVE EXCEPTIONS
        INSERT INTO LTE_NSN_PAQ_NE_BH VALUES T_ARRAY_COL (I);
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
