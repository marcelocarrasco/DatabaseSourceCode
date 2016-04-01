--------------------------------------------------------
--  DDL for Table MV_CAPABILITIES_TABLE
--------------------------------------------------------

  CREATE TABLE "HARRIAGUE"."MV_CAPABILITIES_TABLE" 
   (	"STATEMENT_ID" VARCHAR2(30 BYTE), 
	"MVOWNER" VARCHAR2(30 BYTE), 
	"MVNAME" VARCHAR2(30 BYTE), 
	"CAPABILITY_NAME" VARCHAR2(30 BYTE), 
	"POSSIBLE" CHAR(1 BYTE), 
	"RELATED_TEXT" VARCHAR2(2000 BYTE), 
	"RELATED_NUM" NUMBER, 
	"MSGNO" NUMBER(*,0), 
	"MSGTXT" VARCHAR2(2000 BYTE), 
	"SEQ" NUMBER
   ) ;
