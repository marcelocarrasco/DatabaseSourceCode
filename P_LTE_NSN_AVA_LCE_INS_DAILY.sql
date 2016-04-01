--------------------------------------------------------
--  DDL for Procedure P_LTE_NSN_AVA_LCE_INS_DAILY
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HARRIAGUE"."P_LTE_NSN_AVA_LCE_INS_DAILY" (P_FECHA_DESDE     IN CHAR,
                                                                    P_FECHA_HASTA     IN CHAR,
                                                                    P_SUBCLASS_TABLE  IN CHAR,
                                                                    P_LEVEL           IN CHAR) IS


-- Autor: Mariano Morón. Fecha: 09.09.2015.
-- Actualizacion: Mariano Morón. Fecha: 09.09.2015. Motivo: Estandarización de nombres.
-- Actualizacion: Mariano Moron. Fecha: 16.09.2015. Motivo: Se agrega procesamiento de BH Availability.

-- Validación de periodo
CURSOR PERIODO (P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR, P_SEMANAS IN NUMBER) IS
SELECT TO_CHAR(FECHA, 'DD.MM.YYYY') FECHA
  FROM CALIDAD_STATUS_REFERENCES
 WHERE FECHA BETWEEN TO_DATE(P_FECHA_DESDE, 'DD.MM.YYYY')
                 AND TO_DATE(P_FECHA_HASTA, 'DD.MM.YYYY') + 86399/86400
   AND HORA = '00'
   AND DIA > TRUNC(SYSDATE) - (7 * P_SEMANAS)
 ORDER BY FECHA DESC;

V_TABLA_A_TRUNCAR VARCHAR2(30);
V_CANTIDAD_SEMANAS NUMBER;

BEGIN

-- Control y Definicion de Parametros

SELECT DECODE(P_LEVEL, 'BH', 'AvailabilityWcellBH',
                      'DAY', 'AvailabilityWcellDay') TABLA_A_TRUNCAR,
       PRM_VALUE CANTIDAD_SEMANAS
  INTO V_TABLA_A_TRUNCAR,
       V_CANTIDAD_SEMANAS
  FROM CALIDAD_PARAMETROS
 WHERE PRM_ID = 265;

IF V_TABLA_A_TRUNCAR IS NOT NULL THEN

  P_LTE_TRUNCATE_SPARTITION (P_FECHA_DESDE, P_FECHA_HASTA, V_TABLA_A_TRUNCAR, P_SUBCLASS_TABLE);

  IF P_LEVEL = 'BH' THEN
      P_LTE_NSN_LCEL_BH_CALC(P_FECHA_DESDE, P_FECHA_HASTA);
  END IF;

  FOR SEN IN PERIODO (P_FECHA_DESDE, P_FECHA_HASTA, V_CANTIDAD_SEMANAS) LOOP

    IF P_LEVEL = 'DAY' THEN

      P_LTE_NSN_AVA_LCE_DAY_INS (SEN.FECHA, SEN.FECHA);

    ELSIF P_LEVEL = 'BH' THEN

      P_LTE_NSN_AVA_LCEL_BH_INS (SEN.FECHA, SEN.FECHA);

    END IF;

  END LOOP;

END IF;

END;

/
