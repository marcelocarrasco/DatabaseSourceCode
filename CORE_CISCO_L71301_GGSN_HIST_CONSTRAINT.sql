--------------------------------------------------------
--  Constraints for Table CORE_CISCO_L71301_GGSN_HIST
--------------------------------------------------------

  ALTER TABLE "HARRIAGUE"."CORE_CISCO_L71301_GGSN_HIST" ADD CONSTRAINT "CORE_CISCO_L71301_GGSN_PK" PRIMARY KEY ("FECHA", "GWNAME", "SERVID", "SERVNAME") ENABLE;
 
  ALTER TABLE "HARRIAGUE"."CORE_CISCO_L71301_GGSN_HIST" MODIFY ("FECHA" NOT NULL ENABLE);
 
  ALTER TABLE "HARRIAGUE"."CORE_CISCO_L71301_GGSN_HIST" MODIFY ("FILENAME" NOT NULL ENABLE);
 
  ALTER TABLE "HARRIAGUE"."CORE_CISCO_L71301_GGSN_HIST" MODIFY ("SCHEMANAME" NOT NULL ENABLE);
 
  ALTER TABLE "HARRIAGUE"."CORE_CISCO_L71301_GGSN_HIST" MODIFY ("ORDEN" NOT NULL ENABLE);
