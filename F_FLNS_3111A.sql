--------------------------------------------------------
--  DDL for Function F_FLNS_3111A
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "HARRIAGUE"."F_FLNS_3111A" (P_FINI VARCHAR2,P_FFIN VARCHAR2 DEFAULT NULL) RETURN FLNS_TAB PIPELINED AS
/**
* author: Carrasco Marcelo
* fecha: 11/02/2016
* @param: 
*/
  v_ffin varchar2(10 char) := '';
begin
  if P_FFIN is null then
    V_FFIN := P_FINI;
  else
    V_FFIN := P_FFIN;
  end if;

  for I in (SELECT  PERIOD_START_TIME FECHA,
                    PERIOD_DURATION, 
                    FINS_ID, 
                    TA_ID,
                    sum(PDN_CONNECTIVITY_FAILED_UE +
                        PDN_CONNECTIVITY_FAILED_ENB +
                        DDBEARER_UEINIT_ACT_SUCC +
                        DDBEARER_UEINIT_ACT_FAIL +
                        DDBEARER_PGWINIT_ACT_SUCC +
                        DDBEARER_PGWINIT_ACT_FAIL) AS FLNS_3111A
            from PCOFNS_PS_SMMT_TA_RAW
            where PERIOD_START_TIME between TO_DATE(P_FINI,'dd.mm.yyyy') 
            and to_date(V_FFIN,'dd.mm.yyyy')
            GROUP BY PERIOD_START_TIME, PERIOD_DURATION, FINS_ID, TA_ID
            ) LOOP
    pipe row (FLNS_OBJ(i.FECHA,i.PERIOD_DURATION,i.FINS_ID,null,i.TA_ID,i.FLNS_3111A));
  end LOOP;

  RETURN;
  exception
    WHEN others THEN
      pkg_error_log_new.p_log_error('F_FLNS_3111A',SQLCODE,SQLERRM,'parametros P_FINI '||P_FINI||' P_FFIN '||P_FFIN);
      raise;
end;

/
