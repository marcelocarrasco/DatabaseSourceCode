--------------------------------------------------------
--  DDL for Table MLOG$_NOKLTE_PS_LCELAV_MNC
--------------------------------------------------------

  CREATE TABLE "HARRIAGUE"."MLOG$_NOKLTE_PS_LCELAV_MNC" 
   (	"PERIOD_START_TIME" DATE, 
	"INT_ID" NUMBER, 
	"MCC_ID" VARCHAR2(10 BYTE), 
	"MNC_ID" VARCHAR2(10 BYTE), 
	"SNAPTIME$$" DATE, 
	"DMLTYPE$$" VARCHAR2(1 BYTE), 
	"OLD_NEW$$" VARCHAR2(1 BYTE), 
	"CHANGE_VECTOR$$" RAW(255)
   ) ;
 

   COMMENT ON TABLE "HARRIAGUE"."MLOG$_NOKLTE_PS_LCELAV_MNC"  IS 'snapshot log for master table HARRIAGUE.NOKLTE_PS_LCELAV_MNC1_RAW';
