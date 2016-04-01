--------------------------------------------------------
--  Constraints for Table LTE_NSN_AVAIL_NE_DAYW
--------------------------------------------------------

  ALTER TABLE "HARRIAGUE"."LTE_NSN_AVAIL_NE_DAYW" ADD CONSTRAINT "LTE_NSN_AVAIL_NE_DAYW_PK" PRIMARY KEY ("FECHA", "ELEMENT_CLASS", "ELEMENT_ID") ENABLE;
 
  ALTER TABLE "HARRIAGUE"."LTE_NSN_AVAIL_NE_DAYW" MODIFY ("FECHA" NOT NULL ENABLE);
 
  ALTER TABLE "HARRIAGUE"."LTE_NSN_AVAIL_NE_DAYW" MODIFY ("ELEMENT_CLASS" NOT NULL ENABLE);
 
  ALTER TABLE "HARRIAGUE"."LTE_NSN_AVAIL_NE_DAYW" MODIFY ("ELEMENT_ID" NOT NULL ENABLE);
