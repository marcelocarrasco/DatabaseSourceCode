--------------------------------------------------------
--  DDL for Procedure P_LTE_C_LCELLT_RAW_REPLAY
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HARRIAGUE"."P_LTE_C_LCELLT_RAW_REPLAY" (P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR)
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

  TYPE t_array_tab IS TABLE OF NOKLTE_PS_LCELLT_MNC1_RAW%ROWTYPE;
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
    r.RLC_SDU_VOL_DL_DCCH,
    r.RLC_SDU_VOL_UL_DCCH,
    r.RLC_PDU_VOL_RECEIVED,
    r.RLC_PDU_VOL_TRANSMITTED,
    r.PDCP_SDU_VOL_UL,
    r.PDCP_SDU_VOL_DL,
    r.PDCP_DATA_RATE_MIN_UL,
    r.PDCP_DATA_RATE_MAX_UL,
    r.PDCP_DATA_RATE_MEAN_UL,
    r.PDCP_DATA_RATE_MIN_DL,
    r.PDCP_DATA_RATE_MAX_DL,
    r.PDCP_DATA_RATE_MEAN_DL,
    r.TB_VOL_PDSCH_MCS0,
    r.TB_VOL_PDSCH_MCS1,
    r.TB_VOL_PDSCH_MCS2,
    r.TB_VOL_PDSCH_MCS3,
    r.TB_VOL_PDSCH_MCS4,
    r.TB_VOL_PDSCH_MCS5,
    r.TB_VOL_PDSCH_MCS6,
    r.TB_VOL_PDSCH_MCS7,
    r.TB_VOL_PDSCH_MCS8,
    r.TB_VOL_PDSCH_MCS9,
    r.TB_VOL_PDSCH_MCS10,
    r.TB_VOL_PDSCH_MCS11,
    r.TB_VOL_PDSCH_MCS12,
    r.TB_VOL_PDSCH_MCS13,
    r.TB_VOL_PDSCH_MCS14,
    r.TB_VOL_PDSCH_MCS15,
    r.TB_VOL_PDSCH_MCS16,
    r.TB_VOL_PDSCH_MCS17,
    r.TB_VOL_PDSCH_MCS18,
    r.TB_VOL_PDSCH_MCS19,
    r.TB_VOL_PDSCH_MCS20,
    r.TB_VOL_PUSCH_MCS0,
    r.TB_VOL_PUSCH_MCS1,
    r.TB_VOL_PUSCH_MCS2,
    r.TB_VOL_PUSCH_MCS3,
    r.TB_VOL_PUSCH_MCS4,
    r.TB_VOL_PUSCH_MCS5,
    r.TB_VOL_PUSCH_MCS6,
    r.TB_VOL_PUSCH_MCS7,
    r.TB_VOL_PUSCH_MCS8,
    r.TB_VOL_PUSCH_MCS9,
    r.TB_VOL_PUSCH_MCS10,
    r.TB_VOL_PUSCH_MCS11,
    r.TB_VOL_PUSCH_MCS12,
    r.TB_VOL_PUSCH_MCS13,
    r.TB_VOL_PUSCH_MCS14,
    r.TB_VOL_PUSCH_MCS15,
    r.TB_VOL_PUSCH_MCS16,
    r.TB_VOL_PUSCH_MCS17,
    r.TB_VOL_PUSCH_MCS18,
    r.TB_VOL_PUSCH_MCS19,
    r.TB_VOL_PUSCH_MCS20,
    r.MAC_SDU_VOL_UL_CCCH,
    r.MAC_SDU_VOL_UL_DCCH,
    r.MAC_SDU_VOL_UL_DTCH,
    r.MAC_SDU_VOL_BCCH,
    r.MAC_SDU_VOL_PCCH,
    r.MAC_SDU_VOL_DL_CCCH,
    r.MAC_SDU_VOL_DL_DCCH,
    r.MAC_SDU_VOL_DL_DTCH,
    r.RRC_UL_VOL,
    r.RRC_DL_VOL,
    r.RLC_SDU_VOL_UL_DTCH,
    r.RLC_SDU_VOL_DL_DTCH,
    r.TB_VOL_PDSCH_MCS21,
    r.TB_VOL_PDSCH_MCS22,
    r.TB_VOL_PDSCH_MCS23,
    r.TB_VOL_PDSCH_MCS24,
    r.TB_VOL_PDSCH_MCS25,
    r.TB_VOL_PDSCH_MCS26,
    r.TB_VOL_PDSCH_MCS27,
    r.TB_VOL_PDSCH_MCS28,
    r.VOL_ORIG_TRANS_DL_SCH_TB,
    r.VOL_RE_REC_UL_SCH_TB,
    r.VOL_RE_TRANS_DL_SCH_TB,
    r.VOL_ORIG_REC_UL_SCH_TB,
    r.PDCP_DATA_RATE_MEAN_UL_QCI_1,
    r.PDCP_DATA_RATE_MEAN_DL_QCI_1,
    r.TB_VOL_PUSCH_MCS21,
    r.TB_VOL_PUSCH_MCS22,
    r.TB_VOL_PUSCH_MCS23,
    r.TB_VOL_PUSCH_MCS24,
    r.TB_VOL_PDSCH_MCS29,
    r.TB_VOL_PDSCH_MCS30,
    r.TB_VOL_PDSCH_MCS31,
    r.RLC_PDU_DL_VOL_CA_SCELL,
    r.ACTIVE_TTI_UL,
    r.ACTIVE_TTI_DL,
    r.IP_TPUT_VOL_UL_QCI_1,
    r.IP_TPUT_TIME_UL_QCI_1,
    r.IP_TPUT_VOL_UL_QCI_2,
    r.IP_TPUT_TIME_UL_QCI_2,
    r.IP_TPUT_VOL_UL_QCI_3,
    r.IP_TPUT_TIME_UL_QCI_3,
    r.IP_TPUT_VOL_UL_QCI_4,
    r.IP_TPUT_TIME_UL_QCI_4,
    r.IP_TPUT_VOL_UL_QCI_5,
    r.IP_TPUT_TIME_UL_QCI_5,
    r.IP_TPUT_VOL_UL_QCI_6,
    r.IP_TPUT_TIME_UL_QCI_6,
    r.IP_TPUT_VOL_UL_QCI_7,
    r.IP_TPUT_TIME_UL_QCI_7,
    r.IP_TPUT_VOL_UL_QCI_8,
    r.IP_TPUT_TIME_UL_QCI_8,
    r.IP_TPUT_VOL_UL_QCI_9,
    r.IP_TPUT_TIME_UL_QCI_9,
    r.IP_TPUT_VOL_DL_QCI_1,
    r.IP_TPUT_TIME_DL_QCI_1,
    r.IP_TPUT_VOL_DL_QCI_2,
    r.IP_TPUT_TIME_DL_QCI_2,
    r.IP_TPUT_VOL_DL_QCI_3,
    r.IP_TPUT_TIME_DL_QCI_3,
    r.IP_TPUT_VOL_DL_QCI_4,
    r.IP_TPUT_TIME_DL_QCI_4,
    r.IP_TPUT_VOL_DL_QCI_5,
    r.IP_TPUT_TIME_DL_QCI_5,
    r.IP_TPUT_VOL_DL_QCI_6,
    r.IP_TPUT_TIME_DL_QCI_6,
    r.IP_TPUT_VOL_DL_QCI_7,
    r.IP_TPUT_TIME_DL_QCI_7,
    r.IP_TPUT_VOL_DL_QCI_8,
    r.IP_TPUT_TIME_DL_QCI_8,
    r.IP_TPUT_VOL_DL_QCI_9,
    r.IP_TPUT_TIME_DL_QCI_9
 FROM NOKLTE_PS_LCELLT_MNC1_RAW r
 WHERE  r.PERIOD_START_TIME BETWEEN TO_DATE(''' || P_FECHA_DESDE ||''', ''DD.MM.YYYY HH24'')
                             AND TO_DATE('''||P_FECHA_HASTA ||''', ''DD.MM.YYYY HH24'')';

  OPEN cur FOR sql_stmt;
  LOOP
    FETCH cur BULK COLLECT INTO t_array_col LIMIT limit_in;
    BEGIN
      FORALL i IN 1 .. t_array_col.COUNT SAVE EXCEPTIONS
        INSERT INTO NOKLTE_PS_LCELLT_MNC1_RAW VALUES t_array_col (i);
      
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
