--------------------------------------------------------
--  DDL for Package COM_UTIL_FTP
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "HARRIAGUE"."COM_UTIL_FTP" 
AS

--------------------------------------------------------------------------------
--  Overview      : Package for performing FTP operations within Oracle
--
--                  Transfer operations may be monitored via v$session_longops
--
--  Typical Usage : Use create_connection to create a new FTP connection entry
--                  Assign the necessary properties to the connection using
--                  the set_ routines.
--                  Open the FTP connection with open_connection
--                  Perform the required FTP operations: get, put, rename, etc
--                  Use close_connection to close the FTP connection to the
--                  remote host
--                  Use delete_connection to completely remove the connection
--------------------------------------------------------------------------------
-- Types
SUBTYPE t_errmsg IS VARCHAR2(2000);

--------------------------------------------------------------------------------
-- Exception details raised

c_connection_open_errno     CONSTANT NUMBER(6) := -20800;
c_connection_closed_errno   CONSTANT NUMBER(6) := -20801;
c_invalid_connection_errno  CONSTANT NUMBER(6) := -20802;
c_operation_failed_errno    CONSTANT NUMBER(6) := -20803;
c_connection_failed_errno   CONSTANT NUMBER(6) := -20804;

c_connection_open_errmsg    CONSTANT t_errmsg := 'FTP connection is open';
c_connection_closed_errmsg  CONSTANT t_errmsg := 'FTP connection is closed';
c_invalid_connection_errmsg CONSTANT t_errmsg := 'Invalid FTP connection';
c_operation_failed_errmsg   CONSTANT t_errmsg := 'FTP operation failed';
c_connection_failed_errmsg  CONSTANT t_errmsg := 'FTP connection failed';


--------------------------------------------------------------------------------
--  Function      : create_connection
--
--  Description   : Creates a new connection and returns an identifier 
--                  for the connection
--------------------------------------------------------------------------------
FUNCTION create_connection (p_site             IN  VARCHAR2    DEFAULT NULL
                           ,p_port             IN  PLS_INTEGER DEFAULT NULL
                           ,p_username         IN  VARCHAR2    DEFAULT NULL
                           ,p_password         IN  VARCHAR2    DEFAULT NULL
                           ,p_in_buffer_size   IN  PLS_INTEGER DEFAULT NULL
                           ,p_out_buffer_size  IN  PLS_INTEGER DEFAULT NULL
                           ,p_charset          IN  VARCHAR2    DEFAULT NULL
                           ,p_newline          IN  VARCHAR2    DEFAULT utl_tcp.crlf
                           ,p_tx_timeout       IN  PLS_INTEGER DEFAULT NULL)
RETURN NUMBER;

--------------------------------------------------------------------------------
--  Function      : get_
--
--  Description   : Property "getters"
--
--                  An exception is thrown if the FTP connection doesn't exist
--------------------------------------------------------------------------------
FUNCTION get_site (p_connection IN NUMBER)                 
 RETURN VARCHAR2;
FUNCTION get_port (p_connection IN NUMBER)                  
 RETURN NUMBER;
FUNCTION get_username (p_connection IN NUMBER)              
 RETURN VARCHAR2;
FUNCTION get_password (p_connection IN NUMBER)              
 RETURN VARCHAR2;
FUNCTION get_local_dir (p_connection IN NUMBER)             
 RETURN VARCHAR2;
FUNCTION get_remote_dir (p_connection IN NUMBER)            
 RETURN VARCHAR2;
FUNCTION get_in_buffer_size (p_connection IN NUMBER)           
 RETURN NUMBER;
FUNCTION get_out_buffer_size (p_connection IN NUMBER)           
 RETURN NUMBER;
FUNCTION get_charset (p_connection IN NUMBER)
 RETURN VARCHAR2;
FUNCTION get_newline (p_connection IN NUMBER)
 RETURN VARCHAR2;
FUNCTION get_trans_mode (p_connection IN NUMBER)            
 RETURN VARCHAR2;
FUNCTION get_tx_timeout (p_connection IN NUMBER)            
 RETURN NUMBER;
FUNCTION get_last_response_code (p_connection IN NUMBER)            
 RETURN NUMBER;
