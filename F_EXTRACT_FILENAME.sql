--------------------------------------------------------
--  DDL for Function F_EXTRACT_FILENAME
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "HARRIAGUE"."F_EXTRACT_FILENAME" (p_file_path IN VARCHAR2)
RETURN VARCHAR2
IS
BEGIN
   -- return the string that comes after the last '/'
   RETURN CASE -- if there is no '/'
               WHEN INSTR(p_file_path,'/') = 0 THEN p_file_path
               -- if the string ends in a '/' return null for no file name
               WHEN INSTR(p_file_path,'/',-1) = LENGTH(p_file_path) THEN NULL
               -- otherwise just the string after the last '/'
               ELSE SUBSTR(p_file_path,INSTR(p_file_path,'/',-1)+1)
                 
          END;
END f_extract_filename;

/
