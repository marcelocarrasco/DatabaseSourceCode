--------------------------------------------------------
--  DDL for Table MLOG$_NOKLTE_PS_LUEST_MNC1
--------------------------------------------------------

  CREATE TABLE "HARRIAGUE"."MLOG$_NOKLTE_PS_LUEST_MNC1" 
   (	"PERIOD_START_TIME" DATE, 
	"INT_ID" NUMBER, 
	"MCC_ID" VARCHAR2(10 BYTE), 
	"MNC_ID" VARCHAR2(10 BYTE), 
	"SNAPTIME$$" DATE, 
	"DMLTYPE$$" VARCHAR2(1 BYTE), 
	"OLD_NEW$$" VARCHAR2(1 BYTE), 
	"CHANGE_VECTOR$$" RAW(255)
   ) ;
 

   COMMENT ON TABLE "HARRIAGUE"."MLOG$_NOKLTE_PS_LUEST_MNC1"  IS 'snapshot log for master table HARRIAGUE.NOKLTE_PS_LUEST_MNC1_RAW';
