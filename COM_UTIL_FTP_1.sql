--------------------------------------------------------
--  DDL for Package Body COM_UTIL_FTP
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "HARRIAGUE"."COM_UTIL_FTP" 
AS

--------------------------------------------------------------------------------
-- Exceptions
ex_connection_open    EXCEPTION;
ex_connection_closed  EXCEPTION;
ex_invalid_connection EXCEPTION;
ex_operation_failed   EXCEPTION;


--------------------------------------------------------------------------------
-- Types

-- Some general types
SUBTYPE t_big_string        IS VARCHAR2(32676);
SUBTYPE t_raw_buffer        IS RAW(32676);
SUBTYPE t_text_buffer       IS VARCHAR2(32676);

-- A set of types that builds up a structure for storing the
-- remote FTP response
SUBTYPE t_ftp_response_code IS NUMBER(3);
SUBTYPE t_response_line     IS VARCHAR2(32676);
TYPE t_response_lines_tab   IS TABLE OF t_response_line;
TYPE t_ftp_response         IS RECORD
                               (response_code      t_ftp_response_code
                               ,response_lines_tab t_response_lines_tab
                               );

-- A record type to store all the details needed for an FTP session
-- many of these are simply taken from the TCP connection in package utl_tcp
TYPE t_ftp_conn_rec IS RECORD
                         (cmd_conn              utl_tcp.connection  -- connection to perform command on
                         ,trans_conn            utl_tcp.connection  -- connection for file transfer
                         ,site                  VARCHAR2(500)       -- the site to connect to
                         ,port                  NUMBER              -- the port to connect to
                         ,username              VARCHAR2(100)       -- the username to use
                         ,password              VARCHAR2(100)       -- the password to use
                         ,in_buffer_size        NUMBER              -- the TCP input buffer size (in bytes)
                         ,out_buffer_size       NUMBER              -- the TCP output buffer size (in bytes)
                         ,charset               NUMBER              -- the character set used for text transfers
                         ,newline               VARCHAR2(10)        -- the newline character sequence for TCP writeline
                         ,local_dir             VARCHAR2(1000)      -- the local directory (directory object)
                         ,remote_dir            VARCHAR2(1000)      -- the remote directory
                         ,trans_mode            VARCHAR2(6)         -- transfer mode: ascii or binary
                         ,tx_timeout            NUMBER(5)           -- transfer timeout, in seconds
                         ,last_response_code    t_ftp_response_code -- the last FTP response code
                         ,session_log           t_text_tab          -- session log
                         );

-- A collection of FTP connection records 
TYPE t_ftp_conn_tab IS TABLE OF t_ftp_conn_rec INDEX BY BINARY_INTEGER;

-- define a global collection to store ftp response message
TYPE t_ftp_response_msg_rec IS RECORD
                              (msg          VARCHAR2(500)
                              ,err_response BOOLEAN);
TYPE t_ftp_response_msg_tab IS TABLE OF t_ftp_response_msg_rec INDEX BY BINARY_INTEGER;


--------------------------------------------------------------------------------
-- Global Constants

-- ftp response code constants
c_ftp_file_status    CONSTANT t_ftp_response_code := 213;
c_ftp_user_required  CONSTANT t_ftp_response_code := 220;
c_ftp_pwd_required   CONSTANT t_ftp_response_code := 331;

-- the minumim and maximum size for TCP buffer
c_min_tcp_buffer     CONSTANT NUMBER := 0;
c_max_tcp_buffer     CONSTANT NUMBER := 32767;

-- text handling limits
c_max_file_line_len  CONSTANT NUMBER := 32767;
c_max_varchar2_len   CONSTANT NUMBER := 4000;

-- default transfer buffer size
c_ftp_buffer_size    CONSTANT NUMBER := 8192;

-- format for get_mod_time routine
c_mod_time_format    CONSTANT VARCHAR2(30) := 'yyyymmddhh24miss tzh:tzm';

-- ascii / binary transfer mode constants
c_trans_mode_ascii   CONSTANT VARCHAR2(6) := 'ASCII';
c_trans_mode_binary  CONSTANT VARCHAR2(6) := 'BINARY';


--------------------------------------------------------------------------------
-- Global Variables

-- a global collection of connections and all associated details
-- all access to the package routine is via the connection number,
-- which is the offset into this collection
-- this lets us have multiple FTP connections
g_ftp_conn_tab t_ftp_conn_tab;

-- the global collection of ftp response messages, indexed by the
-- response code. this collection is initialised by the routine 
-- initialise, which is run on package initialisation
g_ftp_response_msg_tab t_ftp_response_msg_tab;

-- the default tc timeout, used if the tx timeout isn't specified
c_default_tx_timeout CONSTANT NUMBER := 1;

-- the default transfer mode for FTP operations
g_default_trans_mode VARCHAR2(6) := c_trans_mode_binary;

-- type measurement
g_type_measurement VARCHAR2(100) := '';
g_not_valid_measurement BOOLEAN := FALSE;

--------------------------------------------------------------------------------
-- Forward References
PROCEDURE send_ascii  (p_connection  IN NUMBER);
PROCEDURE send_binary (p_connection  IN NUMBER);
PROCEDURE send_cwd    (p_connection  IN NUMBER
                      ,p_remote_dir  IN VARCHAR2);

--------------------------------------------------------------------------------
--  Function      : get_ftp_response_msg_rec
--
--  Description   : Returns ftp response msg record
--------------------------------------------------------------------------------
FUNCTION get_ftp_response_msg_rec (p_msg          VARCHAR2
                                  ,p_err_response BOOLEAN)
RETURN t_ftp_response_msg_rec
AS
   l_ftp_response_msg_rec t_ftp_response_msg_rec;
BEGIN
   l_ftp_response_msg_rec.msg          := p_msg;
   l_ftp_response_msg_rec.err_response := p_err_response;
   RETURN l_ftp_response_msg_rec;
END get_ftp_response_msg_rec;
--------------------------------------------------------------------------------
--  Procedure     : init_ftp_response_msg_tab
--
--  Description   : Initialises the global ftp response message collection
--
--                  The response descriptions were taken from Wikipedia:
--                  http://en.wikipedia.org/wiki/List_of_FTP_server_return_codes
--------------------------------------------------------------------------------
PROCEDURE init_ftp_response_msg_tab
AS
BEGIN
   g_ftp_response_msg_tab(100) := get_ftp_response_msg_rec('Series: The requested action is being initiated, expect another reply before proceeding with a new command.', FALSE);
   g_ftp_response_msg_tab(110) := get_ftp_response_msg_rec('Restart marker replay . In this case, the text is exact and not left to the particular implementation; it must read: MARK yyyy = mmmm where yyyy is User-process data stream marker, and mmmm server''s equivalent marker (note the spaces between markers and "=").', FALSE);
   g_ftp_response_msg_tab(120) := get_ftp_response_msg_rec('Service ready in nnn minutes.', FALSE);
   g_ftp_response_msg_tab(125) := get_ftp_response_msg_rec('Data connection already open; transfer starting', FALSE);
   g_ftp_response_msg_tab(150) := get_ftp_response_msg_rec('File status okay; about to open data connection.', FALSE);
   g_ftp_response_msg_tab(200) := get_ftp_response_msg_rec('Command okay.', FALSE);
   g_ftp_response_msg_tab(202) := get_ftp_response_msg_rec('Command not implemented, superfluous at this site.', FALSE);
   g_ftp_response_msg_tab(211) := get_ftp_response_msg_rec('System status, or system help reply.', FALSE);
   g_ftp_response_msg_tab(212) := get_ftp_response_msg_rec('Directory status.', FALSE);
   g_ftp_response_msg_tab(213) := get_ftp_response_msg_rec('File status.', FALSE);
   g_ftp_response_msg_tab(214) := get_ftp_response_msg_rec('Help message.On how to use the server or the meaning of a particular non-standard command. This reply is useful only to the human user.', FALSE);
   g_ftp_response_msg_tab(215) := get_ftp_response_msg_rec('NAME system type. Where NAME is an official system name from the registry (http://www.iana.org/assignments/operating-system-names) kept by IANA.', FALSE);
   g_ftp_response_msg_tab(220) := get_ftp_response_msg_rec('Service ready for new user.', FALSE);
   g_ftp_response_msg_tab(221) := get_ftp_response_msg_rec('Service closing control connection.', FALSE);
   g_ftp_response_msg_tab(225) := get_ftp_response_msg_rec('Data connection open; no transfer in progress.', FALSE);
   g_ftp_response_msg_tab(226) := get_ftp_response_msg_rec('Closing data connection. Requested file action successful (for example, file transfer or file abort).', FALSE);
   g_ftp_response_msg_tab(227) := get_ftp_response_msg_rec('Entering Passive Mode (h1,h2,h3,h4,p1,p2).', FALSE);
   g_ftp_response_msg_tab(228) := get_ftp_response_msg_rec('Entering Long Passive Mode (long address, port).', FALSE);
   g_ftp_response_msg_tab(229) := get_ftp_response_msg_rec('Entering Extended Passive Mode (|||port|).', FALSE);
   g_ftp_response_msg_tab(230) := get_ftp_response_msg_rec('User logged in, proceed. Logged out if appropriate.', FALSE);
   g_ftp_response_msg_tab(231) := get_ftp_response_msg_rec('User logged out; service terminated.', FALSE);
   g_ftp_response_msg_tab(232) := get_ftp_response_msg_rec('Logout command noted, will complete when transfer done.', FALSE);
   g_ftp_response_msg_tab(250) := get_ftp_response_msg_rec('Requested file action okay, completed.', FALSE);
   g_ftp_response_msg_tab(257) := get_ftp_response_msg_rec('"PATHNAME" created.', FALSE);
   g_ftp_response_msg_tab(331) := get_ftp_response_msg_rec('User name okay, need password', FALSE);
   g_ftp_response_msg_tab(332) := get_ftp_response_msg_rec('Need account for login.', FALSE);
   g_ftp_response_msg_tab(350) := get_ftp_response_msg_rec('Requested file action pending further information', FALSE);
   g_ftp_response_msg_tab(421) := get_ftp_response_msg_rec('Service not available, closing control connection. This may be a reply to any command if the service knows it must shut down.', TRUE);
   g_ftp_response_msg_tab(425) := get_ftp_response_msg_rec('Can''t open data connection.', TRUE);
   g_ftp_response_msg_tab(426) := get_ftp_response_msg_rec('Connection closed; transfer aborted.', TRUE);
   g_ftp_response_msg_tab(430) := get_ftp_response_msg_rec('Invalid username or password', TRUE);
   g_ftp_response_msg_tab(434) := get_ftp_response_msg_rec('Requested host unavailable.', TRUE);
   g_ftp_response_msg_tab(450) := get_ftp_response_msg_rec('Requested file action not taken.', TRUE);
   g_ftp_response_msg_tab(451) := get_ftp_response_msg_rec('Requested action aborted. Local error in processing.', TRUE);
   g_ftp_response_msg_tab(452) := get_ftp_response_msg_rec('Requested action not taken. Insufficient storage space in system.File unavailable (e.g., file busy).', TRUE);
   g_ftp_response_msg_tab(500) := get_ftp_response_msg_rec('Syntax error, command unrecognized. This may include errors such as command line too long.', TRUE);
   g_ftp_response_msg_tab(501) := get_ftp_response_msg_rec('Syntax error in parameters or arguments.', TRUE);
   g_ftp_response_msg_tab(502) := get_ftp_response_msg_rec('Command not implemented.', TRUE);
   g_ftp_response_msg_tab(503) := get_ftp_response_msg_rec('Bad sequence of commands.', TRUE);
   g_ftp_response_msg_tab(504) := get_ftp_response_msg_rec('Command not implemented for that parameter.', TRUE);
   g_ftp_response_msg_tab(530) := get_ftp_response_msg_rec('Not logged in.', TRUE);
   g_ftp_response_msg_tab(532) := get_ftp_response_msg_rec('Need account for storing files.', TRUE);
   g_ftp_response_msg_tab(550) := get_ftp_response_msg_rec('Requested action not taken. File unavailable (e.g., file not found, no access).', TRUE);
   g_ftp_response_msg_tab(551) := get_ftp_response_msg_rec('Requested action aborted. Page type unknown.', TRUE);
   g_ftp_response_msg_tab(552) := get_ftp_response_msg_rec('Requested file action aborted. Exceeded storage allocation (for current directory or dataset).', TRUE);
   g_ftp_response_msg_tab(553) := get_ftp_response_msg_rec('Requested action not taken. File name not allowed.', TRUE);
   g_ftp_response_msg_tab(631) := get_ftp_response_msg_rec('Integrity protected reply.', TRUE);
   g_ftp_response_msg_tab(632) := get_ftp_response_msg_rec('Confidentiality and integrity protected reply.', TRUE);
   g_ftp_response_msg_tab(633) := get_ftp_response_msg_rec('Confidentiality protected reply.', TRUE);
END init_ftp_response_msg_tab;

--------------------------------------------------------------------------------
--  Procedure     : initialise
--
--  Description   : Initialises the package
--------------------------------------------------------------------------------
PROCEDURE initialise
AS
BEGIN
   -- initialise the ftp response message collection
   init_ftp_response_msg_tab;
END initialise;

--------------------------------------------------------------------------------
--  Function      : get_empty_connection
--
--  Description   : Returns an empty but initialised connection record
--------------------------------------------------------------------------------
FUNCTION get_empty_connection
RETURN t_ftp_conn_rec
AS
   l_empty_connection t_ftp_conn_rec;
BEGIN
   l_empty_connection.session_log := t_text_tab();
   -- the default trans mode is set here since it does not have
   -- a regular "set" routine and is required to be set before
   -- we can perform any transfers
   l_empty_connection.trans_mode  := g_default_trans_mode;
   RETURN l_empty_connection;
END get_empty_connection;

--------------------------------------------------------------------------------
--  Procedure     : add_log
--
--  Description   : Adds an entry to the session log
--------------------------------------------------------------------------------
PROCEDURE add_log (p_connection   IN NUMBER
                  ,p_text         IN VARCHAR2)
AS
   l_entry_no PLS_INTEGER;
BEGIN
   g_ftp_conn_tab(p_connection).session_log.EXTEND;
   l_entry_no := g_ftp_conn_tab(p_connection).session_log.LAST;
   g_ftp_conn_tab(p_connection).session_log(l_entry_no) := p_text;
END add_log;


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
RETURN NUMBER
AS
   l_connection  NUMBER;
BEGIN
   -- add a connection to the end of the global connection table and 
   -- return the index number
   l_connection := NVL(g_ftp_conn_tab.LAST + 1,1);
   g_ftp_conn_tab(l_connection) := get_empty_connection;
   add_log (p_connection   => l_connection
           ,p_text         => 'create connection: ' || TO_CHAR(l_connection));
   
   set_site            (l_connection, p_site);
   set_port            (l_connection, p_port);
   set_username        (l_connection, p_username);
   set_password        (l_connection, p_password);
   set_in_buffer_size  (l_connection, p_in_buffer_size);
   set_out_buffer_size (l_connection, p_out_buffer_size);
   set_charset         (l_connection, p_charset);
   set_newline         (l_connection, p_newline);
   set_tx_timeout      (l_connection, p_tx_timeout);
   
   RETURN l_connection;

END create_connection;

