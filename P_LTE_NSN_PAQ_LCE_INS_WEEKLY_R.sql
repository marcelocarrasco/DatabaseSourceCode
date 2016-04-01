--------------------------------------------------------
--  DDL for Procedure P_LTE_NSN_PAQ_LCE_INS_WEEKLY_R
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HARRIAGUE"."P_LTE_NSN_PAQ_LCE_INS_WEEKLY_R" (P_FECHA_DESDE     IN CHAR,
                                                             P_FECHA_HASTA      IN CHAR,
                                                             P_SUBCLASS_TABLE   IN CHAR,
                                                             P_LEVEL            IN CHAR,
                                                            P_RESULT OUT NUMBER) IS

-- Autor: Mariano Moron. Fecha: 19.10.2015.

CURSOR PERIODO (P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR) IS
SELECT TO_CHAR(FECHA, 'DD.MM.YYYY') FECHA_CHR
  FROM CALIDAD_STATUS_REFERENCES
 WHERE FECHA BETWEEN TO_DATE(P_FECHA_DESDE, 'DD.MM.YYYY')
                 AND TO_DATE(P_FECHA_HASTA, 'DD.MM.YYYY') + 86399/86400
   AND HORA = '00'
   AND DIA_DESC = 'DOMINGO'
 ORDER BY FECHA DESC;

V_TABLA_A_TRUNCAR  VARCHAR2(50);

BEGIN

-- Control y Definicion de Parametros

SELECT DECODE(P_LEVEL, 'IBHW' , 'PaQWcellIBHW',
                       'DAYW'   , 'PaQWcellDayW'    ) TABLA_A_TRUNCAR
  INTO V_TABLA_A_TRUNCAR
  FROM DUAL;

IF V_TABLA_A_TRUNCAR IS NOT NULL THEN

  P_LTE_TRUNCATE_SPART_WEEKLY (P_FECHA_DESDE, P_FECHA_HASTA, V_TABLA_A_TRUNCAR, P_SUBCLASS_TABLE);

  FOR SEN IN PERIODO (P_FECHA_DESDE, P_FECHA_HASTA) LOOP

    IF P_LEVEL = 'DAYW' THEN

      P_LTE_NSN_PAQ_LCEL_DAYW_INS (SEN.FECHA_CHR);

    ELSIF P_LEVEL = 'IBHW' THEN

      P_LTE_TRAFIC_LCEL_IBHW_AUX(SEN.FECHA_CHR);

      P_LTE_NSN_PAQ_LCEL_IBHW_INS (SEN.FECHA_CHR);

    END IF;

  END LOOP;

END IF;
P_RESULT := 0;

EXCEPTION WHEN OTHERS THEN
    P_RESULT := 1;
END;

/
