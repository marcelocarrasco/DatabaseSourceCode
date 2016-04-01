--------------------------------------------------------
--  DDL for Procedure P_LTE_C_LCELLD_RAW_INS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HARRIAGUE"."P_LTE_C_LCELLD_RAW_INS" (P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR)
IS
-- AUTOR: MARIANO MORON. FECHA: 08.10.2015.
DML_ERRORS EXCEPTION;
PRAGMA EXCEPTION_INIT(DML_ERRORS, -24381);

LIMIT_IN PLS_INTEGER := 100;

TYPE T_ARRAY_TAB IS TABLE OF NOKLTE_PS_LCELLD_MNC1_RAW%ROWTYPE;
T_ARRAY_COL T_ARRAY_TAB;

/*CURSOR CUR_OSS2 (FECHA_DESDE VARCHAR2, FECHA_HASTA VARCHAR2) IS
SELECT T1.*
FROM NOKLTE_PS_LCELLD_MNC1_RAW@OSSRC2.WORLD T1
LEFT OUTER JOIN NOKLTE_PS_LCELLD_MNC1_RAW T3
ON T1.LNCEL_ID = T3.LNCEL_ID
AND T1.PERIOD_START_TIME = T3.PERIOD_START_TIME
WHERE T1.PERIOD_START_TIME BETWEEN TO_DATE(FECHA_DESDE, 'DD.MM.YYYY HH24')
                               AND TO_DATE(FECHA_HASTA, 'DD.MM.YYYY HH24') + (86399 / 86400)
AND T3.LNCEL_ID IS NULL
AND T3.PERIOD_START_TIME IS NULL;*/

CURSOR CUR_OSS3 (FECHA_DESDE VARCHAR2, FECHA_HASTA VARCHAR2) IS
SELECT T1.*
FROM NOKLTE_PS_LCELLD_MNC1_RAW@OSSRC3.WORLD T1
LEFT OUTER JOIN NOKLTE_PS_LCELLD_MNC1_RAW T3
ON T1.LNCEL_ID = T3.LNCEL_ID
AND T1.PERIOD_START_TIME = T3.PERIOD_START_TIME
WHERE T1.PERIOD_START_TIME BETWEEN TO_DATE(FECHA_DESDE, 'DD.MM.YYYY HH24')
                               AND TO_DATE(FECHA_HASTA, 'DD.MM.YYYY HH24') + (86399 / 86400)
AND T3.LNCEL_ID IS NULL
AND T3.PERIOD_START_TIME IS NULL;


 BEGIN

/* OPEN CUR_OSS2 (P_FECHA_DESDE, P_FECHA_HASTA);
  LOOP
    FETCH CUR_OSS2 BULK COLLECT INTO T_ARRAY_COL LIMIT LIMIT_IN;
    BEGIN
      FORALL I IN 1 .. T_ARRAY_COL.COUNT SAVE EXCEPTIONS
        INSERT INTO NOKLTE_PS_LCELLD_MNC1_RAW VALUES T_ARRAY_COL (I);
    END;
    EXIT WHEN CUR_OSS2%NOTFOUND;
  END LOOP;
  COMMIT;
  CLOSE CUR_OSS2;*/

OPEN CUR_OSS3 (P_FECHA_DESDE, P_FECHA_HASTA);
  LOOP
    FETCH CUR_OSS3 BULK COLLECT INTO T_ARRAY_COL LIMIT LIMIT_IN;
    BEGIN
      FORALL I IN 1 .. T_ARRAY_COL.COUNT SAVE EXCEPTIONS
        INSERT INTO NOKLTE_PS_LCELLD_MNC1_RAW VALUES T_ARRAY_COL (I);
    END;
    EXIT WHEN CUR_OSS3%NOTFOUND;
  END LOOP;
  COMMIT;
  CLOSE CUR_OSS3;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

/
