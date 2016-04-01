--------------------------------------------------------
--  DDL for Procedure P_LTE_C_LEPSB_RAW_REPLAY
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HARRIAGUE"."P_LTE_C_LEPSB_RAW_REPLAY" (P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR)
IS
  sql_stmt VARCHAR2(32767);

  TYPE cur_typ IS REF CURSOR;
  cur CUR_TYP;
  limit_in PLS_INTEGER := 100;
  
 v_bulk_errors EXCEPTION;
PRAGMA EXCEPTION_INIT (v_bulk_errors, -24381);
  
  -- LOG --
  l_errors VARCHAR2 (4000);
  l_errno    VARCHAR2(4000);
  l_msg    varchar2(4000);
  l_idx    VARCHAR2(4000);
  -- END LOG --
  
  TYPE t_array_tab IS TABLE OF NOKLTE_PS_LEPSB_MNC1_RAW%ROWTYPE;
  t_array_col t_array_tab;


 BEGIN

 sql_stmt := ' SELECT DISTINCT
      r.MRBTS_ID,
      r.LNBTS_ID,
      r.LNCEL_ID,
      r.MCC_ID,
      r.MNC_ID,
      r.PERIOD_START_TIME + 7 PERIOD_START_TIME,
      r.PERIOD_DURATION,
      r.PERIOD_DURATION_SUM,
      r.EPS_BEARER_SETUP_ATTEMPTS,
      r.EPS_BEARER_SETUP_COMPLETIONS,
      r.EPS_BEARER_SETUP_FAIL_RNL,
      r.EPS_BEARER_SETUP_FAIL_TRPORT,
      r.EPS_BEARER_SETUP_FAIL_RESOUR,
      r.EPS_BEARER_SETUP_FAIL_OTH,
      r.EPC_EPS_BEARER_REL_REQ_NORM,
      r.EPC_EPS_BEARER_REL_REQ_DETACH,
      r.EPC_EPS_BEARER_REL_REQ_RNL,
      r.EPC_EPS_BEARER_REL_REQ_OTH,
      r.ENB_EPS_BEARER_REL_REQ_NORM,
      r.ENB_EPS_BEARER_REL_REQ_RNL,
      r.ENB_EPS_BEARER_REL_REQ_OTH,
      r.ENB_EPS_BEARER_REL_REQ_TNL,
      r.ENB_EPSBEAR_REL_REQ_RNL_REDIR,
      r.EPS_BEARER_SETUP_FAIL_HO,
      r.EPS_BEAR_SET_COM_ADDIT_QCI1,
      r.EPC_EPS_BEAR_REL_REQ_N_QCI1,
      r.EPC_EPS_BEAR_REL_REQ_D_QCI1,
      r.EPC_EPS_BEAR_REL_REQ_R_QCI1,
      r.EPC_EPS_BEAR_REL_REQ_O_QCI1,
      r.ENB_EPS_BEAR_REL_REQ_N_QCI1,
      r.ENB_EPS_BEAR_REL_REQ_O_QCI1,
      r.ENB_EPS_BEAR_REL_REQ_T_QCI1,
      r.EPS_BEARER_STP_ATT_INI_QCI_1,
      r.EPS_BEAR_STP_ATT_INI_NON_GBR,
      r.EPS_BEARER_STP_ATT_ADD_QCI_1,
      r.EPS_BEARER_STP_COM_INI_QCI1,
      r.EPS_BEAR_STP_COM_INI_NON_GBR,
      r.ENB_EPS_BEAR_REL_REQ_R_QCI1,
      r.ENB_EPS_BEAR_REL_REQ_RD_QCI1,
      r.EPS_BEARER_STP_ATT_INI_QCI_2,
      r.EPS_BEARER_STP_ATT_INI_QCI_3,
      r.EPS_BEARER_STP_ATT_INI_QCI_4,
      r.EPS_BEARER_STP_ATT_ADD_QCI_2,
      r.EPS_BEARER_STP_ATT_ADD_QCI_3,
      r.EPS_BEARER_STP_ATT_ADD_QCI_4,
      r.EPS_BEARER_STP_COM_INI_QCI_2,
      r.EPS_BEARER_STP_COM_INI_QCI_3,
      r.EPS_BEARER_STP_COM_INI_QCI_4,
      r.EPS_BEARER_STP_COM_ADD_QCI_2,
      r.EPS_BEARER_STP_COM_ADD_QCI_3,
      r.EPS_BEARER_STP_COM_ADD_QCI_4,
      r.PRE_EMPT_GBR_BEARER,
      r.PRE_EMPT_NON_GBR_BEARER,
      r.ERAB_REL_ENB_ACT_QCI1,
      r.ERAB_REL_ENB_ACT_QCI2,
      r.ERAB_REL_ENB_ACT_QCI3,
      r.ERAB_REL_ENB_ACT_QCI4,
      r.ERAB_REL_ENB_ACT_NON_GBR,
      r.ERAB_IN_SESSION_TIME_QCI1,
      r.ERAB_IN_SESSION_TIME_QCI2,
      r.ERAB_IN_SESSION_TIME_QCI3,
      r.ERAB_IN_SESSION_TIME_QCI4,
      r.ERAB_IN_SESSION_TIME_NON_GBR
  FROM NOKLTE_PS_LEPSB_MNC1_RAW r
 INNER JOIN OBJECTS_SP_LTE o
    ON r.LNBTS_ID = o.LNBTS_ID
   AND r.LNCEL_ID = o.LNCEL_ID
 WHERE r.PERIOD_START_TIME BETWEEN TO_DATE(''' || P_FECHA_DESDE ||''', ''DD.MM.YYYY HH24'')
                             AND TO_DATE('''||P_FECHA_HASTA ||''', ''DD.MM.YYYY HH24'')';

  OPEN cur FOR sql_stmt;
  LOOP
    FETCH cur BULK COLLECT INTO t_array_col LIMIT limit_in;
    BEGIN
      FORALL i IN 1 .. t_array_col.COUNT SAVE EXCEPTIONS
        INSERT INTO NOKLTE_PS_LEPSB_MNC1_RAW VALUES t_array_col (i);
        
    
  EXCEPTION WHEN v_bulk_errors THEN
    FOR i in 1..SQL%BULK_EXCEPTIONS.COUNT LOOP
    l_errno := sql%bulk_exceptions(i).error_code;
    l_msg   := sqlerrm(-l_errno);
    l_idx   := sql%bulk_exceptions(i).error_index;  
     
    Dbms_output.put_line(
   'Error cod:' || l_errno ||
   'Mensaje: ' || l_msg );
    END LOOP;
    
    END;
    EXIT WHEN cur%NOTFOUND;
  END LOOP;
  COMMIT;
  CLOSE cur;

 exception
 when others then
 dbms_output.put_line (sqlerrm); 
   
END;
 

/
