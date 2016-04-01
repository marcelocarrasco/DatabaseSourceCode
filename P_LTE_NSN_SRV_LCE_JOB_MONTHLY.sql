--------------------------------------------------------
--  DDL for Procedure P_LTE_NSN_SRV_LCE_JOB_MONTHLY
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HARRIAGUE"."P_LTE_NSN_SRV_LCE_JOB_MONTHLY" 
IS
-- Autor: Mariano Moron. Fecha: 10.09.2015.
-- Actualizacion: Mariano Moron. Fecha 22.09.2015. Motivo: Se agregan calculo de IBHM.
P_FECHA_DESDE VARCHAR2(15) := TO_CHAR( add_months(TRUNC(SYSDATE, 'MONTH'), -1), 'DD.MM.YYYY');
P_FECHA_HASTA VARCHAR2(15) := TO_CHAR( TRUNC(SYSDATE, 'MONTH') -1 + (86399 / 86400), 'DD.MM.YYYY');
P_SUBCLASS_TABLE VARCHAR2(10) := 'LCE';

 BEGIN

 P_LTE_NSN_SRV_LCE_INS_MONTHLY(P_FECHA_DESDE, P_FECHA_HASTA, P_SUBCLASS_TABLE, 'DAYM');

 P_LTE_NSN_SRV_LCE_INS_MONTHLY(P_FECHA_DESDE, P_FECHA_HASTA, P_SUBCLASS_TABLE, 'IBHM');

 END;

/
