--------------------------------------------------------
--  DDL for Procedure P_LTE_NSN_SRV_LCE_BH_INS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HARRIAGUE"."P_LTE_NSN_SRV_LCE_BH_INS" (P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR)
IS
-- Autor: Mariano Moron. Fecha: 15.09.2015.
-- Actualizacion: Mariano Morón. Fecha: 17.09.2015. Motivo: Se eliminan 2 Kpi's a nivel de LNBTS
DML_ERRORS EXCEPTION;
PRAGMA EXCEPTION_INIT(DML_ERRORS, -24381);
    -- LOG --111
L_ERRORS NUMBER;
L_ERRNO    NUMBER;
L_MSG    VARCHAR2(4000);
L_IDX    NUMBER;
  -- END LOG --

LIMIT_IN PLS_INTEGER := 100;

TYPE T_ARRAY_TAB IS TABLE OF LTE_NSN_SERVICE_LCEL_BH%ROWTYPE;
T_ARRAY_COL T_ARRAY_TAB;


CURSOR CUR (FECHA_DESDE VARCHAR2, FECHA_HASTA VARCHAR2) IS
  SELECT
      TRUNC(T1.FECHA , 'DD')                                       AS FECHA,
      T1.MRBTS_ID,
      T1.LNBTS_ID,
      T1.LNCEL_ID,
      NVL(T1.AVG_PDCP_CELL_THP_DL_NUM                         ,0 )  AS  AVG_PDCP_CELL_THP_DL_NUM,
      NVL(T1.AVG_PDCP_CELL_THP_DL_DEN                         ,0 )  AS AVG_PDCP_CELL_THP_DL_DEN,
      NVL(T1.SIGN_EST_F_RRCCOMPL_MISSING                      ,0 )  AS SIGN_EST_F_RRCCOMPL_MISSING,
      NVL(T1.SIGN_EST_F_RRCCOMPL_ERROR                        ,0 )  AS  SIGN_EST_F_RRCCOMPL_ERROR,
      NVL(T1.SIGN_CONN_ESTAB_FAIL_RRMRAC                      ,0 )  AS  SIGN_CONN_ESTAB_FAIL_RRMRAC,
      NVL(T1.SIGN_CONN_ESTAB_FAIL_RB_EMG                      ,0 )  AS  SIGN_CONN_ESTAB_FAIL_RB_EMG,
      NVL(T1.EPS_BEARER_SETUP_FAIL_RNL                        ,0 )  AS  EPS_BEARER_SETUP_FAIL_RNL,
      NVL(T1.EPS_BEARER_SETUP_FAIL_RESOUR                     ,0 )  AS  EPS_BEARER_SETUP_FAIL_RESOUR,
      NVL(T1.EPS_BEARER_SETUP_FAIL_TRPORT                     ,0 )  AS  EPS_BEARER_SETUP_FAIL_TRPORT,
      NVL(T1.EPS_BEARER_SETUP_FAIL_OTH                        ,0 )  AS  EPS_BEARER_SETUP_FAIL_OTH,
      NVL(T1.ENB_EPS_BEARER_REL_REQ_RNL                       ,0 )  AS  ENB_EPS_BEARER_REL_REQ_RNL,
      NVL(T1.ENB_EPS_BEARER_REL_REQ_TNL                       ,0 )  AS  ENB_EPS_BEARER_REL_REQ_TNL,
      NVL(T1.ENB_EPS_BEARER_REL_REQ_OTH                       ,0 )  AS  ENB_EPS_BEARER_REL_REQ_OTH,
      NVL(T1.AVG_PDCP_CELL_THP_UL_NUM                         ,0 )  AS  AVG_PDCP_CELL_THP_UL_NUM,
      NVL(T1.AVG_PDCP_CELL_THP_UL_DEN                         ,0 )  AS AVG_PDCP_CELL_THP_UL_DEN,
      NVL(T1.TRAFICO_UL                                       ,0 )  AS TRAFICO_UL,
      NVL(T1.TRAFICO_DL                                       ,0 )  AS TRAFICO_DL,
      NVL(T1.USER_ACT_BUFFER_UL_MAX                           ,0 )  AS USER_ACT_BUFFER_UL_MAX,
      NVL(T1.USER_ACT_BUFFER_DL_MAX                           ,0 )  AS USER_ACT_BUFFER_DL_MAX,
      NVL(T1.USER_ACT_BUFFER_UL_AVG                           ,0 )  AS USER_ACT_BUFFER_UL_AVG,
      NVL(T1.USER_ACT_BUFFER_DL_AVG                           ,0 )  AS USER_ACT_BUFFER_DL_AVG,
      NVL(T1.RACH_STP_SUCCESS_NUM                             ,0 )  AS  RACH_STP_SUCCESS_NUM,
      NVL(T1.RACH_STP_SUCCESS_DEN                             ,0 )  AS RACH_STP_SUCCESS_DEN,
      NVL(T1.LATENCY_UL                                       ,0 )  AS LATENCY_UL,
      NVL(T1.LATENCY_DL                                       ,0 )  AS LATENCY_DL,
      NVL(T1.CELL_THROUGHPUT_DL                               ,0 )  AS CELL_THROUGHPUT_DL,
      NVL(T1.CELL_THROUGHPUT_UL                               ,0 )  AS CELL_THROUGHPUT_UL,
      NVL(T1.BLER_PUSCH_NUM                                   ,0 )  AS  BLER_PUSCH_NUM,
      NVL(T1.BLER_PUSCH_DEN                                   ,0 )  AS BLER_PUSCH_DEN,
      NVL(T1.BLER_PDSCH_NUM                                   ,0 )  AS  BLER_PDSCH_NUM,
      NVL(T1.BLER_PDSCH_DEN                                   ,0 )  AS BLER_PDSCH_DEN,
      NVL(T1.RRC_CONN_STP_SUCCESS_NUM                         ,0 )  AS  RRC_CONN_STP_SUCCESS_NUM,
      NVL(T1.RRC_CONN_STP_SUCCESS_DEN                         ,0 )  AS RRC_CONN_STP_SUCCESS_DEN,
      NVL(T1.RAB_DROP_ATTEMPTS                                ,0 )  AS RAB_DROP_ATTEMPTS,
      NVL(T1.RAB_STP_SUCCESS_NUM                              ,0 )  AS  RAB_STP_SUCCESS_NUM,
      NVL(T1.RAB_STP_SUCCESS_DEN                              ,0 )  AS RAB_STP_SUCCESS_DEN,
      NVL(T1.RAB_SETUP_SUCCESS_NUM                            ,0 )  AS RAB_SETUP_SUCCESS_NUM,
      NVL(T1.RAB_SETUP_SUCCESS_DEN                            ,0 )  AS RAB_SETUP_SUCCESS_DEN,
      NVL(T1.RRC_CONN_STP_ATTEMPTS                            ,0 )  AS RRC_CONN_STP_ATTEMPTS,
      NVL(T1.EPS_BEARER_SETUP_ATTEMPTS                        ,0 )  AS EPS_BEARER_SETUP_ATTEMPTS,
      NVL(T1.RAB_DROP_USR_NUM                                 ,0 )  AS RAB_DROP_USR_NUM ,
      NVL(T1.RAB_DROP_USR_DEN                                 ,0 )  AS RAB_DROP_USR_DEN ,
      NVL(T1.RAB_NORMAL_RELEASE_NUM                           ,0 )  AS RAB_NORMAL_RELEASE_NUM,
      NVL(T1.RAB_NORMAL_RELEASE_DEN                           ,0 )  AS RAB_NORMAL_RELEASE_DEN,
      NVL(T1.EPC_EPS_BEARER_REL_REQ_RNL                       ,0 )  AS EPC_EPS_BEARER_REL_REQ_RNL,
      NVL(T1.EPC_EPS_BEARER_REL_REQ_OTH                       ,0 )  AS EPC_EPS_BEARER_REL_REQ_OTH,
      NVL(T1.AVG_ACTIVE_USER_CELL                             ,0 )  AS AVG_ACTIVE_USER_CELL,
      NVL(T1.MAX_AVG_ACTIVE_USER_CELL                         ,0 )  AS MAX_AVG_ACTIVE_USER_CELL,
      NVL(AUX3.RRC_CONNECTED_UES                              ,0 )  AS RRC_CONNECTED_UES
  FROM LTE_NSN_SERVICE_LCEL_HOUR T1
  INNER JOIN MV_LTE_TRAFIC_LCEL_BH_AUX AUX
  ON T1.FECHA = AUX.FECHA
  AND T1.LNCEL_ID = AUX.LNCEL_ID
  LEFT OUTER JOIN (SELECT
                TRUNC(T3.FECHA , 'DD') AS FECHA,
                T3.LNCEL_ID,
                T3.RRC_CONNECTED_UES
              FROM LTE_NSN_SERVICE_LCEL_HOUR T3
              INNER JOIN MV_MME_USERS_PLMN_BH_AUX AUX2
              ON T3.FECHA = AUX2.FECHA
              WHERE T3.FECHA BETWEEN TO_DATE(FECHA_DESDE, 'DD.MM.YYYY')
                                 AND TO_DATE(FECHA_HASTA, 'DD.MM.YYYY') + (86399 / 86400)
          ) AUX3
  ON T1.FECHA = AUX3.FECHA
  AND T1.LNCEL_ID = AUX3.LNCEL_ID


  WHERE T1.FECHA BETWEEN TO_DATE(FECHA_DESDE, 'DD.MM.YYYY')
                                 AND TO_DATE(FECHA_HASTA, 'DD.MM.YYYY') + (86399 / 86400);

BEGIN

--P_LTE_TRUNCATE_SPARTITION (P_FECHA_DESDE, P_FECHA_HASTA, 'ServiceWcellBH', 'LCE');

OPEN CUR (P_FECHA_DESDE, P_FECHA_HASTA);

LOOP
  FETCH CUR BULK COLLECT INTO T_ARRAY_COL LIMIT LIMIT_IN;
  BEGIN
    FORALL I IN 1 .. T_ARRAY_COL.COUNT SAVE EXCEPTIONS
      INSERT INTO LTE_NSN_SERVICE_LCEL_BH VALUES T_ARRAY_COL (I);
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
