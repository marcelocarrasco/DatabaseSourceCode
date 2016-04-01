--------------------------------------------------------
--  DDL for View FLNS_3110L_CONS_HOUR_TEST
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."FLNS_3110L_CONS_HOUR_TEST" ("FECHA", "PERIOD_DURATION", "FINS_ID", "MME_NAME", "FLNS_3110L") AS 
  SELECT TRUNC(flns_3100a.FECHA, 'HH24') AS FECHA,  
      FLNS_3100A.PERIOD_DURATION, FLNS_3100A.FINS_ID, FLNS_3100A.MME_NAME,
      SUM( flns_3100a.flns_3100a + flns_3101a.flns_3100a /*+ flns_3111a.flns_3111a +
         flns_3112a.flns_3112a + flns_3172a.flns_3172a + flns_3102d.flns_3102d +
         flns_3113a.flns_3113a + flns_3103b.flns_3103b + flns_3104b.flns_3104b +
         flns_3114a.flns_3114a + flns_3105b.flns_3105b + flns_3287a.flns_3287a +
         flns_3106a.flns_3106a + flns_3218a.flns_3218a + flns_3115a.flns_3115a +
         flns_3108b.flns_3108b + flns_3109b.flns_3109b*/ ) AS FLNS_3110L
  FROM
      (
      select FECHA, PERIOD_DURATION, FINS_ID, MME_NAME, TA_ID, FLNS_3100A
      from table(F_FLNS_3100A('01.03.2016'))) FLNS_3100A JOIN
      (select FECHA, PERIOD_DURATION, FINS_ID, MME_NAME, TA_ID, FLNS_3100A
      from table(F_FLNS_3101A('01.03.2016'))) FLNS_3101A
      ON (FLNS_3100A.FINS_ID = FLNS_3101A.FINS_ID and FLNS_3100A.fecha = FLNS_3101A.fecha)
  GROUP BY TRUNC(flns_3100a.FECHA, 'HH24') , flns_3100a.PERIOD_DURATION, flns_3100a.FINS_ID, flns_3100a.MME_NAME;
