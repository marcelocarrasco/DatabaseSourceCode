--------------------------------------------------------
--  Constraints for Table LTE_NSN_PAQ_LCEL_IBHW
--------------------------------------------------------

  ALTER TABLE "HARRIAGUE"."LTE_NSN_PAQ_LCEL_IBHW" ADD CONSTRAINT "LTE_NSN_PAQ_LCEL_IBHW_PK" PRIMARY KEY ("FECHA", "LNCEL_ID") ENABLE;
 
  ALTER TABLE "HARRIAGUE"."LTE_NSN_PAQ_LCEL_IBHW" MODIFY ("FECHA" NOT NULL ENABLE);
 
  ALTER TABLE "HARRIAGUE"."LTE_NSN_PAQ_LCEL_IBHW" MODIFY ("LNCEL_ID" NOT NULL ENABLE);
