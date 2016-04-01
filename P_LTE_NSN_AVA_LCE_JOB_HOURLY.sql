--------------------------------------------------------
--  DDL for Procedure P_LTE_NSN_AVA_LCE_JOB_HOURLY
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HARRIAGUE"."P_LTE_NSN_AVA_LCE_JOB_HOURLY" 
IS
-- Autor: Mariano Moron. Fecha: 09.09.2015.
P_FECHA_DESDE VARCHAR2(15) := TO_CHAR( TRUNC(SYSDATE, 'HH24') - 5/24, 'DD.MM.YYYY HH24');
P_FECHA_HASTA VARCHAR2(15) := TO_CHAR( TRUNC(SYSDATE, 'HH24'), 'DD.MM.YYYY HH24');
P_SUBCLASS_TABLE VARCHAR2(10) := 'LCE';

 BEGIN

 P_LTE_NSN_AVA_LCE_INS_HOURLY(P_FECHA_DESDE, P_FECHA_HASTA,P_SUBCLASS_TABLE, 'HOUR' );

 END;

/
