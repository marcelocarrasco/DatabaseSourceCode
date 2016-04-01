--------------------------------------------------------
--  Constraints for Table NOKLTE_PS_LCELLR_MNC1_RAW
--------------------------------------------------------

  ALTER TABLE "HARRIAGUE"."NOKLTE_PS_LCELLR_MNC1_RAW" ADD CONSTRAINT "NOKLTE_PK_LCELLR_MNC1_RAW" PRIMARY KEY ("PERIOD_START_TIME", "INT_ID", "MCC_ID", "MNC_ID") ENABLE;
 
  ALTER TABLE "HARRIAGUE"."NOKLTE_PS_LCELLR_MNC1_RAW" MODIFY ("INT_ID" NOT NULL ENABLE);
 
  ALTER TABLE "HARRIAGUE"."NOKLTE_PS_LCELLR_MNC1_RAW" MODIFY ("LNCEL_ID" NOT NULL ENABLE);
 
  ALTER TABLE "HARRIAGUE"."NOKLTE_PS_LCELLR_MNC1_RAW" MODIFY ("MCC_ID" NOT NULL ENABLE);
 
  ALTER TABLE "HARRIAGUE"."NOKLTE_PS_LCELLR_MNC1_RAW" MODIFY ("MNC_ID" NOT NULL ENABLE);
 
  ALTER TABLE "HARRIAGUE"."NOKLTE_PS_LCELLR_MNC1_RAW" MODIFY ("PERIOD_START_TIME" NOT NULL ENABLE);
