#' Open PostgreSQL Connection
#' 
#' Connect to a PostgreSQL database with a config.yml file.
#' 
#' @inheritParams psql::psql_connect
#' @return An S4 object that inherits from DBIConnection.
#' @export
#' @details Wrapper on `psql::psql_connect()`
#' @family postgresql functions
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
  conn <- psql::psql_connect(
    config_path = config_path, 
    config_value = config_value
  )
  conn
}

#' Close PostgreSQL Connection
#' 
#' Close the PostgreSQL connection when you are done using a database. 
#'
#' @inheritParams DBI::dbDisconnect
#'
#' @return TRUE (or errors).
#' @export
#' @details Wrapper on `DBI::dbDisconnect()`. It is important to remember to 
#' close connections or your database performance can decrease over time. 
#' @family postgresql functions
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
#' @family postgresql functions
#'
#' @examples
#' \dontrun{
#' sbf_save_pg("/Users/user1/Dumps/dump_db.sql")
#' }
sbf_save_pg <- function(path = "dump_db.sql",
                        config_path = getOption("psql.config_path", NULL),
                        config_value = getOption("psql.value", NULL)) {
  psql::psql_backup(path = path,
                    config_path = config_path,
                    config_value = config_value)
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
#' @family postgresql functions
#'
#' @examples
#' \dontrun{
#' sbf_create_pg("new_database")
#' sbf_create_pg("new_database", config_path = "keys/config.yml")
#' }
sbf_create_pg <- function(dbname,
                          config_path = getOption("psql.config_path", NULL),
                          config_value = getOption("psql.value", NULL)) {
  psql::psql_create_db(dbname = dbname,
                       config_path = config_path,
                       config_value = config_value)
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
#' @family postgresql functions
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
sbf_execute_pg <- function(sql,
                           config_path = getOption("psql.config_path", NULL),
                           config_value = getOption("psql.value", NULL)) {
  psql::psql_execute_db(sql = sql,
                        config_path = config_path,
                        config_value = config_value)
}

#' List tables in a schema
#'
#' This function lists all the tables in a schema.
#'
#' @inheritParams psql::psql_list_tables
#'
#' @return A vector of table names
#' @export
#' @details Wrapper on `psql::psql_list_tables()`
#' @family postgresql functions
#'
#' @examples
#' \dontrun{
#' sbf_list_tables_pg(
#'   "boat_count"
#' )
#' sbf_list_tables_pg()
#' }
sbf_list_tables_pg <- function(schema = getOption("psql.schema", "public"),
                               config_path = getOption("psql.config_path", NULL),
                               config_value = getOption("psql.value", NULL)) {
  psql::psql_list_tables(schema = schema,
                         config_path = config_path,
                         config_value = config_value)
}

#' Load a table from a PostgreSQL database
#'
#' Read/load a table from a PostgreSQL database as a data frame into R.
#'
#' @inheritParams psql::psql_read_table
#'
#' @return A data frame
#' @export
#' @details Wrapper on `psql::psql_read_table()`
#' @family postgresql functions
#'
#' @examples
#' \dontrun{
#' sbf_load_data_from_pg("capture")
#' sbf_load_data_from_pg("counts", "boat_count")
#' }
sbf_load_data_from_pg <- function(tbl_name,
                                  schema = getOption("psql.schema", "public"),
                                  config_path = getOption("psql.config_path", NULL),
                                  config_value = getOption("psql.value", NULL)) {
  psql::psql_read_table(
    tbl_name = tbl_name,
    schema = schema,
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
#' @export
#' @family postgresql functions
#' @family load functions
#' 
#' @examples
#' \dontrun{
#' sbf_load_datas_from_pg()
#' sbf_load_datas_from_pg(schema = "capture")
#' sbf_load_datas_from_pg(rename = toupper)
#' }
sbf_load_datas_from_pg <- function(schema = getOption("psql.schema", "public"),
                                   rename = identity,
                                   env = parent.frame(),
                                   config_path = getOption("psql.config_path", NULL),
                                   config_value = getOption("psql.value", NULL)) {
  chk_s3_class(env, "environment")
  chk_function(rename)
  
  tbl_names <- psql::psql_list_tables(schema = schema,
                                      config_path = config_path,
                                      config_value = config_value)
  
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

#' Add data frame to PostgreSQL database
#'
#' Add data with a data frame to your PostgreSQL database. The data frame name
#' must match the table name in your database, if not use the `tbl_name`
#' argument to pass the table name.
#'
#' @inheritParams psql::psql_add_data
#' @inheritParams sbf_save_data
#'
#' @return A scalar numeric.
#' @export
#' @details Wrapper on `psql::psql_add_data()`
#' @family postgresql functions
#' @family save functions
#'
#' @examples
#' \dontrun{
#' sbf_save_data_to_pg(outing, "creel")
#' sbf_save_data_to_pg(outing_new, "creel", "outing")
#' }
sbf_save_data_to_pg <- function(x,
                                schema = getOption("psql.schema", "public"),
                                x_name = NULL,
                                config_path = getOption("psql.config_path", NULL),
                                config_value = getOption("psql.value", NULL)) {
  psql::psql_add_data(
    tbl = x,
    schema = schema,
    tbl_name = x_name,
    config_path = config_path,
    config_value = config_value
  )
}

#' Set Schema Name
#'
#' @param schema A string of the schema name. Default value is `"public"`.
#'
#' @return An invisible schema name 
#' @export
#' @family postgresql functions
#'
#' @examples
#' \dontrun{
#' sbf_set_schema("capture")
#' }
sbf_set_schema <- function(schema = "public") {
  chk::chk_string(schema)
  options(psql.schema = schema)
  invisible(schema)
}

#' Get Schema Name
#'
#' @return A string of the schema name. 
#' @export
#' @family postgresql functions
#'
#' @examples
#' \dontrun{
#' sbf_get_schema()
#' }
sbf_get_schema <- function() {
  getOption("psql.schema", character(0))
}

#' Reset Schema Name
#' 
#' Reset schema name back to public
#'
#' @return An invisible string of the schema name the database is set to
#' @export
#' @family postgresql functions
#'
#' @examples
#' \dontrun{
#' sbf_reset_schema()
#' }
sbf_reset_schema <- function() {
  invisible(sbf_set_schema(schema = "public"))
}

#' Set the Config File path
#' 
#' A wrapper to quickly set the `psql.config_path` options parameter.
#'
#' @param path 
#'
#' @return An invisible string of the file path given
#' @export
#' @details This function is recommended to be added to your header when used.
#' @family postgresql functions
#'
#' @examples
#' \dontrun{
#' sbf_set_config_file()
#' sbf_set_config_file("Keys/config-captures.yml")
#' }
sbf_set_config_file <- function(path = "config.yml") {
  chk::chk_string(path)
  options(psql.config_path = path)
  invisible(path)
}

#' Get the Config File Path
#' 
#' Get the option set for psql.config_path
#'
#' @return A string of the config file path. 
#' @export
#' @family postgresql functions
#'
#' @examples
#' \dontrun{
#' sbf_get_config_file()
#' }
sbf_get_config_file <- function() {
  getOption("psql.config_path", character(0))
}

#' Reset the Config File Path
#' 
#' Reset the psql.config_path option to the default value.
#'
#' @return An invisible string of the default file path
#' @export
#' @family postgresql functions
#'
#' @examples
#' \dontrun{
#' sbf_reset_config_file()
#' }
sbf_reset_config_file <- function() {
  invisible(sbf_set_config_file(path = "config.yml"))
}

#' Set the Config Value
#' 
#' Wrapper for setting the `psql.config_value` options parameter.
#'
#' @param value A string of the config file value to grab.
#'
#' @return An invisible string of the value given
#' @export
#' @details This function is recommended to be added to your header when used.
#' @family postgresql functions
#'
#' @examples
#' \dontrun{
#' sbf_set_config_value("shinyapp")
#' }
sbf_set_config_value <- function(value = NULL) {
  chk::chk_null_or(value, vld = chk::vld_string)
  options(psql.config_value = value)
  invisible(value)
}

#' Get the Config File Value
#' 
#' Get the value set for the `psql.config_value` options parameter.
#'
#' @return A string of the config file value
#' @export
#' @family postgresql functions
#'
#' @examples
#' \dontrun{
#' sbf_get_config_value()
#' }
sbf_get_config_value <- function() {
  getOption("psql.config_value", character(0))
}

#' Reset the Config File Value
#' 
#' Reset the value for `psql.config_value` to the default value.
#'
#' @return An invisible string of the default file path
#' @export
#' @family postgresql functions
#'
#' @examples
#' \dontrun{
#' sbf_reset_config_value()
#' }
sbf_reset_config_value <- function() {
  invisible(sbf_set_config_value(value = NULL)) 
}