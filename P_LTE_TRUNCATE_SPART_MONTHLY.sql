--------------------------------------------------------
--  DDL for Procedure P_LTE_TRUNCATE_SPART_MONTHLY
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HARRIAGUE"."P_LTE_TRUNCATE_SPART_MONTHLY" (P_FECHA_DESDE    IN CHAR,
                                                                 P_FECHA_HASTA    IN CHAR,
                                                                 P_CLASS_TABLE    IN CHAR,
                                                                 P_SUBCLASS_TABLE IN CHAR) IS

-- Autor: Mariano Morón. Fecha: 10.09.2015.
-- Actualizacion: Mariano Moron. Fecha 14.09.2015. Motivo: Fix del P_SUBCLASS_TABLE.
-- Actualizacion: Mariano Moron. Fecha 14.09.2015. Motivo: Se agregan clases de NE.
-- Actualizacion: Mariano Moron. Fecha 22.09.2015. Motivo: Se agregan clases de IBHM.

CURSOR C_VENTANA (P_PARTICION_ESQUEMA_MSC_FECHA IN CHAR,
                  FECHA_DESDE                   IN CHAR,
                  FECHA_HASTA                   IN CHAR,
                  P_MESES                       IN NUMBER) IS
SELECT DISTINCT MES, TO_CHAR(MES, P_PARTICION_ESQUEMA_MSC_FECHA) FECHA
  FROM CALIDAD_STATUS_REFERENCES
 WHERE FECHA BETWEEN TO_DATE(FECHA_DESDE, 'DD.MM.YYYY')
                 AND TO_DATE(FECHA_HASTA, 'DD.MM.YYYY') + 86399/86400
   AND HORA = '00'
   --AND DIA >= ADD_MONTHS(TRUNC(SYSDATE, 'MONTH'), - P_MESES)
 ORDER BY MES DESC;

V_NOMBRE_TABLA                 VARCHAR2(30);
V_PARTICION_ESQUEMA            VARCHAR2(30);
V_PARTICION_ESQUEMA_MSC_FECHA  VARCHAR2(30);
V_PARTICION_FORMATO_MSC_FECHA  VARCHAR2(30);
V_SUBPARTICION_NAME            VARCHAR2(10);
V_PARTITION_CLASS              VARCHAR2(20);

V_LINEA                        VARCHAR2(200);
V_CANTIDAD_MESES               NUMBER;

BEGIN

SELECT PRM_VALUE CANTIDAD_MESES
  INTO V_CANTIDAD_MESES
  FROM CALIDAD_PARAMETROS
 WHERE PRM_ID = 267;

SELECT A.NOMBRE_TABLA,
       A.PARTICION_ESQUEMA,
       A.PARTICION_ESQUEMA_MSC_FECHA,
       A.PARTICION_FORMATO_MSC_FECHA,
       CASE WHEN P_SUBCLASS_TABLE != 'LCE' THEN '_' ELSE NULL END ||
       CASE
            WHEN P_SUBCLASS_TABLE = 'LNBTS'    THEN 'LBS'
            WHEN P_SUBCLASS_TABLE = 'ALM'     THEN 'ALM'
            WHEN P_SUBCLASS_TABLE = 'MERCADO' THEN 'MKT'
            WHEN P_SUBCLASS_TABLE = 'PAIS'    THEN 'CTY'
            WHEN P_SUBCLASS_TABLE = 'CIUDAD'  THEN 'CDD'
            ELSE NULL END SUBPARTICION_NAME,
            CASE WHEN P_SUBCLASS_TABLE = 'LCE' THEN 'PARTITION'
                                          ELSE 'SUBPARTITION' END PARTITION_CLASS
  INTO V_NOMBRE_TABLA,
       V_PARTICION_ESQUEMA,
       V_PARTICION_ESQUEMA_MSC_FECHA,
       V_PARTICION_FORMATO_MSC_FECHA,
       V_SUBPARTICION_NAME,
       V_PARTITION_CLASS
  FROM CALIDAD_PARAMETROS_TABLAS A,
       (
SELECT CASE
            WHEN P_CLASS_TABLE = 'ServiceWcellDayM'                 THEN 'LTE_NSN_SERVICE_LCEL_DAYM'
            WHEN P_CLASS_TABLE = 'ServiceWcellIBHM'                 THEN 'LTE_NSN_SERVICE_LCEL_IBHM'
            WHEN P_CLASS_TABLE = 'ServiceNeDayM'                    THEN 'LTE_NSN_SERVICE_NE_DAYM'
            WHEN P_CLASS_TABLE = 'ServiceNeIBHM'                    THEN 'LTE_NSN_SERVICE_NE_IBHM'

            WHEN P_CLASS_TABLE = 'AvailabilityWcellDayM'            THEN 'LTE_NSN_AVAIL_LCEL_DAYM'
            WHEN P_CLASS_TABLE = 'AvailabilityWcellIBHM'            THEN 'LTE_NSN_AVAIL_LCEL_IBHM'
            WHEN P_CLASS_TABLE = 'AvailabilityNeDayM'               THEN 'LTE_NSN_AVAIL_NE_DAYM'
            WHEN P_CLASS_TABLE = 'AvailabilityNeIBHM'               THEN 'LTE_NSN_AVAIL_NE_IBHM'

            WHEN P_CLASS_TABLE = 'PaQWcellDayM'                     THEN 'LTE_NSN_PAQ_LCEL_DAYM'
            WHEN P_CLASS_TABLE = 'PaQWcellIBHM'                     THEN 'LTE_NSN_PAQ_LCEL_IBHM'
            WHEN P_CLASS_TABLE = 'PaQNeDayM'                        THEN 'LTE_NSN_PAQ_NE_DAYM'
            WHEN P_CLASS_TABLE = 'PaQNeIBHM'                        THEN 'LTE_NSN_PAQ_NE_IBHM'
            ELSE NULL END NOMBRE_TABLA
  FROM DUAL
       ) B
 WHERE A.NOMBRE_TABLA = B.NOMBRE_TABLA;

FOR SYN IN C_VENTANA (V_PARTICION_ESQUEMA_MSC_FECHA,
                      P_FECHA_DESDE,
                      P_FECHA_HASTA,
                      V_CANTIDAD_MESES
                     ) LOOP

SELECT 'ALTER TABLE HARRIAGUE.'||V_NOMBRE_TABLA||' TRUNCATE '||V_PARTITION_CLASS||' '||
       V_PARTICION_ESQUEMA||SYN.FECHA||V_SUBPARTICION_NAME LINEA
  INTO V_LINEA
  FROM DUAL;

BEGIN

EXECUTE IMMEDIATE V_LINEA;
-- DBMS_OUTPUT.PUT_LINE(V_LINEA);

EXCEPTION

WHEN OTHERS THEN
NULL;

END;

END LOOP;

END;

/
