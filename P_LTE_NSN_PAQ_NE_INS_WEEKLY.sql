--------------------------------------------------------
--  DDL for Procedure P_LTE_NSN_PAQ_NE_INS_WEEKLY
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HARRIAGUE"."P_LTE_NSN_PAQ_NE_INS_WEEKLY" (P_FECHA_DESDE     IN CHAR,
                                                                   P_FECHA_HASTA      IN CHAR,
                                                                   P_SUBCLASS_TABLE   IN CHAR,
                                                                   P_LEVEL            IN CHAR) IS

-- Autor: Paula Fernandez Fecha: 15.09.2015.
-- Actualizacion: Mariano Moron. Fecha: 21.09.2015. Motivo: Se agrega procesamiento de BH.

CURSOR PERIODO (P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR, P_SEMANAS IN NUMBER) IS
SELECT TO_CHAR(FECHA, 'DD.MM.YYYY') FECHA_CHR
  FROM CALIDAD_STATUS_REFERENCES
 WHERE FECHA BETWEEN TO_DATE(P_FECHA_DESDE, 'DD.MM.YYYY')
                 AND TO_DATE(P_FECHA_HASTA, 'DD.MM.YYYY') + 86399/86400
   AND HORA = '00'
   AND DIA_DESC = 'DOMINGO'
   AND DIA >= TRUNC(SYSDATE, 'DAY') - (7 * P_SEMANAS)
 ORDER BY FECHA DESC;

V_TABLA_A_TRUNCAR  VARCHAR2(50);
V_CANTIDAD_SEMANAS NUMBER;

BEGIN

-- Control y Definicion de Parametros

SELECT DECODE(P_LEVEL, 'IBHW', 'PaQNeIBHW',
                       'DAYW'   , 'PaQNeDayW'    ) TABLA_A_TRUNCAR,
       PRM_VALUE CANTIDAD_SEMANAS
  INTO V_TABLA_A_TRUNCAR,
       V_CANTIDAD_SEMANAS
  FROM CALIDAD_PARAMETROS
 WHERE PRM_ID = 266;

IF V_TABLA_A_TRUNCAR IS NOT NULL THEN

  P_LTE_TRUNCATE_SPART_WEEKLY (P_FECHA_DESDE, P_FECHA_HASTA, V_TABLA_A_TRUNCAR, P_SUBCLASS_TABLE);

  FOR SEN IN PERIODO (P_FECHA_DESDE, P_FECHA_HASTA, V_CANTIDAD_SEMANAS) LOOP

    IF P_LEVEL = 'DAYW' THEN

      IF P_SUBCLASS_TABLE = 'LNBTS' THEN
          P_LTE_NSN_PAQ_LNB_DAYW_INS (SEN.FECHA_CHR);
      ELSE
          P_LTE_NSN_PAQ_NE_DAYW_INS (P_SUBCLASS_TABLE, SEN.FECHA_CHR);
      END IF;

     ELSIF P_LEVEL = 'IBHW' THEN

      IF P_SUBCLASS_TABLE = 'LNBTS' THEN
          P_LTE_NSN_PAQ_LNB_IBHW_INS (SEN.FECHA_CHR);
      ELSE
          P_LTE_NSN_PAQ_NE_IBHW_INS (P_SUBCLASS_TABLE, SEN.FECHA_CHR);
      END IF;

    END IF;

  END LOOP;

END IF;

END;

/
