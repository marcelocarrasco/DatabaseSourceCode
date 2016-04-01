--------------------------------------------------------
--  DDL for Function F_LTE_NSN_NE_DAYM_REWORK
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "HARRIAGUE"."F_LTE_NSN_NE_DAYM_REWORK" 
   ( P_FECHA_DESDE IN CHAR, P_FECHA_HASTA IN CHAR)
   RETURN NUMBER
IS
   CNUMBER NUMBER;
   REWORK_STATUS VARCHAR2(50);
   PAQ_VALUE NUMBER;
   SRV_VALUE NUMBER;
   AVA_VALUE NUMBER;


BEGIN

  REWORK_STATUS := F_LTE_NSN_CHECK_REWORK('F_LTE_NSN_NE_DAYM_REWORK') ;

   IF REWORK_STATUS = 'STOPPED' THEN


      P_LTE_NSN_UPDATE_REWORK ('F_LTE_NSN_NE_DAYM_REWORK' , 'WORKING');

      P_LTE_NSN_PAQ_NE_INS_MONTH_R(P_FECHA_DESDE, P_FECHA_HASTA, 'DAYM', PAQ_VALUE);
      P_LTE_NSN_SRV_NE_INS_MONTH_R(P_FECHA_DESDE, P_FECHA_HASTA, 'DAYM', SRV_VALUE);
      P_LTE_NSN_AVA_NE_INS_MONTH_R(P_FECHA_DESDE, P_FECHA_HASTA, 'DAYM', AVA_VALUE);

      IF PAQ_VALUE = 0 AND SRV_VALUE = 0 AND AVA_VALUE = 0 THEN

        P_LTE_NSN_UPDATE_REWORK ('F_LTE_NSN_NE_DAYM_REWORK' , 'STOPPED');

        CNUMBER := 0; -- means OK
      ELSE

        P_LTE_NSN_UPDATE_REWORK ('F_LTE_NSN_NE_DAYM_REWORK' , 'STOPPED');

        CNUMBER := -1; -- means error on rework
      END IF;
   ELSE
      CNUMBER := 1; -- means rework already in progress
   END IF;

RETURN CNUMBER;

EXCEPTION
WHEN OTHERS THEN
   RAISE_APPLICATION_ERROR(-20001,'AN ERROR WAS ENCOUNTERED - '||SQLCODE||' -ERROR- '||SQLERRM);
END;

/
