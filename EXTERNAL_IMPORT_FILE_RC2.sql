--------------------------------------------------------
--  DDL for Table EXTERNAL_IMPORT_FILE_RC2
--------------------------------------------------------

  CREATE TABLE "HARRIAGUE"."EXTERNAL_IMPORT_FILE_RC2" 
   (	"FILENAME" VARCHAR2(1000 BYTE), 
	"DATE_IMPORT" DATE, 
	"STATUS" VARCHAR2(10 BYTE), 
	"MEASUREMENT_TYPE" VARCHAR2(255 BYTE)
   ) 
   ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "WDIR_NSN_STORAGE_XML_DATA"
      ACCESS PARAMETERS
      ( records delimited by newline
        NOBADFILE
        NODISCARDFILE
        NOLOGFILE
        fields terminated by ','
        missing field VALUES ARE NULL
        reject ROWS WITH ALL NULL fields

       (
        FILENAME         CHAR(255),
        DATE_IMPORT      CHAR(255) date_format DATE mask "DD.MM.YYYY.HH24.MI.SS",
        STATUS           CHAR(255),
        MEASUREMENT_TYPE CHAR(255)
       )
          )
      LOCATION
       ( 'import_xml_2.txt'
       )
    )
  ;
