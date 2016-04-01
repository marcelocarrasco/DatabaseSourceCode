--------------------------------------------------------
--  DDL for Procedure P_LTE_TRAFIC_LCEL_IBHW_AUX
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HARRIAGUE"."P_LTE_TRAFIC_LCEL_IBHW_AUX" (P_FECHA IN CHAR)
IS
-- Autor: Mariano Moron. Fecha: 18.09.2015.
DML_ERRORS EXCEPTION;
PRAGMA EXCEPTION_INIT(DML_ERRORS, -24381);
    -- LOG --111
L_ERRORS NUMBER;
L_ERRNO    NUMBER;
L_MSG    VARCHAR2(4000);
L_IDX    NUMBER;
  -- END LOG --

LIMIT_IN PLS_INTEGER := 100;
V_CANTIDAD    NUMBER := 3;

V_FECHA_DESDE VARCHAR2(10);
V_FECHA_HASTA VARCHAR2(10);

V_LINEA       VARCHAR2(200);

TYPE T_ARRAY_TAB IS TABLE OF LTE_TRAFIC_LCEL_IBHW_AUX%ROWTYPE;
T_ARRAY_COL T_ARRAY_TAB;


CURSOR CUR (P_DATE_INI VARCHAR2, P_DATE_FIN VARCHAR2, P_CANT NUMBER) IS
  SELECT FECHA,
         LNCEL_NAME,
         MRBTS_ID,
         LNBTS_ID,
         LNCEL_ID,
         TRAFICO_DL,
         ORDEN
    FROM (
          SELECT FECHA,
                 LNCEL_NAME,
                 MRBTS_ID,
                 LNBTS_ID,
                 LNCEL_ID,
                 TRAFICO_DL,
                 ROW_NUMBER() OVER(PARTITION BY LNCEL_ID ORDER BY TRAFICO_DL DESC, FECHA DESC NULLS LAST) ORDEN
            FROM (
                  SELECT FECHA,
                         LNCEL_NAME,
                         MRBTS_ID,
                         LNBTS_ID,
                         LNCEL_ID,
                         TRAFICO_DL,
                         CASE WHEN BTS_NAME IS NULL AND FECHA_DESDE IS NULL THEN 'TRAER' ELSE 'NO TRAER' END CONDICION
                    FROM (
                          SELECT A.FECHA,
                                 B.LNCEL_NAME,
                                 A.MRBTS_ID,
                                 A.LNBTS_ID,
                                 A.LNCEL_ID,
                                 A.TRAFICO_DL
                            FROM LTE_NSN_SERVICE_LCEL_BH A,
                                 OBJECTS_SP_LTE          B
                           WHERE A.LNCEL_ID = B.LNCEL_ID (+)
                             AND FECHA BETWEEN TO_DATE(P_DATE_INI, 'DD.MM.YYYY')
                                           AND TO_DATE(P_DATE_FIN, 'DD.MM.YYYY') + 86399/86400
                         ) C,
                         MULTIVENDOR_EXCLUIDAS D
                   WHERE C.LNCEL_NAME        = NVL(D.BTS_NAME    (+), C.LNCEL_NAME)
                     AND C.FECHA             = NVL(D.FECHA_DESDE (+), C.FECHA)
                     AND D.TIPO_ISABH (+) = 'WEEK'
                     AND D.TECNOLOGIA (+) = 'LTE'
                 )
           WHERE CONDICION = 'TRAER'
         )
   WHERE ORDEN <= P_CANT;

BEGIN

-- Truncate Partition Table Aux

BEGIN

SELECT 'TRUNCATE TABLE HARRIAGUE.LTE_TRAFIC_LCEL_IBHW_AUX' LINEA
  INTO V_LINEA
  FROM DUAL;

EXECUTE IMMEDIATE V_LINEA;

EXCEPTION

WHEN OTHERS THEN
NULL;

END;

SELECT TO_CHAR(TRUNC(TO_DATE(P_FECHA, 'DD.MM.YYYY'), 'DAY'), 'DD.MM.YYYY')      FECHA_DESDE,
       TO_CHAR(TRUNC(TO_DATE(P_FECHA, 'DD.MM.YYYY'), 'DAY') + 6 , 'DD.MM.YYYY') FECHA_HASTA
  INTO V_FECHA_DESDE,
       V_FECHA_HASTA
  FROM DUAL;


OPEN CUR (V_FECHA_DESDE, V_FECHA_HASTA, V_CANTIDAD);

LOOP
  FETCH CUR BULK COLLECT INTO T_ARRAY_COL LIMIT LIMIT_IN;
  BEGIN
    FORALL I IN 1 .. T_ARRAY_COL.COUNT SAVE EXCEPTIONS
      INSERT INTO LTE_TRAFIC_LCEL_IBHW_AUX VALUES T_ARRAY_COL (I);
  EXCEPTION
    WHEN DML_ERRORS THEN
      -- CAPTURE EXCEPTIONS TO PERFORM OPERATIONS DML
           L_ERRORS := SQL%BULK_EXCEPTIONS.COUNT;
              FOR I IN 1 .. L_ERRORS
              LOOP
                  L_ERRNO := SQL%BULK_EXCEPTIONS(I).ERROR_CODE;
                  L_MSG   := SQLERRM(-L_ERRNO);
                  L_IDX   := SQL%BULK_EXCEPTIONS(I).ERROR_INDEX;
                  /*
                  INSERT INTO ERROR_LOG(ID, IMPORT_DATE, SOURCE, TARGET, LNBTS_ID, LNCEL_ID, PERIOD_START_TIME,
                   MCC_ID, MNC_ID, ERROR_NRO, ERROR_MESG)
                  VALUES
                  (SEQ_ERROR_LOG.NEXTVAL,SYSDATE,P_SOURCE1_TABLE,P_TARGET_TABLE,T_ARRAY_COL(L_IDX).LNBTS_ID,
                   T_ARRAY_COL(L_IDX).LNCEL_ID,T_ARRAY_COL(L_IDX).PERIOD_START_TIME,T_ARRAY_COL(L_IDX).MCC_ID,
                   T_ARRAY_COL(L_IDX).MNC_ID, L_ERRNO,L_MSG );
        */
              END LOOP;
  -- END --
  END;
  EXIT WHEN CUR%NOTFOUND;
END LOOP;
COMMIT;
CLOSE CUR;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

/
