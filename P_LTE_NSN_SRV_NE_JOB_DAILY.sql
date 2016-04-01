--------------------------------------------------------
--  DDL for Procedure P_LTE_NSN_SRV_NE_JOB_DAILY
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HARRIAGUE"."P_LTE_NSN_SRV_NE_JOB_DAILY" 
IS
-- Autor: Mariano Moron. Fecha: 14.09.2015.
-- Actualizacion: Mariano Moron. Fecha: 21.09.2015. Motivo: Se agrega procesamiento de BH.
P_FECHA_DESDE VARCHAR2(15) := TO_CHAR( TRUNC(SYSDATE, 'DD') - 3, 'DD.MM.YYYY');
P_FECHA_HASTA VARCHAR2(15) := TO_CHAR( TRUNC(SYSDATE, 'DD') -1, 'DD.MM.YYYY');
P_LEVEL_DAY VARCHAR2(10) := 'DAY';
P_LEVEL_BH VARCHAR2(10) := 'BH';


 BEGIN
 --Procesamiento de valores diarios

 P_LTE_NSN_SRV_NE_INS_DAILY(P_FECHA_DESDE, P_FECHA_HASTA, 'LNBTS', P_LEVEL_DAY);

 P_LTE_NSN_SRV_NE_INS_DAILY(P_FECHA_DESDE, P_FECHA_HASTA, 'ALM', P_LEVEL_DAY);

 P_LTE_NSN_SRV_NE_INS_DAILY(P_FECHA_DESDE, P_FECHA_HASTA, 'MERCADO', P_LEVEL_DAY);

 P_LTE_NSN_SRV_NE_INS_DAILY(P_FECHA_DESDE, P_FECHA_HASTA, 'PAIS', P_LEVEL_DAY);

 P_LTE_NSN_SRV_NE_INS_DAILY(P_FECHA_DESDE, P_FECHA_HASTA, 'CIUDAD', P_LEVEL_DAY);

--Procesamiento de Busy Hour

 P_LTE_NSN_SRV_NE_INS_DAILY(P_FECHA_DESDE, P_FECHA_HASTA, 'LNBTS', P_LEVEL_BH);

 P_LTE_NSN_SRV_NE_INS_DAILY(P_FECHA_DESDE, P_FECHA_HASTA, 'ALM', P_LEVEL_BH);

 P_LTE_NSN_SRV_NE_INS_DAILY(P_FECHA_DESDE, P_FECHA_HASTA, 'MERCADO', P_LEVEL_BH);

 P_LTE_NSN_SRV_NE_INS_DAILY(P_FECHA_DESDE, P_FECHA_HASTA, 'PAIS', P_LEVEL_BH);

 P_LTE_NSN_SRV_NE_INS_DAILY(P_FECHA_DESDE, P_FECHA_HASTA, 'CIUDAD', P_LEVEL_BH);


 END;

/
