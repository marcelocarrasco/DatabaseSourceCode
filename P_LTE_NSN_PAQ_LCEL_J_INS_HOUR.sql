--------------------------------------------------------
--  DDL for Procedure P_LTE_NSN_PAQ_LCEL_J_INS_HOUR
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HARRIAGUE"."P_LTE_NSN_PAQ_LCEL_J_INS_HOUR" 
IS

P_FECHA_DESDE VARCHAR2(15) := TO_CHAR( TRUNC(SYSDATE, 'HH24') - 5/24, 'DD.MM.YYYY HH24');
P_FECHA_HASTA VARCHAR2(15) := TO_CHAR( TRUNC(SYSDATE, 'HH24'), 'DD.MM.YYYY HH24');
P_SUBCLASS_TABLE VARCHAR2(10) := 'LCE';

 BEGIN

 P_LTE_NSN_PAQ_LCE_INS_HOURLY(P_FECHA_DESDE, P_FECHA_HASTA, P_SUBCLASS_TABLE, 'HOUR');

 END;

/
