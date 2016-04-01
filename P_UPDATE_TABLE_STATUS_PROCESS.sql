--------------------------------------------------------
--  DDL for Procedure P_UPDATE_TABLE_STATUS_PROCESS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HARRIAGUE"."P_UPDATE_TABLE_STATUS_PROCESS" (
p_external_import_table     IN VARCHAR)
 IS
  sql_stmt VARCHAR2(4000);
  TYPE cur_typ IS REF CURSOR;
  cur CUR_TYP;

  dml_errors EXCEPTION;
  PRAGMA EXCEPTION_INIT(dml_errors, -24381);
  -- LOG --
 /* l_errors number;
  l_errno    number;
  l_msg    varchar2(4000);
  l_idx    number;*/
  -- END LOG --
  limit_in PLS_INTEGER := 100;

  TYPE t_array_tab IS TABLE OF STATUS_PROCESS_ETL%ROWTYPE;
  t_array_col t_array_tab;

BEGIN
  sql_stmt := 'SELECT ET.FILENAME,
       ET.DATE_IMPORT,
       ET.STATUS,
       REGEXP_REPLACE(REGEXP_SUBSTR(ET.FILENAME,''\.([A-Z]*[a-z]*[0-9]*[_]*){1,10}\.''),''\.'', '''') MEASUREMENT_TYPE,
       REGEXP_REPLACE(REGEXP_SUBSTR(ET.FILENAME,''*_[A-Z]*_*''),''_'', '''') NETWORK_ELEMENT,
       NULL DATE_PROCESS
       FROM '|| p_external_import_table ||' ET WHERE FILENAME LIKE ''%.all''';

  OPEN cur FOR sql_stmt;
  LOOP
    FETCH cur BULK COLLECT INTO t_array_col LIMIT limit_in;
    BEGIN
      FORALL i IN 1 .. t_array_col.COUNT SAVE EXCEPTIONS
        INSERT INTO STATUS_PROCESS_ETL VALUES t_array_col (i);
   /*EXCEPTION
      WHEN dml_errors THEN
        -- Capture exceptions to perform operations DML
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

                end loop;*/
    -- end --
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
