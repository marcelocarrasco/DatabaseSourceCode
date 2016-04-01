--------------------------------------------------------
--  DDL for Package COM_UTIL_PARSE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "HARRIAGUE"."COM_UTIL_PARSE" 
IS
  --
  /*
  ***************************************************************************
  Overview : Package for performing parse and load  operations -LTE MME
  ***************************************************************************
  /* parse xml with Mobility Management measurement and load in a database */
  FUNCTION parser_M_Mobility_Management(
      p_local_dir        IN VARCHAR2,
      p_file_name        IN VARCHAR2)
   RETURN INTEGER;
   
   

  /* parse xml with Session Management measurement and load in a database */
  FUNCTION parser_M_Session_Management(
      p_local_dir        IN VARCHAR2,
      p_file_name        IN VARCHAR2)
   RETURN INTEGER;   
   

  /* parse xml with MMDU_User_Level measurement and load in a database */
  FUNCTION parser_M_MMDU_User_Level(
      p_local_dir        IN VARCHAR2,
      p_file_name        IN VARCHAR2)
   RETURN INTEGER;
   
   
  /* parse xml with User_MME_Level measurement and load in a database */
  FUNCTION parser_M_User_MME_Level(
      p_local_dir        IN VARCHAR2,
      p_file_name        IN VARCHAR2)
   RETURN INTEGER;
   

  /* parse xml with SGsAP measurement and load in a database */
  FUNCTION parser_M_SGsAP(
      p_local_dir        IN VARCHAR2,
      p_file_name        IN VARCHAR2)
   RETURN INTEGER;
   
   
  /* parse xml with Compute_Unit_Load measurement and load in a database */
  FUNCTION parser_M_Computer_Unit_Load(
      p_local_dir        IN VARCHAR2,
      p_file_name        IN VARCHAR2)
   RETURN INTEGER;  


  /* parse xml with Network_Element_User measurement and load in a database 
  FUNCTION parser_M_Network_Element_User(
      p_local_dir        IN VARCHAR2,
      p_file_name        IN VARCHAR2)
   RETURN INTEGER;  */
   
   
   
    /*
  ***************************************************************************
  Overview : Package for performing parse and load  operations -LTE EnodeB
  ***************************************************************************   
 
  /* parse xml with Network_Element_User measurement and load in a database */
  FUNCTION parser_LTE_Cell_Throughput(
      p_local_dir        IN VARCHAR2,
      p_file_name        IN VARCHAR2)
   RETURN INTEGER; 
   
  
  
  /* parse xml with Network_Element_User measurement and load in a database */
  FUNCTION parser_LTE_S1AP(
      p_local_dir        IN VARCHAR2,
      p_file_name        IN VARCHAR2)
   RETURN INTEGER;  
   
   
  /* parse xml with LTE_UE_State measurement and load in a database */
  FUNCTION parser_LTE_UE_State(
      p_local_dir        IN VARCHAR2,
      p_file_name        IN VARCHAR2)
   RETURN INTEGER;
   
  /* parse xml with LTE_EPS_Bearer measurement and load in a database  */
  FUNCTION parser_LTE_EPS_Bearer(
      p_local_dir        IN VARCHAR2,
      p_file_name        IN VARCHAR2)
   RETURN INTEGER;
 
  /* parse xml with LTE Cell_Load measurement and load in a database  */
  FUNCTION parser_LTE_Cell_LoadP(
      p_local_dir        IN VARCHAR2,
      p_file_name        IN VARCHAR2)
   RETURN INTEGER;
   
     /* parse xml with LTE _Pwr_and_Qual_DL measurement and load in a database  */
  FUNCTION parser_LTE_Pwr_and_Qual_DL(
      p_local_dir        IN VARCHAR2,
      p_file_name        IN VARCHAR2)
   RETURN INTEGER;
  
   /* parse xml with LTE_Pwr_and_Qual_UL measurement and load in a database  */
  FUNCTION parser_LTE_Pwr_and_Qual_UL(
      p_local_dir        IN VARCHAR2,
      p_file_name        IN VARCHAR2)
   RETURN INTEGER;
   
  /* parse xml with LTE_Cell_Avail measurement and load in a database*/
  FUNCTION parser_LTE_Cell_Avail(
      p_local_dir        IN VARCHAR2,
      p_file_name        IN VARCHAR2)
   RETURN INTEGER;
   
  /* parse xml with LTE_Radio_Bearer measurement and load in a database*/
  FUNCTION parser_LTE_Radio_Bearer(
      p_local_dir        IN VARCHAR2,
      p_file_name        IN VARCHAR2)
   RETURN INTEGER;   
     
     /* parse xml with LTE_Cell_Resource measurement and load in a database*/
  FUNCTION parser_LTE_Cell_Resource(
      p_local_dir        IN VARCHAR2,
      p_file_name        IN VARCHAR2)
   RETURN INTEGER;
   
     /* parse xml with LTE_RRC measurement and load in a database*/
  FUNCTION parser_LTE_RRC(
      p_local_dir        IN VARCHAR2,
      p_file_name        IN VARCHAR2)
   RETURN INTEGER;
   
   /* parse xml with LTE_Handover measurement and load in a database*/
FUNCTION parser_LTE_Handover(
      p_local_dir        IN VARCHAR2,
      p_file_name        IN VARCHAR2)
   RETURN INTEGER;
   
   /* parse xml with LTE_Inter_Sys_HO measurement and load in a database*/
FUNCTION parser_LTE_Inter_Sys_HO(
      p_local_dir        IN VARCHAR2,
      p_file_name        IN VARCHAR2)
   RETURN INTEGER;
   
  /*
  ***************************************************************************
  Overview : Package for performing parse and load  operations -UMTS
  ***************************************************************************
  /* parse xml with Traffic measurement and load in a database */  
  
 FUNCTION parser_UMTS_Traffic(
      p_local_dir        IN VARCHAR2,
      p_file_name        IN VARCHAR2)
   RETURN INTEGER;             

END com_util_parse;

/
