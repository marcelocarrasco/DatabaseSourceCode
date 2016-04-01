--------------------------------------------------------
--  DDL for Procedure P_LTE_NSN_AVA_NE_JOB_MONTHLY
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HARRIAGUE"."P_LTE_NSN_AVA_NE_JOB_MONTHLY" 
IS
-- Autor: Paula Fernandez. Fecha: 17.09.2015.
P_FECHA_DESDE VARCHAR2(15) := TO_CHAR(add_months(TRUNC(SYSDATE, 'MONTH'), -1), 'DD.MM.YYYY');
P_FECHA_HASTA VARCHAR2(15) := TO_CHAR((TRUNC(SYSDATE, 'MONTH') - 1),'DD.MM.YYYY');

P_LEVEL VARCHAR2(10) := 'DAYM';

 BEGIN


 P_LTE_NSN_AVA_NE_INS_MONTHLY(P_FECHA_DESDE, P_FECHA_HASTA, 'LNBTS', P_LEVEL);

 P_LTE_NSN_AVA_NE_INS_MONTHLY(P_FECHA_DESDE, P_FECHA_HASTA, 'ALM', P_LEVEL);

 P_LTE_NSN_AVA_NE_INS_MONTHLY(P_FECHA_DESDE, P_FECHA_HASTA, 'MERCADO', P_LEVEL);

 P_LTE_NSN_AVA_NE_INS_MONTHLY(P_FECHA_DESDE, P_FECHA_HASTA, 'PAIS', P_LEVEL);

 P_LTE_NSN_AVA_NE_INS_MONTHLY(P_FECHA_DESDE, P_FECHA_HASTA, 'CIUDAD', P_LEVEL);

 END;



/
