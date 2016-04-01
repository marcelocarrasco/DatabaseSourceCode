--------------------------------------------------------
--  DDL for Procedure P_LTE_NSN_SRV_LCE_JOB_WEEKLY
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HARRIAGUE"."P_LTE_NSN_SRV_LCE_JOB_WEEKLY" 
IS
-- Autor: Mariano Moron. Fecha: 09.09.2015.
-- Actualizacion: Mariano Morón. Fecha: 21.09.2015. Motivo: Se agrega calculo IBHW.

P_FECHA_DESDE VARCHAR2(15) := TO_CHAR( TRUNC(SYSDATE, 'DAY') - 7, 'DD.MM.YYYY');
P_FECHA_HASTA VARCHAR2(15) := TO_CHAR( TRUNC(SYSDATE, 'DAY') - 1, 'DD.MM.YYYY');
P_SUBCLASS_TABLE VARCHAR2(10) := 'LCE';

 BEGIN

 P_LTE_NSN_SRV_LCE_INS_WEEKLY(P_FECHA_DESDE, P_FECHA_HASTA, P_SUBCLASS_TABLE, 'DAYW');


 P_LTE_NSN_SRV_LCE_INS_WEEKLY(P_FECHA_DESDE, P_FECHA_HASTA, P_SUBCLASS_TABLE, 'IBHW');

 END;

/
