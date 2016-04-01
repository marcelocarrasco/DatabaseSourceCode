--------------------------------------------------------
--  DDL for Procedure P_LTE_C_LUEST_RAW_INS_2
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HARRIAGUE"."P_LTE_C_LUEST_RAW_INS_2" (
p_starttime IN VARCHAR2,
p_ossrc IN VARCHAR2) IS

  sql_stmt VARCHAR2(4000);
  TYPE cur_typ IS REF CURSOR;
  cur CUR_TYP;

  /*dml_errors EXCEPTION;
  PRAGMA EXCEPTION_INIT(dml_errors, -24381);*/
  
  v_bulk_errors EXCEPTION;
  PRAGMA EXCEPTION_INIT (v_bulk_errors, -24381);
  
  -- LOG --
  l_errors number;
  l_errno    number;
  l_msg    varchar2(4000);
  l_idx    number;
  -- END LOG --
  limit_in PLS_INTEGER := 100;

  TYPE t_array_tab IS TABLE OF NOKLTE_PS_LUEST_MNC1_RAW%ROWTYPE;
  t_array_col t_array_tab;

   -- Then extract parameters table.
  p_source1_table  CONSTANT VARCHAR2(150):= 'NOKLTE_PS_LUEST_MNC1_VW';
  p_target_table  CONSTANT VARCHAR2(150):= 'NOKLTE_PS_LUEST_MNC1_RAW';

BEGIN
  sql_stmt := 'SELECT T1.*
     FROM ' || p_source1_table || ' T1
     LEFT OUTER JOIN ' || p_target_table || ' T2
       ON T1.MRBTS_ID = T2.MRBTS_ID
       AND T1.LNBTS_ID = T2.LNBTS_ID
       AND T1.LNCEL_ID = T2.LNCEL_ID
       AND T1.PERIOD_START_TIME = T2.PERIOD_START_TIME
       AND T2.PERIOD_START_TIME = TO_DATE(''' || p_starttime ||''', ''DD.MM.YYYY HH24'')
     WHERE T2.MRBTS_ID IS NULL
     AND T2.LNBTS_ID IS NULL
     AND T2.LNCEL_ID IS NULL
     AND T2.PERIOD_START_TIME IS NULL' ;

  OPEN cur FOR sql_stmt;
  LOOP
    FETCH cur BULK COLLECT INTO t_array_col LIMIT limit_in;
    BEGIN
      FORALL i IN 1 .. t_array_col.COUNT SAVE EXCEPTIONS
        INSERT INTO NOKLTE_PS_LUEST_MNC1_RAW VALUES t_array_col (i);
   /*  EXCEPTION
     WHEN dml_errors THEN
        -- Capture exceptions to perform operations DML
             l_errors := sql%bulk_exceptions.count;
                for i in 1 .. l_errors
                loop
                    l_errno := sql%bulk_exceptions(i).error_code;
                    l_msg   := sqlerrm(-l_errno);
                    l_idx   := sql%bulk_exceptions(i).error_index;

                    INSERT INTO ERROR_LOG(ID, IMPORT_DATE, SOURCE, TARGET,FINS_ID, PERIOD_START_TIME,
          UNIT_ID,ERROR_NRO,ERROR_MESG)
                    VALUES
                    (seq_error_log.NEXTVAL,sysdate,p_source1_table,p_target_table,
                     t_array_col(l_idx).FINS_ID,t_array_col(l_idx).PERIOD_START_TIME,
           t_array_col(l_idx).UNIT_ID,l_errno,l_msg);

                end loop;
    -- end --*/
    
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
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

/
