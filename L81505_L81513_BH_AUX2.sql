--------------------------------------------------------
--  DDL for View L81505_L81513_BH_AUX2
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HARRIAGUE"."L81505_L81513_BH_AUX2" ("FECHA", "GWNAME", "SERVID", "SERVNAME", "VALOR") AS 
  SELECT FECHA,
           GWNAME,
           SERVID,
           SERVNAME,
           VALOR
      FROM (
    SELECT STUB.FECHA,
           SDB.GWNAME,
           SDB.SERVID,
           SDB.SERVNAME,
           (STUB.UPLINK_THP_MBPS + SDB.DOWNLINK_THP_MBPS_GBR) VALOR,
           ROW_NUMBER() OVER (PARTITION BY TRUNC(SDB.FECHA),
                                           SDB.GWNAME,
                                           SDB.SERVID,
                                           SDB.SERVNAME
                                  ORDER BY (STUB.UPLINK_THP_MBPS + SDB.DOWNLINK_THP_MBPS_GBR) DESC,
                                           SDB.FECHA DESC) SEQNUM
      FROM (
    SELECT TRUNC(FECHA, 'HH24') FECHA, GWNAME, SERVID, SERVNAME, SUM(UPLINK_THP_MBPS) AS UPLINK_THP_MBPS
      FROM CORE_CISCO_L81505_GGSN_HIST
     GROUP BY TRUNC(FECHA, 'HH24'), SERVID, GWNAME, SERVNAME
           ) STUB
INNER JOIN (
    SELECT TRUNC(FECHA, 'HH24') FECHA, GWNAME, SERVID, SERVNAME, SUM(DOWNLINK_THP_MBPS_GBR) AS DOWNLINK_THP_MBPS_GBR
      FROM CORE_CISCO_L81513_GGSN_HIST
     GROUP BY TRUNC(FECHA, 'HH24'), SERVID, GWNAME, SERVNAME
           ) SDB
        ON STUB.FECHA = SDB.FECHA
       AND STUB.SERVID = SDB.SERVID
       AND STUB.GWNAME = SDB.GWNAME
       AND STUB.SERVNAME = SDB.SERVNAME
           )
    WHERE SEQNUM = 1
   ORDER BY SERVNAME, GWNAME, FECHA
;
