--------------------------------------------------------
--  DDL for Procedure P_LTE_TRUNCATE_SPART_WEEKLY
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HARRIAGUE"."P_LTE_TRUNCATE_SPART_WEEKLY" (P_FECHA_DESDE    IN CHAR,
                                                                    P_FECHA_HASTA    IN CHAR,
                                                                    P_CLASS_TABLE    IN CHAR,
                                                                    P_SUBCLASS_TABLE IN CHAR) IS

-- Autor: Mariano Morón. Fecha: 09.09.2015.
-- Actualizacion: Mariano Moron. Fecha 14.09.2015. Motivo: Fix del P_SUBCLASS_TABLE
-- Actualizacion: Mariano Moron. Fecha 14.09.2015. Motivo: Se agregan clases de NE.
-- Actualizacion: Mariano Moron. Fecha 14.09.2015. Motivo: Se agregan clases de IBHW.

CURSOR C_VENTANA (P_PARTICION_ESQUEMA_MSC_FECHA IN CHAR,
                  FECHA_DESDE                   IN CHAR,
                  FECHA_HASTA                   IN CHAR,
                  P_SEMANAS                     IN NUMBER) IS
SELECT TO_CHAR(DIA, P_PARTICION_ESQUEMA_MSC_FECHA) FECHA
  FROM CALIDAD_STATUS_REFERENCES
 WHERE FECHA BETWEEN TO_DATE(FECHA_DESDE, 'DD.MM.YYYY')
                 AND TO_DATE(FECHA_HASTA, 'DD.MM.YYYY') + 86399/86400
   AND HORA = '00'
   AND DIA_DESC = 'DOMINGO'
   --AND DIA >= TRUNC(SYSDATE, 'DAY') - (7 * P_SEMANAS)
 ORDER BY DIA DESC;

V_NOMBRE_TABLA                 VARCHAR2(30);
V_PARTICION_ESQUEMA            VARCHAR2(30);
V_PARTICION_ESQUEMA_MSC_FECHA  VARCHAR2(30);
V_PARTICION_FORMATO_MSC_FECHA  VARCHAR2(30);
V_SUBPARTICION_NAME            VARCHAR2(10);
V_PARTITION_CLASS              VARCHAR2(20);

V_LINEA                        VARCHAR2(200);
V_CANTIDAD_SEMANAS             NUMBER;

BEGIN

SELECT PRM_VALUE CANTIDAD_SEMANAS
  INTO V_CANTIDAD_SEMANAS
  FROM CALIDAD_PARAMETROS
 WHERE PRM_ID = 266;

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
SELECT CASE WHEN P_CLASS_TABLE = 'ServiceWcellDayW'                 THEN 'LTE_NSN_SERVICE_LCEL_DAYW'
            WHEN P_CLASS_TABLE = 'ServiceWcellIBHW'                 THEN 'LTE_NSN_SERVICE_LCEL_IBHW'
            WHEN P_CLASS_TABLE = 'ServiceNeDayW'                    THEN 'LTE_NSN_SERVICE_NE_DAYW'
            WHEN P_CLASS_TABLE = 'ServiceNeIBHW'                    THEN 'LTE_NSN_SERVICE_NE_IBHW'

            WHEN P_CLASS_TABLE = 'AvailabilityWcellDayW'            THEN 'LTE_NSN_AVAIL_LCEL_DAYW'
            WHEN P_CLASS_TABLE = 'AvailabilityWcellIBHW'            THEN 'LTE_NSN_AVAIL_LCEL_IBHW'
            WHEN P_CLASS_TABLE = 'AvailabilityNeDayW'               THEN 'LTE_NSN_AVAIL_NE_DAYW'
            WHEN P_CLASS_TABLE = 'AvailabilityNeIBHW'               THEN 'LTE_NSN_AVAIL_NE_IBHW'

            WHEN P_CLASS_TABLE = 'PaQWcellDayW'                     THEN 'LTE_NSN_PAQ_LCEL_DAYW'
            WHEN P_CLASS_TABLE = 'PaQWcellIBHW'                     THEN 'LTE_NSN_PAQ_LCEL_IBHW'
            WHEN P_CLASS_TABLE = 'PaQNeDayW'                        THEN 'LTE_NSN_PAQ_NE_DAYW'
            WHEN P_CLASS_TABLE = 'PaQNeIBHW'                        THEN 'LTE_NSN_PAQ_NE_IBHW'

            ELSE NULL END NOMBRE_TABLA
  FROM DUAL
       ) B
 WHERE A.NOMBRE_TABLA = B.NOMBRE_TABLA;

FOR SYN IN C_VENTANA (V_PARTICION_ESQUEMA_MSC_FECHA,
                      P_FECHA_DESDE,
                      P_FECHA_HASTA,
                      V_CANTIDAD_SEMANAS
                     ) LOOP

SELECT 'ALTER TABLE '||V_NOMBRE_TABLA||' TRUNCATE '||V_PARTITION_CLASS||' '||
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
