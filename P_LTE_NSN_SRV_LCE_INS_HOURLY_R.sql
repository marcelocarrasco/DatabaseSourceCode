--------------------------------------------------------
--  DDL for Procedure P_LTE_NSN_SRV_LCE_INS_HOURLY_R
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HARRIAGUE"."P_LTE_NSN_SRV_LCE_INS_HOURLY_R" (P_FECHA_DESDE     IN CHAR,
                                                            P_FECHA_HASTA     IN CHAR,
                                                            P_SUBCLASS_TABLE  IN CHAR,
                                                            P_LEVEL           IN CHAR,
                                                            P_RESULT OUT NUMBER) IS


-- Autor: Mariano Morón. Fecha: 09.10.2015.

-- Validación de periodo
CURSOR PERIODO (P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR) IS
SELECT DIA,
       RESULTADO,
       MAX(FECHA_DESDE) FECHA_DESDE,
       MAX(FECHA_HASTA) FECHA_HASTA
  FROM (
SELECT DIA,
       RESULTADO,
       DECODE(RESTO, 0, FECHA) FECHA_DESDE,
       DECODE(RESTO, 5, FECHA) FECHA_HASTA
  FROM (
SELECT DIA,
       TO_CHAR(FECHA, 'DD.MM.YYYY HH24') FECHA,
       FLOOR(TO_NUMBER(HORA)/ 6) RESULTADO,
       MOD(TO_NUMBER(HORA), 6) RESTO
  FROM CALIDAD_STATUS_REFERENCES
WHERE FECHA BETWEEN TO_DATE(P_FECHA_DESDE, 'DD.MM.YYYY')
                 AND TO_DATE(P_FECHA_HASTA, 'DD.MM.YYYY') + 86399/86400
       )
       )
GROUP BY DIA, RESULTADO
ORDER BY DIA, RESULTADO;

V_TABLA_A_TRUNCAR VARCHAR2(30);

BEGIN

-- Control y Definicion de Parametros

SELECT DECODE(P_LEVEL, 'HOUR', 'ServiceLceHour') TABLA_A_TRUNCAR
  INTO V_TABLA_A_TRUNCAR
  FROM DUAL;

IF V_TABLA_A_TRUNCAR IS NOT NULL THEN

  FOR SEN IN PERIODO (P_FECHA_DESDE, P_FECHA_HASTA) LOOP

  P_LTE_TRUNCATE_SPART_HOURLY (SEN.FECHA_DESDE, SEN.FECHA_HASTA, V_TABLA_A_TRUNCAR, P_SUBCLASS_TABLE);

    IF P_LEVEL = 'HOUR' THEN

      P_LTE_NSN_SRV_LCE_HOUR_INS (SEN.FECHA_DESDE, SEN.FECHA_HASTA);

    END IF;

  END LOOP;

END IF;
P_RESULT := 0;

EXCEPTION WHEN OTHERS THEN
    P_RESULT := 1;
END;

/
