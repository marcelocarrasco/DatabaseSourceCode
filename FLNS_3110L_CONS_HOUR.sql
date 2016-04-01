--------------------------------------------------------
--  DDL for View FLNS_3110L_CONS_HOUR
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."FLNS_3110L_CONS_HOUR" ("FECHA", "PERIOD_DURATION", "FINS_ID", "MME_NAME", "FLNS_3110L") AS 
  SELECT TRUNC(flns_3100a.FECHA, 'HH24') AS FECHA,
      flns_3100a.PERIOD_DURATION, flns_3100a.FINS_ID, flns_3100a.MME_NAME,
      SUM( flns_3100a.flns_3100a + flns_3101a.flns_3101a + flns_3111a.flns_3111a +
         flns_3112a.flns_3112a + flns_3172a.flns_3172a + flns_3102d.flns_3102d +
         flns_3113a.flns_3113a + flns_3103b.flns_3103b + flns_3104b.flns_3104b +
         flns_3114a.flns_3114a + flns_3105b.flns_3105b + flns_3287a.flns_3287a +
         flns_3106a.flns_3106a + flns_3218a.flns_3218a + flns_3115a.flns_3115a +
         flns_3108b.flns_3108b + flns_3109b.flns_3109b ) AS FLNS_3110L
  FROM flns_3100a_cons_hour flns_3100a
   INNER JOIN flns_3101a_cons_hour flns_3101a
   ON flns_3100a.FINS_ID = flns_3101a.FINS_ID
   AND flns_3100a.FECHA = flns_3101a.FECHA
   INNER JOIN flns_3111a_cons_hour flns_3111a
   ON flns_3101a.FINS_ID = flns_3111a.FINS_ID
   AND flns_3101a.FECHA = flns_3111a.FECHA
   INNER JOIN flns_3112a_cons_hour flns_3112a
   ON flns_3111a.FINS_ID = flns_3112a.FINS_ID
   AND flns_3111a.FECHA = flns_3112a.FECHA
   INNER JOIN flns_3172a_cons_hour flns_3172a
   ON flns_3112a.FINS_ID = flns_3172a.FINS_ID
   AND flns_3112a.FECHA = flns_3172a.FECHA
   INNER JOIN flns_3102d_cons_hour flns_3102d
   ON flns_3172a.FINS_ID = flns_3102d.FINS_ID
   AND flns_3172a.FECHA = flns_3102d.FECHA
   INNER JOIN flns_3113a_cons_hour flns_3113a
   ON flns_3102d.FINS_ID = flns_3113a.FINS_ID
   AND flns_3102d.FECHA = flns_3113a.FECHA
   INNER JOIN flns_3103b_cons_hour flns_3103b
   ON flns_3113a.FINS_ID = flns_3103b.FINS_ID
   AND flns_3113a.FECHA = flns_3103b.FECHA
   INNER JOIN flns_3104b_cons_hour flns_3104b
   ON flns_3103b.FINS_ID = flns_3104b.FINS_ID
   AND flns_3103b.FECHA = flns_3104b.FECHA
   INNER JOIN flns_3114a_cons_hour flns_3114a
   ON flns_3104b.FINS_ID = flns_3114a.FINS_ID
   AND flns_3104b.FECHA = flns_3114a.FECHA
   INNER JOIN flns_3105b_cons_hour flns_3105b
   ON flns_3114a.FINS_ID = flns_3105b.FINS_ID
   AND flns_3114a.FECHA = flns_3105b.FECHA
   INNER JOIN flns_3287a_cons_hour flns_3287a
   ON flns_3105b.FINS_ID = flns_3287a.FINS_ID
   AND flns_3105b.FECHA = flns_3287a.FECHA
   INNER JOIN flns_3106a_cons_hour flns_3106a
   ON flns_3287a.FINS_ID = flns_3106a.FINS_ID
   AND flns_3287a.FECHA = flns_3106a.FECHA
   INNER JOIN flns_3218a_cons_hour flns_3218a
   ON flns_3106a.FINS_ID = flns_3218a.FINS_ID
   AND flns_3106a.FECHA = flns_3218a.FECHA
   INNER JOIN flns_3115a_cons_hour flns_3115a
   ON flns_3218a.FINS_ID = flns_3115a.FINS_ID
   AND flns_3218a.FECHA = flns_3115a.FECHA
   INNER JOIN flns_3108b_cons_hour flns_3108b
   ON flns_3115a.FINS_ID = flns_3108b.FINS_ID
   AND flns_3115a.FECHA = flns_3108b.FECHA
   INNER JOIN flns_3109b_cons_hour flns_3109b
   ON flns_3108b.FINS_ID = flns_3109b.FINS_ID
   AND flns_3108b.FECHA = flns_3109b.FECHA
GROUP BY TRUNC(flns_3100a.FECHA, 'HH24') , flns_3100a.PERIOD_DURATION, flns_3100a.FINS_ID, flns_3100a.MME_NAME
;