--------------------------------------------------------------------------------
--  Function      : get_
--
--  Description   : Property "getters". 
--
--                  An exception is thrown if the FTP connection doesn't exist
--------------------------------------------------------------------------------
FUNCTION get_site (p_connection IN NUMBER)                  
 RETURN VARCHAR2
AS
BEGIN
   IF (NOT connection_exists (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_invalid_connection_errno, c_invalid_connection_errmsg);
   END IF;
   RETURN g_ftp_conn_tab(p_connection).site;
END get_site;

FUNCTION get_port  (p_connection IN NUMBER)                 
 RETURN NUMBER
AS
BEGIN
   IF (NOT connection_exists (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_invalid_connection_errno, c_invalid_connection_errmsg);
   END IF;
   RETURN g_ftp_conn_tab(p_connection).port;
END get_port;

FUNCTION get_username (p_connection IN NUMBER)             
 RETURN VARCHAR2
AS
BEGIN
   IF (NOT connection_exists (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_invalid_connection_errno, c_invalid_connection_errmsg);
   END IF;
   RETURN g_ftp_conn_tab(p_connection).username;
END get_username;

FUNCTION get_password (p_connection IN NUMBER)              
 RETURN VARCHAR2
AS
BEGIN
   IF (NOT connection_exists (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_invalid_connection_errno, c_invalid_connection_errmsg);
   END IF;
   RETURN g_ftp_conn_tab(p_connection).password;
END get_password;

FUNCTION get_local_dir (p_connection IN NUMBER)             
 RETURN VARCHAR2
AS
BEGIN
   IF (NOT connection_exists (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_invalid_connection_errno, c_invalid_connection_errmsg);
   END IF;
   RETURN g_ftp_conn_tab(p_connection).local_dir;
END get_local_dir;

FUNCTION get_remote_dir (p_connection IN NUMBER)            
 RETURN VARCHAR2
AS
BEGIN
   IF (NOT connection_exists (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_invalid_connection_errno, c_invalid_connection_errmsg);
   END IF;
   RETURN g_ftp_conn_tab(p_connection).remote_dir;
END get_remote_dir;

FUNCTION get_in_buffer_size (p_connection IN NUMBER)            
 RETURN NUMBER
AS
BEGIN
   IF (NOT connection_exists (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_invalid_connection_errno, c_invalid_connection_errmsg);
   END IF;
   RETURN g_ftp_conn_tab(p_connection).in_buffer_size;
END get_in_buffer_size;

FUNCTION get_out_buffer_size (p_connection IN NUMBER)            
 RETURN NUMBER
AS
BEGIN
   IF (NOT connection_exists (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_invalid_connection_errno, c_invalid_connection_errmsg);
   END IF;
   RETURN g_ftp_conn_tab(p_connection).out_buffer_size;
END get_out_buffer_size;

FUNCTION get_charset (p_connection IN NUMBER)            
 RETURN VARCHAR2
AS
BEGIN
   IF (NOT connection_exists (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_invalid_connection_errno, c_invalid_connection_errmsg);
   END IF;
   RETURN g_ftp_conn_tab(p_connection).charset;
END get_charset;

FUNCTION get_newline (p_connection IN NUMBER)            
 RETURN VARCHAR2
AS
BEGIN
   IF (NOT connection_exists (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_invalid_connection_errno, c_invalid_connection_errmsg);
   END IF;
   RETURN g_ftp_conn_tab(p_connection).newline;
END get_newline;

FUNCTION get_trans_mode (p_connection IN NUMBER)            
 RETURN VARCHAR2
AS
BEGIN
   IF (NOT connection_exists (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_invalid_connection_errno, c_invalid_connection_errmsg);
   END IF;
   RETURN g_ftp_conn_tab(p_connection).trans_mode;
END get_trans_mode;

FUNCTION get_tx_timeout (p_connection IN NUMBER)            
 RETURN NUMBER
AS
BEGIN
   IF (NOT connection_exists (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_invalid_connection_errno, c_invalid_connection_errmsg);
   END IF;
   RETURN g_ftp_conn_tab(p_connection).tx_timeout;
END get_tx_timeout;

FUNCTION get_last_response_code (p_connection IN NUMBER)            
 RETURN NUMBER
AS
BEGIN
   IF (NOT connection_exists (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_invalid_connection_errno, c_invalid_connection_errmsg);
   END IF;
   RETURN g_ftp_conn_tab(p_connection).last_response_code;
END get_last_response_code;

FUNCTION get_last_response_msg (p_connection IN NUMBER)            
 RETURN VARCHAR2
AS
BEGIN
   IF (NOT connection_exists (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_invalid_connection_errno, c_invalid_connection_errmsg);
   END IF;
   -- get the response message from the last response code but
   -- make sure to handle the scenario where there is no last response code
   RETURN CASE 
             WHEN g_ftp_conn_tab(p_connection).last_response_code IS NOT NULL
             THEN g_ftp_response_msg_tab(g_ftp_conn_tab(p_connection).last_response_code).msg
             ELSE NULL
          END;
END get_last_response_msg;

--------------------------------------------------------------------------------
--  Procedure     : set_site
--
--  Description   : Sets the remote FTP site. The connection must be closed to
--                  set this property
--------------------------------------------------------------------------------
PROCEDURE set_site          (p_connection  IN  NUMBER
                            ,p_site        IN  VARCHAR2)
AS
BEGIN
   IF (NOT connection_exists (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_invalid_connection_errno, c_invalid_connection_errmsg);
   ELSIF (connection_open (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_connection_open_errno, c_connection_open_errmsg);
   END IF;

   add_log (p_connection   => p_connection
           ,p_text         => 'Set site: ' || p_site);
   g_ftp_conn_tab(p_connection).site := p_site;

END set_site;

--------------------------------------------------------------------------------
--  Procedure     : set_port
--
--  Description   : Sets the remote FTP port. The connection must be closed to
--                  set this property
--------------------------------------------------------------------------------
PROCEDURE set_port          (p_connection  IN  NUMBER
                            ,p_port        IN  NUMBER)
AS
BEGIN
   IF (NOT connection_exists (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_invalid_connection_errno, c_invalid_connection_errmsg);
   ELSIF (connection_open (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_connection_open_errno, c_connection_open_errmsg);
   END IF;
   
   add_log (p_connection   => p_connection
           ,p_text         => 'Set port: ' || TO_CHAR(p_port));
   g_ftp_conn_tab(p_connection).port := p_port;

END set_port;

--------------------------------------------------------------------------------
--  Procedure     : set_username
--
--  Description   : Sets the FTP username. The connection must be closed to
--                  set this property
--------------------------------------------------------------------------------
PROCEDURE set_username      (p_connection  IN  NUMBER
                            ,p_username    IN  VARCHAR2)
AS
BEGIN
   IF (NOT connection_exists (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_invalid_connection_errno, c_invalid_connection_errmsg);
   ELSIF (connection_open (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_connection_open_errno, c_connection_open_errmsg);
   END IF;

   add_log (p_connection   => p_connection
           ,p_text         => 'Set username: ' || p_username);
   g_ftp_conn_tab(p_connection).username :=p_username;

END set_username;

--------------------------------------------------------------------------------
--  Procedure     : set_password
--
--  Description   : Sets the FTP password. The connection must be closed to
--                  set this property
--------------------------------------------------------------------------------
PROCEDURE set_password      (p_connection  IN  NUMBER
                            ,p_password    IN  VARCHAR2)
AS
BEGIN
   IF (NOT connection_exists (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_invalid_connection_errno, c_invalid_connection_errmsg);
   ELSIF (connection_open (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_connection_open_errno, c_connection_open_errmsg);
   END IF;

   add_log (p_connection   => p_connection
           ,p_text         => 'Set password: ' || p_password);
   g_ftp_conn_tab(p_connection).password := p_password;

END set_password;

--------------------------------------------------------------------------------
--  Procedure     : set_local_dir
--
--  Description   : Sets the local directory for FTP transfers
--------------------------------------------------------------------------------
PROCEDURE set_local_dir     (p_connection  IN  NUMBER
                            ,p_local_dir   IN  VARCHAR2)
AS
BEGIN
   IF (NOT connection_exists (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_invalid_connection_errno, c_invalid_connection_errmsg);
   END IF;

   add_log (p_connection   => p_connection
           ,p_text         => 'Set local_dir: ' || p_local_dir);
   g_ftp_conn_tab(p_connection).local_dir := p_local_dir;

END set_local_dir;

--------------------------------------------------------------------------------
--  Procedure     : set_remote_dir
--
--  Description   : Sets the remote directory for FTP transfers. The connection 
--                  must be open to set this property
--------------------------------------------------------------------------------
PROCEDURE set_remote_dir    (p_connection  IN  NUMBER
                            ,p_remote_dir  IN  VARCHAR2)
AS
BEGIN
   IF (NOT connection_exists (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_invalid_connection_errno, c_invalid_connection_errmsg);
   ELSIF (NOT connection_open (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_connection_closed_errno, c_connection_closed_errmsg);
   END IF;
   
   -- change the remote directory
   send_cwd (p_connection  => p_connection
            ,p_remote_dir  => p_remote_dir);

   add_log (p_connection   => p_connection
           ,p_text         => 'Set remote_dir: ' || p_remote_dir);
           
   g_ftp_conn_tab(p_connection).remote_dir := p_remote_dir;

END set_remote_dir;

--------------------------------------------------------------------------------
--  Procedure     : set_charset
--
--  Description   : Sets the character set for FTP transfers. The connection 
--                  must be closed to set this property
--------------------------------------------------------------------------------
PROCEDURE set_charset    (p_connection  IN  NUMBER
                         ,p_charset     IN  VARCHAR2)
AS
BEGIN
   IF (NOT connection_exists (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_invalid_connection_errno, c_invalid_connection_errmsg);
   ELSIF (connection_open (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_connection_open_errno, c_connection_open_errmsg);
   END IF;

   add_log (p_connection   => p_connection
           ,p_text         => 'Set charset: ' || p_charset);
   g_ftp_conn_tab(p_connection).charset := p_charset;

END set_charset;

--------------------------------------------------------------------------------
--  Procedure     : set_newline
--
--  Description   : Sets the new line characters for FTP transfers. The connection 
--                  must be closed to set this property
--------------------------------------------------------------------------------
PROCEDURE set_newline    (p_connection  IN  NUMBER
                         ,p_newline     IN  VARCHAR2)
AS
BEGIN
   IF (NOT connection_exists (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_invalid_connection_errno, c_invalid_connection_errmsg);
   ELSIF (connection_open (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_connection_open_errno, c_connection_open_errmsg);
   END IF;

   add_log (p_connection   => p_connection
           ,p_text         => 'Set newline: ' || p_newline);
   g_ftp_conn_tab(p_connection).newline := p_newline;

END set_newline;

--------------------------------------------------------------------------------
--  Procedure     : set_tx_timeout
--
--  Description   : Sets the timeout for FTP transfers. The connection 
--                  must be closed to set this property
--------------------------------------------------------------------------------
PROCEDURE set_tx_timeout    (p_connection  IN  NUMBER
                            ,p_tx_timeout  IN  NUMBER)
AS 
  l_tx_timeout NUMBER;
BEGIN
   IF (NOT connection_exists (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_invalid_connection_errno, c_invalid_connection_errmsg);
   ELSIF (connection_open (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_connection_open_errno, c_connection_open_errmsg);
   END IF;

   -- UTL_TCP seems to wait forever if the tx timeout is
   -- NULL... and this seems to cause the session to hang
   -- so, ensure we set a value for this property
   l_tx_timeout := NVL(p_tx_timeout,c_default_tx_timeout);
   
   add_log (p_connection   => p_connection
           ,p_text         => 'Set tx_timeout: ' || TO_CHAR(p_tx_timeout));
   g_ftp_conn_tab(p_connection).tx_timeout := l_tx_timeout;
   
END set_tx_timeout;

--------------------------------------------------------------------------------
--  Procedure     : set_in_buffer_size
--
--  Description   : Sets the input TCP buffer size, in bytes. Values from 0 to
--                  32k are permitted, as well as NULL. This cannot be set once
--                  the connection is opened
--------------------------------------------------------------------------------
PROCEDURE set_in_buffer_size    (p_connection     IN  NUMBER
                                ,p_in_buffer_size IN  NUMBER)
AS
BEGIN
   IF (NOT connection_exists (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_invalid_connection_errno, c_invalid_connection_errmsg);
   ELSIF (connection_open (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_connection_open_errno, c_connection_open_errmsg);
   ELSIF (p_in_buffer_size < c_min_tcp_buffer OR p_in_buffer_size > c_max_tcp_buffer) THEN
      RAISE_APPLICATION_ERROR (c_operation_failed_errno, c_operation_failed_errmsg);
   END IF;

   add_log (p_connection   => p_connection
           ,p_text         => 'Set in_buffer_size: ' || TO_CHAR(p_in_buffer_size));
   g_ftp_conn_tab(p_connection).in_buffer_size := p_in_buffer_size;

END set_in_buffer_size;

--------------------------------------------------------------------------------
--  Procedure     : set_out_buffer_size
--
--  Description   : Sets the output TCP buffer size, in bytes. Values from 0 to
--                  32k are permitted, as well as NULL. This cannot be set once
--                  the connection is opened
--------------------------------------------------------------------------------
PROCEDURE set_out_buffer_size    (p_connection      IN  NUMBER
                                 ,p_out_buffer_size IN  NUMBER)
AS
BEGIN
   IF (NOT connection_exists (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_invalid_connection_errno, c_invalid_connection_errmsg);
   ELSIF (connection_open (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_connection_open_errno, c_connection_open_errmsg);
   ELSIF (p_out_buffer_size < c_min_tcp_buffer OR p_out_buffer_size > c_max_tcp_buffer) THEN
      RAISE_APPLICATION_ERROR (c_operation_failed_errno, c_operation_failed_errmsg);
   END IF;

   add_log (p_connection   => p_connection
           ,p_text         => 'Set out_buffer_size: ' || TO_CHAR(p_out_buffer_size));
   g_ftp_conn_tab(p_connection).out_buffer_size := p_out_buffer_size;

END set_out_buffer_size;

--------------------------------------------------------------------------------
--  Function      : get_default_trans_mode
--
--  Description   : Returns the default transfer mode that will be used for
--                  FTP operations. This can be overridden with the BINARY
--                  and ASCII procedures
--------------------------------------------------------------------------------
FUNCTION get_default_trans_mode
RETURN VARCHAR2
AS
BEGIN
   RETURN g_default_trans_mode;
END get_default_trans_mode;

--------------------------------------------------------------------------------
--  Procedure     : set_default_trans_mode_ascii
--
--  Description   : Sets the default transfer mode to ascii. This setting will
--                  apply to all new connections and will not affect existing
--                  connection, whether they are open or not.
--------------------------------------------------------------------------------
PROCEDURE set_default_trans_mode_ascii
AS
BEGIN
   g_default_trans_mode := c_trans_mode_ascii;
END set_default_trans_mode_ascii;

--------------------------------------------------------------------------------
--  Procedure     : set_default_trans_mode_ascii
--
--  Description   : Sets the default transfer mode to binary. This setting will
--                  apply to all new connections and will not affect existing
--                  connection, whether they are open or not.
--------------------------------------------------------------------------------
PROCEDURE set_default_trans_mode_binary
AS
BEGIN
   g_default_trans_mode := c_trans_mode_binary;
END set_default_trans_mode_binary;

--------------------------------------------------------------------------------
--  Function      : get_session_log
--
--  Description   : Returns the log of the current session
--------------------------------------------------------------------------------
FUNCTION get_session_log (p_connection  IN NUMBER)
RETURN t_text_tab
AS
BEGIN
   IF (NOT connection_exists (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_invalid_connection_errno, c_invalid_connection_errmsg);
   END IF;
   
   RETURN g_ftp_conn_tab(p_connection).session_log;
   
END get_session_log;


--------------------------------------------------------------------------------
--  Procedure     : process_ftp_response
--
--  Description   : Processes FTP response, raising an exception if the response
--                  was an error condition
--------------------------------------------------------------------------------
PROCEDURE process_ftp_response (l_tcp_response IN t_ftp_response)
AS
BEGIN

   IF (l_tcp_response.response_code IS NOT NULL) THEN
      BEGIN
         IF (g_ftp_response_msg_tab(l_tcp_response.response_code).err_response) THEN
            RAISE_APPLICATION_ERROR (c_operation_failed_errno, 'FTP Error ' || TO_CHAR(l_tcp_response.response_code) || ' : ' || g_ftp_response_msg_tab(l_tcp_response.response_code).msg);
         END IF;
      EXCEPTION
         -- if the respopnse code isn't contained in the message table then
         -- we'll generate a no data found exception above so let's handle it
         -- gracefully
         WHEN NO_DATA_FOUND THEN
            -- if the response code is in the 400s or 500s then its an error
            -- otherwise just continue without action
            IF (l_tcp_response.response_code >= 400) THEN
               RAISE_APPLICATION_ERROR (c_operation_failed_errno, 'FTP Error ' || TO_CHAR(l_tcp_response.response_code) || ' : Unknown error response');
            ELSE
               NULL;
            END IF;
         END;
      ELSIF (l_tcp_response.response_lines_tab.COUNT = 0) THEN
      RAISE_APPLICATION_ERROR (c_operation_failed_errno, 'FTP Error : No response received for the previous operation');
   END IF;

END process_ftp_response;

--------------------------------------------------------------------------------
--  Procedure     : binary
--
--  Description   : Sets the transfer mode to binary
--------------------------------------------------------------------------------
PROCEDURE binary    (p_connection  IN  NUMBER)
AS
BEGIN
   IF (NOT connection_exists (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_invalid_connection_errno, c_invalid_connection_errmsg);
   ELSIF (NOT connection_open (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_connection_open_errno, c_connection_open_errmsg);
   END IF;
   
   -- send the binary command to the remote host
   send_binary (p_connection => p_connection);
   
   add_log (p_connection   => p_connection
           ,p_text         => 'Set mode: binary');
   g_ftp_conn_tab(p_connection).trans_mode := 'BINARY';
   
END binary;

--------------------------------------------------------------------------------
--  Procedure     : ascii
--
--  Description   : Sets the transfer mode to ascii (text)
--------------------------------------------------------------------------------
PROCEDURE ascii    (p_connection  IN  NUMBER)
AS
BEGIN
   IF (NOT connection_exists (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_invalid_connection_errno, c_invalid_connection_errmsg);
   ELSIF (NOT connection_open (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_connection_open_errno, c_connection_open_errmsg);
   END IF;
   
   -- send the ascii command to the remote host
   send_ascii (p_connection => p_connection);
   
   add_log (p_connection   => p_connection
           ,p_text         => 'Set mode: ascii');
   g_ftp_conn_tab(p_connection).trans_mode := 'ASCII';
   
END ascii;

--------------------------------------------------------------------------------
--  Function      : write_cmd
--
--  Description   : Writes a line to the FTP command connection
--------------------------------------------------------------------------------
FUNCTION write_cmd (p_connection     IN NUMBER
                   ,p_text           IN VARCHAR2)
RETURN PLS_INTEGER
AS
BEGIN
   
   add_log (p_connection   => p_connection
           ,p_text         => 'Remote request: ' || p_text);
   RETURN utl_tcp.write_line(g_ftp_conn_tab(p_connection).cmd_conn,p_text);
   
END write_cmd;

--------------------------------------------------------------------------------
--  Function      : get_line
--
--  Description   : Reads a line from the TCP connection
--------------------------------------------------------------------------------
FUNCTION get_line   (p_tcp_connection IN OUT NOCOPY utl_tcp.connection
                    ,p_remove_crlf    IN BOOLEAN DEFAULT FALSE
                    ,p_peek           IN BOOLEAN DEFAULT FALSE)
RETURN t_response_line
AS
BEGIN
   RETURN utl_tcp.get_line(p_tcp_connection,p_remove_crlf,p_peek);   
END get_line;

--------------------------------------------------------------------------------
--  Function      : get_lines
--
--  Description   : Reads all pending line from the TCP connection
--------------------------------------------------------------------------------
FUNCTION get_lines  (p_tcp_connection IN OUT NOCOPY utl_tcp.connection
                    ,p_remove_crlf    IN BOOLEAN DEFAULT FALSE
                    ,p_peek           IN BOOLEAN DEFAULT FALSE)
RETURN t_response_lines_tab
AS
   l_response_line       t_response_line;
   l_response_lines_tab  t_response_lines_tab := t_response_lines_tab();
   l_no_response         BOOLEAN;
BEGIN

   -- now read from the connection until we run out
   -- of input
   l_no_response := FALSE;
   WHILE (NOT l_no_response)
   LOOP
      BEGIN
         l_response_line := get_line (p_tcp_connection  => p_tcp_connection
                                     ,p_remove_crlf     => TRUE
                                     ,p_peek            => FALSE);
         l_response_lines_tab.EXTEND;
         l_response_lines_tab(l_response_lines_tab.LAST) := l_response_line;
      EXCEPTION
         WHEN utl_tcp.end_of_input THEN
            l_no_response := TRUE;
         -- seems to be bug in UTL_TCP that get_line waits for TRANSFER_TIMEOUT
         -- when reading a line... or maybe I'm doing something wrong...
         WHEN utl_tcp.transfer_timeout THEN
            l_no_response := TRUE;
            --dbms_output.put_line ('get_lines terminated by transfer_timeout');
      END;
   END LOOP;
   
   RETURN l_response_lines_tab;

END get_lines;

--------------------------------------------------------------------------------
--  Function      : get_cmd_response
--
--  Description   : Returns the response from the FTP command connection
--------------------------------------------------------------------------------
FUNCTION get_cmd_response  (p_connection     IN NUMBER
                           ,p_remove_crlf    IN BOOLEAN DEFAULT FALSE
                           ,p_peek           IN BOOLEAN DEFAULT FALSE)
RETURN t_ftp_response
AS
   l_tcp_response t_ftp_response;
BEGIN
   
   -- put all the response lines from the connection
   l_tcp_response.response_lines_tab := get_lines(g_ftp_conn_tab(p_connection).cmd_conn,p_remove_crlf,p_peek);
                                                      
   -- now set the response code
   IF (l_tcp_response.response_lines_tab.COUNT > 0) THEN
      -- block to catch TO_NUMBER conversion exceptions, which we'll ignore
      BEGIN
         l_tcp_response.response_code := TO_NUMBER(SUBSTR(l_tcp_response.response_lines_tab(1),1,3));
         g_ftp_conn_tab(p_connection).last_response_code := TO_NUMBER(l_tcp_response.response_code);
      EXCEPTION
         WHEN VALUE_ERROR THEN
            NULL;
      END;
   END IF;

   -- add the response entries to the connection log   
   IF (l_tcp_response.response_lines_tab.COUNT > 0) THEN
      FOR i IN 1..l_tcp_response.response_lines_tab.COUNT
      LOOP
         add_log (p_connection   => p_connection
                 ,p_text         => 'Remote response: ' || l_tcp_response.response_lines_tab(i));
      END LOOP;
   END IF;
          
   RETURN l_tcp_response;
   
END get_cmd_response;

--------------------------------------------------------------------------------
--  Procedure     : send_cmd
--
--  Description   : Sends a command to the remote host and checks the response
--                  to ensure the command was successful. 
--                  An exception of ex_operation_failed is raised if the
--                  command fails. The request and response are written to
--                  the session log
--------------------------------------------------------------------------------
PROCEDURE send_cmd (p_tcp_response  OUT t_ftp_response
                   ,p_connection    IN  NUMBER
                   ,p_cmd           IN  VARCHAR2)
AS
   l_chars_sent    NUMBER;
   l_tcp_response  t_ftp_response;
   l_response_code VARCHAR2(3);
   l_no_response   BOOLEAN;
BEGIN

   -- send the command to the remote server
   l_chars_sent := write_cmd (p_connection => p_connection
                             ,p_text       => p_cmd);
   
   -- get the response
   l_tcp_response := get_cmd_response (p_connection     => p_connection
                                      ,p_remove_crlf    => TRUE
                                      ,p_peek           => FALSE);

   -- process the response, mainly for error conditions
   process_ftp_response (l_tcp_response);
   
   -- send the response back to the calling routine
   p_tcp_response := l_tcp_response;
         
END send_cmd;

--------------------------------------------------------------------------------
--  Procedure     : send_username
--
--  Description   : Sends the username command to the remote server
--------------------------------------------------------------------------------
PROCEDURE send_username (p_connection  IN NUMBER)
AS
   l_tcp_response t_ftp_response;
BEGIN
   send_cmd (p_tcp_response  => l_tcp_response
            ,p_connection    => p_connection
            ,p_cmd           => 'USER ' || g_ftp_conn_tab(p_connection).username);
END send_username;   

--------------------------------------------------------------------------------
--  Procedure     : send_password
--
--  Description   : Sends the password command to the remote server
--------------------------------------------------------------------------------
PROCEDURE send_password (p_connection  IN NUMBER)
AS
   l_tcp_response t_ftp_response;
BEGIN
   send_cmd (p_tcp_response  => l_tcp_response
            ,p_connection    => p_connection
            ,p_cmd           => 'PASS ' || g_ftp_conn_tab(p_connection).password);
END send_password; 

--------------------------------------------------------------------------------
--  Procedure     : send_feat
--
--  Description   : Sends the FEAT command to the remote server
--------------------------------------------------------------------------------
PROCEDURE send_feat (p_connection  IN NUMBER)
AS
   l_tcp_response t_ftp_response;
BEGIN
   send_cmd (p_tcp_response  => l_tcp_response
            ,p_connection    => p_connection
            ,p_cmd           => 'FEAT ');
END send_feat; 

--------------------------------------------------------------------------------
--  Procedure     : send_ascii
--
--  Description   : Sets the transfer type to ASCII
--------------------------------------------------------------------------------
PROCEDURE send_ascii (p_connection  IN NUMBER)
AS
   l_tcp_response t_ftp_response;
BEGIN
   send_cmd (p_tcp_response  => l_tcp_response
            ,p_connection    => p_connection
            ,p_cmd           => 'TYPE A');
END send_ascii; 

--------------------------------------------------------------------------------
--  Procedure     : send_binary
--
--  Description   : Sets the transfer type to binary
--------------------------------------------------------------------------------
PROCEDURE send_binary (p_connection  IN NUMBER)
AS
   l_tcp_response t_ftp_response;
BEGIN
   send_cmd (p_tcp_response  => l_tcp_response
            ,p_connection    => p_connection
            ,p_cmd           => 'TYPE I');
END send_binary; 


--------------------------------------------------------------------------------
--  Procedure     : exract_data_conn
--
--  Description   : Extracts the remote IP address and port number for the
--                  data connection from a PASV command response
--                  The format of the details are contained in the response
--                  string part:
--                  (a,b,c,d,x,y)
--                  where a,b,c,d are the IP address details and the port number
--                  is (x*256)+y
--------------------------------------------------------------------------------
PROCEDURE exract_data_conn (p_ip_address    OUT VARCHAR2
                           ,p_port          OUT NUMBER
                           ,p_pasv_response IN  VARCHAR2)
AS
   l_start_addr NUMBER;
   l_end_addr   NUMBER;
   l_addr       t_big_string;
BEGIN
   -- extract the part of the response in brackets
   l_start_addr := INSTR (p_pasv_response,'(')+1;
   l_end_addr   := INSTR (p_pasv_response,')')-1;
   l_addr       := SUBSTR (p_pasv_response,l_start_addr,l_end_addr-l_start_addr+1);

   -- now work out the IP address and port from the commas in the resulting string   
   p_ip_address := REPLACE (SUBSTR (l_addr, 1, INSTR (l_addr,',',1,4)-1),',','.');
   p_port       := (TO_NUMBER (SUBSTR (l_addr,INSTR (l_addr,',',1,4)+1,INSTR (l_addr,',',1,5)-INSTR (l_addr,',',1,4)-1)) * 256)+
                   (TO_NUMBER (SUBSTR (l_addr,INSTR (l_addr,',',1,5)+1)));
END exract_data_conn;   

--------------------------------------------------------------------------------
--  Procedure     : send_passive
--
--  Description   : Sets the FTP connection to passive mode and creates the
--                  data transfer connection using the details returned by the
--                  remote server.
--------------------------------------------------------------------------------
PROCEDURE send_passive (p_connection  IN NUMBER)
AS
   l_tcp_response t_ftp_response;
   l_data_addr    t_big_string;
   l_data_port    NUMBER;
BEGIN
   send_cmd (p_tcp_response  => l_tcp_response
            ,p_connection    => p_connection
            ,p_cmd           => 'PASV');
   
   exract_data_conn (p_ip_address    => l_data_addr
                    ,p_port          => l_data_port
                    ,p_pasv_response => l_tcp_response.response_lines_tab(1));
   
   add_log (p_connection  => p_connection
           ,p_text        => 'Transfer connection on : ' || l_data_addr || ':' || l_data_port);
   
   g_ftp_conn_tab(p_connection).trans_conn := utl_tcp.open_connection (remote_host      => l_data_addr 
                                                                      ,remote_port      => l_data_port 
                                                                      ,local_host       => NULL
                                                                      ,local_port       => NULL
                                                                      ,in_buffer_size   => get_in_buffer_size (p_connection)
                                                                      ,out_buffer_size  => get_out_buffer_size (p_connection)
                                                                      ,charset          => get_charset (p_connection)
                                                                      ,newline          => get_newline (p_connection)
                                                                      ,tx_timeout       => get_tx_timeout (p_connection));
END send_passive;   

--------------------------------------------------------------------------------
--  Procedure     : close_trans_connection
--
--  Description   : Closes the data transfer connection
--------------------------------------------------------------------------------
PROCEDURE close_trans_connection (p_connection  IN NUMBER)
AS
BEGIN
   -- now close the transfer connection if it's open
   IF (g_ftp_conn_tab(p_connection).trans_conn.remote_host IS NOT NULL) THEN
      utl_tcp.close_connection(g_ftp_conn_tab(p_connection).trans_conn);
   END IF;
END close_trans_connection;

--------------------------------------------------------------------------------
--  Procedure     : exract_dir
--
--  Description   : Extracts the remote directory from the response string
--------------------------------------------------------------------------------
PROCEDURE exract_dir (p_remote_dir    OUT VARCHAR2
                     ,p_pwd_response  IN  VARCHAR2)
AS
   l_start_dir NUMBER;
   l_end_dir   NUMBER;
BEGIN
   l_start_dir   := INSTR (p_pwd_response,'"')+1;
   l_end_dir     := INSTR (p_pwd_response,'"',1,2)-1;
   p_remote_dir  := SUBSTR (p_pwd_response,l_start_dir,l_end_dir-l_start_dir+1);
END exract_dir;   

--------------------------------------------------------------------------------
--  Procedure     : send_pwd
--
--  Description   : Sends the pwd command and obtains the current remote 
--                  directory, which is set as the connection record property
--------------------------------------------------------------------------------
PROCEDURE send_pwd (p_connection  IN NUMBER)
AS
   l_tcp_response t_ftp_response;
   l_remote_dir   t_big_string;
BEGIN
   send_cmd (p_tcp_response  => l_tcp_response
            ,p_connection    => p_connection
            ,p_cmd           => 'PWD');

   exract_dir (p_remote_dir    => l_remote_dir
              ,p_pwd_response  => l_tcp_response.response_lines_tab(1));
   
   g_ftp_conn_tab(p_connection).remote_dir := l_remote_dir;
   
   add_log (p_connection   => p_connection
           ,p_text         => 'Remote Directory: ' || l_remote_dir);
END send_pwd;   

--------------------------------------------------------------------------------
--  Procedure     : send_cwd
--
--  Description   : Sends the cwd command and obtains the current remote 
--                  directory, which is set as the connection record property
--------------------------------------------------------------------------------
PROCEDURE send_cwd (p_connection  IN NUMBER
                   ,p_remote_dir  IN VARCHAR2)
AS
   l_tcp_response t_ftp_response;
BEGIN
   send_cmd (p_tcp_response  => l_tcp_response
            ,p_connection    => p_connection
            ,p_cmd           => 'CWD ' || p_remote_dir);
END send_cwd;   

--------------------------------------------------------------------------------
--  Function      : get_remote_dir_list
--
--  Description   : Returns a directory listing of the remote server. The details
--                  of the listing will be server specific but may be able to be
--                  parsed.
--------------------------------------------------------------------------------
FUNCTION get_remote_dir_list (p_connection       IN NUMBER
                             ,p_remote_dir       IN VARCHAR2 DEFAULT NULL)
RETURN t_text_tab
AS
   l_response_lines_tab t_response_lines_tab;
   l_text_tab           t_text_tab := t_text_tab();
   l_tcp_response       t_ftp_response;
BEGIN
   IF (NOT connection_exists (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_invalid_connection_errno, c_invalid_connection_errmsg);
   ELSIF (NOT connection_open (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_connection_open_errno, c_connection_open_errmsg);
   END IF;
   
   -- open the data port to receive the directory listing
   send_passive (p_connection);
   
   send_cmd (p_tcp_response  => l_tcp_response
            ,p_connection    => p_connection
            ,p_cmd           => 'LIST ' || p_remote_dir);

   -- the directory listing is on the data transfer connection
   -- so read it from that
   l_response_lines_tab := get_lines(p_tcp_connection => g_ftp_conn_tab(p_connection).trans_conn
                                    ,p_remove_crlf    => TRUE
                                    ,p_peek           => FALSE);
                                           
   -- now close the data connection
   close_trans_connection (p_connection);

   -- copy the response lines into the return collection
   FOR i IN 1..l_response_lines_tab.COUNT
   LOOP
      l_text_tab.EXTEND;
      l_text_tab(l_text_tab.LAST) := l_response_lines_tab(i);
   END LOOP;

   -- get any remaining response lines after the get operation
   l_tcp_response :=  get_cmd_response (p_connection);
   
   RETURN l_text_tab;
   
EXCEPTION
   WHEN OTHERS THEN
      -- close the data connection if it's open
      IF (connection_exists (p_connection)) THEN
         close_trans_connection (p_connection);
         -- get any remaining response lines after the get operation
         IF (connection_open (p_connection)) THEN
            l_tcp_response :=  get_cmd_response (p_connection);
         END IF;
      END IF;
      RAISE;

END get_remote_dir_list;


--------------------------------------------------------------------------------
--  Function      : get_remote_file_list
--
--  Description   : Returns a file listing of the remote server
--------------------------------------------------------------------------------
FUNCTION get_remote_file_list (p_connection       IN NUMBER
                              ,p_remote_dir       IN VARCHAR2 DEFAULT NULL)
RETURN t_text_tab
AS
   l_response_lines_tab t_response_lines_tab;
   l_text_tab           t_text_tab := t_text_tab();
   l_tcp_response       t_ftp_response;
BEGIN
   IF (NOT connection_exists (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_invalid_connection_errno, c_invalid_connection_errmsg);
   ELSIF (NOT connection_open (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_connection_open_errno, c_connection_open_errmsg);
   END IF;
   
   -- open the data port to receive the directory listing
   send_passive (p_connection);
   
   send_cmd (p_tcp_response  => l_tcp_response
            ,p_connection    => p_connection
            ,p_cmd           => 'NLST ' || p_remote_dir);
   
   -- the directory listing is on the data transfer connection
   -- so read it from that
   l_response_lines_tab := get_lines (p_tcp_connection => g_ftp_conn_tab(p_connection).trans_conn
                                     ,p_remove_crlf    => TRUE
                                     ,p_peek           => FALSE);
                                           
   -- now close the data connection
   close_trans_connection (p_connection);

   -- copy the response lines into the return collection
   FOR i IN 1..l_response_lines_tab.COUNT
   LOOP
      l_text_tab.EXTEND;
      l_text_tab(l_text_tab.LAST) := l_response_lines_tab(i);
   END LOOP;

   -- get any remaining response lines after the get operation
   l_tcp_response :=  get_cmd_response (p_connection);
   
   RETURN l_text_tab;
   
EXCEPTION
   WHEN OTHERS THEN
      -- close the data connection if it's open
      IF (connection_exists (p_connection)) THEN
         close_trans_connection (p_connection);
         -- get any remaining response lines after the get operation
         IF (connection_open (p_connection)) THEN
            l_tcp_response :=  get_cmd_response (p_connection);
         END IF;
      END IF;
      RAISE;

END get_remote_file_list;


--------------------------------------------------------------------------------
--  Function      : get_file_list
--
--  Description   : Returns a file listing of the remote server. This will only
--                  be the names of the files. The remote directory is
--                  optional. If not specified then the root directory is
--                  returned.
--
--                  Output of this routine is restricted to 4000 bytes per line. 
--                  Anything in excess is truncated.
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
PIPELINED
AS
   l_no_response        BOOLEAN;
   l_tcp_response       t_ftp_response;
   l_response_line      t_response_line;
BEGIN
   IF (NOT connection_exists (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_invalid_connection_errno, c_invalid_connection_errmsg);
   ELSIF (NOT connection_open (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_connection_open_errno, c_connection_open_errmsg);
   END IF;
   
   -- open the data port to receive the directory listing
   send_passive (p_connection);

   -- send the directory listing command
   send_cmd (p_tcp_response  => l_tcp_response
            ,p_connection    => p_connection
            ,p_cmd           => 'NLST ' || p_remote_dir);
       
   -- now read from the connection until we run out
   -- of input
   l_no_response := FALSE;
   WHILE (NOT l_no_response)
   LOOP
      BEGIN
         l_response_line := get_line (p_tcp_connection  => g_ftp_conn_tab(p_connection).trans_conn
                                     ,p_remove_crlf     => TRUE
                                     ,p_peek            => FALSE);
         PIPE ROW (SUBSTR(l_response_line,1,c_max_varchar2_len));
      EXCEPTION
         WHEN utl_tcp.end_of_input THEN
            l_no_response := TRUE;
         -- seems to be bg in UTL_TCP that get_line waits for TRANSFER_TIMEOUT
         -- when reading a line... or maybe I'm doing something wrong...
         WHEN utl_tcp.transfer_timeout THEN
            l_no_response := TRUE;
         WHEN NO_DATA_NEEDED THEN
            l_no_response := TRUE;
      END;
   END LOOP;

   -- now close the data connection
   close_trans_connection (p_connection);

   -- get any remaining response lines after the get operation
   l_tcp_response :=  get_cmd_response (p_connection);

   RETURN;

EXCEPTION
   WHEN OTHERS THEN
      IF (connection_exists (p_connection)) THEN
         -- now close the data connection
         close_trans_connection (p_connection);
         -- get any remaining response lines after the get operation
         IF (connection_open (p_connection)) THEN
            l_tcp_response :=  get_cmd_response (p_connection);
         END IF;
      END IF;
      RAISE;
END get_file_list;


--------------------------------------------------------------------------------
--  Function      : get_file_list
--
--  Description   : Returns a file listing of the remote server. This will only
--                  be the names of the files. The remote directory is
--                  optional. If not specified then the root directory is
--                  returned
--
--                  Output of this routine is restricted to 4000 bytes per line. 
--                  Anything in excess is truncated.
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
PIPELINED
AS
   l_connection         NUMBER;
   l_no_response        BOOLEAN;
   l_tcp_response       t_ftp_response;
   l_response_line      t_response_line;
BEGIN
   
   -- create a new FTP connection
   l_connection := create_connection (p_site        => p_site
                                     ,p_port        => p_port
                                     ,p_username    => p_username
                                     ,p_password    => p_password);
                                     
   -- open the FTP connection 
   open_connection (l_connection);
   
   -- open the data port to receive the directory listing
   send_passive (l_connection);

   -- send the directory listing command
   send_cmd (p_tcp_response  => l_tcp_response
            ,p_connection    => l_connection
            ,p_cmd           => 'NLST ' || p_remote_dir);
       
   -- now read from the connection until we run out
   -- of input
   l_no_response := FALSE;
   WHILE (NOT l_no_response)
   LOOP
      BEGIN
         l_response_line := get_line (p_tcp_connection  => g_ftp_conn_tab(l_connection).trans_conn
                                     ,p_remove_crlf     => TRUE
                                     ,p_peek            => FALSE);
         PIPE ROW (SUBSTR(l_response_line,1,c_max_varchar2_len));
      EXCEPTION
         WHEN utl_tcp.end_of_input THEN
            l_no_response := TRUE;
         -- seems to be bg in UTL_TCP that get_line waits for TRANSFER_TIMEOUT
         -- when reading a line... or maybe I'm doing something wrong...
         WHEN utl_tcp.transfer_timeout THEN
            l_no_response := TRUE;
         WHEN NO_DATA_NEEDED THEN
            l_no_response := TRUE;
      END;
   END LOOP;

   -- now close the data connection
   close_trans_connection (l_connection);

   -- get any remaining response lines after the get operation
   l_tcp_response :=  get_cmd_response (l_connection);
   
   -- now close and remove the connection
   delete_connection (l_connection);

   RETURN;

EXCEPTION
   WHEN OTHERS THEN
      IF (connection_exists (l_connection)) THEN
         -- now remove the connection
         delete_connection (l_connection);
      END IF;
      RAISE;
END get_file_list;


--------------------------------------------------------------------------------
--  Function      : get_clob
--
--  Description   : Reads all pending text on the FTP transfer connection
--                  and returns a CLOB with the data
--------------------------------------------------------------------------------
PROCEDURE get_clob  (p_clob            OUT CLOB
                    ,p_connection      IN  NUMBER
                    ,P_remote_filename IN  VARCHAR2
                    ,p_file_size       IN  NUMBER)
AS
   c_buffer_size        CONSTANT NUMBER := c_ftp_buffer_size;
   l_buffer             t_text_buffer;
   l_num_chars          NUMBER;
   l_more_data          BOOLEAN;
   l_clob               CLOB;
   -- longops variables
   l_rindex             BINARY_INTEGER := dbms_application_info.set_session_longops_nohint;
   l_slno               BINARY_INTEGER;
   l_sofar              NUMBER := 0;
   l_totalwork          NUMBER := p_file_size;
BEGIN

   dbms_lob.createtemporary(l_clob,TRUE);
  
   -- start longops monitoring
   dbms_application_info.set_session_longops
     (rindex      => l_rindex
     ,slno        => l_slno
     ,op_name     => 'FTP get'
     ,target      => 0
     ,context     => 0
     ,sofar       => l_sofar
     ,totalwork   => l_totalwork
     ,target_desc => P_remote_filename
     ,units       => 'bytes'); 
   
   -- now pull the file into the lob
   l_more_data := TRUE;
   WHILE (l_more_data) 
   LOOP
      BEGIN
         -- read the text in chunks, appending each chunk onto
         -- the clob
         l_num_chars := utl_tcp.read_text (g_ftp_conn_tab(p_connection).trans_conn
                                          ,l_buffer
                                          ,c_buffer_size);
       
         -- keep track of how far through the file we've processed
         l_sofar := l_sofar + l_num_chars;

         -- update the longops
         dbms_application_info.set_session_longops
           (rindex      => l_rindex
           ,slno        => l_slno
           ,sofar       => l_sofar
           ,totalwork   => l_totalwork); 

         IF (l_num_chars > 0) THEN
            dbms_lob.writeappend (l_clob, l_num_chars, l_buffer);
         END IF;
      EXCEPTION
         WHEN utl_tcp.transfer_timeout THEN
            l_more_data := FALSE;
         WHEN utl_tcp.end_of_input THEN
            l_more_data := FALSE;
      END;
   END LOOP;
   
   -- assign the output BLOB
   p_clob := l_clob;

END get_clob;

--------------------------------------------------------------------------------
--  Function      : get_blob
--
--  Description   : Reads all pending text on the FTP transfer connection
--                  and returns a BLOB with the data
--------------------------------------------------------------------------------
PROCEDURE get_blob  (p_blob            OUT BLOB
                    ,p_connection      IN  NUMBER
                    ,P_remote_filename IN  VARCHAR2
                    ,p_file_size       IN  NUMBER)
AS
   c_buffer_size        CONSTANT NUMBER := c_ftp_buffer_size;
   l_buffer             t_raw_buffer ;
   l_num_bytes          NUMBER;
   l_more_data          BOOLEAN;
   l_blob               BLOB;
   -- longops variables
   l_rindex             BINARY_INTEGER := dbms_application_info.set_session_longops_nohint;
   l_slno               BINARY_INTEGER;
   l_sofar              NUMBER := 0;
   l_totalwork          NUMBER := p_file_size;
BEGIN

   dbms_lob.createtemporary(l_blob,TRUE);
  
   -- start longops monitoring
   dbms_application_info.set_session_longops
     (rindex      => l_rindex
     ,slno        => l_slno
     ,op_name     => 'FTP get'
     ,target      => 0
     ,context     => 0
     ,sofar       => l_sofar
     ,totalwork   => l_totalwork
     ,target_desc => P_remote_filename
     ,units       => 'bytes'); 
   
   -- now pull the file into the lob
   l_more_data := TRUE;
   WHILE (l_more_data) 
   LOOP
      BEGIN
         -- read the remote file in chunks, appending each chunk onto
         -- the blob
         l_num_bytes := utl_tcp.read_raw  (g_ftp_conn_tab(p_connection).trans_conn
                                          ,l_buffer
                                          ,c_buffer_size);
       
         -- keep track of how far through the file we've processed
         l_sofar := l_sofar + l_num_bytes;

         -- update the longops
         dbms_application_info.set_session_longops
           (rindex      => l_rindex
           ,slno        => l_slno
           ,sofar       => l_sofar
           ,totalwork   => l_totalwork); 

         IF (l_num_bytes > 0) THEN
            dbms_lob.writeappend (l_blob, l_num_bytes, l_buffer);
         END IF;
      EXCEPTION
         WHEN utl_tcp.transfer_timeout THEN
            l_more_data := FALSE;
         WHEN utl_tcp.end_of_input THEN
            l_more_data := FALSE;
      END;
   END LOOP;
   
   -- assign the output BLOB
   p_blob := l_blob;

END get_blob;


--------------------------------------------------------------------------------
--  Procedure     : get_ascii
--
--  Description   : Retrieves the remote file and writes it to the directory
--                  and filename specified
--------------------------------------------------------------------------------
PROCEDURE get_ascii  (p_connection       IN NUMBER
                     ,p_remote_filename  IN VARCHAR2
                     ,p_local_dir        IN VARCHAR2
                     ,p_local_filename   IN VARCHAR2
                     ,p_remote_file_size IN NUMBER)
AS
   c_buffer_size        CONSTANT NUMBER := c_ftp_buffer_size;
   c_longops_updt_freq  CONSTANT NUMBER := 10;
   l_buffer             t_text_buffer;
   l_num_chars          NUMBER;
   l_more_data          BOOLEAN;
   l_file_handle        utl_file.file_type;
   -- longops variables
   l_rindex             BINARY_INTEGER := dbms_application_info.set_session_longops_nohint;
   l_slno               BINARY_INTEGER;
   l_sofar              NUMBER := 0;
   l_totalwork          NUMBER := p_remote_file_size;
   l_row_count          NUMBER := 0;
   l_validated          BOOLEAN := FALSE;
   
BEGIN
  -- open the local file for writing
   l_file_handle := utl_file.fopen (p_local_dir, p_local_filename, 'w', c_max_file_line_len);
  
   -- start longops monitoring
   dbms_application_info.set_session_longops
     (rindex      => l_rindex
     ,slno        => l_slno
     ,op_name     => 'FTP get'
     ,target      => 0
     ,context     => 0
     ,sofar       => l_sofar
     ,totalwork   => l_totalwork
     ,target_desc => p_remote_filename
     ,units       => 'bytes'); 
   
   -- now pull the file into the lob
   l_more_data := TRUE;
   WHILE (l_more_data) 
   LOOP
      BEGIN
         -- read the text in chunks, writing each chunk into the destination file
         l_num_chars := utl_tcp.read_line (c           => g_ftp_conn_tab(p_connection).trans_conn
                                          ,data        => l_buffer
                                          ,remove_crlf => TRUE);
       
         -- keep track of how far through the file we've processed
         l_sofar := l_sofar + LENGTH(l_buffer);
 
         -- capture Type measurement  --
         IF( l_buffer LIKE '%measurementType%') THEN
         
          IF(l_validated = FALSE)THEN
          
              l_validated := TRUE;
         
           IF(is_valid_measurement(l_buffer))THEN
              
              g_type_measurement := l_buffer;
              
            ELSE 
                  g_not_valid_measurement := TRUE;
                  EXIT;
            END IF;
           END IF; 
         END IF;
         
         -- only update longops every c_longops_updt_freq rows
         -- rather than every row, which would be excessive
         IF (l_row_count >= c_longops_updt_freq) THEN
            -- update the longops
            dbms_application_info.set_session_longops
              (rindex      => l_rindex
              ,slno        => l_slno
              ,totalwork   => l_totalwork
              ,sofar       => l_sofar); 
            -- reset the line counter
            l_row_count := 0;
         ELSE
            l_row_count := l_row_count + 1;
         END IF;

         IF (l_num_chars > 0) THEN
            utl_file.put_line (l_file_handle, l_buffer, TRUE);
         END IF;
      EXCEPTION
         WHEN utl_tcp.transfer_timeout THEN
            l_more_data := FALSE;
         WHEN utl_tcp.end_of_input THEN
            l_more_data := FALSE;
      END;
   END LOOP;
   
   IF (g_not_valid_measurement) THEN
        utl_file.fclose (l_file_handle);
        utl_file.fremove(p_local_dir, p_local_filename);
   ELSE
        utl_file.fclose (l_file_handle);
         
   END IF;
   
   
EXCEPTION
   WHEN OTHERS THEN
      IF (utl_file.is_open(l_file_handle)) THEN
         utl_file.fclose (l_file_handle);
      END IF;
      RAISE;

END get_ascii;

--------------------------------------------------------------------------------
--  Procedure     : get_binary
--
--  Description   : Retrieves the remote file and writes it to the directory
--                  and filename specified
--------------------------------------------------------------------------------
PROCEDURE get_binary  (p_connection       IN NUMBER
                      ,p_remote_filename  IN VARCHAR2
                      ,p_local_dir        IN VARCHAR2
                      ,p_local_filename   IN VARCHAR2
                      ,p_remote_file_size IN NUMBER)
AS
   c_buffer_size        CONSTANT NUMBER := c_ftp_buffer_size;
   l_buffer             t_raw_buffer;
   l_num_bytes          NUMBER;
   l_more_data          BOOLEAN;
   l_file_handle        utl_file.file_type;
   -- longops variables
   l_rindex             BINARY_INTEGER := dbms_application_info.set_session_longops_nohint;
   l_slno               BINARY_INTEGER;
   l_sofar              NUMBER := 0;
   l_totalwork          NUMBER := p_remote_file_size;
BEGIN

   -- open the local file for writing
   l_file_handle := utl_file.fopen (p_local_dir, p_local_filename, 'wb', c_buffer_size);
  
   -- start longops monitoring
   dbms_application_info.set_session_longops
     (rindex      => l_rindex
     ,slno        => l_slno
     ,op_name     => 'FTP get'
     ,target      => 0
     ,context     => 0
     ,sofar       => l_sofar
     ,totalwork   => l_totalwork
     ,target_desc => p_remote_filename
     ,units       => 'bytes'); 
   
   -- now pull the remote file across into the local file
   l_more_data := TRUE;
   WHILE (l_more_data) 
   LOOP
      BEGIN
         -- read the remote file in chunks, appending each chunk onto
         -- the blob
         l_num_bytes := utl_tcp.read_raw  (g_ftp_conn_tab(p_connection).trans_conn
                                          ,l_buffer
                                          ,c_buffer_size);

       
         -- keep track of how far through the file we've processed
         l_sofar := l_sofar + l_num_bytes;

         -- update the longops
         dbms_application_info.set_session_longops
           (rindex      => l_rindex
           ,slno        => l_slno
           ,sofar       => l_sofar
           ,totalwork   => l_totalwork); 

         IF (l_num_bytes > 0) THEN
            utl_file.put_raw (l_file_handle, l_buffer, TRUE);
         END IF;
      EXCEPTION
         WHEN utl_tcp.transfer_timeout THEN
            l_more_data := FALSE;
         WHEN utl_tcp.end_of_input THEN
            l_more_data := FALSE;
      END;
   END LOOP;
   
   utl_file.fclose (l_file_handle);
   
EXCEPTION
   WHEN OTHERS THEN
      IF (utl_file.is_open(l_file_handle)) THEN
         utl_file.fclose (l_file_handle);
      END IF;
      RAISE;

END get_binary;

--------------------------------------------------------------------------------
--  Procedure     : put_ascii
--
--  Description   : Retrieves the local file and writes it to the tcp
--                  connection specified
--------------------------------------------------------------------------------
PROCEDURE put_ascii   (p_connection       IN NUMBER
                      ,p_local_dir        IN VARCHAR2
                      ,p_local_filename   IN VARCHAR2
                      ,p_local_file_size  IN NUMBER)
AS
   c_buffer_size        CONSTANT NUMBER := c_ftp_buffer_size;
   c_longops_updt_freq  CONSTANT NUMBER := 10;

   l_buffer             t_text_buffer;
   l_num_chars          NUMBER;
   l_more_data          BOOLEAN;
   l_file_handle        utl_file.file_type;
   -- longops variables
   l_rindex             BINARY_INTEGER := dbms_application_info.set_session_longops_nohint;
   l_slno               BINARY_INTEGER;
   l_sofar              NUMBER := 0;
   l_totalwork          NUMBER := p_local_file_size;
   l_row_count          NUMBER := 0;
BEGIN

   -- open the local file for reading
   l_file_handle := utl_file.fopen (p_local_dir, p_local_filename, 'r', c_max_file_line_len);
   
   -- start longops monitoring
   dbms_application_info.set_session_longops
     (rindex      => l_rindex
     ,slno        => l_slno
     ,op_name     => 'FTP put'
     ,target      => 0
     ,context     => 0
     ,sofar       => l_sofar
     ,totalwork   => l_totalwork
     ,target_desc => p_local_filename
     ,units       => 'bytes'); 

   -- now read the file and send it to the tcp connectin
   l_more_data := TRUE;
   WHILE (l_more_data) 
   LOOP
      BEGIN 
         -- read the next line from the file...
         utl_file.get_line (l_file_handle, l_buffer, c_buffer_size);
       
         -- keep track of how far through the file we've processed
         l_sofar := l_sofar + LENGTH (l_buffer);
      
         -- only update longops every c_longops_updt_freq rows
         -- rather than every row, which would be excessive
         IF (l_row_count >= c_longops_updt_freq) THEN
            -- update the longops
            dbms_application_info.set_session_longops
              (rindex      => l_rindex
              ,slno        => l_slno
              ,totalwork   => l_totalwork
              ,sofar       => l_sofar); 
            -- reset the line counter
            l_row_count := 0;
         ELSE
            l_row_count := l_row_count + 1;
         END IF;

         -- ... and send across the connection
         l_num_chars := utl_tcp.write_line (g_ftp_conn_tab(p_connection).trans_conn
                                           ,l_buffer);
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            l_more_data := FALSE;
      END;
   END LOOP;
   
   utl_file.fclose (l_file_handle);
   
EXCEPTION
   WHEN OTHERS THEN
      IF (utl_file.is_open(l_file_handle)) THEN
         utl_file.fclose (l_file_handle);
      END IF;
      RAISE;

END put_ascii;


--------------------------------------------------------------------------------
--  Procedure     : put_binary
--
--  Description   : Retrieves the local file and writes it to the tcp
--                  connection specified
--------------------------------------------------------------------------------
PROCEDURE put_binary  (p_connection       IN NUMBER
                      ,p_local_dir        IN VARCHAR2
                      ,p_local_filename   IN VARCHAR2
                      ,p_local_file_size  IN NUMBER)
AS
   c_buffer_size        CONSTANT NUMBER := c_ftp_buffer_size;
   l_buffer             t_raw_buffer;
   l_num_bytes          NUMBER;
   l_more_data          BOOLEAN;
   l_file_handle        utl_file.file_type;
   -- longops variables
   l_rindex             BINARY_INTEGER := dbms_application_info.set_session_longops_nohint;
   l_slno               BINARY_INTEGER;
   l_sofar              NUMBER := 0;
   l_totalwork          NUMBER := p_local_file_size;
BEGIN

   -- open the local file for reading
   l_file_handle := utl_file.fopen (p_local_dir, p_local_filename, 'rb', c_max_file_line_len);
   
   -- start longops monitoring
   dbms_application_info.set_session_longops
     (rindex      => l_rindex
     ,slno        => l_slno
     ,op_name     => 'FTP put'
     ,target      => 0
     ,context     => 0
     ,sofar       => l_sofar
     ,totalwork   => l_totalwork
     ,target_desc => p_local_filename
     ,units       => 'bytes'); 

   -- now read the file and send it to the tcp connectin
   l_more_data := TRUE;
   WHILE (l_more_data) 
   LOOP
      BEGIN 
         -- read the next chunk from the file...
         utl_file.get_raw (l_file_handle, l_buffer, c_buffer_size);
       
         -- keep track of how far through the file we've processed
         l_sofar := l_sofar + utl_raw.length (l_buffer);
         
         -- update the longops
         dbms_application_info.set_session_longops
           (rindex      => l_rindex
           ,slno        => l_slno
           ,totalwork   => l_totalwork
           ,sofar       => l_sofar); 

         -- ... and send across the connection
         l_num_bytes := utl_tcp.write_raw  (g_ftp_conn_tab(p_connection).trans_conn
                                           ,l_buffer);
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            l_more_data := FALSE;
      END;
   END LOOP;
   
   utl_file.fclose (l_file_handle);
   
EXCEPTION
   WHEN OTHERS THEN
      IF (utl_file.is_open(l_file_handle)) THEN
         utl_file.fclose (l_file_handle);
      END IF;
      RAISE;

END put_binary;


--------------------------------------------------------------------------------
--  Procedure     : put_ascii
--
--  Description   : Send a CLOB to the remote connection
--------------------------------------------------------------------------------
PROCEDURE put_ascii  (p_connection       IN NUMBER
                     ,p_clob             IN CLOB
                     ,p_clob_size        IN NUMBER)
AS
   c_buffer_size        CONSTANT NUMBER := c_ftp_buffer_size;
   l_buffer             t_text_buffer;
   l_num_chars          NUMBER;
   -- longops variables
   l_rindex             BINARY_INTEGER := dbms_application_info.set_session_longops_nohint;
   l_slno               BINARY_INTEGER;
   l_sofar              NUMBER := 0;
   l_totalwork          NUMBER := p_clob_size;
BEGIN
   
   -- start longops monitoring
   dbms_application_info.set_session_longops
     (rindex      => l_rindex
     ,slno        => l_slno
     ,op_name     => 'FTP put: CLOB'
     ,target      => 0
     ,context     => 0
     ,sofar       => l_sofar
     ,totalwork   => l_totalwork
     ,target_desc => 'CLOB'
     ,units       => 'bytes'); 

   -- loop through the CLOB in chunks, writing each chunk to
   -- the remote file
   FOR i IN 0..FLOOR(dbms_lob.getlength(p_clob)/c_buffer_size)
   LOOP
      l_buffer := dbms_lob.substr(p_clob,c_buffer_size,(i*c_buffer_size)+1);

      -- keep track of how far through the CLOB we've processed
      l_sofar := l_sofar + LENGTH(l_buffer);
      
      -- update the longops
      dbms_application_info.set_session_longops
        (rindex      => l_rindex
        ,slno        => l_slno
        ,sofar       => l_sofar
        ,totalwork   => l_totalwork); 

      l_num_chars := utl_tcp.write_text (g_ftp_conn_tab(p_connection).trans_conn
                                        ,l_buffer
                                        ,LENGTH(l_buffer));
   END LOOP;

END put_ascii;

--------------------------------------------------------------------------------
--  Procedure     : put_binary
--
--  Description   : Send a BLOB to the remote connection
--------------------------------------------------------------------------------
PROCEDURE put_binary  (p_connection       IN NUMBER
                      ,p_blob             IN BLOB
                      ,p_blob_size        IN NUMBER)
AS
   c_buffer_size        CONSTANT NUMBER := c_ftp_buffer_size;
   l_buffer             t_raw_buffer;
   l_num_bytes          NUMBER;
   -- longops variables
   l_rindex             BINARY_INTEGER := dbms_application_info.set_session_longops_nohint;
   l_slno               BINARY_INTEGER;
   l_sofar              NUMBER := 0;
   l_totalwork          NUMBER := p_blob_size;
BEGIN
   
   -- start longops monitoring
   dbms_application_info.set_session_longops
     (rindex      => l_rindex
     ,slno        => l_slno
     ,op_name     => 'FTP put: BLOB'
     ,target      => 0
     ,context     => 0
     ,sofar       => l_sofar
     ,totalwork   => l_totalwork
     ,target_desc => 'BLOB'
     ,units       => 'bytes'); 
   
   -- loop through the BLOB in chunks, writing each chunk to
   -- the remote file
   FOR i IN 0..FLOOR(dbms_lob.getlength(p_blob)/c_buffer_size)
   LOOP
      l_buffer := dbms_lob.substr(p_blob,c_buffer_size,(i*c_buffer_size)+1);

      -- keep track of how far through the CLOB we've processed
      l_sofar := l_sofar + utl_raw.length(l_buffer);
      
      -- update the longops
      dbms_application_info.set_session_longops
        (rindex      => l_rindex
        ,slno        => l_slno
        ,sofar       => l_sofar
        ,totalwork   => l_totalwork); 

      l_num_bytes := utl_tcp.write_raw (g_ftp_conn_tab(p_connection).trans_conn
                                       ,l_buffer
                                       ,utl_raw.length(l_buffer));
   END LOOP;

END put_binary;

--------------------------------------------------------------------------------
--  Procedure     : extract_filename
--
--  Description   : Extracts a filename from a path
--------------------------------------------------------------------------------
FUNCTION extract_filename (p_file_path    IN VARCHAR2)
RETURN VARCHAR2
AS
BEGIN
   -- return the string that comes after the last '/'
   RETURN CASE -- if there is no '/'
               WHEN INSTR(p_file_path,'/') = 0 THEN p_file_path
               -- if the string ends in a '/' return null for no file name
               WHEN INSTR(p_file_path,'/',-1) = LENGTH(p_file_path) THEN NULL
               -- otherwise just the string after the last '/'
               ELSE SUBSTR(p_file_path,INSTR(p_file_path,'/',-1)+1)
          END;
END extract_filename;   


--------------------------------------------------------------------------------
--  Procedure     : get
--
--  Description   : Retrieves the remote file and writes it to the directory
--                  and filename specified
--------------------------------------------------------------------------------
PROCEDURE get    (p_connection       IN NUMBER
                 ,p_remote_filename  IN VARCHAR2
                 ,p_local_dir        IN VARCHAR2 DEFAULT NULL
                 ,p_local_filename   IN VARCHAR2 DEFAULT NULL)
AS
   l_tcp_response       t_ftp_response;
   l_file_size          NUMBER;
BEGIN
   IF (NOT connection_exists (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_invalid_connection_errno, c_invalid_connection_errmsg);
   ELSIF (NOT connection_open (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_connection_open_errno, c_connection_open_errmsg);
   END IF;
   
   -- get the size of the remote file for transfer monitoring
   l_file_size := get_size (p_connection      => p_connection
                           ,p_remote_filename => p_remote_filename);
   
   -- open the data port to receive the directory listing
   send_passive (p_connection);

   -- send the retrieve command
   send_cmd (p_tcp_response  => l_tcp_response
            ,p_connection    => p_connection
            ,p_cmd           => 'RETR ' || p_remote_filename);

   -- transfer the file using the mode defined; ascii or binary
   IF (get_trans_mode (p_connection) = c_trans_mode_ascii) THEN
      get_ascii  (p_connection       => p_connection
                 ,p_remote_filename  => p_remote_filename
                 ,p_local_dir        => NVL(p_local_dir,get_local_dir(p_connection))
                 ,p_local_filename   => extract_filename(NVL(p_local_filename,p_remote_filename))
                 ,p_remote_file_size => l_file_size);
   ELSIF (get_trans_mode (p_connection) = c_trans_mode_binary) THEN
      get_binary (p_connection       => p_connection
                 ,p_remote_filename  => p_remote_filename
                 ,p_local_dir        => NVL(p_local_dir,get_local_dir(p_connection))
                 ,p_local_filename   => extract_filename(NVL(p_local_filename,p_remote_filename))
                 ,p_remote_file_size => l_file_size);
   END IF;                 
                                        
   -- now close the data connection
   close_trans_connection (p_connection);
   
   -- get any remaining response lines after the get operation
   l_tcp_response :=  get_cmd_response (p_connection);

   
EXCEPTION
   WHEN OTHERS THEN
      IF (connection_exists (p_connection)) THEN
         -- close the data connection if it's open
         close_trans_connection (p_connection);
         -- get any remaining response lines after the get operation
         IF (connection_open (p_connection)) THEN
            l_tcp_response :=  get_cmd_response (p_connection);
         END IF;
      END IF;
      RAISE;
   
END get;

--------------------------------------------------------------------------------
--  Procedure     : get
--
--  Description   : Retrieves the remote file and returns it as a t_text_tab.
--
--                  This routine will only return data if the transfer mode is
--                  set to ASCII.
--
--                  Output of this routine is restricted to 4000 bytes per line. 
--                  Anything in excess is truncated.
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
PIPELINED
AS
   c_buffer_size        CONSTANT NUMBER := c_ftp_buffer_size;
   c_longops_updt_freq  CONSTANT NUMBER := 10;

   l_tcp_response       t_ftp_response;
   --l_file_size          NUMBER;
   l_buffer             t_text_buffer;
   l_num_chars          NUMBER;
   l_more_data          BOOLEAN;
   -- longops variables
   l_rindex             BINARY_INTEGER := dbms_application_info.set_session_longops_nohint;
   l_slno               BINARY_INTEGER;
   l_sofar              NUMBER := 0;
   l_totalwork          NUMBER;
   l_row_count          NUMBER := 0;
BEGIN
   IF (NOT connection_exists (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_invalid_connection_errno, c_invalid_connection_errmsg);
   ELSIF (NOT connection_open (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_connection_open_errno, c_connection_open_errmsg);
   END IF;

   -- if possible get the size of the file we're about to transfer
   l_totalwork := get_size (p_connection      => p_connection
                           ,p_remote_filename => p_remote_filename);
   
   -- open the data port to receive the directory listing
   send_passive (p_connection);

   -- send the retrieve command
   send_cmd (p_tcp_response  => l_tcp_response
            ,p_connection    => p_connection
            ,p_cmd           => 'RETR ' || p_remote_filename);

   -- return the file requested
   IF (get_trans_mode (p_connection) = c_trans_mode_ascii) THEN
   
  
       -- start longops monitoring
       dbms_application_info.set_session_longops
         (rindex      => l_rindex
         ,slno        => l_slno
         ,op_name     => 'FTP get'
         ,target      => 0
         ,context     => 0
         ,sofar       => l_sofar
         ,totalwork   => l_totalwork
         ,target_desc => p_remote_filename
         ,units       => 'bytes'); 
       
       -- now pull the file into the lob
       l_more_data := TRUE;
       WHILE (l_more_data) 
       LOOP
          BEGIN
             -- read the text in chunks, writing each chunk into the destination file
             l_num_chars := utl_tcp.read_line (c           => g_ftp_conn_tab(p_connection).trans_conn
                                              ,data        => l_buffer
                                              ,remove_crlf => TRUE);
           
             -- keep track of how far through the file we've processed
             l_sofar := l_sofar + LENGTH(l_buffer);
          
             -- only update longops every c_longops_updt_freq rows
             -- rather than every row, which would be excessive
             IF (l_row_count >= c_longops_updt_freq) THEN
                -- update the longops
                dbms_application_info.set_session_longops
                  (rindex      => l_rindex
                  ,slno        => l_slno
                  ,totalwork   => l_totalwork
                  ,sofar       => l_sofar); 
                -- reset the line counter
                l_row_count := 0;
             ELSE
                l_row_count := l_row_count + 1;
             END IF;
    
             -- we're limited to lines of 4000 chars or less
             -- for SQL data types so simply truncate to 4000 chars
             IF (l_num_chars > 0) THEN
                PIPE ROW (SUBSTR(l_buffer,1,c_max_varchar2_len));
             END IF;
          EXCEPTION
             WHEN utl_tcp.transfer_timeout THEN
                l_more_data := FALSE;
             WHEN utl_tcp.end_of_input THEN
                l_more_data := FALSE;
             WHEN NO_DATA_NEEDED THEN
                l_more_data :=  FALSE;
          END;
       END LOOP;

   END IF;                 
                                           
   -- now close the data connection
   close_trans_connection (p_connection);

   -- get any remaining response lines after the get operation
   l_tcp_response :=  get_cmd_response (p_connection);

   RETURN;

EXCEPTION
   WHEN OTHERS THEN
      IF (connection_exists (p_connection)) THEN
         -- now close the data connection
         close_trans_connection (p_connection);
         -- get any remaining response lines after the get operation
         IF (connection_open (p_connection)) THEN
            l_tcp_response :=  get_cmd_response (p_connection);
         END IF;
      END IF;
      RAISE;
END get;


--------------------------------------------------------------------------------
--  Procedure     : get
--
--  Description   : Retrieves the remote file and returns it as a t_text_tab
--
--                  This version of GET creates the FTP connection, retrieves
--                  the file and then closes and removes the connection once
--                  finished.
--
--                  Output of this routine is restricted to 4000 bytes per line. 
--                  Anything in excess is truncated.
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
PIPELINED
AS
   c_longops_updt_freq  CONSTANT NUMBER := 10;
   
   l_connection         NUMBER;
   l_tcp_response       t_ftp_response;
   l_buffer             t_text_buffer;
   l_num_chars          NUMBER;
   l_more_data          BOOLEAN;
   -- longops variables
   l_rindex             BINARY_INTEGER := dbms_application_info.set_session_longops_nohint;
   l_slno               BINARY_INTEGER;
   l_sofar              NUMBER := 0;
   l_totalwork          NUMBER;
   l_row_count          NUMBER := 0;
BEGIN
   
   -- create a new FTP connection
   l_connection := create_connection (p_site        => p_site
                                     ,p_port        => p_port
                                     ,p_username    => p_username
                                     ,p_password    => p_password);
                                     
   -- open the FTP connection 
   open_connection (l_connection);
   
   -- set the transfer mode to ASCII
   ascii (l_connection);

   -- get the size of the remote file for transfer monitoring
   l_totalwork := get_size (p_connection      => l_connection
                           ,p_remote_filename => p_remote_filename);
   
   -- open the data port to receive the directory listing
   send_passive (l_connection);

   -- send the retrieve command
   send_cmd (p_tcp_response  => l_tcp_response
            ,p_connection    => l_connection
            ,p_cmd           => 'RETR ' || p_remote_filename);
  
   -- start longops monitoring
   dbms_application_info.set_session_longops
      (rindex      => l_rindex
      ,slno        => l_slno
      ,op_name     => 'FTP get'
      ,target      => 0
      ,context     => 0
      ,sofar       => l_sofar
      ,totalwork   => l_totalwork
      ,target_desc => p_remote_filename
      ,units       => 'bytes'); 
       
   -- now pull the file into the lob
   l_more_data := TRUE;
   WHILE (l_more_data) 
   LOOP
      BEGIN
         -- read the text in chunks, writing each chunk into the destination file
         l_num_chars := utl_tcp.read_line (c           => g_ftp_conn_tab(l_connection).trans_conn
                                          ,data        => l_buffer
                                          ,remove_crlf => TRUE);
           
         -- keep track of how far through the file we've processed
         l_sofar := l_sofar + l_num_chars;
    
          
         -- only update longops every c_longops_updt_freq rows
         -- rather than every row, which would be excessive
         IF (l_row_count >= c_longops_updt_freq) THEN
            -- update the longops
            dbms_application_info.set_session_longops
               (rindex      => l_rindex
               ,slno        => l_slno
               ,totalwork   => l_totalwork
               ,sofar       => l_sofar); 
            -- reset the line counter
            l_row_count := 0;
         ELSE
            l_row_count := l_row_count + 1;
         END IF;
    
         -- we're limited to lines of 4000 chars or less
         -- for SQL data types so simply truncate to 4000 chars
         IF (l_num_chars > 0) THEN
            PIPE ROW (SUBSTR(l_buffer,1,c_max_varchar2_len));
         END IF;
      EXCEPTION
          WHEN utl_tcp.transfer_timeout THEN
             l_more_data := FALSE;
          WHEN utl_tcp.end_of_input THEN
             l_more_data := FALSE;
          WHEN NO_DATA_NEEDED THEN
             l_more_data := FALSE;
      END;
   END LOOP;

   -- now close the data connection
   close_trans_connection (l_connection);

   -- get any remaining response lines after the get operation
   l_tcp_response :=  get_cmd_response (p_connection => l_connection);
   
   -- now close and remove the connection
   delete_connection (l_connection);

   RETURN;

EXCEPTION
   WHEN OTHERS THEN
      IF (connection_exists (l_connection)) THEN
         -- now remove the connection
         delete_connection (l_connection);
      END IF;
      RAISE;
END get;

--------------------------------------------------------------------------------
--  Procedure     : mget
--
--  Description   : Retrieves multiple remote files and writes them to the
--                  directory specified. The ability to rename the files in the
--                  copy process is not provided.
--------------------------------------------------------------------------------
PROCEDURE mget   (p_connection       IN NUMBER
                 ,p_remote_filename  IN VARCHAR2
                 ,p_local_dir        IN VARCHAR2 DEFAULT NULL)
AS
   l_file_list       t_text_tab;
   current_date      DATE := SYSDATE;
   etl_status        VARCHAR2(10 BYTE):='0';       --  0:imported
   p_counter         NUMBER;
   sql_stmt          VARCHAR2(200);
   v_local_file_name VARCHAR2(200);
BEGIN
   IF (NOT connection_exists (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_invalid_connection_errno, c_invalid_connection_errmsg);
   ELSIF (NOT connection_open (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_connection_open_errno, c_connection_open_errmsg);
   END IF;

   -- get the directory listing 
   l_file_list := get_remote_file_list (p_connection, p_remote_filename);
   
   FOR i IN 1..l_file_list.COUNT
   LOOP
     v_local_file_name := extract_filename(l_file_list(i));
     SELECT COUNT(*) INTO p_counter FROM STATUS_PROCESS_ETL WHERE filename = v_local_file_name AND rownum < 2;
     IF(p_counter= 0 )THEN
      get (p_connection, l_file_list(i), p_local_dir);
      
      --update table STATUS_PROCESS_ETL whith information the xml import.
     
      IF( g_not_valid_measurement <> TRUE ) THEN
     
      INSERT INTO STATUS_PROCESS_ETL VALUES (v_local_file_name,SYSDATE, etl_status,g_type_measurement);
      COMMIT;
      -- file xml load in table
    --  load_file(p_local_dir,v_local_file_name, g_type_measurement);
      
      END IF; 
      
    END IF;
   END LOOP;    
   
END mget;

--------------------------------------------------------------------------------
--  Function      : get_clob
--
--  Description   : Retrieves the remote file and returns it as a CLOB
--------------------------------------------------------------------------------
FUNCTION get_clob    (p_connection       IN NUMBER
                     ,p_remote_filename  IN VARCHAR2)
RETURN CLOB
AS
   l_tcp_response       t_ftp_response;
   l_clob               CLOB;
   l_file_size          NUMBER;
BEGIN
   IF (NOT connection_exists (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_invalid_connection_errno, c_invalid_connection_errmsg);
   ELSIF (NOT connection_open (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_connection_open_errno, c_connection_open_errmsg);
   END IF;
   
   -- get the size of the file we're about to transfer
   l_file_size := get_size (p_connection      => p_connection
                           ,p_remote_filename => p_remote_filename);
   
   -- open the data port to receive the directory listing
   send_passive (p_connection);

   -- send the retrieve command
   send_cmd (p_tcp_response  => l_tcp_response
            ,p_connection    => p_connection
            ,p_cmd           => 'RETR ' || p_remote_filename);
   
   -- retrieve the remote file into the CLOB         
   get_clob (p_clob            => l_clob
            ,p_connection      => p_connection
            ,p_remote_filename => p_remote_filename
            ,p_file_size       => l_file_size);
                                           
   -- now close the data connection
   close_trans_connection (p_connection);

   -- get any remaining response lines after the get operation
   l_tcp_response :=  get_cmd_response (p_connection);
   
   RETURN l_clob;

EXCEPTION
   WHEN OTHERS THEN
      IF (connection_exists (p_connection)) THEN
         -- close the data connection if it's open
         close_trans_connection (p_connection);
         -- get any remaining response lines after the get operation
         IF (connection_open (p_connection)) THEN
            l_tcp_response :=  get_cmd_response (p_connection);
         END IF;
      END IF;
      RAISE;

END get_clob;


--------------------------------------------------------------------------------
--  Function      : get_blob
--
--  Description   : Retrieves the remote file and returns it as a BLOB
--------------------------------------------------------------------------------
FUNCTION get_blob    (p_connection       IN NUMBER
                     ,p_remote_filename  IN VARCHAR2)
RETURN BLOB
AS
   l_tcp_response       t_ftp_response;
   l_blob               BLOB;
   l_file_size          NUMBER;
BEGIN
   IF (NOT connection_exists (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_invalid_connection_errno, c_invalid_connection_errmsg);
   ELSIF (NOT connection_open (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_connection_open_errno, c_connection_open_errmsg);
   END IF;
   
   -- get the size of the file we're about to transfer
   l_file_size := get_size (p_connection      => p_connection
                           ,p_remote_filename => p_remote_filename);
   
   -- open the data port to receive the directory listing
   send_passive (p_connection);

   -- send the retrieve command
   send_cmd (p_tcp_response  => l_tcp_response
            ,p_connection    => p_connection
            ,p_cmd           => 'RETR ' || p_remote_filename);
            
   
   -- retrieve the remote file into the BLOB         
   get_blob (p_blob            => l_blob
            ,p_connection      => p_connection
            ,p_remote_filename => p_remote_filename
            ,p_file_size       => l_file_size);
                                           
   -- now close the data connection
   close_trans_connection (p_connection);

   -- get any remaining response lines after the get operation
   l_tcp_response :=  get_cmd_response (p_connection);
   
   RETURN l_blob;
   
EXCEPTION
   WHEN OTHERS THEN
      IF (connection_exists (p_connection)) THEN
         -- close the data connection if it's open
         close_trans_connection (p_connection);
         -- get any remaining response lines after the get operation
         IF (connection_open (p_connection)) THEN
            l_tcp_response :=  get_cmd_response (p_connection);
         END IF;
      END IF;
      RAISE;

END get_blob;

--------------------------------------------------------------------------------
--  Procedure     : put
--
--  Description   : Sends a file to the remote site
--------------------------------------------------------------------------------
PROCEDURE put    (p_connection       IN NUMBER
                 ,p_local_filename   IN VARCHAR2
                 ,p_local_dir        IN VARCHAR2 DEFAULT NULL
                 ,p_remote_filename  IN VARCHAR2 DEFAULT NULL)
AS
   l_tcp_response       t_ftp_response;
   -- file attributes
   l_file_size          NUMBER;
   l_file_exists        BOOLEAN;
   l_block_size         NUMBER;
BEGIN
   IF (NOT connection_exists (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_invalid_connection_errno, c_invalid_connection_errmsg);
   ELSIF (NOT connection_open (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_connection_open_errno, c_connection_open_errmsg);
   END IF;

   -- get the file size so we can do longops monitoring
   utl_file.fgetattr (location    => NVL (p_local_dir, get_local_dir (p_connection))
                     ,filename    => p_local_filename
                     ,fexists     => l_file_exists
                     ,file_length => l_file_size
                     ,block_size  => l_block_size);
                     
   -- open the data port to receive the directory listing
   send_passive (p_connection);

   -- send the retrieve command
   send_cmd (p_tcp_response  => l_tcp_response
            ,p_connection    => p_connection
            ,p_cmd           => 'STOR ' || NVL(p_remote_filename, p_local_filename));

   -- transfer the file using the mode defined; ascii or binary
   IF (get_trans_mode(p_connection) = c_trans_mode_ascii) THEN
      put_ascii  (p_connection      => p_connection
                 ,p_local_dir       => NVL (p_local_dir, get_local_dir (p_connection))
                 ,p_local_filename  => p_local_filename
                 ,p_local_file_size => l_file_size);
   ELSIF (get_trans_mode(p_connection) = c_trans_mode_binary) THEN
      put_binary (p_connection      => p_connection
                 ,p_local_dir       => NVL (p_local_dir, get_local_dir (p_connection))
                 ,p_local_filename  => p_local_filename
                 ,p_local_file_size => l_file_size);
   END IF;
   
   -- now close the data connection
   close_trans_connection (p_connection);

   -- get any remaining response lines after the get operation
   l_tcp_response :=  get_cmd_response (p_connection);
   
EXCEPTION
   WHEN OTHERS THEN
      IF (connection_exists (p_connection)) THEN
         -- close the data connection if it's open
         close_trans_connection (p_connection);
         -- get any remaining response lines after the get operation
         IF (connection_open (p_connection)) THEN
            l_tcp_response :=  get_cmd_response (p_connection);
         END IF;
      END IF;
      RAISE;
   
END put;


--------------------------------------------------------------------------------
--  Procedure     : put
--
--  Description   : Create a file on the remote site from the content of
--                  a CLOB
--------------------------------------------------------------------------------
PROCEDURE put    (p_connection       IN NUMBER
                 ,p_clob             IN CLOB
                 ,p_remote_filename  IN VARCHAR2)
AS
   l_tcp_response       t_ftp_response;
BEGIN
   IF (NOT connection_exists (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_invalid_connection_errno, c_invalid_connection_errmsg);
   ELSIF (NOT connection_open (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_connection_open_errno, c_connection_open_errmsg);
   END IF;
   
   -- open the data port to receive the directory listing
   send_passive (p_connection);

   -- send the retrieve command
   send_cmd (p_tcp_response  => l_tcp_response
            ,p_connection    => p_connection
            ,p_cmd           => 'STOR ' || p_remote_filename);

   -- send the CLOB to the remote site
   put_ascii (p_connection      => p_connection
             ,p_clob            => p_clob
             ,p_clob_size       => dbms_lob.getlength(p_clob));
                                           
   -- now close the data connection
   close_trans_connection (p_connection);

   -- get any remaining response lines after the get operation
   l_tcp_response :=  get_cmd_response (p_connection);
   
EXCEPTION
   WHEN OTHERS THEN
      IF (connection_exists (p_connection)) THEN
         -- close the data connection if it's open
         close_trans_connection (p_connection);
         -- get any remaining response lines after the get operation
         IF (connection_open (p_connection)) THEN
            l_tcp_response :=  get_cmd_response (p_connection);
         END IF;
      END IF;
      RAISE;
   
END put;

--------------------------------------------------------------------------------
--  Procedure     : put
--
--  Description   : Create a file on the remote site from the content of
--                  a BLOB
--------------------------------------------------------------------------------
PROCEDURE put    (p_connection       IN NUMBER
                 ,p_blob             IN BLOB
                 ,p_remote_filename  IN VARCHAR2)
AS
   l_tcp_response       t_ftp_response;
BEGIN
   IF (NOT connection_exists (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_invalid_connection_errno, c_invalid_connection_errmsg);
   ELSIF (NOT connection_open (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_connection_open_errno, c_connection_open_errmsg);
   END IF;
   
   -- open the data port to receive the directory listing
   send_passive (p_connection);

   -- send the retrieve command
   send_cmd (p_tcp_response  => l_tcp_response
            ,p_connection    => p_connection
            ,p_cmd           => 'STOR ' || p_remote_filename);

   -- send the blob to the remote site
   put_binary (p_connection      => p_connection
              ,p_blob            => p_blob
              ,p_blob_size       => dbms_lob.getlength(p_blob));
                                           
   -- now close the data connection
   close_trans_connection (p_connection);

   -- get any remaining response lines after the get operation
   l_tcp_response :=  get_cmd_response (p_connection);
   
EXCEPTION
   WHEN OTHERS THEN
      IF (connection_exists (p_connection)) THEN
         -- close the data connection if it's open
         close_trans_connection (p_connection);
         -- get any remaining response lines after the get operation
         IF (connection_open (p_connection)) THEN
            l_tcp_response :=  get_cmd_response (p_connection);
         END IF;
      END IF;
      RAISE;
   
END put;

--------------------------------------------------------------------------------
--  Procedure     : put
--
--  Description   : Create a file on the remote site from the content of
--                  a REF CURSOR
--
--                  The 11g version of this routine uses pkg_csv to output the
--                  cursor content in CSV format. Options for configuring the
--                  output can be made by calling the pkg_csv routines prior
--                  to calling this one
--------------------------------------------------------------------------------
/**PROCEDURE put    (p_connection       IN     NUMBER
                 ,p_cursor           IN OUT SYS_REFCURSOR
                 ,p_remote_filename  IN     VARCHAR2
                 ,p_column_headers   IN     BOOLEAN DEFAULT TRUE)
AS
   c_longops_updt_freq  CONSTANT NUMBER := 10;
   l_tcp_response       t_ftp_response;
   l_cursor_line        t_text_buffer;
   l_num_chars          NUMBER;
   l_csv_handle         NUMBER; -- the csv handle from pkg_csv
   l_more_data          BOOLEAN := TRUE; -- use to denote when we've processed the cursor
   -- longops variables
   l_rindex             BINARY_INTEGER := dbms_application_info.set_session_longops_nohint;
   l_slno               BINARY_INTEGER;
   l_sofar              NUMBER := 0;
   l_totalwork          NUMBER := NULL; -- we don't know how much work
   l_row_count          NUMBER := 0;
BEGIN
   IF (NOT connection_exists (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_invalid_connection_errno, c_invalid_connection_errmsg);
   ELSIF (NOT connection_open (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_connection_open_errno, c_connection_open_errmsg);
   END IF;
   
   -- open the data port to receive the directory listing
   send_passive (p_connection);

   -- send the retrieve command
   send_cmd (p_tcp_response  => l_tcp_response
            ,p_connection    => p_connection
            ,p_cmd           => 'STOR ' || p_remote_filename);

   -- start longops monitoring
   dbms_application_info.set_session_longops
     (rindex      => l_rindex
     ,slno        => l_slno
     ,op_name     => 'FTP put'
     ,target      => 0
     ,context     => 0
     ,sofar       => l_sofar
     ,totalwork   => l_totalwork
     ,target_desc => p_remote_filename
     ,units       => 'rows'); 
     
   -- obtain the cursor handle from pkg_csv
   l_csv_handle := pkg_csv.open_handle (p_cursor);
   
   -- output the column headers, if required
   IF (p_column_headers) THEN
      l_cursor_line := pkg_csv.get_headers (l_csv_handle);
      l_num_chars := utl_tcp.write_line (g_ftp_conn_tab(p_connection).trans_conn
                                        ,l_cursor_line);
   END IF;
   

   -- simply loop through the cursor, writing each entry to the
   -- remote file
   WHILE (l_more_data)
   LOOP
   
      -- pkg_csv.get_csv_line raises NO_DATA_FOUND when we run out of data
      -- so create a block to handle this situation
      BEGIN
   
         l_cursor_line := pkg_csv.get_line (l_csv_handle);
   
         -- keep track of how far through the file we've processed
         l_sofar := l_sofar +1;
   
         -- only update longops every c_longops_updt_freq rows
         -- rather than every row, which would be excessive
         IF (l_row_count >= c_longops_updt_freq) THEN
            -- update the longops
            dbms_application_info.set_session_longops
              (rindex      => l_rindex
              ,slno        => l_slno
              ,totalwork   => l_totalwork
              ,sofar       => l_sofar); 
            -- reset the line counter
            l_row_count := 0;
         ELSE
            l_row_count := l_row_count + 1;
         END IF;

         l_num_chars := utl_tcp.write_line (g_ftp_conn_tab(p_connection).trans_conn
                                           ,l_cursor_line);

      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            l_more_data := FALSE;
      END;
   END LOOP;
                                           
   -- now close the data connection
   close_trans_connection (p_connection);

   -- get any remaining response lines after the get operation
   l_tcp_response :=  get_cmd_response (p_connection);
   
EXCEPTION
   WHEN OTHERS THEN
      IF (connection_exists (p_connection)) THEN
         -- close the data connection if it's open
         close_trans_connection (p_connection);
         -- get any remaining response lines after the get operation
         IF (connection_open (p_connection)) THEN
            l_tcp_response :=  get_cmd_response (p_connection);
         END IF;
      END IF;
      RAISE;
   
END put; **/

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
                 ,p_column_headers   IN     BOOLEAN DEFAULT TRUE)
AS
   l_connection         NUMBER;
BEGIN
   
   -- create a new FTP connection
   l_connection := create_connection (p_site        => p_site
                                     ,p_port        => p_port
                                     ,p_username    => p_username
                                     ,p_password    => p_password);
                                     
   -- open the FTP connection 
   open_connection (l_connection);
   
   -- set the transfer mode to ASCII
   ascii (l_connection);
   
   -- now call the previous proc to do the actual legwork
   put (p_connection       => l_connection
       ,p_cursor           => p_cursor
       ,p_remote_filename  => p_remote_filename
       ,p_column_headers   => p_column_headers);

   -- close and remote the FTP connection
   delete_connection (l_connection);
   
EXCEPTION
   WHEN OTHERS THEN
      IF (connection_exists (l_connection)) THEN
         -- close and remote the FTP connection
         delete_connection (l_connection);
      END IF;
      RAISE;
   
END put; **/

--------------------------------------------------------------------------------
--  Procedure     : delete
--
--  Description   : Deletes the specified remote file
--------------------------------------------------------------------------------
PROCEDURE delete    (p_connection       IN NUMBER
                    ,p_remote_filename  IN VARCHAR2)
AS
   l_tcp_response t_ftp_response;
BEGIN
   IF (NOT connection_exists (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_invalid_connection_errno, c_invalid_connection_errmsg);
   ELSIF (NOT connection_open (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_connection_open_errno, c_connection_open_errmsg);
   END IF;

   send_cmd (p_tcp_response  => l_tcp_response
            ,p_connection    => p_connection
            ,p_cmd           => 'DELE ' || p_remote_filename);
END delete;

--------------------------------------------------------------------------------
--  Procedure     : rename
--
--  Description   : Renames the specified remote file to a new name
--------------------------------------------------------------------------------
PROCEDURE rename    (p_connection           IN NUMBER
                    ,p_old_remote_filename  IN VARCHAR2
                    ,p_new_remote_filename  IN VARCHAR2)
AS
   l_tcp_response t_ftp_response;
BEGIN
   IF (NOT connection_exists (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_invalid_connection_errno, c_invalid_connection_errmsg);
   ELSIF (NOT connection_open (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_connection_open_errno, c_connection_open_errmsg);
   END IF;

   send_cmd (p_tcp_response  => l_tcp_response
            ,p_connection    => p_connection
            ,p_cmd           => 'RNFR ' || p_old_remote_filename);
   send_cmd (p_tcp_response  => l_tcp_response
            ,p_connection    => p_connection
            ,p_cmd           => 'RNTO ' || p_new_remote_filename);
END rename;

--------------------------------------------------------------------------------
--  Procedure     : mkdir
--
--  Description   : Creates the specified remote directory
--------------------------------------------------------------------------------
PROCEDURE mkdir     (p_connection       IN NUMBER
                    ,p_remote_dir       IN VARCHAR2)
AS
   l_tcp_response t_ftp_response;
BEGIN
   IF (NOT connection_exists (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_invalid_connection_errno, c_invalid_connection_errmsg);
   ELSIF (NOT connection_open (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_connection_open_errno, c_connection_open_errmsg);
   END IF;

   send_cmd (p_tcp_response  => l_tcp_response
            ,p_connection    => p_connection
            ,p_cmd           => 'MKD ' || p_remote_dir);
END mkdir;

--------------------------------------------------------------------------------
--  Procedure     : rmdir
--
--  Description   : Removes the specified remote directory
--------------------------------------------------------------------------------
PROCEDURE rmdir     (p_connection       IN NUMBER
                    ,p_remote_dir       IN VARCHAR2)
AS
   l_tcp_response t_ftp_response;
BEGIN
   IF (NOT connection_exists (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_invalid_connection_errno, c_invalid_connection_errmsg);
   ELSIF (NOT connection_open (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_connection_open_errno, c_connection_open_errmsg);
   END IF;

   send_cmd (p_tcp_response  => l_tcp_response
            ,p_connection    => p_connection
            ,p_cmd           => 'RMD ' || p_remote_dir);
END rmdir;

--------------------------------------------------------------------------------
--  Function      : get_size
--
--  Description   : Returns the size of the remote file
--------------------------------------------------------------------------------
FUNCTION  get_size  (p_connection       IN NUMBER
                    ,p_remote_filename  IN VARCHAR2)
RETURN NUMBER
AS
   l_tcp_response       t_ftp_response;
   l_file_size          NUMBER;
   l_current_trans_mode VARCHAR2(6);
BEGIN
   IF (NOT connection_exists (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_invalid_connection_errno, c_invalid_connection_errmsg);
   ELSIF (NOT connection_open (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_connection_open_errno, c_connection_open_errmsg);
   END IF;
   
   -- get the current transfer mode and change it to BINARY if it's not
   -- already that. It seems some FTP servers insist on being in BINARY
   -- mode to execute the SIZE command
   l_current_trans_mode := get_trans_mode (p_connection);
   IF (l_current_trans_mode = c_trans_mode_ascii) THEN
      binary (p_connection);
   END IF;

   -- send the size command
   send_cmd (p_tcp_response  => l_tcp_response
            ,p_connection    => p_connection
            ,p_cmd           => 'SIZE ' || p_remote_filename);

   -- if we get back a response code of 213 then convert the
   -- remainder of the line to a number as it should be
   -- the file size
   IF (l_tcp_response.response_code = c_ftp_file_status) THEN
      -- block to catch conversion errors
      BEGIN
         l_file_size := TO_NUMBER(SUBSTR(l_tcp_response.response_lines_tab(1),4));
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR (c_operation_failed_errno
                                    ,'Failed to convert response to file size. Response returned was ''' || SUBSTR(l_tcp_response.response_lines_tab(1),4) || '''');
      END;
   ELSE
      RAISE_APPLICATION_ERROR (c_operation_failed_errno, c_operation_failed_errmsg);
   END IF;

   -- restore the tranfer mode if we changed it to BINARY   
   IF (l_current_trans_mode = c_trans_mode_ascii) THEN
      ascii (p_connection);
   END IF;

   RETURN l_file_size;
   
END get_size;

--------------------------------------------------------------------------------
--  Function      : get_mod_time
--
--  Description   : Returns the last modification time of the remote file
--------------------------------------------------------------------------------
FUNCTION  get_mod_time  (p_connection       IN NUMBER
                        ,p_remote_filename  IN VARCHAR2)
RETURN TIMESTAMP WITH TIME ZONE
AS
   l_tcp_response       t_ftp_response;
   l_mod_time           TIMESTAMP WITH TIME ZONE;
BEGIN
   IF (NOT connection_exists (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_invalid_connection_errno, c_invalid_connection_errmsg);
   ELSIF (NOT connection_open (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_connection_open_errno, c_connection_open_errmsg);
   END IF;

   -- send the size command
   send_cmd (p_tcp_response  => l_tcp_response
            ,p_connection    => p_connection
            ,p_cmd           => 'MDTM ' || p_remote_filename);

   -- if we get back a response code of 213 then convert the
   -- remainder of the line to a number as it should be
   -- the file size
   IF (l_tcp_response.response_code = c_ftp_file_status) THEN
      -- block to catch various conversion errors
      BEGIN
         l_mod_time := TO_TIMESTAMP_TZ(TRIM(SUBSTR(l_tcp_response.response_lines_tab(1),4))|| ' 00:00',c_mod_time_format);
      EXCEPTION
         WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR (c_operation_failed_errno
                                   ,'Failed to convert response to modifcation date. Response returned was ''' || SUBSTR(l_tcp_response.response_lines_tab(1),4) || '''');      
      END;
   ELSE
      RAISE_APPLICATION_ERROR (c_operation_failed_errno, c_operation_failed_errmsg);
   END IF;
   
   RETURN l_mod_time;
   
END get_mod_time;

--------------------------------------------------------------------------------
--  Procedure     : open_connection
--
--  Description   : Opens the connection specified
--------------------------------------------------------------------------------
PROCEDURE open_connection (p_connection       IN NUMBER)
AS
   l_tcp_response t_ftp_response;
   ex_connection_failed  EXCEPTION;
   PRAGMA EXCEPTION_INIT (ex_connection_failed, -29260);
BEGIN

   IF (connection_open (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_connection_open_errno, c_connection_open_errmsg);
   END IF;

   g_ftp_conn_tab(p_connection).cmd_conn := utl_tcp.open_connection (remote_host      => get_site (p_connection)
                                                                    ,remote_port      => get_port (p_connection)
                                                                    ,local_host       => NULL
                                                                    ,local_port       => NULL
                                                                    ,in_buffer_size   => get_in_buffer_size (p_connection)
                                                                    ,out_buffer_size  => get_out_buffer_size (p_connection)
                                                                    ,charset          => get_charset (p_connection)
                                                                    ,newline          => get_newline (p_connection)
                                                                    ,tx_timeout       => get_tx_timeout (p_connection));
   
   IF (connection_open (p_connection)) THEN
      add_log (p_connection  => p_connection
              ,p_text        => 'Opened connection: ' || get_site(p_connection) || ':' || TO_CHAR(get_port(p_connection)));
             
      -- get any remaining response lines after the get operation
      l_tcp_response :=  get_cmd_response (p_connection);
  
      -- log in using the credientials supplied
      IF (get_last_response_code (p_connection) = c_ftp_user_required) THEN
         send_username (p_connection);
         -- send a password if one was requested
         IF (get_last_response_code (p_connection) = c_ftp_pwd_required) THEN
            send_password (p_connection);
         END IF;
      END IF;
      -- get the current directory
      send_pwd (p_connection);
      -- get the features supported by the remote site
      -- ToDo: is this worthwhile?
      -- sent_feat     (p_connection);
      
   ELSE
      RAISE_APPLICATION_ERROR (c_operation_failed_errno, c_operation_failed_errmsg);
   END IF;
   
EXCEPTION
   WHEN ex_connection_failed THEN
      add_log (p_connection  => p_connection
              ,p_text        => 'Failed to open connection: ' || get_site(p_connection) || ':' || TO_CHAR(get_port(p_connection)));
      RAISE_APPLICATION_ERROR (c_connection_failed_errno, 'Failed to open a connection to ' || get_site (p_connection));
   
END open_connection;

--------------------------------------------------------------------------------
--  Procedure     : close_connection
--
--  Description   : Closes a previously opened connection. Does nothing if the 
--                  connection is already closed
--------------------------------------------------------------------------------
PROCEDURE close_connection (p_connection       IN NUMBER)
AS
   l_tcp_response t_ftp_response;
BEGIN

   -- close the connection
   IF (NOT connection_exists (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_invalid_connection_errno, c_invalid_connection_errmsg);
   END IF;
   
   -- only do something if the connection is open
   IF (connection_open (p_connection)) THEN
   
      -- first close the transfer connection if it's open
      close_trans_connection (p_connection);
      
      -- then send the QUIT command to the remote server
      send_cmd (p_tcp_response  => l_tcp_response
               ,p_connection    => p_connection
               ,p_cmd           => 'QUIT');
   
      utl_tcp.close_connection(g_ftp_conn_tab(p_connection).cmd_conn);
   
   
      add_log (p_connection  => p_connection
              ,p_text        => 'Closed connection: ' || get_site(p_connection) || ':' || TO_CHAR(get_port(p_connection)));
              
   END IF;
   
END close_connection;

--------------------------------------------------------------------------------
--  Procedure     : close_all_connections
--
--  Description   : Closes all previously opened connections.
--------------------------------------------------------------------------------
PROCEDURE close_all_connections
AS
   l_connection  NUMBER;
BEGIN

   IF (g_ftp_conn_tab.COUNT > 0) THEN
      l_connection := g_ftp_conn_tab.FIRST;
      -- loop through the connection collection and close each
      -- in turn. this cannot be done using a simple FOR loop
      -- since the collection may be sparse
      LOOP
         close_connection (l_connection);
         l_connection := g_ftp_conn_tab.NEXT(l_connection);
         EXIT WHEN l_connection IS NULL;
      END LOOP;
   END IF;
   
END close_all_connections;

--------------------------------------------------------------------------------
--  Procedure     : delete_connection
--
--  Description   : Completely removes a connection. If the connection is open
--                  then it is closed first.
--------------------------------------------------------------------------------
PROCEDURE delete_connection (p_connection       IN NUMBER)
AS
BEGIN

   IF (NOT connection_exists (p_connection)) THEN
      RAISE_APPLICATION_ERROR (c_invalid_connection_errno, c_invalid_connection_errmsg);
   END IF;
   
   -- close the connection if it's still open
   close_connection (p_connection);

   -- now simply remove the entry from the connection collection   
   g_ftp_conn_tab.DELETE(p_connection);
   
END delete_connection;

--------------------------------------------------------------------------------
--  Procedure     : delete_all_connections
--
--  Description   : Completely removes all declared connections.
--------------------------------------------------------------------------------
PROCEDURE delete_all_connections
AS
   l_connection  NUMBER;
BEGIN

   IF (g_ftp_conn_tab.COUNT > 0) THEN
      l_connection := g_ftp_conn_tab.FIRST;
      -- loop through the connection collection and close each
      -- in turn. this cannot be done using a simple FOR loop
      -- since the collection may be sparse
      LOOP
         delete_connection (l_connection);
         l_connection := g_ftp_conn_tab.NEXT(l_connection);
         EXIT WHEN l_connection IS NULL;
      END LOOP;
   END IF;
   
END delete_all_connections;

--------------------------------------------------------------------------------
--  Function      : connection_exists
--
--  Description   : Returns TRUE if the connection identifier exists. NOTE:
--                  the connection may not actually be open though
--------------------------------------------------------------------------------
FUNCTION connection_exists (p_connection       IN NUMBER)
RETURN BOOLEAN
AS
BEGIN
   RETURN g_ftp_conn_tab.EXISTS(p_connection);
END connection_exists;

--------------------------------------------------------------------------------
--  Function      : connection_open
--
--  Description   : Returns TRUE if the connection identifier exists and is
--                  open to the remote site
--------------------------------------------------------------------------------
FUNCTION connection_open (p_connection       IN NUMBER)
RETURN BOOLEAN
AS
   l_return_value BOOLEAN;
BEGIN

   IF NOT (connection_exists (p_connection)) THEN
      l_return_value := FALSE;
   ELSE
      l_return_value := g_ftp_conn_tab(p_connection).cmd_conn.remote_host IS NOT NULL;
   END IF;
   
   RETURN l_return_value;
   
END connection_open;

--------------------------------------------------------------------------------
--  Function      : is_valid_measurement
--
--  Description   : Returns TRUE if measurement is valid and FALSE if not valid 
--------------------------------------------------------------------------------
FUNCTION is_valid_measurement(v_type_measurement IN VARCHAR2) 
 RETURN BOOLEAN
AS
  valid_return BOOLEAN;
BEGIN 
  CASE trim(v_type_measurement)
    WHEN '<PMTarget  measurementType="Mobility_Management">' THEN
      valid_return:=TRUE;
    
    WHEN '<PMTarget  measurementType="Session_Management">' THEN
      valid_return:=TRUE;
    
    WHEN '<PMTarget  measurementType="MMDU_User_Level">' THEN
     valid_return:=TRUE;
    
    WHEN '<PMTarget  measurementType="User_MME_Level">' THEN
     valid_return:=TRUE;
    
    WHEN '<PMTarget  measurementType="SGsAP">' THEN
     valid_return:=TRUE;
    
    WHEN '<PMTarget  measurementType="ULOAD">' THEN
      valid_return:=TRUE;
    
    WHEN '<PMTarget  measurementType="LTE_Cell_Throughput">' THEN
     valid_return:=TRUE;
    
    WHEN '<PMTarget  measurementType="LTE_S1AP">' THEN
      valid_return:=TRUE;
    
    WHEN '<PMTarget  measurementType="LTE_UE_State">' THEN
      valid_return:=TRUE;
    
    WHEN '<PMTarget  measurementType="LTE_Cell_Load">' THEN
     valid_return:=TRUE;
      
    WHEN '<PMTarget  measurementType="LTE_Pwr_and_Qual_DL">' THEN
      valid_return:=TRUE;  
      
    WHEN '<PMTarget  measurementType="LTE_EPS_Bearer">' THEN
    valid_return:=TRUE;
    
    WHEN '<PMTarget  measurementType="LTE_Pwr_and_Qual_UL">' THEN
    valid_return:=TRUE; 
    
    WHEN '<PMTarget  measurementType="LTE_Cell_Avail">' THEN
    valid_return:=TRUE;
    
    WHEN '<PMTarget  measurementType="LTE_Radio_Bearer">' THEN
    valid_return:=TRUE;
    
    WHEN '<PMTarget  measurementType="LTE_Cell_Resource">' THEN
    valid_return:=TRUE;
    
    WHEN '<PMTarget  measurementType="LTE_RRC">' THEN
    valid_return:=TRUE;
    
    WHEN '<PMTarget  measurementType="LTE_Handover">' THEN
    valid_return:=TRUE;
    
    ELSE valid_return:=FALSE; 
                                                         
  END CASE;
  RETURN valid_return;
END is_valid_measurement;
--------------------------------------------------------------------------------
-- Package initialisation section
BEGIN

   -- simply call the initialisation routine
   initialise;

END com_util_ftp;

/
