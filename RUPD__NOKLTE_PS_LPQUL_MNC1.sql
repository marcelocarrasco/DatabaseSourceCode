--------------------------------------------------------
--  DDL for Table RUPD$_NOKLTE_PS_LPQUL_MNC1
--------------------------------------------------------

  CREATE GLOBAL TEMPORARY TABLE "HARRIAGUE"."RUPD$_NOKLTE_PS_LPQUL_MNC1" 
   (	"PERIOD_START_TIME" DATE, 
	"INT_ID" NUMBER, 
	"MCC_ID" VARCHAR2(10 BYTE), 
	"MNC_ID" VARCHAR2(10 BYTE), 
	"DMLTYPE$$" VARCHAR2(1 BYTE), 
	"SNAPID" NUMBER(*,0), 
	"CHANGE_VECTOR$$" RAW(255)
   ) ON COMMIT PRESERVE ROWS ;
 

   COMMENT ON TABLE "HARRIAGUE"."RUPD$_NOKLTE_PS_LPQUL_MNC1"  IS 'temporary updatable snapshot log';
