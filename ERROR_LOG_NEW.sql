--------------------------------------------------------
--  DDL for Table ERROR_LOG_NEW
--------------------------------------------------------

  CREATE TABLE "HARRIAGUE"."ERROR_LOG_NEW" 
   (	"FECHA" TIMESTAMP (6) DEFAULT systimestamp, 
	"OBJETO" VARCHAR2(70 CHAR), 
	"SQL_CODE" NUMBER, 
	"SQL_ERRM" VARCHAR2(4000 CHAR), 
	"COMENTARIO" VARCHAR2(4000 CHAR)
   ) ;
