--------------------------------------------------------
--  DDL for Procedure P_LTE_NSN_SRV_LCE_INS_DAILY_R
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HARRIAGUE"."P_LTE_NSN_SRV_LCE_INS_DAILY_R" (P_FECHA_DESDE     IN CHAR,
                                                            P_FECHA_HASTA     IN CHAR,
                                                            P_SUBCLASS_TABLE  IN CHAR,
                                                            P_LEVEL           IN CHAR,
                                                            P_RESULT OUT NUMBER) IS


-- Autor: Mariano Morón. Fecha: 09.10.2015.

-- Validación de periodo
CURSOR PERIODO (P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR) IS
SELECT TO_CHAR(FECHA, 'DD.MM.YYYY') FECHA
  FROM CALIDAD_STATUS_REFERENCES
 WHERE FECHA BETWEEN TO_DATE(P_FECHA_DESDE, 'DD.MM.YYYY')
                 AND TO_DATE(P_FECHA_HASTA, 'DD.MM.YYYY') + 86399/86400
   AND HORA = '00'
 ORDER BY FECHA DESC;

V_TABLA_A_TRUNCAR VARCHAR2(30);

BEGIN

-- Control y Definicion de Parametros

SELECT DECODE(P_LEVEL, 'BH', 'ServiceWcellBH',
                       'DAY', 'ServiceWcellDay') TABLA_A_TRUNCAR
  INTO V_TABLA_A_TRUNCAR
  FROM DUAL;

IF V_TABLA_A_TRUNCAR IS NOT NULL THEN

  P_LTE_TRUNCATE_SPARTITION (P_FECHA_DESDE, P_FECHA_HASTA, V_TABLA_A_TRUNCAR, P_SUBCLASS_TABLE);

    IF P_LEVEL = 'BH' THEN
      P_LTE_NSN_LCEL_BH_CALC(P_FECHA_DESDE, P_FECHA_HASTA);
    END IF;

  FOR SEN IN PERIODO (P_FECHA_DESDE, P_FECHA_HASTA) LOOP

    IF P_LEVEL = 'DAY' THEN
    	
     P_LTE_NSN_SRV_LCE_DAY_INS (SEN.FECHA, SEN.FECHA);

    ELSIF P_LEVEL = 'BH' THEN
    
     P_LTE_NSN_SRV_LCE_BH_INS(SEN.FECHA, SEN.FECHA);

    END IF;

  END LOOP;

END IF;
P_RESULT := 0;

EXCEPTION WHEN OTHERS THEN
    P_RESULT := 1;
END;

/