FUNCTION get_last_response_msg (p_connection IN NUMBER)            
 RETURN VARCHAR2;

--------------------------------------------------------------------------------
--  Procedure     : set_
--
--  Description   : Property setters
--
--                  The required connection state for the routines are:
--                  - set_site: connection must be closed
--                  - set_port: connection must be closed
--                  - set_username: connection must be closed
--                  - set_password: connection must be closed
--                  - set_local_dir: connection can be open or closed
--                  - set_remote_dir: connection must be open
--                  - set_charset: connection must be closed
--                  - set_newline: connection must be closed
--                  - set_tx_timeout: connection must be closed
--------------------------------------------------------------------------------
PROCEDURE set_site            (p_connection      IN  NUMBER
                              ,p_site            IN  VARCHAR2);
PROCEDURE set_port            (p_connection      IN  NUMBER
                              ,p_port            IN  NUMBER);
PROCEDURE set_username        (p_connection      IN  NUMBER
                              ,p_username        IN  VARCHAR2);
PROCEDURE set_password        (p_connection      IN  NUMBER
                              ,p_password        IN  VARCHAR2);
PROCEDURE set_local_dir       (p_connection      IN  NUMBER
                              ,p_local_dir       IN  VARCHAR2);
PROCEDURE set_remote_dir      (p_connection      IN  NUMBER
                              ,p_remote_dir      IN  VARCHAR2);
PROCEDURE set_charset         (p_connection      IN  NUMBER
                              ,p_charset         IN  VARCHAR2);
PROCEDURE set_newline         (p_connection      IN  NUMBER
                              ,p_newline         IN  VARCHAR2);
PROCEDURE set_tx_timeout      (p_connection      IN  NUMBER
                              ,p_tx_timeout      IN  NUMBER);

--------------------------------------------------------------------------------
--  Procedure     : set_in_buffer_size
--
--  Description   : Sets the input TCP buffer size, in bytes. Values from 0 to
--                  32k are permitted, as well as NULL. This cannot be set once
--                  the connection is opened
--------------------------------------------------------------------------------
PROCEDURE set_in_buffer_size  (p_connection      IN  NUMBER
                              ,p_in_buffer_size  IN  NUMBER);

--------------------------------------------------------------------------------
--  Procedure     : set_out_buffer_size
--
--  Description   : Sets the output TCP buffer size, in bytes. Values from 0 to
--                  32k are permitted, as well as NULL. This cannot be set once
--                  the connection is opened
--------------------------------------------------------------------------------
PROCEDURE set_out_buffer_size (p_connection      IN  NUMBER
                              ,p_out_buffer_size IN  NUMBER);


--------------------------------------------------------------------------------
--  Function      : get_default_trans_mode
--
--  Description   : Returns the default transfer mode that will be used for
--                  FTP operations. This can be overridden with the BINARY
--                  and ASCII procedures
--------------------------------------------------------------------------------
FUNCTION get_default_trans_mode
RETURN VARCHAR2;

--------------------------------------------------------------------------------
--  Procedure     : set_default_trans_mode_ascii
--
--  Description   : Sets the default transfer mode to ascii. This setting will
--                  apply to all new connections and will not affect existing
--                  connection, whether they are open or not.
--------------------------------------------------------------------------------
PROCEDURE set_default_trans_mode_ascii;

--------------------------------------------------------------------------------
--  Procedure     : set_default_trans_mode_ascii
--
--  Description   : Sets the default transfer mode to binary. This setting will
--                  apply to all new connections and will not affect existing
--                  connection, whether they are open or not.
--------------------------------------------------------------------------------
PROCEDURE set_default_trans_mode_binary;

--------------------------------------------------------------------------------
--  Function      : get_session_log
--
--  Description   : Returns the log of the current session
--------------------------------------------------------------------------------
FUNCTION get_session_log (p_connection IN NUMBER)
RETURN t_text_tab;


--------------------------------------------------------------------------------
--  Procedure     : binary
--
--  Description   : Sets the transfer mode to binary
--------------------------------------------------------------------------------
PROCEDURE binary (p_connection IN NUMBER);

