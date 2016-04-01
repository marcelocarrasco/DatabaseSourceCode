--------------------------------------------------------
--  DDL for Package PKG_ERROR_LOG_NEW
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "HARRIAGUE"."PKG_ERROR_LOG_NEW" AS
/**
* Author: Carrasco Marcelo
* Date: 14/03/2016
* Comment: Paquete para conter la funcionalidad asociada a la tabla error_log_new
*/
  procedure P_LOG_ERROR(P_OBJETO in varchar,
                        P_SQL_CODE IN NUMBER,
                        P_SQL_ERRM IN VARCHAR2,
                        P_COMENTARIO IN VARCHAR2);
  /**
  * Comment: Procedimiento para limpiar los datos de la tabla hasta una fecha determinada
  * Param: P_FECHA VARCHAR2 (dd.mm.yyyy) indica la fecha hasta la que se pretende eliminar filas incluida la fecha,
  *                                      pasada como parámetro en caso de no ser especificada, utiliza (sysdate - 1)             
  */                      
  PROCEDURE clean_up (p_fecha IN VARCHAR2 DEFAULT SYSDATE);
end pkg_error_log_new;

/
