--------------------------------------------------------
--  DDL for Procedure P_LTE_NSN_AVA_NE_INS_WEEKLY_R
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HARRIAGUE"."P_LTE_NSN_AVA_NE_INS_WEEKLY_R" (P_FECHA_DESDE     IN CHAR,
                                                           P_FECHA_HASTA      IN CHAR,
                                                           P_LEVEL            IN CHAR,
                                                            P_RESULT OUT NUMBER) IS

-- Autor: Mariano Morón. Fecha: 16.10.2015.

CURSOR PERIODO (P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR) IS
SELECT TO_CHAR(FECHA, 'DD.MM.YYYY') FECHA_CHR
  FROM CALIDAD_STATUS_REFERENCES
 WHERE FECHA BETWEEN TO_DATE(P_FECHA_DESDE, 'DD.MM.YYYY')
                 AND TO_DATE(P_FECHA_HASTA, 'DD.MM.YYYY') + 86399/86400
   AND HORA = '00'
   AND DIA_DESC = 'DOMINGO'
 ORDER BY FECHA DESC;

V_TABLA_A_TRUNCAR  VARCHAR2(50);

CURSOR ELEMENTOS IS
SELECT 'LNBTS'   NE FROM DUAL UNION ALL
SELECT 'ALM'     NE FROM DUAL UNION ALL
SELECT 'MERCADO' NE FROM DUAL UNION ALL
SELECT 'PAIS'    NE FROM DUAL UNION ALL
SELECT 'CIUDAD'  NE FROM DUAL;

BEGIN

-- Control y Definicion de Parametros

SELECT DECODE(P_LEVEL, 'IBHW', 'AvailabilityNeIBHW',
                       'DAYW'   , 'AvailabilityNeDayW'    ) TABLA_A_TRUNCAR
  INTO V_TABLA_A_TRUNCAR
  FROM DUAL;

IF V_TABLA_A_TRUNCAR IS NOT NULL THEN

FOR SEN IN PERIODO (P_FECHA_DESDE, P_FECHA_HASTA) LOOP

    FOR SYN IN ELEMENTOS LOOP

      P_LTE_TRUNCATE_SPART_WEEKLY (SEN.FECHA_CHR, SEN.FECHA_CHR, V_TABLA_A_TRUNCAR, SYN.NE);

      IF P_LEVEL = 'DAYW' THEN

        IF SYN.NE = 'LNBTS' THEN
            P_LTE_NSN_AVA_LNB_DAYW_INS (SEN.FECHA_CHR);
        ELSE
            P_LTE_NSN_AVA_NE_DAYW_INS (SYN.NE, SEN.FECHA_CHR);
        END IF;

      ELSIF P_LEVEL = 'IBHW' THEN

        IF SYN.NE = 'LNBTS' THEN
            P_LTE_NSN_AVA_LNB_IBHW_INS (SEN.FECHA_CHR);
        ELSE
            P_LTE_NSN_AVA_NE_IBHW_INS (SYN.NE, SEN.FECHA_CHR);
        END IF;

      END IF;

    END LOOP;

  END LOOP;

END IF;
P_RESULT := 0;

EXCEPTION WHEN OTHERS THEN
    P_RESULT := 1;
END;

/
