--------------------------------------------------------
--  DDL for Table LTE_NSN_SERVICE_NE_DAYW
--------------------------------------------------------

  CREATE TABLE "HARRIAGUE"."LTE_NSN_SERVICE_NE_DAYW" 
   (	"FECHA" DATE, 
	"ELEMENT_CLASS" VARCHAR2(20 BYTE), 
	"ELEMENT_ID" VARCHAR2(100 BYTE), 
	"AVG_PDCP_CELL_THP_DL_NUM" NUMBER, 
	"AVG_PDCP_CELL_THP_DL_DEN" NUMBER, 
	"SIGN_EST_F_RRCCOMPL_MISSING" NUMBER, 
	"SIGN_EST_F_RRCCOMPL_ERROR" NUMBER, 
	"SIGN_CONN_ESTAB_FAIL_RRMRAC" NUMBER, 
	"SIGN_CONN_ESTAB_FAIL_RB_EMG" NUMBER, 
	"EPS_BEARER_SETUP_FAIL_RNL" NUMBER, 
	"EPS_BEARER_SETUP_FAIL_RESOUR" NUMBER, 
	"EPS_BEARER_SETUP_FAIL_TRPORT" NUMBER, 
	"EPS_BEARER_SETUP_FAIL_OTH" NUMBER, 
	"ENB_EPS_BEARER_REL_REQ_RNL" NUMBER, 
	"ENB_EPS_BEARER_REL_REQ_TNL" NUMBER, 
	"ENB_EPS_BEARER_REL_REQ_OTH" NUMBER, 
	"AVG_PDCP_CELL_THP_UL_NUM" NUMBER, 
	"AVG_PDCP_CELL_THP_UL_DEN" NUMBER, 
	"TRAFICO_UL" NUMBER, 
	"TRAFICO_DL" NUMBER, 
	"USER_ACT_BUFFER_UL_MAX" NUMBER, 
	"USER_ACT_BUFFER_DL_MAX" NUMBER, 
	"USER_ACT_BUFFER_UL_AVG" NUMBER, 
	"USER_ACT_BUFFER_DL_AVG" NUMBER, 
	"RACH_STP_SUCCESS_NUM" NUMBER, 
	"RACH_STP_SUCCESS_DEN" NUMBER, 
	"LATENCY_UL" NUMBER, 
	"LATENCY_DL" NUMBER, 
	"CELL_THROUGHPUT_DL" NUMBER, 
	"CELL_THROUGHPUT_UL" NUMBER, 
	"BLER_PUSCH_NUM" NUMBER, 
	"BLER_PUSCH_DEN" NUMBER, 
	"BLER_PDSCH_NUM" NUMBER, 
	"BLER_PDSCH_DEN" NUMBER, 
	"RRC_CONN_STP_SUCCESS_NUM" NUMBER, 
	"RRC_CONN_STP_SUCCESS_DEN" NUMBER, 
	"RAB_DROP_ATTEMPTS" NUMBER, 
	"RAB_STP_SUCCESS_NUM" NUMBER, 
	"RAB_STP_SUCCESS_DEN" NUMBER, 
	"RAB_SETUP_SUCCESS_NUM" NUMBER, 
	"RAB_SETUP_SUCCESS_DEN" NUMBER, 
	"RRC_CONN_STP_ATTEMPTS" NUMBER, 
	"EPS_BEARER_SETUP_ATTEMPTS" NUMBER, 
	"RAB_DROP_USR_NUM" NUMBER, 
	"RAB_DROP_USR_DEN" NUMBER, 
	"RAB_NORMAL_RELEASE_NUM" NUMBER, 
	"RAB_NORMAL_RELEASE_DEN" NUMBER, 
	"EPC_EPS_BEARER_REL_REQ_RNL" NUMBER, 
	"EPC_EPS_BEARER_REL_REQ_OTH" NUMBER, 
	"AVG_ACTIVE_USER_CELL" NUMBER, 
	"MAX_AVG_ACTIVE_USER_CELL" NUMBER, 
	"RRC_CONNECTED_UES" NUMBER
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
 (PARTITION "LTE_NSN_20150621"  VALUES LESS THAN (TO_DATE(' 2015-06-28 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20150628"  VALUES LESS THAN (TO_DATE(' 2015-07-05 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20150705"  VALUES LESS THAN (TO_DATE(' 2015-07-12 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20150712"  VALUES LESS THAN (TO_DATE(' 2015-07-19 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20150719"  VALUES LESS THAN (TO_DATE(' 2015-07-26 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20150726"  VALUES LESS THAN (TO_DATE(' 2015-08-02 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20150802"  VALUES LESS THAN (TO_DATE(' 2015-08-09 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20150809"  VALUES LESS THAN (TO_DATE(' 2015-08-16 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20150816"  VALUES LESS THAN (TO_DATE(' 2015-08-23 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20150823"  VALUES LESS THAN (TO_DATE(' 2015-08-30 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20150830"  VALUES LESS THAN (TO_DATE(' 2015-09-06 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20150906"  VALUES LESS THAN (TO_DATE(' 2015-09-13 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20150913"  VALUES LESS THAN (TO_DATE(' 2015-09-20 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20150920"  VALUES LESS THAN (TO_DATE(' 2015-09-27 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20150927"  VALUES LESS THAN (TO_DATE(' 2015-10-04 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20151004"  VALUES LESS THAN (TO_DATE(' 2015-10-11 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20151011"  VALUES LESS THAN (TO_DATE(' 2015-10-18 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20151018"  VALUES LESS THAN (TO_DATE(' 2015-10-25 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20151025"  VALUES LESS THAN (TO_DATE(' 2015-11-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20151101"  VALUES LESS THAN (TO_DATE(' 2015-11-08 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20151108"  VALUES LESS THAN (TO_DATE(' 2015-11-15 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20151115"  VALUES LESS THAN (TO_DATE(' 2015-11-22 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20151122"  VALUES LESS THAN (TO_DATE(' 2015-11-29 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20151129"  VALUES LESS THAN (TO_DATE(' 2015-12-06 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20151206"  VALUES LESS THAN (TO_DATE(' 2015-12-13 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20151213"  VALUES LESS THAN (TO_DATE(' 2015-12-20 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
 PARTITION "LTE_NSN_20151220"  VALUES LESS THAN (TO_DATE(' 2015-12-27 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) , 
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
