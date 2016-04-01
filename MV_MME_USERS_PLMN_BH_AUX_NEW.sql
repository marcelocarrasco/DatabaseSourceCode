--------------------------------------------------------
--  DDL for Materialized View MV_MME_USERS_PLMN_BH_AUX_NEW
--------------------------------------------------------

  CREATE MATERIALIZED VIEW "HARRIAGUE"."MV_MME_USERS_PLMN_BH_AUX_NEW"
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS NOLOGGING
  STORAGE(INITIAL 262144 NEXT 262144 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
  TABLESPACE "TBS_AUXILIAR" 
  BUILD DEFERRED
  USING INDEX 
  REFRESH COMPLETE ON DEMAND
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  ENABLE QUERY REWRITE
  AS SELECT FECHA,
       PAIS
    FROM(
          SELECT F1.FECHA AS FECHA,
                 'ARGENTINA' AS PAIS,
                 ROW_NUMBER() OVER(PARTITION BY TRUNC (F1.FECHA, 'DD')
                                             ORDER BY F1.SUMUSR DESC
                                             ) AS SEQNUM
          FROM(
                SELECT T1.PERIOD_START_TIME AS FECHA,
                        round(decode(AVG(T1.EPS_ECM_CONN_DENOM),
              0,
              0,
              SUM(T1.EPS_ECM_CONN_SUM)/AVG(T1.EPS_ECM_CONN_DENOM)),
       2) CONN_USR,
                       --SUM(T1.EPS_ECM_CONN_SUM)/AVG(T1.EPS_ECM_CONN_DENOM) AS CONN_USR,
                       round(decode(AVG(T1.EPS_ECM_IDLE_DENOM),
              0,
              0,
              SUM(T1.EPS_ECM_IDLE_SUM)/AVG(T1.EPS_ECM_IDLE_DENOM)),
       2) IDLE_USR,

                       --SUM(T1.EPS_ECM_IDLE_SUM)/AVG(T1.EPS_ECM_IDLE_DENOM) AS IDLE_USR,
               round(decode(AVG(T1.EPS_ECM_CONN_DENOM),
              0,
              0,
              SUM(T1.EPS_ECM_CONN_SUM)/AVG(T1.EPS_ECM_CONN_DENOM)),
       2) +   round(decode(AVG(T1.EPS_ECM_IDLE_DENOM),
              0,
              0,
              SUM(T1.EPS_ECM_IDLE_SUM)/AVG(T1.EPS_ECM_IDLE_DENOM)),
       2)  SUMUSR


                       --SUM(T1.EPS_ECM_CONN_SUM)/AVG(T1.EPS_ECM_CONN_DENOM) + SUM(T1.EPS_ECM_IDLE_SUM)/AVG(T1.EPS_ECM_IDLE_DENOM) AS SUMUSR

                FROM PCOFNS_PS_UMLM_FLEXINS_RAW T1,
                    (SELECT PRM_VALUE AS FECHA_DESDE FROM CALIDAD_PARAMETROS WHERE PRM_ID = 275) T2,
                      (SELECT PRM_VALUE AS FECHA_HASTA FROM CALIDAD_PARAMETROS WHERE PRM_ID = 276) T3
                WHERE T1.PERIOD_START_TIME BETWEEN TO_DATE (T2.FECHA_DESDE,'DD.MM.YYYY')
                                                AND TO_DATE (T3.FECHA_HASTA,'DD.MM.YYYY') + 83999/84000
                                                AND PERIOD_START_TIME NOT IN (TO_DATE('27.10.2015', 'DD.MM.YYYY'))
                GROUP BY T1.PERIOD_START_TIME
            ) F1
    )
    WHERE SEQNUM = 1
;
 

   COMMENT ON MATERIALIZED VIEW "HARRIAGUE"."MV_MME_USERS_PLMN_BH_AUX_NEW"  IS 'snapshot table for snapshot HARRIAGUE.MV_MME_USERS_PLMN_BH_AUX_NEW';
