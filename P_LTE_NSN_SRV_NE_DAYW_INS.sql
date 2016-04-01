--------------------------------------------------------
--  DDL for Procedure P_LTE_NSN_SRV_NE_DAYW_INS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HARRIAGUE"."P_LTE_NSN_SRV_NE_DAYW_INS" (P_ELE_CLASS IN CHAR, P_FECHA_DESDE IN CHAR)
IS
-- Autor: Mariano Moron. Fecha: 14.09.2015.
-- Actualizacion: Mariano Morón. Fecha: 17.09.2015. Motivo: Se eliminan 2 Kpi's a nivel de LNBTS
DML_ERRORS EXCEPTION;
PRAGMA EXCEPTION_INIT(DML_ERRORS, -24381);
    -- LOG --
L_ERRORS NUMBER;
L_ERRNO    NUMBER;
L_MSG    VARCHAR2(4000);
L_IDX    NUMBER;
  -- END LOG --

LIMIT_IN PLS_INTEGER := 100;
V_FECHA_DESDE VARCHAR2(10);
V_FECHA_HASTA VARCHAR2(10);

TYPE T_ARRAY_TAB IS TABLE OF LTE_NSN_SERVICE_NE_DAYW%ROWTYPE;
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
        NVL(SUM(T1.AVG_PDCP_CELL_THP_DL_NUM)                   ,0 )  AS  AVG_PDCP_CELL_THP_DL_NUM,
        NVL(SUM(T1.AVG_PDCP_CELL_THP_DL_DEN)                   ,0 )  AS AVG_PDCP_CELL_THP_DL_DEN,
        NVL(SUM(T1.SIGN_EST_F_RRCCOMPL_MISSING)                ,0 )  AS SIGN_EST_F_RRCCOMPL_MISSING,
        NVL(SUM(T1.SIGN_EST_F_RRCCOMPL_ERROR)                  ,0 )  AS  SIGN_EST_F_RRCCOMPL_ERROR,
        NVL(SUM(T1.SIGN_CONN_ESTAB_FAIL_RRMRAC)                ,0 )  AS  SIGN_CONN_ESTAB_FAIL_RRMRAC,
        NVL(SUM(T1.SIGN_CONN_ESTAB_FAIL_RB_EMG)                ,0 )  AS  SIGN_CONN_ESTAB_FAIL_RB_EMG,
        NVL(SUM(T1.EPS_BEARER_SETUP_FAIL_RNL)                  ,0 )  AS  EPS_BEARER_SETUP_FAIL_RNL,
        NVL(SUM(T1.EPS_BEARER_SETUP_FAIL_RESOUR)               ,0 )  AS  EPS_BEARER_SETUP_FAIL_RESOUR,
        NVL(SUM(T1.EPS_BEARER_SETUP_FAIL_TRPORT)               ,0 )  AS  EPS_BEARER_SETUP_FAIL_TRPORT,
        NVL(SUM(T1.EPS_BEARER_SETUP_FAIL_OTH)                  ,0 )  AS  EPS_BEARER_SETUP_FAIL_OTH,
        NVL(SUM(T1.ENB_EPS_BEARER_REL_REQ_RNL)                 ,0 )  AS  ENB_EPS_BEARER_REL_REQ_RNL,
        NVL(SUM(T1.ENB_EPS_BEARER_REL_REQ_TNL)                 ,0 )  AS  ENB_EPS_BEARER_REL_REQ_TNL,
        NVL(SUM(T1.ENB_EPS_BEARER_REL_REQ_OTH)                 ,0 )  AS  ENB_EPS_BEARER_REL_REQ_OTH,
        NVL(SUM(T1.AVG_PDCP_CELL_THP_UL_NUM)                   ,0 )  AS  AVG_PDCP_CELL_THP_UL_NUM,
        NVL(SUM(T1.AVG_PDCP_CELL_THP_UL_DEN)                   ,0 )  AS AVG_PDCP_CELL_THP_UL_DEN,
        NVL(SUM(T1.TRAFICO_UL)                                 ,0 )  AS TRAFICO_UL,
        NVL(SUM(T1.TRAFICO_DL)                                 ,0 )  AS TRAFICO_DL,
        NVL(SUM(T1.USER_ACT_BUFFER_UL_MAX)                     ,0 )  AS USER_ACT_BUFFER_UL_MAX,
        NVL(SUM(T1.USER_ACT_BUFFER_DL_MAX)                     ,0 )  AS USER_ACT_BUFFER_DL_MAX,
        NVL(SUM(T1.USER_ACT_BUFFER_UL_AVG)                     ,0 )  AS  USER_ACT_BUFFER_UL_AVG,
        NVL(SUM(T1.USER_ACT_BUFFER_DL_AVG)                      ,0 )  AS  USER_ACT_BUFFER_DL_AVG,
        NVL(SUM(T1.RACH_STP_SUCCESS_NUM)                       ,0 )  AS  RACH_STP_SUCCESS_NUM,
        NVL(SUM(T1.RACH_STP_SUCCESS_DEN)                       ,0 )  AS RACH_STP_SUCCESS_DEN,
        NVL(ROUND(AVG(T1.LATENCY_UL),2)                        ,0 )  AS LATENCY_UL,
        NVL(ROUND(AVG(T1.LATENCY_DL),2)                        ,0 )  AS LATENCY_DL,
        NVL(MAX(T1.CELL_THROUGHPUT_DL)                         ,0 )  AS CELL_THROUGHPUT_DL,
        NVL(MAX(T1.CELL_THROUGHPUT_UL)                         ,0 )  AS CELL_THROUGHPUT_UL,
        NVL(SUM(T1.BLER_PUSCH_NUM)                             ,0 )  AS  BLER_PUSCH_NUM,
        NVL(SUM(T1.BLER_PUSCH_DEN)                             ,0 )  AS BLER_PUSCH_DEN,
        NVL(SUM(T1.BLER_PDSCH_NUM)                             ,0 )  AS  BLER_PDSCH_NUM,
        NVL(SUM(T1.BLER_PDSCH_DEN)                             ,0 )  AS BLER_PDSCH_DEN,
        NVL(SUM(T1.RRC_CONN_STP_SUCCESS_NUM)                   ,0 )  AS  RRC_CONN_STP_SUCCESS_NUM,
        NVL(SUM(T1.RRC_CONN_STP_SUCCESS_DEN)                   ,0 )  AS RRC_CONN_STP_SUCCESS_DEN,
        NVL(SUM(T1.RAB_DROP_ATTEMPTS)                          ,0 )  AS RAB_DROP_ATTEMPTS,
        NVL(SUM(T1.RAB_STP_SUCCESS_NUM)                        ,0 )  AS  RAB_STP_SUCCESS_NUM,
        NVL(SUM(T1.RAB_STP_SUCCESS_DEN)                        ,0 )  AS RAB_STP_SUCCESS_DEN,
        NVL(SUM(T1.RAB_SETUP_SUCCESS_NUM)                      ,0 )  AS RAB_SETUP_SUCCESS_NUM,
        NVL(SUM(T1.RAB_SETUP_SUCCESS_DEN)                      ,0 )  AS RAB_SETUP_SUCCESS_DEN,
        NVL(SUM(T1.RRC_CONN_STP_ATTEMPTS)                      ,0 )  AS RRC_CONN_STP_ATTEMPTS,
        NVL(SUM(T1.EPS_BEARER_SETUP_ATTEMPTS)                  ,0 )  AS EPS_BEARER_SETUP_ATTEMPTS,
        NVL(SUM(T1.RAB_DROP_USR_NUM)                           ,0 )  AS RAB_DROP_USR_NUM ,
        NVL(SUM(T1.RAB_DROP_USR_DEN)                           ,0 )  AS RAB_DROP_USR_DEN ,
        NVL(SUM(T1.RAB_NORMAL_RELEASE_NUM)                     ,0 )  AS RAB_NORMAL_RELEASE_NUM,
        NVL(SUM(T1.RAB_NORMAL_RELEASE_DEN)                     ,0 )  AS RAB_NORMAL_RELEASE_DEN,
        NVL(SUM(T1.EPC_EPS_BEARER_REL_REQ_RNL)                 ,0 )  AS EPC_EPS_BEARER_REL_REQ_RNL,
        NVL(SUM(T1.EPC_EPS_BEARER_REL_REQ_OTH)                 ,0 )  AS EPC_EPS_BEARER_REL_REQ_OTH,
        NVL(ROUND(AVG(T1.AVG_ACTIVE_USER_CELL),2)              ,0 )  AS AVG_ACTIVE_USER_CELL,
        NVL(MAX(T1.MAX_AVG_ACTIVE_USER_CELL)                   ,0 )  AS MAX_AVG_ACTIVE_USER_CELL,
        NVL(SUM(T1.RRC_CONNECTED_UES)                          ,0 )  AS RRC_CONNECTED_UES
        FROM LTE_NSN_SERVICE_NE_DAYW T1
        LEFT OUTER JOIN OBJECTS_SP_LTE_NE T2
        ON T1.ELEMENT_CLASS = T2.ELEMENT_CLASS
        AND T1.ELEMENT_ID = T2.ELEMENT_ID
        AND T1.ELEMENT_CLASS = 'LNBTS'

        WHERE T1.FECHA BETWEEN TO_DATE(FECHA_DESDE, 'DD.MM.YYYY')
                            AND TO_DATE(FECHA_HASTA, 'DD.MM.YYYY')+ (86399 / 86400)

        GROUP BY T1.FECHA , CASE
                                WHEN ELE_CLASS = 'ALM'     THEN NVL(T2.ALM            , 'No Especificado')
                                WHEN ELE_CLASS = 'MERCADO' THEN NVL(T2.MERCADO        , 'No Especificado')
                                WHEN ELE_CLASS = 'PAIS'    THEN NVL(T2.PAIS           , 'No Especificado')
                                WHEN ELE_CLASS = 'CIUDAD'  THEN NVL(T2.CLUSTER_GESTION, 'No Especificado') END;


 BEGIN

  SELECT TO_CHAR(TRUNC(TO_DATE(P_FECHA_DESDE, 'DD.MM.YYYY'), 'DAY'), 'DD.MM.YYYY')    FECHA_DESDE,
     TO_CHAR(TRUNC(TO_DATE(P_FECHA_DESDE, 'DD.MM.YYYY'), 'DAY') + 6 , 'DD.MM.YYYY')   FECHA_HASTA
  INTO V_FECHA_DESDE,
       V_FECHA_HASTA
  FROM DUAL;

    OPEN CUR (P_ELE_CLASS, V_FECHA_DESDE, V_FECHA_HASTA);
  LOOP
    FETCH CUR BULK COLLECT INTO T_ARRAY_COL LIMIT LIMIT_IN;
    BEGIN
      FORALL I IN 1 .. T_ARRAY_COL.COUNT SAVE EXCEPTIONS
        INSERT INTO LTE_NSN_SERVICE_NE_DAYW VALUES T_ARRAY_COL (I);
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
