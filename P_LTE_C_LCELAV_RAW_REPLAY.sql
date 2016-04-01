--------------------------------------------------------
--  DDL for Procedure P_LTE_C_LCELAV_RAW_REPLAY
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HARRIAGUE"."P_LTE_C_LCELAV_RAW_REPLAY" (P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR)
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

  TYPE t_array_tab IS TABLE OF NOKLTE_PS_LCELAV_MNC1_RAW%ROWTYPE;
  t_array_col t_array_tab;


 BEGIN

      sql_stmt := ' SELECT DISTINCT
      r.MRBTS_ID,
      r.LNBTS_ID ,
      r.LNCEL_ID ,
      r.MCC_ID   ,
      r.MNC_ID   ,
      r.PERIOD_START_TIME + 7 PERIOD_START_TIME,
      r.PERIOD_DURATION ,
      r.PERIOD_DURATION_SUM    ,
      r.CHNG_TO_CELL_AVAIL     ,
      r.CHNG_TO_CELL_PLAN_UNAVAIL     ,
      r.CHNG_TO_CELL_UNPLAN_UNAVAIL   ,
      r.SAMPLES_CELL_AVAIL     ,
      r.SAMPLES_CELL_PLAN_UNAVAIL     ,
      r.SAMPLES_CELL_UNPLAN_UNAVAIL   ,
      r.DENOM_CELL_AVAIL
  FROM NOKLTE_PS_LCELAV_MNC1_RAW r
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
        INSERT INTO NOKLTE_PS_LCELAV_MNC1_RAW VALUES t_array_col (i);
        
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
