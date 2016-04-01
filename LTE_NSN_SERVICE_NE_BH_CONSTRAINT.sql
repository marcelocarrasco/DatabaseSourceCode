--------------------------------------------------------
--  Constraints for Table LTE_NSN_SERVICE_NE_BH
--------------------------------------------------------

  ALTER TABLE "HARRIAGUE"."LTE_NSN_SERVICE_NE_BH" ADD CONSTRAINT "LTE_NSN_SERVICE_NE_BH_PK" PRIMARY KEY ("FECHA", "ELEMENT_CLASS", "ELEMENT_ID") ENABLE;
 
  ALTER TABLE "HARRIAGUE"."LTE_NSN_SERVICE_NE_BH" MODIFY ("FECHA" NOT NULL ENABLE);
 
  ALTER TABLE "HARRIAGUE"."LTE_NSN_SERVICE_NE_BH" MODIFY ("ELEMENT_CLASS" NOT NULL ENABLE);
 
  ALTER TABLE "HARRIAGUE"."LTE_NSN_SERVICE_NE_BH" MODIFY ("ELEMENT_ID" NOT NULL ENABLE);
