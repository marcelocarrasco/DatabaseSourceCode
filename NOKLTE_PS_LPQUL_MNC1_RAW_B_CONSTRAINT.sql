--------------------------------------------------------
--  Constraints for Table NOKLTE_PS_LPQUL_MNC1_RAW_B
--------------------------------------------------------

  ALTER TABLE "HARRIAGUE"."NOKLTE_PS_LPQUL_MNC1_RAW_B" ADD CONSTRAINT "NOKLTE_PK_LPQUL_MNC1_RAW_B" PRIMARY KEY ("PERIOD_START_TIME", "INT_ID", "MCC_ID", "MNC_ID") ENABLE;
 
  ALTER TABLE "HARRIAGUE"."NOKLTE_PS_LPQUL_MNC1_RAW_B" MODIFY ("INT_ID" NOT NULL ENABLE);
 
  ALTER TABLE "HARRIAGUE"."NOKLTE_PS_LPQUL_MNC1_RAW_B" MODIFY ("LNCEL_ID" NOT NULL ENABLE);
 
  ALTER TABLE "HARRIAGUE"."NOKLTE_PS_LPQUL_MNC1_RAW_B" MODIFY ("MCC_ID" NOT NULL ENABLE);
 
  ALTER TABLE "HARRIAGUE"."NOKLTE_PS_LPQUL_MNC1_RAW_B" MODIFY ("MNC_ID" NOT NULL ENABLE);
 
  ALTER TABLE "HARRIAGUE"."NOKLTE_PS_LPQUL_MNC1_RAW_B" MODIFY ("PERIOD_START_TIME" NOT NULL ENABLE);
