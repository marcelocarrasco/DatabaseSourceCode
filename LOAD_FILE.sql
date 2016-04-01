--------------------------------------------------------
--  DDL for Procedure LOAD_FILE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HARRIAGUE"."LOAD_FILE" (p_local_dir        IN VARCHAR2,
                                      p_file_name        IN VARCHAR2,
                                      g_type_measurement IN VARCHAR2) IS
  v_response INTEGER;
BEGIN
  CASE trim(g_type_measurement)
    --measurement Type LTE
    WHEN '<PMTarget  measurementType="Mobility_Management">' THEN
      v_response := com_util_parse.parser_M_Mobility_Management(p_local_dir, p_file_name);
    
    WHEN '<PMTarget  measurementType="Session_Management">' THEN
      v_response := com_util_parse.parser_M_Session_Management(p_local_dir,p_file_name);
    
    WHEN '<PMTarget  measurementType="MMDU_User_Level">' THEN
      v_response := com_util_parse.parser_M_MMDU_User_Level(p_local_dir,p_file_name);
    
    WHEN '<PMTarget  measurementType="User_MME_Level">' THEN
      v_response := com_util_parse.parser_M_User_MME_Level(p_local_dir,p_file_name);
    
    WHEN '<PMTarget  measurementType="SGsAP">' THEN
      v_response := com_util_parse.parser_M_SGsAP(p_local_dir, p_file_name);
    
    WHEN '<PMTarget  measurementType="ULOAD">' THEN
      v_response := com_util_parse.parser_M_Computer_Unit_Load(p_local_dir,p_file_name);
    
    WHEN '<PMTarget  measurementType="LTE_Cell_Throughput">' THEN
      v_response := com_util_parse.parser_LTE_Cell_Throughput(p_local_dir,p_file_name);
    
    WHEN '<PMTarget  measurementType="LTE_S1AP">' THEN
      v_response := com_util_parse.parser_LTE_S1AP(p_local_dir, p_file_name);
    
    WHEN '<PMTarget  measurementType="LTE_UE_State">' THEN
      v_response := com_util_parse.parser_LTE_UE_State(p_local_dir,p_file_name);
    
    WHEN '<PMTarget  measurementType="LTE_Cell_Load">' THEN
      v_response := com_util_parse.parser_LTE_Cell_LoadP(p_local_dir, p_file_name);
      
    WHEN '<PMTarget  measurementType="LTE_Pwr_and_Qual_DL">' THEN
      v_response := com_util_parse.parser_LTE_Pwr_and_Qual_DL(p_local_dir, p_file_name);  
      
      
    WHEN '<PMTarget  measurementType="LTE_EPS_Bearer">' THEN
    v_response := com_util_parse.parser_LTE_EPS_Bearer(p_local_dir, p_file_name);
    
    WHEN '<PMTarget  measurementType="LTE_Pwr_and_Qual_UL">' THEN
    v_response := com_util_parse.parser_LTE_Pwr_and_Qual_UL(p_local_dir, p_file_name); 
    
    WHEN '<PMTarget  measurementType="LTE_Cell_Avail">' THEN
    v_response := com_util_parse.parser_LTE_Cell_Avail(p_local_dir, p_file_name);
    
    WHEN '<PMTarget  measurementType="LTE_Radio_Bearer">' THEN
    v_response := com_util_parse.parser_LTE_Radio_Bearer(p_local_dir, p_file_name);
    
    WHEN '<PMTarget  measurementType="LTE_Cell_Resource">' THEN
    v_response := com_util_parse.parser_LTE_Cell_Resource(p_local_dir, p_file_name);
    
    WHEN '<PMTarget  measurementType="LTE_RRC">' THEN
    v_response := com_util_parse.parser_LTE_RRC(p_local_dir, p_file_name);
    
    WHEN '<PMTarget  measurementType="LTE_Handover">' THEN
    v_response := com_util_parse.parser_LTE_Handover(p_local_dir, p_file_name);
    
    WHEN '<PMTarget  measurementType="LTE_Inter_Sys_HO">' THEN
    v_response := com_util_parse.parser_LTE_Inter_Sys_HO(p_local_dir, p_file_name);                                                       
    
    --measurement Type UMTS
    
    WHEN 'Traffic' THEN
    v_response := com_util_parse.parser_UMTS_Traffic(p_local_dir, p_file_name);
    
  END CASE;
  IF(v_response = 0)THEN
    DBMS_OUTPUT.put_line('Parser successfull, file:' || p_file_name );
  END IF;
 
EXCEPTION
  WHEN CASE_NOT_FOUND THEN
    DBMS_OUTPUT.put_line('Condition out case');
  
END load_file;

/