--------------------------------------------------------------------------------
--  Procedure     : ascii
--
--  Description   : Sets the transfer mode to ascii (text)
--------------------------------------------------------------------------------
PROCEDURE ascii (p_connection IN NUMBER);

--------------------------------------------------------------------------------
--  Function      : connection_exists
--
--  Description   : Returns TRUE if the connection identifier exists. NOTE:
--                  the connection may not actually be open though
--------------------------------------------------------------------------------
FUNCTION connection_exists (p_connection       IN NUMBER)
RETURN BOOLEAN;

--------------------------------------------------------------------------------
--  Function      : connection_open
--
--  Description   : Returns TRUE if the connection identifier exists and is
--                  open to the remote site
--------------------------------------------------------------------------------
FUNCTION connection_open (p_connection       IN NUMBER)
RETURN BOOLEAN;

--------------------------------------------------------------------------------
--  Procedure     : open_connection
--
--  Description   : Opens the connection specified
--------------------------------------------------------------------------------
PROCEDURE open_connection (p_connection       IN NUMBER);

--------------------------------------------------------------------------------
--  Procedure     : close_connection
--
--  Description   : Closes a previously opened connection. Does nothing if the 
--                  connection is already closed
--------------------------------------------------------------------------------
PROCEDURE close_connection (p_connection       IN NUMBER);

--------------------------------------------------------------------------------
--  Procedure     : close_all_connections
--
--  Description   : Closes all previously opened connections.
--------------------------------------------------------------------------------
PROCEDURE close_all_connections;

--------------------------------------------------------------------------------
--  Procedure     : delete_connection
--
--  Description   : Completely removes a connection. If the connection is open
--                  then it is closed first.
--------------------------------------------------------------------------------
PROCEDURE delete_connection (p_connection       IN NUMBER);

--------------------------------------------------------------------------------
--  Procedure     : delete_all_connections
--
--  Description   : Completely removes all declared connections.
--------------------------------------------------------------------------------
PROCEDURE delete_all_connections;

--------------------------------------------------------------------------------
--  Function      : get_remote_dir_list
--
--  Description   : Returns a directory listing of the remote server. The details
--                  of the listing will be server specific but may be able to be
--                  parsed.
--------------------------------------------------------------------------------
FUNCTION get_remote_dir_list (p_connection       IN NUMBER
                             ,p_remote_dir       IN VARCHAR2 DEFAULT NULL)
RETURN t_text_tab;

--------------------------------------------------------------------------------
--  Function      : get_remote_file_list
--
--  Description   : Returns a file listing of the remote server. This will only
--                  be the names of the files.
--------------------------------------------------------------------------------
FUNCTION get_remote_file_list (p_connection       IN NUMBER
                              ,p_remote_dir       IN VARCHAR2 DEFAULT NULL)
RETURN t_text_tab;

--------------------------------------------------------------------------------
--  Function      : get_file_list
--
--  Description   : Returns a file listing of the remote server. This will only
--                  be the names of the files. The remote directory is
--                  optional. If not specified then the root directory is
--                  returned.
--                  
--                  Example of use:
--
--  SELECT f.column_value
--  FROM   TABLE(pkg_ftp.get_file_list(:l_connection,'/public/data/*.txt')) f
--
--------------------------------------------------------------------------------
FUNCTION get_file_list (p_connection       IN  NUMBER
                       ,p_remote_dir       IN  VARCHAR2 DEFAULT NULL)
RETURN t_text_tab
PIPELINED;

--------------------------------------------------------------------------------
--  Function      : get_file_list
--
--  Description   : Returns a file listing of the remote server. This will only
--                  be the names of the files. The remote directory is
--                  optional. If not specified then the root directory is
--                  returned
--                  
--                  Example of use:
--
--  SELECT f.column_value
--  FROM   TABLE(pkg_ftp.get_file_list(:l_connection,'/public/data/*.txt')) f
--
--------------------------------------------------------------------------------
FUNCTION get_file_list (p_site             IN  VARCHAR2    
                       ,p_port             IN  PLS_INTEGER 
                       ,p_username         IN  VARCHAR2    
                       ,p_password         IN  VARCHAR2    
                       ,p_remote_dir       IN  VARCHAR2 DEFAULT NULL)
