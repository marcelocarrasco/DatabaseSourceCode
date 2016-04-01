--------------------------------------------------------
--  DDL for Function F_LTE_GET_GID
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "HARRIAGUE"."F_LTE_GET_GID" (P_OBJECT_CLASS  IN NUMBER,
                                         P_LNCEL_INSTANCE IN NUMBER,
                                         P_LNBTS_INSTANCE IN NUMBER,
                                         P_RNBTS_INSTANCE IN NUMBER,
                                         P_FLEXINS_INSTANCE IN NUMBER,
                                         P_R_TYPE_GID IN VARCHAR) RETURN NUMBER
AS
V_INT_ID NUMBER;
V_LNCEL_ID NUMBER;
V_LNBTS_ID  NUMBER;
V_MRBTS_ID NUMBER;
V_RESULT   NUMBER;
V_CONDICION VARCHAR2(4000);
sql_stmt VARCHAR2(4000);
BEGIN
  
IF P_OBJECT_CLASS = 3130  THEN
     V_CONDICION:= ' LNCEL_OBJECT_CLASS = 3130
                         AND LNCEL_OBJECT_NRO = ' || P_LNCEL_INSTANCE ||
                         ' AND LNBTS_OBJECT_NRO = ' || P_LNBTS_INSTANCE ||
                         ' AND SYSDATE BETWEEN LNCEL_VALID_START_DATE AND LNCEL_VALID_FINISH_DATE
                         AND ROWNUM =1 ';
               
ELSIF P_OBJECT_CLASS = 3129 THEN 

    V_CONDICION:= ' LNBTS_OBJECT_CLASS = 3129
                    AND LNBTS_OBJECT_NRO = ' || P_LNBTS_INSTANCE ||
                  ' AND SYSDATE BETWEEN LNCEL_VALID_START_DATE AND LNCEL_VALID_FINISH_DATE
                    AND ROWNUM =1 ';
                          
ELSIF P_OBJECT_CLASS = 3766 THEN 
      
  sql_stmt := 'SELECT INT_ID
      FROM MULTIVENDOR_OBJECTS
      WHERE OBJECT_CLASS = 3766                   
      AND OBJECT_NRO = ' || P_FLEXINS_INSTANCE ||  
      ' AND SYSDATE BETWEEN VALID_START_DATE AND VALID_FINISH_DATE
      AND ROWNUM =1 ';

   EXECUTE IMMEDIATE sql_stmt INTO V_INT_ID ;  
   V_RESULT := V_INT_ID; 
   RETURN V_RESULT;          
                          
END IF;

sql_stmt:= 'SELECT 
  LNBTS_PARENT_ID AS MRBTS_ID,
  LNBTS_ID,
  LNCEL_ID
  FROM OBJECTS_SP_LTE
  WHERE ' || V_CONDICION;
   
 EXECUTE IMMEDIATE sql_stmt INTO V_MRBTS_ID, V_LNBTS_ID, V_LNCEL_ID; 
   
    IF P_R_TYPE_GID = 'MRBTS_ID' THEN
      IF V_MRBTS_ID IS NOT NULL THEN V_RESULT := V_MRBTS_ID;
       ELSE V_RESULT := P_RNBTS_INSTANCE;
      END IF;
    END IF;     
      
    IF P_R_TYPE_GID = 'LNBTS_ID' THEN
      IF V_LNBTS_ID IS NOT NULL THEN V_RESULT := V_LNBTS_ID;
       ELSE V_RESULT := P_RNBTS_INSTANCE||P_LNBTS_INSTANCE;
      END IF;
    END IF;    
       
    IF P_R_TYPE_GID = 'LNCEL_ID'  THEN
      IF V_LNCEL_ID IS NOT NULL THEN V_RESULT := V_LNCEL_ID;
       ELSE V_RESULT := P_RNBTS_INSTANCE||P_LNBTS_INSTANCE||P_LNCEL_INSTANCE;
      END IF;
    END IF;  
 
  RETURN V_RESULT;
  
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
       IF P_R_TYPE_GID = 'MRBTS_ID' THEN
      IF V_MRBTS_ID IS NOT NULL THEN V_RESULT := V_MRBTS_ID;
       ELSE V_RESULT := P_RNBTS_INSTANCE;
      END IF;
    END IF;     
      
    IF P_R_TYPE_GID = 'LNBTS_ID' THEN
      IF V_LNBTS_ID IS NOT NULL THEN V_RESULT := V_LNBTS_ID;
       ELSE V_RESULT := P_RNBTS_INSTANCE||P_LNBTS_INSTANCE;
      END IF;
    END IF;    
       
    IF P_R_TYPE_GID = 'LNCEL_ID'  THEN
      IF V_LNCEL_ID IS NOT NULL THEN V_RESULT := V_LNCEL_ID;
       ELSE V_RESULT := P_RNBTS_INSTANCE||P_LNBTS_INSTANCE||P_LNCEL_INSTANCE;
      END IF;
    END IF;
    
    IF P_R_TYPE_GID = 'FINS_ID'  THEN
      IF V_INT_ID IS NULL THEN V_RESULT := P_FLEXINS_INSTANCE;
      END IF;
    END IF;
    
 RETURN V_RESULT;

END;

/
