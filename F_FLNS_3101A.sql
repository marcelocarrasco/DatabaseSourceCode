--------------------------------------------------------
--  DDL for Function F_FLNS_3101A
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "HARRIAGUE"."F_FLNS_3101A" (P_FINI varchar2,P_FFIN varchar2 default null) return FLNS_TAB PIPELINED as
begin
  if p_ffin is null then
      for I in (select  FLNS.PERIOD_START_TIME  FECHA,
                        FLNS.PERIOD_DURATION    PERIOD_DURATION, 
                        FLNS.FINS_ID            FINS_ID, 
                        MO.MME_NAME             MME_NAME, 
                        FLNS.TA_ID              TA_ID, 
                        FLNS.FLNS_3101A         FLNS_3101A
                from (
                      select  PERIOD_START_TIME, 
                              PERIOD_DURATION,
                              FINS_ID, 
                              TA_ID,
                              sum(EPS_DETACH) AS FLNS_3101A
                      from PCOFNS_PS_MMMT_TA_RAW
                      where PERIOD_START_TIME between TO_DATE(P_FINI,'dd.mm.yyyy') 
                      and to_date(P_FINI,'dd.mm.yyyy')  
                      GROUP BY PERIOD_START_TIME, PERIOD_DURATION, FINS_ID, TA_ID
                      ) FLNS
                inner join (
    --                  SELECT  SGSN_NAME AS MME_NAME,
    --                          SGSN_ID 
    --                  FROM VW_SGSN_OBJECTS
                      select INT_ID                 SGSN_ID,
                             NAME                   MME_NAME
                      from MULTIVENDOR_OBJECTS
                      WHERE VALID_FINISH_DATE > SYSDATE
                      ) MO
                on  MO.SGSN_ID = FLNS.FINS_ID) LOOP
        pipe row (FLNS_OBJ(i.FECHA,i.PERIOD_DURATION,i.FINS_ID,i.MME_NAME,i.TA_ID,i.FLNS_3101A));
      end LOOP;
  else
      for I in (select  FLNS.PERIOD_START_TIME  FECHA,
                        FLNS.PERIOD_DURATION    PERIOD_DURATION, 
                        FLNS.FINS_ID            FINS_ID, 
                        MO.MME_NAME             MME_NAME, 
                        FLNS.TA_ID              TA_ID, 
                        FLNS.FLNS_3101A         FLNS_3101A
                from (
                      select  PERIOD_START_TIME, 
                              PERIOD_DURATION,
                              FINS_ID, 
                              TA_ID,
                              sum(EPS_DETACH) AS FLNS_3101A
                      from PCOFNS_PS_MMMT_TA_RAW
                      where PERIOD_START_TIME between TO_DATE(P_FINI,'dd.mm.yyyy') 
                      and to_date(P_FFIN,'dd.mm.yyyy')  
                      GROUP BY PERIOD_START_TIME, PERIOD_DURATION, FINS_ID, TA_ID
                      ) FLNS
                inner join (
    --                  SELECT  SGSN_NAME AS MME_NAME,
    --                          SGSN_ID 
    --                  FROM VW_SGSN_OBJECTS
                      select INT_ID                 SGSN_ID,
                             NAME                   MME_NAME
                      from MULTIVENDOR_OBJECTS
                      WHERE VALID_FINISH_DATE > SYSDATE
                      ) MO
                on  MO.SGSN_ID = FLNS.FINS_ID) LOOP
        PIPE row (FLNS_OBJ(I.FECHA,I.PERIOD_DURATION,I.FINS_ID,I.MME_NAME,I.TA_ID,I.FLNS_3101A));
      end LOOP;
  end if;
  return;
end;

/
