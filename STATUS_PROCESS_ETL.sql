--------------------------------------------------------
--  DDL for Table STATUS_PROCESS_ETL
--------------------------------------------------------

  CREATE TABLE "HARRIAGUE"."STATUS_PROCESS_ETL" 
   (	"FILENAME" VARCHAR2(1000 BYTE), 
	"DATE_IMPORT" DATE, 
	"STATUS" VARCHAR2(10 BYTE), 
	"MEASUREMENT_TYPE" VARCHAR2(100 BYTE), 
	"NETWORK_ELEMENT" VARCHAR2(100 BYTE), 
	"DATE_PROCESS" DATE
   ) ;