RETURN t_text_tab
PIPELINED;

--------------------------------------------------------------------------------
--  Procedure     : get
--
--  Description   : Retrieves the remote file and writes it to the directory
--                  and filename specified
--------------------------------------------------------------------------------
PROCEDURE get    (p_connection       IN NUMBER
                 ,p_remote_filename  IN VARCHAR2
                 ,p_local_dir        IN VARCHAR2 DEFAULT NULL
                 ,p_local_filename   IN VARCHAR2 DEFAULT NULL);

--------------------------------------------------------------------------------
--  Procedure     : get
--
--  Description   : Retrieves the remote file and returns it as a t_text_tab
--
--                  This routine will only return data if the transfer mode is
--                  set to ASCII.
--
--                  Example of use:
--                    
--  SELECT f.column_value
--  FROM   TABLE(pkg_ftp.get(:l_connection,'/public/data/test.txt')) f
--
--------------------------------------------------------------------------------
FUNCTION  get    (p_connection       IN NUMBER
                 ,p_remote_filename  IN VARCHAR2)
RETURN t_text_tab
PIPELINED;

--------------------------------------------------------------------------------
--  Procedure     : get
--
--  Description   : Retrieves the remote file and returns it as a t_text_tab
--
--                  This routine will only return data if the transfer mode is
--                  set to ASCII.
--                  
--                  This version of GET creates the FTP connection, retrieves
--                  the file and then closes and removes the connection once
--                  finished.
--
--                  Example of use:
--
--  SELECT f.*
--  FROM   TABLE(pkg_ftp.get ('localhost', 21, 'anonymous','anonymous','text_file.txt')) f
--
--                  or combined with the get_file_list function:
--
--  SELECT t.file_name
--  ,      f.*
--  FROM   (SELECT d.column_value AS file_name
--          FROM   TABLE(pkg_ftp.get_file_list ('localhost', 21, 'anonymous','anonymous','/public')) d
--          WHERE  d.column_value LIKE '/public/%.txt') t
--  ,      TABLE(pkg_ftp.get ('localhost', 21, 'anonymous','anonymous',t.file_name)) f
--
--------------------------------------------------------------------------------
FUNCTION  get    (p_site             IN  VARCHAR2    
                 ,p_port             IN  PLS_INTEGER 
                 ,p_username         IN  VARCHAR2    
                 ,p_password         IN  VARCHAR2    
                 ,p_remote_filename  IN  VARCHAR2)
RETURN t_text_tab
PIPELINED;

--------------------------------------------------------------------------------
--  Procedure     : mget
--
--  Description   : Retrieves multiple remote files and writes them to the
--                  directory specified. The ability to rename the files in the
--                  copy process is not provided.
--------------------------------------------------------------------------------
PROCEDURE mget   (p_connection       IN NUMBER
                 ,p_remote_filename  IN VARCHAR2
                 ,p_local_dir        IN VARCHAR2 DEFAULT NULL);

--------------------------------------------------------------------------------
--  Function      : get_clob
--
--  Description   : Retrieves the remote file and returns it as a CLOB
--------------------------------------------------------------------------------
FUNCTION get_clob    (p_connection       IN NUMBER
                     ,p_remote_filename  IN VARCHAR2)
RETURN CLOB;

--------------------------------------------------------------------------------
--  Function      : get_blob
--
--  Description   : Retrieves the remote file and returns it as a BLOB
--------------------------------------------------------------------------------
FUNCTION get_blob  (p_connection       IN NUMBER
                   ,p_remote_filename  IN VARCHAR2)
RETURN BLOB;

--------------------------------------------------------------------------------
--  Procedure     : put
--
--  Description   : Sends a file to the remote site
--------------------------------------------------------------------------------
PROCEDURE put    (p_connection       IN NUMBER
                 ,p_local_filename   IN VARCHAR2
                 ,p_local_dir        IN VARCHAR2 DEFAULT NULL
                 ,p_remote_filename  IN VARCHAR2 DEFAULT NULL);

