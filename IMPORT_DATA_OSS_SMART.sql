--------------------------------------------------------
--  DDL for Procedure IMPORT_DATA_OSS_SMART
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HARRIAGUE"."IMPORT_DATA_OSS_SMART" IS

  dml_errors EXCEPTION;
  PRAGMA EXCEPTION_INIT(dml_errors, -24381);
  l_errors number;
  l_errno    number;
  l_msg    varchar2(4000);
  l_idx    number;

  limit_in PLS_INTEGER := 100;

  TYPE t_array_tab IS TABLE OF T_NOKLTE_PS_LCELAV_MNC1_RAW%ROWTYPE;
  t_array_col t_array_tab;
  sql_stmt VARCHAR2(4000);
  TYPE cur_typ IS REF CURSOR;
  cur CUR_TYP;
  
  p_source1_table CONSTANT VARCHAR2(100) :='NOKLTE_PS_LCELAV_MNC1_RAW@OSSRC3.WORLD';
  p_source2_table CONSTANT VARCHAR2(100) :='OBJECTS_SP_LTE';
  p_target_table CONSTANT VARCHAR2(100) :='T_NOKLTE_PS_LCELAV_MNC1_RAW';
  p_type_object_class CONSTANT VARCHAR2(100) := '3130';

BEGIN
     sql_stmt := 'SELECT T2.LNCEL_ID AS INT_ID, T2.LNCEL_NAME, T1.*
     FROM ' || p_source1_table || ' T1
     INNER JOIN ' || p_source2_table || ' T2
        ON T1.LNCEL_ID = T2.LNCEL_ID
     LEFT OUTER JOIN ' || p_target_table || ' T3
       ON T1.LNCEL_ID = T3.INT_ID
       AND T1.PERIOD_START_TIME = T3.PERIOD_START_TIME
     WHERE T3.INT_ID IS NULL
       AND T3.PERIOD_START_TIME IS NULL
       AND T2.LNCEL_OBJECT_CLASS =' || p_type_object_class ||
     ' AND SYSDATE BETWEEN T2.LNCEL_VALID_START_DATE AND T2.LNCEL_VALID_FINISH_DATE';
       
   OPEN cur FOR sql_stmt;
  LOOP
    FETCH cur BULK COLLECT INTO t_array_col LIMIT limit_in;
    BEGIN
      FORALL i IN 1 .. t_array_col.COUNT SAVE EXCEPTIONS
        
        INSERT INTO T_NOKLTE_PS_LCELAV_MNC1_RAW VALUES t_array_col (i);
        
        
    EXCEPTION
      WHEN dml_errors THEN
         l_errors := sql%bulk_exceptions.count;
                for i in 1 .. l_errors
                loop
                    l_errno := sql%bulk_exceptions(i).error_code;
                    l_msg   := sqlerrm(-l_errno);
                    l_idx   := sql%bulk_exceptions(i).error_index;
                    
                    INSERT INTO ERROR_LOG(ID, IMPORT_DATE, SOURCE, TARGET, LNBTS_ID, LNCEL_ID, PERIOD_START_TIME,
                     MCC_ID, MNC_ID, ERROR_NRO, ERROR_MESG)
                    VALUES
                    (seq_error_log.NEXTVAL,sysdate,p_source1_table,p_target_table,t_array_col(l_idx).LNBTS_ID,
                     t_array_col(l_idx).LNCEL_ID,t_array_col(l_idx).PERIOD_START_TIME,t_array_col(l_idx).MCC_ID,
                     t_array_col(l_idx).MNC_ID, l_errno,l_msg );
              
                end loop;
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
