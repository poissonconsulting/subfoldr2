#' Open PostgreSQL Connection
#' 
#' Connect to a PostgreSQL database with a config.yml file.
#' 
#' @inheritParams psql::psql_connect
#' @return
#' @export
#' @details Wrapper on `psql::psql_connect()`
#'
#' @examples
#' \dontrun{
#' conn <- sbf_open_pg()
#' sbf_close_pg(conn)
#'
#' sbf_open_pg("config.yml")
#' sbf_close_pg(conn)
#'
#' sbf_open_pg(config_path = "config.yml", config_value = "database")
#' sbf_close_pg(conn)
#' }
sbf_open_pg <- function(config_path = getOption("psql.config_path", NULL),
                        config_value = getOption("psql.value", NULL)) {
  con <- psql:::psql_connect(
    config_path = config_path, 
    config_value = config_value
  )
  con
}

#' Close PostgreSQL Connection
#' 
#' Close the PostgreSQL connection when you are done using a database. 
#'
#' @param conn 
#'
#' @return TRUE (or errors).
#' @export
#' @details Wrapper on `DBI::dbDisconnect()`. It is important to remember to 
#' close connections or your database performance can decrease over time. 
#'
#' @examples
#' \dontrun{
#' conn <- sbf_open_pg()
#' sbf_close_pg(conn)
#' }
sbf_close_pg <- function(conn) {
  DBI::dbDisconnect(conn = conn)
  TRUE
}

#' Save PostgreSQL backup
#'
#' Save a copy of your database in a plain text format. This saves all the SQL
#' code to recreate the structure and data.
#'
#' @inheritParams psql::psql_backup
#'
#' @return TRUE (or errors)
#' @export
#' @details Wrapper on `psql::psql_backup()`
#'
#' @examples
#' \dontrun{
#' sbf_save_pg("/Users/user1/Dumps/dump_db.sql")
#' }
sbf_save_pg <- function(
    path = "dump_db.sql",
    config_path = getOption("psql.config_path", NULL),
    config_value = getOption("psql.value", NULL)
  ) {
  psql::psql_backup(
    path = path,
    config_path = config_path, 
    config_value = config_value
  )
}

#' Create PostgreSQL database
#'
#' Create a new PostgreSQL database.
#'
#' @inheritParams psql::psql_create_db
#'
#' @return TRUE (or errors).
#' @export
#' @details Wrapper on `psql::psql_create_db()`
#'
#' @examples
sbf_create_pg <- function(
    dbname,
    config_path = getOption("psql.config_path", NULL),
    config_value = getOption("psql.value", NULL)  
  ) {
  psql::psql_createdb(
    dbname = dbname,
    config_path = config_path,
    config_value = config_value
  )
}

#' Execute SQL statement for PostgreSQL database
#'
#' Execute PostgreSQL statements.
#'
#' @inheritParams psql::psql_execute_db
#'
#' @return A scalar numeric of the number of rows affected by the statement.
#' @export
#' @details Wrapper on `psql::psql_execute_db()`
#'
#' @examples
#' \dontrun{
#' sbf_execute_pg(
#'   "CREATE SCHEMA boat_count"
#' )
#' sbf_execute_pg(
#'   "CREATE TABLE boat_count.input (
#'   file_name TEXT NOT NULL,
#'   comment TEXT)"
#' )
#' }
sbf_execute_pg <- function(
    sql,
    config_path = getOption("psql.config_path", NULL),
    config_value = getOption("psql.value", NULL)
  ) {
  psql::psql_execute_db(
    sql = sql,
    config_path = config_path,
    config_value = config_value
  )
}







#' Load Data Frames from PostgreSQL Database
#' 
#' Load all the tables in a schema as data frames into your environment from a 
#'  PostgreSQL database.
#'
#' @inheritParams sbf_load_objects
#' @inheritParams psql::psql_list_tables
#' @return An invisible character vector of the paths to the saved objects.
#' @family load functions
#' @family postgresql functions
#' @export
sbf_load_datas_from_psql <- function(schema = "public",
                                     rename = identity,
                                     env = parent.frame(),
                                     config_path = getOption("psql.config_path", NULL),
                                     config_value = getOption("psql.value", NULL)) {
  chk_s3_class(env, "environment")
  chk_function(rename)
  
  tbl_names <- psql::psql_list_tables(
    schema = schema, 
    config_path = config_path,
    config_value = config_value
  )
  
  datas <- lapply(
    tbl_names, 
    psql::psql_read_table, 
    schema = schema, 
    config_path = config_path,
    config_value = config_value
  )
  
  names(datas) <- tbl_names
  names(datas) <- rename(names(datas))
  
  mapply(assign, names(datas), datas, MoreArgs = list(envir = env))
  invisible(names(datas))
}







