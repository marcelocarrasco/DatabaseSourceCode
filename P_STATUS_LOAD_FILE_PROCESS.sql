--------------------------------------------------------
--  DDL for Procedure P_STATUS_LOAD_FILE_PROCESS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HARRIAGUE"."P_STATUS_LOAD_FILE_PROCESS" (
p_path_file IN VARCHAR2, p_status IN VARCHAR2)
 AS
 BEGIN
  IF(p_status ='1' OR p_status ='2' OR p_status ='5') THEN
      IF(p_status='1') THEN
       -- update table STATUS_PROCESS_ETL whith information the xml status 1: processed.
       update STATUS_PROCESS_ETL set status ='1', date_process = SYSDATE where filename = p_path_file;
       ELSIF(p_status='2')THEN
       -- update table STATUS_PROCESS_ETL whith information the xml status 2: error processed.
        update STATUS_PROCESS_ETL set status ='2', date_process = SYSDATE where filename = p_path_file;
        ELSIF(p_status = '5')THEN
        -- update table STATUS_PROCESS_ETL whith information the xml status 5: processing.
        update STATUS_PROCESS_ETL set status ='5', date_process = SYSDATE where filename = p_path_file;
        
  END IF;
  ELSE
     DBMS_OUTPUT.PUT_LINE('No es un valor valido para el parametro status.');
  END IF;

EXCEPTION
  WHEN OTHERS THEN
   RAISE_APPLICATION_ERROR(-20001,'Se ha encontrado un error'||SQLCODE||' -ERROR- '||SQLERRM);
END;

/
