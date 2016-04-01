--------------------------------------------------------
--  DDL for Procedure P_LTE_NSN_AVA_LCE_INS_HOURLY
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HARRIAGUE"."P_LTE_NSN_AVA_LCE_INS_HOURLY" (P_FECHA_DESDE     IN CHAR,
                                                                    P_FECHA_HASTA     IN CHAR,
                                                                    P_SUBCLASS_TABLE  IN CHAR,
                                                                    P_LEVEL           IN CHAR) IS


-- Autor: Mariano Morón. Fecha: 04.11.2015.

V_TABLA_A_TRUNCAR VARCHAR2(30);

BEGIN

-- Control y Definicion de Parametros

SELECT DECODE(P_LEVEL, 'HOUR', 'AvailabilityLceHour') TABLA_A_TRUNCAR
  INTO V_TABLA_A_TRUNCAR
  FROM DUAL;

IF V_TABLA_A_TRUNCAR IS NOT NULL THEN

  P_LTE_TRUNCATE_SPART_HOURLY (P_FECHA_DESDE, P_FECHA_HASTA, V_TABLA_A_TRUNCAR, P_SUBCLASS_TABLE);

    IF P_LEVEL = 'HOUR' THEN

      P_LTE_NSN_AVA_LCE_HOUR_INS (P_FECHA_DESDE, P_FECHA_HASTA);

    END IF;

END IF;

END;

/
