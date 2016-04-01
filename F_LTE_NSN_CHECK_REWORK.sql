--------------------------------------------------------
--  DDL for Function F_LTE_NSN_CHECK_REWORK
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "HARRIAGUE"."F_LTE_NSN_CHECK_REWORK" 
   ( name_in IN varchar2 )
   RETURN varchar2
IS
   cstatus varchar2(50);

   cursor c1 is
   SELECT REWORK_STATUS
     FROM LTE_NSN_REWORK_STATUS
     WHERE REWORK_NAME = name_in;

BEGIN

   open c1;
   fetch c1 into cstatus;

   if c1%notfound then
      cstatus := 'Rework not found';
   end if;

   close c1;

RETURN cstatus;

EXCEPTION
WHEN OTHERS THEN
   raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
END;

/
