--------------------------------------------------------
--  DDL for Procedure IMPORT_FILE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HARRIAGUE"."IMPORT_FILE" (
   p_site       IN VARCHAR2,
   p_file_name  IN VARCHAR2,
   p_username   IN VARCHAR2,
   p_password   IN VARCHAR2,
   p_local_dir  IN VARCHAR2 ) is
   
   c_port       CONSTANT NUMBER        := 21;
   l_connection NUMBER;
   
   -- a simple routine for outputting a T_TEXT_TAB variable
   -- to DBMS_OUTPUT
   PROCEDURE output_text_tab (p_text_tab IN t_text_tab)
   AS
   BEGIN
      IF (p_text_tab IS NOT NULL) THEN
         FOR i IN 1..p_text_tab.COUNT
         LOOP
            dbms_output.put_line (p_text_tab(i));
         END LOOP;
      ELSE
         dbms_output.put_line ('No data to output');
      END IF;
   END output_text_tab;
   
BEGIN
   -- Create a new FTP connection
   l_connection := com_util_ftp.create_connection (p_site  => p_site
                                             ,p_port      => c_port
                                             ,p_username  => p_username
                                             ,p_password  => p_password);

   -- Open the FTP connection                                             
   com_util_ftp.open_connection (l_connection);
   
   -- Set the transfer to ASCII
   com_util_ftp.ascii (l_connection);
   
   com_util_ftp.mget (p_connection       => l_connection
                ,p_remote_filename  => p_file_name
                ,p_local_dir        => p_local_dir);

   -- Close the connection
   com_util_ftp.close_connection (l_connection);

   -- Uncomment this next line to display the FTP session log
   --output_text_tab (com_util_ftp.get_session_log (l_connection));

EXCEPTION
   WHEN OTHERS THEN

      -- Something bad happened. Dump the FTP session log, the
      -- Oracle error and close the FTP connection
      output_text_tab (com_util_ftp.get_session_log (l_connection));
      IF (com_util_ftp.connection_open (l_connection)) THEN
         com_util_ftp.close_connection (l_connection);
      END IF;
      dbms_output.put_line (dbms_utility.format_error_backtrace);
      RAISE;                                         
 END import_file;

/
