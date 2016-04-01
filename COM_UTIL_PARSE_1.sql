--------------------------------------------------------
--  DDL for Package Body COM_UTIL_PARSE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "HARRIAGUE"."COM_UTIL_PARSE" 
IS
  /*
  ***************************************************************************
  Overview : Package for performing parse and load  operations -LTE MME
  ***************************************************************************

  /* parse xml with Mobility Management measurement and load in a database */
FUNCTION parser_M_Mobility_Management(
    p_local_dir        IN VARCHAR2,
    p_file_name        IN VARCHAR2)
    RETURN INTEGER 
 
IS
   return_result INTEGER;              -- 2: error procesed, 1: ok procesed
   
BEGIN
     
   

  INSERT INTO pcofns_ps_mmmt_ta_raw
    (FINS_ID,MCC_ID,MNC_ID,TA_ID,PERIOD_START_TIME,PERIOD_DURATION,EPS_ATTACH_SUCC,EPS_ATTACH_FAIL,EPS_DETACH,EPS_PERIODIC_TAU_SUCC,EPS_PERIODIC_TAU_FAIL,
    EPS_TAU_SUCC,EPS_TAU_FAIL,EPS_SERVICE_REQUEST_SUCC,EPS_SERVICE_REQUEST_FAIL,EPS_PATH_SWITCH_X2_SUCC,EPS_PATH_SWITCH_X2_FAIL,EPS_PAGING_ATTEMPTS,
    EPS_PAGING_SUCC,EPS_PAGING_FAIL,EPS_TO_3G_GN_ISHO_SUCC,EPS_TO_3G_GN_ISHO_TRGT_REJE,EPS_TO_3G_GN_ISHO_PREP_FAIL,EPS_TO_3G_GN_ISHO_ENB_CNCL,
    EPS_TO_3G_GN_ISHO_FAIL,EPS_S1HO_SUCC,EPS_S1HO_FAIL,EPS_S1HO_DUE_TO_MME_FAIL,EPS_S1HO_ENB_ERROR_FAIL,
    EPS_S1HO_SGW_ERROR_FAIL,EPS_S1HO_COLLISION_FAIL,EPS_S1HO_UNSPECIFIED_RE_FAIL,EPS_S1HO_UNKNOWN_TARGET_FAIL,EPS_S1HO_IN_TARGET_SYST_FAIL,
    EPS_S1HO_HO_CANCELLED_FAIL,EPS_S1HO_INTERACTION_WI_FAIL,EPS_S1HO_TARGET_ALLOW_FAIL,EPS_S1HO_CELL_NOT_AVAIL_FAIL,EPS_S1HO_NO_RADIO_RESOU_FAIL,
    EPS_S1HO_ALG_NOT_SUPP_FAIL,EPS_S1HO_UNSPEC_CAUSE_FAIL,EPS_CMB_INTRA_TAU_SUCC,EPS_CMB_INTRA_TAU_FAIL,EPS_CMB_INTRA_TAU_IMSI_ATT_SUC,
    EPS_CMB_INTRA_TAU_IMSI_ATT_FAI,EPS_CMB_INTER_TAU_SUCC,EPS_CMB_INTER_TAU_FAIL,EPS_INTER_TAU_OG_SUCC,EPS_INTER_TAU_OG_FAIL,INTRATAU_WO_SGW_CHANGE_SUCC,
    INTRATAU_WO_SGW_CHANGE_FAIL,EPS_COMBINED_ATTACH_SUCC,EPS_CMBND_ATTACH_EPS_SUCC,EPS_CMBND_ATTACH_EPS_FAIL,EPS_CMBND_ATTACH_FAIL,
    ESR_MO_ATTEMPTS,ESR_MT_ATTEMPTS,ESR_MO_EMERGENCY_ATTEMPTS,EPS_ATTACH_SUCC_UE_APN,EPS_ATTACH_SUCC_UE_APN_OVERRDN,EPS_ATTACH_FAIL_ESM_INFO_REQ,
    INTRAMME_S1HO_SGW_CHG_FAIL,INTRAMME_S1HO_SGW_CHG_SUCC,EPS_X2HO_SGW_CHG_SUCC,INTRAMME_TAU_SGW_CHG_SUCC,MME_OFFLOAD_SUCCESSFUL,MME_OFFLOAD_SUCCESS_ABNORMAL,
    MME_OFFLOAD_FAILED,MME_OFFLOAD_FAILED_ENB_ERROR,MME_OFFLOAD_FAILED_COLLISIONS,INTERMME_TAU_WO_SGW_CHG_SUCC,INTERMME_TAU_OUT_SUCC,
    INTERMME_S1HO_WO_SGW_CHG_SUCC,INTERMME_S1HO_OUT_SUCC,INTERMME_TAU_IN_FAIL,INTERMME_TAU_OUT_FAIL,INTERMME_S1HO_IN_FAIL,INTERMME_S1HO_OUT_FAIL,
    ATTACH_IN_WITH_MME_CHG_SUCC,ATTACH_IN_WITH_MME_CHG_FAIL,EPS_ATTACH_DUE_TO_MME_FAIL,EPS_TAU_DUE_TO_MME_FAIL,EPS_SERVICE_REQUEST_MME_FAIL,
    EPS_ATTACH_NAS_03_FAIL,EPS_ATTACH_NAS_06_FAIL,EPS_ATTACH_NAS_07_FAIL,EPS_ATTACH_NAS_08_FAIL,EPS_TAU_NAS_03_FAIL,EPS_TAU_NAS_06_FAIL,
    EPS_TAU_NAS_07_FAIL,EPS_TAU_NAS_08_FAIL,EPS_PAGING_1ST_ATTEMPT_SUCC)
WITH t AS (SELECT xmltype(bfilename(p_local_dir,p_file_name), nls_charset_id('UTF-8')) xmlcol FROM dual)
SELECT
    (select INT_ID from MULTIVENDOR_OBJECTS where OBJECT_NRO = substr(REGEXP_SUBSTR(extractValue(value(x),'/PMMOResult/MO/DN/text()'),'FLEXINS-[0-9]*'),9)) FINS_ID,
    substr(REGEXP_SUBSTR(extractValue(value(x),'/PMMOResult/MO/DN/text()'),'MCC-[0-9]*'),5)  MCC_ID,
    substr(REGEXP_SUBSTR(extractValue(value(x),'/PMMOResult/MO/DN/text()'),'MNC-[0-9]*'),5) MNC_ID,
    substr(REGEXP_SUBSTR(extractValue(value(x),'/PMMOResult/MO/DN/text()'),'TA-[0-9]*'),4) TA_ID,
    TO_DATE(REGEXP_REPLACE(REGEXP_SUBSTR(extract(t.xmlcol, '/OMeS/PMSetup/@startTime'),'[0-9]*[-][0-9]*[-][0-9]*[^t][0-9]*[:][0-9]*[:][0-9]*'),'(T)', ' '),'YYYY-MM-DD HH24:MI:SS ') PERIOD_START_TIME,
    extract(t.xmlcol, '/OMeS/PMSetup/@interval').getNumberVal() PERIOD_DURATION,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C000') EPS_ATTACH_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C001') EPS_ATTACH_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C002') EPS_DETACH,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C003') EPS_PERIODIC_TAU_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C004') EPS_PERIODIC_TAU_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C005') EPS_TAU_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C006') EPS_TAU_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C007') EPS_SERVICE_REQUEST_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C008') EPS_SERVICE_REQUEST_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C009') EPS_PATH_SWITCH_X2_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C010') EPS_PATH_SWITCH_X2_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C011') EPS_PAGING_ATTEMPTS,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C012') EPS_PAGING_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C013') EPS_PAGING_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C014') EPS_TO_3G_GN_ISHO_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C015') EPS_TO_3G_GN_ISHO_TRGT_REJE,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C016') EPS_TO_3G_GN_ISHO_PREP_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C017') EPS_TO_3G_GN_ISHO_ENB_CNCL,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C018') EPS_TO_3G_GN_ISHO_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C019') EPS_S1HO_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C020') EPS_S1HO_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C021') EPS_S1HO_DUE_TO_MME_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C022') EPS_S1HO_ENB_ERROR_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C023') EPS_S1HO_SGW_ERROR_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C024') EPS_S1HO_COLLISION_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C025') EPS_S1HO_UNSPECIFIED_RE_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C026') EPS_S1HO_UNKNOWN_TARGET_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C027') EPS_S1HO_IN_TARGET_SYST_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C028') EPS_S1HO_HO_CANCELLED_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C029') EPS_S1HO_INTERACTION_WI_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C030') EPS_S1HO_TARGET_ALLOW_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C031') EPS_S1HO_CELL_NOT_AVAIL_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C032') EPS_S1HO_NO_RADIO_RESOU_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C033') EPS_S1HO_ALG_NOT_SUPPFAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C034') EPS_S1HO_UNSPEC_CAUSE_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C035') EPS_CMB_INTRA_TAU_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C036') EPS_CMB_INTRA_TAU_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C037') EPS_CMB_INTRA_TAU_IMSI_ATT_SUC,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C038') EPS_CMB_INTRA_TAU_IMSI_ATT_FAI,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C039') EPS_CMB_INTER_TAU_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C040') EPS_CMB_INTER_TAU_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C041') EPS_INTER_TAU_OG_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C042') EPS_INTER_TAU_OG_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C043') INTRATAU_WO_SGW_CHANGE_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C044') INTRATAU_WO_SGW_CHANGE_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C045') EPS_COMBINED_ATTACH_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C046') EPS_CMBND_ATTACH_EPS_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C047') EPS_CMBND_ATTACH_EPS_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C048') EPS_CMBND_ATTACH_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C049') ESR_MO_ATTEMPTS,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C050') ESR_MT_ATTEMPTS,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C051') ESR_MO_EMERGENCY_ATTEMPTS,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C052') EPS_ATTACH_SUCC_UE_APN,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C053') EPS_ATTACH_SUCC_UE_APN_OVERRDN,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C054') EPS_ATTACH_FAIL_ESM_INFO_REQ,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C055') INTRAMME_S1HO_SGW_CHG_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C056') INTRAMME_S1HO_SGW_CHG_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C057') EPS_X2HO_SGW_CHG_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C058') INTRAMME_TAU_SGW_CHG_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C059') MME_OFFLOAD_SUCCESSFUL, 
    extractValue(value(x),'/PMMOResult/PMTarget/M50C060') MME_OFFLOAD_SUCCESS_ABNORMAL,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C061') MME_OFFLOAD_FAILED,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C062') MME_OFFLOAD_FAILED_ENB_ERROR,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C063') MME_OFFLOAD_FAILED_COLLISIONS,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C064') INTERMME_TAU_WO_SGW_CHG_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C065') INTERMME_TAU_OUT_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C066') INTERMME_S1HO_WO_SGW_CHG_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C067') INTERMME_S1HO_OUT_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C068') INTERMME_TAU_IN_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C069') INTERMME_TAU_OUT_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C070') INTERMME_S1HO_IN_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C071') INTERMME_S1HO_OUT_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C072') ATTACH_IN_WITH_MME_CHG_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C073') ATTACH_IN_WITH_MME_CHG_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C074') EPS_ATTACH_DUE_TO_MME_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C075') EPS_TAU_DUE_TO_MME_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C076') EPS_SERVICE_REQUEST_MME_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C077') EPS_ATTACH_NAS_03_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C078') EPS_ATTACH_NAS_06_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C079') EPS_ATTACH_NAS_07_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C080') EPS_ATTACH_NAS_08_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C081') EPS_TAU_NAS_03_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C082') EPS_TAU_NAS_06_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C083') EPS_TAU_NAS_07_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C084') EPS_TAU_NAS_08_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M50C085') EPS_PAGING_1ST_ATTEMPT_SUCC
    
    FROM t,TABLE(XMLSequence(extract(t.xmlcol,'/OMeS/PMSetup/PMMOResult'))) x;
   -- update table STATUS_PROCESS_ETL whith information the xml status 1:processed.
   update STATUS_PROCESS_ETL set status ='1' where filename = p_file_name;
    return_result := 1;
    return return_result;
    
  EXCEPTION
  WHEN OTHERS THEN
    raise_application_error(-20001,'An error has been found - '||SQLCODE||' -ERROR- '||SQLERRM);
   -- update table STATUS_PROCESS_ETL whith information the xml status 2: error processed.
   update STATUS_PROCESS_ETL set status ='2' where filename = p_file_name;
    return_result := 2;
    return return_result;
  COMMIT;  
END parser_M_Mobility_Management;


  /* parse xml with Session Management measurement and load in a database */
FUNCTION parser_M_Session_Management(
    p_local_dir        IN VARCHAR2,
    p_file_name        IN VARCHAR2)
    RETURN INTEGER

IS
   return_result INTEGER;              -- 2: error procesed, 1: ok procesed
   
BEGIN
    
   

  INSERT INTO pcofns_ps_smmt_ta_raw
    (FINS_ID,MCC_ID,MNC_ID,TA_ID,PERIOD_START_TIME,PERIOD_DURATION, EPS_DEF_BEARER_ACT_SUCC, EPS_DEF_BEARER_ACT_FAIL, EPS_DEF_BEARER_DEACT,
     GW_INIT_BEARER_MOD_SUCCESS, GW_INIT_BEARER_MOD_FAILURE, GW_INIT_BEARER_MOD_FAIL_UE, GW_INIT_BEARER_MOD_FAIL_ENB, GW_INIT_BEARER_MOD_FAIL_SGW,
     GW_INIT_BEARER_MOD_FAIL_MME, HSS_INIT_BEARER_MOD_SUCCESS, HSS_INIT_BEARER_MOD_FAILURE, HSS_INIT_BEARER_MOD_FAIL_UE, HSS_INIT_BEARER_MOD_FAIL_ENB,
     HSS_INIT_BEARER_MOD_FAIL_SGW, PDN_CONNECTIVITY_SUCCESSFUL, PDN_CONNECTIVITY_FAILED, PDN_CONNECTIVITY_FAILED_MME, PDN_CONNECTIVITY_FAILED_SGW,
     PDN_CONNECTIVITY_FAILED_UE, PDN_CONNECTIVITY_FAILED_ENB, PDN_CONNECT_FAILED_COLLISION, PDN_CONNECT_FAILED_UNSPECIFIED, DDBEARER_HSSINIT_MOD_SUCC,
     DDBEARER_HSSINIT_MOD_FAIL, DDBEARER_PGWINIT_ACT_SUCC, DDBEARER_PGWINIT_ACT_FAIL, DDBEARER_PGWINIT_MOD_SUCC, DDBEARER_PGWINIT_MOD_FAIL,
     DDBEARER_PGWINIT_DEACT_SUCC, DDBEARER_MMEINIT_DEACT_SUCC, DDBEARER_MMEINIT_DEACT_ABNORM, DDBEARER_UEINIT_ACT_SUCC, DDBEARER_UEINIT_ACT_FAIL,
     DDBEARER_UEINIT_MOD_SUCC, DDBEARER_UEINIT_MOD_FAIL, DDBEARER_UEINIT_DEACT_SUCC, DDBEARER_UEINIT_DEACT_FAIL, EPS_DEF_BEARER_ACT_MME_FAIL,
     EPS_DDBEARER_REQ_BY_MME, EPS_DDBEARE_CONF_BY_UE, EPS_DFBEARER_S5_S8_REQ_BY_MME, EPS_DFBEARER_S5_S8_CONF_BY_SGW, EPS_DDBEARER_S5_S8_REQ_BY_MME,
     EPS_DDBEARER_S5_S8_CONF_BY_SGW, EMCALL_PDN_CONN_SUCC, EMCALL_PDN_CONN_FAIL, EMCALL_DED_BEARER_ACT_SUCC, EMCALL_DED_BEARER_ACT_FAIL)
WITH t AS (SELECT xmltype(bfilename(p_local_dir,p_file_name), nls_charset_id('UTF-8')) xmlcol FROM dual)
SELECT
    (select INT_ID from multivendor_objects where OBJECT_NRO = substr(REGEXP_SUBSTR(extractValue(value(x),'/PMMOResult/MO/DN/text()'),'FLEXINS-[0-9]*'),9)) FINS_ID,
    substr(REGEXP_SUBSTR(extractValue(value(x),'/PMMOResult/MO/DN/text()'),'MCC-[0-9]*'),5)  MCC_ID,
    substr(REGEXP_SUBSTR(extractValue(value(x),'/PMMOResult/MO/DN/text()'),'MNC-[0-9]*'),5) MNC_ID,
    substr(REGEXP_SUBSTR(extractValue(value(x),'/PMMOResult/MO/DN/text()'),'TA-[0-9]*'),4) TA_ID,
    TO_DATE(REGEXP_REPLACE(REGEXP_SUBSTR(extract(t.xmlcol, '/OMeS/PMSetup/@startTime'),'[0-9]*[-][0-9]*[-][0-9]*[^t][0-9]*[:][0-9]*[:][0-9]*'),'(T)', ' '),'YYYY-MM-DD HH24:MI:SS ') PERIOD_START_TIME,
    extract(t.xmlcol, '/OMeS/PMSetup/@interval').getNumberVal() PERIOD_DURATION,
    extractValue(value(x),'/PMMOResult/PMTarget/M51C000') EPS_DEF_BEARER_ACT_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M51C001') EPS_DEF_BEARER_ACT_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M51C002') EPS_DEF_BEARER_DEACT,
    extractValue(value(x),'/PMMOResult/PMTarget/M51C003') GW_INIT_BEARER_MOD_SUCCESS,
    extractValue(value(x),'/PMMOResult/PMTarget/M51C004') GW_INIT_BEARER_MOD_FAILURE,
    extractValue(value(x),'/PMMOResult/PMTarget/M51C005') GW_INIT_BEARER_MOD_FAIL_UE,
    extractValue(value(x),'/PMMOResult/PMTarget/M51C006') GW_INIT_BEARER_MOD_FAIL_ENB,
    extractValue(value(x),'/PMMOResult/PMTarget/M51C007') GW_INIT_BEARER_MOD_FAIL_SGW,
    extractValue(value(x),'/PMMOResult/PMTarget/M51C008') GW_INIT_BEARER_MOD_FAIL_MME,
    extractValue(value(x),'/PMMOResult/PMTarget/M51C009') HSS_INIT_BEARER_MOD_SUCCESS,
    extractValue(value(x),'/PMMOResult/PMTarget/M51C010') HSS_INIT_BEARER_MOD_FAILURE,
    extractValue(value(x),'/PMMOResult/PMTarget/M51C011') HSS_INIT_BEARER_MOD_FAIL_UE,
    extractValue(value(x),'/PMMOResult/PMTarget/M51C012') HSS_INIT_BEARER_MOD_FAIL_ENB,
    extractValue(value(x),'/PMMOResult/PMTarget/M51C013') HSS_INIT_BEARER_MOD_FAIL_SGW,
    extractValue(value(x),'/PMMOResult/PMTarget/M51C014') PDN_CONNECTIVITY_SUCCESSFUL,
    extractValue(value(x),'/PMMOResult/PMTarget/M51C015') PDN_CONNECTIVITY_FAILED,
    extractValue(value(x),'/PMMOResult/PMTarget/M51C016') PDN_CONNECTIVITY_FAILED_MME,
    extractValue(value(x),'/PMMOResult/PMTarget/M51C017') PDN_CONNECTIVITY_FAILED_SGW,
    extractValue(value(x),'/PMMOResult/PMTarget/M51C018') PDN_CONNECTIVITY_FAILED_UE,
    extractValue(value(x),'/PMMOResult/PMTarget/M51C019') PDN_CONNECTIVITY_FAILED_ENB,
    extractValue(value(x),'/PMMOResult/PMTarget/M51C020') PDN_CONNECT_FAILED_COLLISION,
    extractValue(value(x),'/PMMOResult/PMTarget/M51C021') PDN_CONNECT_FAILED_UNSPECIFIED,
    extractValue(value(x),'/PMMOResult/PMTarget/M51C022') DDBEARER_HSSINIT_MOD_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M51C023') DDBEARER_HSSINIT_MOD_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M51C024') DDBEARER_PGWINIT_ACT_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M51C025') DDBEARER_PGWINIT_ACT_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M51C026') DDBEARER_PGWINIT_MOD_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M51C027') DDBEARER_PGWINIT_MOD_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M51C028') DDBEARER_PGWINIT_DEACT_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M51C029') DDBEARER_MMEINIT_DEACT_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M51C030') DDBEARER_MMEINIT_DEACT_ABNORM,
    extractValue(value(x),'/PMMOResult/PMTarget/M51C031') DDBEARER_UEINIT_ACT_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M51C032') DDBEARER_UEINIT_ACT_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M51C033') DDBEARER_UEINIT_MOD_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M51C034') DDBEARER_UEINIT_MOD_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M51C035') DDBEARER_UEINIT_DEACT_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M51C036') DDBEARER_UEINIT_DEACT_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M51C037') EPS_DEF_BEARER_ACT_MME_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M51C038') EPS_DDBEARER_REQ_BY_MME,
    extractValue(value(x),'/PMMOResult/PMTarget/M51C039') EPS_DDBEARE_CONF_BY_UE,
    extractValue(value(x),'/PMMOResult/PMTarget/M51C040') EPS_DFBEARER_S5_S8_REQ_BY_MME,
    extractValue(value(x),'/PMMOResult/PMTarget/M51C041') EPS_DFBEARER_S5_S8_CONF_BY_SGW,
    extractValue(value(x),'/PMMOResult/PMTarget/M51C042') EPS_DDBEARER_S5_S8_REQ_BY_MME,
    extractValue(value(x),'/PMMOResult/PMTarget/M51C043') EPS_DDBEARER_S5_S8_CONF_BY_SGW,
    extractValue(value(x),'/PMMOResult/PMTarget/M51C044') EMCALL_PDN_CONN_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M51C045') EMCALL_PDN_CONN_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M51C046') EMCALL_DED_BEARER_ACT_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M51C047') EMCALL_DED_BEARER_ACT_FAIL
    
    FROM t,TABLE(XMLSequence(extract(t.xmlcol,'/OMeS/PMSetup/PMMOResult'))) x;
  -- update table STATUS_PROCESS_ETL whith information the xml status 1:processed.
   update STATUS_PROCESS_ETL set status ='1' where filename = p_file_name;
    return_result := 1;
    return return_result;
    
   EXCEPTION
  WHEN OTHERS THEN
    raise_application_error(-20001,'An error has been found - '||SQLCODE||' -ERROR- '||SQLERRM);
   -- update table STATUS_PROCESS_ETL whith information the xml status 2: error processed.
   update STATUS_PROCESS_ETL set status ='2' where filename = p_file_name;
    return_result := 2;
    return return_result;   
    COMMIT; 
END parser_M_Session_Management;

  /* parse xml with MMDU User Level measurement and load in a database */
FUNCTION parser_M_MMDU_User_Level(
    p_local_dir        IN VARCHAR2,
    p_file_name        IN VARCHAR2)
    RETURN INTEGER

IS
   return_result INTEGER;              -- 2: error procesed, 1: ok procesed
   
BEGIN
     
   

  INSERT INTO pcofns_ps_mulm_mmdu_raw
    (FINS_ID,MMDU_ID,PERIOD_START_TIME,PERIOD_DURATION, EPS_MMDU_EMM_REG_MIN, EPS_MMDU_EMM_REG_MAX, EPS_MMDU_EMM_REG_SUM, EPS_MMDU_EMM_REG_DENOM,
    EPS_MMDU_EMM_DEREG_MIN, EPS_MMDU_EMM_DEREG_MAX, EPS_MMDU_EMM_DEREG_SUM, MMDU_EMM_DEREG_DENOM, EPS_BEARER_ACTIVE_NBR_MAX,
    EPS_BEARER_DEDICATED_NBR_MAX, EPS_BEARER_DEDICATED_NBR_SUM, EPS_BEARER_DEDICATED_NBR_DEN, EPS_BEARER_DEFAULT_NBR_MAX,
    EPS_BEARER_DEFAULT_NBR_SUM, EPS_BEARER_DEFAULT_NBR_DEN)
WITH t AS (SELECT xmltype(bfilename(p_local_dir,p_file_name), nls_charset_id('UTF-8')) xmlcol FROM dual)
SELECT
    (select INT_ID from multivendor_objects where OBJECT_NRO = substr(REGEXP_SUBSTR(extractValue(value(x),'/PMMOResult/MO/DN/text()'),'FLEXINS-[0-9]*'),9)) FINS_ID,
    substr(REGEXP_SUBSTR(extractValue(value(x),'/PMMOResult/MO/DN/text()'),'MMDU-[0-9]*'),6)  MMDU_ID,
    TO_DATE(REGEXP_REPLACE(REGEXP_SUBSTR(extract(t.xmlcol, '/OMeS/PMSetup/@startTime'),'[0-9]*[-][0-9]*[-][0-9]*[^t][0-9]*[:][0-9]*[:][0-9]*'),'(T)', ' '),'YYYY-MM-DD HH24:MI:SS ') PERIOD_START_TIME,
    extract(t.xmlcol, '/OMeS/PMSetup/@interval').getNumberVal() PERIOD_DURATION,
     extractValue(value(x),'/PMMOResult/PMTarget/M58C000') EPS_MMDU_EMM_REG_MIN,
    extractValue(value(x),'/PMMOResult/PMTarget/M58C001') EPS_MMDU_EMM_REG_MAX,
    extractValue(value(x),'/PMMOResult/PMTarget/M58C002') EPS_MMDU_EMM_REG_SUM,
    extractValue(value(x),'/PMMOResult/PMTarget/M58C003') EPS_MMDU_EMM_REG_DENOM,
    extractValue(value(x),'/PMMOResult/PMTarget/M58C004') EPS_MMDU_EMM_DEREG_MIN,
    extractValue(value(x),'/PMMOResult/PMTarget/M58C005') EPS_MMDU_EMM_DEREG_MAX,
    extractValue(value(x),'/PMMOResult/PMTarget/M58C006') EPS_MMDU_EMM_DEREG_SUM,
    extractValue(value(x),'/PMMOResult/PMTarget/M58C007') MMDU_EMM_DEREG_DENOM,
    extractValue(value(x),'/PMMOResult/PMTarget/M58C008') EPS_BEARER_ACTIVE_NBR_MAX,
    extractValue(value(x),'/PMMOResult/PMTarget/M58C009') EPS_BEARER_DEDICATED_NBR_MAX,
    extractValue(value(x),'/PMMOResult/PMTarget/M58C010') EPS_BEARER_DEDICATED_NBR_SUM,
    extractValue(value(x),'/PMMOResult/PMTarget/M58C011') EPS_BEARER_DEDICATED_NBR_DEN,
    extractValue(value(x),'/PMMOResult/PMTarget/M58C012') EPS_BEARER_DEFAULT_NBR_MAX,
    extractValue(value(x),'/PMMOResult/PMTarget/M58C013') EPS_BEARER_DEFAULT_NBR_SUM,
    extractValue(value(x),'/PMMOResult/PMTarget/M58C014') EPS_BEARER_DEFAULT_NBR_DEN
    
    FROM t,TABLE(XMLSequence(extract(t.xmlcol,'/OMeS/PMSetup/PMMOResult'))) x;
  -- update table STATUS_PROCESS_ETL whith information the xml status 1:processed.
   update STATUS_PROCESS_ETL set status ='1' where filename = p_file_name;
    return_result := 1;
    return return_result;
    
  EXCEPTION
  WHEN OTHERS THEN
    raise_application_error(-20001,'An error has been found - '||SQLCODE||' -ERROR- '||SQLERRM);
  -- update table STATUS_PROCESS_ETL whith information the xml status 2: error processed.
   update STATUS_PROCESS_ETL set status ='2' where filename = p_file_name;
    return_result := 2;
    return return_result;
    COMMIT;    
END parser_M_MMDU_User_Level;

  /* parse xml with User_MME_Level measurement and load in a database */
FUNCTION parser_M_User_MME_Level(
    p_local_dir        IN VARCHAR2,
    p_file_name        IN VARCHAR2)
    RETURN INTEGER

IS
   return_result INTEGER;              -- 2: error procesed, 1: ok procesed
   
BEGIN
    
   

  INSERT INTO pcofns_ps_umlm_flexins_raw
    (FINS_ID,PERIOD_START_TIME,PERIOD_DURATION, EPS_ECM_CONN_MIN, EPS_ECM_CONN_MAX, EPS_ECM_IDLE_MIN, EPS_ECM_IDLE_MAX, EPS_EMM_REG_MIN,
    EPS_EMM_REG_MAX, EPS_EMM_DEREG_MIN, EPS_EMM_DEREG_MAX, EPS_ECM_CONN_SUM, EPS_ECM_CONN_DENOM, EPS_ECM_IDLE_SUM, EPS_ECM_IDLE_DENOM,
    PROVIDE_SUBS_LOCATION_SUCC, PROVIDE_SUBS_LOCATION_ABN_SUCC, PROVIDE_SUBS_LOCATION_ABN_FAIL, LOCATION_SERVICE_REQ_SUCC,
    LOCATION_SERVICE_REQ_FAIL, SRVCC_PS_AND_CS_HANDOVER_SUCC, SRVCC_CS_HANDOVER_SUCC, OVERLOAD_CONTROL_DROP_PROC,
    SRVCC_PS_AND_CS_HO_3G_FAIL, SRVCC_CS_HO_3G_FAIL, SRVCC_CS_HO_2G_SUCC, SRVCC_CS_HO_2G_FAIL, SRVCC_EME_HO_3G_SUCC, SRVCC_EME_HO_3G_FAIL,
    SRVCC_EME_HO_2G_SUCC, SRVCC_EME_HO_2G_FAIL, SRVCC_3G_CANCELLED, SRVCC_2G_CANCELLED, SRVCC_EME_3G_CANCELLED, SRVCC_EME_2G_CANCELLED,
    EPS_LICENSE_REG_FAIL, EPS_LICENSE_BEARER_FAIL, EPS_PURGE_HSS_OK_SUCC, EPS_PURGE_HSS_NOK_SUCC)
WITH t AS (SELECT xmltype(bfilename(p_local_dir,p_file_name), nls_charset_id('UTF-8')) xmlcol FROM dual)
SELECT
    (select INT_ID from multivendor_objects where OBJECT_NRO = substr(REGEXP_SUBSTR(extractValue(value(x),'/PMMOResult/MO/DN/text()'),'FLEXINS-[0-9]*'),9)) FINS_ID,
    TO_DATE(REGEXP_REPLACE(REGEXP_SUBSTR(extract(t.xmlcol, '/OMeS/PMSetup/@startTime'),'[0-9]*[-][0-9]*[-][0-9]*[^t][0-9]*[:][0-9]*[:][0-9]*'),'(T)', ' '),'YYYY-MM-DD HH24:MI:SS ') PERIOD_START_TIME,
    extract(t.xmlcol, '/OMeS/PMSetup/@interval').getNumberVal() PERIOD_DURATION,
    extractValue(value(x),'/PMMOResult/PMTarget/M53C000') EPS_ECM_CONN_MIN,
    extractValue(value(x),'/PMMOResult/PMTarget/M53C001') EPS_ECM_CONN_MAX,
    extractValue(value(x),'/PMMOResult/PMTarget/M53C002') EPS_ECM_IDLE_MIN,
    extractValue(value(x),'/PMMOResult/PMTarget/M53C003') EPS_ECM_IDLE_MAX,
    extractValue(value(x),'/PMMOResult/PMTarget/M53C004') EPS_EMM_REG_MIN,
    extractValue(value(x),'/PMMOResult/PMTarget/M53C005') EPS_EMM_REG_MAX,
    extractValue(value(x),'/PMMOResult/PMTarget/M53C006') EPS_EMM_DEREG_MIN,
    extractValue(value(x),'/PMMOResult/PMTarget/M53C007') EPS_EMM_DEREG_MAX,
    extractValue(value(x),'/PMMOResult/PMTarget/M53C008') EPS_ECM_CONN_SUM,
    extractValue(value(x),'/PMMOResult/PMTarget/M53C009') EPS_ECM_CONN_DENOM,
    extractValue(value(x),'/PMMOResult/PMTarget/M53C010') EPS_ECM_IDLE_SUM,
    extractValue(value(x),'/PMMOResult/PMTarget/M53C011') EPS_ECM_IDLE_DENOM,
    extractValue(value(x),'/PMMOResult/PMTarget/M53C012') PROVIDE_SUBS_LOCATION_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M53C013') PROVIDE_SUBS_LOCATION_ABN_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M53C014') PROVIDE_SUBS_LOCATION_ABN_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M53C015') LOCATION_SERVICE_REQ_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M53C016') LOCATION_SERVICE_REQ_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M53C017') SRVCC_PS_AND_CS_HANDOVER_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M53C018') SRVCC_CS_HANDOVER_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M53C019') OVERLOAD_CONTROL_DROP_PROC,
    extractValue(value(x),'/PMMOResult/PMTarget/M53C020') SRVCC_PS_AND_CS_HO_3G_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M53C021') SRVCC_CS_HO_3G_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M53C022') SRVCC_CS_HO_2G_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M53C023') SRVCC_CS_HO_2G_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M53C024') SRVCC_EME_HO_3G_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M53C025') SRVCC_EME_HO_3G_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M53C026') SRVCC_EME_HO_2G_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M53C027') SRVCC_EME_HO_2G_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M53C028') SRVCC_3G_CANCELLED,
    extractValue(value(x),'/PMMOResult/PMTarget/M53C029') SRVCC_2G_CANCELLED,
    extractValue(value(x),'/PMMOResult/PMTarget/M53C030') SRVCC_EME_3G_CANCELLED,
    extractValue(value(x),'/PMMOResult/PMTarget/M53C031') SRVCC_EME_2G_CANCELLED,
    extractValue(value(x),'/PMMOResult/PMTarget/M53C032') EPS_LICENSE_REG_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M53C033') EPS_LICENSE_BEARER_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M53C034') EPS_PURGE_HSS_OK_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M53C035') EPS_PURGE_HSS_NOK_SUCC
    
    FROM t,TABLE(XMLSequence(extract(t.xmlcol,'/OMeS/PMSetup/PMMOResult'))) x;
  -- update table STATUS_PROCESS_ETL whith information the xml status 1: processed.
   update STATUS_PROCESS_ETL set status ='1' where filename = p_file_name;
    return_result := 1;
    return return_result;
    
  EXCEPTION
  WHEN OTHERS THEN
    raise_application_error(-20001,'An error has been found - '||SQLCODE||' -ERROR- '||SQLERRM);
   -- update table STATUS_PROCESS_ETL whith information the xml status 2: error processed.
   update STATUS_PROCESS_ETL set status ='2' where filename = p_file_name;
    return_result := 2;
    return return_result;
    COMMIT;    
END parser_M_User_MME_Level;

  /* parse xml with SGsAPl measurement and load in a database */
FUNCTION parser_M_SGsAP(
    p_local_dir        IN VARCHAR2,
    p_file_name        IN VARCHAR2)
    RETURN INTEGER

IS
   return_result INTEGER;              -- 2: error procesed, 1: ok procesed
   
BEGIN
     
  INSERT INTO pcofns_ps_sgsm_flexins_raw
    (FINS_ID,PERIOD_START_TIME,PERIOD_DURATION,SGSAP_UPLINK_SUCC,SGSAP_UPLINK_FAIL,SGSAP_DOWNLINK_SUCC,SGSAP_DOWNLINK_FAIL,
    CSFB_PAGING_ATTEMPT,CSFB_PAGING_FAIL)
WITH t AS (SELECT xmltype(bfilename(p_local_dir,p_file_name), nls_charset_id('UTF-8')) xmlcol FROM dual)
SELECT
    (select INT_ID from multivendor_objects where OBJECT_NRO = substr(REGEXP_SUBSTR(extractValue(value(x),'/PMMOResult/MO/DN/text()'),'FLEXINS-[0-9]*'),9)) FINS_ID,
    TO_DATE(REGEXP_REPLACE(REGEXP_SUBSTR(extract(t.xmlcol, '/OMeS/PMSetup/@startTime'),'[0-9]*[-][0-9]*[-][0-9]*[^t][0-9]*[:][0-9]*[:][0-9]*'),'(T)', ' '),'YYYY-MM-DD HH24:MI:SS ') PERIOD_START_TIME,
    extract(t.xmlcol, '/OMeS/PMSetup/@interval').getNumberVal() PERIOD_DURATION,
    extractValue(value(x),'/PMMOResult/PMTarget/M55C000') SGSAP_UPLINK_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M55C001') SGSAP_UPLINK_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M55C002') SGSAP_DOWNLINK_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M55C003') SGSAP_DOWNLINK_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M55C004') CSFB_PAGING_ATTEMPT,
    extractValue(value(x),'/PMMOResult/PMTarget/M55C005') CSFB_PAGING_FAIL
  
     FROM t,TABLE(XMLSequence(extract(t.xmlcol,'/OMeS/PMSetup/PMMOResult'))) x;
  -- update table STATUS_PROCESS_ETL whith information the xml status 1: processed.
   update STATUS_PROCESS_ETL set status ='1' where filename = p_file_name;
    return_result := 1;
    return return_result;
    
  EXCEPTION
  WHEN OTHERS THEN
    raise_application_error(-20001,'An error has been found - '||SQLCODE||' -ERROR- '||SQLERRM);
   -- update table STATUS_PROCESS_ETL whith information the xml status 2: error processed.
   update STATUS_PROCESS_ETL set status ='2' where filename = p_file_name;
    return_result := 2;
    return return_result;
  COMMIT;       
END parser_M_SGsAP;

  /* parse xml with Computer_Unit_Load measurement and load in a database */
FUNCTION parser_M_Computer_Unit_Load(
    p_local_dir        IN VARCHAR2,
    p_file_name        IN VARCHAR2)
    RETURN INTEGER

IS
   return_result INTEGER;              -- 2: error procesed, 1: ok procesed
   
BEGIN

  dbms_output.put_line ('entro a parser_M_Computer_Unit_Load');   
  INSERT INTO pcofns_ps_uload_unit1_raw
    (FINS_ID,UNIT_ID,PERIOD_START_TIME,PERIOD_DURATION,COMP_AVERAGE_LOAD,COMP_PEAK_LOAD_PERCENT,COMP_PEAK_LOAD_DATE,COMP_PEAK_LOAD_TIME)
WITH t AS (SELECT xmltype(bfilename(p_local_dir,p_file_name), nls_charset_id('UTF-8')) xmlcol FROM dual)
SELECT
    (select INT_ID from multivendor_objects where OBJECT_NRO = substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()').getStringVal(),'FLEXINS-[0-9]*'),9)) FINS_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()').getStringVal(),'UNIT-[A-Za-z0-9_]*'),6)  UNIT_ID,
    TO_DATE(REGEXP_REPLACE(REGEXP_SUBSTR(extract(t.xmlcol, '/OMeS/PMSetup/@startTime'),'[0-9]*[-][0-9]*[-][0-9]*[^t][0-9]*[:][0-9]*[:][0-9]*'),'(T)', ' '),'YYYY-MM-DD HH24:MI:SS ') PERIOD_START_TIME,
    extract(t.xmlcol, '/OMeS/PMSetup/@interval').getNumberVal() PERIOD_DURATION,
    extractValue(value(x),'/PMMOResult/PMTarget/M592B2C1') COMP_AVERAGE_LOAD,
    extractValue(value(x),'/PMMOResult/PMTarget/M592B2C2') COMP_PEAK_LOAD_PERCENT,
    extractValue(value(x),'/PMMOResult/PMTarget/M592B2C3') COMP_PEAK_LOAD_DATE,
    extractValue(value(x),'/PMMOResult/PMTarget/M592B2C4') COMP_PEAK_LOAD_TIME
  
     FROM t,TABLE(XMLSequence(extract(t.xmlcol,'/OMeS/PMSetup/PMMOResult'))) x;
    -- update table STATUS_PROCESS_ETL whith information the xml status 1: processed.
   update STATUS_PROCESS_ETL set status ='1' where filename = p_file_name;   
   return_result := 1 ;
   return return_result;
  EXCEPTION
  WHEN OTHERS THEN
    raise_application_error(-20001,'An error has been found - '||SQLCODE||' -ERROR- '||SQLERRM);
    -- update table STATUS_PROCESS_ETL whith information the xml status 2: error processed.
    update STATUS_PROCESS_ETL set status ='2' where filename = p_file_name; 
    return_result := 2 ;
   return return_result;
  COMMIT;
END parser_M_Computer_Unit_Load;


  /* parse xml with Network_Element_User measurement and load in a database 
FUNCTION parser_M_Network_Element_User(
    p_local_dir        IN VARCHAR2,
    p_file_name        IN VARCHAR2)
    RETURN INTEGER

IS
   return_result INTEGER;              -- 2: error procesed, 1: ok procesed
   
BEGIN
    
   

  INSERT INTO pcofns_ps_neum_flexins_raw
    (FINS_ID,PERIOD_START_TIME,PERIOD_DURATION,NS_ATTACHED_USERS_MAX,NS_ATTACHED_USERS_SUM,NS_ATTACHED_USERS_DEN,NS_ROAMING_USERS_MAX,
    NS_ROAMING_USERS_SUM,NS_ROAMING_USERS_DEN,NS_DETACHED_USERS_MAX,NS_DETACHED_USERS_SUM,NS_DETACHED_USERS_DEN,NS_PURGE_ATTEMPT)
WITH t AS (SELECT xmltype(bfilename(p_local_dir,p_file_name), nls_charset_id('UTF-8')) xmlcol FROM dual)
SELECT
    (select INT_ID from multivendor_objects where OBJECT_NRO = substr(REGEXP_SUBSTR(extractValue(value(x),'/PMMOResult/MO/DN/text()'),'FLEXINS-[0-9]*'),9)) FINS_ID,
    TO_DATE(REGEXP_REPLACE(REGEXP_SUBSTR(extract(t.xmlcol, '/OMeS/PMSetup/@startTime'),'[0-9]*[-][0-9]*[-][0-9]*[^t][0-9]*[:][0-9]*[:][0-9]*'),'(T)', ' '),'YYYY-MM-DD HH24:MI:SS ') PERIOD_START_TIME,
    extract(t.xmlcol, '/OMeS/PMSetup/@interval').getNumberVal() PERIOD_DURATION,
    extractValue(value(x),'/PMMOResult/PMTarget/M67C000') NS_ATTACHED_USERS_MAX,
    extractValue(value(x),'/PMMOResult/PMTarget/M67C001') NS_ATTACHED_USERS_SUM,
    extractValue(value(x),'/PMMOResult/PMTarget/M67C002') NS_ATTACHED_USERS_DEN,
    extractValue(value(x),'/PMMOResult/PMTarget/M67C003') NS_ROAMING_USERS_MAX,
    extractValue(value(x),'/PMMOResult/PMTarget/M67C004') NS_ROAMING_USERS_SUM,
    extractValue(value(x),'/PMMOResult/PMTarget/M67C005') NS_ROAMING_USERS_DEN,
    extractValue(value(x),'/PMMOResult/PMTarget/M67C006') NS_DETACHED_USERS_MAX,
    extractValue(value(x),'/PMMOResult/PMTarget/M67C007') NS_DETACHED_USERS_SUM,
    extractValue(value(x),'/PMMOResult/PMTarget/M67C008') NS_DETACHED_USERS_DEN,
    extractValue(value(x),'/PMMOResult/PMTarget/M67C009') NS_PURGE_ATTEMPT
  
     FROM t,TABLE(XMLSequence(extract(t.xmlcol,'/OMeS/PMSetup/PMMOResult'))) x;
    return_result := 1;
    return return_result;
    
  EXCEPTION
  WHEN OTHERS THEN
    raise_application_error(-20001,'An error has been found - '||SQLCODE||' -ERROR- '||SQLERRM);
    return_result := 2;
    return return_result;    
END parser_M_Network_Element_User; */


    /*
  ***************************************************************************
  Overview : Package for performing parse and load  operations -LTE EnodeB
  *************************************************************************** 
  
  /* parse xml with LTE_Cell_Throughput measurement and load in a database  */
FUNCTION parser_LTE_Cell_Throughput(
    p_local_dir        IN VARCHAR2,
    p_file_name        IN VARCHAR2)
    RETURN INTEGER
IS
   return_result INTEGER;              -- 2: error procesed, 1: ok procesed   
BEGIN
     
   
 INSERT INTO noklte_ps_lcellt_mnc1_raw
 (INT_ID,CO_NAME,PERIOD_START_TIME,PERIOD_DURATION,PERIOD_DURATION_SUM,MRBTS_ID,LNBTS_ID,LNCEL_ID,MCC_ID,MNC_ID,
  RLC_SDU_VOL_DL_DCCH,RLC_SDU_VOL_UL_DCCH,RLC_PDU_VOL_RECEIVED,RLC_PDU_VOL_TRANSMITTED,PDCP_SDU_VOL_UL,PDCP_SDU_VOL_DL,
  PDCP_DATA_RATE_MIN_UL,PDCP_DATA_RATE_MAX_UL,PDCP_DATA_RATE_MEAN_UL,PDCP_DATA_RATE_MIN_DL,PDCP_DATA_RATE_MAX_DL,
  PDCP_DATA_RATE_MEAN_DL,TB_VOL_PDSCH_MCS0,TB_VOL_PDSCH_MCS1,TB_VOL_PDSCH_MCS2,TB_VOL_PDSCH_MCS3,TB_VOL_PDSCH_MCS4,
  TB_VOL_PDSCH_MCS5,TB_VOL_PDSCH_MCS6,TB_VOL_PDSCH_MCS7,TB_VOL_PDSCH_MCS8,TB_VOL_PDSCH_MCS9,TB_VOL_PDSCH_MCS10,
  TB_VOL_PDSCH_MCS11,TB_VOL_PDSCH_MCS12,TB_VOL_PDSCH_MCS13,TB_VOL_PDSCH_MCS14,TB_VOL_PDSCH_MCS15,
  TB_VOL_PDSCH_MCS16,TB_VOL_PDSCH_MCS17,TB_VOL_PDSCH_MCS18,TB_VOL_PDSCH_MCS19,TB_VOL_PDSCH_MCS20,TB_VOL_PUSCH_MCS0,
  TB_VOL_PUSCH_MCS1,TB_VOL_PUSCH_MCS2,TB_VOL_PUSCH_MCS3,TB_VOL_PUSCH_MCS4,TB_VOL_PUSCH_MCS5,TB_VOL_PUSCH_MCS6,
  TB_VOL_PUSCH_MCS7,TB_VOL_PUSCH_MCS8,TB_VOL_PUSCH_MCS9,TB_VOL_PUSCH_MCS10,TB_VOL_PUSCH_MCS11,TB_VOL_PUSCH_MCS12,
  TB_VOL_PUSCH_MCS13,TB_VOL_PUSCH_MCS14,TB_VOL_PUSCH_MCS15,TB_VOL_PUSCH_MCS16,TB_VOL_PUSCH_MCS17,TB_VOL_PUSCH_MCS18,
  TB_VOL_PUSCH_MCS19,TB_VOL_PUSCH_MCS20,MAC_SDU_VOL_UL_CCCH,MAC_SDU_VOL_UL_DCCH,MAC_SDU_VOL_UL_DTCH,MAC_SDU_VOL_DL_CCCH,
  MAC_SDU_VOL_DL_DCCH,MAC_SDU_VOL_DL_DTCH,RRC_UL_VOL,RRC_DL_VOL,RLC_SDU_VOL_UL_DTCH,RLC_SDU_VOL_DL_DTCH,TB_VOL_PDSCH_MCS21,
  TB_VOL_PDSCH_MCS22,TB_VOL_PDSCH_MCS23,TB_VOL_PDSCH_MCS24,TB_VOL_PDSCH_MCS25,TB_VOL_PDSCH_MCS26,TB_VOL_PDSCH_MCS27,TB_VOL_PDSCH_MCS28,
  VOL_ORIG_TRANS_DL_SCH_TB,VOL_RE_REC_UL_SCH_TB,VOL_RE_TRANS_DL_SCH_TB,VOL_ORIG_REC_UL_SCH_TB,PDCP_DATA_RATE_MEAN_UL_QCI_1,
  PDCP_DATA_RATE_MEAN_DL_QCI_1,TB_VOL_PUSCH_MCS21,TB_VOL_PUSCH_MCS22,TB_VOL_PUSCH_MCS23,TB_VOL_PUSCH_MCS24,RLC_PDU_DL_VOL_CA_SCELL,
  ACTIVE_TTI_UL,ACTIVE_TTI_DL,IP_TPUT_VOL_UL_QCI_1,IP_TPUT_TIME_UL_QCI_1,IP_TPUT_VOL_UL_QCI_2,IP_TPUT_TIME_UL_QCI_2,
  IP_TPUT_VOL_UL_QCI_3,IP_TPUT_TIME_UL_QCI_3,IP_TPUT_VOL_UL_QCI_4,IP_TPUT_TIME_UL_QCI_4,IP_TPUT_VOL_UL_QCI_5,IP_TPUT_TIME_UL_QCI_5,
  IP_TPUT_VOL_UL_QCI_6,IP_TPUT_TIME_UL_QCI_6,IP_TPUT_VOL_UL_QCI_7,IP_TPUT_TIME_UL_QCI_7,IP_TPUT_VOL_UL_QCI_8,IP_TPUT_TIME_UL_QCI_8,IP_TPUT_VOL_UL_QCI_9,
  IP_TPUT_TIME_UL_QCI_9,IP_TPUT_VOL_DL_QCI_1,IP_TPUT_TIME_DL_QCI_1,IP_TPUT_VOL_DL_QCI_2,IP_TPUT_TIME_DL_QCI_2,IP_TPUT_VOL_DL_QCI_3,
  IP_TPUT_TIME_DL_QCI_3,IP_TPUT_VOL_DL_QCI_4,IP_TPUT_TIME_DL_QCI_4,IP_TPUT_VOL_DL_QCI_5,IP_TPUT_TIME_DL_QCI_5,IP_TPUT_VOL_DL_QCI_6,
  IP_TPUT_TIME_DL_QCI_6,IP_TPUT_VOL_DL_QCI_7,IP_TPUT_TIME_DL_QCI_7,IP_TPUT_VOL_DL_QCI_8,IP_TPUT_TIME_DL_QCI_8,IP_TPUT_VOL_DL_QCI_9,
  IP_TPUT_TIME_DL_QCI_9)
WITH t AS (SELECT xmltype(bfilename(p_local_dir,p_file_name), nls_charset_id('AL32UTF8')) xmlcol FROM dual)
SELECT
    (select INT_ID from MULTIVENDOR_OBJECTS where OBJECT_CLASS = 3130 and OBJECT_NRO = substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNCEL-[0-9]*'),7)) INT_ID,
    (select NAME from multivendor_objects where OBJECT_CLASS = 3130 and OBJECT_NRO = substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNCEL-[0-9]*'),7)) CO_NAME,
    TO_DATE(REGEXP_REPLACE(REGEXP_SUBSTR(extract(t.xmlcol, '//@startTime','xmlns="pm/cnf_lte_nsn.1.0.xsd"'),'[0-9]*[-][0-9]*[-][0-9]*[^t][0-9]*[:][0-9]*[:][0-9]*'),'(T)', ' '),'YYYY-MM-DD HH24:MI:SS ') PERIOD_START_TIME,
    extract(t.xmlcol, '//@interval','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getNumberVal() PERIOD_DURATION,
    extract(t.xmlcol, '//@interval','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getNumberVal() PERIOD_DURATION_SUM,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'MRBTS-[0-9]*'),7) MRBTS_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNBTS-[0-9]*'),7) LNBTS_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNCEL-[0-9]*'),7) LNCEL_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'MCC-[0-9]*'),5) MCC_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'MNC-[0-9]*'),5) MNC_ID,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C12','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RLC_SDU_VOL_DL_DCCH,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C16','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RLC_SDU_VOL_UL_DCCH,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C17','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RLC_PDU_VOL_RECEIVED,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C18','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RLC_PDU_VOL_TRANSMITTED,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C19','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCP_SDU_VOL_UL,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C20','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCP_SDU_VOL_DL,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C21','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCP_DATA_RATE_MIN_UL,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C22','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCP_DATA_RATE_MAX_UL,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C23','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCP_DATA_RATE_MEAN_UL,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C24','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCP_DATA_RATE_MIN_DL,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C25','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCP_DATA_RATE_MAX_DL,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C26','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCP_DATA_RATE_MEAN_DL,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C27','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PDSCH_MCS0,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C28','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PDSCH_MCS1,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C29','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PDSCH_MCS2,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C30','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PDSCH_MCS3,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C31','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PDSCH_MCS4,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C32','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PDSCH_MCS5,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C33','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PDSCH_MCS6,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C34','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PDSCH_MCS7,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C35','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PDSCH_MCS8,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C36','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PDSCH_MCS9, 
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C37','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PDSCH_MCS10,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C38','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PDSCH_MCS11,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C39','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PDSCH_MCS12,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C40','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PDSCH_MCS13,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C41','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PDSCH_MCS14,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C42','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PDSCH_MCS15,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C43','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PDSCH_MCS16,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C44','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PDSCH_MCS17,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C45','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PDSCH_MCS18,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C46','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PDSCH_MCS19,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C47','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PDSCH_MCS20,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C48','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PUSCH_MCS0,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C49','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PUSCH_MCS1,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C50','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PUSCH_MCS2,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C51','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PUSCH_MCS3,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C52','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PUSCH_MCS4,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C53','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PUSCH_MCS5,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C54','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PUSCH_MCS6,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C55','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PUSCH_MCS7,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C56','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PUSCH_MCS8,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C57','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PUSCH_MCS9,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C58','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PUSCH_MCS10,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C59','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PUSCH_MCS11,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C60','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PUSCH_MCS12,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C61','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PUSCH_MCS13,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C62','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PUSCH_MCS14,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C63','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PUSCH_MCS15,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C64','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PUSCH_MCS16,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C65','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PUSCH_MCS17,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C66','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PUSCH_MCS18,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C67','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PUSCH_MCS19,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C68','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PUSCH_MCS20,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C69','xmlns="pm/cnf_lte_nsn.1.0.xsd"') MAC_SDU_VOL_UL_CCCH,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C70','xmlns="pm/cnf_lte_nsn.1.0.xsd"') MAC_SDU_VOL_UL_DCCH,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C71','xmlns="pm/cnf_lte_nsn.1.0.xsd"') MAC_SDU_VOL_UL_DTCH,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C74','xmlns="pm/cnf_lte_nsn.1.0.xsd"') MAC_SDU_VOL_DL_CCCH,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C75','xmlns="pm/cnf_lte_nsn.1.0.xsd"') MAC_SDU_VOL_DL_DCCH,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C76','xmlns="pm/cnf_lte_nsn.1.0.xsd"') MAC_SDU_VOL_DL_DTCH,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C77','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RRC_UL_VOL,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C78','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RRC_DL_VOL,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C79','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RLC_SDU_VOL_UL_DTCH,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C80','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RLC_SDU_VOL_DL_DTCH,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C81','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PDSCH_MCS21,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C82','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PDSCH_MCS22,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C83','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PDSCH_MCS23,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C84','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PDSCH_MCS24,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C85','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PDSCH_MCS25,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C86','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PDSCH_MCS26,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C87','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PDSCH_MCS27,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C88','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PDSCH_MCS28,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C0','xmlns="pm/cnf_lte_nsn.1.0.xsd"') VOL_ORIG_TRANS_DL_SCH_TB,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C1','xmlns="pm/cnf_lte_nsn.1.0.xsd"') VOL_RE_REC_UL_SCH_TB,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C2','xmlns="pm/cnf_lte_nsn.1.0.xsd"') VOL_RE_TRANS_DL_SCH_TB,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C3','xmlns="pm/cnf_lte_nsn.1.0.xsd"') VOL_ORIG_REC_UL_SCH_TB,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C116','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCP_DATA_RATE_MEAN_UL_QCI_1,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C143','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCP_DATA_RATE_MEAN_DL_QCI_1,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C144','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PUSCH_MCS21,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C145','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PUSCH_MCS22,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C146','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PUSCH_MCS23,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C147','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_VOL_PUSCH_MCS24,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C151','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RLC_PDU_DL_VOL_CA_SCELL,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C89','xmlns="pm/cnf_lte_nsn.1.0.xsd"') ACTIVE_TTI_UL,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C90','xmlns="pm/cnf_lte_nsn.1.0.xsd"') ACTIVE_TTI_DL,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C91','xmlns="pm/cnf_lte_nsn.1.0.xsd"') IP_TPUT_VOL_UL_QCI_1,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C92','xmlns="pm/cnf_lte_nsn.1.0.xsd"') IP_TPUT_TIME_UL_QCI_1,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C93','xmlns="pm/cnf_lte_nsn.1.0.xsd"') IP_TPUT_VOL_UL_QCI_2,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C94','xmlns="pm/cnf_lte_nsn.1.0.xsd"') IP_TPUT_TIME_UL_QCI_2,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C95','xmlns="pm/cnf_lte_nsn.1.0.xsd"') IP_TPUT_VOL_UL_QCI_3,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C96','xmlns="pm/cnf_lte_nsn.1.0.xsd"') IP_TPUT_TIME_UL_QCI_3,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C97','xmlns="pm/cnf_lte_nsn.1.0.xsd"') IP_TPUT_VOL_UL_QCI_4,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C98','xmlns="pm/cnf_lte_nsn.1.0.xsd"') IP_TPUT_TIME_UL_QCI_4,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C99','xmlns="pm/cnf_lte_nsn.1.0.xsd"') IP_TPUT_VOL_UL_QCI_5,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C100','xmlns="pm/cnf_lte_nsn.1.0.xsd"') IP_TPUT_TIME_UL_QCI_5,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C101','xmlns="pm/cnf_lte_nsn.1.0.xsd"') IP_TPUT_VOL_UL_QCI_6,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C102','xmlns="pm/cnf_lte_nsn.1.0.xsd"') IP_TPUT_TIME_UL_QCI_6,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C103','xmlns="pm/cnf_lte_nsn.1.0.xsd"') IP_TPUT_VOL_UL_QCI_7,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C104','xmlns="pm/cnf_lte_nsn.1.0.xsd"') IP_TPUT_TIME_UL_QCI_7,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C105','xmlns="pm/cnf_lte_nsn.1.0.xsd"') IP_TPUT_VOL_UL_QCI_8,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C106','xmlns="pm/cnf_lte_nsn.1.0.xsd"') IP_TPUT_TIME_UL_QCI_8,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C107','xmlns="pm/cnf_lte_nsn.1.0.xsd"') IP_TPUT_VOL_UL_QCI_9,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C108','xmlns="pm/cnf_lte_nsn.1.0.xsd"') IP_TPUT_TIME_UL_QCI_9,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C117','xmlns="pm/cnf_lte_nsn.1.0.xsd"') IP_TPUT_VOL_DL_QCI_1,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C118','xmlns="pm/cnf_lte_nsn.1.0.xsd"') IP_TPUT_TIME_DL_QCI_1,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C119','xmlns="pm/cnf_lte_nsn.1.0.xsd"') IP_TPUT_VOL_DL_QCI_2,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C120','xmlns="pm/cnf_lte_nsn.1.0.xsd"') IP_TPUT_TIME_DL_QCI_2,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C121','xmlns="pm/cnf_lte_nsn.1.0.xsd"') IP_TPUT_VOL_DL_QCI_3,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C122','xmlns="pm/cnf_lte_nsn.1.0.xsd"') IP_TPUT_TIME_DL_QCI_3,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C123','xmlns="pm/cnf_lte_nsn.1.0.xsd"') IP_TPUT_VOL_DL_QCI_4,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C124','xmlns="pm/cnf_lte_nsn.1.0.xsd"') IP_TPUT_TIME_DL_QCI_4,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C125','xmlns="pm/cnf_lte_nsn.1.0.xsd"') IP_TPUT_VOL_DL_QCI_5,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C126','xmlns="pm/cnf_lte_nsn.1.0.xsd"') IP_TPUT_TIME_DL_QCI_5,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C127','xmlns="pm/cnf_lte_nsn.1.0.xsd"') IP_TPUT_VOL_DL_QCI_6,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C128','xmlns="pm/cnf_lte_nsn.1.0.xsd"') IP_TPUT_TIME_DL_QCI_6,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C129','xmlns="pm/cnf_lte_nsn.1.0.xsd"') IP_TPUT_VOL_DL_QCI_7,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C130','xmlns="pm/cnf_lte_nsn.1.0.xsd"') IP_TPUT_TIME_DL_QCI_7,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C131','xmlns="pm/cnf_lte_nsn.1.0.xsd"') IP_TPUT_VOL_DL_QCI_8,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C132','xmlns="pm/cnf_lte_nsn.1.0.xsd"') IP_TPUT_TIME_DL_QCI_8,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C133','xmlns="pm/cnf_lte_nsn.1.0.xsd"') IP_TPUT_VOL_DL_QCI_9,
    extractValue(value(x),'/PMMOResult/PMTarget/M8012C134','xmlns="pm/cnf_lte_nsn.1.0.xsd"') IP_TPUT_TIME_DL_QCI_9
    
     FROM t,TABLE(XMLSequence(extract(t.xmlcol,'/OMeS/PMSetup/PMMOResult','xmlns="pm/cnf_lte_nsn.1.0.xsd"'))) x;
    
    -- update table STATUS_PROCESS_ETL whith information the xml status 1: processed.
   update STATUS_PROCESS_ETL set status ='1' where filename = p_file_name;   
   return_result := 1 ;
   return return_result;
  
   EXCEPTION
  WHEN OTHERS THEN
    raise_application_error(-20001,'An error has been found - '||SQLCODE||' -ERROR- '||SQLERRM);
    -- update table STATUS_PROCESS_ETL whith information the xml status 2: error processed.
   update STATUS_PROCESS_ETL set status ='2' where filename = p_file_name;   
   return_result := 2 ;
   return return_result;
  COMMIT;    
END parser_LTE_Cell_Throughput;

  /* parse xml with LTE_S1AP measurement and load in a database  */
FUNCTION parser_LTE_S1AP(
    p_local_dir        IN VARCHAR2,
    p_file_name        IN VARCHAR2)
    RETURN INTEGER
IS
   return_result INTEGER;              -- 2: error procesed, 1: ok procesed   
BEGIN
     
   
 INSERT INTO noklte_ps_ls1ap_lnbts_raw
 (INT_ID,CO_NAME,MRBTS_ID,LNBTS_ID,PERIOD_START_TIME,PERIOD_DURATION,PERIOD_DURATION_SUM,INI_CONT_STP_REQ,INI_CONT_STP_COMP,
 INI_CONT_STP_FAIL_RNL,INI_CONT_STP_FAIL_TRPORT,INI_CONT_STP_FAIL_RESOUR,INI_CONT_STP_FAIL_OTHER,S1_SETUP_ATT,S1_SETUP_SUCC,
 S1_SETUP_FAIL_NO_RESP,S1_SETUP_FAIL_IND_BY_MME,S1_PAGING,UE_LOG_S1_SETUP,UE_CONTEXT_MOD_ATT,
 UE_CONTEXT_MOD_ATT_AMBR,UE_CONTEXT_MOD_FAIL,E_RAB_SETUP_ATT_EMG,E_RAB_SETUP_SUCC_EMG,S1AP_NAS_UPLINK,S1AP_NAS_DOWNLINK,
 UE_CONTEXT_MOD_ATT_CSFB,S1AP_GLOBAL_RESET_INIT_ENB,S1AP_GLOBAL_RESET_INIT_MME,S1AP_PARTIAL_RESET_INIT_ENB,
 S1AP_PARTIAL_RESET_INIT_MME,E_RAB_SETUP_FAIL_RB_EMG,S1AP_LCS_REP_CTRL,S1AP_LCS_REP,X2_IP_RETR_VIA_S1_SUCC,
 X2_IP_RETR_VIA_S1_ATT,S1AP_WRITE_REP_WARN_REQ,S1AP_WRITE_REP_WARN_RESP,S1AP_KILL_REQ,S1AP_KILL_RESP)
 
 
WITH t AS (SELECT xmltype(bfilename(p_local_dir,p_file_name), nls_charset_id('AL32UTF8')) xmlcol FROM dual)
SELECT
    (select INT_ID from MULTIVENDOR_OBJECTS where OBJECT_CLASS = 3129 and OBJECT_NRO = substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNBTS-[0-9]*'),7)) INT_ID,
    (select NAME from multivendor_objects where OBJECT_CLASS = 3129 and OBJECT_NRO = substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNBTS-[0-9]*'),7)) CO_NAME,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'MRBTS-[0-9]*'),7) MRBTS_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNBTS-[0-9]*'),7) LNBTS_ID,
    TO_DATE(REGEXP_REPLACE(REGEXP_SUBSTR(extract(t.xmlcol, '//@startTime','xmlns="pm/cnf_lte_nsn.1.0.xsd"'),'[0-9]*[-][0-9]*[-][0-9]*[^t][0-9]*[:][0-9]*[:][0-9]*'),'(T)', ' '),'YYYY-MM-DD HH24:MI:SS ') PERIOD_START_TIME,
    extract(t.xmlcol, '//@interval','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getNumberVal() PERIOD_DURATION,
    extract(t.xmlcol, '//@interval','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getNumberVal() PERIOD_DURATION_SUM,


    extractValue(value(x),'/PMMOResult/PMTarget/M8000C0','xmlns="pm/cnf_lte_nsn.1.0.xsd"') INI_CONT_STP_REQ,
    extractValue(value(x),'/PMMOResult/PMTarget/M8000C1','xmlns="pm/cnf_lte_nsn.1.0.xsd"') INI_CONT_STP_COMP,
    extractValue(value(x),'/PMMOResult/PMTarget/M8000C2','xmlns="pm/cnf_lte_nsn.1.0.xsd"') INI_CONT_STP_FAIL_RNL,
    extractValue(value(x),'/PMMOResult/PMTarget/M8000C3','xmlns="pm/cnf_lte_nsn.1.0.xsd"') INI_CONT_STP_FAIL_TRPORT,
    extractValue(value(x),'/PMMOResult/PMTarget/M8000C4','xmlns="pm/cnf_lte_nsn.1.0.xsd"') INI_CONT_STP_FAIL_RESOUR,
    extractValue(value(x),'/PMMOResult/PMTarget/M8000C5','xmlns="pm/cnf_lte_nsn.1.0.xsd"') INI_CONT_STP_FAIL_OTHER,
    extractValue(value(x),'/PMMOResult/PMTarget/M8000C6','xmlns="pm/cnf_lte_nsn.1.0.xsd"') S1_SETUP_ATT,
    extractValue(value(x),'/PMMOResult/PMTarget/M8000C7','xmlns="pm/cnf_lte_nsn.1.0.xsd"') S1_SETUP_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M8000C8','xmlns="pm/cnf_lte_nsn.1.0.xsd"') S1_SETUP_FAIL_NO_RESP,
    extractValue(value(x),'/PMMOResult/PMTarget/M8000C9','xmlns="pm/cnf_lte_nsn.1.0.xsd"') S1_SETUP_FAIL_IND_BY_MME,
    extractValue(value(x),'/PMMOResult/PMTarget/M8000C11','xmlns="pm/cnf_lte_nsn.1.0.xsd"') S1_PAGING,
    extractValue(value(x),'/PMMOResult/PMTarget/M8000C12','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_LOG_S1_SETUP,
    extractValue(value(x),'/PMMOResult/PMTarget/M8000C23','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_CONTEXT_MOD_ATT,
    extractValue(value(x),'/PMMOResult/PMTarget/M8000C24','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_CONTEXT_MOD_ATT_AMBR,
    extractValue(value(x),'/PMMOResult/PMTarget/M8000C24','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_CONTEXT_MOD_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M8000C32','xmlns="pm/cnf_lte_nsn.1.0.xsd"') E_RAB_SETUP_ATT_EMG,
    extractValue(value(x),'/PMMOResult/PMTarget/M8000C33','xmlns="pm/cnf_lte_nsn.1.0.xsd"') E_RAB_SETUP_SUCC_EMG,
    extractValue(value(x),'/PMMOResult/PMTarget/M8000C29','xmlns="pm/cnf_lte_nsn.1.0.xsd"') S1AP_NAS_UPLINK,
    extractValue(value(x),'/PMMOResult/PMTarget/M8000C30','xmlns="pm/cnf_lte_nsn.1.0.xsd"') S1AP_NAS_DOWNLINK,
    extractValue(value(x),'/PMMOResult/PMTarget/M8000C31','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_CONTEXT_MOD_ATT_CSFB,
    extractValue(value(x),'/PMMOResult/PMTarget/M8000C13','xmlns="pm/cnf_lte_nsn.1.0.xsd"') S1AP_GLOBAL_RESET_INIT_ENB,
    extractValue(value(x),'/PMMOResult/PMTarget/M8000C14','xmlns="pm/cnf_lte_nsn.1.0.xsd"') S1AP_GLOBAL_RESET_INIT_MME,
    extractValue(value(x),'/PMMOResult/PMTarget/M8000C15','xmlns="pm/cnf_lte_nsn.1.0.xsd"') S1AP_PARTIAL_RESET_INIT_ENB,
    extractValue(value(x),'/PMMOResult/PMTarget/M8000C16','xmlns="pm/cnf_lte_nsn.1.0.xsd"') S1AP_PARTIAL_RESET_INIT_MME,
    extractValue(value(x),'/PMMOResult/PMTarget/M8000C34','xmlns="pm/cnf_lte_nsn.1.0.xsd"') E_RAB_SETUP_FAIL_RB_EMG,
    extractValue(value(x),'/PMMOResult/PMTarget/M8000C35','xmlns="pm/cnf_lte_nsn.1.0.xsd"') S1AP_LCS_REP_CTRL,
    extractValue(value(x),'/PMMOResult/PMTarget/M8000C36','xmlns="pm/cnf_lte_nsn.1.0.xsd"') S1AP_LCS_REP,
    extractValue(value(x),'/PMMOResult/PMTarget/M8000C37','xmlns="pm/cnf_lte_nsn.1.0.xsd"') X2_IP_RETR_VIA_S1_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M8000C38','xmlns="pm/cnf_lte_nsn.1.0.xsd"') X2_IP_RETR_VIA_S1_ATT,
    extractValue(value(x),'/PMMOResult/PMTarget/M8000C39','xmlns="pm/cnf_lte_nsn.1.0.xsd"') S1AP_WRITE_REP_WARN_REQ,
    extractValue(value(x),'/PMMOResult/PMTarget/M8000C40','xmlns="pm/cnf_lte_nsn.1.0.xsd"') S1AP_WRITE_REP_WARN_RESP,
    extractValue(value(x),'/PMMOResult/PMTarget/M8000C41','xmlns="pm/cnf_lte_nsn.1.0.xsd"') S1AP_KILL_REQ,
    extractValue(value(x),'/PMMOResult/PMTarget/M8000C42','xmlns="pm/cnf_lte_nsn.1.0.xsd"') S1AP_KILL_RESP
  
     FROM t,TABLE(XMLSequence(extract(t.xmlcol,'/OMeS/PMSetup/PMMOResult','xmlns="pm/cnf_lte_nsn.1.0.xsd"'))) x;
    
    -- update table STATUS_PROCESS_ETL whith information the xml status 1: processed.
   update STATUS_PROCESS_ETL set status ='1' where filename = p_file_name;   
   return_result := 1 ;
   return return_result;
  
   EXCEPTION
  WHEN OTHERS THEN
    raise_application_error(-20001,'An error has been found - '||SQLCODE||' -ERROR- '||SQLERRM);
    -- update table STATUS_PROCESS_ETL whith information the xml status 2: error processed.
   update STATUS_PROCESS_ETL set status ='2' where filename = p_file_name;   
   return_result := 2 ;
   return return_result;
  COMMIT;    
END parser_LTE_S1AP;


  /* parse xml with LTE_UE_State measurement and load in a database*/
FUNCTION parser_LTE_UE_State(
    p_local_dir        IN VARCHAR2,
    p_file_name        IN VARCHAR2)
    RETURN INTEGER
IS
   return_result INTEGER;              -- 2: error procesed, 1: ok procesed   
BEGIN
    
   
 INSERT INTO noklte_ps_luest_mnc1_raw
 (INT_ID,CO_NAME,MRBTS_ID,LNBTS_ID,LNCEL_ID,MCC_ID,MNC_ID,PERIOD_START_TIME,PERIOD_DURATION,PERIOD_DURATION_SUM,SIGN_CONN_ESTAB_COMP,
 SIGN_EST_F_RRCCOMPL_MISSING,SIGN_EST_F_RRCCOMPL_ERROR,SIGN_CONN_ESTAB_FAIL_RRMRAC,EPC_INIT_TO_IDLE_UE_NORM_REL,EPC_INIT_TO_IDLE_DETACH,
 EPC_INIT_TO_IDLE_RNL,EPC_INIT_TO_IDLE_OTHER,ENB_INIT_TO_IDLE_NORM_REL,ENB_INIT_TO_IDLE_RNL,ENB_INIT_TO_IDLE_OTHER,SIGN_CONN_ESTAB_ATT_MO_S,
 SIGN_CONN_ESTAB_ATT_MT,SIGN_CONN_ESTAB_ATT_MO_D,SIGN_CONN_ESTAB_ATT_OTHERS,SIGN_CONN_ESTAB_ATT_EMG,SIGN_CONN_ESTAB_COMP_EMG,
 SIGN_CONN_ESTAB_FAIL_RB_EMG,SUBFRAME_DRX_ACTIVE_UE,SUBFRAME_DRX_SLEEP_UE,PRE_EMPT_UE_CONTEXT_NON_GBR)
 
 
WITH t AS (SELECT xmltype(bfilename(p_local_dir,p_file_name), nls_charset_id('AL32UTF8')) xmlcol FROM dual)
SELECT
    (select INT_ID from MULTIVENDOR_OBJECTS where OBJECT_CLASS = 3130 and OBJECT_NRO = substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNCEL-[0-9]*'),7)) INT_ID,
    (select NAME from multivendor_objects where OBJECT_CLASS = 3130 and OBJECT_NRO = substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNCEL-[0-9]*'),7)) CO_NAME,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'MRBTS-[0-9]*'),7) MRBTS_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNBTS-[0-9]*'),7) LNBTS_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNCEL-[0-9]*'),7) LNCEL_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'MCC-[0-9]*'),5) MCC_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'MNC-[0-9]*'),5) MNC_ID,
    TO_DATE(REGEXP_REPLACE(REGEXP_SUBSTR(extract(t.xmlcol, '//@startTime','xmlns="pm/cnf_lte_nsn.1.0.xsd"'),'[0-9]*[-][0-9]*[-][0-9]*[^t][0-9]*[:][0-9]*[:][0-9]*'),'(T)', ' '),'YYYY-MM-DD HH24:MI:SS ') PERIOD_START_TIME,
    extract(t.xmlcol, '//@interval','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getNumberVal() PERIOD_DURATION,
    extract(t.xmlcol, '//@interval','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getNumberVal() PERIOD_DURATION_SUM,
    extractValue(value(x),'/PMMOResult/PMTarget/M8013C5','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SIGN_CONN_ESTAB_COMP,
    extractValue(value(x),'/PMMOResult/PMTarget/M8013C6','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SIGN_EST_F_RRCCOMPL_MISSING,
    extractValue(value(x),'/PMMOResult/PMTarget/M8013C7','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SIGN_EST_F_RRCCOMPL_ERROR,
    extractValue(value(x),'/PMMOResult/PMTarget/M8013C8','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SIGN_CONN_ESTAB_FAIL_RRMRAC,
    extractValue(value(x),'/PMMOResult/PMTarget/M8013C9','xmlns="pm/cnf_lte_nsn.1.0.xsd"') EPC_INIT_TO_IDLE_UE_NORM_REL,
    extractValue(value(x),'/PMMOResult/PMTarget/M8013C10','xmlns="pm/cnf_lte_nsn.1.0.xsd"') EPC_INIT_TO_IDLE_DETACH,
    extractValue(value(x),'/PMMOResult/PMTarget/M8013C11','xmlns="pm/cnf_lte_nsn.1.0.xsd"') EPC_INIT_TO_IDLE_RNL,
    extractValue(value(x),'/PMMOResult/PMTarget/M8013C12','xmlns="pm/cnf_lte_nsn.1.0.xsd"') EPC_INIT_TO_IDLE_OTHER,
    extractValue(value(x),'/PMMOResult/PMTarget/M8013C13','xmlns="pm/cnf_lte_nsn.1.0.xsd"') ENB_INIT_TO_IDLE_NORM_REL,
    extractValue(value(x),'/PMMOResult/PMTarget/M8013C15','xmlns="pm/cnf_lte_nsn.1.0.xsd"') ENB_INIT_TO_IDLE_RNL,
    extractValue(value(x),'/PMMOResult/PMTarget/M8013C16','xmlns="pm/cnf_lte_nsn.1.0.xsd"') ENB_INIT_TO_IDLE_OTHER,
    extractValue(value(x),'/PMMOResult/PMTarget/M8013C17','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SIGN_CONN_ESTAB_ATT_MO_S,
    extractValue(value(x),'/PMMOResult/PMTarget/M8013C18','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SIGN_CONN_ESTAB_ATT_MT,
    extractValue(value(x),'/PMMOResult/PMTarget/M8013C19','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SIGN_CONN_ESTAB_ATT_MO_D,
    extractValue(value(x),'/PMMOResult/PMTarget/M8013C20','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SIGN_CONN_ESTAB_ATT_OTHERS,
    extractValue(value(x),'/PMMOResult/PMTarget/M8013C21','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SIGN_CONN_ESTAB_ATT_EMG,
    extractValue(value(x),'/PMMOResult/PMTarget/M8013C26','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SIGN_CONN_ESTAB_COMP_EMG,
    extractValue(value(x),'/PMMOResult/PMTarget/M8013C27','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SIGN_CONN_ESTAB_FAIL_RB_EMG,
    extractValue(value(x),'/PMMOResult/PMTarget/M8013C24','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SUBFRAME_DRX_ACTIVE_UE,
    extractValue(value(x),'/PMMOResult/PMTarget/M8013C25','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SUBFRAME_DRX_SLEEP_UE,
    extractValue(value(x),'/PMMOResult/PMTarget/M8013C28','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PRE_EMPT_UE_CONTEXT_NON_GBR
  
     FROM t,TABLE(XMLSequence(extract(t.xmlcol,'/OMeS/PMSetup/PMMOResult','xmlns="pm/cnf_lte_nsn.1.0.xsd"'))) x;
    
    -- update table STATUS_PROCESS_ETL whith information the xml status 1: processed.
   update STATUS_PROCESS_ETL set status ='1' where filename = p_file_name;   
   return_result := 1 ;
   return return_result;
  
   EXCEPTION
  WHEN OTHERS THEN
    raise_application_error(-20001,'An error has been found - '||SQLCODE||' -ERROR- '||SQLERRM);
    -- update table STATUS_PROCESS_ETL whith information the xml status 2: error processed.
   update STATUS_PROCESS_ETL set status ='2' where filename = p_file_name;   
   return_result := 2 ;
   return return_result;
  COMMIT;    
END parser_LTE_UE_State;


  /* parse xml with LTE_S1AP measurement and load in a database  */
FUNCTION parser_LTE_Cell_LoadP(
    p_local_dir        IN VARCHAR2,
    p_file_name        IN VARCHAR2)
    RETURN INTEGER
IS
   return_result INTEGER;              -- 2: error procesed, 1: ok procesed   
BEGIN

   
 INSERT INTO NOKLTE_PS_LCELLD_MNC1_RAW
 (INT_ID,CO_NAME,MRBTS_ID,LNBTS_ID,LNCEL_ID, MCC_ID, MNC_ID, PERIOD_START_TIME,PERIOD_DURATION,PERIOD_DURATION_SUM,
  PDCP_SDU_DELAY_DL_DTCH_MIN, PDCP_SDU_DELAY_DL_DTCH_MAX, PDCP_SDU_DELAY_DL_DTCH_MEAN, PDCP_SDU_DELAY_UL_DTCH_MIN, 
  PDCP_SDU_DELAY_UL_DTCH_MAX, PDCP_SDU_DELAY_UL_DTCH_MEAN, RACH_STP_ATT_SMALL_MSG, RACH_STP_ATT_LARGE_MSG, RACH_STP_COMPLETIONS, 
  TRANSMIT_TB_ON_PCH, TRANSMIT_TB_ON_BCH, TRANSMIT_TB_ON_DL_SCH, HARQ_RETRANS_ON_DL_SCH, CORR_NON_DUPL_UL_SCH_TB, 
  CORR_UL_SCH_TB_RE_RECEPT, INCORR_UL_SCH_TB_RECEPT, PUSCH_TRANS_USING_MCS0, PUSCH_TRANS_USING_MCS1, PUSCH_TRANS_USING_MCS2, 
  PUSCH_TRANS_USING_MCS3, PUSCH_TRANS_USING_MCS4, PUSCH_TRANS_USING_MCS5, PUSCH_TRANS_USING_MCS6, PUSCH_TRANS_USING_MCS7, 
  PUSCH_TRANS_USING_MCS8, PUSCH_TRANS_USING_MCS9, PUSCH_TRANS_USING_MCS10, PUSCH_TRANS_USING_MCS11, PUSCH_TRANS_USING_MCS12, 
  PUSCH_TRANS_USING_MCS13, PUSCH_TRANS_USING_MCS14, PUSCH_TRANS_USING_MCS15, PUSCH_TRANS_USING_MCS16, PUSCH_TRANS_USING_MCS17, 
  PUSCH_TRANS_USING_MCS18, PUSCH_TRANS_USING_MCS19, PUSCH_TRANS_USING_MCS20, PUSCH_TRANS_USING_MCS21, PUSCH_TRANS_USING_MCS22, 
  PUSCH_TRANS_USING_MCS23, PUSCH_TRANS_USING_MCS24, PUSCH_TRANS_USING_MCS25, PUSCH_TRANS_USING_MCS26, PUSCH_TRANS_USING_MCS27, 
  PUSCH_TRANS_USING_MCS28, PDSCH_TRANS_USING_MCS0, PDSCH_TRANS_USING_MCS1, PDSCH_TRANS_USING_MCS2, PDSCH_TRANS_USING_MCS3, 
  PDSCH_TRANS_USING_MCS4, PDSCH_TRANS_USING_MCS5, PDSCH_TRANS_USING_MCS6, PDSCH_TRANS_USING_MCS7, PDSCH_TRANS_USING_MCS8, 
  PDSCH_TRANS_USING_MCS9, PDSCH_TRANS_USING_MCS10, PDSCH_TRANS_USING_MCS11, PDSCH_TRANS_USING_MCS12, PDSCH_TRANS_USING_MCS13, 
  PDSCH_TRANS_USING_MCS14, PDSCH_TRANS_USING_MCS15, PDSCH_TRANS_USING_MCS16, PDSCH_TRANS_USING_MCS17, PDSCH_TRANS_USING_MCS18, 
  PDSCH_TRANS_USING_MCS19, PDSCH_TRANS_USING_MCS20, PDSCH_TRANS_USING_MCS21, PDSCH_TRANS_USING_MCS22, PDSCH_TRANS_USING_MCS23, 
  PDSCH_TRANS_USING_MCS24, PDSCH_TRANS_USING_MCS25, PDSCH_TRANS_USING_MCS26, PDSCH_TRANS_USING_MCS27, PDSCH_TRANS_USING_MCS28, 
  PUSCH_TRANS_NACK_MCS0, PUSCH_TRANS_NACK_MCS1, PUSCH_TRANS_NACK_MCS2, PUSCH_TRANS_NACK_MCS3, PUSCH_TRANS_NACK_MCS4, 
  PUSCH_TRANS_NACK_MCS5, PUSCH_TRANS_NACK_MCS6, PUSCH_TRANS_NACK_MCS7, PUSCH_TRANS_NACK_MCS8, PUSCH_TRANS_NACK_MCS9, 
  PUSCH_TRANS_NACK_MCS10, PUSCH_TRANS_NACK_MCS11, PUSCH_TRANS_NACK_MCS12, PUSCH_TRANS_NACK_MCS13, PUSCH_TRANS_NACK_MCS14, 
  PUSCH_TRANS_NACK_MCS15, PUSCH_TRANS_NACK_MCS16, PUSCH_TRANS_NACK_MCS17, PUSCH_TRANS_NACK_MCS18, PUSCH_TRANS_NACK_MCS19,
   PUSCH_TRANS_NACK_MCS20, PUSCH_TRANS_NACK_MCS21, PUSCH_TRANS_NACK_MCS22, PUSCH_TRANS_NACK_MCS23, PUSCH_TRANS_NACK_MCS24, 
   PUSCH_TRANS_NACK_MCS25, PUSCH_TRANS_NACK_MCS26, PUSCH_TRANS_NACK_MCS27, PUSCH_TRANS_NACK_MCS28, PDSCH_TRANS_NACK_MCS0, 
   PDSCH_TRANS_NACK_MCS1, PDSCH_TRANS_NACK_MCS2, PDSCH_TRANS_NACK_MCS3, PDSCH_TRANS_NACK_MCS4, PDSCH_TRANS_NACK_MCS5, 
   PDSCH_TRANS_NACK_MCS6, PDSCH_TRANS_NACK_MCS7, PDSCH_TRANS_NACK_MCS8, PDSCH_TRANS_NACK_MCS9, PDSCH_TRANS_NACK_MCS10, 
   PDSCH_TRANS_NACK_MCS11, PDSCH_TRANS_NACK_MCS12, PDSCH_TRANS_NACK_MCS13, PDSCH_TRANS_NACK_MCS14, PDSCH_TRANS_NACK_MCS15, 
   PDSCH_TRANS_NACK_MCS16, PDSCH_TRANS_NACK_MCS17, PDSCH_TRANS_NACK_MCS18, PDSCH_TRANS_NACK_MCS19, PDSCH_TRANS_NACK_MCS20, 
   PDSCH_TRANS_NACK_MCS21, PDSCH_TRANS_NACK_MCS22, PDSCH_TRANS_NACK_MCS23, PDSCH_TRANS_NACK_MCS24, PDSCH_TRANS_NACK_MCS25, 
   PDSCH_TRANS_NACK_MCS26, PDSCH_TRANS_NACK_MCS27, PDSCH_TRANS_NACK_MCS28, RLC_SDU_ON_DL_DTCH, RLC_SDU_ON_DL_DCCH, 
   RLC_SDU_ON_UL_DTCH, RLC_SDU_ON_UL_DCCH, RLC_PDU_FIRST_TRANS, RLC_PDU_RE_TRANS, UL_RLC_PDU_DUPL_REC, UL_RLC_PDU_RETR_REQ, 
   UL_RLC_PDU_DISC, DL_UE_DATA_BUFF_AVG, DL_UE_DATA_BUFF_MAX, UL_UE_DATA_BUFF_AVG, UL_UE_DATA_BUFF_MAX, PDCP_SDU_UL, PDCP_SDU_DL, 
   PDCP_SDU_DL_DISC, TB_BAD_PDSCH_MCS0, TB_BAD_PDSCH_MCS1, TB_BAD_PDSCH_MCS2, TB_BAD_PDSCH_MCS3, TB_BAD_PDSCH_MCS4, 
   TB_BAD_PDSCH_MCS5, TB_BAD_PDSCH_MCS6, TB_BAD_PDSCH_MCS7, TB_BAD_PDSCH_MCS8, TB_BAD_PDSCH_MCS9, TB_BAD_PDSCH_MCS10, 
   TB_BAD_PDSCH_MCS11, TB_BAD_PDSCH_MCS12, TB_BAD_PDSCH_MCS13, TB_BAD_PDSCH_MCS14, TB_BAD_PDSCH_MCS15, TB_BAD_PDSCH_MCS16, 
   TB_BAD_PDSCH_MCS17, TB_BAD_PDSCH_MCS18, TB_BAD_PDSCH_MCS19, TB_BAD_PDSCH_MCS20, TB_BAD_PUSCH_MCS0, TB_BAD_PUSCH_MCS1, 
   TB_BAD_PUSCH_MCS2, TB_BAD_PUSCH_MCS3, TB_BAD_PUSCH_MCS4, TB_BAD_PUSCH_MCS5, TB_BAD_PUSCH_MCS6, TB_BAD_PUSCH_MCS7, 
   TB_BAD_PUSCH_MCS8, TB_BAD_PUSCH_MCS9, TB_BAD_PUSCH_MCS10, TB_BAD_PUSCH_MCS11, TB_BAD_PUSCH_MCS12, TB_BAD_PUSCH_MCS13, 
   TB_BAD_PUSCH_MCS14, TB_BAD_PUSCH_MCS15, TB_BAD_PUSCH_MCS16, TB_BAD_PUSCH_MCS17, TB_BAD_PUSCH_MCS18, TB_BAD_PUSCH_MCS19, 
   TB_BAD_PUSCH_MCS20, RRC_CONN_UE_AVG, RRC_CONN_UE_MAX, TB_BAD_PDSCH_MCS21, TB_BAD_PDSCH_MCS22, TB_BAD_PDSCH_MCS23, 
   TB_BAD_PDSCH_MCS24, TB_BAD_PDSCH_MCS25, TB_BAD_PDSCH_MCS26, TB_BAD_PDSCH_MCS27, TB_BAD_PDSCH_MCS28, DL_QUE_L_SRB_MIN, 
   DL_QUE_L_SRB_AVG, DL_QUE_L_SRB_MAX, DL_QUE_L_DRB_MIN, DL_QUE_L_DRB_AVG, DL_QUE_L_DRB_MAX, DL_RLC_C_PDU_FIRST_TIME, 
   DL_RLC_D_PDU_FIRST_TIME, DL_RLC_SDU_FROM_PDCP, RLC_SDU_BCCH, RLC_SDU_DL_CCCH, RLC_SDU_PCCH, RLC_SDU_UL_CCCH, 
   UL_RLC_PDU_RECECPTION, UL_RLC_PDU_REC_TOT, CELL_LOAD_ACT_UE_AVG, CELL_LOAD_ACT_UE_MAX, UE_DRB_DL_DATA_QCI_1, 
   PDCP_RET_DL_DEL_MEAN_QCI_1, PDCP_RET_DL_DEL_MEAN_QCI_2, PDCP_SDU_UL_QCI_1, PDCP_SDU_DL_QCI_1, PDCP_SDU_DISC_DL_QCI_1, 
   UE_DRB_DL_DATA_NON_GBR, PDCP_RET_DL_DEL_MEAN_NON_GBR, UE_DRB_UL_DATA_QCI_1, UE_DRB_UL_DATA_NON_GBR, PDCCH_ORDER_ATT, 
   PDCCH_INIT_ORDER_ATT, PDCCH_ORDER_SUCCESS, D_PREAMB_UNAVAIL, D_PREAMB_PDCCH_UNAVAIL, D_PREAMB_HO_UNAVAIL, CELL_LOAD_UL_IN_SYNC, 
   CELL_LOAD_UL_IN_SYNC_AVG, CELL_LOAD_UNL_POW_RES, CELL_LOAD_UL_OUT_SYNC_0_05, CELL_LOAD_UL_OUT_SYNC_05_025, CELL_LOAD_UL_OUT_SYNC_025_10, 
   CELL_LOAD_UL_OUT_SYNC_10_100, CELL_LOAD_UL_OUT_SYNC_100_INF, PUSCH_1ST_TRANS_MCS0, PUSCH_1ST_TRANS_MCS1, PUSCH_1ST_TRANS_MCS2, 
   PUSCH_1ST_TRANS_MCS3, PUSCH_1ST_TRANS_MCS4, PUSCH_1ST_TRANS_MCS5, PUSCH_1ST_TRANS_MCS6, PUSCH_1ST_TRANS_MCS7, PUSCH_1ST_TRANS_MCS8, 
   PUSCH_1ST_TRANS_MCS9, PUSCH_1ST_TRANS_MCS10, PUSCH_1ST_TRANS_MCS11, PUSCH_1ST_TRANS_MCS12, PUSCH_1ST_TRANS_MCS13, 
   PUSCH_1ST_TRANS_MCS14, PUSCH_1ST_TRANS_MCS15, PUSCH_1ST_TRANS_MCS16, PUSCH_1ST_TRANS_MCS17, PUSCH_1ST_TRANS_MCS18, 
   PUSCH_1ST_TRANS_MCS19, PUSCH_1ST_TRANS_MCS20, PUSCH_1ST_TRANS_MCS21, PUSCH_1ST_TRANS_MCS22, PUSCH_1ST_TRANS_MCS23, 
   PUSCH_1ST_TRANS_MCS24, PUSCH_1ST_TRANS_NACK_MCS0, PUSCH_1ST_TRANS_NACK_MCS1, PUSCH_1ST_TRANS_NACK_MCS2, PUSCH_1ST_TRANS_NACK_MCS3, 
   PUSCH_1ST_TRANS_NACK_MCS4, PUSCH_1ST_TRANS_NACK_MCS5, PUSCH_1ST_TRANS_NACK_MCS6, PUSCH_1ST_TRANS_NACK_MCS7, 
   PUSCH_1ST_TRANS_NACK_MCS8, PUSCH_1ST_TRANS_NACK_MCS9, PUSCH_1ST_TRANS_NACK_MCS10, PUSCH_1ST_TRANS_NACK_MCS11, 
   PUSCH_1ST_TRANS_NACK_MCS12, PUSCH_1ST_TRANS_NACK_MCS13, PUSCH_1ST_TRANS_NACK_MCS14, PUSCH_1ST_TRANS_NACK_MCS15, 
   PUSCH_1ST_TRANS_NACK_MCS16, PUSCH_1ST_TRANS_NACK_MCS17, PUSCH_1ST_TRANS_NACK_MCS18, PUSCH_1ST_TRANS_NACK_MCS19, 
   PUSCH_1ST_TRANS_NACK_MCS20, PUSCH_1ST_TRANS_NACK_MCS21, PUSCH_1ST_TRANS_NACK_MCS22, PUSCH_1ST_TRANS_NACK_MCS23, 
   PUSCH_1ST_TRANS_NACK_MCS24, TB_BAD_PUSCH_MCS21, TB_BAD_PUSCH_MCS22, TB_BAD_PUSCH_MCS23, TB_BAD_PUSCH_MCS24, 
   UE_DRB_DL_DATA_QCI_2, UE_DRB_DL_DATA_QCI_3, UE_DRB_DL_DATA_QCI_4, PDCP_RET_DL_DEL_MEAN_QCI_3, PDCP_RET_DL_DEL_MEAN_QCI_4, 
   RACH_STP_ATT_DEDICATED, PDCP_SDU_DL_QCI_2, PDCP_SDU_DL_QCI_3, PDCP_SDU_DL_QCI_4, PDCP_SDU_DISC_DL_QCI_2, 
   PDCP_SDU_DISC_DL_QCI_3, PDCP_SDU_DISC_DL_QCI_4, MEAN_PRB_AVAIL_PDSCH, MEAN_PRB_AVAIL_PUSCH, PDCP_SDU_LOSS_UL, 
   PDCP_SDU_LOSS_UL_QCI_1, PDCP_SDU_LOSS_UL_QCI_2, PDCP_SDU_LOSS_UL_QCI_3, PDCP_SDU_LOSS_UL_QCI_4, PDCP_SDU_LOSS_DL, 
   PDCP_SDU_LOSS_DL_QCI_1, PDCP_SDU_LOSS_DL_QCI_2, PDCP_SDU_LOSS_DL_QCI_3, PDCP_SDU_LOSS_DL_QCI_4, PDCP_SDU_UL_QCI_2, 
   PDCP_SDU_UL_QCI_3, PDCP_SDU_UL_QCI_4, CA_DL_CAP_UE_AVG, CA_SCELL_CONF_UE_AVG, CA_SCELL_ACTIVE_UE_AVG, NUM_WARN_ETWS_PRIM, 
   NUM_WARN_ETWS_SEC, NUM_WARN_CMAS, SUM_ACTIVE_UE_DATA_DL, DENOM_ACTIVE_UE_DATA_DL, SUM_ACTIVE_UE_DATA_UL, DENOM_ACTIVE_UE_DATA_UL, 
   SUM_RRC_CONN_UE, DENOM_RRC_CONN_UE, SUM_ACTIVE_UE, DENOM_ACTIVE_UE 
)
 
 
WITH t AS (SELECT xmltype(bfilename(p_local_dir,p_file_name), nls_charset_id('AL32UTF8')) xmlcol FROM dual)
SELECT
    (select INT_ID from MULTIVENDOR_OBJECTS where OBJECT_CLASS = 3130 and OBJECT_NRO = substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNCEL-[0-9]*'),7)) INT_ID,
    (select NAME from multivendor_objects where OBJECT_CLASS = 3130 and OBJECT_NRO = substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNCEL-[0-9]*'),7)) CO_NAME,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'MRBTS-[0-9]*'),7) MRBTS_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNBTS-[0-9]*'),7) LNBTS_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNCEL-[0-9]*'),7) LNCEL_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'MCC-[0-9]*'),5) MCC_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'MNC-[0-9]*'),5) MNC_ID,
    TO_DATE(REGEXP_REPLACE(REGEXP_SUBSTR(extract(t.xmlcol, '//@startTime','xmlns="pm/cnf_lte_nsn.1.0.xsd"'),'[0-9]*[-][0-9]*[-][0-9]*[^t][0-9]*[:][0-9]*[:][0-9]*'),'(T)', ' '),'YYYY-MM-DD HH24:MI:SS ') PERIOD_START_TIME,
    extract(t.xmlcol, '//@interval','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getNumberVal() PERIOD_DURATION,
    extract(t.xmlcol, '//@interval','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getNumberVal() PERIOD_DURATION_SUM,

    extractValue(value(x),'/PMMOResult/PMTarget/M8001C0','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCP_SDU_DELAY_DL_DTCH_MIN,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C1','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCP_SDU_DELAY_DL_DTCH_MAX,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C2','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCP_SDU_DELAY_DL_DTCH_MEAN,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C3','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCP_SDU_DELAY_UL_DTCH_MIN,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C4','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCP_SDU_DELAY_UL_DTCH_MAX,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C5','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCP_SDU_DELAY_UL_DTCH_MEAN,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C6','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RACH_STP_ATT_SMALL_MSG,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C7','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RACH_STP_ATT_LARGE_MSG,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C8','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RACH_STP_COMPLETIONS,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C9','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TRANSMIT_TB_ON_PCH,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C10','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TRANSMIT_TB_ON_BCH,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C11','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TRANSMIT_TB_ON_DL_SCH,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C12','xmlns="pm/cnf_lte_nsn.1.0.xsd"') HARQ_RETRANS_ON_DL_SCH,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C13','xmlns="pm/cnf_lte_nsn.1.0.xsd"') CORR_NON_DUPL_UL_SCH_TB,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C14','xmlns="pm/cnf_lte_nsn.1.0.xsd"') CORR_UL_SCH_TB_RE_RECEPT,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C15','xmlns="pm/cnf_lte_nsn.1.0.xsd"') INCORR_UL_SCH_TB_RECEPT,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C16','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_USING_MCS0,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C17','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_USING_MCS1,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C18','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_USING_MCS2,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C19','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_USING_MCS3,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C20','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_USING_MCS4,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C21','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_USING_MCS5,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C22','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_USING_MCS6,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C23','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_USING_MCS7,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C24','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_USING_MCS8,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C25','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_USING_MCS9,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C26','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_USING_MCS10,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C27','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_USING_MCS11,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C28','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_USING_MCS12,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C29','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_USING_MCS13,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C30','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_USING_MCS14,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C31','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_USING_MCS15,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C32','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_USING_MCS16,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C33','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_USING_MCS17,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C34','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_USING_MCS18,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C35','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_USING_MCS19,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C36','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_USING_MCS20,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C37','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_USING_MCS21,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C38','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_USING_MCS22,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C39','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_USING_MCS23,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C40','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_USING_MCS24,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C41','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_USING_MCS25,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C42','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_USING_MCS26,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C44','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_USING_MCS27,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C43','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_USING_MCS28,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C45','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_USING_MCS0,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C46','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_USING_MCS1,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C47','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_USING_MCS2,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C48','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_USING_MCS3,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C49','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_USING_MCS4,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C50','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_USING_MCS5,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C51','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_USING_MCS6,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C52','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_USING_MCS7,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C53','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_USING_MCS8,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C54','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_USING_MCS9,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C55','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_USING_MCS10,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C56','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_USING_MCS11,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C57','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_USING_MCS12,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C58','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_USING_MCS13,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C59','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_USING_MCS14,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C60','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_USING_MCS15,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C61','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_USING_MCS16,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C62','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_USING_MCS17,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C63','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_USING_MCS18,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C64','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_USING_MCS19,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C65','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_USING_MCS20,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C66','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_USING_MCS21,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C67','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_USING_MCS22,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C68','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_USING_MCS23,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C69','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_USING_MCS24,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C70','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_USING_MCS25,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C71','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_USING_MCS26,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C72','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_USING_MCS27,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C73','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_USING_MCS28,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C74','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_NACK_MCS0,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C75','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_NACK_MCS1,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C76','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_NACK_MCS2,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C77','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_NACK_MCS3,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C78','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_NACK_MCS4,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C79','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_NACK_MCS5,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C80','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_NACK_MCS6,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C81','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_NACK_MCS7,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C82','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_NACK_MCS8,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C83','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_NACK_MCS9,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C84','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_NACK_MCS10,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C85','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_NACK_MCS11,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C86','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_NACK_MCS12,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C87','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_NACK_MCS13,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C88','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_NACK_MCS14,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C89','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_NACK_MCS15,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C90','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_NACK_MCS16,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C91','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_NACK_MCS17,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C92','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_NACK_MCS18,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C93','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_NACK_MCS19,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C94','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_NACK_MCS20,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C95','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_NACK_MCS21,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C96','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_NACK_MCS22,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C97','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_NACK_MCS23,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C98','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_NACK_MCS24,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C99','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_NACK_MCS25,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C100','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_NACK_MCS26,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C101','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_NACK_MCS27,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C102','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_TRANS_NACK_MCS28,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C103','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_NACK_MCS0,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C104','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_NACK_MCS1,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C105','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_NACK_MCS2,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C106','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_NACK_MCS3,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C107','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_NACK_MCS4,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C108','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_NACK_MCS5,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C109','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_NACK_MCS6,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C110','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_NACK_MCS7,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C111','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_NACK_MCS8,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C112','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_NACK_MCS9,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C113','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_NACK_MCS10,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C114','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_NACK_MCS11,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C115','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_NACK_MCS12,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C116','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_NACK_MCS13,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C117','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_NACK_MCS14,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C118','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_NACK_MCS15,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C119','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_NACK_MCS16,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C120','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_NACK_MCS17,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C121','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_NACK_MCS18,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C122','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_NACK_MCS19,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C123','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_NACK_MCS20,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C124','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_NACK_MCS21,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C125','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_NACK_MCS22,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C126','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_NACK_MCS23,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C127','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_NACK_MCS24,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C128','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_NACK_MCS25,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C129','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_NACK_MCS26,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C130','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_NACK_MCS27,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C131','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDSCH_TRANS_NACK_MCS28,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C132','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RLC_SDU_ON_DL_DTCH,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C133','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RLC_SDU_ON_DL_DCCH,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C135','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RLC_SDU_ON_UL_DTCH,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C136','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RLC_SDU_ON_UL_DCCH,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C137','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RLC_PDU_FIRST_TRANS,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C138','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RLC_PDU_RE_TRANS,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C143','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UL_RLC_PDU_DUPL_REC,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C144','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UL_RLC_PDU_RETR_REQ,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C145','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UL_RLC_PDU_DISC,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C147','xmlns="pm/cnf_lte_nsn.1.0.xsd"') DL_UE_DATA_BUFF_AVG,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C148','xmlns="pm/cnf_lte_nsn.1.0.xsd"') DL_UE_DATA_BUFF_MAX,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C150','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UL_UE_DATA_BUFF_AVG,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C151','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UL_UE_DATA_BUFF_MAX,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C153','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCP_SDU_UL,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C154','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCP_SDU_DL,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C155','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCP_SDU_DL_DISC,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C156','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PDSCH_MCS0,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C157','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PDSCH_MCS1,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C158','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PDSCH_MCS2,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C159','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PDSCH_MCS3,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C160','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PDSCH_MCS4,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C161','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PDSCH_MCS5,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C162','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PDSCH_MCS6,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C163','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PDSCH_MCS7,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C164','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PDSCH_MCS8,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C165','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PDSCH_MCS9,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C166','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PDSCH_MCS10,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C167','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PDSCH_MCS11,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C168','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PDSCH_MCS12,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C169','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PDSCH_MCS13,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C170','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PDSCH_MCS14,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C171','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PDSCH_MCS15,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C172','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PDSCH_MCS16,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C173','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PDSCH_MCS17,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C174','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PDSCH_MCS18,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C175','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PDSCH_MCS19,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C176','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PDSCH_MCS20,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C177','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PUSCH_MCS0,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C178','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PUSCH_MCS1,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C179','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PUSCH_MCS2,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C180','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PUSCH_MCS3,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C181','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PUSCH_MCS4,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C182','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PUSCH_MCS5,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C183','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PUSCH_MCS6,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C184','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PUSCH_MCS7,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C185','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PUSCH_MCS8,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C186','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PUSCH_MCS9,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C187','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PUSCH_MCS10,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C188','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PUSCH_MCS11,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C189','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PUSCH_MCS12,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C190','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PUSCH_MCS13,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C191','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PUSCH_MCS14,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C192','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PUSCH_MCS15,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C193','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PUSCH_MCS16,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C194','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PUSCH_MCS17,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C195','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PUSCH_MCS18,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C196','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PUSCH_MCS19,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C197','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PUSCH_MCS20,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C199','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RRC_CONN_UE_AVG,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C200','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RRC_CONN_UE_MAX,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C202','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PDSCH_MCS21,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C203','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PDSCH_MCS22,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C204','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PDSCH_MCS23,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C205','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PDSCH_MCS24,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C206','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PDSCH_MCS25,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C207','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PDSCH_MCS26,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C208','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PDSCH_MCS27,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C209','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PDSCH_MCS28,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C210','xmlns="pm/cnf_lte_nsn.1.0.xsd"') DL_QUE_L_SRB_MIN,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C211','xmlns="pm/cnf_lte_nsn.1.0.xsd"') DL_QUE_L_SRB_AVG,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C212','xmlns="pm/cnf_lte_nsn.1.0.xsd"') DL_QUE_L_SRB_MAX,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C213','xmlns="pm/cnf_lte_nsn.1.0.xsd"') DL_QUE_L_DRB_MIN,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C214','xmlns="pm/cnf_lte_nsn.1.0.xsd"') DL_QUE_L_DRB_AVG,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C215','xmlns="pm/cnf_lte_nsn.1.0.xsd"') DL_QUE_L_DRB_MAX,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C140','xmlns="pm/cnf_lte_nsn.1.0.xsd"') DL_RLC_C_PDU_FIRST_TIME,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C141','xmlns="pm/cnf_lte_nsn.1.0.xsd"') DL_RLC_D_PDU_FIRST_TIME,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C146','xmlns="pm/cnf_lte_nsn.1.0.xsd"') DL_RLC_SDU_FROM_PDCP,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C218','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RLC_SDU_BCCH,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C219','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RLC_SDU_DL_CCCH,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C220','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RLC_SDU_PCCH,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C222','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RLC_SDU_UL_CCCH,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C139','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UL_RLC_PDU_RECECPTION,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C142','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UL_RLC_PDU_REC_TOT,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C223','xmlns="pm/cnf_lte_nsn.1.0.xsd"') CELL_LOAD_ACT_UE_AVG,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C224','xmlns="pm/cnf_lte_nsn.1.0.xsd"') CELL_LOAD_ACT_UE_MAX,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C227','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_DRB_DL_DATA_QCI_1,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C269','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCP_RET_DL_DEL_MEAN_QCI_1,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C271','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCP_RET_DL_DEL_MEAN_QCI_2,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C305','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCP_SDU_UL_QCI_1,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C314','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCP_SDU_DL_QCI_1,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C323','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCP_SDU_DISC_DL_QCI_1,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C235','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_DRB_DL_DATA_NON_GBR,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C270','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCP_RET_DL_DEL_MEAN_NON_GBR,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C419','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_DRB_UL_DATA_QCI_1,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C420','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_DRB_UL_DATA_NON_GBR,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C421','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCCH_ORDER_ATT,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C422','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCCH_INIT_ORDER_ATT,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C423','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCCH_ORDER_SUCCESS,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C424','xmlns="pm/cnf_lte_nsn.1.0.xsd"') D_PREAMB_UNAVAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C425','xmlns="pm/cnf_lte_nsn.1.0.xsd"') D_PREAMB_PDCCH_UNAVAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C426','xmlns="pm/cnf_lte_nsn.1.0.xsd"') D_PREAMB_HO_UNAVAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C427','xmlns="pm/cnf_lte_nsn.1.0.xsd"') CELL_LOAD_UL_IN_SYNC,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C428','xmlns="pm/cnf_lte_nsn.1.0.xsd"') CELL_LOAD_UL_IN_SYNC_AVG,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C429','xmlns="pm/cnf_lte_nsn.1.0.xsd"') CELL_LOAD_UNL_POW_RES,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C430','xmlns="pm/cnf_lte_nsn.1.0.xsd"') CELL_LOAD_UL_OUT_SYNC_0_05,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C431','xmlns="pm/cnf_lte_nsn.1.0.xsd"') CELL_LOAD_UL_OUT_SYNC_05_025,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C432','xmlns="pm/cnf_lte_nsn.1.0.xsd"') CELL_LOAD_UL_OUT_SYNC_025_10,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C433','xmlns="pm/cnf_lte_nsn.1.0.xsd"') CELL_LOAD_UL_OUT_SYNC_10_100,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C434','xmlns="pm/cnf_lte_nsn.1.0.xsd"') CELL_LOAD_UL_OUT_SYNC_100_INF,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C435','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_MCS0,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C436','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_MCS1,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C437','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_MCS2,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C438','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_MCS3,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C439','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_MCS4,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C440','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_MCS5,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C441','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_MCS6,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C442','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_MCS7,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C443','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_MCS8,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C444','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_MCS9,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C445','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_MCS10,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C446','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_MCS11,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C447','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_MCS12,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C448','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_MCS13,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C449','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_MCS14,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C450','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_MCS15,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C451','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_MCS16,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C452','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_MCS17,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C453','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_MCS18,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C454','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_MCS19,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C455','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_MCS20,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C456','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_MCS21,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C457','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_MCS22,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C458','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_MCS23,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C459','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_MCS24,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C460','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_NACK_MCS0,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C461','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_NACK_MCS1,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C462','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_NACK_MCS2,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C463','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_NACK_MCS3,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C464','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_NACK_MCS4,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C465','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_NACK_MCS5,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C466','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_NACK_MCS6,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C467','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_NACK_MCS7,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C468','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_NACK_MCS8,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C469','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_NACK_MCS9,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C470','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_NACK_MCS10,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C471','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_NACK_MCS11,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C472','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_NACK_MCS12,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C473','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_NACK_MCS13,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C474','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_NACK_MCS14,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C475','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_NACK_MCS15,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C476','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_NACK_MCS16,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C477','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_NACK_MCS17,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C478','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_NACK_MCS18,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C479','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_NACK_MCS19,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C480','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_NACK_MCS20,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C481','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_NACK_MCS21,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C482','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_NACK_MCS22,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C483','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_NACK_MCS23,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C484','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PUSCH_1ST_TRANS_NACK_MCS24,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C485','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PUSCH_MCS21,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C486','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PUSCH_MCS22,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C487','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PUSCH_MCS23,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C488','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TB_BAD_PUSCH_MCS24,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C228','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_DRB_DL_DATA_QCI_2,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C229','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_DRB_DL_DATA_QCI_3,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C230','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_DRB_DL_DATA_QCI_4,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C272','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCP_RET_DL_DEL_MEAN_QCI_3,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C273','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCP_RET_DL_DEL_MEAN_QCI_4,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C286','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RACH_STP_ATT_DEDICATED,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C315','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCP_SDU_DL_QCI_2,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C316','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCP_SDU_DL_QCI_3,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C317','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCP_SDU_DL_QCI_4,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C324','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCP_SDU_DISC_DL_QCI_2,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C325','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCP_SDU_DISC_DL_QCI_3,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C326','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCP_SDU_DISC_DL_QCI_4,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C216','xmlns="pm/cnf_lte_nsn.1.0.xsd"') MEAN_PRB_AVAIL_PDSCH,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C217','xmlns="pm/cnf_lte_nsn.1.0.xsd"') MEAN_PRB_AVAIL_PUSCH,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C254','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCP_SDU_LOSS_UL,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C255','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCP_SDU_LOSS_UL_QCI_1,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C256','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCP_SDU_LOSS_UL_QCI_2,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C257','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCP_SDU_LOSS_UL_QCI_3,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C258','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCP_SDU_LOSS_UL_QCI_4,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C259','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCP_SDU_LOSS_DL,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C260','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCP_SDU_LOSS_DL_QCI_1,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C261','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCP_SDU_LOSS_DL_QCI_2,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C262','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCP_SDU_LOSS_DL_QCI_3,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C263','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCP_SDU_LOSS_DL_QCI_4,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C306','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCP_SDU_UL_QCI_2,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C307','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCP_SDU_UL_QCI_3,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C308','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCP_SDU_UL_QCI_4,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C494','xmlns="pm/cnf_lte_nsn.1.0.xsd"') CA_DL_CAP_UE_AVG,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C495','xmlns="pm/cnf_lte_nsn.1.0.xsd"') CA_SCELL_CONF_UE_AVG,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C496','xmlns="pm/cnf_lte_nsn.1.0.xsd"') CA_SCELL_ACTIVE_UE_AVG,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C231','xmlns="pm/cnf_lte_nsn.1.0.xsd"') NUM_WARN_ETWS_PRIM,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C232','xmlns="pm/cnf_lte_nsn.1.0.xsd"') NUM_WARN_ETWS_SEC,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C233','xmlns="pm/cnf_lte_nsn.1.0.xsd"') NUM_WARN_CMAS,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C264','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SUM_ACTIVE_UE_DATA_DL,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C265','xmlns="pm/cnf_lte_nsn.1.0.xsd"') DENOM_ACTIVE_UE_DATA_DL,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C266','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SUM_ACTIVE_UE_DATA_UL,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C267','xmlns="pm/cnf_lte_nsn.1.0.xsd"') DENOM_ACTIVE_UE_DATA_UL,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C318','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SUM_RRC_CONN_UE,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C319','xmlns="pm/cnf_lte_nsn.1.0.xsd"') DENOM_RRC_CONN_UE,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C320','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SUM_ACTIVE_UE,
    extractValue(value(x),'/PMMOResult/PMTarget/M8001C321','xmlns="pm/cnf_lte_nsn.1.0.xsd"') DENOM_ACTIVE_UE

     FROM t,TABLE(XMLSequence(extract(t.xmlcol,'/OMeS/PMSetup/PMMOResult','xmlns="pm/cnf_lte_nsn.1.0.xsd"'))) x;
    
 -- update table STATUS_PROCESS_ETL whith information the xml status 1: processed.
   update STATUS_PROCESS_ETL set status ='1' where filename = p_file_name;   
   return_result := 1 ;
   return return_result;
  
   EXCEPTION
  WHEN OTHERS THEN
    raise_application_error(-20001,'An error has been found - '||SQLCODE||' -ERROR- '||SQLERRM);
    -- update table STATUS_PROCESS_ETL whith information the xml status 2: error processed.
   update STATUS_PROCESS_ETL set status ='2' where filename = p_file_name;   
   return_result := 2 ;
   return return_result;
  COMMIT;    
END parser_LTE_Cell_LoadP;

  /* parse xml with LTE_S1AP measurement and load in a database */
FUNCTION parser_LTE_Pwr_and_Qual_DL(
    p_local_dir        IN VARCHAR2,
    p_file_name        IN VARCHAR2)
    RETURN INTEGER
IS
   return_result INTEGER;              -- 2: error procesed, 1: ok procesed   
BEGIN
     
   
 INSERT INTO NOKLTE_PS_LPQDL_MNC1_RAW
 (INT_ID,CO_NAME,MRBTS_ID,LNBTS_ID, LNCEL_ID, MCC_ID, MNC_ID, PERIOD_START_TIME,PERIOD_DURATION,PERIOD_DURATION_SUM,
  UE_REP_CQI_LEVEL_00, UE_REP_CQI_LEVEL_01, UE_REP_CQI_LEVEL_02, UE_REP_CQI_LEVEL_03, UE_REP_CQI_LEVEL_04, UE_REP_CQI_LEVEL_05, 
  UE_REP_CQI_LEVEL_06, UE_REP_CQI_LEVEL_07, UE_REP_CQI_LEVEL_08, UE_REP_CQI_LEVEL_09, UE_REP_CQI_LEVEL_10, UE_REP_CQI_LEVEL_11, 
  UE_REP_CQI_LEVEL_12, UE_REP_CQI_LEVEL_13, UE_REP_CQI_LEVEL_14, UE_REP_CQI_LEVEL_15, CQI_OFF_MIN, CQI_OFF_MAX, CQI_OFF_MEAN, MIMO_OL_DIV, 
  MIMO_OL_SM, MIMO_CL_1CW, MIMO_CL_2CW, MIMO_SWITCH_OL, MIMO_SWITCH_CL, PDCCH_ALLOC_PDSCH_HARQ, PDCCH_ALLOC_PDSCH_HARQ_NO_RES 
 )
 
 
WITH t AS (SELECT xmltype(bfilename(p_local_dir,p_file_name), nls_charset_id('AL32UTF8')) xmlcol FROM dual)
SELECT
    (select INT_ID from MULTIVENDOR_OBJECTS where OBJECT_CLASS = 3130 and OBJECT_NRO = substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNCEL-[0-9]*'),7)) INT_ID,
    (select NAME from multivendor_objects where OBJECT_CLASS = 3130 and OBJECT_NRO = substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNCEL-[0-9]*'),7)) CO_NAME,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'MRBTS-[0-9]*'),7) MRBTS_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNBTS-[0-9]*'),7) LNBTS_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNCEL-[0-9]*'),7) LNCEL_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'MCC-[0-9]*'),5) MCC_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'MNC-[0-9]*'),5) MNC_ID,
    TO_DATE(REGEXP_REPLACE(REGEXP_SUBSTR(extract(t.xmlcol, '//@startTime','xmlns="pm/cnf_lte_nsn.1.0.xsd"'),'[0-9]*[-][0-9]*[-][0-9]*[^t][0-9]*[:][0-9]*[:][0-9]*'),'(T)', ' '),'YYYY-MM-DD HH24:MI:SS ') PERIOD_START_TIME,
    extract(t.xmlcol, '//@interval','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getNumberVal() PERIOD_DURATION,
    extract(t.xmlcol, '//@interval','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getNumberVal() PERIOD_DURATION_SUM,


   extractValue(value(x),'/PMMOResult/PMTarget/M8010C36','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_REP_CQI_LEVEL_00,
   extractValue(value(x),'/PMMOResult/PMTarget/M8010C37','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_REP_CQI_LEVEL_01,
   extractValue(value(x),'/PMMOResult/PMTarget/M8010C38','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_REP_CQI_LEVEL_02,
   extractValue(value(x),'/PMMOResult/PMTarget/M8010C39','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_REP_CQI_LEVEL_03,
   extractValue(value(x),'/PMMOResult/PMTarget/M8010C40','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_REP_CQI_LEVEL_04,
   extractValue(value(x),'/PMMOResult/PMTarget/M8010C41','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_REP_CQI_LEVEL_05,
   extractValue(value(x),'/PMMOResult/PMTarget/M8010C42','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_REP_CQI_LEVEL_06,
   extractValue(value(x),'/PMMOResult/PMTarget/M8010C43','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_REP_CQI_LEVEL_07,
   extractValue(value(x),'/PMMOResult/PMTarget/M8010C44','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_REP_CQI_LEVEL_08,
   extractValue(value(x),'/PMMOResult/PMTarget/M8010C45','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_REP_CQI_LEVEL_09,
   extractValue(value(x),'/PMMOResult/PMTarget/M8010C46','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_REP_CQI_LEVEL_10,
   extractValue(value(x),'/PMMOResult/PMTarget/M8010C47','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_REP_CQI_LEVEL_11,
   extractValue(value(x),'/PMMOResult/PMTarget/M8010C48','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_REP_CQI_LEVEL_12,
   extractValue(value(x),'/PMMOResult/PMTarget/M8010C49','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_REP_CQI_LEVEL_13,
   extractValue(value(x),'/PMMOResult/PMTarget/M8010C50','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_REP_CQI_LEVEL_14,
   extractValue(value(x),'/PMMOResult/PMTarget/M8010C51','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_REP_CQI_LEVEL_15,
   extractValue(value(x),'/PMMOResult/PMTarget/M8010C52','xmlns="pm/cnf_lte_nsn.1.0.xsd"') CQI_OFF_MIN,
   extractValue(value(x),'/PMMOResult/PMTarget/M8010C53','xmlns="pm/cnf_lte_nsn.1.0.xsd"') CQI_OFF_MAX,
   extractValue(value(x),'/PMMOResult/PMTarget/M8010C54','xmlns="pm/cnf_lte_nsn.1.0.xsd"') CQI_OFF_MEAN,
   extractValue(value(x),'/PMMOResult/PMTarget/M8010C55','xmlns="pm/cnf_lte_nsn.1.0.xsd"') MIMO_OL_DIV,
   extractValue(value(x),'/PMMOResult/PMTarget/M8010C56','xmlns="pm/cnf_lte_nsn.1.0.xsd"') MIMO_OL_SM,
   extractValue(value(x),'/PMMOResult/PMTarget/M8010C57','xmlns="pm/cnf_lte_nsn.1.0.xsd"') MIMO_CL_1CW,
   extractValue(value(x),'/PMMOResult/PMTarget/M8010C58','xmlns="pm/cnf_lte_nsn.1.0.xsd"') MIMO_CL_2CW,
   extractValue(value(x),'/PMMOResult/PMTarget/M8010C59','xmlns="pm/cnf_lte_nsn.1.0.xsd"') MIMO_SWITCH_OL,
   extractValue(value(x),'/PMMOResult/PMTarget/M8010C60','xmlns="pm/cnf_lte_nsn.1.0.xsd"') MIMO_SWITCH_CL,
   extractValue(value(x),'/PMMOResult/PMTarget/M8010C61','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCCH_ALLOC_PDSCH_HARQ,
   extractValue(value(x),'/PMMOResult/PMTarget/M8010C62','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCCH_ALLOC_PDSCH_HARQ_NO_RES

     FROM t,TABLE(XMLSequence(extract(t.xmlcol,'/OMeS/PMSetup/PMMOResult','xmlns="pm/cnf_lte_nsn.1.0.xsd"'))) x;
    
    -- update table STATUS_PROCESS_ETL whith information the xml status 1: processed.
   update STATUS_PROCESS_ETL set status ='1' where filename = p_file_name;   
   return_result := 1 ;
   return return_result;
  
   EXCEPTION
  WHEN OTHERS THEN
    raise_application_error(-20001,'An error has been found - '||SQLCODE||' -ERROR- '||SQLERRM);
    -- update table STATUS_PROCESS_ETL whith information the xml status 2: error processed.
   update STATUS_PROCESS_ETL set status ='2' where filename = p_file_name;   
   return_result := 2 ;
   return return_result;
  COMMIT;    
END parser_LTE_Pwr_and_Qual_DL; 


  /* parse xml with LTE_EPS_Bearer measurement and load in a database*/
FUNCTION parser_LTE_EPS_Bearer(
    p_local_dir        IN VARCHAR2,
    p_file_name        IN VARCHAR2)
    RETURN INTEGER
IS
   return_result INTEGER;              -- 2: error procesed, 1: ok procesed   
BEGIN
    
   
 INSERT INTO noklte_ps_lepsb_mnc1_raw
 (INT_ID,CO_NAME,MRBTS_ID,LNBTS_ID,LNCEL_ID,MCC_ID,MNC_ID,PERIOD_START_TIME,PERIOD_DURATION,PERIOD_DURATION_SUM,EPS_BEARER_SETUP_ATTEMPTS,
 EPS_BEARER_SETUP_COMPLETIONS,EPS_BEARER_SETUP_FAIL_RNL,EPS_BEARER_SETUP_FAIL_TRPORT,EPS_BEARER_SETUP_FAIL_RESOUR,
 EPS_BEARER_SETUP_FAIL_OTH,EPC_EPS_BEARER_REL_REQ_NORM,EPC_EPS_BEARER_REL_REQ_DETACH,EPC_EPS_BEARER_REL_REQ_RNL,EPC_EPS_BEARER_REL_REQ_OTH,
 ENB_EPS_BEARER_REL_REQ_NORM,ENB_EPS_BEARER_REL_REQ_RNL,ENB_EPS_BEARER_REL_REQ_OTH,ENB_EPS_BEARER_REL_REQ_TNL,ENB_EPSBEAR_REL_REQ_RNL_REDIR,
 EPS_BEAR_SET_COM_ADDIT_QCI1,EPC_EPS_BEAR_REL_REQ_N_QCI1,EPC_EPS_BEAR_REL_REQ_D_QCI1,EPC_EPS_BEAR_REL_REQ_R_QCI1,EPC_EPS_BEAR_REL_REQ_O_QCI1,
 ENB_EPS_BEAR_REL_REQ_N_QCI1,ENB_EPS_BEAR_REL_REQ_O_QCI1,ENB_EPS_BEAR_REL_REQ_T_QCI1,EPS_BEARER_STP_ATT_INI_QCI_1,EPS_BEAR_STP_ATT_INI_NON_GBR,
 EPS_BEARER_STP_ATT_ADD_QCI_1,EPS_BEARER_STP_COM_INI_QCI1,EPS_BEAR_STP_COM_INI_NON_GBR,ENB_EPS_BEAR_REL_REQ_R_QCI1,ENB_EPS_BEAR_REL_REQ_RD_QCI1,
 EPS_BEARER_STP_ATT_INI_QCI_2,EPS_BEARER_STP_ATT_INI_QCI_3,EPS_BEARER_STP_ATT_INI_QCI_4,EPS_BEARER_STP_ATT_ADD_QCI_2,EPS_BEARER_STP_ATT_ADD_QCI_3,
 EPS_BEARER_STP_ATT_ADD_QCI_4,EPS_BEARER_STP_COM_INI_QCI_2,EPS_BEARER_STP_COM_INI_QCI_3,EPS_BEARER_STP_COM_INI_QCI_4,EPS_BEARER_STP_COM_ADD_QCI_2,
 EPS_BEARER_STP_COM_ADD_QCI_3,EPS_BEARER_STP_COM_ADD_QCI_4,PRE_EMPT_GBR_BEARER,PRE_EMPT_NON_GBR_BEARER,ERAB_REL_ENB_ACT_QCI1,ERAB_REL_ENB_ACT_QCI2,
 ERAB_REL_ENB_ACT_QCI3,ERAB_REL_ENB_ACT_QCI4,ERAB_REL_ENB_ACT_NON_GBR,ERAB_IN_SESSION_TIME_QCI1,ERAB_IN_SESSION_TIME_QCI2,ERAB_IN_SESSION_TIME_QCI3,
 ERAB_IN_SESSION_TIME_QCI4,ERAB_IN_SESSION_TIME_NON_GBR)
 
 
WITH t AS (SELECT xmltype(bfilename(p_local_dir,p_file_name), nls_charset_id('AL32UTF8')) xmlcol FROM dual)
SELECT
    (select INT_ID from MULTIVENDOR_OBJECTS where OBJECT_CLASS = 3130 and OBJECT_NRO = substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNCEL-[0-9]*'),7)) INT_ID,
    (select NAME from multivendor_objects where OBJECT_CLASS = 3130 and OBJECT_NRO = substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNCEL-[0-9]*'),7)) CO_NAME,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'MRBTS-[0-9]*'),7) MRBTS_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNBTS-[0-9]*'),7) LNBTS_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNCEL-[0-9]*'),7) LNCEL_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'MCC-[0-9]*'),5) MCC_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'MNC-[0-9]*'),5) MNC_ID,
    TO_DATE(REGEXP_REPLACE(REGEXP_SUBSTR(extract(t.xmlcol, '//@startTime','xmlns="pm/cnf_lte_nsn.1.0.xsd"'),'[0-9]*[-][0-9]*[-][0-9]*[^t][0-9]*[:][0-9]*[:][0-9]*'),'(T)', ' '),'YYYY-MM-DD HH24:MI:SS ') PERIOD_START_TIME,
    extract(t.xmlcol, '//@interval','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getNumberVal() PERIOD_DURATION,
    extract(t.xmlcol, '//@interval','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getNumberVal() PERIOD_DURATION_SUM,
    
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C0','xmlns="pm/cnf_lte_nsn.1.0.xsd"') EPS_BEARER_SETUP_ATTEMPTS,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C1','xmlns="pm/cnf_lte_nsn.1.0.xsd"') EPS_BEARER_SETUP_COMPLETIONS,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C2','xmlns="pm/cnf_lte_nsn.1.0.xsd"') EPS_BEARER_SETUP_FAIL_RNL,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C3','xmlns="pm/cnf_lte_nsn.1.0.xsd"' )EPS_BEARER_SETUP_FAIL_TRPORT,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C4','xmlns="pm/cnf_lte_nsn.1.0.xsd"') EPS_BEARER_SETUP_FAIL_RESOUR,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C5','xmlns="pm/cnf_lte_nsn.1.0.xsd"') EPS_BEARER_SETUP_FAIL_OTH,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C6','xmlns="pm/cnf_lte_nsn.1.0.xsd"') EPC_EPS_BEARER_REL_REQ_NORM,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C7','xmlns="pm/cnf_lte_nsn.1.0.xsd"') EPC_EPS_BEARER_REL_REQ_DETACH,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C8','xmlns="pm/cnf_lte_nsn.1.0.xsd"') EPC_EPS_BEARER_REL_REQ_RNL,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C9','xmlns="pm/cnf_lte_nsn.1.0.xsd"') EPC_EPS_BEARER_REL_REQ_OTH,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C10','xmlns="pm/cnf_lte_nsn.1.0.xsd"') ENB_EPS_BEARER_REL_REQ_NORM,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C12','xmlns="pm/cnf_lte_nsn.1.0.xsd"') ENB_EPS_BEARER_REL_REQ_RNL,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C13','xmlns="pm/cnf_lte_nsn.1.0.xsd"') ENB_EPS_BEARER_REL_REQ_OTH,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C14','xmlns="pm/cnf_lte_nsn.1.0.xsd"') ENB_EPS_BEARER_REL_REQ_TNL,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C15','xmlns="pm/cnf_lte_nsn.1.0.xsd"') ENB_EPSBEAR_REL_REQ_RNL_REDIR,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C44','xmlns="pm/cnf_lte_nsn.1.0.xsd"') EPS_BEAR_SET_COM_ADDIT_QCI1,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C89','xmlns="pm/cnf_lte_nsn.1.0.xsd"') EPC_EPS_BEAR_REL_REQ_N_QCI1,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C98','xmlns="pm/cnf_lte_nsn.1.0.xsd"') EPC_EPS_BEAR_REL_REQ_D_QCI1,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C107','xmlns="pm/cnf_lte_nsn.1.0.xsd"') EPC_EPS_BEAR_REL_REQ_R_QCI1,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C116','xmlns="pm/cnf_lte_nsn.1.0.xsd"') EPC_EPS_BEAR_REL_REQ_O_QCI1,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C125','xmlns="pm/cnf_lte_nsn.1.0.xsd"') ENB_EPS_BEAR_REL_REQ_N_QCI1,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C143','xmlns="pm/cnf_lte_nsn.1.0.xsd"') ENB_EPS_BEAR_REL_REQ_O_QCI1,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C152','xmlns="pm/cnf_lte_nsn.1.0.xsd"') ENB_EPS_BEAR_REL_REQ_T_QCI1,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C17','xmlns="pm/cnf_lte_nsn.1.0.xsd"') EPS_BEARER_STP_ATT_INI_QCI_1,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C18','xmlns="pm/cnf_lte_nsn.1.0.xsd"') EPS_BEAR_STP_ATT_INI_NON_GBR,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C26','xmlns="pm/cnf_lte_nsn.1.0.xsd"') EPS_BEARER_STP_ATT_ADD_QCI_1,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C35','xmlns="pm/cnf_lte_nsn.1.0.xsd"') EPS_BEARER_STP_COM_INI_QCI1,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C36','xmlns="pm/cnf_lte_nsn.1.0.xsd"') EPS_BEAR_STP_COM_INI_NON_GBR,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C134','xmlns="pm/cnf_lte_nsn.1.0.xsd"') ENB_EPS_BEAR_REL_REQ_R_QCI1,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C161','xmlns="pm/cnf_lte_nsn.1.0.xsd"') ENB_EPS_BEAR_REL_REQ_RD_QCI1,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C162','xmlns="pm/cnf_lte_nsn.1.0.xsd"') EPS_BEARER_STP_ATT_INI_QCI_2,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C163','xmlns="pm/cnf_lte_nsn.1.0.xsd"') EPS_BEARER_STP_ATT_INI_QCI_3,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C164','xmlns="pm/cnf_lte_nsn.1.0.xsd"') EPS_BEARER_STP_ATT_INI_QCI_4,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C165','xmlns="pm/cnf_lte_nsn.1.0.xsd"') EPS_BEARER_STP_ATT_ADD_QCI_2,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C166','xmlns="pm/cnf_lte_nsn.1.0.xsd"') EPS_BEARER_STP_ATT_ADD_QCI_3,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C167','xmlns="pm/cnf_lte_nsn.1.0.xsd"') EPS_BEARER_STP_ATT_ADD_QCI_4,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C168','xmlns="pm/cnf_lte_nsn.1.0.xsd"') EPS_BEARER_STP_COM_INI_QCI_2,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C169','xmlns="pm/cnf_lte_nsn.1.0.xsd"') EPS_BEARER_STP_COM_INI_QCI_3,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C170','xmlns="pm/cnf_lte_nsn.1.0.xsd"') EPS_BEARER_STP_COM_INI_QCI_4,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C171','xmlns="pm/cnf_lte_nsn.1.0.xsd"') EPS_BEARER_STP_COM_ADD_QCI_2,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C172','xmlns="pm/cnf_lte_nsn.1.0.xsd"') EPS_BEARER_STP_COM_ADD_QCI_3,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C173','xmlns="pm/cnf_lte_nsn.1.0.xsd"') EPS_BEARER_STP_COM_ADD_QCI_4,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C174','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PRE_EMPT_GBR_BEARER,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C175','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PRE_EMPT_NON_GBR_BEARER,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C176','xmlns="pm/cnf_lte_nsn.1.0.xsd"') ERAB_REL_ENB_ACT_QCI1,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C177','xmlns="pm/cnf_lte_nsn.1.0.xsd"') ERAB_REL_ENB_ACT_QCI2,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C178','xmlns="pm/cnf_lte_nsn.1.0.xsd"') ERAB_REL_ENB_ACT_QCI3,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C179','xmlns="pm/cnf_lte_nsn.1.0.xsd"') ERAB_REL_ENB_ACT_QCI4,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C180','xmlns="pm/cnf_lte_nsn.1.0.xsd"') ERAB_REL_ENB_ACT_NON_GBR,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C181','xmlns="pm/cnf_lte_nsn.1.0.xsd"') ERAB_IN_SESSION_TIME_QCI1,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C182','xmlns="pm/cnf_lte_nsn.1.0.xsd"') ERAB_IN_SESSION_TIME_QCI2,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C183','xmlns="pm/cnf_lte_nsn.1.0.xsd"') ERAB_IN_SESSION_TIME_QCI3,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C184','xmlns="pm/cnf_lte_nsn.1.0.xsd"') ERAB_IN_SESSION_TIME_QCI4,
    extractValue(value(x),'/PMMOResult/PMTarget/M8006C185','xmlns="pm/cnf_lte_nsn.1.0.xsd"')ERAB_IN_SESSION_TIME_NON_GBR
    
  
     FROM t,TABLE(XMLSequence(extract(t.xmlcol,'/OMeS/PMSetup/PMMOResult','xmlns="pm/cnf_lte_nsn.1.0.xsd"'))) x;
    
    -- update table STATUS_PROCESS_ETL whith information the xml status 1: processed.
   update STATUS_PROCESS_ETL set status ='1' where filename = p_file_name;   
   return_result := 1 ;
   return return_result;
  
   EXCEPTION
  WHEN OTHERS THEN
    raise_application_error(-20001,'An error has been found - '||SQLCODE||' -ERROR- '||SQLERRM);
    -- update table STATUS_PROCESS_ETL whith information the xml status 2: error processed.
   update STATUS_PROCESS_ETL set status ='2' where filename = p_file_name;   
   return_result := 2 ;
   return return_result;
  COMMIT;    
END parser_LTE_EPS_Bearer;

  /* parse xml with LTE_Pwr_and_Qual_UL measurement and load in a database*/
FUNCTION parser_LTE_Pwr_and_Qual_UL(
    p_local_dir        IN VARCHAR2,
    p_file_name        IN VARCHAR2)
    RETURN INTEGER
IS
   return_result INTEGER;              -- 2: error procesed, 1: ok procesed   
BEGIN
    
   
 INSERT INTO noklte_ps_lpqul_mnc1_raw
 (INT_ID,CO_NAME,MRBTS_ID,LNBTS_ID,LNCEL_ID,MCC_ID,MNC_ID,PERIOD_START_TIME,PERIOD_DURATION,PERIOD_DURATION_SUM,RSSI_PUCCH_MIN,
 RSSI_PUCCH_MAX,RSSI_PUCCH_AVG,RSSI_PUSCH_MIN,RSSI_PUSCH_MAX,RSSI_PUSCH_AVG,RSSI_PUCCH_LEVEL_01,RSSI_PUCCH_LEVEL_02,
 RSSI_PUCCH_LEVEL_03,RSSI_PUCCH_LEVEL_04,RSSI_PUCCH_LEVEL_05,RSSI_PUCCH_LEVEL_06,RSSI_PUCCH_LEVEL_07,RSSI_PUCCH_LEVEL_08,
 RSSI_PUCCH_LEVEL_09,RSSI_PUCCH_LEVEL_10,RSSI_PUCCH_LEVEL_11,RSSI_PUCCH_LEVEL_12,RSSI_PUCCH_LEVEL_13,RSSI_PUCCH_LEVEL_14,
 RSSI_PUCCH_LEVEL_15,RSSI_PUCCH_LEVEL_16,RSSI_PUCCH_LEVEL_17,RSSI_PUCCH_LEVEL_18,RSSI_PUCCH_LEVEL_19,RSSI_PUCCH_LEVEL_20,
 RSSI_PUCCH_LEVEL_21,RSSI_PUCCH_LEVEL_22,RSSI_PUSCH_LEVEL_01,RSSI_PUSCH_LEVEL_02,RSSI_PUSCH_LEVEL_03,RSSI_PUSCH_LEVEL_04,
 RSSI_PUSCH_LEVEL_05,RSSI_PUSCH_LEVEL_06,RSSI_PUSCH_LEVEL_07,RSSI_PUSCH_LEVEL_08,RSSI_PUSCH_LEVEL_09,RSSI_PUSCH_LEVEL_10,
 RSSI_PUSCH_LEVEL_11,RSSI_PUSCH_LEVEL_12,RSSI_PUSCH_LEVEL_13,RSSI_PUSCH_LEVEL_14,RSSI_PUSCH_LEVEL_15,RSSI_PUSCH_LEVEL_16,
 RSSI_PUSCH_LEVEL_17,RSSI_PUSCH_LEVEL_18,RSSI_PUSCH_LEVEL_19,RSSI_PUSCH_LEVEL_20,RSSI_PUSCH_LEVEL_21,RSSI_PUSCH_LEVEL_22,
 UE_PWR_HEADROOM_PUSCH_LEVEL1,UE_PWR_HEADROOM_PUSCH_LEVEL2,UE_PWR_HEADROOM_PUSCH_LEVEL3,UE_PWR_HEADROOM_PUSCH_LEVEL4,
 UE_PWR_HEADROOM_PUSCH_LEVEL5,UE_PWR_HEADROOM_PUSCH_LEVEL6,UE_PWR_HEADROOM_PUSCH_LEVEL7,UE_PWR_HEADROOM_PUSCH_LEVEL8,
 UE_PWR_HEADROOM_PUSCH_LEVEL9,UE_PWR_HEADROOM_PUSCH_LEVEL10,UE_PWR_HEADROOM_PUSCH_LEVEL11,UE_PWR_HEADROOM_PUSCH_LEVEL12,
 UE_PWR_HEADROOM_PUSCH_LEVEL13,UE_PWR_HEADROOM_PUSCH_LEVEL14,UE_PWR_HEADROOM_PUSCH_LEVEL15,UE_PWR_HEADROOM_PUSCH_LEVEL16,
 UE_PWR_HEADROOM_PUSCH_LEVEL17,UE_PWR_HEADROOM_PUSCH_LEVEL18,UE_PWR_HEADROOM_PUSCH_LEVEL19,UE_PWR_HEADROOM_PUSCH_LEVEL20,
 UE_PWR_HEADROOM_PUSCH_LEVEL21,UE_PWR_HEADROOM_PUSCH_LEVEL22,UE_PWR_HEADROOM_PUSCH_LEVEL23,UE_PWR_HEADROOM_PUSCH_LEVEL24,
 UE_PWR_HEADROOM_PUSCH_LEVEL25,UE_PWR_HEADROOM_PUSCH_LEVEL26,UE_PWR_HEADROOM_PUSCH_LEVEL27,UE_PWR_HEADROOM_PUSCH_LEVEL28,
 UE_PWR_HEADROOM_PUSCH_LEVEL29,UE_PWR_HEADROOM_PUSCH_LEVEL30,UE_PWR_HEADROOM_PUSCH_LEVEL31,UE_PWR_HEADROOM_PUSCH_LEVEL32,
 UE_PWR_HEADROOM_PUSCH_MIN,UE_PWR_HEADROOM_PUSCH_MAX,UE_PWR_HEADROOM_PUSCH_AVG,SINR_PUCCH_MIN,SINR_PUCCH_MAX,SINR_PUCCH_AVG,
 SINR_PUSCH_MIN,SINR_PUSCH_MAX,SINR_PUSCH_AVG,SINR_PUCCH_LEVEL_1,SINR_PUCCH_LEVEL_2,SINR_PUCCH_LEVEL_3,SINR_PUCCH_LEVEL_4,
 SINR_PUCCH_LEVEL_5,SINR_PUCCH_LEVEL_6,SINR_PUCCH_LEVEL_7,SINR_PUCCH_LEVEL_8,SINR_PUCCH_LEVEL_9,SINR_PUCCH_LEVEL_10,
 SINR_PUCCH_LEVEL_11,SINR_PUCCH_LEVEL_12,SINR_PUCCH_LEVEL_13,SINR_PUCCH_LEVEL_14,SINR_PUCCH_LEVEL_15,SINR_PUCCH_LEVEL_16,
 SINR_PUCCH_LEVEL_17,SINR_PUCCH_LEVEL_18,SINR_PUCCH_LEVEL_19,SINR_PUCCH_LEVEL_20,SINR_PUCCH_LEVEL_21,SINR_PUCCH_LEVEL_22,
 SINR_PUSCH_LEVEL_1,SINR_PUSCH_LEVEL_2,SINR_PUSCH_LEVEL_3,SINR_PUSCH_LEVEL_4,SINR_PUSCH_LEVEL_5,SINR_PUSCH_LEVEL_6,
 SINR_PUSCH_LEVEL_7,SINR_PUSCH_LEVEL_8,SINR_PUSCH_LEVEL_9,SINR_PUSCH_LEVEL_10,SINR_PUSCH_LEVEL_11,SINR_PUSCH_LEVEL_12,
 SINR_PUSCH_LEVEL_13,SINR_PUSCH_LEVEL_14,SINR_PUSCH_LEVEL_15,SINR_PUSCH_LEVEL_16,SINR_PUSCH_LEVEL_17,SINR_PUSCH_LEVEL_18,
 SINR_PUSCH_LEVEL_19,SINR_PUSCH_LEVEL_20,SINR_PUSCH_LEVEL_21,SINR_PUSCH_LEVEL_22,UL_AMC_UPGRADE,UL_AMC_DOWNGRADE,
 RSSI_CELL_PUCCH_MIN,RSSI_CELL_PUCCH_MAX,RSSI_CELL_PUCCH_MEAN,RSSI_CELL_PUCCH_LEVEL_1,RSSI_CELL_PUCCH_LEVEL_2,
 RSSI_CELL_PUCCH_LEVEL_3,RSSI_CELL_PUCCH_LEVEL_4,RSSI_CELL_PUCCH_LEVEL_5,RSSI_CELL_PUCCH_LEVEL_6,RSSI_CELL_PUCCH_LEVEL_7,
 RSSI_CELL_PUCCH_LEVEL_8,RSSI_CELL_PUCCH_LEVEL_9,RSSI_CELL_PUCCH_LEVEL_10,RSSI_CELL_PUCCH_LEVEL_11,RSSI_CELL_PUCCH_LEVEL_12,
 RSSI_CELL_PUCCH_LEVEL_13,RSSI_CELL_PUCCH_LEVEL_14,RSSI_CELL_PUCCH_LEVEL_15,RSSI_CELL_PUCCH_LEVEL_16,RSSI_CELL_PUCCH_LEVEL_17,
 RSSI_CELL_PUCCH_LEVEL_18,RSSI_CELL_PUCCH_LEVEL_19,RSSI_CELL_PUCCH_LEVEL_20,RSSI_CELL_PUCCH_LEVEL_21,RSSI_CELL_PUCCH_LEVEL_22,
 RSSI_CELL_PUSCH_MIN,RSSI_CELL_PUSCH_MAX,RSSI_CELL_PUSCH_MEAN,RSSI_CELL_PUSCH_LEVEL_1,RSSI_CELL_PUSCH_LEVEL_2,RSSI_CELL_PUSCH_LEVEL_3,
 RSSI_CELL_PUSCH_LEVEL_4,RSSI_CELL_PUSCH_LEVEL_5,RSSI_CELL_PUSCH_LEVEL_6,RSSI_CELL_PUSCH_LEVEL_7,RSSI_CELL_PUSCH_LEVEL_8,
 RSSI_CELL_PUSCH_LEVEL_9,RSSI_CELL_PUSCH_LEVEL_10,RSSI_CELL_PUSCH_LEVEL_11,RSSI_CELL_PUSCH_LEVEL_12,RSSI_CELL_PUSCH_LEVEL_13,
 RSSI_CELL_PUSCH_LEVEL_14,RSSI_CELL_PUSCH_LEVEL_15,RSSI_CELL_PUSCH_LEVEL_16,RSSI_CELL_PUSCH_LEVEL_17,RSSI_CELL_PUSCH_LEVEL_18,
 RSSI_CELL_PUSCH_LEVEL_19,RSSI_CELL_PUSCH_LEVEL_20,RSSI_CELL_PUSCH_LEVEL_21,RSSI_CELL_PUSCH_LEVEL_22,SINR_CELL_PUCCH_MIN,
 SINR_CELL_PUCCH_MAX,SINR_CELL_PUCCH_MEAN,SINR_CELL_PUCCH_LEVEL_1,SINR_CELL_PUCCH_LEVEL_2,SINR_CELL_PUCCH_LEVEL_3,
 SINR_CELL_PUCCH_LEVEL_4,SINR_CELL_PUCCH_LEVEL_5,SINR_CELL_PUCCH_LEVEL_6,SINR_CELL_PUCCH_LEVEL_7,SINR_CELL_PUCCH_LEVEL_8,
 SINR_CELL_PUCCH_LEVEL_9,SINR_CELL_PUCCH_LEVEL_10,SINR_CELL_PUCCH_LEVEL_11,SINR_CELL_PUCCH_LEVEL_12,SINR_CELL_PUCCH_LEVEL_13,
 SINR_CELL_PUCCH_LEVEL_14,SINR_CELL_PUCCH_LEVEL_15,SINR_CELL_PUCCH_LEVEL_16,SINR_CELL_PUCCH_LEVEL_17,SINR_CELL_PUCCH_LEVEL_18,
 SINR_CELL_PUCCH_LEVEL_19,SINR_CELL_PUCCH_LEVEL_20,SINR_CELL_PUCCH_LEVEL_21,SINR_CELL_PUCCH_LEVEL_22,SINR_CELL_PUSCH_MIN,SINR_CELL_PUSCH_MAX,
 SINR_CELL_PUSCH_MEAN,SINR_CELL_PUSCH_LEVEL_1,SINR_CELL_PUSCH_LEVEL_2,SINR_CELL_PUSCH_LEVEL_3,SINR_CELL_PUSCH_LEVEL_4,SINR_CELL_PUSCH_LEVEL_5,
 SINR_CELL_PUSCH_LEVEL_6,SINR_CELL_PUSCH_LEVEL_7,SINR_CELL_PUSCH_LEVEL_8,SINR_CELL_PUSCH_LEVEL_9,SINR_CELL_PUSCH_LEVEL_10,SINR_CELL_PUSCH_LEVEL_11,
 SINR_CELL_PUSCH_LEVEL_12,SINR_CELL_PUSCH_LEVEL_13,SINR_CELL_PUSCH_LEVEL_14,SINR_CELL_PUSCH_LEVEL_15,SINR_CELL_PUSCH_LEVEL_16,
 SINR_CELL_PUSCH_LEVEL_17,SINR_CELL_PUSCH_LEVEL_18,SINR_CELL_PUSCH_LEVEL_19,SINR_CELL_PUSCH_LEVEL_20,SINR_CELL_PUSCH_LEVEL_21,SINR_CELL_PUSCH_LEVEL_22)
 
 
WITH t AS (SELECT xmltype(bfilename(p_local_dir,p_file_name), nls_charset_id('AL32UTF8')) xmlcol FROM dual)
SELECT
    (select INT_ID from MULTIVENDOR_OBJECTS where OBJECT_CLASS = 3130 and OBJECT_NRO = substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNCEL-[0-9]*'),7)) INT_ID,
    (select NAME from multivendor_objects where OBJECT_CLASS = 3130 and OBJECT_NRO = substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNCEL-[0-9]*'),7)) CO_NAME,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'MRBTS-[0-9]*'),7) MRBTS_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNBTS-[0-9]*'),7) LNBTS_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNCEL-[0-9]*'),7) LNCEL_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'MCC-[0-9]*'),5) MCC_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'MNC-[0-9]*'),5) MNC_ID,
    TO_DATE(REGEXP_REPLACE(REGEXP_SUBSTR(extract(t.xmlcol, '//@startTime','xmlns="pm/cnf_lte_nsn.1.0.xsd"'),'[0-9]*[-][0-9]*[-][0-9]*[^t][0-9]*[:][0-9]*[:][0-9]*'),'(T)', ' '),'YYYY-MM-DD HH24:MI:SS ') PERIOD_START_TIME,
    extract(t.xmlcol, '//@interval','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getNumberVal() PERIOD_DURATION,
    extract(t.xmlcol, '//@interval','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getNumberVal() PERIOD_DURATION_SUM,
    
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C0','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUCCH_MIN,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C1','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUCCH_MAX,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C2','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUCCH_AVG,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C3','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUSCH_MIN,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C4','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUSCH_MAX,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C5','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUSCH_AVG,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C6','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUCCH_LEVEL_01,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C7','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUCCH_LEVEL_02,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C8','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUCCH_LEVEL_03,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C9','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUCCH_LEVEL_04,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C10','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUCCH_LEVEL_05,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C11','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUCCH_LEVEL_06,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C12','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUCCH_LEVEL_07,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C13','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUCCH_LEVEL_08,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C14','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUCCH_LEVEL_09,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C15','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUCCH_LEVEL_10,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C16','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUCCH_LEVEL_11,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C17','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUCCH_LEVEL_12,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C18','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUCCH_LEVEL_13,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C19','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUCCH_LEVEL_14,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C20','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUCCH_LEVEL_15,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C21','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUCCH_LEVEL_16,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C22','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUCCH_LEVEL_17,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C23','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUCCH_LEVEL_18,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C24','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUCCH_LEVEL_19,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C25','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUCCH_LEVEL_20,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C26','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUCCH_LEVEL_21,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C27','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUCCH_LEVEL_22,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C28','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUSCH_LEVEL_01,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C29','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUSCH_LEVEL_02,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C30','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUSCH_LEVEL_03,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C31','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUSCH_LEVEL_04,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C32','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUSCH_LEVEL_05,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C33','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUSCH_LEVEL_06,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C34','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUSCH_LEVEL_07,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C35','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUSCH_LEVEL_08,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C36','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUSCH_LEVEL_09,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C37','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUSCH_LEVEL_10,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C38','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUSCH_LEVEL_11,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C39','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUSCH_LEVEL_12,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C40','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUSCH_LEVEL_13,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C41','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUSCH_LEVEL_14,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C42','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUSCH_LEVEL_15,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C43','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUSCH_LEVEL_16,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C44','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUSCH_LEVEL_17,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C45','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUSCH_LEVEL_18,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C46','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUSCH_LEVEL_19,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C47','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUSCH_LEVEL_20,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C48','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUSCH_LEVEL_21,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C48','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_PUSCH_LEVEL_22,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C54','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_PWR_HEADROOM_PUSCH_LEVEL1,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C55','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_PWR_HEADROOM_PUSCH_LEVEL2,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C56','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_PWR_HEADROOM_PUSCH_LEVEL3,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C57','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_PWR_HEADROOM_PUSCH_LEVEL4,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C58','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_PWR_HEADROOM_PUSCH_LEVEL5,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C59','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_PWR_HEADROOM_PUSCH_LEVEL6,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C60','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_PWR_HEADROOM_PUSCH_LEVEL7,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C61','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_PWR_HEADROOM_PUSCH_LEVEL8,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C62','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_PWR_HEADROOM_PUSCH_LEVEL9,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C63','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_PWR_HEADROOM_PUSCH_LEVEL10,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C64','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_PWR_HEADROOM_PUSCH_LEVEL11,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C65','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_PWR_HEADROOM_PUSCH_LEVEL12,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C66','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_PWR_HEADROOM_PUSCH_LEVEL13,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C67','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_PWR_HEADROOM_PUSCH_LEVEL14,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C68','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_PWR_HEADROOM_PUSCH_LEVEL15,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C69','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_PWR_HEADROOM_PUSCH_LEVEL16,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C70','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_PWR_HEADROOM_PUSCH_LEVEL17,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C71','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_PWR_HEADROOM_PUSCH_LEVEL18,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C72','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_PWR_HEADROOM_PUSCH_LEVEL19,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C73','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_PWR_HEADROOM_PUSCH_LEVEL20,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C74','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_PWR_HEADROOM_PUSCH_LEVEL21,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C75','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_PWR_HEADROOM_PUSCH_LEVEL22,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C76','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_PWR_HEADROOM_PUSCH_LEVEL23,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C77','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_PWR_HEADROOM_PUSCH_LEVEL24,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C78','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_PWR_HEADROOM_PUSCH_LEVEL25,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C79','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_PWR_HEADROOM_PUSCH_LEVEL26,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C80','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_PWR_HEADROOM_PUSCH_LEVEL27,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C81','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_PWR_HEADROOM_PUSCH_LEVEL28,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C82','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_PWR_HEADROOM_PUSCH_LEVEL29,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C83','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_PWR_HEADROOM_PUSCH_LEVEL30,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C84','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_PWR_HEADROOM_PUSCH_LEVEL31,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C85','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_PWR_HEADROOM_PUSCH_LEVEL32,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C87','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_PWR_HEADROOM_PUSCH_MIN,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C88','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_PWR_HEADROOM_PUSCH_MAX,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C89','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_PWR_HEADROOM_PUSCH_AVG,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C90','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_PUCCH_MIN,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C91','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_PUCCH_MAX,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C92','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_PUCCH_AVG,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C93','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_PUSCH_MIN,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C94','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_PUSCH_MAX,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C95','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_PUSCH_AVG,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C96','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_PUCCH_LEVEL_1,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C97','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_PUCCH_LEVEL_2,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C98','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_PUCCH_LEVEL_3,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C99','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_PUCCH_LEVEL_4,
    extractValue(value(x),'/PMMOResult/PMTarget/M8005C100','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_PUCCH_LEVEL_5,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C101','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_PUCCH_LEVEL_6,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C102','xmlns="pm/cnf_lte_nsn.1.0.xsd"')SINR_PUCCH_LEVEL_7,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C103','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_PUCCH_LEVEL_8,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C104','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_PUCCH_LEVEL_9,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C105','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_PUCCH_LEVEL_10,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C106','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_PUCCH_LEVEL_11,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C107','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_PUCCH_LEVEL_12,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C108','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_PUCCH_LEVEL_13,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C109','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_PUCCH_LEVEL_14,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C110','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_PUCCH_LEVEL_15,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C111','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_PUCCH_LEVEL_16,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C112','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_PUCCH_LEVEL_17,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C113','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_PUCCH_LEVEL_18,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C114','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_PUCCH_LEVEL_19,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C115','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_PUCCH_LEVEL_20,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C116','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_PUCCH_LEVEL_21,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C117','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_PUCCH_LEVEL_22,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C118','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_PUSCH_LEVEL_1,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C119','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_PUSCH_LEVEL_2,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C120','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_PUSCH_LEVEL_3,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C121','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_PUSCH_LEVEL_4,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C122','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_PUSCH_LEVEL_5,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C123','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_PUSCH_LEVEL_6,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C124','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_PUSCH_LEVEL_7,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C125','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_PUSCH_LEVEL_8,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C126','xmlns="pm/cnf_lte_nsn.1.0.xsd"')  SINR_PUSCH_LEVEL_9,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C127','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_PUSCH_LEVEL_10,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C128','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_PUSCH_LEVEL_11,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C129','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_PUSCH_LEVEL_12,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C130','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_PUSCH_LEVEL_13,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C131','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_PUSCH_LEVEL_14,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C132','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_PUSCH_LEVEL_15,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C133','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_PUSCH_LEVEL_16,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C134','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_PUSCH_LEVEL_17,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C135','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_PUSCH_LEVEL_18,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C136','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_PUSCH_LEVEL_19,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C137','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_PUSCH_LEVEL_20,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C138','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_PUSCH_LEVEL_21,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C139','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_PUSCH_LEVEL_22,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C140','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UL_AMC_UPGRADE,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C141','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UL_AMC_DOWNGRADE,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C206','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUCCH_MIN,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C207','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUCCH_MAX,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C208','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUCCH_MEAN,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C209','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUCCH_LEVEL_1,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C210','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUCCH_LEVEL_2,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C211','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUCCH_LEVEL_3,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C212','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUCCH_LEVEL_4,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C213','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUCCH_LEVEL_5,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C214','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUCCH_LEVEL_6,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C215','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUCCH_LEVEL_7,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C216','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUCCH_LEVEL_8,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C217','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUCCH_LEVEL_9,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C218','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUCCH_LEVEL_10,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C219','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUCCH_LEVEL_11,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C220','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUCCH_LEVEL_12,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C221','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUCCH_LEVEL_13,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C222','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUCCH_LEVEL_14,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C223','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUCCH_LEVEL_15,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C224','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUCCH_LEVEL_16,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C225','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUCCH_LEVEL_17,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C226','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUCCH_LEVEL_18,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C227','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUCCH_LEVEL_19,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C228','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUCCH_LEVEL_20,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C229','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUCCH_LEVEL_21,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C230','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUCCH_LEVEL_22,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C231','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUSCH_MIN,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C232','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUSCH_MAX,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C233','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUSCH_MEAN,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C234','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUSCH_LEVEL_1,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C235','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUSCH_LEVEL_2,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C236','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUSCH_LEVEL_3,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C237','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUSCH_LEVEL_4,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C238','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUSCH_LEVEL_5,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C239','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUSCH_LEVEL_6,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C240','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUSCH_LEVEL_7,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C241','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUSCH_LEVEL_8,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C242','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUSCH_LEVEL_9,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C243','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUSCH_LEVEL_10,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C244','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUSCH_LEVEL_11,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C245','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUSCH_LEVEL_12,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C246','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUSCH_LEVEL_13,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C247','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUSCH_LEVEL_14,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C248','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUSCH_LEVEL_15,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C249','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUSCH_LEVEL_16,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C250','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUSCH_LEVEL_17,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C251','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUSCH_LEVEL_18,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C252','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUSCH_LEVEL_19,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C253','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUSCH_LEVEL_20,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C254','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUSCH_LEVEL_21,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C255','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RSSI_CELL_PUSCH_LEVEL_22,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C256','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_CELL_PUCCH_MIN,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C257','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_CELL_PUCCH_MAX,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C258','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_CELL_PUCCH_MEAN,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C259','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_CELL_PUCCH_LEVEL_1,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C260','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_CELL_PUCCH_LEVEL_2,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C261','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_CELL_PUCCH_LEVEL_3,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C262','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_CELL_PUCCH_LEVEL_4,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C263','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_CELL_PUCCH_LEVEL_5,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C264','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_CELL_PUCCH_LEVEL_6,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C265','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_CELL_PUCCH_LEVEL_7,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C266','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_CELL_PUCCH_LEVEL_8,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C267','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_CELL_PUCCH_LEVEL_9,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C268','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_CELL_PUCCH_LEVEL_10,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C269','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_CELL_PUCCH_LEVEL_11,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C270','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_CELL_PUCCH_LEVEL_12,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C271','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_CELL_PUCCH_LEVEL_13,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C272','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_CELL_PUCCH_LEVEL_14,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C273','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_CELL_PUCCH_LEVEL_15,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C274','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_CELL_PUCCH_LEVEL_16,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C275','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_CELL_PUCCH_LEVEL_17,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C276','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_CELL_PUCCH_LEVEL_18,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C277','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_CELL_PUCCH_LEVEL_19,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C278','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_CELL_PUCCH_LEVEL_20,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C279','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_CELL_PUCCH_LEVEL_21,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C280','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_CELL_PUCCH_LEVEL_22,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C281','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_CELL_PUSCH_MIN,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C282','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_CELL_PUSCH_MAX,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C283','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_CELL_PUSCH_MEAN,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C284','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_CELL_PUSCH_LEVEL_1,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C285','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_CELL_PUSCH_LEVEL_2,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C286','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_CELL_PUSCH_LEVEL_3,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C287','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_CELL_PUSCH_LEVEL_4,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C288','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_CELL_PUSCH_LEVEL_5,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C289','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_CELL_PUSCH_LEVEL_6,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C290','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_CELL_PUSCH_LEVEL_7,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C291','xmlns="pm/cnf_lte_nsn.1.0.xsd"')SINR_CELL_PUSCH_LEVEL_8,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C292','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_CELL_PUSCH_LEVEL_9,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C293','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_CELL_PUSCH_LEVEL_10,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C294','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_CELL_PUSCH_LEVEL_11,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C295','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_CELL_PUSCH_LEVEL_12,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C296','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_CELL_PUSCH_LEVEL_13,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C297','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_CELL_PUSCH_LEVEL_14,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C298','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_CELL_PUSCH_LEVEL_15,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C299','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_CELL_PUSCH_LEVEL_16,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C300','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_CELL_PUSCH_LEVEL_17,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C301','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_CELL_PUSCH_LEVEL_18,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C302','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_CELL_PUSCH_LEVEL_19,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C303','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_CELL_PUSCH_LEVEL_20,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C304','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_CELL_PUSCH_LEVEL_21,
	extractValue(value(x),'/PMMOResult/PMTarget/M8005C305','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SINR_CELL_PUSCH_LEVEL_22
	
    FROM t,TABLE(XMLSequence(extract(t.xmlcol,'/OMeS/PMSetup/PMMOResult','xmlns="pm/cnf_lte_nsn.1.0.xsd"'))) x;
    
    -- update table STATUS_PROCESS_ETL whith information the xml status 1: processed.
   update STATUS_PROCESS_ETL set status ='1' where filename = p_file_name;   
   return_result := 1 ;
   return return_result;
  
   EXCEPTION
  WHEN OTHERS THEN
    raise_application_error(-20001,'An error has been found - '||SQLCODE||' -ERROR- '||SQLERRM);
    -- update table STATUS_PROCESS_ETL whith information the xml status 2: error processed.
   update STATUS_PROCESS_ETL set status ='2' where filename = p_file_name;   
   return_result := 2 ;
   return return_result;
  COMMIT;    
END parser_LTE_Pwr_and_Qual_UL;

  /* parse xml with LTE_Cell_Avail measurement and load in a database*/
FUNCTION parser_LTE_Cell_Avail(
    p_local_dir        IN VARCHAR2,
    p_file_name        IN VARCHAR2)
    RETURN INTEGER
IS
   return_result INTEGER;              -- 2: error procesed, 1: ok procesed   
BEGIN
    
   
 INSERT INTO noklte_ps_lcelav_mnc1_raw
 (INT_ID,CO_NAME,MRBTS_ID,LNBTS_ID,LNCEL_ID,MCC_ID,MNC_ID,PERIOD_START_TIME,PERIOD_DURATION,PERIOD_DURATION_SUM,CHNG_TO_CELL_AVAIL,
 CHNG_TO_CELL_PLAN_UNAVAIL,CHNG_TO_CELL_UNPLAN_UNAVAIL,SAMPLES_CELL_AVAIL,SAMPLES_CELL_PLAN_UNAVAIL,SAMPLES_CELL_UNPLAN_UNAVAIL,
 DENOM_CELL_AVAIL)
 
 
WITH t AS (SELECT xmltype(bfilename(p_local_dir,p_file_name), nls_charset_id('AL32UTF8')) xmlcol FROM dual)
SELECT
    (select INT_ID from MULTIVENDOR_OBJECTS where OBJECT_CLASS = 3130 and OBJECT_NRO = substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNCEL-[0-9]*'),7)) INT_ID,
    (select NAME from multivendor_objects where OBJECT_CLASS = 3130 and OBJECT_NRO = substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNCEL-[0-9]*'),7)) CO_NAME,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'MRBTS-[0-9]*'),7) MRBTS_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNBTS-[0-9]*'),7) LNBTS_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNCEL-[0-9]*'),7) LNCEL_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'MCC-[0-9]*'),5) MCC_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'MNC-[0-9]*'),5) MNC_ID,
    TO_DATE(REGEXP_REPLACE(REGEXP_SUBSTR(extract(t.xmlcol, '//@startTime','xmlns="pm/cnf_lte_nsn.1.0.xsd"'),'[0-9]*[-][0-9]*[-][0-9]*[^t][0-9]*[:][0-9]*[:][0-9]*'),'(T)', ' '),'YYYY-MM-DD HH24:MI:SS ') PERIOD_START_TIME,
    extract(t.xmlcol, '//@interval','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getNumberVal() PERIOD_DURATION,
    extract(t.xmlcol, '//@interval','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getNumberVal() PERIOD_DURATION_SUM,
    
    extractValue(value(x),'/PMMOResult/PMTarget/M8020C0','xmlns="pm/cnf_lte_nsn.1.0.xsd"') CHNG_TO_CELL_AVAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M8020C1','xmlns="pm/cnf_lte_nsn.1.0.xsd"')CHNG_TO_CELL_PLAN_UNAVAIL,
	extractValue(value(x),'/PMMOResult/PMTarget/M8020C2','xmlns="pm/cnf_lte_nsn.1.0.xsd"') CHNG_TO_CELL_UNPLAN_UNAVAIL,
	extractValue(value(x),'/PMMOResult/PMTarget/M8020C3','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SAMPLES_CELL_AVAIL,
	extractValue(value(x),'/PMMOResult/PMTarget/M8020C4','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SAMPLES_CELL_PLAN_UNAVAIL,
	extractValue(value(x),'/PMMOResult/PMTarget/M8020C5','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SAMPLES_CELL_UNPLAN_UNAVAIL,
	extractValue(value(x),'/PMMOResult/PMTarget/M8020C6','xmlns="pm/cnf_lte_nsn.1.0.xsd"') DENOM_CELL_AVAIL
	
    FROM t,TABLE(XMLSequence(extract(t.xmlcol,'/OMeS/PMSetup/PMMOResult','xmlns="pm/cnf_lte_nsn.1.0.xsd"'))) x;
    
    -- update table STATUS_PROCESS_ETL whith information the xml status 1: processed.
   update STATUS_PROCESS_ETL set status ='1' where filename = p_file_name;   
   return_result := 1 ;
   return return_result;
  
   EXCEPTION
  WHEN OTHERS THEN
    raise_application_error(-20001,'An error has been found - '||SQLCODE||' -ERROR- '||SQLERRM);
    -- update table STATUS_PROCESS_ETL whith information the xml status 2: error processed.
   update STATUS_PROCESS_ETL set status ='2' where filename = p_file_name;   
   return_result := 2 ;
   return return_result;
  COMMIT;    
END parser_LTE_Cell_Avail;

  /* parse xml with LTE_Radio_Bearer measurement and load in a database*/
FUNCTION parser_LTE_Radio_Bearer(
    p_local_dir        IN VARCHAR2,
    p_file_name        IN VARCHAR2)
    RETURN INTEGER
IS
   return_result INTEGER;              -- 2: error procesed, 1: ok procesed   
BEGIN
    
   
 INSERT INTO NOKLTE_PS_LRDB_MNC1_RAW
 (INT_ID,CO_NAME,MRBTS_ID,LNBTS_ID,LNCEL_ID,MCC_ID,MNC_ID,PERIOD_START_TIME,PERIOD_DURATION,PERIOD_DURATION_SUM,DATA_RB_STP_ATT,
 DATA_RB_STP_COMP,DATA_RB_STP_FAIL,RB_REL_REQ_NORM_REL,RB_REL_REQ_DETACH_PROC,RB_REL_REQ_RNL,RB_REL_REQ_OTHER,SRB1_SETUP_ATT,
 SRB1_SETUP_SUCC,SRB1_SETUP_FAIL,SRB2_SETUP_ATT,SRB2_SETUP_SUCC,SRB2_SETUP_FAIL,RB_REL_REQ_RNL_REDIR)
 
 
WITH t AS (SELECT xmltype(bfilename(p_local_dir,p_file_name), nls_charset_id('AL32UTF8')) xmlcol FROM dual)
SELECT
    (select INT_ID from MULTIVENDOR_OBJECTS where OBJECT_CLASS = 3130 and valid_finish_date > sysdate and OBJECT_NRO = substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNCEL-[0-9]*'),7)) INT_ID,
    (select NAME from multivendor_objects where OBJECT_CLASS = 3130 and valid_finish_date > sysdate and OBJECT_NRO = substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNCEL-[0-9]*'),7)) CO_NAME,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'MRBTS-[0-9]*'),7) MRBTS_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNBTS-[0-9]*'),7) LNBTS_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNCEL-[0-9]*'),7) LNCEL_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'MCC-[0-9]*'),5) MCC_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'MNC-[0-9]*'),5) MNC_ID,
    TO_DATE(REGEXP_REPLACE(REGEXP_SUBSTR(extract(t.xmlcol, '//@startTime','xmlns="pm/cnf_lte_nsn.1.0.xsd"'),'[0-9]*[-][0-9]*[-][0-9]*[^t][0-9]*[:][0-9]*[:][0-9]*'),'(T)', ' '),'YYYY-MM-DD HH24:MI:SS ') PERIOD_START_TIME,
    extract(t.xmlcol, '//@interval','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getNumberVal() PERIOD_DURATION,
    extract(t.xmlcol, '//@interval','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getNumberVal() PERIOD_DURATION_SUM,
    
    extractValue(value(x),'/PMMOResult/PMTarget/M8007C0','xmlns="pm/cnf_lte_nsn.1.0.xsd"') DATA_RB_STP_ATT,
    extractValue(value(x),'/PMMOResult/PMTarget/M8007C1','xmlns="pm/cnf_lte_nsn.1.0.xsd"') DATA_RB_STP_COMP,
	extractValue(value(x),'/PMMOResult/PMTarget/M8007C2','xmlns="pm/cnf_lte_nsn.1.0.xsd"') DATA_RB_STP_FAIL,
	extractValue(value(x),'/PMMOResult/PMTarget/M8007C3','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RB_REL_REQ_NORM_REL,
	extractValue(value(x),'/PMMOResult/PMTarget/M8007C4','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RB_REL_REQ_DETACH_PROC,
	extractValue(value(x),'/PMMOResult/PMTarget/M8007C5','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RB_REL_REQ_RNL,
	extractValue(value(x),'/PMMOResult/PMTarget/M8007C6','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RB_REL_REQ_OTHER,
	extractValue(value(x),'/PMMOResult/PMTarget/M8007C7','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SRB1_SETUP_ATT,
	extractValue(value(x),'/PMMOResult/PMTarget/M8007C8','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SRB1_SETUP_SUCC,
	extractValue(value(x),'/PMMOResult/PMTarget/M8007C9','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SRB1_SETUP_FAIL,
	extractValue(value(x),'/PMMOResult/PMTarget/M8007C10','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SRB2_SETUP_ATT,
	extractValue(value(x),'/PMMOResult/PMTarget/M8007C11','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SRB2_SETUP_SUCC,
	extractValue(value(x),'/PMMOResult/PMTarget/M8007C12','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SRB2_SETUP_FAIL,
	extractValue(value(x),'/PMMOResult/PMTarget/M8007C13','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RB_REL_REQ_RNL_REDIR
	
    FROM t,TABLE(XMLSequence(extract(t.xmlcol,'/OMeS/PMSetup/PMMOResult','xmlns="pm/cnf_lte_nsn.1.0.xsd"'))) x;
    COMMIT;
    -- update table STATUS_PROCESS_ETL whith information the xml status 1: processed.
   update STATUS_PROCESS_ETL set status ='1' where filename = p_file_name;
   COMMIT;   
   return_result := 1 ;
   return return_result;
   
   EXCEPTION
  WHEN OTHERS THEN
    raise_application_error(-20001,'Se ha encontrado un error - '||SQLCODE||' -ERROR- '||SQLERRM);
    -- update table STATUS_PROCESS_ETL whith information the xml status 2: error processed.
   update STATUS_PROCESS_ETL set status ='2' where filename = p_file_name;
   COMMIT;    
   return_result := 2 ;
   return return_result;
   
      
END parser_LTE_Radio_Bearer;

  /* parse xml with LTE_Cell_Resource measurement and load in a database*/
FUNCTION parser_LTE_Cell_Resource(
    p_local_dir        IN VARCHAR2,
    p_file_name        IN VARCHAR2)
    RETURN INTEGER
IS
   return_result INTEGER;              -- 2: error procesed, 1: ok procesed   
BEGIN
    
   
 INSERT INTO NOKLTE_PS_LCELLR_MNC1_RAW
 (INT_ID,CO_NAME,MRBTS_ID,LNBTS_ID,LNCEL_ID,MCC_ID,MNC_ID,PERIOD_START_TIME,PERIOD_DURATION,PERIOD_DURATION_SUM,UL_PRB_UTIL_TTI_LEVEL_1,
 UL_PRB_UTIL_TTI_LEVEL_2,UL_PRB_UTIL_TTI_LEVEL_3,UL_PRB_UTIL_TTI_LEVEL_4,UL_PRB_UTIL_TTI_LEVEL_5,UL_PRB_UTIL_TTI_LEVEL_6,
 UL_PRB_UTIL_TTI_LEVEL_7,UL_PRB_UTIL_TTI_LEVEL_8,UL_PRB_UTIL_TTI_LEVEL_9,UL_PRB_UTIL_TTI_LEVEL_10,UL_PRB_UTIL_TTI_MIN,
 UL_PRB_UTIL_TTI_MAX,UL_PRB_UTIL_TTI_MEAN,DL_PRB_UTIL_TTI_LEVEL_1,DL_PRB_UTIL_TTI_LEVEL_2,DL_PRB_UTIL_TTI_LEVEL_3,DL_PRB_UTIL_TTI_LEVEL_4,
 DL_PRB_UTIL_TTI_LEVEL_5,DL_PRB_UTIL_TTI_LEVEL_6,DL_PRB_UTIL_TTI_LEVEL_7,DL_PRB_UTIL_TTI_LEVEL_8,DL_PRB_UTIL_TTI_LEVEL_9,
 DL_PRB_UTIL_TTI_LEVEL_10,DL_PRB_UTIL_TTI_MIN,DL_PRB_UTIL_TTI_MAX,DL_PRB_UTIL_TTI_MEAN,CCE_AVAIL_ACT_TTI,AGG1_USED_PDCCH,AGG2_USED_PDCCH,
 AGG4_USED_PDCCH,AGG8_USED_PDCCH,AGG1_BLOCKED_PDCCH,AGG2_BLOCKED_PDCCH,AGG4_BLOCKED_PDCCH,AGG8_BLOCKED_PDCCH,PRB_USED_UL_TOTAL,
 PRB_USED_PUCCH,PRB_USED_PUSCH,PRB_USED_DL_TOTAL,PRB_USED_PDSCH,UE_PER_UL_TTI_AVG,UE_PER_UL_TTI_MAX,UE_PER_DL_TTI_AVG,UE_PER_DL_TTI_MAX,
 PDCCH_1_OFDM_SYMBOL,PDCCH_2_OFDM_SYMBOLS,PDCCH_3_OFDM_SYMBOLS,TTI_BUNDLING_MODE_UE_AVG,TTI_BUNDLING_GRANTS,TTI_BUNDL_RETENTION_SHORT,
 TTI_BUNDL_RETENTION_MEDIUM,TTI_BUNDL_RETENTION_LONG,CA_SCELL_CONFIG_ATT,CA_SCELL_CONFIG_SUCC,HIGH_CELL_LOAD_LB)
 
 
WITH t AS (SELECT xmltype(bfilename(p_local_dir,p_file_name), nls_charset_id('AL32UTF8')) xmlcol FROM dual)
SELECT
    (SELECT LNCEL_ID FROM objects_sp_lte where lncel_object_class = 3130 and sysdate BETWEEN lncel_valid_start_date and lncel_valid_finish_date and lncel_object_nro= substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNCEL-[0-9]*'),7)) INT_ID,
    (SELECT LNCEL_NAME FROM objects_sp_lte where lncel_object_class = 3130 and sysdate BETWEEN lncel_valid_start_date and lncel_valid_finish_date and lncel_object_nro= substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNCEL-[0-9]*'),7)) CO_NAME,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'MRBTS-[0-9]*'),7) MRBTS_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNBTS-[0-9]*'),7) LNBTS_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNCEL-[0-9]*'),7) LNCEL_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'MCC-[0-9]*'),5) MCC_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'MNC-[0-9]*'),5) MNC_ID,
    TO_DATE(REGEXP_REPLACE(REGEXP_SUBSTR(extract(t.xmlcol, '//@startTime','xmlns="pm/cnf_lte_nsn.1.0.xsd"'),'[0-9]*[-][0-9]*[-][0-9]*[^t][0-9]*[:][0-9]*[:][0-9]*'),'(T)', ' '),'YYYY-MM-DD HH24:MI:SS ') PERIOD_START_TIME,
    extract(t.xmlcol, '//@interval','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getNumberVal() PERIOD_DURATION,
    extract(t.xmlcol, '//@interval','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getNumberVal() PERIOD_DURATION_SUM,
    
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C12','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UL_PRB_UTIL_TTI_LEVEL_1,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C13','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UL_PRB_UTIL_TTI_LEVEL_2,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C14','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UL_PRB_UTIL_TTI_LEVEL_3,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C15','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UL_PRB_UTIL_TTI_LEVEL_4,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C16','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UL_PRB_UTIL_TTI_LEVEL_5,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C17','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UL_PRB_UTIL_TTI_LEVEL_6,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C18','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UL_PRB_UTIL_TTI_LEVEL_7,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C19','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UL_PRB_UTIL_TTI_LEVEL_8,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C20','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UL_PRB_UTIL_TTI_LEVEL_9,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C21','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UL_PRB_UTIL_TTI_LEVEL_10,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C22','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UL_PRB_UTIL_TTI_MIN,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C23','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UL_PRB_UTIL_TTI_MAX,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C24','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UL_PRB_UTIL_TTI_MEAN,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C25','xmlns="pm/cnf_lte_nsn.1.0.xsd"') DL_PRB_UTIL_TTI_LEVEL_1,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C26','xmlns="pm/cnf_lte_nsn.1.0.xsd"') DL_PRB_UTIL_TTI_LEVEL_2,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C27','xmlns="pm/cnf_lte_nsn.1.0.xsd"') DL_PRB_UTIL_TTI_LEVEL_3,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C28','xmlns="pm/cnf_lte_nsn.1.0.xsd"') DL_PRB_UTIL_TTI_LEVEL_4,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C29','xmlns="pm/cnf_lte_nsn.1.0.xsd"') DL_PRB_UTIL_TTI_LEVEL_5,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C30','xmlns="pm/cnf_lte_nsn.1.0.xsd"') DL_PRB_UTIL_TTI_LEVEL_6,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C31','xmlns="pm/cnf_lte_nsn.1.0.xsd"') DL_PRB_UTIL_TTI_LEVEL_7,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C32','xmlns="pm/cnf_lte_nsn.1.0.xsd"') DL_PRB_UTIL_TTI_LEVEL_8,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C33','xmlns="pm/cnf_lte_nsn.1.0.xsd"') DL_PRB_UTIL_TTI_LEVEL_9,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C34','xmlns="pm/cnf_lte_nsn.1.0.xsd"') DL_PRB_UTIL_TTI_LEVEL_10,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C35','xmlns="pm/cnf_lte_nsn.1.0.xsd"') DL_PRB_UTIL_TTI_MIN,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C36','xmlns="pm/cnf_lte_nsn.1.0.xsd"') DL_PRB_UTIL_TTI_MAX,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C37','xmlns="pm/cnf_lte_nsn.1.0.xsd"') DL_PRB_UTIL_TTI_MEAN,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C38','xmlns="pm/cnf_lte_nsn.1.0.xsd"')CCE_AVAIL_ACT_TTI,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C39','xmlns="pm/cnf_lte_nsn.1.0.xsd"') AGG1_USED_PDCCH,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C40','xmlns="pm/cnf_lte_nsn.1.0.xsd"') AGG2_USED_PDCCH,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C41','xmlns="pm/cnf_lte_nsn.1.0.xsd"') AGG4_USED_PDCCH,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C42','xmlns="pm/cnf_lte_nsn.1.0.xsd"') AGG8_USED_PDCCH,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C43','xmlns="pm/cnf_lte_nsn.1.0.xsd"') AGG1_BLOCKED_PDCCH,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C44','xmlns="pm/cnf_lte_nsn.1.0.xsd"') AGG2_BLOCKED_PDCCH,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C45','xmlns="pm/cnf_lte_nsn.1.0.xsd"') AGG4_BLOCKED_PDCCH,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C46','xmlns="pm/cnf_lte_nsn.1.0.xsd"') AGG8_BLOCKED_PDCCH,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C47','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PRB_USED_UL_TOTAL,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C49','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PRB_USED_PUCCH,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C50','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PRB_USED_PUSCH,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C51','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PRB_USED_DL_TOTAL,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C54','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PRB_USED_PDSCH,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C55','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_PER_UL_TTI_AVG,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C56','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_PER_UL_TTI_MAX,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C57','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_PER_DL_TTI_AVG,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C58','xmlns="pm/cnf_lte_nsn.1.0.xsd"') UE_PER_DL_TTI_MAX,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C59','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCCH_1_OFDM_SYMBOL,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C60','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCCH_2_OFDM_SYMBOLS,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C61','xmlns="pm/cnf_lte_nsn.1.0.xsd"') PDCCH_3_OFDM_SYMBOLS,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C62','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TTI_BUNDLING_MODE_UE_AVG,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C63','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TTI_BUNDLING_GRANTS,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C64','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TTI_BUNDL_RETENTION_SHORT,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C65','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TI_BUNDL_RETENTION_MEDIUM,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C66','xmlns="pm/cnf_lte_nsn.1.0.xsd"') TTI_BUNDL_RETENTION_LONG,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C67','xmlns="pm/cnf_lte_nsn.1.0.xsd"') CA_SCELL_CONFIG_ATT,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C68','xmlns="pm/cnf_lte_nsn.1.0.xsd"') CA_SCELL_CONFIG_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M8011C69','xmlns="pm/cnf_lte_nsn.1.0.xsd"') HIGH_CELL_LOAD_LB
	
    FROM t,TABLE(XMLSequence(extract(t.xmlcol,'/OMeS/PMSetup/PMMOResult','xmlns="pm/cnf_lte_nsn.1.0.xsd"'))) x;
  COMMIT;  
    -- update table STATUS_PROCESS_ETL whith information the xml status 1: processed.
   update STATUS_PROCESS_ETL set status ='1' where filename = p_file_name;
   COMMIT;   
   return_result := 1 ;
   return return_result;
  
   EXCEPTION
  WHEN OTHERS THEN
    raise_application_error(-20001,'Se ha encontrado un error - '||SQLCODE||' -ERROR- '||SQLERRM);
    -- update table STATUS_PROCESS_ETL whith information the xml status 2: error processed.
   update STATUS_PROCESS_ETL set status ='2' where filename = p_file_name;
   COMMIT;   
   return_result := 2 ;
   return return_result;   
END parser_LTE_Cell_Resource;

  /* parse xml with LTE_RRC measurement and load in a database*/
FUNCTION parser_LTE_RRC(
    p_local_dir        IN VARCHAR2,
    p_file_name        IN VARCHAR2)
    RETURN INTEGER
IS
   return_result INTEGER;              -- 2: error procesed, 1: ok procesed   
BEGIN
    
   
 INSERT INTO NOKLTE_PS_LRRC_MNC1_RAW
 (INT_ID,CO_NAME,MRBTS_ID,LNBTS_ID,LNCEL_ID,MCC_ID,MNC_ID,PERIOD_START_TIME,PERIOD_DURATION,PERIOD_DURATION_SUM,REJ_RRC_CONN_RE_ESTAB,
 DISC_RRC_PAGING,RRC_PAGING_MESSAGES,RRC_PAGING_REQUESTS,RRC_CON_RE_ESTAB_ATT,RRC_CON_RE_ESTAB_SUCC,RRC_CON_RE_ESTAB_ATT_HO_FAIL,
 RRC_CON_RE_ESTAB_SUCC_HO_FAIL,RRC_CON_RE_ESTAB_ATT_OTHER,RRC_CON_RE_ESTAB_SUCC_OTHER,REPORT_CGI_REQ,SUCC_CGI_REPORTS,
 RRC_CON_REL_REDIR_H_ENB,RRC_PAGING_ETWS_CMAS)
 
 
WITH t AS (SELECT xmltype(bfilename(p_local_dir,p_file_name), nls_charset_id('AL32UTF8')) xmlcol FROM dual)
SELECT
    (SELECT LNCEL_ID FROM objects_sp_lte where lncel_object_class = 3130 and sysdate BETWEEN lncel_valid_start_date and lncel_valid_finish_date and lncel_object_nro= substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNCEL-[0-9]*'),7)) INT_ID,
    (SELECT LNCEL_NAME FROM objects_sp_lte where lncel_object_class = 3130 and sysdate BETWEEN lncel_valid_start_date and lncel_valid_finish_date and lncel_object_nro= substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNCEL-[0-9]*'),7)) CO_NAME,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'MRBTS-[0-9]*'),7) MRBTS_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNBTS-[0-9]*'),7) LNBTS_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNCEL-[0-9]*'),7) LNCEL_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'MCC-[0-9]*'),5) MCC_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'MNC-[0-9]*'),5) MNC_ID,
    TO_DATE(REGEXP_REPLACE(REGEXP_SUBSTR(extract(t.xmlcol, '//@startTime','xmlns="pm/cnf_lte_nsn.1.0.xsd"'),'[0-9]*[-][0-9]*[-][0-9]*[^t][0-9]*[:][0-9]*[:][0-9]*'),'(T)', ' '),'YYYY-MM-DD HH24:MI:SS ') PERIOD_START_TIME,
    extract(t.xmlcol, '//@interval','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getNumberVal() PERIOD_DURATION,
    extract(t.xmlcol, '//@interval','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getNumberVal() PERIOD_DURATION_SUM,
          
    extractValue(value(x),'/PMMOResult/PMTarget/M8008C0','xmlns="pm/cnf_lte_nsn.1.0.xsd"') REJ_RRC_CONN_RE_ESTAB,
    extractValue(value(x),'/PMMOResult/PMTarget/M8008C2','xmlns="pm/cnf_lte_nsn.1.0.xsd"') DISC_RRC_PAGING,
    extractValue(value(x),'/PMMOResult/PMTarget/M8008C3','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RRC_PAGING_MESSAGES,
    extractValue(value(x),'/PMMOResult/PMTarget/M8008C1','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RRC_PAGING_REQUESTS,
    extractValue(value(x),'/PMMOResult/PMTarget/M8008C4','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RRC_CON_RE_ESTAB_ATT,
    extractValue(value(x),'/PMMOResult/PMTarget/M8008C5','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RRC_CON_RE_ESTAB_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M8008C6','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RRC_CON_RE_ESTAB_ATT_HO_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M8008C7','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RRC_CON_RE_ESTAB_SUCC_HO_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M8008C8','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RRC_CON_RE_ESTAB_ATT_OTHER,
    extractValue(value(x),'/PMMOResult/PMTarget/M8008C9','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RRC_CON_RE_ESTAB_SUCC_OTHER,
    extractValue(value(x),'/PMMOResult/PMTarget/M8008C10','xmlns="pm/cnf_lte_nsn.1.0.xsd"') REPORT_CGI_REQ,
    extractValue(value(x),'/PMMOResult/PMTarget/M8008C11','xmlns="pm/cnf_lte_nsn.1.0.xsd"') SUCC_CGI_REPORTS,
    extractValue(value(x),'/PMMOResult/PMTarget/M8008C15','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RRC_CON_REL_REDIR_H_ENB,
    extractValue(value(x),'/PMMOResult/PMTarget/M8008C16','xmlns="pm/cnf_lte_nsn.1.0.xsd"') RRC_PAGING_ETWS_CMAS
	
    FROM t,TABLE(XMLSequence(extract(t.xmlcol,'/OMeS/PMSetup/PMMOResult','xmlns="pm/cnf_lte_nsn.1.0.xsd"'))) x;
  COMMIT;  
    -- update table STATUS_PROCESS_ETL whith information the xml status 1: processed.
   update STATUS_PROCESS_ETL set status ='1' where filename = p_file_name;
   COMMIT;   
   return_result := 1 ;
   return return_result;
  
   EXCEPTION
  WHEN OTHERS THEN
    raise_application_error(-20001,'Se ha encontrado un error - '||SQLCODE||' -ERROR- '||SQLERRM);
    -- update table STATUS_PROCESS_ETL whith information the xml status 2: error processed.
   update STATUS_PROCESS_ETL set status ='2' where filename = p_file_name;
   COMMIT;   
   return_result := 2 ;
   return return_result;   
   
 END parser_LTE_RRC;
 
   /* parse xml with LTE_Handover measurement and load in a database*/
FUNCTION parser_LTE_Handover(
    p_local_dir        IN VARCHAR2,
    p_file_name        IN VARCHAR2)
    RETURN INTEGER
IS
   return_result INTEGER;              -- 2: error procesed, 1: ok procesed   
BEGIN
    
   
 INSERT INTO NOKLTE_PS_LHO_MNC1_RAW
 (INT_ID,CO_NAME,MRBTS_ID,LNBTS_ID,LNCEL_ID,MCC_ID,MNC_ID,PERIOD_START_TIME,PERIOD_DURATION,PERIOD_DURATION_SUM,HO_INTFREQ_ATT,
 HO_INTFREQ_GAP_ATT,HO_INTFREQ_SUCC,HO_INTFREQ_GAP_SUCC,HO_INTFREQ_FAIL,HO_INTFREQ_GAP_FAIL,HO_EMG_PREP,HO_EMG_PREP_FAIL,
 HO_EMG_ATT,HO_EMG_SUCC,HO_DRX_ATT,HO_DRX_SUCC,MRO_LATE_HO,MRO_EARLY_TYPE1_HO,MRO_EARLY_TYPE2_HO,HO_LB_ATT,HO_LB_SUCC)
 
 
WITH t AS (SELECT xmltype(bfilename(p_local_dir,p_file_name), nls_charset_id('AL32UTF8')) xmlcol FROM dual)
SELECT
    (SELECT LNCEL_ID FROM objects_sp_lte where lncel_object_class = 3130 and sysdate BETWEEN lncel_valid_start_date and lncel_valid_finish_date and lncel_object_nro= substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNCEL-[0-9]*'),7)) INT_ID,
    (SELECT LNCEL_NAME FROM objects_sp_lte where lncel_object_class = 3130 and sysdate BETWEEN lncel_valid_start_date and lncel_valid_finish_date and lncel_object_nro= substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNCEL-[0-9]*'),7)) CO_NAME,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'MRBTS-[0-9]*'),7) MRBTS_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNBTS-[0-9]*'),7) LNBTS_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNCEL-[0-9]*'),7) LNCEL_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'MCC-[0-9]*'),5) MCC_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'MNC-[0-9]*'),5) MNC_ID,
    TO_DATE(REGEXP_REPLACE(REGEXP_SUBSTR(extract(t.xmlcol, '//@startTime','xmlns="pm/cnf_lte_nsn.1.0.xsd"'),'[0-9]*[-][0-9]*[-][0-9]*[^t][0-9]*[:][0-9]*[:][0-9]*'),'(T)', ' '),'YYYY-MM-DD HH24:MI:SS ') PERIOD_START_TIME,
    extract(t.xmlcol, '//@interval','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getNumberVal() PERIOD_DURATION,
    extract(t.xmlcol, '//@interval','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getNumberVal() PERIOD_DURATION_SUM,
        
    extractValue(value(x),'/PMMOResult/PMTarget/M8021C0','xmlns="pm/cnf_lte_nsn.1.0.xsd"') HO_INTFREQ_ATT,
    extractValue(value(x),'/PMMOResult/PMTarget/M8021C1','xmlns="pm/cnf_lte_nsn.1.0.xsd"') HO_INTFREQ_GAP_ATT,
    extractValue(value(x),'/PMMOResult/PMTarget/M8021C2','xmlns="pm/cnf_lte_nsn.1.0.xsd"') HO_INTFREQ_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M8021C3','xmlns="pm/cnf_lte_nsn.1.0.xsd"') HO_INTFREQ_GAP_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M8021C4','xmlns="pm/cnf_lte_nsn.1.0.xsd"') HO_INTFREQ_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M8021C5','xmlns="pm/cnf_lte_nsn.1.0.xsd"') HO_INTFREQ_GAP_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M8021C6','xmlns="pm/cnf_lte_nsn.1.0.xsd"') HO_EMG_PREP,
    extractValue(value(x),'/PMMOResult/PMTarget/M8021C9','xmlns="pm/cnf_lte_nsn.1.0.xsd"') HO_EMG_PREP_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M8021C12','xmlns="pm/cnf_lte_nsn.1.0.xsd"') HO_EMG_ATT,
    extractValue(value(x),'/PMMOResult/PMTarget/M8021C15','xmlns="pm/cnf_lte_nsn.1.0.xsd"') HO_EMG_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M8021C18','xmlns="pm/cnf_lte_nsn.1.0.xsd"') HO_DRX_ATT,
    extractValue(value(x),'/PMMOResult/PMTarget/M8021C19','xmlns="pm/cnf_lte_nsn.1.0.xsd"') HO_DRX_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M8021C20','xmlns="pm/cnf_lte_nsn.1.0.xsd"') MRO_LATE_HO,
    extractValue(value(x),'/PMMOResult/PMTarget/M8021C21','xmlns="pm/cnf_lte_nsn.1.0.xsd"') MRO_EARLY_TYPE1_HO,
    extractValue(value(x),'/PMMOResult/PMTarget/M8021C22','xmlns="pm/cnf_lte_nsn.1.0.xsd"') MRO_EARLY_TYPE2_HO,
    extractValue(value(x),'/PMMOResult/PMTarget/M8021C23','xmlns="pm/cnf_lte_nsn.1.0.xsd"') HO_LB_ATT,
    extractValue(value(x),'/PMMOResult/PMTarget/M8021C24','xmlns="pm/cnf_lte_nsn.1.0.xsd"') HO_LB_SUCC
	
    FROM t,TABLE(XMLSequence(extract(t.xmlcol,'/OMeS/PMSetup/PMMOResult','xmlns="pm/cnf_lte_nsn.1.0.xsd"'))) x;
  COMMIT;  
    -- update table STATUS_PROCESS_ETL whith information the xml status 1: processed.
   update STATUS_PROCESS_ETL set status ='1' where filename = p_file_name;
   COMMIT;   
   return_result := 1 ;
   return return_result;
  
   EXCEPTION
  WHEN OTHERS THEN
    raise_application_error(-20001,'Se ha encontrado un error - '||SQLCODE||' -ERROR- '||SQLERRM);
    -- update table STATUS_PROCESS_ETL whith information the xml status 2: error processed.
   update STATUS_PROCESS_ETL set status ='2' where filename = p_file_name;
   COMMIT;   
   return_result := 2 ;
   return return_result;   
   
END parser_LTE_Handover;

  /* parse xml with LTE_Inter_Sys_HO measurement and load in a database*/
FUNCTION parser_LTE_Inter_Sys_HO(
    p_local_dir        IN VARCHAR2,
    p_file_name        IN VARCHAR2)
    RETURN INTEGER
IS
   return_result INTEGER;              -- 2: error procesed, 1: ok procesed   
BEGIN
    
   
 INSERT INTO NOKLTE_PS_LISHO_MNC1_RAW
 (INT_ID,CO_NAME,MRBTS_ID,LNBTS_ID,LNCEL_ID,MCC_ID,MNC_ID,PERIOD_START_TIME,PERIOD_DURATION,PERIOD_DURATION_SUM,CSFB_REDIR_CR_ATT,
 CSFB_REDIR_CR_CMODE_ATT,CSFB_REDIR_CR_EMERGENCY_ATT,ISYS_HO_PREP,ISYS_HO_PREP_FAIL_TIM,ISYS_HO_PREP_FAIL_AC,ISYS_HO_PREP_FAIL_OTH,
 ISYS_HO_ATT,ISYS_HO_SUCC,ISYS_HO_FAIL,NACC_TO_GSM_ATT,ISYS_HO_UTRAN_SRVCC_ATT,ISYS_HO_UTRAN_SRVCC_SUCC,ISYS_HO_UTRAN_SRVCC_FAIL,
 CSFB_PSHO_UTRAN_ATT,ISYS_HO_GERAN_SRVCC_ATT,ISYS_HO_GERAN_SRVCC_SUCC,ISYS_HO_GERAN_SRVCC_FAIL)
 
 
WITH t AS (SELECT xmltype(bfilename(p_local_dir,p_file_name), nls_charset_id('AL32UTF8')) xmlcol FROM dual)
SELECT
    (SELECT LNCEL_ID FROM objects_sp_lte where lncel_object_class = 3130 and sysdate BETWEEN lncel_valid_start_date and lncel_valid_finish_date and lncel_object_nro= substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNCEL-[0-9]*'),7)) INT_ID,
    (SELECT LNCEL_NAME FROM objects_sp_lte where lncel_object_class = 3130 and sysdate BETWEEN lncel_valid_start_date and lncel_valid_finish_date and lncel_object_nro= substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNCEL-[0-9]*'),7)) CO_NAME,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'MRBTS-[0-9]*'),7) MRBTS_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNBTS-[0-9]*'),7) LNBTS_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'LNCEL-[0-9]*'),7) LNCEL_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'MCC-[0-9]*'),5) MCC_ID,
    substr(REGEXP_SUBSTR(extract(value(x),'//DN/text()','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getStringVal(),'MNC-[0-9]*'),5) MNC_ID,
    TO_DATE(REGEXP_REPLACE(REGEXP_SUBSTR(extract(t.xmlcol, '//@startTime','xmlns="pm/cnf_lte_nsn.1.0.xsd"'),'[0-9]*[-][0-9]*[-][0-9]*[^t][0-9]*[:][0-9]*[:][0-9]*'),'(T)', ' '),'YYYY-MM-DD HH24:MI:SS ') PERIOD_START_TIME,
    extract(t.xmlcol, '//@interval','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getNumberVal() PERIOD_DURATION,
    extract(t.xmlcol, '//@interval','xmlns="pm/cnf_lte_nsn.1.0.xsd"').getNumberVal() PERIOD_DURATION_SUM,
        
    extractValue(value(x),'/PMMOResult/PMTarget/M8016C11','xmlns="pm/cnf_lte_nsn.1.0.xsd"') CSFB_REDIR_CR_ATT,
    extractValue(value(x),'/PMMOResult/PMTarget/M8016C12','xmlns="pm/cnf_lte_nsn.1.0.xsd"') CSFB_REDIR_CR_CMODE_ATT,
    extractValue(value(x),'/PMMOResult/PMTarget/M8016C13','xmlns="pm/cnf_lte_nsn.1.0.xsd"') CSFB_REDIR_CR_EMERGENCY_ATT,
    extractValue(value(x),'/PMMOResult/PMTarget/M8016C14','xmlns="pm/cnf_lte_nsn.1.0.xsd"') ISYS_HO_PREP,
    extractValue(value(x),'/PMMOResult/PMTarget/M8016C15','xmlns="pm/cnf_lte_nsn.1.0.xsd"') ISYS_HO_PREP_FAIL_TIM,
    extractValue(value(x),'/PMMOResult/PMTarget/M8016C16','xmlns="pm/cnf_lte_nsn.1.0.xsd"') ISYS_HO_PREP_FAIL_AC,
    extractValue(value(x),'/PMMOResult/PMTarget/M8016C17','xmlns="pm/cnf_lte_nsn.1.0.xsd"') ISYS_HO_PREP_FAIL_OTH,
    extractValue(value(x),'/PMMOResult/PMTarget/M8016C21','xmlns="pm/cnf_lte_nsn.1.0.xsd"') ISYS_HO_ATT,
    extractValue(value(x),'/PMMOResult/PMTarget/M8016C23','xmlns="pm/cnf_lte_nsn.1.0.xsd"') ISYS_HO_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M8016C25','xmlns="pm/cnf_lte_nsn.1.0.xsd"') ISYS_HO_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M8016C26','xmlns="pm/cnf_lte_nsn.1.0.xsd"') NACC_TO_GSM_ATT,
    extractValue(value(x),'/PMMOResult/PMTarget/M8016C29','xmlns="pm/cnf_lte_nsn.1.0.xsd"') ISYS_HO_UTRAN_SRVCC_ATT,
    extractValue(value(x),'/PMMOResult/PMTarget/M8016C30','xmlns="pm/cnf_lte_nsn.1.0.xsd"') ISYS_HO_UTRAN_SRVCC_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M8016C31','xmlns="pm/cnf_lte_nsn.1.0.xsd"') ISYS_HO_UTRAN_SRVCC_FAIL,
    extractValue(value(x),'/PMMOResult/PMTarget/M8016C32','xmlns="pm/cnf_lte_nsn.1.0.xsd"') CSFB_PSHO_UTRAN_ATT,
    extractValue(value(x),'/PMMOResult/PMTarget/M8016C33','xmlns="pm/cnf_lte_nsn.1.0.xsd"') ISYS_HO_GERAN_SRVCC_ATT,
    extractValue(value(x),'/PMMOResult/PMTarget/M8016C34','xmlns="pm/cnf_lte_nsn.1.0.xsd"') ISYS_HO_GERAN_SRVCC_SUCC,
    extractValue(value(x),'/PMMOResult/PMTarget/M8016C35','xmlns="pm/cnf_lte_nsn.1.0.xsd"') ISYS_HO_GERAN_SRVCC_FAIL
    	
    FROM t,TABLE(XMLSequence(extract(t.xmlcol,'/OMeS/PMSetup/PMMOResult','xmlns="pm/cnf_lte_nsn.1.0.xsd"'))) x;
    COMMIT;  
    -- update table STATUS_PROCESS_ETL whith information the xml status 1: processed.
   update STATUS_PROCESS_ETL set status ='1' where filename = p_file_name;
   COMMIT;   
   return_result := 1 ;
   return return_result;
  
   EXCEPTION
  WHEN OTHERS THEN
    raise_application_error(-20001,'Se ha encontrado un error - '||SQLCODE||' -ERROR- '||SQLERRM);
    -- update table STATUS_PROCESS_ETL whith information the xml status 2: error processed.
   update STATUS_PROCESS_ETL set status ='2' where filename = p_file_name;
   COMMIT;   
   return_result := 2 ;
   return return_result;   
   
END parser_LTE_Inter_Sys_HO;


  /*
  ***************************************************************************
  Overview : Package for performing parse and load  operations -UMTS
  ***************************************************************************
  /* parse xml with Traffic measurement and load in a database */  
  
FUNCTION parser_UMTS_Traffic(
      p_local_dir        IN VARCHAR2,
      p_file_name        IN VARCHAR2)
      RETURN INTEGER
  IS
     return_result INTEGER;              -- 2: error procesed, 1: ok procesed   
     XMLNS VARCHAR2(255):= 'pm/cnf_rnc_nsn.7.0.xsd'; 
  BEGIN

 INSERT INTO UMTS_C_NSN_TRAFFIC_MNC1_RHA
(
  PERIOD_START_TIME,
  OSSRC,
  WCELL_GID,
  WBTS_GID,
  RNC_GID,
  MCC_ID,
  MNC_ID,
  PERIOD_DURATION,
  PERIOD_DURATION_SUM,
  DCH_REQ_LINK_SRNC,
  DCH_REQ_LINK_REJ_UL_SRNC,
  DCH_REQ_LINK_REJ_DL_SRNC,
  DCH_REQ_RRC_CONN_SRNC,
  DCH_DHO_REQ_LINK_SRNC,
  DCH_DHO_REQ_LINK_REJ_SRNC,
  DCH_ALLO_LINK_1_7_SRNC,
  DCH_ALLO_LINK_3_4_SRNC,
  DCH_ALLO_LINK_13_6_SRNC,
  DCH_ALLO_DURA_LINK_1_7_SRNC,
  DCH_ALLO_DURA_LINK_3_4_SRNC,
  DCH_ALLO_DURA_LINK_13_6_SRNC,
  REQ_CS_VOICE_IN_SRNC,
  REQ_CS_VOICE_REJ_UL_SRNC,
  REQ_CS_VOICE_REJ_DL_SRNC,
  RT_DCH_INIT_VOICE_SRNC,
  REQ_CS_VOICE_SRNC,
  REQ_CS_VOICE_REJ_SRNC,
  ALLO_FOR_AMR_4_75_UL_IN_SRNC,
  ALLO_FOR_AMR_5_15_UL_IN_SRNC,
  ALLO_FOR_AMR_5_9_UL_IN_SRNC,
  ALLO_FOR_AMR_6_7_UL_IN_SRNC,
  ALLO_FOR_AMR_7_4_UL_IN_SRNC,
  ALLO_FOR_AMR_7_95_UL_IN_SRNC,
  ALLO_FOR_AMR_10_2_UL_IN_SRNC,
  ALLO_FOR_AMR_12_2_UL_IN_SRNC,
  ALLO_FOR_AMR_4_75_DL_IN_SRNC,
  ALLO_FOR_AMR_5_15_DL_IN_SRNC,
  ALLO_FOR_AMR_5_9_DL_IN_SRNC,
  ALLO_FOR_AMR_6_7_DL_IN_SRNC,
  ALLO_FOR_AMR_7_4_DL_IN_SRNC,
  ALLO_FOR_AMR_7_95_DL_IN_SRNC,
  ALLO_FOR_AMR_10_2_DL_IN_SRNC,
  ALLO_FOR_AMR_12_2_DL_IN_SRNC,
  DUR_FOR_AMR_4_75_UL_IN_SRNC,
  DUR_FOR_AMR_5_15_UL_IN_SRNC,
  DUR_FOR_AMR_5_9_UL_IN_SRNC,
  DUR_FOR_AMR_6_7_UL_IN_SRNC,
  DUR_FOR_AMR_7_4_UL_IN_SRNC,
  DUR_FOR_AMR_7_95_UL_IN_SRNC,
  DUR_FOR_AMR_10_2_UL_IN_SRNC,
  DUR_FOR_AMR_12_2_UL_IN_SRNC,
  DUR_FOR_AMR_4_75_DL_IN_SRNC,
  DUR_FOR_AMR_5_15_DL_IN_SRNC,
  DUR_FOR_AMR_5_9_DL_IN_SRNC,
  DUR_FOR_AMR_6_7_DL_IN_SRNC,
  DUR_FOR_AMR_7_4_DL_IN_SRNC,
  DUR_FOR_AMR_7_95_DL_IN_SRNC,
  DUR_FOR_AMR_10_2_DL_IN_SRNC,
  DUR_FOR_AMR_12_2_DL_IN_SRNC,
  REQ_CS_DATA_CONV_SRNC,
  REQ_CS_STREAM_SRNC,
  REQ_CS_CONV_REJ_UL_SRNC,
  REQ_CS_CONV_REJ_DL_SRNC,
  REQ_CS_STREAM_REJ_UL_SRNC,
  REQ_CS_STREAM_REJ_DL_SRNC,
  INI_REQ_CS_DATA_CONV_SRNC,
  INI_REQ_CS_STREAM_UL_SRNC,
  RT_REQ_DATA_CONV_SRNC,
  RT_REQ_DATA_CONV_REJ_SRNC,
  RT_REQ_DATA_STREAM_SRNC,
  RT_REQ_DATA_STREAM_REJ_SRNC,
  ALLO_TRAN_CS_CONV_28_8_SRNC,
  ALLO_TRAN_CS_CONV_32_IN_SRNC,
  ALLO_TRAN_CS_CONV_33_6_SRNC,
  ALLO_TRAN_CS_CONV_64_IN_SRNC,
  ALLO_DUR_CS_CONV_28_8_SRNC,
  ALLO_DUR_CS_CONV_32_IN_SRNC,
  ALLO_DUR_CS_CONV_33_6_SRNC,
  ALLO_DUR_CS_CONV_64_IN_SRNC,
  ALLO_NTRANS_STREAM_14_4_UL,
  ALLO_NTRANS_STREAM_28_8_UL,
  ALLO_NTRANS_STREAM_56_7_UL,
  ALLO_NTRANS_STREAM_14_4_DL,
  ALLO_NTRANS_STREAM_28_8_DL,
  ALLO_NTRANS_STREAM_56_7_DL,
  ALLO_DUR_NTRANS_STRM_14_4_UL,
  ALLO_DUR_NTRANS_STRM_28_8_UL,
  ALLO_DUR_NTRANS_STRM_56_7_UL,
  ALLO_DUR_NTRANS_STRM_14_4_DL,
  ALLO_DUR_NTRANS_STRM_28_8_DL,
  ALLO_DUR_NTRANS_STRM_56_7_DL,
  REQ_FOR_PS_CONV_SRNC,
  REQ_FOR_PS_STREAM_SRNC,
  REQ_FOR_PS_INTERA_UL_SRNC,
  REQ_FOR_PS_INTERA_DL_SRNC,
  REQ_FOR_PS_BACKG_UL_SRNC,
  REQ_FOR_PS_BACKG_DL_SRNC,
  REQ_PS_CONV_REJ_UL_SRNC,
  REQ_PS_CONV_REJ_DL_SRNC,
  REQ_PS_STREAM_REJ_UL_SRNC,
  REQ_PS_STREAM_REJ_DL_SRNC,
  REQ_PS_INTERA_REJ_UL_SRNC,
  REQ_PS_INTERA_REJ_DL_SRNC,
  REQ_PS_BACKG_REJ_UL_SRNC,
  REQ_PS_BACKG_REJ_DL_SRNC,
  INI_REQ_PS_CONV_SRNC,
  INI_REQ_PS_STREAM_UL_SRNC,
  INI_REQ_PS_INTERA_UL_SRNC,
  INI_REQ_PS_INTERA_DL_SRNC,
  INI_REQ_PS_BACKGR_UL_SRNC,
  INI_REQ_PS_BACKGR_DL_SRNC,
  RT_REQ_PS_CONV_SRNC,
  RT_REQ_PS_CONV_REJ_SRNC,
  RT_REQ_PS_STREAM_SRNC,
  RT_REQ_PS_STREAM_REJ_SRNC,
  NRT_REQ_PS_INTERA_SRNC,
  NRT_REQ_PS_INTERA_REJ_SRNC,
  NRT_REQ_PS_BACKG_SRNC,
  NRT_REQ_PS_BACKG_REJ_SRNC,
  ALLO_PS_CONV_8_UL_IN_SRNC,
  ALLO_PS_CONV_16_UL_IN_SRNC,
  ALLO_PS_CONV_32_UL_IN_SRNC,
  ALLO_PS_CONV_64_UL_IN_SRNC,
  ALLO_PS_CONV_128_UL_IN_SRNC,
  ALLO_PS_CONV_256_UL_IN_SRNC,
  ALLO_PS_CONV_320_UL_IN_SRNC,
  ALLO_PS_CONV_384_UL_IN_SRNC,
  ALLO_PS_CONV_8_DL_IN_SRNC,
  ALLO_PS_CONV_16_DL_IN_SRNC,
  ALLO_PS_CONV_32_DL_IN_SRNC,
  ALLO_PS_CONV_64_DL_IN_SRNC,
  ALLO_PS_CONV_128_DL_IN_SRNC,
  ALLO_PS_CONV_256_DL_IN_SRNC,
  ALLO_PS_CONV_320_DL_IN_SRNC,
  ALLO_PS_CONV_384_DL_IN_SRNC,
  ALLO_PS_STREAM_8_UL_IN_SRNC,
  ALLO_PS_STREAM_16_UL_IN_SRNC,
  ALLO_PS_STREAM_32_UL_IN_SRNC,
  ALLO_PS_STREAM_64_UL_IN_SRNC,
  ALLO_PS_STREAM_128_UL_SRNC,
  ALLO_PS_STREAM_256_UL_SRNC,
  ALLO_PS_STREAM_320_UL_SRNC,
  ALLO_PS_STREAM_384_UL_SRNC,
  ALLO_PS_STREAM_8_DL_IN_SRNC,
  ALLO_PS_STREAM_16_DL_IN_SRNC,
  ALLO_PS_STREAM_32_DL_IN_SRNC,
  ALLO_PS_STREAM_64_DL_IN_SRNC,
  ALLO_PS_STREAM_128_DL_SRNC,
  ALLO_PS_STREAM_256_DL_SRNC,
  ALLO_PS_STREAM_320_DL_SRNC,
  ALLO_PS_STREAM_384_DL_SRNC,
  ALLO_PS_INTERA_8_UL_IN_SRNC,
  ALLO_PS_INTERA_16_UL_IN_SRNC,
  ALLO_PS_INTERA_32_UL_IN_SRNC,
  ALLO_PS_INTERA_64_UL_IN_SRNC,
  ALLO_PS_INTERA_128_UL_SRNC,
  ALLO_PS_INTERA_256_UL_SRNC,
  ALLO_PS_INTERA_320_UL_SRNC,
  ALLO_PS_INTERA_384_UL_SRNC,
  ALLO_PS_INTERA_8_DL_IN_SRNC,
  ALLO_PS_INTERA_16_DL_IN_SRNC,
  ALLO_PS_INTERA_32_DL_IN_SRNC,
  ALLO_PS_INTERA_64_DL_IN_SRNC,
  ALLO_PS_INTERA_128_DL_SRNC,
  ALLO_PS_INTERA_256_DL_SRNC,
  ALLO_PS_INTERA_320_DL_SRNC,
  ALLO_PS_INTERA_384_DL_SRNC,
  ALLO_PS_BACKG_8_UL_IN_SRNC,
  ALLO_PS_BACKG_16_UL_IN_SRNC,
  ALLO_PS_BACKG_32_UL_IN_SRNC,
  ALLO_PS_BACKG_64_UL_IN_SRNC,
  ALLO_PS_BACKG_128_UL_IN_SRNC,
  ALLO_PS_BACKG_256_UL_IN_SRNC,
  ALLO_PS_BACKG_320_UL_IN_SRNC,
  ALLO_PS_BACKG_384_UL_IN_SRNC,
  ALLO_PS_BACKG_8_DL_IN_SRNC,
  ALLO_PS_BACKG_16_DL_IN_SRNC,
  ALLO_PS_BACKG_32_DL_IN_SRNC,
  ALLO_PS_BACKG_64_DL_IN_SRNC,
  ALLO_PS_BACKG_128_DL_IN_SRNC,
  ALLO_PS_BACKG_256_DL_IN_SRNC,
  ALLO_PS_BACKG_320_DL_IN_SRNC,
  ALLO_PS_BACKG_384_DL_IN_SRNC,
  DUR_PS_CONV_8_UL_IN_SRNC,
  DUR_PS_CONV_16_UL_IN_SRNC,
  DUR_PS_CONV_32_UL_IN_SRNC,
  DUR_PS_CONV_64_UL_IN_SRNC,
  DUR_PS_CONV_128_UL_IN_SRNC,
  DUR_PS_CONV_256_UL_IN_SRNC,
  DUR_PS_CONV_320_UL_IN_SRNC,
  DUR_PS_CONV_384_UL_IN_SRNC,
  DUR_PS_CONV_8_DL_IN_SRNC,
  DUR_PS_CONV_16_DL_IN_SRNC,
  DUR_PS_CONV_32_DL_IN_SRNC,
  DUR_PS_CONV_64_DL_IN_SRNC,
  DUR_PS_CONV_128_DL_IN_SRNC,
  DUR_PS_CONV_256_DL_IN_SRNC,
  DUR_PS_CONV_320_DL_IN_SRNC,
  DUR_PS_CONV_384_DL_IN_SRNC,
  DUR_PS_STREAM_8_UL_IN_SRNC,
  DUR_PS_STREAM_16_UL_IN_SRNC,
  DUR_PS_STREAM_32_UL_IN_SRNC,
  DUR_PS_STREAM_64_UL_IN_SRNC,
  DUR_PS_STREAM_128_UL_IN_SRNC,
  DUR_PS_STREAM_256_UL_IN_SRNC,
  DUR_PS_STREAM_320_UL_IN_SRNC,
  DUR_PS_STREAM_384_UL_IN_SRNC,
  DUR_PS_STREAM_8_DL_IN_SRNC,
  DUR_PS_STREAM_16_DL_IN_SRNC,
  DUR_PS_STREAM_32_DL_IN_SRNC,
  DUR_PS_STREAM_64_DL_IN_SRNC,
  DUR_PS_STREAM_128_DL_IN_SRNC,
  DUR_PS_STREAM_256_DL_IN_SRNC,
  DUR_PS_STREAM_320_DL_IN_SRNC,
  DUR_PS_STREAM_384_DL_IN_SRNC,
  DUR_PS_INTERA_8_UL_IN_SRNC,
  DUR_PS_INTERA_16_UL_IN_SRNC,
  DUR_PS_INTERA_32_UL_IN_SRNC,
  DUR_PS_INTERA_64_UL_IN_SRNC,
  DUR_PS_INTERA_128_UL_IN_SRNC,
  DUR_PS_INTERA_256_UL_IN_SRNC,
  DUR_PS_INTERA_320_UL_IN_SRNC,
  DUR_PS_INTERA_384_UL_IN_SRNC,
  DUR_PS_INTERA_8_DL_IN_SRNC,
  DUR_PS_INTERA_16_DL_IN_SRNC,
  DUR_PS_INTERA_32_DL_IN_SRNC,
  DUR_PS_INTERA_64_DL_IN_SRNC,
  DUR_PS_INTERA_128_DL_IN_SRNC,
  DUR_PS_INTERA_256_DL_IN_SRNC,
  DUR_PS_INTERA_320_DL_IN_SRNC,
  DUR_PS_INTERA_384_DL_IN_SRNC,
  DUR_PS_BACKG_8_UL_IN_SRNC,
  DUR_PS_BACKG_16_UL_IN_SRNC,
  DUR_PS_BACKG_32_UL_IN_SRNC,
  DUR_PS_BACKG_64_UL_IN_SRNC,
  DUR_PS_BACKG_128_UL_IN_SRNC,
  DUR_PS_BACKG_256_UL_IN_SRNC,
  DUR_PS_BACKG_320_UL_IN_SRNC,
  DUR_PS_BACKG_384_UL_IN_SRNC,
  DUR_PS_BACKG_8_DL_IN_SRNC,
  DUR_PS_BACKG_16_DL_IN_SRNC,
  DUR_PS_BACKG_32_DL_IN_SRNC,
  DUR_PS_BACKG_64_DL_IN_SRNC,
  DUR_PS_BACKG_128_DL_IN_SRNC,
  DUR_PS_BACKG_256_DL_IN_SRNC,
  DUR_PS_BACKG_320_DL_IN_SRNC,
  DUR_PS_BACKG_384_DL_IN_SRNC,
  DCH_REQ_SIG_LINK_DRNC,
  DCH_REQ_SIG_LINK_UL_DRNC,
  DCH_REQ_SIG_LINK_DL_DRNC,
  DCH_DHO_REQ_SIG_LINK_DRNC,
  DCH_REQ_SIG_LINK_REJ_DRNC,
  DCH_ALLO_SIG_LINK_1_7_DRNC,
  DCH_ALLO_SIG_LINK_3_4_DRNC,
  DCH_ALLO_SIG_LINK_13_6_DRNC,
  DCH_ALLO_DURA_LINK_1_7_DRNC,
  DCH_ALLO_DURA_LINK_3_4_DRNC,
  DCH_ALLO_DURA_LINK_13_6_DRNC,
  REQ_CS_VOICE_IN_DRNC,
  REQ_CS_VOICE_REJ_UL_IN_DRNC,
  REQ_CS_VOICE_REJ_DL_IN_DRNC,
  RT_REQ_CS_VOICE_DRNC,
  RT_REQ_CS_VOICE_REJ_DRNC,
  ALLO_FOR_AMR_4_75_UL_IN_DRNC,
  ALLO_FOR_AMR_5_15_UL_IN_DRNC,
  ALLO_FOR_AMR_5_9_UL_IN_DRNC,
  ALLO_FOR_AMR_6_7_UL_IN_DRNC,
  ALLO_FOR_AMR_7_4_UL_IN_DRNC,
  ALLO_FOR_AMR_7_95_UL_IN_DRNC,
  ALLO_FOR_AMR_10_2_UL_IN_DRNC,
  ALLO_FOR_AMR_12_2_UL_IN_DRNC,
  ALLO_FOR_AMR_4_75_DL_IN_DRNC,
  ALLO_FOR_AMR_5_15_DL_IN_DRNC,
  ALLO_FOR_AMR_5_9_DL_IN_DRNC,
  ALLO_FOR_AMR_6_7_DL_IN_DRNC,
  ALLO_FOR_AMR_7_4_DL_IN_DRNC,
  ALLO_FOR_AMR_7_95_DL_IN_DRNC,
  ALLO_FOR_AMR_10_2_DL_IN_DRNC,
  ALLO_FOR_AMR_12_2_DL_IN_DRNC,
  DURA_FOR_AMR_4_75_UL_IN_DRNC,
  DURA_FOR_AMR_5_15_UL_IN_DRNC,
  DURA_FOR_AMR_5_9_UL_IN_DRNC,
  DURA_FOR_AMR_6_7_UL_IN_DRNC,
  DURA_FOR_AMR_7_4_UL_IN_DRNC,
  DURA_FOR_AMR_7_95_UL_IN_DRNC,
  DURA_FOR_AMR_10_2_UL_IN_DRNC,
  DURA_FOR_AMR_12_2_UL_IN_DRNC,
  DURA_FOR_AMR_4_75_DL_IN_DRNC,
  DURA_FOR_AMR_5_15_DL_IN_DRNC,
  DURA_FOR_AMR_5_9_DL_IN_DRNC,
  DURA_FOR_AMR_6_7_DL_IN_DRNC,
  DURA_FOR_AMR_7_4_DL_IN_DRNC,
  DURA_FOR_AMR_7_95_DL_IN_DRNC,
  DURA_FOR_AMR_10_2_DL_IN_DRNC,
  DURA_FOR_AMR_12_2_DL_IN_DRNC,
  REQ_DATA_IN_IN_DRNC,
  REQ_DATA_REJ_IN_UL_IN_DRNC,
  REQ_DATA_REJ_IN_DL_IN_DRNC,
  DCH_DHO_REQ_DATA_DRNC,
  DCH_DHO_REQ_DATA_REJ_DRNC,
  ALLO_FOR_DATA_8_UL_IN_DRNC,
  ALLO_FOR_DATA_14_4_UL_DRNC,
  ALLO_FOR_DATA_16_UL_IN_DRNC,
  ALLO_FOR_DATA_28_8_UL_DRNC,
  ALLO_FOR_DATA_32_UL_IN_DRNC,
  ALLO_FOR_DATA_33_6_UL_DRNC,
  ALLO_FOR_DATA_57_6_UL_DRNC,
  ALLO_FOR_DATA_64_UL_IN_DRNC,
  ALLO_FOR_DATA_128_UL_IN_DRNC,
  ALLO_FOR_DATA_256_UL_IN_DRNC,
  ALLO_FOR_DATA_320_UL_IN_DRNC,
  ALLO_FOR_DATA_384_UL_IN_DRNC,
  ALLO_FOR_DATA_8_DL_IN_DRNC,
  ALLO_FOR_DATA_14_4_DL_DRNC,
  ALLO_FOR_DATA_16_DL_IN_DRNC,
  ALLO_FOR_DATA_28_8_DL_DRNC,
  ALLO_FOR_DATA_32_DL_IN_DRNC,
  ALLO_FOR_DATA_33_6_DL_DRNC,
  ALLO_FOR_DATA_57_6_DL_DRNC,
  ALLO_FOR_DATA_64_DL_IN_DRNC,
  ALLO_FOR_DATA_128_DL_IN_DRNC,
  ALLO_FOR_DATA_256_DL_IN_DRNC,
  ALLO_FOR_DATA_320_DL_IN_DRNC,
  ALLO_FOR_DATA_384_DL_IN_DRNC,
  DURA_FOR_DATA_8_UL_IN_DRNC,
  DURA_FOR_DATA_14_4_UL_DRNC,
  DURA_FOR_DATA_16_UL_IN_DRNC,
  DURA_FOR_DATA_28_8_UL_DRNC,
  DURA_FOR_DATA_32_UL_IN_DRNC,
  DURA_FOR_DATA_33_6_UL_DRNC,
  DURA_FOR_DATA_57_6_UL_DRNC,
  DURA_FOR_DATA_64_UL_IN_DRNC,
  DURA_FOR_DATA_128_UL_IN_DRNC,
  DURA_FOR_DATA_256_UL_IN_DRNC,
  DURA_FOR_DATA_320_UL_IN_DRNC,
  DURA_FOR_DATA_384_UL_IN_DRNC,
  DURA_FOR_DATA_8_DL_IN_DRNC,
  DURA_FOR_DATA_14_4_DL_DRNC,
  DURA_FOR_DATA_16_DL_IN_DRNC,
  DURA_FOR_DATA_28_8_DL_DRNC,
  DURA_FOR_DATA_32_DL_IN_DRNC,
  DURA_FOR_DATA_33_6_DL_DRNC,
  DURA_FOR_DATA_57_6_DL_DRNC,
  DURA_FOR_DATA_64_DL_IN_DRNC,
  DURA_FOR_DATA_128_DL_IN_DRNC,
  DURA_FOR_DATA_256_DL_IN_DRNC,
  DURA_FOR_DATA_320_DL_IN_DRNC,
  DURA_FOR_DATA_384_DL_IN_DRNC,
  DCH_HHO_REQ_LINK_SRNC,
  DCH_HHO_REQ_LINK_REJ_SRNC,
  REQ_CS_VOICE_HHO_SRNC,
  REQ_CS_VOICE_HHO_REJ_SRNC,
  RT_REQ_DATA_CONV_HHO_SRNC,
  RT_REQ_DATA_CNV_HHO_REJ_SRNC,
  RT_REQ_DATA_STREAM_HHO_SRNC,
  RT_REQ_DATA_STRM_HHO_RJ_SRNC,
  RT_REQ_PS_CONV_HHO_SRNC,
  RT_REQ_PS_CONV_HHO_REJ_SRNC,
  RT_REQ_PS_STREAM_HHO_SRNC,
  RT_REQ_PS_STRM_HHO_REJ_SRNC,
  NRT_REQ_PS_INTERA_HHO_SRNC,
  NRT_REQ_PS_INT_HHO_REJ_SRNC,
  NRT_REQ_PS_BACKG_HHO_SRNC,
  NRT_REQ_PS_BACKG_HHO_RJ_SRNC,
  REQ_CMOD_UL_IF_HHO_SRNC,
  REQ_CMOD_DL_IF_HHO_SRNC,
  REQ_COM_UL_INT_SYS_HHO_SRNC,
  REQ_COM_DL_INT_SYS_HHO_SRNC,
  REQ_COM_UL_REJ_FRE_HHO_SRNC,
  REQ_COM_DL_REJ_FRE_HHO_SRNC,
  REQ_COM_UL_REJ_SYS_HHO_SRNC,
  REQ_COM_DL_REJ_SYS_HHO_SRNC,
  ALLO_COM_UL_FRE_HHO_SRNC,
  ALLO_COM_DL_FRE_HHO_SRNC,
  ALLO_DUR_COM_UL_FRE_HHO_SRNC,
  ALLO_DUR_COM_DL_FRE_HHO_SRNC,
  ALLO_COM_UL_SYS_HHO_SRNC,
  ALLO_COM_DL_SYS_HHO_SRNC,
  ALLO_DUR_COM_UL_SYS_HHO_SRNC,
  ALLO_DUR_COM_DL_SYS_HHO_SRNC,
  DCH_HHO_REQ_LINK_DRNC,
  DCH_HHO_REQ_LINK_REJ_DRNC,
  REQ_CS_VOICE_HHO_DRNC,
  REQ_CS_VOICE_HHO_REJ_DRNC,
  DCH_HHO_REQ_DATA_DRNC,
  DCH_HHO_REQ_DATA_REJ_DRNC,
  REQ_CMOD_UL_DRNC,
  REQ_CMOD_DL_DRNC,
  REQ_CMOD_UL_REJ_DRNC,
  REQ_CMOD_DL_REJ_DRNC,
  ALLO_CMOD_UL_DRNC,
  ALLO_CMOD_DL_DRNC,
  ALLO_DURA_CMOD_UL_DRNC,
  ALLO_DURA_CMOD_DL_DRNC,
  ALLO_HS_DSCH_FLOW_INT,
  ALLO_HS_DSCH_RET_64_INT,
  ALLO_HS_DSCH_RET_128_INT,
  ALLO_HS_DSCH_RET_384_INT,
  ALLO_HS_DSCH_FLOW_BGR,
  ALLO_HS_DSCH_RET_64_BGR,
  ALLO_HS_DSCH_RET_128_BGR,
  ALLO_HS_DSCH_RET_384_BGR,
  ALLO_DUR_HS_DSCH_FLOW_INT,
  ALLO_DUR_HS_DSCH_RET_64_INT,
  ALLO_DUR_HS_DSCH_RET_128_INT,
  ALLO_DUR_HS_DSCH_RET_384_INT,
  ALLO_DUR_HS_DSCH_FLOW_BGR,
  ALLO_DUR_HS_DSCH_RET_64_BGR,
  ALLO_DUR_HS_DSCH_RET_128_BGR,
  ALLO_DUR_HS_DSCH_RET_384_BGR,
  REJ_HS_DSCH_RET_INT,
  REJ_HS_DSCH_RET_BGR,
  REJ_HS_DSCH_AMR_BGR,
  SETUP_FAIL_HS_DSCH_AMR_BGR,
  ALLO_HS_DSCH_AMR_BGR,
  REL_ALLO_NORM_HSDSCH_AMR_BGR,
  REL_ALLO_NORM_HS_DSCH_INT,
  REL_ALLO_OTH_FAIL_HSDSCH_INT,
  REL_ALLO_HS_DSCH_MOB_DCH_INT,
  REL_ALLO_NORM_HS_DSCH_BGR,
  REL_ALLO_OTH_FAIL_HSDSCH_BGR,
  REL_ALLO_HS_DSCH_MOB_DCH_BGR,
  SETUP_FAIL_RNC_HS_DSCH_INT,
  SETUP_FAIL_IUB_MAC_D_INT,
  SETUP_FAIL_UE_HS_DSCH_INT,
  SETUP_FAIL_BTS_HS_DSCH_INT,
  SETUP_FAIL_IUB_HS_TOTAL_INT,
  SETUP_FAIL_64_IUB_HSDSCH_INT,
  SETUP_FAIL_128_IUB_HSDSCH_IN,
  SETUP_FAIL_384_IUB_HSDSCH_IN,
  SETUP_FAIL_RNC_HS_DSCH_BGR,
  SETUP_FAIL_IUB_MAC_D_BGR,
  SETUP_FAIL_UE_HS_DSCH_BGR,
  SETUP_FAIL_BTS_HS_DSCH_BGR,
  SETUP_FAIL_IUB_HS_TOTAL_BGR,
  SETUP_FAIL_64_IUB_HSDSCH_BGR,
  SETUP_FAIL_128_IUB_HSDSCH_BG,
  SETUP_FAIL_384_IUB_HSDSCH_BG,
  HS_DSCH_RET_UPGRADE_INT,
  HS_DSCH_RET_DOWNGRADE_INT,
  HS_DSCH_RET_UPGRADE_BGR,
  HS_DSCH_RET_DOWNGRADE_BGR,
  ALLO_COM_UL_SF2_SRNC,
  ALLO_COM_DL_SF2_SRNC,
  ALLO_COM_UL_HLS_SRNC,
  ALLO_COM_DL_HLS_SRNC,
  ALLO_DUR_COM_UL_SF2_SRNC,
  ALLO_DUR_COM_DL_SF2_SRNC,
  ALLO_DUR_COM_UL_HLS_SRNC,
  ALLO_DUR_COM_DL_HLS_SRNC,
  ALLO_COM_UL_SF2_DRNC,
  ALLO_COM_DL_SF2_DRNC,
  ALLO_COM_UL_HLS_DRNC,
  ALLO_COM_DL_HLS_DRNC,
  ALLO_COM_DL_PUNCT_DRNC,
  ALLO_DUR_COM_UL_SF2_DRNC,
  ALLO_DUR_COM_DL_SF2_DRNC,
  ALLO_DUR_COM_UL_HLS_DRNC,
  ALLO_DUR_COM_DL_HLS_DRNC,
  ALLO_DUR_COM_DL_PUNCT_DRNC,
  DCH_SHO_STP_VOICE_FAIL_TRANS,
  DCH_SHO_STP_CSCONV_F_TRANS,
  DCH_SHO_STP_CSSTR_F_TRANS,
  DCH_SHO_STP_PSSTR_F_TRANS,
  DCH_SHO_STP_PSINT_F_TRANS,
  DCH_SHO_STP_PSBACKG_F_TRANS,
  UL_INI_STP_FAIL_INT_IUB_AAL2,
  UL_UPG_STP_FAIL_INT_IUB_AAL2,
  DL_INI_STP_FAIL_INT_IUB_AAL2,
  DL_UPG_STP_FAIL_INT_IUB_AAL2,
  UL_INI_STP_F_BACKG_IUB_AAL2,
  UL_UPG_STP_F_BACKG_IUB_AAL2,
  DL_INI_STP_F_BACKG_IUB_AAL2,
  DL_UPG_STP_F_BACKG_IUB_AAL2,
  UL_INI_STP_FAIL_INT_IUR_AAL2,
  UL_UPG_STP_FAIL_INT_IUR_AAL2,
  DL_INI_STP_FAIL_INT_IUR_AAL2,
  DL_UPG_STP_FAIL_INT_IUR_AAL2,
  UL_INI_STP_F_BACKG_IUR_AAL2,
  UL_UPG_STP_F_BACKG_IUR_AAL2,
  DL_INI_STP_F_BACKG_IUR_AAL2,
  DL_UPG_STP_F_BACKG_IUR_AAL2,
  DCH_STP_F_AMR_DRNC_EXTTRANS,
  DCH_STP_F_DATA_DRNC_EXTTRANS,
  DCH_SEL_MAX_HSDPA_USERS_INT,
  DCH_SEL_MAX_HSDPA_USERS_BGR,
  REL_ALLO_HS_DSCH_OTH_DCH_INT,
  REL_ALLO_HS_DSCH_PRE_EMP_INT,
  REL_ALLO_RL_FAIL_HS_DSCH_INT,
  REL_ALLO_HS_DSCH_OTH_DCH_BGR,
  REL_ALLO_HS_DSCH_PRE_EMP_BGR,
  REL_ALLO_RL_FAIL_HS_DSCH_BGR,
  REJ_HS_DSCH_AMR_INT,
  SETUP_FAIL_HS_DSCH_AMR_INT,
  ALLO_HS_DSCH_AMR_INT,
  REL_ALLO_NORM_HSDSCH_AMR_INT,
  ALLO_FOR_WAMR_12_65_SRNC,
  ALLO_FOR_WAMR_6_6_SRNC,
  DURA_FOR_WAMR_12_65_SRNC,
  DURA_FOR_WAMR_6_6_SRNC,
  ALLO_FOR_WAMR_12_65_DRNC,
  ALLO_FOR_WAMR_8_85_DRNC,
  ALLO_FOR_WAMR_6_6_DRNC,
  DURA_FOR_WAMR_12_65_DRNC,
  DURA_FOR_WAMR_8_85_DRNC,
  DURA_FOR_WAMR_6_6_DRNC,
  SWI_FROM_WAMR_TO_NAMR_SRNC,
  SWI_FROM_NAMR_TO_WAMR_SRNC,
  SWI_FROM_WAMR_TO_NAMR_DRNC,
  SWI_FROM_NAMR_TO_WAMR_DRNC,
  ALLO_HS_DSCH_RET_16_INT,
  ALLO_HS_DSCH_RET_16_BGR,
  ALLO_DUR_HS_DSCH_RET_16_INT,
  ALLO_DUR_HS_DSCH_RET_16_BGR,
  SETUP_FAIL_16_IUB_HSDSCH_INT,
  SETUP_FAIL_16_IUB_HSDSCH_BGR,
  SWI_DCH_TO_HS_DSCH_INT,
  SWI_DCH_TO_HS_DSCH_BGR,
  DCH_ALLO_NON_HSPA_TO_HSPA,
  DCH_ALLO_HSPA_TO_NON_HSPA,
  DCH_ALLO_HSPA_TO_HSPA,
  FACH_DCH_NON_HSPA_TO_HSPA,
  FACH_DCH_HSPA_TO_NON_HSPA,
  FACH_DCH_HSPA_TO_HSPA,
  UL_DCH_SEL_MAX_HSUPA_USR_INT,
  UL_DCH_SEL_MAX_HSUPA_USR_BGR,
  UL_DCH_SEL_BTS_HW_INT,
  UL_DCH_SEL_BTS_HW_BGR,
  EDCH_ALLO_CANC_NA_AS_INT,
  EDCH_ALLO_CANC_NA_AS_BGR,
  DL_DCH_SEL_HSDPA_POWER_INT,
  DL_DCH_SEL_HSDPA_POWER_BGR,
  SETUP_FAIL_EDCH_UE_INT,
  SETUP_FAIL_EDCH_UE_BGR,
  SETUP_FAIL_EDCH_BTS_INT,
  SETUP_FAIL_EDCH_BTS_BGR,
  SETUP_FAIL_EDCH_TRANS_INT,
  SETUP_FAIL_EDCH_TRANS_BGR,
  SETUP_FAIL_EDCH_OTHER_INT,
  SETUP_FAIL_EDCH_OTHER_BGR,
  ALLO_SUCCESS_EDCH_INT,
  ALLO_SUCCESS_EDCH_BGR,
  ALLO_DUR_EDCH_INT,
  ALLO_DUR_EDCH_BGR,
  REL_EDCH_NORM_INT,
  REL_EDCH_NORM_BGR,
  REL_EDCH_HSDSCH_SCC_INT,
  REL_EDCH_HSDSCH_SCC_BGR,
  REL_EDCH_RL_FAIL_INT,
  REL_EDCH_RL_FAIL_BGR,
  REL_EDCH_OTHER_FAIL_INT,
  REL_EDCH_OTHER_FAIL_BGR,
  AMR_EDCH_ALLO,
  AMR_EDCH_NORMAL_REL,
  ALLO_HS_INTER_RNC_HHO_INT,
  ALLO_HS_INTER_RNC_HHO_BGR,
  STP_F_HS_INTER_RNC_HHO_INT,
  STP_F_HS_INTER_RNC_HHO_BGR,
  ALLO_ED_INTER_RNC_HHO_INT,
  ALLO_ED_INTER_RNC_HHO_BGR,
  STP_F_ED_INTER_RNC_HHO_INT,
  STP_F_ED_INTER_RNC_HHO_BGR,
  REJ_DCH_DUE_CODES_INT_DL,
  REJ_DCH_DUE_CODES_BGR_DL,
  REJ_DCH_DUE_POWER_INT_DL,
  REJ_DCH_DUE_POWER_BGR_DL,
  REJ_DCH_REC_DUE_CODES_INT_DL,
  REJ_DCH_REC_DUE_CODES_BGR_DL,
  REJ_DCH_REC_DUE_PWR_INT_DL,
  REJ_DCH_REC_DUE_PWR_BGR_DL,
  AMR_LOWER_CODEC_SF128_INC,
  AMR_LOWER_CODEC_SF256_INC,
  LOAD_AMR_DGR_SF128_SUCCESS,
  LOAD_AMR_DGR_SF256_SUCCESS,
  LOAD_AMR_UPGRADE_SUCCESS,
  AMR_CODEC_CHANGE_FAIL_ICSU,
  AMR_CODEC_CHANGE_FAIL_OTHER,
  SWI_DCH_TO_HS_DSCH_STR,
  ALLO_HS_DSCH_FLOW_STR,
  ALLO_HS_DSCH_RET_16_STR,
  ALLO_HS_DSCH_RET_64_STR,
  ALLO_HS_DSCH_RET_128_STR,
  ALLO_DUR_HS_DSCH_FLOW_STR,
  ALLO_DUR_HS_DSCH_RET_16_STR,
  ALLO_DUR_HS_DSCH_RET_64_STR,
  ALLO_DUR_HS_DSCH_RET_128_STR,
  REJ_HS_DSCH_RET_STR,
  REL_ALLO_NORM_HS_DSCH_STR,
  REL_ALLO_OTH_FAIL_HSDSCH_STR,
  REL_ALLO_HS_DSCH_MOB_DCH_STR,
  SETUP_FAIL_RNC_HS_DSCH_STR,
  SETUP_FAIL_IUB_MAC_D_STR,
  SETUP_FAIL_UE_HS_DSCH_STR,
  SETUP_FAIL_BTS_HS_DSCH_STR,
  SETUP_FAIL_IUB_HS_TOTAL_STR,
  SETUP_FAIL_16_IUB_HSDSCH_STR,
  SETUP_FAIL_64_IUB_HSDSCH_STR,
  SETUP_FAIL_128_IUB_HSDSCH_ST,
  HS_DSCH_RET_UPGRADE_STR,
  HS_DSCH_RET_DOWNGRADE_STR,
  DCH_SEL_MAX_HSDPA_USERS_STR,
  REL_ALLO_HS_DSCH_OTH_DCH_STR,
  REL_ALLO_HS_DSCH_PRE_EMP_STR,
  REL_ALLO_RL_FAIL_HS_DSCH_STR,
  REJ_HS_DSCH_AMR_STR,
  SETUP_FAIL_HS_DSCH_AMR_STR,
  ALLO_HS_DSCH_AMR_STR,
  REL_ALLO_NORM_HSDSCH_AMR_STR,
  UL_DCH_SEL_MAX_HSUPA_USR_STR,
  UL_DCH_SEL_BTS_HW_STR,
  EDCH_ALLO_CANC_NA_AS_STR,
  DL_DCH_SEL_HSDPA_POWER_STR,
  SETUP_FAIL_EDCH_UE_STR,
  SETUP_FAIL_EDCH_BTS_STR,
  SETUP_FAIL_EDCH_TRANS_STR,
  SETUP_FAIL_EDCH_OTHER_STR,
  ALLO_SUCCESS_EDCH_STR,
  ALLO_DUR_EDCH_STR,
  REL_EDCH_NORM_STR,
  REL_EDCH_HSDSCH_SCC_STR,
  REL_EDCH_RL_FAIL_STR,
  REL_EDCH_OTHER_FAIL_STR,
  ALLO_HS_INTER_RNC_HHO_STR,
  STP_F_HS_INTER_RNC_HHO_STR,
  ALLO_ED_INTER_RNC_HHO_STR,
  STP_F_ED_INTER_RNC_HHO_STR,
  ALLO_AMR_MULTINRT_HSPA,
  ALLO_MULTINRT_HSPA,
  ALLO_AMR_RT_NRT_HSPA,
  ALLO_AMR_RT_MULTINRT_HSPA,
  ALLO_RT_NRT_HSPA,
  ALLO_RT_MULTINRT_HSPA,
  ALLO_CM_HSDPA_IFHO,
  ALLO_DURA_CM_HSDPA_IFHO,
  REJ_CM_HSDPA_IFHO,
  REJ_DCH_DUE_POWER_INT_UL,
  REJ_DCH_DUE_POWER_BGR_UL,
  REJ_DCH_REC_DUE_PWR_INT_UL,
  REJ_DCH_REC_DUE_PWR_BGR_UL,
  ATT_HS_DSCH_DRNC,
  ALLO_HS_DSCH_DRNC,
  ALLO_DUR_HS_DSCH_DRNC,
  ATT_EDCH_DRNC,
  ALLO_EDCH_DRNC,
  ALLO_DUR_EDCH_DRNC,
  SETUP_FAIL_BTS_HS_DSCH_AMR,
  SETUP_FAIL_UE_HS_DSCH_AMR,
  SETUP_FAIL_TRANS_HS_DSCH_AMR,
  SETUP_FAIL_OTHER_HS_DSCH_AMR,
  SETUP_FAIL_BTS_EDCH_AMR,
  SETUP_FAIL_UE_EDCH_AMR,
  SETUP_FAIL_TRANS_EDCH_AMR,
  SETUP_FAIL_OTHER_EDCH_AMR,
  REL_ALLO_NORM_HS_DSCH_AMR,
  REL_ALLO_RL_FAIL_HS_DSCH_AMR,
  REL_ALLO_OTH_FAIL_HSDSCH_AMR,
  REL_ALLO_NORM_EDCH_AMR,
  REL_ALLO_RL_FAIL_EDCH_AMR,
  REL_ALLO_OTH_FAIL_EDCH_AMR,
  SWI_R99_TO_HSPA_CS_VOICE,
  SWI_HSPA_TO_R99_CS_AMR,
  ALLO_HS_DSCH_5_9_AMR,
  ALLO_HS_DSCH_12_2_AMR,
  ALLO_HS_DSCH_12_65_AMR,
  ALLO_DUR_HS_DSCH_5_9_AMR,
  ALLO_DUR_HS_DSCH_12_2_AMR,
  ALLO_DUR_HS_DSCH_12_65_AMR,
  ALLO_SUCCESS_EDCH_AMR_5_9,
  ALLO_SUCCESS_EDCH_AMR_12_2,
  ALLO_SUCCESS_EDCH_AMR_12_65,
  ALLO_DUR_EDCH_5_9_AMR,
  ALLO_DUR_EDCH_12_2_AMR,
  ALLO_DUR_EDCH_12_65_AMR,
  ALLO_EDCH_SRB_SRNC,
  ALLO_EDCH_SRB_DRNC,
  ALLO_HS_DSCH_SRB_SRNC,
  ALLO_HS_DSCH_SRB_DRNC,
  ALLO_DUR_HS_DSCH_INACTIV_BGR,
  ALLO_DUR_HS_DSCH_INACTIV_INT,
  ALLO_DUR_EDCH_INACTIV_BGR,
  ALLO_DUR_EDCH_INACTIV_INT,
  ATT_HSPA_DIREAL_BGR,
  ATT_HSPA_DIREAL_INT,
  ALLO_SUCC_HSPA_DIREAL_BGR,
  ALLO_SUCC_HSPA_DIREAL_INT,
  ALLO_CM_HSUPA_IFHO,
  ALLO_DURA_CM_HSUPA_IFHO,
  REJ_CM_HSUPA_IFHO,
  TRAFFIC_SPARE_1,
  TRAFFIC_SPARE_2,
  SETUP_REJ_EDCH_AC_INT,
  SETUP_REJ_EDCH_AC_BGR,
  ALLO_HS_DSCH_FLOW_PTT,
  ALLO_SUCCESS_EDCH_PTT,
  MEH_ADMIT_CS_VOICE,
  MEH_REJECT_2MS_EDCH_TTI,
  MEH_REJECT_EDCH,
  MEH_REJECT_HSDSCH,
  MEH_RESTR_R99_UL_DCH
)
WITH T AS (SELECT XMLTYPE(BFILENAME(P_LOCAL_DIR, P_FILE_NAME), NLS_CHARSET_ID('AL32UTF8')) XMLCOL FROM DUAL WHERE ROWNUM <10)

       SELECT TO_DATE(REGEXP_REPLACE(REGEXP_SUBSTR(EXTRACT(T.XMLCOL, '//@startTime', 'xmlns="'||XMLNS||'"'), '[0-9]*[-][0-9]*[-][0-9]*[^t][0-9]*[:][0-9]*[:][0-9]*'), '(T)', ' '),'YYYY-MM-DD HH24:MI:SS ') PERIOD_START_TIME,
       'OSSRC1' OSSRC,
       F_UMTS_CLDD_OBJ_GID_GET ('WCELL_GID', 
       REGEXP_REPLACE(REGEXP_SUBSTR(EXTRACT(VALUE(X),'//DN/text()'     , 'xmlns="'||XMLNS||'"').GETSTRINGVAL(), 'RNC.[0-9]*'), 'RNC.', ''),
       REGEXP_REPLACE(REGEXP_SUBSTR(EXTRACT(VALUE(X),'//DN/text()'     , 'xmlns="'||XMLNS||'"').GETSTRINGVAL(), 'WBTS.[0-9]*'), 'WBTS.', ''),
       REGEXP_REPLACE(REGEXP_SUBSTR(EXTRACT(VALUE(X),'//DN/text()'     , 'xmlns="'||XMLNS||'"').GETSTRINGVAL(), 'WCEL.[0-9]*'), 'WCEL.', '')) WCELL_GID,
       F_UMTS_CLDD_OBJ_GID_GET ('WBTS_GID', 
       REGEXP_REPLACE(REGEXP_SUBSTR(EXTRACT(VALUE(X),'//DN/text()'     , 'xmlns="'||XMLNS||'"').GETSTRINGVAL(), 'RNC.[0-9]*'), 'RNC.', ''),
       REGEXP_REPLACE(REGEXP_SUBSTR(EXTRACT(VALUE(X),'//DN/text()'     , 'xmlns="'||XMLNS||'"').GETSTRINGVAL(), 'WBTS.[0-9]*'), 'WBTS.', ''),
       REGEXP_REPLACE(REGEXP_SUBSTR(EXTRACT(VALUE(X),'//DN/text()'     , 'xmlns="'||XMLNS||'"').GETSTRINGVAL(), 'WCEL.[0-9]*'), 'WCEL.', '')) WBTS_GID,
       F_UMTS_CLDD_OBJ_GID_GET ('RNC_GID', 
       REGEXP_REPLACE(REGEXP_SUBSTR(EXTRACT(VALUE(X),'//DN/text()'     , 'xmlns="'||XMLNS||'"').GETSTRINGVAL(), 'RNC.[0-9]*'), 'RNC.', ''),
       REGEXP_REPLACE(REGEXP_SUBSTR(EXTRACT(VALUE(X),'//DN/text()'     , 'xmlns="'||XMLNS||'"').GETSTRINGVAL(), 'WBTS.[0-9]*'), 'WBTS.', ''),
       REGEXP_REPLACE(REGEXP_SUBSTR(EXTRACT(VALUE(X),'//DN/text()'     , 'xmlns="'||XMLNS||'"').GETSTRINGVAL(), 'WCEL.[0-9]*'), 'WCEL.', '')) RNC_GID,
       REGEXP_REPLACE(REGEXP_SUBSTR(EXTRACT(VALUE(X),'//DN/text()'     , 'xmlns="'||XMLNS||'"').GETSTRINGVAL(), 'MCC.[0-9]*'), 'MCC.', '') MCC_ID,
       REGEXP_REPLACE(REGEXP_SUBSTR(EXTRACT(VALUE(X),'//DN/text()'     , 'xmlns="'||XMLNS||'"').GETSTRINGVAL(), 'MNC.[0-9]*'), 'MNC.', '') MNC_ID,
       EXTRACT(T.XMLCOL, '//@interval'                                 , 'xmlns="'||XMLNS||'"').GETNUMBERVAL() PERIOD_DURATION,
       EXTRACT(T.XMLCOL, '//@interval'                                 , 'xmlns="'||XMLNS||'"').GETNUMBERVAL() PERIOD_DURATION_SUM,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C0'            , 'xmlns="'||XMLNS||'"') DCH_REQ_LINK_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C1'            , 'xmlns="'||XMLNS||'"') DCH_REQ_LINK_REJ_UL_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C2'            , 'xmlns="'||XMLNS||'"') DCH_REQ_LINK_REJ_DL_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C3'            , 'xmlns="'||XMLNS||'"') DCH_REQ_RRC_CONN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C4'            , 'xmlns="'||XMLNS||'"') DCH_DHO_REQ_LINK_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C5'            , 'xmlns="'||XMLNS||'"') DCH_DHO_REQ_LINK_REJ_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C6'            , 'xmlns="'||XMLNS||'"') DCH_ALLO_LINK_1_7_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C7'            , 'xmlns="'||XMLNS||'"') DCH_ALLO_LINK_3_4_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C8'            , 'xmlns="'||XMLNS||'"') DCH_ALLO_LINK_13_6_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C9'            , 'xmlns="'||XMLNS||'"') DCH_ALLO_DURA_LINK_1_7_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C10'           , 'xmlns="'||XMLNS||'"') DCH_ALLO_DURA_LINK_3_4_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C11'           , 'xmlns="'||XMLNS||'"') DCH_ALLO_DURA_LINK_13_6_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C12'           , 'xmlns="'||XMLNS||'"') REQ_CS_VOICE_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C13'           , 'xmlns="'||XMLNS||'"') REQ_CS_VOICE_REJ_UL_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C14'           , 'xmlns="'||XMLNS||'"') REQ_CS_VOICE_REJ_DL_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C15'           , 'xmlns="'||XMLNS||'"') RT_DCH_INIT_VOICE_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C16'           , 'xmlns="'||XMLNS||'"') REQ_CS_VOICE_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C17'           , 'xmlns="'||XMLNS||'"') REQ_CS_VOICE_REJ_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C18'           , 'xmlns="'||XMLNS||'"') ALLO_FOR_AMR_4_75_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C19'           , 'xmlns="'||XMLNS||'"') ALLO_FOR_AMR_5_15_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C20'           , 'xmlns="'||XMLNS||'"') ALLO_FOR_AMR_5_9_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C21'           , 'xmlns="'||XMLNS||'"') ALLO_FOR_AMR_6_7_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C22'           , 'xmlns="'||XMLNS||'"') ALLO_FOR_AMR_7_4_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C23'           , 'xmlns="'||XMLNS||'"') ALLO_FOR_AMR_7_95_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C24'           , 'xmlns="'||XMLNS||'"') ALLO_FOR_AMR_10_2_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C25'           , 'xmlns="'||XMLNS||'"') ALLO_FOR_AMR_12_2_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C26'           , 'xmlns="'||XMLNS||'"') ALLO_FOR_AMR_4_75_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C27'           , 'xmlns="'||XMLNS||'"') ALLO_FOR_AMR_5_15_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C28'           , 'xmlns="'||XMLNS||'"') ALLO_FOR_AMR_5_9_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C29'           , 'xmlns="'||XMLNS||'"') ALLO_FOR_AMR_6_7_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C30'           , 'xmlns="'||XMLNS||'"') ALLO_FOR_AMR_7_4_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C31'           , 'xmlns="'||XMLNS||'"') ALLO_FOR_AMR_7_95_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C32'           , 'xmlns="'||XMLNS||'"') ALLO_FOR_AMR_10_2_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C33'           , 'xmlns="'||XMLNS||'"') ALLO_FOR_AMR_12_2_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C34'           , 'xmlns="'||XMLNS||'"') DUR_FOR_AMR_4_75_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C35'           , 'xmlns="'||XMLNS||'"') DUR_FOR_AMR_5_15_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C36'           , 'xmlns="'||XMLNS||'"') DUR_FOR_AMR_5_9_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C37'           , 'xmlns="'||XMLNS||'"') DUR_FOR_AMR_6_7_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C38'           , 'xmlns="'||XMLNS||'"') DUR_FOR_AMR_7_4_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C39'           , 'xmlns="'||XMLNS||'"') DUR_FOR_AMR_7_95_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C40'           , 'xmlns="'||XMLNS||'"') DUR_FOR_AMR_10_2_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C41'           , 'xmlns="'||XMLNS||'"') DUR_FOR_AMR_12_2_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C42'           , 'xmlns="'||XMLNS||'"') DUR_FOR_AMR_4_75_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C43'           , 'xmlns="'||XMLNS||'"') DUR_FOR_AMR_5_15_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C44'           , 'xmlns="'||XMLNS||'"') DUR_FOR_AMR_5_9_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C45'           , 'xmlns="'||XMLNS||'"') DUR_FOR_AMR_6_7_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C46'           , 'xmlns="'||XMLNS||'"') DUR_FOR_AMR_7_4_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C47'           , 'xmlns="'||XMLNS||'"') DUR_FOR_AMR_7_95_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C48'           , 'xmlns="'||XMLNS||'"') DUR_FOR_AMR_10_2_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C49'           , 'xmlns="'||XMLNS||'"') DUR_FOR_AMR_12_2_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C50'           , 'xmlns="'||XMLNS||'"') REQ_CS_DATA_CONV_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C51'           , 'xmlns="'||XMLNS||'"') REQ_CS_STREAM_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C52'           , 'xmlns="'||XMLNS||'"') REQ_CS_CONV_REJ_UL_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C53'           , 'xmlns="'||XMLNS||'"') REQ_CS_CONV_REJ_DL_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C54'           , 'xmlns="'||XMLNS||'"') REQ_CS_STREAM_REJ_UL_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C55'           , 'xmlns="'||XMLNS||'"') REQ_CS_STREAM_REJ_DL_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C56'           , 'xmlns="'||XMLNS||'"') INI_REQ_CS_DATA_CONV_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C57'           , 'xmlns="'||XMLNS||'"') INI_REQ_CS_STREAM_UL_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C58'           , 'xmlns="'||XMLNS||'"') RT_REQ_DATA_CONV_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C59'           , 'xmlns="'||XMLNS||'"') RT_REQ_DATA_CONV_REJ_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C60'           , 'xmlns="'||XMLNS||'"') RT_REQ_DATA_STREAM_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C61'           , 'xmlns="'||XMLNS||'"') RT_REQ_DATA_STREAM_REJ_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C62'           , 'xmlns="'||XMLNS||'"') ALLO_TRAN_CS_CONV_28_8_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C63'           , 'xmlns="'||XMLNS||'"') ALLO_TRAN_CS_CONV_32_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C64'           , 'xmlns="'||XMLNS||'"') ALLO_TRAN_CS_CONV_33_6_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C65'           , 'xmlns="'||XMLNS||'"') ALLO_TRAN_CS_CONV_64_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C66'           , 'xmlns="'||XMLNS||'"') ALLO_DUR_CS_CONV_28_8_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C67'           , 'xmlns="'||XMLNS||'"') ALLO_DUR_CS_CONV_32_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C68'           , 'xmlns="'||XMLNS||'"') ALLO_DUR_CS_CONV_33_6_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C69'           , 'xmlns="'||XMLNS||'"') ALLO_DUR_CS_CONV_64_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C70'           , 'xmlns="'||XMLNS||'"') ALLO_NTRANS_STREAM_14_4_UL,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C71'           , 'xmlns="'||XMLNS||'"') ALLO_NTRANS_STREAM_28_8_UL,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C72'           , 'xmlns="'||XMLNS||'"') ALLO_NTRANS_STREAM_56_7_UL,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C73'           , 'xmlns="'||XMLNS||'"') ALLO_NTRANS_STREAM_14_4_DL,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C74'           , 'xmlns="'||XMLNS||'"') ALLO_NTRANS_STREAM_28_8_DL,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C75'           , 'xmlns="'||XMLNS||'"') ALLO_NTRANS_STREAM_56_7_DL,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C76'           , 'xmlns="'||XMLNS||'"') ALLO_DUR_NTRANS_STRM_14_4_UL,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C77'           , 'xmlns="'||XMLNS||'"') ALLO_DUR_NTRANS_STRM_28_8_UL,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C78'           , 'xmlns="'||XMLNS||'"') ALLO_DUR_NTRANS_STRM_56_7_UL,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C79'           , 'xmlns="'||XMLNS||'"') ALLO_DUR_NTRANS_STRM_14_4_DL,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C80'           , 'xmlns="'||XMLNS||'"') ALLO_DUR_NTRANS_STRM_28_8_DL,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C81'           , 'xmlns="'||XMLNS||'"') ALLO_DUR_NTRANS_STRM_56_7_DL,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C82'           , 'xmlns="'||XMLNS||'"') REQ_FOR_PS_CONV_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C83'           , 'xmlns="'||XMLNS||'"') REQ_FOR_PS_STREAM_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C84'           , 'xmlns="'||XMLNS||'"') REQ_FOR_PS_INTERA_UL_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C85'           , 'xmlns="'||XMLNS||'"') REQ_FOR_PS_INTERA_DL_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C86'           , 'xmlns="'||XMLNS||'"') REQ_FOR_PS_BACKG_UL_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C87'           , 'xmlns="'||XMLNS||'"') REQ_FOR_PS_BACKG_DL_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C88'           , 'xmlns="'||XMLNS||'"') REQ_PS_CONV_REJ_UL_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C89'           , 'xmlns="'||XMLNS||'"') REQ_PS_CONV_REJ_DL_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C90'           , 'xmlns="'||XMLNS||'"') REQ_PS_STREAM_REJ_UL_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C91'           , 'xmlns="'||XMLNS||'"') REQ_PS_STREAM_REJ_DL_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C92'           , 'xmlns="'||XMLNS||'"') REQ_PS_INTERA_REJ_UL_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C93'           , 'xmlns="'||XMLNS||'"') REQ_PS_INTERA_REJ_DL_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C94'           , 'xmlns="'||XMLNS||'"') REQ_PS_BACKG_REJ_UL_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C95'           , 'xmlns="'||XMLNS||'"') REQ_PS_BACKG_REJ_DL_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C96'           , 'xmlns="'||XMLNS||'"') INI_REQ_PS_CONV_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C97'           , 'xmlns="'||XMLNS||'"') INI_REQ_PS_STREAM_UL_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C98'           , 'xmlns="'||XMLNS||'"') INI_REQ_PS_INTERA_UL_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C99'           , 'xmlns="'||XMLNS||'"') INI_REQ_PS_INTERA_DL_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C100'          , 'xmlns="'||XMLNS||'"') INI_REQ_PS_BACKGR_UL_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C101'          , 'xmlns="'||XMLNS||'"') INI_REQ_PS_BACKGR_DL_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C102'          , 'xmlns="'||XMLNS||'"') RT_REQ_PS_CONV_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C103'          , 'xmlns="'||XMLNS||'"') RT_REQ_PS_CONV_REJ_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C104'          , 'xmlns="'||XMLNS||'"') RT_REQ_PS_STREAM_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C105'          , 'xmlns="'||XMLNS||'"') RT_REQ_PS_STREAM_REJ_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C106'          , 'xmlns="'||XMLNS||'"') NRT_REQ_PS_INTERA_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C107'          , 'xmlns="'||XMLNS||'"') NRT_REQ_PS_INTERA_REJ_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C108'          , 'xmlns="'||XMLNS||'"') NRT_REQ_PS_BACKG_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C109'          , 'xmlns="'||XMLNS||'"') NRT_REQ_PS_BACKG_REJ_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C110'          , 'xmlns="'||XMLNS||'"') ALLO_PS_CONV_8_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C111'          , 'xmlns="'||XMLNS||'"') ALLO_PS_CONV_16_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C112'          , 'xmlns="'||XMLNS||'"') ALLO_PS_CONV_32_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C113'          , 'xmlns="'||XMLNS||'"') ALLO_PS_CONV_64_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C114'          , 'xmlns="'||XMLNS||'"') ALLO_PS_CONV_128_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C115'          , 'xmlns="'||XMLNS||'"') ALLO_PS_CONV_256_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C116'          , 'xmlns="'||XMLNS||'"') ALLO_PS_CONV_320_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C117'          , 'xmlns="'||XMLNS||'"') ALLO_PS_CONV_384_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C118'          , 'xmlns="'||XMLNS||'"') ALLO_PS_CONV_8_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C119'          , 'xmlns="'||XMLNS||'"') ALLO_PS_CONV_16_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C120'          , 'xmlns="'||XMLNS||'"') ALLO_PS_CONV_32_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C121'          , 'xmlns="'||XMLNS||'"') ALLO_PS_CONV_64_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C122'          , 'xmlns="'||XMLNS||'"') ALLO_PS_CONV_128_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C123'          , 'xmlns="'||XMLNS||'"') ALLO_PS_CONV_256_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C124'          , 'xmlns="'||XMLNS||'"') ALLO_PS_CONV_320_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C125'          , 'xmlns="'||XMLNS||'"') ALLO_PS_CONV_384_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C126'          , 'xmlns="'||XMLNS||'"') ALLO_PS_STREAM_8_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C127'          , 'xmlns="'||XMLNS||'"') ALLO_PS_STREAM_16_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C128'          , 'xmlns="'||XMLNS||'"') ALLO_PS_STREAM_32_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C129'          , 'xmlns="'||XMLNS||'"') ALLO_PS_STREAM_64_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C130'          , 'xmlns="'||XMLNS||'"') ALLO_PS_STREAM_128_UL_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C131'          , 'xmlns="'||XMLNS||'"') ALLO_PS_STREAM_256_UL_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C132'          , 'xmlns="'||XMLNS||'"') ALLO_PS_STREAM_320_UL_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C133'          , 'xmlns="'||XMLNS||'"') ALLO_PS_STREAM_384_UL_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C134'          , 'xmlns="'||XMLNS||'"') ALLO_PS_STREAM_8_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C135'          , 'xmlns="'||XMLNS||'"') ALLO_PS_STREAM_16_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C136'          , 'xmlns="'||XMLNS||'"') ALLO_PS_STREAM_32_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C137'          , 'xmlns="'||XMLNS||'"') ALLO_PS_STREAM_64_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C138'          , 'xmlns="'||XMLNS||'"') ALLO_PS_STREAM_128_DL_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C139'          , 'xmlns="'||XMLNS||'"') ALLO_PS_STREAM_256_DL_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C140'          , 'xmlns="'||XMLNS||'"') ALLO_PS_STREAM_320_DL_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C141'          , 'xmlns="'||XMLNS||'"') ALLO_PS_STREAM_384_DL_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C142'          , 'xmlns="'||XMLNS||'"') ALLO_PS_INTERA_8_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C143'          , 'xmlns="'||XMLNS||'"') ALLO_PS_INTERA_16_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C144'          , 'xmlns="'||XMLNS||'"') ALLO_PS_INTERA_32_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C145'          , 'xmlns="'||XMLNS||'"') ALLO_PS_INTERA_64_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C146'          , 'xmlns="'||XMLNS||'"') ALLO_PS_INTERA_128_UL_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C147'          , 'xmlns="'||XMLNS||'"') ALLO_PS_INTERA_256_UL_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C148'          , 'xmlns="'||XMLNS||'"') ALLO_PS_INTERA_320_UL_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C149'          , 'xmlns="'||XMLNS||'"') ALLO_PS_INTERA_384_UL_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C150'          , 'xmlns="'||XMLNS||'"') ALLO_PS_INTERA_8_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C151'          , 'xmlns="'||XMLNS||'"') ALLO_PS_INTERA_16_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C152'          , 'xmlns="'||XMLNS||'"') ALLO_PS_INTERA_32_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C153'          , 'xmlns="'||XMLNS||'"') ALLO_PS_INTERA_64_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C154'          , 'xmlns="'||XMLNS||'"') ALLO_PS_INTERA_128_DL_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C155'          , 'xmlns="'||XMLNS||'"') ALLO_PS_INTERA_256_DL_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C156'          , 'xmlns="'||XMLNS||'"') ALLO_PS_INTERA_320_DL_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C157'          , 'xmlns="'||XMLNS||'"') ALLO_PS_INTERA_384_DL_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C158'          , 'xmlns="'||XMLNS||'"') ALLO_PS_BACKG_8_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C159'          , 'xmlns="'||XMLNS||'"') ALLO_PS_BACKG_16_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C160'          , 'xmlns="'||XMLNS||'"') ALLO_PS_BACKG_32_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C161'          , 'xmlns="'||XMLNS||'"') ALLO_PS_BACKG_64_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C162'          , 'xmlns="'||XMLNS||'"') ALLO_PS_BACKG_128_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C163'          , 'xmlns="'||XMLNS||'"') ALLO_PS_BACKG_256_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C164'          , 'xmlns="'||XMLNS||'"') ALLO_PS_BACKG_320_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C165'          , 'xmlns="'||XMLNS||'"') ALLO_PS_BACKG_384_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C166'          , 'xmlns="'||XMLNS||'"') ALLO_PS_BACKG_8_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C167'          , 'xmlns="'||XMLNS||'"') ALLO_PS_BACKG_16_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C168'          , 'xmlns="'||XMLNS||'"') ALLO_PS_BACKG_32_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C169'          , 'xmlns="'||XMLNS||'"') ALLO_PS_BACKG_64_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C170'          , 'xmlns="'||XMLNS||'"') ALLO_PS_BACKG_128_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C171'          , 'xmlns="'||XMLNS||'"') ALLO_PS_BACKG_256_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C172'          , 'xmlns="'||XMLNS||'"') ALLO_PS_BACKG_320_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C173'          , 'xmlns="'||XMLNS||'"') ALLO_PS_BACKG_384_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C174'          , 'xmlns="'||XMLNS||'"') DUR_PS_CONV_8_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C175'          , 'xmlns="'||XMLNS||'"') DUR_PS_CONV_16_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C176'          , 'xmlns="'||XMLNS||'"') DUR_PS_CONV_32_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C177'          , 'xmlns="'||XMLNS||'"') DUR_PS_CONV_64_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C178'          , 'xmlns="'||XMLNS||'"') DUR_PS_CONV_128_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C179'          , 'xmlns="'||XMLNS||'"') DUR_PS_CONV_256_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C180'          , 'xmlns="'||XMLNS||'"') DUR_PS_CONV_320_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C181'          , 'xmlns="'||XMLNS||'"') DUR_PS_CONV_384_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C182'          , 'xmlns="'||XMLNS||'"') DUR_PS_CONV_8_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C183'          , 'xmlns="'||XMLNS||'"') DUR_PS_CONV_16_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C184'          , 'xmlns="'||XMLNS||'"') DUR_PS_CONV_32_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C185'          , 'xmlns="'||XMLNS||'"') DUR_PS_CONV_64_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C186'          , 'xmlns="'||XMLNS||'"') DUR_PS_CONV_128_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C187'          , 'xmlns="'||XMLNS||'"') DUR_PS_CONV_256_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C188'          , 'xmlns="'||XMLNS||'"') DUR_PS_CONV_320_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C189'          , 'xmlns="'||XMLNS||'"') DUR_PS_CONV_384_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C190'          , 'xmlns="'||XMLNS||'"') DUR_PS_STREAM_8_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C191'          , 'xmlns="'||XMLNS||'"') DUR_PS_STREAM_16_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C192'          , 'xmlns="'||XMLNS||'"') DUR_PS_STREAM_32_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C193'          , 'xmlns="'||XMLNS||'"') DUR_PS_STREAM_64_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C194'          , 'xmlns="'||XMLNS||'"') DUR_PS_STREAM_128_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C195'          , 'xmlns="'||XMLNS||'"') DUR_PS_STREAM_256_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C196'          , 'xmlns="'||XMLNS||'"') DUR_PS_STREAM_320_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C197'          , 'xmlns="'||XMLNS||'"') DUR_PS_STREAM_384_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C198'          , 'xmlns="'||XMLNS||'"') DUR_PS_STREAM_8_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C199'          , 'xmlns="'||XMLNS||'"') DUR_PS_STREAM_16_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C200'          , 'xmlns="'||XMLNS||'"') DUR_PS_STREAM_32_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C201'          , 'xmlns="'||XMLNS||'"') DUR_PS_STREAM_64_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C202'          , 'xmlns="'||XMLNS||'"') DUR_PS_STREAM_128_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C203'          , 'xmlns="'||XMLNS||'"') DUR_PS_STREAM_256_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C204'          , 'xmlns="'||XMLNS||'"') DUR_PS_STREAM_320_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C205'          , 'xmlns="'||XMLNS||'"') DUR_PS_STREAM_384_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C206'          , 'xmlns="'||XMLNS||'"') DUR_PS_INTERA_8_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C207'          , 'xmlns="'||XMLNS||'"') DUR_PS_INTERA_16_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C208'          , 'xmlns="'||XMLNS||'"') DUR_PS_INTERA_32_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C209'          , 'xmlns="'||XMLNS||'"') DUR_PS_INTERA_64_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C210'          , 'xmlns="'||XMLNS||'"') DUR_PS_INTERA_128_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C211'          , 'xmlns="'||XMLNS||'"') DUR_PS_INTERA_256_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C212'          , 'xmlns="'||XMLNS||'"') DUR_PS_INTERA_320_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C213'          , 'xmlns="'||XMLNS||'"') DUR_PS_INTERA_384_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C214'          , 'xmlns="'||XMLNS||'"') DUR_PS_INTERA_8_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C215'          , 'xmlns="'||XMLNS||'"') DUR_PS_INTERA_16_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C216'          , 'xmlns="'||XMLNS||'"') DUR_PS_INTERA_32_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C217'          , 'xmlns="'||XMLNS||'"') DUR_PS_INTERA_64_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C218'          , 'xmlns="'||XMLNS||'"') DUR_PS_INTERA_128_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C219'          , 'xmlns="'||XMLNS||'"') DUR_PS_INTERA_256_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C220'          , 'xmlns="'||XMLNS||'"') DUR_PS_INTERA_320_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C221'          , 'xmlns="'||XMLNS||'"') DUR_PS_INTERA_384_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C222'          , 'xmlns="'||XMLNS||'"') DUR_PS_BACKG_8_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C223'          , 'xmlns="'||XMLNS||'"') DUR_PS_BACKG_16_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C224'          , 'xmlns="'||XMLNS||'"') DUR_PS_BACKG_32_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C225'          , 'xmlns="'||XMLNS||'"') DUR_PS_BACKG_64_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C226'          , 'xmlns="'||XMLNS||'"') DUR_PS_BACKG_128_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C227'          , 'xmlns="'||XMLNS||'"') DUR_PS_BACKG_256_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C228'          , 'xmlns="'||XMLNS||'"') DUR_PS_BACKG_320_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C229'          , 'xmlns="'||XMLNS||'"') DUR_PS_BACKG_384_UL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C230'          , 'xmlns="'||XMLNS||'"') DUR_PS_BACKG_8_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C231'          , 'xmlns="'||XMLNS||'"') DUR_PS_BACKG_16_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C232'          , 'xmlns="'||XMLNS||'"') DUR_PS_BACKG_32_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C233'          , 'xmlns="'||XMLNS||'"') DUR_PS_BACKG_64_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C234'          , 'xmlns="'||XMLNS||'"') DUR_PS_BACKG_128_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C235'          , 'xmlns="'||XMLNS||'"') DUR_PS_BACKG_256_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C236'          , 'xmlns="'||XMLNS||'"') DUR_PS_BACKG_320_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C237'          , 'xmlns="'||XMLNS||'"') DUR_PS_BACKG_384_DL_IN_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C238'          , 'xmlns="'||XMLNS||'"') DCH_REQ_SIG_LINK_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C239'          , 'xmlns="'||XMLNS||'"') DCH_REQ_SIG_LINK_UL_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C240'          , 'xmlns="'||XMLNS||'"') DCH_REQ_SIG_LINK_DL_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C241'          , 'xmlns="'||XMLNS||'"') DCH_DHO_REQ_SIG_LINK_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C242'          , 'xmlns="'||XMLNS||'"') DCH_REQ_SIG_LINK_REJ_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C243'          , 'xmlns="'||XMLNS||'"') DCH_ALLO_SIG_LINK_1_7_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C244'          , 'xmlns="'||XMLNS||'"') DCH_ALLO_SIG_LINK_3_4_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C245'          , 'xmlns="'||XMLNS||'"') DCH_ALLO_SIG_LINK_13_6_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C246'          , 'xmlns="'||XMLNS||'"') DCH_ALLO_DURA_LINK_1_7_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C247'          , 'xmlns="'||XMLNS||'"') DCH_ALLO_DURA_LINK_3_4_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C248'          , 'xmlns="'||XMLNS||'"') DCH_ALLO_DURA_LINK_13_6_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C249'          , 'xmlns="'||XMLNS||'"') REQ_CS_VOICE_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C250'          , 'xmlns="'||XMLNS||'"') REQ_CS_VOICE_REJ_UL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C251'          , 'xmlns="'||XMLNS||'"') REQ_CS_VOICE_REJ_DL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C252'          , 'xmlns="'||XMLNS||'"') RT_REQ_CS_VOICE_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C253'          , 'xmlns="'||XMLNS||'"') RT_REQ_CS_VOICE_REJ_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C254'          , 'xmlns="'||XMLNS||'"') ALLO_FOR_AMR_4_75_UL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C255'          , 'xmlns="'||XMLNS||'"') ALLO_FOR_AMR_5_15_UL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C256'          , 'xmlns="'||XMLNS||'"') ALLO_FOR_AMR_5_9_UL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C257'          , 'xmlns="'||XMLNS||'"') ALLO_FOR_AMR_6_7_UL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C258'          , 'xmlns="'||XMLNS||'"') ALLO_FOR_AMR_7_4_UL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C259'          , 'xmlns="'||XMLNS||'"') ALLO_FOR_AMR_7_95_UL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C260'          , 'xmlns="'||XMLNS||'"') ALLO_FOR_AMR_10_2_UL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C261'          , 'xmlns="'||XMLNS||'"') ALLO_FOR_AMR_12_2_UL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C262'          , 'xmlns="'||XMLNS||'"') ALLO_FOR_AMR_4_75_DL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C263'          , 'xmlns="'||XMLNS||'"') ALLO_FOR_AMR_5_15_DL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C264'          , 'xmlns="'||XMLNS||'"') ALLO_FOR_AMR_5_9_DL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C265'          , 'xmlns="'||XMLNS||'"') ALLO_FOR_AMR_6_7_DL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C266'          , 'xmlns="'||XMLNS||'"') ALLO_FOR_AMR_7_4_DL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C267'          , 'xmlns="'||XMLNS||'"') ALLO_FOR_AMR_7_95_DL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C268'          , 'xmlns="'||XMLNS||'"') ALLO_FOR_AMR_10_2_DL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C269'          , 'xmlns="'||XMLNS||'"') ALLO_FOR_AMR_12_2_DL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C270'          , 'xmlns="'||XMLNS||'"') DURA_FOR_AMR_4_75_UL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C271'          , 'xmlns="'||XMLNS||'"') DURA_FOR_AMR_5_15_UL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C272'          , 'xmlns="'||XMLNS||'"') DURA_FOR_AMR_5_9_UL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C273'          , 'xmlns="'||XMLNS||'"') DURA_FOR_AMR_6_7_UL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C274'          , 'xmlns="'||XMLNS||'"') DURA_FOR_AMR_7_4_UL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C275'          , 'xmlns="'||XMLNS||'"') DURA_FOR_AMR_7_95_UL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C276'          , 'xmlns="'||XMLNS||'"') DURA_FOR_AMR_10_2_UL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C277'          , 'xmlns="'||XMLNS||'"') DURA_FOR_AMR_12_2_UL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C278'          , 'xmlns="'||XMLNS||'"') DURA_FOR_AMR_4_75_DL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C279'          , 'xmlns="'||XMLNS||'"') DURA_FOR_AMR_5_15_DL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C280'          , 'xmlns="'||XMLNS||'"') DURA_FOR_AMR_5_9_DL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C281'          , 'xmlns="'||XMLNS||'"') DURA_FOR_AMR_6_7_DL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C282'          , 'xmlns="'||XMLNS||'"') DURA_FOR_AMR_7_4_DL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C283'          , 'xmlns="'||XMLNS||'"') DURA_FOR_AMR_7_95_DL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C284'          , 'xmlns="'||XMLNS||'"') DURA_FOR_AMR_10_2_DL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C285'          , 'xmlns="'||XMLNS||'"') DURA_FOR_AMR_12_2_DL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C286'          , 'xmlns="'||XMLNS||'"') REQ_DATA_IN_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C287'          , 'xmlns="'||XMLNS||'"') REQ_DATA_REJ_IN_UL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C288'          , 'xmlns="'||XMLNS||'"') REQ_DATA_REJ_IN_DL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C289'          , 'xmlns="'||XMLNS||'"') DCH_DHO_REQ_DATA_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C290'          , 'xmlns="'||XMLNS||'"') DCH_DHO_REQ_DATA_REJ_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C291'          , 'xmlns="'||XMLNS||'"') ALLO_FOR_DATA_8_UL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C292'          , 'xmlns="'||XMLNS||'"') ALLO_FOR_DATA_14_4_UL_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C293'          , 'xmlns="'||XMLNS||'"') ALLO_FOR_DATA_16_UL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C294'          , 'xmlns="'||XMLNS||'"') ALLO_FOR_DATA_28_8_UL_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C295'          , 'xmlns="'||XMLNS||'"') ALLO_FOR_DATA_32_UL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C296'          , 'xmlns="'||XMLNS||'"') ALLO_FOR_DATA_33_6_UL_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C297'          , 'xmlns="'||XMLNS||'"') ALLO_FOR_DATA_57_6_UL_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C298'          , 'xmlns="'||XMLNS||'"') ALLO_FOR_DATA_64_UL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C299'          , 'xmlns="'||XMLNS||'"') ALLO_FOR_DATA_128_UL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C300'          , 'xmlns="'||XMLNS||'"') ALLO_FOR_DATA_256_UL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C301'          , 'xmlns="'||XMLNS||'"') ALLO_FOR_DATA_320_UL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C302'          , 'xmlns="'||XMLNS||'"') ALLO_FOR_DATA_384_UL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C303'          , 'xmlns="'||XMLNS||'"') ALLO_FOR_DATA_8_DL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C304'          , 'xmlns="'||XMLNS||'"') ALLO_FOR_DATA_14_4_DL_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C305'          , 'xmlns="'||XMLNS||'"') ALLO_FOR_DATA_16_DL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C306'          , 'xmlns="'||XMLNS||'"') ALLO_FOR_DATA_28_8_DL_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C307'          , 'xmlns="'||XMLNS||'"') ALLO_FOR_DATA_32_DL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C308'          , 'xmlns="'||XMLNS||'"') ALLO_FOR_DATA_33_6_DL_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C309'          , 'xmlns="'||XMLNS||'"') ALLO_FOR_DATA_57_6_DL_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C310'          , 'xmlns="'||XMLNS||'"') ALLO_FOR_DATA_64_DL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C311'          , 'xmlns="'||XMLNS||'"') ALLO_FOR_DATA_128_DL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C312'          , 'xmlns="'||XMLNS||'"') ALLO_FOR_DATA_256_DL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C313'          , 'xmlns="'||XMLNS||'"') ALLO_FOR_DATA_320_DL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C314'          , 'xmlns="'||XMLNS||'"') ALLO_FOR_DATA_384_DL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C315'          , 'xmlns="'||XMLNS||'"') DURA_FOR_DATA_8_UL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C316'          , 'xmlns="'||XMLNS||'"') DURA_FOR_DATA_14_4_UL_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C317'          , 'xmlns="'||XMLNS||'"') DURA_FOR_DATA_16_UL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C318'          , 'xmlns="'||XMLNS||'"') DURA_FOR_DATA_28_8_UL_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C319'          , 'xmlns="'||XMLNS||'"') DURA_FOR_DATA_32_UL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C320'          , 'xmlns="'||XMLNS||'"') DURA_FOR_DATA_33_6_UL_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C321'          , 'xmlns="'||XMLNS||'"') DURA_FOR_DATA_57_6_UL_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C322'          , 'xmlns="'||XMLNS||'"') DURA_FOR_DATA_64_UL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C323'          , 'xmlns="'||XMLNS||'"') DURA_FOR_DATA_128_UL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C324'          , 'xmlns="'||XMLNS||'"') DURA_FOR_DATA_256_UL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C325'          , 'xmlns="'||XMLNS||'"') DURA_FOR_DATA_320_UL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C326'          , 'xmlns="'||XMLNS||'"') DURA_FOR_DATA_384_UL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C327'          , 'xmlns="'||XMLNS||'"') DURA_FOR_DATA_8_DL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C328'          , 'xmlns="'||XMLNS||'"') DURA_FOR_DATA_14_4_DL_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C329'          , 'xmlns="'||XMLNS||'"') DURA_FOR_DATA_16_DL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C330'          , 'xmlns="'||XMLNS||'"') DURA_FOR_DATA_28_8_DL_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C331'          , 'xmlns="'||XMLNS||'"') DURA_FOR_DATA_32_DL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C332'          , 'xmlns="'||XMLNS||'"') DURA_FOR_DATA_33_6_DL_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C333'          , 'xmlns="'||XMLNS||'"') DURA_FOR_DATA_57_6_DL_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C334'          , 'xmlns="'||XMLNS||'"') DURA_FOR_DATA_64_DL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C335'          , 'xmlns="'||XMLNS||'"') DURA_FOR_DATA_128_DL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C336'          , 'xmlns="'||XMLNS||'"') DURA_FOR_DATA_256_DL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C337'          , 'xmlns="'||XMLNS||'"') DURA_FOR_DATA_320_DL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C338'          , 'xmlns="'||XMLNS||'"') DURA_FOR_DATA_384_DL_IN_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C339'          , 'xmlns="'||XMLNS||'"') DCH_HHO_REQ_LINK_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C340'          , 'xmlns="'||XMLNS||'"') DCH_HHO_REQ_LINK_REJ_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C341'          , 'xmlns="'||XMLNS||'"') REQ_CS_VOICE_HHO_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C342'          , 'xmlns="'||XMLNS||'"') REQ_CS_VOICE_HHO_REJ_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C343'          , 'xmlns="'||XMLNS||'"') RT_REQ_DATA_CONV_HHO_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C344'          , 'xmlns="'||XMLNS||'"') RT_REQ_DATA_CNV_HHO_REJ_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C345'          , 'xmlns="'||XMLNS||'"') RT_REQ_DATA_STREAM_HHO_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C346'          , 'xmlns="'||XMLNS||'"') RT_REQ_DATA_STRM_HHO_RJ_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C347'          , 'xmlns="'||XMLNS||'"') RT_REQ_PS_CONV_HHO_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C348'          , 'xmlns="'||XMLNS||'"') RT_REQ_PS_CONV_HHO_REJ_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C349'          , 'xmlns="'||XMLNS||'"') RT_REQ_PS_STREAM_HHO_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C350'          , 'xmlns="'||XMLNS||'"') RT_REQ_PS_STRM_HHO_REJ_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C351'          , 'xmlns="'||XMLNS||'"') NRT_REQ_PS_INTERA_HHO_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C352'          , 'xmlns="'||XMLNS||'"') NRT_REQ_PS_INT_HHO_REJ_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C353'          , 'xmlns="'||XMLNS||'"') NRT_REQ_PS_BACKG_HHO_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C354'          , 'xmlns="'||XMLNS||'"') NRT_REQ_PS_BACKG_HHO_RJ_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C355'          , 'xmlns="'||XMLNS||'"') REQ_CMOD_UL_IF_HHO_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C356'          , 'xmlns="'||XMLNS||'"') REQ_CMOD_DL_IF_HHO_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C357'          , 'xmlns="'||XMLNS||'"') REQ_COM_UL_INT_SYS_HHO_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C358'          , 'xmlns="'||XMLNS||'"') REQ_COM_DL_INT_SYS_HHO_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C359'          , 'xmlns="'||XMLNS||'"') REQ_COM_UL_REJ_FRE_HHO_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C360'          , 'xmlns="'||XMLNS||'"') REQ_COM_DL_REJ_FRE_HHO_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C361'          , 'xmlns="'||XMLNS||'"') REQ_COM_UL_REJ_SYS_HHO_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C362'          , 'xmlns="'||XMLNS||'"') REQ_COM_DL_REJ_SYS_HHO_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C363'          , 'xmlns="'||XMLNS||'"') ALLO_COM_UL_FRE_HHO_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C364'          , 'xmlns="'||XMLNS||'"') ALLO_COM_DL_FRE_HHO_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C365'          , 'xmlns="'||XMLNS||'"') ALLO_DUR_COM_UL_FRE_HHO_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C366'          , 'xmlns="'||XMLNS||'"') ALLO_DUR_COM_DL_FRE_HHO_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C367'          , 'xmlns="'||XMLNS||'"') ALLO_COM_UL_SYS_HHO_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C368'          , 'xmlns="'||XMLNS||'"') ALLO_COM_DL_SYS_HHO_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C369'          , 'xmlns="'||XMLNS||'"') ALLO_DUR_COM_UL_SYS_HHO_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C370'          , 'xmlns="'||XMLNS||'"') ALLO_DUR_COM_DL_SYS_HHO_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C371'          , 'xmlns="'||XMLNS||'"') DCH_HHO_REQ_LINK_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C372'          , 'xmlns="'||XMLNS||'"') DCH_HHO_REQ_LINK_REJ_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C373'          , 'xmlns="'||XMLNS||'"') REQ_CS_VOICE_HHO_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C374'          , 'xmlns="'||XMLNS||'"') REQ_CS_VOICE_HHO_REJ_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C375'          , 'xmlns="'||XMLNS||'"') DCH_HHO_REQ_DATA_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C376'          , 'xmlns="'||XMLNS||'"') DCH_HHO_REQ_DATA_REJ_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C377'          , 'xmlns="'||XMLNS||'"') REQ_CMOD_UL_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C378'          , 'xmlns="'||XMLNS||'"') REQ_CMOD_DL_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C379'          , 'xmlns="'||XMLNS||'"') REQ_CMOD_UL_REJ_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C380'          , 'xmlns="'||XMLNS||'"') REQ_CMOD_DL_REJ_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C381'          , 'xmlns="'||XMLNS||'"') ALLO_CMOD_UL_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C382'          , 'xmlns="'||XMLNS||'"') ALLO_CMOD_DL_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C383'          , 'xmlns="'||XMLNS||'"') ALLO_DURA_CMOD_UL_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C384'          , 'xmlns="'||XMLNS||'"') ALLO_DURA_CMOD_DL_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C385'          , 'xmlns="'||XMLNS||'"') ALLO_HS_DSCH_FLOW_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C386'          , 'xmlns="'||XMLNS||'"') ALLO_HS_DSCH_RET_64_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C387'          , 'xmlns="'||XMLNS||'"') ALLO_HS_DSCH_RET_128_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C388'          , 'xmlns="'||XMLNS||'"') ALLO_HS_DSCH_RET_384_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C389'          , 'xmlns="'||XMLNS||'"') ALLO_HS_DSCH_FLOW_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C390'          , 'xmlns="'||XMLNS||'"') ALLO_HS_DSCH_RET_64_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C391'          , 'xmlns="'||XMLNS||'"') ALLO_HS_DSCH_RET_128_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C392'          , 'xmlns="'||XMLNS||'"') ALLO_HS_DSCH_RET_384_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C393'          , 'xmlns="'||XMLNS||'"') ALLO_DUR_HS_DSCH_FLOW_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C394'          , 'xmlns="'||XMLNS||'"') ALLO_DUR_HS_DSCH_RET_64_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C395'          , 'xmlns="'||XMLNS||'"') ALLO_DUR_HS_DSCH_RET_128_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C396'          , 'xmlns="'||XMLNS||'"') ALLO_DUR_HS_DSCH_RET_384_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C397'          , 'xmlns="'||XMLNS||'"') ALLO_DUR_HS_DSCH_FLOW_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C398'          , 'xmlns="'||XMLNS||'"') ALLO_DUR_HS_DSCH_RET_64_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C399'          , 'xmlns="'||XMLNS||'"') ALLO_DUR_HS_DSCH_RET_128_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C400'          , 'xmlns="'||XMLNS||'"') ALLO_DUR_HS_DSCH_RET_384_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C401'          , 'xmlns="'||XMLNS||'"') REJ_HS_DSCH_RET_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C402'          , 'xmlns="'||XMLNS||'"') REJ_HS_DSCH_RET_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C403'          , 'xmlns="'||XMLNS||'"') REJ_HS_DSCH_AMR_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C404'          , 'xmlns="'||XMLNS||'"') SETUP_FAIL_HS_DSCH_AMR_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C405'          , 'xmlns="'||XMLNS||'"') ALLO_HS_DSCH_AMR_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C406'          , 'xmlns="'||XMLNS||'"') REL_ALLO_NORM_HSDSCH_AMR_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C407'          , 'xmlns="'||XMLNS||'"') REL_ALLO_NORM_HS_DSCH_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C408'          , 'xmlns="'||XMLNS||'"') REL_ALLO_OTH_FAIL_HSDSCH_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C409'          , 'xmlns="'||XMLNS||'"') REL_ALLO_HS_DSCH_MOB_DCH_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C410'          , 'xmlns="'||XMLNS||'"') REL_ALLO_NORM_HS_DSCH_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C411'          , 'xmlns="'||XMLNS||'"') REL_ALLO_OTH_FAIL_HSDSCH_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C412'          , 'xmlns="'||XMLNS||'"') REL_ALLO_HS_DSCH_MOB_DCH_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C413'          , 'xmlns="'||XMLNS||'"') SETUP_FAIL_RNC_HS_DSCH_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C414'          , 'xmlns="'||XMLNS||'"') SETUP_FAIL_IUB_MAC_D_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C415'          , 'xmlns="'||XMLNS||'"') SETUP_FAIL_UE_HS_DSCH_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C416'          , 'xmlns="'||XMLNS||'"') SETUP_FAIL_BTS_HS_DSCH_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C417'          , 'xmlns="'||XMLNS||'"') SETUP_FAIL_IUB_HS_TOTAL_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C418'          , 'xmlns="'||XMLNS||'"') SETUP_FAIL_64_IUB_HSDSCH_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C419'          , 'xmlns="'||XMLNS||'"') SETUP_FAIL_128_IUB_HSDSCH_IN,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C420'          , 'xmlns="'||XMLNS||'"') SETUP_FAIL_384_IUB_HSDSCH_IN,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C421'          , 'xmlns="'||XMLNS||'"') SETUP_FAIL_RNC_HS_DSCH_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C422'          , 'xmlns="'||XMLNS||'"') SETUP_FAIL_IUB_MAC_D_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C423'          , 'xmlns="'||XMLNS||'"') SETUP_FAIL_UE_HS_DSCH_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C424'          , 'xmlns="'||XMLNS||'"') SETUP_FAIL_BTS_HS_DSCH_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C425'          , 'xmlns="'||XMLNS||'"') SETUP_FAIL_IUB_HS_TOTAL_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C426'          , 'xmlns="'||XMLNS||'"') SETUP_FAIL_64_IUB_HSDSCH_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C427'          , 'xmlns="'||XMLNS||'"') SETUP_FAIL_128_IUB_HSDSCH_BG,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C428'          , 'xmlns="'||XMLNS||'"') SETUP_FAIL_384_IUB_HSDSCH_BG,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C429'          , 'xmlns="'||XMLNS||'"') HS_DSCH_RET_UPGRADE_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C430'          , 'xmlns="'||XMLNS||'"') HS_DSCH_RET_DOWNGRADE_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C431'          , 'xmlns="'||XMLNS||'"') HS_DSCH_RET_UPGRADE_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C432'          , 'xmlns="'||XMLNS||'"') HS_DSCH_RET_DOWNGRADE_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C433'          , 'xmlns="'||XMLNS||'"') ALLO_COM_UL_SF2_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C434'          , 'xmlns="'||XMLNS||'"') ALLO_COM_DL_SF2_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C435'          , 'xmlns="'||XMLNS||'"') ALLO_COM_UL_HLS_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C436'          , 'xmlns="'||XMLNS||'"') ALLO_COM_DL_HLS_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C437'          , 'xmlns="'||XMLNS||'"') ALLO_DUR_COM_UL_SF2_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C438'          , 'xmlns="'||XMLNS||'"') ALLO_DUR_COM_DL_SF2_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C439'          , 'xmlns="'||XMLNS||'"') ALLO_DUR_COM_UL_HLS_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C440'          , 'xmlns="'||XMLNS||'"') ALLO_DUR_COM_DL_HLS_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C441'          , 'xmlns="'||XMLNS||'"') ALLO_COM_UL_SF2_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C442'          , 'xmlns="'||XMLNS||'"') ALLO_COM_DL_SF2_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C443'          , 'xmlns="'||XMLNS||'"') ALLO_COM_UL_HLS_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C444'          , 'xmlns="'||XMLNS||'"') ALLO_COM_DL_HLS_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C445'          , 'xmlns="'||XMLNS||'"') ALLO_COM_DL_PUNCT_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C446'          , 'xmlns="'||XMLNS||'"') ALLO_DUR_COM_UL_SF2_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C447'          , 'xmlns="'||XMLNS||'"') ALLO_DUR_COM_DL_SF2_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C448'          , 'xmlns="'||XMLNS||'"') ALLO_DUR_COM_UL_HLS_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C449'          , 'xmlns="'||XMLNS||'"') ALLO_DUR_COM_DL_HLS_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C450'          , 'xmlns="'||XMLNS||'"') ALLO_DUR_COM_DL_PUNCT_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C451'          , 'xmlns="'||XMLNS||'"') DCH_SHO_STP_VOICE_FAIL_TRANS,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C452'          , 'xmlns="'||XMLNS||'"') DCH_SHO_STP_CSCONV_F_TRANS,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C453'          , 'xmlns="'||XMLNS||'"') DCH_SHO_STP_CSSTR_F_TRANS,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C454'          , 'xmlns="'||XMLNS||'"') DCH_SHO_STP_PSSTR_F_TRANS,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C455'          , 'xmlns="'||XMLNS||'"') DCH_SHO_STP_PSINT_F_TRANS,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C456'          , 'xmlns="'||XMLNS||'"') DCH_SHO_STP_PSBACKG_F_TRANS,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C457'          , 'xmlns="'||XMLNS||'"') UL_INI_STP_FAIL_INT_IUB_AAL2,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C458'          , 'xmlns="'||XMLNS||'"') UL_UPG_STP_FAIL_INT_IUB_AAL2,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C459'          , 'xmlns="'||XMLNS||'"') DL_INI_STP_FAIL_INT_IUB_AAL2,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C460'          , 'xmlns="'||XMLNS||'"') DL_UPG_STP_FAIL_INT_IUB_AAL2,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C461'          , 'xmlns="'||XMLNS||'"') UL_INI_STP_F_BACKG_IUB_AAL2,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C462'          , 'xmlns="'||XMLNS||'"') UL_UPG_STP_F_BACKG_IUB_AAL2,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C463'          , 'xmlns="'||XMLNS||'"') DL_INI_STP_F_BACKG_IUB_AAL2,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C464'          , 'xmlns="'||XMLNS||'"') DL_UPG_STP_F_BACKG_IUB_AAL2,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C465'          , 'xmlns="'||XMLNS||'"') UL_INI_STP_FAIL_INT_IUR_AAL2,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C466'          , 'xmlns="'||XMLNS||'"') UL_UPG_STP_FAIL_INT_IUR_AAL2,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C467'          , 'xmlns="'||XMLNS||'"') DL_INI_STP_FAIL_INT_IUR_AAL2,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C468'          , 'xmlns="'||XMLNS||'"') DL_UPG_STP_FAIL_INT_IUR_AAL2,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C469'          , 'xmlns="'||XMLNS||'"') UL_INI_STP_F_BACKG_IUR_AAL2,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C470'          , 'xmlns="'||XMLNS||'"') UL_UPG_STP_F_BACKG_IUR_AAL2,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C471'          , 'xmlns="'||XMLNS||'"') DL_INI_STP_F_BACKG_IUR_AAL2,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C472'          , 'xmlns="'||XMLNS||'"') DL_UPG_STP_F_BACKG_IUR_AAL2,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C473'          , 'xmlns="'||XMLNS||'"') DCH_STP_F_AMR_DRNC_EXTTRANS,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C474'          , 'xmlns="'||XMLNS||'"') DCH_STP_F_DATA_DRNC_EXTTRANS,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C475'          , 'xmlns="'||XMLNS||'"') DCH_SEL_MAX_HSDPA_USERS_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C476'          , 'xmlns="'||XMLNS||'"') DCH_SEL_MAX_HSDPA_USERS_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C477'          , 'xmlns="'||XMLNS||'"') REL_ALLO_HS_DSCH_OTH_DCH_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C478'          , 'xmlns="'||XMLNS||'"') REL_ALLO_HS_DSCH_PRE_EMP_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C479'          , 'xmlns="'||XMLNS||'"') REL_ALLO_RL_FAIL_HS_DSCH_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C480'          , 'xmlns="'||XMLNS||'"') REL_ALLO_HS_DSCH_OTH_DCH_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C481'          , 'xmlns="'||XMLNS||'"') REL_ALLO_HS_DSCH_PRE_EMP_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C482'          , 'xmlns="'||XMLNS||'"') REL_ALLO_RL_FAIL_HS_DSCH_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C483'          , 'xmlns="'||XMLNS||'"') REJ_HS_DSCH_AMR_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C484'          , 'xmlns="'||XMLNS||'"') SETUP_FAIL_HS_DSCH_AMR_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C485'          , 'xmlns="'||XMLNS||'"') ALLO_HS_DSCH_AMR_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C486'          , 'xmlns="'||XMLNS||'"') REL_ALLO_NORM_HSDSCH_AMR_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C487'          , 'xmlns="'||XMLNS||'"') ALLO_FOR_WAMR_12_65_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C488'          , 'xmlns="'||XMLNS||'"') ALLO_FOR_WAMR_6_6_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C489'          , 'xmlns="'||XMLNS||'"') DURA_FOR_WAMR_12_65_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C490'          , 'xmlns="'||XMLNS||'"') DURA_FOR_WAMR_6_6_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C491'          , 'xmlns="'||XMLNS||'"') ALLO_FOR_WAMR_12_65_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C492'          , 'xmlns="'||XMLNS||'"') ALLO_FOR_WAMR_8_85_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C493'          , 'xmlns="'||XMLNS||'"') ALLO_FOR_WAMR_6_6_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C494'          , 'xmlns="'||XMLNS||'"') DURA_FOR_WAMR_12_65_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C495'          , 'xmlns="'||XMLNS||'"') DURA_FOR_WAMR_8_85_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C496'          , 'xmlns="'||XMLNS||'"') DURA_FOR_WAMR_6_6_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C497'          , 'xmlns="'||XMLNS||'"') SWI_FROM_WAMR_TO_NAMR_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C498'          , 'xmlns="'||XMLNS||'"') SWI_FROM_NAMR_TO_WAMR_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C499'          , 'xmlns="'||XMLNS||'"') SWI_FROM_WAMR_TO_NAMR_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C500'          , 'xmlns="'||XMLNS||'"') SWI_FROM_NAMR_TO_WAMR_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C501'          , 'xmlns="'||XMLNS||'"') ALLO_HS_DSCH_RET_16_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C502'          , 'xmlns="'||XMLNS||'"') ALLO_HS_DSCH_RET_16_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C503'          , 'xmlns="'||XMLNS||'"') ALLO_DUR_HS_DSCH_RET_16_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C504'          , 'xmlns="'||XMLNS||'"') ALLO_DUR_HS_DSCH_RET_16_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C505'          , 'xmlns="'||XMLNS||'"') SETUP_FAIL_16_IUB_HSDSCH_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C506'          , 'xmlns="'||XMLNS||'"') SETUP_FAIL_16_IUB_HSDSCH_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C507'          , 'xmlns="'||XMLNS||'"') SWI_DCH_TO_HS_DSCH_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C508'          , 'xmlns="'||XMLNS||'"') SWI_DCH_TO_HS_DSCH_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C509'          , 'xmlns="'||XMLNS||'"') DCH_ALLO_NON_HSPA_TO_HSPA,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C510'          , 'xmlns="'||XMLNS||'"') DCH_ALLO_HSPA_TO_NON_HSPA,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C511'          , 'xmlns="'||XMLNS||'"') DCH_ALLO_HSPA_TO_HSPA,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C512'          , 'xmlns="'||XMLNS||'"') FACH_DCH_NON_HSPA_TO_HSPA,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C513'          , 'xmlns="'||XMLNS||'"') FACH_DCH_HSPA_TO_NON_HSPA,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C514'          , 'xmlns="'||XMLNS||'"') FACH_DCH_HSPA_TO_HSPA,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C515'          , 'xmlns="'||XMLNS||'"') UL_DCH_SEL_MAX_HSUPA_USR_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C516'          , 'xmlns="'||XMLNS||'"') UL_DCH_SEL_MAX_HSUPA_USR_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C517'          , 'xmlns="'||XMLNS||'"') UL_DCH_SEL_BTS_HW_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C518'          , 'xmlns="'||XMLNS||'"') UL_DCH_SEL_BTS_HW_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C519'          , 'xmlns="'||XMLNS||'"') EDCH_ALLO_CANC_NA_AS_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C520'          , 'xmlns="'||XMLNS||'"') EDCH_ALLO_CANC_NA_AS_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C521'          , 'xmlns="'||XMLNS||'"') DL_DCH_SEL_HSDPA_POWER_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C522'          , 'xmlns="'||XMLNS||'"') DL_DCH_SEL_HSDPA_POWER_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C523'          , 'xmlns="'||XMLNS||'"') SETUP_FAIL_EDCH_UE_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C524'          , 'xmlns="'||XMLNS||'"') SETUP_FAIL_EDCH_UE_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C525'          , 'xmlns="'||XMLNS||'"') SETUP_FAIL_EDCH_BTS_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C526'          , 'xmlns="'||XMLNS||'"') SETUP_FAIL_EDCH_BTS_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C527'          , 'xmlns="'||XMLNS||'"') SETUP_FAIL_EDCH_TRANS_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C528'          , 'xmlns="'||XMLNS||'"') SETUP_FAIL_EDCH_TRANS_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C529'          , 'xmlns="'||XMLNS||'"') SETUP_FAIL_EDCH_OTHER_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C530'          , 'xmlns="'||XMLNS||'"') SETUP_FAIL_EDCH_OTHER_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C531'          , 'xmlns="'||XMLNS||'"') ALLO_SUCCESS_EDCH_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C532'          , 'xmlns="'||XMLNS||'"') ALLO_SUCCESS_EDCH_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C533'          , 'xmlns="'||XMLNS||'"') ALLO_DUR_EDCH_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C534'          , 'xmlns="'||XMLNS||'"') ALLO_DUR_EDCH_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C535'          , 'xmlns="'||XMLNS||'"') REL_EDCH_NORM_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C536'          , 'xmlns="'||XMLNS||'"') REL_EDCH_NORM_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C537'          , 'xmlns="'||XMLNS||'"') REL_EDCH_HSDSCH_SCC_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C538'          , 'xmlns="'||XMLNS||'"') REL_EDCH_HSDSCH_SCC_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C539'          , 'xmlns="'||XMLNS||'"') REL_EDCH_RL_FAIL_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C540'          , 'xmlns="'||XMLNS||'"') REL_EDCH_RL_FAIL_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C541'          , 'xmlns="'||XMLNS||'"') REL_EDCH_OTHER_FAIL_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C542'          , 'xmlns="'||XMLNS||'"') REL_EDCH_OTHER_FAIL_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C543'          , 'xmlns="'||XMLNS||'"') AMR_EDCH_ALLO,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C544'          , 'xmlns="'||XMLNS||'"') AMR_EDCH_NORMAL_REL,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C545'          , 'xmlns="'||XMLNS||'"') ALLO_HS_INTER_RNC_HHO_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C546'          , 'xmlns="'||XMLNS||'"') ALLO_HS_INTER_RNC_HHO_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C547'          , 'xmlns="'||XMLNS||'"') STP_F_HS_INTER_RNC_HHO_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C548'          , 'xmlns="'||XMLNS||'"') STP_F_HS_INTER_RNC_HHO_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C549'          , 'xmlns="'||XMLNS||'"') ALLO_ED_INTER_RNC_HHO_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C550'          , 'xmlns="'||XMLNS||'"') ALLO_ED_INTER_RNC_HHO_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C551'          , 'xmlns="'||XMLNS||'"') STP_F_ED_INTER_RNC_HHO_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C552'          , 'xmlns="'||XMLNS||'"') STP_F_ED_INTER_RNC_HHO_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C553'          , 'xmlns="'||XMLNS||'"') REJ_DCH_DUE_CODES_INT_DL,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C554'          , 'xmlns="'||XMLNS||'"') REJ_DCH_DUE_CODES_BGR_DL,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C555'          , 'xmlns="'||XMLNS||'"') REJ_DCH_DUE_POWER_INT_DL,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C556'          , 'xmlns="'||XMLNS||'"') REJ_DCH_DUE_POWER_BGR_DL,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C557'          , 'xmlns="'||XMLNS||'"') REJ_DCH_REC_DUE_CODES_INT_DL,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C558'          , 'xmlns="'||XMLNS||'"') REJ_DCH_REC_DUE_CODES_BGR_DL,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C559'          , 'xmlns="'||XMLNS||'"') REJ_DCH_REC_DUE_PWR_INT_DL,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C560'          , 'xmlns="'||XMLNS||'"') REJ_DCH_REC_DUE_PWR_BGR_DL,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C561'          , 'xmlns="'||XMLNS||'"') AMR_LOWER_CODEC_SF128_INC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C562'          , 'xmlns="'||XMLNS||'"') AMR_LOWER_CODEC_SF256_INC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C563'          , 'xmlns="'||XMLNS||'"') LOAD_AMR_DGR_SF128_SUCCESS,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C564'          , 'xmlns="'||XMLNS||'"') LOAD_AMR_DGR_SF256_SUCCESS,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C565'          , 'xmlns="'||XMLNS||'"') LOAD_AMR_UPGRADE_SUCCESS,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C566'          , 'xmlns="'||XMLNS||'"') AMR_CODEC_CHANGE_FAIL_ICSU,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C567'          , 'xmlns="'||XMLNS||'"') AMR_CODEC_CHANGE_FAIL_OTHER,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C568'          , 'xmlns="'||XMLNS||'"') SWI_DCH_TO_HS_DSCH_STR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C569'          , 'xmlns="'||XMLNS||'"') ALLO_HS_DSCH_FLOW_STR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C570'          , 'xmlns="'||XMLNS||'"') ALLO_HS_DSCH_RET_16_STR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C571'          , 'xmlns="'||XMLNS||'"') ALLO_HS_DSCH_RET_64_STR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C572'          , 'xmlns="'||XMLNS||'"') ALLO_HS_DSCH_RET_128_STR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C573'          , 'xmlns="'||XMLNS||'"') ALLO_DUR_HS_DSCH_FLOW_STR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C574'          , 'xmlns="'||XMLNS||'"') ALLO_DUR_HS_DSCH_RET_16_STR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C575'          , 'xmlns="'||XMLNS||'"') ALLO_DUR_HS_DSCH_RET_64_STR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C576'          , 'xmlns="'||XMLNS||'"') ALLO_DUR_HS_DSCH_RET_128_STR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C577'          , 'xmlns="'||XMLNS||'"') REJ_HS_DSCH_RET_STR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C578'          , 'xmlns="'||XMLNS||'"') REL_ALLO_NORM_HS_DSCH_STR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C579'          , 'xmlns="'||XMLNS||'"') REL_ALLO_OTH_FAIL_HSDSCH_STR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C580'          , 'xmlns="'||XMLNS||'"') REL_ALLO_HS_DSCH_MOB_DCH_STR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C581'          , 'xmlns="'||XMLNS||'"') SETUP_FAIL_RNC_HS_DSCH_STR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C582'          , 'xmlns="'||XMLNS||'"') SETUP_FAIL_IUB_MAC_D_STR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C583'          , 'xmlns="'||XMLNS||'"') SETUP_FAIL_UE_HS_DSCH_STR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C584'          , 'xmlns="'||XMLNS||'"') SETUP_FAIL_BTS_HS_DSCH_STR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C585'          , 'xmlns="'||XMLNS||'"') SETUP_FAIL_IUB_HS_TOTAL_STR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C586'          , 'xmlns="'||XMLNS||'"') SETUP_FAIL_16_IUB_HSDSCH_STR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C587'          , 'xmlns="'||XMLNS||'"') SETUP_FAIL_64_IUB_HSDSCH_STR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C588'          , 'xmlns="'||XMLNS||'"') SETUP_FAIL_128_IUB_HSDSCH_ST,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C589'          , 'xmlns="'||XMLNS||'"') HS_DSCH_RET_UPGRADE_STR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C590'          , 'xmlns="'||XMLNS||'"') HS_DSCH_RET_DOWNGRADE_STR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C591'          , 'xmlns="'||XMLNS||'"') DCH_SEL_MAX_HSDPA_USERS_STR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C592'          , 'xmlns="'||XMLNS||'"') REL_ALLO_HS_DSCH_OTH_DCH_STR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C593'          , 'xmlns="'||XMLNS||'"') REL_ALLO_HS_DSCH_PRE_EMP_STR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C594'          , 'xmlns="'||XMLNS||'"') REL_ALLO_RL_FAIL_HS_DSCH_STR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C595'          , 'xmlns="'||XMLNS||'"') REJ_HS_DSCH_AMR_STR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C596'          , 'xmlns="'||XMLNS||'"') SETUP_FAIL_HS_DSCH_AMR_STR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C597'          , 'xmlns="'||XMLNS||'"') ALLO_HS_DSCH_AMR_STR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C598'          , 'xmlns="'||XMLNS||'"') REL_ALLO_NORM_HSDSCH_AMR_STR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C599'          , 'xmlns="'||XMLNS||'"') UL_DCH_SEL_MAX_HSUPA_USR_STR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C600'          , 'xmlns="'||XMLNS||'"') UL_DCH_SEL_BTS_HW_STR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C601'          , 'xmlns="'||XMLNS||'"') EDCH_ALLO_CANC_NA_AS_STR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C602'          , 'xmlns="'||XMLNS||'"') DL_DCH_SEL_HSDPA_POWER_STR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C603'          , 'xmlns="'||XMLNS||'"') SETUP_FAIL_EDCH_UE_STR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C604'          , 'xmlns="'||XMLNS||'"') SETUP_FAIL_EDCH_BTS_STR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C605'          , 'xmlns="'||XMLNS||'"') SETUP_FAIL_EDCH_TRANS_STR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C606'          , 'xmlns="'||XMLNS||'"') SETUP_FAIL_EDCH_OTHER_STR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C607'          , 'xmlns="'||XMLNS||'"') ALLO_SUCCESS_EDCH_STR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C608'          , 'xmlns="'||XMLNS||'"') ALLO_DUR_EDCH_STR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C609'          , 'xmlns="'||XMLNS||'"') REL_EDCH_NORM_STR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C610'          , 'xmlns="'||XMLNS||'"') REL_EDCH_HSDSCH_SCC_STR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C611'          , 'xmlns="'||XMLNS||'"') REL_EDCH_RL_FAIL_STR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C612'          , 'xmlns="'||XMLNS||'"') REL_EDCH_OTHER_FAIL_STR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C613'          , 'xmlns="'||XMLNS||'"') ALLO_HS_INTER_RNC_HHO_STR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C614'          , 'xmlns="'||XMLNS||'"') STP_F_HS_INTER_RNC_HHO_STR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C615'          , 'xmlns="'||XMLNS||'"') ALLO_ED_INTER_RNC_HHO_STR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C616'          , 'xmlns="'||XMLNS||'"') STP_F_ED_INTER_RNC_HHO_STR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C617'          , 'xmlns="'||XMLNS||'"') ALLO_AMR_MULTINRT_HSPA,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C618'          , 'xmlns="'||XMLNS||'"') ALLO_MULTINRT_HSPA,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C619'          , 'xmlns="'||XMLNS||'"') ALLO_AMR_RT_NRT_HSPA,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C620'          , 'xmlns="'||XMLNS||'"') ALLO_AMR_RT_MULTINRT_HSPA,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C621'          , 'xmlns="'||XMLNS||'"') ALLO_RT_NRT_HSPA,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C622'          , 'xmlns="'||XMLNS||'"') ALLO_RT_MULTINRT_HSPA,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C623'          , 'xmlns="'||XMLNS||'"') ALLO_CM_HSDPA_IFHO,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C624'          , 'xmlns="'||XMLNS||'"') ALLO_DURA_CM_HSDPA_IFHO,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C625'          , 'xmlns="'||XMLNS||'"') REJ_CM_HSDPA_IFHO,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C626'          , 'xmlns="'||XMLNS||'"') REJ_DCH_DUE_POWER_INT_UL,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C627'          , 'xmlns="'||XMLNS||'"') REJ_DCH_DUE_POWER_BGR_UL,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C628'          , 'xmlns="'||XMLNS||'"') REJ_DCH_REC_DUE_PWR_INT_UL,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C629'          , 'xmlns="'||XMLNS||'"') REJ_DCH_REC_DUE_PWR_BGR_UL,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C630'          , 'xmlns="'||XMLNS||'"') ATT_HS_DSCH_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C631'          , 'xmlns="'||XMLNS||'"') ALLO_HS_DSCH_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C632'          , 'xmlns="'||XMLNS||'"') ALLO_DUR_HS_DSCH_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C633'          , 'xmlns="'||XMLNS||'"') ATT_EDCH_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C634'          , 'xmlns="'||XMLNS||'"') ALLO_EDCH_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C635'          , 'xmlns="'||XMLNS||'"') ALLO_DUR_EDCH_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C636'          , 'xmlns="'||XMLNS||'"') SETUP_FAIL_BTS_HS_DSCH_AMR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C637'          , 'xmlns="'||XMLNS||'"') SETUP_FAIL_UE_HS_DSCH_AMR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C638'          , 'xmlns="'||XMLNS||'"') SETUP_FAIL_TRANS_HS_DSCH_AMR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C639'          , 'xmlns="'||XMLNS||'"') SETUP_FAIL_OTHER_HS_DSCH_AMR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C640'          , 'xmlns="'||XMLNS||'"') SETUP_FAIL_BTS_EDCH_AMR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C641'          , 'xmlns="'||XMLNS||'"') SETUP_FAIL_UE_EDCH_AMR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C642'          , 'xmlns="'||XMLNS||'"') SETUP_FAIL_TRANS_EDCH_AMR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C643'          , 'xmlns="'||XMLNS||'"') SETUP_FAIL_OTHER_EDCH_AMR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C644'          , 'xmlns="'||XMLNS||'"') REL_ALLO_NORM_HS_DSCH_AMR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C645'          , 'xmlns="'||XMLNS||'"') REL_ALLO_RL_FAIL_HS_DSCH_AMR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C646'          , 'xmlns="'||XMLNS||'"') REL_ALLO_OTH_FAIL_HSDSCH_AMR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C647'          , 'xmlns="'||XMLNS||'"') REL_ALLO_NORM_EDCH_AMR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C648'          , 'xmlns="'||XMLNS||'"') REL_ALLO_RL_FAIL_EDCH_AMR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C649'          , 'xmlns="'||XMLNS||'"') REL_ALLO_OTH_FAIL_EDCH_AMR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C650'          , 'xmlns="'||XMLNS||'"') SWI_R99_TO_HSPA_CS_VOICE,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C651'          , 'xmlns="'||XMLNS||'"') SWI_HSPA_TO_R99_CS_AMR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C652'          , 'xmlns="'||XMLNS||'"') ALLO_HS_DSCH_5_9_AMR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C653'          , 'xmlns="'||XMLNS||'"') ALLO_HS_DSCH_12_2_AMR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C654'          , 'xmlns="'||XMLNS||'"') ALLO_HS_DSCH_12_65_AMR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C655'          , 'xmlns="'||XMLNS||'"') ALLO_DUR_HS_DSCH_5_9_AMR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C656'          , 'xmlns="'||XMLNS||'"') ALLO_DUR_HS_DSCH_12_2_AMR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C657'          , 'xmlns="'||XMLNS||'"') ALLO_DUR_HS_DSCH_12_65_AMR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C658'          , 'xmlns="'||XMLNS||'"') ALLO_SUCCESS_EDCH_AMR_5_9,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C659'          , 'xmlns="'||XMLNS||'"') ALLO_SUCCESS_EDCH_AMR_12_2,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C660'          , 'xmlns="'||XMLNS||'"') ALLO_SUCCESS_EDCH_AMR_12_65,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C661'          , 'xmlns="'||XMLNS||'"') ALLO_DUR_EDCH_5_9_AMR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C662'          , 'xmlns="'||XMLNS||'"') ALLO_DUR_EDCH_12_2_AMR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C663'          , 'xmlns="'||XMLNS||'"') ALLO_DUR_EDCH_12_65_AMR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C664'          , 'xmlns="'||XMLNS||'"') ALLO_EDCH_SRB_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C665'          , 'xmlns="'||XMLNS||'"') ALLO_EDCH_SRB_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C666'          , 'xmlns="'||XMLNS||'"') ALLO_HS_DSCH_SRB_SRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C667'          , 'xmlns="'||XMLNS||'"') ALLO_HS_DSCH_SRB_DRNC,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C668'          , 'xmlns="'||XMLNS||'"') ALLO_DUR_HS_DSCH_INACTIV_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C669'          , 'xmlns="'||XMLNS||'"') ALLO_DUR_HS_DSCH_INACTIV_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C670'          , 'xmlns="'||XMLNS||'"') ALLO_DUR_EDCH_INACTIV_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C671'          , 'xmlns="'||XMLNS||'"') ALLO_DUR_EDCH_INACTIV_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C672'          , 'xmlns="'||XMLNS||'"') ATT_HSPA_DIREAL_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C673'          , 'xmlns="'||XMLNS||'"') ATT_HSPA_DIREAL_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C674'          , 'xmlns="'||XMLNS||'"') ALLO_SUCC_HSPA_DIREAL_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C675'          , 'xmlns="'||XMLNS||'"') ALLO_SUCC_HSPA_DIREAL_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C676'          , 'xmlns="'||XMLNS||'"') ALLO_CM_HSUPA_IFHO,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C677'          , 'xmlns="'||XMLNS||'"') ALLO_DURA_CM_HSUPA_IFHO,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C678'          , 'xmlns="'||XMLNS||'"') REJ_CM_HSUPA_IFHO,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C679'          , 'xmlns="'||XMLNS||'"') TRAFFIC_SPARE_1,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C680'          , 'xmlns="'||XMLNS||'"') TRAFFIC_SPARE_2,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C681'          , 'xmlns="'||XMLNS||'"') SETUP_REJ_EDCH_AC_INT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C682'          , 'xmlns="'||XMLNS||'"') SETUP_REJ_EDCH_AC_BGR,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C683'          , 'xmlns="'||XMLNS||'"') ALLO_HS_DSCH_FLOW_PTT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C684'          , 'xmlns="'||XMLNS||'"') ALLO_SUCCESS_EDCH_PTT,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C688'          , 'xmlns="'||XMLNS||'"') MEH_ADMIT_CS_VOICE,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C689'          , 'xmlns="'||XMLNS||'"') MEH_REJECT_2MS_EDCH_TTI,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C686'          , 'xmlns="'||XMLNS||'"') MEH_REJECT_EDCH,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C687'          , 'xmlns="'||XMLNS||'"') MEH_REJECT_HSDSCH,
       EXTRACTVALUE(VALUE(X),'/PMMOResult/PMTarget/M1002C685'          , 'xmlns="'||XMLNS||'"') MEH_RESTR_R99_UL_DCH

       FROM T, TABLE(XMLSEQUENCE(EXTRACT(T.XMLCOL,'/OMeS/PMSetup/PMMOResult','xmlns="'||XMLNS||'"'))) X;
    
      -- update table STATUS_PROCESS_ETL whith information the xml status 1: processed.
     update STATUS_PROCESS_ETL set status ='1' where filename = p_file_name;
     return_result := 1 ;
     return return_result;
    
     EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20001,'Se ha encontrado un error - '||SQLCODE||' -ERROR- '||SQLERRM);
      -- update table STATUS_PROCESS_ETL whith information the xml status 2: error processed.
     update STATUS_PROCESS_ETL set status ='2' where filename = p_file_name;
       
     return_result := 2 ;
     return return_result;   
     
 END parser_UMTS_Traffic;      

END com_util_parse;

/
