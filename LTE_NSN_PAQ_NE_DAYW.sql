--------------------------------------------------------
--  DDL for Table LTE_NSN_PAQ_NE_DAYW
--------------------------------------------------------

  CREATE TABLE "HARRIAGUE"."LTE_NSN_PAQ_NE_DAYW" 
   (	"FECHA" DATE, 
	"ELEMENT_CLASS" VARCHAR2(20 BYTE), 
	"ELEMENT_ID" VARCHAR2(100 BYTE), 
	"RSSI_PUSCH_UL_NUM" NUMBER, 
	"RSSI_PUSCH_UL_DEN" NUMBER, 
	"RSSI_PUCCH_UL_NUM" NUMBER, 
	"RSSI_PUCCH_UL_DEN" NUMBER, 
	"SINR_PUSCH_UL_NUM" NUMBER, 
	"SINR_PUSCH_UL_DEN" NUMBER, 
	"SINR_PUCCH_UL_NUM" NUMBER, 
	"SINR_PUCCH_UL_DEN" NUMBER, 
	"CQI_NUM" NUMBER, 
	"CQI_DEN" NUMBER
   ) 
  PARTITION BY RANGE ("FECHA") 
  SUBPARTITION BY LIST ("ELEMENT_CLASS") 
  SUBPARTITION TEMPLATE ( 
    SUBPARTITION "LBS" values ( 'LNBTS' ), 
    SUBPARTITION "ALM" values ( 'ALM' ), 
    SUBPARTITION "MKT" values ( 'MERCADO' ), 
    SUBPARTITION "CDD" values ( 'CIUDAD' ), 
    SUBPARTITION "CTY" values ( 'PAIS' ), 
    SUBPARTITION "OTH" values ( DEFAULT ) ) 
 (PARTITION "LTE_NSN_20150626"  VALUES LESS THAN (TO_DATE(' 2015-07-03 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) 
 ( SUBPARTITION "LTE_NSN_PAQ_NE_20150626_WBS"  VALUES ('WBTS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150626_RNC"  VALUES ('RNC') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150626_ALM"  VALUES ('ALM') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150626_MKT"  VALUES ('MERCADO') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150626_CDD"  VALUES ('CIUDAD') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150626_CTY"  VALUES ('PAIS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150626_OTH"  VALUES (DEFAULT) ) , 
 PARTITION "LTE_NSN_20150703"  VALUES LESS THAN (TO_DATE(' 2015-07-10 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) 
 ( SUBPARTITION "LTE_NSN_PAQ_NE_20150703_WBS"  VALUES ('WBTS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150703_RNC"  VALUES ('RNC') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150703_ALM"  VALUES ('ALM') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150703_MKT"  VALUES ('MERCADO') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150703_CDD"  VALUES ('CIUDAD') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150703_CTY"  VALUES ('PAIS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150703_OTH"  VALUES (DEFAULT) ) , 
 PARTITION "LTE_NSN_20150710"  VALUES LESS THAN (TO_DATE(' 2015-07-17 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) 
 ( SUBPARTITION "LTE_NSN_PAQ_NE_20150710_WBS"  VALUES ('WBTS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150710_RNC"  VALUES ('RNC') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150710_ALM"  VALUES ('ALM') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150710_MKT"  VALUES ('MERCADO') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150710_CDD"  VALUES ('CIUDAD') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150710_CTY"  VALUES ('PAIS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150710_OTH"  VALUES (DEFAULT) ) , 
 PARTITION "LTE_NSN_20150717"  VALUES LESS THAN (TO_DATE(' 2015-07-24 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) 
 ( SUBPARTITION "LTE_NSN_PAQ_NE_20150717_WBS"  VALUES ('WBTS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150717_RNC"  VALUES ('RNC') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150717_ALM"  VALUES ('ALM') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150717_MKT"  VALUES ('MERCADO') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150717_CDD"  VALUES ('CIUDAD') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150717_CTY"  VALUES ('PAIS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150717_OTH"  VALUES (DEFAULT) ) , 
 PARTITION "LTE_NSN_20150724"  VALUES LESS THAN (TO_DATE(' 2015-07-31 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) 
 ( SUBPARTITION "LTE_NSN_PAQ_NE_20150724_WBS"  VALUES ('WBTS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150724_RNC"  VALUES ('RNC') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150724_ALM"  VALUES ('ALM') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150724_MKT"  VALUES ('MERCADO') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150724_CDD"  VALUES ('CIUDAD') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150724_CTY"  VALUES ('PAIS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150724_OTH"  VALUES (DEFAULT) ) , 
 PARTITION "LTE_NSN_20150731"  VALUES LESS THAN (TO_DATE(' 2015-08-07 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) 
 ( SUBPARTITION "LTE_NSN_PAQ_NE_20150731_WBS"  VALUES ('WBTS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150731_RNC"  VALUES ('RNC') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150731_ALM"  VALUES ('ALM') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150731_MKT"  VALUES ('MERCADO') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150731_CDD"  VALUES ('CIUDAD') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150731_CTY"  VALUES ('PAIS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150731_OTH"  VALUES (DEFAULT) ) , 
 PARTITION "LTE_NSN_20150807"  VALUES LESS THAN (TO_DATE(' 2015-08-14 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) 
 ( SUBPARTITION "LTE_NSN_PAQ_NE_20150807_WBS"  VALUES ('WBTS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150807_RNC"  VALUES ('RNC') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150807_ALM"  VALUES ('ALM') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150807_MKT"  VALUES ('MERCADO') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150807_CDD"  VALUES ('CIUDAD') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150807_CTY"  VALUES ('PAIS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150807_OTH"  VALUES (DEFAULT) ) , 
 PARTITION "LTE_NSN_20150814"  VALUES LESS THAN (TO_DATE(' 2015-08-21 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) 
 ( SUBPARTITION "LTE_NSN_PAQ_NE_20150814_WBS"  VALUES ('WBTS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150814_RNC"  VALUES ('RNC') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150814_ALM"  VALUES ('ALM') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150814_MKT"  VALUES ('MERCADO') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150814_CDD"  VALUES ('CIUDAD') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150814_CTY"  VALUES ('PAIS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150814_OTH"  VALUES (DEFAULT) ) , 
 PARTITION "LTE_NSN_20150821"  VALUES LESS THAN (TO_DATE(' 2015-08-28 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) 
 ( SUBPARTITION "LTE_NSN_PAQ_NE_20150821_WBS"  VALUES ('WBTS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150821_RNC"  VALUES ('RNC') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150821_ALM"  VALUES ('ALM') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150821_MKT"  VALUES ('MERCADO') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150821_CDD"  VALUES ('CIUDAD') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150821_CTY"  VALUES ('PAIS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150821_OTH"  VALUES (DEFAULT) ) , 
 PARTITION "LTE_NSN_20150828"  VALUES LESS THAN (TO_DATE(' 2015-09-04 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) 
 ( SUBPARTITION "LTE_NSN_PAQ_NE_20150828_WBS"  VALUES ('WBTS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150828_RNC"  VALUES ('RNC') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150828_ALM"  VALUES ('ALM') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150828_MKT"  VALUES ('MERCADO') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150828_CDD"  VALUES ('CIUDAD') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150828_CTY"  VALUES ('PAIS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150828_OTH"  VALUES (DEFAULT) ) , 
 PARTITION "LTE_NSN_20150904"  VALUES LESS THAN (TO_DATE(' 2015-09-11 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) 
 ( SUBPARTITION "LTE_NSN_PAQ_NE_20150904_WBS"  VALUES ('WBTS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150904_RNC"  VALUES ('RNC') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150904_ALM"  VALUES ('ALM') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150904_MKT"  VALUES ('MERCADO') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150904_CDD"  VALUES ('CIUDAD') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150904_CTY"  VALUES ('PAIS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150904_OTH"  VALUES (DEFAULT) ) , 
 PARTITION "LTE_NSN_20150911"  VALUES LESS THAN (TO_DATE(' 2015-09-18 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) 
 ( SUBPARTITION "LTE_NSN_PAQ_NE_20150911_WBS"  VALUES ('WBTS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150911_RNC"  VALUES ('RNC') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150911_ALM"  VALUES ('ALM') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150911_MKT"  VALUES ('MERCADO') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150911_CDD"  VALUES ('CIUDAD') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150911_CTY"  VALUES ('PAIS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150911_OTH"  VALUES (DEFAULT) ) , 
 PARTITION "LTE_NSN_20150920"  VALUES LESS THAN (TO_DATE(' 2015-09-27 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) 
 ( SUBPARTITION "LTE_NSN_PAQ_NE_20150920_LBS"  VALUES ('LNBTS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150920_ALM"  VALUES ('ALM') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150920_MKT"  VALUES ('MERCADO') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150920_CDD"  VALUES ('CIUDAD') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150920_CTY"  VALUES ('PAIS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150920_OTH"  VALUES (DEFAULT) ) , 
 PARTITION "LTE_NSN_20150927"  VALUES LESS THAN (TO_DATE(' 2015-10-04 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) 
 ( SUBPARTITION "LTE_NSN_PAQ_NE_20150927_LBS"  VALUES ('LNBTS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150927_ALM"  VALUES ('ALM') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150927_MKT"  VALUES ('MERCADO') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150927_CDD"  VALUES ('CIUDAD') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150927_CTY"  VALUES ('PAIS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20150927_OTH"  VALUES (DEFAULT) ) , 
 PARTITION "LTE_NSN_20151004"  VALUES LESS THAN (TO_DATE(' 2015-10-11 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) 
 ( SUBPARTITION "LTE_NSN_PAQ_NE_20151004_LBS"  VALUES ('LNBTS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151004_ALM"  VALUES ('ALM') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151004_MKT"  VALUES ('MERCADO') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151004_CDD"  VALUES ('CIUDAD') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151004_CTY"  VALUES ('PAIS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151004_OTH"  VALUES (DEFAULT) ) , 
 PARTITION "LTE_NSN_20151011"  VALUES LESS THAN (TO_DATE(' 2015-10-18 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) 
 ( SUBPARTITION "LTE_NSN_PAQ_NE_20151011_LBS"  VALUES ('LNBTS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151011_ALM"  VALUES ('ALM') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151011_MKT"  VALUES ('MERCADO') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151011_CDD"  VALUES ('CIUDAD') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151011_CTY"  VALUES ('PAIS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151011_OTH"  VALUES (DEFAULT) ) , 
 PARTITION "LTE_NSN_20151018"  VALUES LESS THAN (TO_DATE(' 2015-10-25 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) 
 ( SUBPARTITION "LTE_NSN_PAQ_NE_20151018_LBS"  VALUES ('LNBTS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151018_ALM"  VALUES ('ALM') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151018_MKT"  VALUES ('MERCADO') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151018_CDD"  VALUES ('CIUDAD') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151018_CTY"  VALUES ('PAIS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151018_OTH"  VALUES (DEFAULT) ) , 
 PARTITION "LTE_NSN_20151025"  VALUES LESS THAN (TO_DATE(' 2015-11-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) 
 ( SUBPARTITION "LTE_NSN_PAQ_NE_20151025_LBS"  VALUES ('LNBTS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151025_ALM"  VALUES ('ALM') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151025_MKT"  VALUES ('MERCADO') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151025_CDD"  VALUES ('CIUDAD') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151025_CTY"  VALUES ('PAIS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151025_OTH"  VALUES (DEFAULT) ) , 
 PARTITION "LTE_NSN_20151101"  VALUES LESS THAN (TO_DATE(' 2015-11-08 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) 
 ( SUBPARTITION "LTE_NSN_PAQ_NE_20151101_LBS"  VALUES ('LNBTS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151101_ALM"  VALUES ('ALM') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151101_MKT"  VALUES ('MERCADO') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151101_CDD"  VALUES ('CIUDAD') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151101_CTY"  VALUES ('PAIS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151101_OTH"  VALUES (DEFAULT) ) , 
 PARTITION "LTE_NSN_20151108"  VALUES LESS THAN (TO_DATE(' 2015-11-15 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) 
 ( SUBPARTITION "LTE_NSN_PAQ_NE_20151108_LBS"  VALUES ('LNBTS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151108_ALM"  VALUES ('ALM') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151108_MKT"  VALUES ('MERCADO') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151108_CDD"  VALUES ('CIUDAD') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151108_CTY"  VALUES ('PAIS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151108_OTH"  VALUES (DEFAULT) ) , 
 PARTITION "LTE_NSN_20151115"  VALUES LESS THAN (TO_DATE(' 2015-11-22 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) 
 ( SUBPARTITION "LTE_NSN_PAQ_NE_20151115_LBS"  VALUES ('LNBTS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151115_ALM"  VALUES ('ALM') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151115_MKT"  VALUES ('MERCADO') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151115_CDD"  VALUES ('CIUDAD') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151115_CTY"  VALUES ('PAIS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151115_OTH"  VALUES (DEFAULT) ) , 
 PARTITION "LTE_NSN_20151122"  VALUES LESS THAN (TO_DATE(' 2015-11-29 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) 
 ( SUBPARTITION "LTE_NSN_PAQ_NE_20151122_LBS"  VALUES ('LNBTS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151122_ALM"  VALUES ('ALM') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151122_MKT"  VALUES ('MERCADO') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151122_CDD"  VALUES ('CIUDAD') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151122_CTY"  VALUES ('PAIS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151122_OTH"  VALUES (DEFAULT) ) , 
 PARTITION "LTE_NSN_20151129"  VALUES LESS THAN (TO_DATE(' 2015-12-06 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) 
 ( SUBPARTITION "LTE_NSN_PAQ_NE_20151129_LBS"  VALUES ('LNBTS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151129_ALM"  VALUES ('ALM') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151129_MKT"  VALUES ('MERCADO') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151129_CDD"  VALUES ('CIUDAD') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151129_CTY"  VALUES ('PAIS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151129_OTH"  VALUES (DEFAULT) ) , 
 PARTITION "LTE_NSN_20151206"  VALUES LESS THAN (TO_DATE(' 2015-12-13 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) 
 ( SUBPARTITION "LTE_NSN_PAQ_NE_20151206_LBS"  VALUES ('LNBTS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151206_ALM"  VALUES ('ALM') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151206_MKT"  VALUES ('MERCADO') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151206_CDD"  VALUES ('CIUDAD') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151206_CTY"  VALUES ('PAIS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151206_OTH"  VALUES (DEFAULT) ) , 
 PARTITION "LTE_NSN_20151213"  VALUES LESS THAN (TO_DATE(' 2015-12-20 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) 
 ( SUBPARTITION "LTE_NSN_PAQ_NE_20151213_LBS"  VALUES ('LNBTS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151213_ALM"  VALUES ('ALM') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151213_MKT"  VALUES ('MERCADO') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151213_CDD"  VALUES ('CIUDAD') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151213_CTY"  VALUES ('PAIS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151213_OTH"  VALUES (DEFAULT) ) , 
 PARTITION "LTE_NSN_20151220"  VALUES LESS THAN (TO_DATE(' 2015-12-27 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) 
 ( SUBPARTITION "LTE_NSN_PAQ_NE_20151220_LBS"  VALUES ('LNBTS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151220_ALM"  VALUES ('ALM') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151220_MKT"  VALUES ('MERCADO') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151220_CDD"  VALUES ('CIUDAD') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151220_CTY"  VALUES ('PAIS') , 
  SUBPARTITION "LTE_NSN_PAQ_NE_20151220_OTH"  VALUES (DEFAULT) ) , 
 PARTITION "LTE_NSN_20151227"  VALUES LESS THAN (TO_DATE(' 2016-01-03 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20160103"  VALUES LESS THAN (TO_DATE(' 2016-01-10 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20160110"  VALUES LESS THAN (TO_DATE(' 2016-01-17 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20160117"  VALUES LESS THAN (TO_DATE(' 2016-01-24 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20160124"  VALUES LESS THAN (TO_DATE(' 2016-01-31 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20160131"  VALUES LESS THAN (TO_DATE(' 2016-02-07 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20160207"  VALUES LESS THAN (TO_DATE(' 2016-02-14 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20160214"  VALUES LESS THAN (TO_DATE(' 2016-02-21 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20160221"  VALUES LESS THAN (TO_DATE(' 2016-02-28 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20160228"  VALUES LESS THAN (TO_DATE(' 2016-03-06 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20160306"  VALUES LESS THAN (TO_DATE(' 2016-03-13 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20160313"  VALUES LESS THAN (TO_DATE(' 2016-03-20 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20160320"  VALUES LESS THAN (TO_DATE(' 2016-03-27 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20160327"  VALUES LESS THAN (TO_DATE(' 2016-04-03 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20160403"  VALUES LESS THAN (TO_DATE(' 2016-04-10 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20160410"  VALUES LESS THAN (TO_DATE(' 2016-04-17 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20160417"  VALUES LESS THAN (TO_DATE(' 2016-04-24 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20160424"  VALUES LESS THAN (TO_DATE(' 2016-05-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20160501"  VALUES LESS THAN (TO_DATE(' 2016-05-08 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20160508"  VALUES LESS THAN (TO_DATE(' 2016-05-15 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20160515"  VALUES LESS THAN (TO_DATE(' 2016-05-22 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20160522"  VALUES LESS THAN (TO_DATE(' 2016-05-29 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20160529"  VALUES LESS THAN (TO_DATE(' 2016-06-05 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20160605"  VALUES LESS THAN (TO_DATE(' 2016-06-12 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20160612"  VALUES LESS THAN (TO_DATE(' 2016-06-19 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20160619"  VALUES LESS THAN (TO_DATE(' 2016-06-26 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20160626"  VALUES LESS THAN (TO_DATE(' 2016-07-03 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) ) ;
