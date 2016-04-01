--------------------------------------------------------
--  DDL for Procedure P_LTE_NSN_AVA_NE_INS_MONTHLY
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HARRIAGUE"."P_LTE_NSN_AVA_NE_INS_MONTHLY" (P_FECHA_DESDE     IN CHAR,
                                                                   P_FECHA_HASTA      IN CHAR,
                                                                   P_SUBCLASS_TABLE   IN CHAR,
                                                                   P_LEVEL            IN CHAR) IS

-- Autor: Paula Fernandez Fecha: 17.09.2015.
-- Actualizacion: Mariano Moron. Fecha 22.09.2015. Motivo: Se agregan calculo de IBHM.


CURSOR PERIODO (P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR, P_MESES IN NUMBER) IS
SELECT DISTINCT MES, TO_CHAR(MES, 'DD.MM.YYYY') FECHA_CHR
  FROM CALIDAD_STATUS_REFERENCES
 WHERE FECHA BETWEEN TO_DATE(P_FECHA_DESDE, 'DD.MM.YYYY')
                 AND TO_DATE(P_FECHA_HASTA, 'DD.MM.YYYY') + 86399/86400
   AND HORA = '00'
   AND DIA >= ADD_MONTHS(TRUNC(SYSDATE, 'MONTH'), - P_MESES)
 ORDER BY MES DESC;

V_TABLA_A_TRUNCAR  VARCHAR2(50);
V_CANTIDAD_MESES   NUMBER;

BEGIN

-- Control y Definicion de Parametros

SELECT DECODE(P_LEVEL,'IBHM' , 'AvailabilityNeIBHM',
                      'DAYM'   , 'AvailabilityNeDayM' ) TABLA_A_TRUNCAR,
       PRM_VALUE CANTIDAD_MESES
  INTO V_TABLA_A_TRUNCAR,
       V_CANTIDAD_MESES
  FROM CALIDAD_PARAMETROS
 WHERE PRM_ID = 267;

IF V_TABLA_A_TRUNCAR IS NOT NULL THEN

  P_LTE_TRUNCATE_SPART_MONTHLY (P_FECHA_DESDE, P_FECHA_HASTA, V_TABLA_A_TRUNCAR, P_SUBCLASS_TABLE);

  FOR SEN IN PERIODO (P_FECHA_DESDE, P_FECHA_HASTA, V_CANTIDAD_MESES) LOOP

    IF P_LEVEL = 'DAYM' THEN

      IF P_SUBCLASS_TABLE = 'LNBTS' THEN
          --DBMS_OUTPUT.PUT_LINE('TEST');
          P_LTE_NSN_AVA_LNB_DAYM_INS (SEN.FECHA_CHR);
      ELSE
          --DBMS_OUTPUT.PUT_LINE('TEST');
          P_LTE_NSN_AVA_NE_DAYM_INS (P_SUBCLASS_TABLE, SEN.FECHA_CHR);

      END IF;

    ELSIF P_LEVEL = 'IBHM' THEN

      IF P_SUBCLASS_TABLE = 'LNBTS' THEN
          --DBMS_OUTPUT.PUT_LINE('TEST');
          P_LTE_NSN_AVA_LNB_IBHM_INS (SEN.FECHA_CHR);
      ELSE
          --DBMS_OUTPUT.PUT_LINE('TEST');
          P_LTE_NSN_AVA_NE_IBHM_INS (P_SUBCLASS_TABLE, SEN.FECHA_CHR);

      END IF;

    END IF;

  END LOOP;

END IF;

END;

/
