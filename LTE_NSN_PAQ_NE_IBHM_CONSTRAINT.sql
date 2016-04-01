--------------------------------------------------------
--  Constraints for Table LTE_NSN_PAQ_NE_IBHM
--------------------------------------------------------

  ALTER TABLE "HARRIAGUE"."LTE_NSN_PAQ_NE_IBHM" ADD CONSTRAINT "LTE_NSN_PAQ_NE_IBHM_PK" PRIMARY KEY ("FECHA", "ELEMENT_CLASS", "ELEMENT_ID") ENABLE;
 
  ALTER TABLE "HARRIAGUE"."LTE_NSN_PAQ_NE_IBHM" MODIFY ("FECHA" NOT NULL ENABLE);
 
  ALTER TABLE "HARRIAGUE"."LTE_NSN_PAQ_NE_IBHM" MODIFY ("ELEMENT_CLASS" NOT NULL ENABLE);
 
  ALTER TABLE "HARRIAGUE"."LTE_NSN_PAQ_NE_IBHM" MODIFY ("ELEMENT_ID" NOT NULL ENABLE);
