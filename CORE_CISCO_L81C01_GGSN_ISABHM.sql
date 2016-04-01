--------------------------------------------------------
--  DDL for View CORE_CISCO_L81C01_GGSN_ISABHM
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."CORE_CISCO_L81C01_GGSN_ISABHM" ("FECHA", "GWNAME", "PGW_LICENSING") AS 
  SELECT TRUNC(hist.FECHA , 'MONTH') AS FECHA, hist.GWNAME, ROUND(AVG(hist.PGW_LICENSING),2 ) AS PGW_LICENSING
FROM(
      SELECT TRUNC(FECHA, 'HH24') AS FECHA, GWNAME, SUM(PGWACTIVEDATA) AS PGW_LICENSING
      FROM CORE_CISCO_L81C01_GGSN_HIST
      GROUP BY TRUNC(FECHA, 'HH24'), GWNAME
    ) hist
INNER JOIN (
           SELECT FECHA, GWNAME, SERVID, SERVNAME, SEQNUM
            FROM (
                  SELECT FECHA , GWNAME, SERVID, SERVNAME, ROW_NUMBER()
                        OVER (
                          PARTITION BY TRUNC(FECHA , 'MONTH'), GWNAME, SERVID, SERVNAME
                          ORDER BY VALOR DESC) SEQNUM
                  FROM L81505_L81513_BH_AUX2
                  )
            WHERE SEQNUM < 4
        ) bh
ON bh.FECHA = hist.FECHA
AND bh.GWNAME = hist.GWNAME
GROUP BY TRUNC(hist.FECHA , 'MONTH'), hist.GWNAME
;
