--------------------------------------------------------
--  DDL for Procedure P_LTE_NSN_UPDATE_REWORK
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HARRIAGUE"."P_LTE_NSN_UPDATE_REWORK" 
   ( name_in IN varchar2, status_in IN varchar2 )
IS

BEGIN

  UPDATE LTE_NSN_REWORK_STATUS
  SET REWORK_STATUS = status_in
  WHERE REWORK_NAME = name_in;

  COMMIT;

EXCEPTION
WHEN OTHERS THEN
   raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
END;

/
