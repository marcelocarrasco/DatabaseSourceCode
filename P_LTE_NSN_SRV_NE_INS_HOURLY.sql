--------------------------------------------------------
--  DDL for Procedure P_LTE_NSN_SRV_NE_INS_HOURLY
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HARRIAGUE"."P_LTE_NSN_SRV_NE_INS_HOURLY" (P_FECHA_DESDE     IN CHAR,
                                                                   P_FECHA_HASTA     IN CHAR,
                                                                   P_SUBCLASS_TABLE  IN CHAR,
                                                                   P_LEVEL           IN CHAR) IS

-- Autor: Mariano Moron. Fecha: 11.09.2015.

-- Validacion de periodo
CURSOR PERIODO (P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR, P_SEMANAS IN NUMBER) IS
SELECT TO_CHAR(FECHA, 'DD.MM.YYYY HH24') FECHA
  FROM CALIDAD_STATUS_REFERENCES
 WHERE FECHA BETWEEN TO_DATE(P_FECHA_DESDE, 'DD.MM.YYYY HH24')
                 AND TO_DATE(P_FECHA_HASTA, 'DD.MM.YYYY HH24')
   AND DIA > TRUNC(SYSDATE) - (7 * P_SEMANAS)
 ORDER BY FECHA DESC;

V_TABLA_A_TRUNCAR  VARCHAR2(30);
V_CANTIDAD_SEMANAS NUMBER;

BEGIN

-- Control y Definicion de Parametros

SELECT DECODE(P_LEVEL, 'HOUR', 'ServiceNeHour') TABLA_A_TRUNCAR,
       PRM_VALUE CANTIDAD_SEMANAS
  INTO V_TABLA_A_TRUNCAR,
       V_CANTIDAD_SEMANAS
  FROM CALIDAD_PARAMETROS
 WHERE PRM_ID = 264;

IF V_TABLA_A_TRUNCAR IS NOT NULL THEN

  P_LTE_TRUNCATE_SPART_HOURLY (P_FECHA_DESDE, P_FECHA_HASTA, V_TABLA_A_TRUNCAR, P_SUBCLASS_TABLE);

  FOR SEN IN PERIODO (P_FECHA_DESDE, P_FECHA_HASTA, V_CANTIDAD_SEMANAS) LOOP

    IF P_LEVEL = 'HOUR' THEN

       IF P_SUBCLASS_TABLE = 'LNBTS' THEN
         
         P_LTE_NSN_SRV_LNB_HOUR_INS (SEN.FECHA, SEN.FECHA);

       ELSE

         P_LTE_NSN_SRV_NE_HOUR_INS (P_SUBCLASS_TABLE, SEN.FECHA, SEN.FECHA);

       END IF;

    END IF;

  END LOOP;

END IF;

END;

/