--------------------------------------------------------------------------------
--  Procedure     : put
--
--  Description   : Create a file on the remote site from the content of
--                  a CLOB
--------------------------------------------------------------------------------
PROCEDURE put    (p_connection       IN NUMBER
                 ,p_clob             IN CLOB
                 ,p_remote_filename  IN VARCHAR2);

--------------------------------------------------------------------------------
--  Procedure     : put
--
--  Description   : Create a file on the remote site from the content of
--                  a BLOB
--------------------------------------------------------------------------------
PROCEDURE put    (p_connection       IN NUMBER
                 ,p_blob             IN BLOB
                 ,p_remote_filename  IN VARCHAR2);

--------------------------------------------------------------------------------
--  Procedure     : put
--
--  Description   : Create a file on the remote site from the content of
--                  a REF CURSOR.
--
--                  The 11g version of this routine uses pkg_csv to output the
--                  cursor content in CSV format. Options for configuring the
--                  output can be made by calling the pkg_csv routines prior
--                  to calling this one
--------------------------------------------------------------------------------
/**PROCEDURE put    (p_connection       IN     NUMBER
                 ,p_cursor           IN OUT SYS_REFCURSOR
                 ,p_remote_filename  IN     VARCHAR2
                 ,p_column_headers   IN     BOOLEAN DEFAULT TRUE);**/

--------------------------------------------------------------------------------
--  Procedure     : put
--
--  Description   : Create a file on the remote site from the content of
--                  a REF CURSOR.
--
--                  The 11g version of this routine uses pkg_csv to output the
--                  cursor content in CSV format. Options for configuring the
--                  output can be made by calling the pkg_csv routines prior
--                  to calling this one
--------------------------------------------------------------------------------
/**PROCEDURE put    (p_site             IN     VARCHAR2    
                 ,p_port             IN     PLS_INTEGER 
                 ,p_username         IN     VARCHAR2    
                 ,p_password         IN     VARCHAR2    
                 ,p_cursor           IN OUT SYS_REFCURSOR
                 ,p_remote_filename  IN     VARCHAR2
                 ,p_column_headers   IN     BOOLEAN DEFAULT TRUE);**/

--------------------------------------------------------------------------------
--  Procedure     : delete
--
--  Description   : Deletes the specified remote file
--------------------------------------------------------------------------------
PROCEDURE delete    (p_connection       IN NUMBER
                    ,p_remote_filename  IN VARCHAR2);

--------------------------------------------------------------------------------
--  Procedure     : rename
--
--  Description   : Renames the specified remote file to a new name
--------------------------------------------------------------------------------
PROCEDURE rename    (p_connection           IN NUMBER
                    ,p_old_remote_filename  IN VARCHAR2
                    ,p_new_remote_filename  IN VARCHAR2);

--------------------------------------------------------------------------------
--  Function      : get_size
--
--  Description   : Returns the size of the remote file
--------------------------------------------------------------------------------
FUNCTION  get_size  (p_connection       IN NUMBER
                    ,p_remote_filename  IN VARCHAR2)
RETURN NUMBER;

--------------------------------------------------------------------------------
--  Function      : get_mod_time
--
--  Description   : Returns the last modification time of the remote file
--------------------------------------------------------------------------------
FUNCTION  get_mod_time  (p_connection       IN NUMBER
                        ,p_remote_filename  IN VARCHAR2)
RETURN TIMESTAMP WITH TIME ZONE;

--------------------------------------------------------------------------------
--  Procedure     : mkdir
--
--  Description   : Creates the specified remote directory
--------------------------------------------------------------------------------
PROCEDURE mkdir     (p_connection       IN NUMBER
                    ,p_remote_dir       IN VARCHAR2);

--------------------------------------------------------------------------------
--  Procedure     : rmdir
--
--  Description   : Removes the specified remote directory
--------------------------------------------------------------------------------
PROCEDURE rmdir     (p_connection       IN NUMBER
                    ,p_remote_dir       IN VARCHAR2);

--------------------------------------------------------------------------------
--  Function      : is_valid_measurement
--
--  Description   : Returns TRUE if measurement is valid and FALSE if not valid 
--------------------------------------------------------------------------------
FUNCTION is_valid_measurement(v_type_measurement IN VARCHAR2) 

RETURN BOOLEAN;

END com_util_ftp;

/
