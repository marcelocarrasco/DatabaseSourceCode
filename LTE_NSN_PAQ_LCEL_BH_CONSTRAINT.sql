--------------------------------------------------------
--  Constraints for Table LTE_NSN_PAQ_LCEL_BH
--------------------------------------------------------

  ALTER TABLE "HARRIAGUE"."LTE_NSN_PAQ_LCEL_BH" ADD CONSTRAINT "LTE_NSN_PAQ_LCEL_BH_PK" PRIMARY KEY ("FECHA", "LNCEL_ID") ENABLE;
 
  ALTER TABLE "HARRIAGUE"."LTE_NSN_PAQ_LCEL_BH" MODIFY ("FECHA" NOT NULL ENABLE);
 
  ALTER TABLE "HARRIAGUE"."LTE_NSN_PAQ_LCEL_BH" MODIFY ("LNCEL_ID" NOT NULL ENABLE);
