--------------------------------------------------------
--  DDL for Procedure P_LTE_NSN_PAQ_LCEL_J_INS_DAILY
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HARRIAGUE"."P_LTE_NSN_PAQ_LCEL_J_INS_DAILY" 
IS

-- Autor: Paula Fernandez. Fecha: 09.09.2015.
-- Actualizacion: Mariano Moron. Fecha: 16.09.2015. Motivo: Se agrega procesamiento de BH.
P_FECHA_DESDE VARCHAR2(15) := TO_CHAR( TRUNC(SYSDATE, 'DD') - 3, 'DD.MM.YYYY');
P_FECHA_HASTA VARCHAR2(15) := TO_CHAR( TRUNC(SYSDATE, 'DD') -1, 'DD.MM.YYYY');
P_SUBCLASS_TABLE VARCHAR2(10) := 'LCE';

 BEGIN

 P_LTE_NSN_PAQ_LCEL_INS_DAILY(P_FECHA_DESDE, P_FECHA_HASTA, P_SUBCLASS_TABLE, 'DAY');

 P_LTE_NSN_PAQ_LCEL_INS_DAILY(P_FECHA_DESDE, P_FECHA_HASTA, P_SUBCLASS_TABLE, 'BH');

 END;

/
