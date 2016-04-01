--------------------------------------------------------
--  DDL for Procedure P_LTE_NSN_PAQ_NE_INS_DAILY_R
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HARRIAGUE"."P_LTE_NSN_PAQ_NE_INS_DAILY_R" (P_FECHA_DESDE     IN CHAR,
                                                          P_FECHA_HASTA     IN CHAR,
                                                          P_LEVEL           IN CHAR,
                                                          P_RESULT OUT NUMBER) IS


-- Autor: Mariano Moron. Fecha: 21.10.2015.

-- Validaci?n de periodo
CURSOR PERIODO (P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR) IS
SELECT TO_CHAR(FECHA, 'DD.MM.YYYY') FECHA
  FROM CALIDAD_STATUS_REFERENCES
 WHERE FECHA BETWEEN TO_DATE(P_FECHA_DESDE, 'DD.MM.YYYY')
                 AND TO_DATE(P_FECHA_HASTA, 'DD.MM.YYYY') + 86399/86400
   AND HORA = '00'
 ORDER BY FECHA DESC;

V_TABLA_A_TRUNCAR VARCHAR2(30);

CURSOR ELEMENTOS IS
SELECT 'LNBTS'   NE FROM DUAL UNION ALL
SELECT 'ALM'     NE FROM DUAL UNION ALL
SELECT 'MERCADO' NE FROM DUAL UNION ALL
SELECT 'PAIS'    NE FROM DUAL UNION ALL
SELECT 'CIUDAD'  NE FROM DUAL;

BEGIN

-- Control y Definicion de Parametros

SELECT DECODE(P_LEVEL, 'BH', 'PowerAndQualityNeBH',
                      'DAY', 'PowerAndQualityNeDay') TABLA_A_TRUNCAR
  INTO V_TABLA_A_TRUNCAR
  FROM DUAL;

IF V_TABLA_A_TRUNCAR IS NOT NULL THEN

FOR SEN IN PERIODO (P_FECHA_DESDE, P_FECHA_HASTA) LOOP

    FOR SYN IN ELEMENTOS LOOP

      P_LTE_TRUNCATE_SPARTITION (SEN.FECHA, SEN.FECHA, V_TABLA_A_TRUNCAR, SYN.NE);

      IF P_LEVEL = 'DAY' THEN

        IF SYN.NE = 'LNBTS' THEN
            P_LTE_NSN_PAQ_LNB_DAY_INS (SEN.FECHA, SEN.FECHA);
        ELSE
            P_LTE_NSN_PAQ_NE_DAY_INS (SYN.NE, SEN.FECHA, SEN.FECHA);
        END IF;

      ELSIF P_LEVEL = 'BH' THEN

        IF SYN.NE = 'LNBTS' THEN
            P_LTE_NSN_PAQ_LNB_BH_INS (SEN.FECHA, SEN.FECHA);
        ELSE
            P_LTE_NSN_PAQ_NE_BH_INS (SYN.NE, SEN.FECHA, SEN.FECHA);
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
