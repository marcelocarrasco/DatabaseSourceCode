--------------------------------------------------------
--  DDL for Procedure CORE_CISCO_PDSN_GGSN_JOB_INS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HARRIAGUE"."CORE_CISCO_PDSN_GGSN_JOB_INS" 
IS
-- Autor: Mariano Moron. Fecha: 23.09.2015.
P_FECHA_DESDE VARCHAR2(15) := TO_CHAR( TRUNC(SYSDATE, 'HH24') - 4/24, 'DD.MM.YYYY HH24');
P_FECHA_HASTA VARCHAR2(15) := TO_CHAR( TRUNC(SYSDATE, 'HH24') - 1 + (86399 / 86400), 'DD.MM.YYYY HH24');

 BEGIN

  CORE_CISCO_L81801_GGSN_P(P_FECHA_DESDE, P_FECHA_HASTA );
  
  CORE_CISCO_L81802_GGSN_P(P_FECHA_DESDE, P_FECHA_HASTA );
  
  CORE_CISCO_L81804_GGSN_P(P_FECHA_DESDE, P_FECHA_HASTA );
  
  CORE_CISCO_L81C01_GGSN_P(P_FECHA_DESDE, P_FECHA_HASTA );
  exception
    WHEN others THEN
      PKG_ERROR_LOG_NEW.P_LOG_ERROR('CORE_CISCO_PDSN_GGSN_JOB_INS',SQLCODE,SQLERRM,'P_FECHA_DESDE '||P_FECHA_DESDE||' P_FECHA_HASTA '||P_FECHA_HASTA);
 END;

/
