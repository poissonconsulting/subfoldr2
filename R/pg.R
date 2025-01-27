#' Open PostgreSQL Connection
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' `sbf_open_pg()` was moved to `subfoldr2ext::sbfx_open_pg()`.
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
                        config_value = getOption("psql.config_value", "default")) {
  lifecycle::deprecate_stop(
    "0.2.0",
    "sbf_open_pg()",
    "subfoldr2ext::sbfx_open_pg()"
  )
}

#' Close PostgreSQL Connection
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' `sbf_close_pg()` was moved to `subfoldr2ext::sbfx_close_pg()`.
#'
#' Close the PostgreSQL connection when you are done using a database.
#'
#' @inheritParams DBI::dbDisconnect
#'
#' @return TRUE (or errors).
#' @export
#' @details Wrapper on `DBI::dbDisconnect()`. It is important to remember to
#'   close connections or your database performance can decrease over time.
#' @family postgresql functions
#'
#' @examples
#' \dontrun{
#' conn <- sbf_open_pg()
#' sbf_close_pg(conn)
#' }
sbf_close_pg <- function(conn) {
  lifecycle::deprecate_stop(
    "0.2.0",
    "sbf_close_pg()",
    "subfoldr2ext::sbfx_close_pg()"
  )
}

#' Save PostgreSQL backup
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' `sbf_backup_pg()` was moved to `subfoldr2ext::sbfx_backup_pg()`.
#'
#' Save a copy of your database in a plain text format. This saves all the SQL
#' code to recreate the structure and data.
#'
#' @inheritParams psql::psql_backup
#' @inheritParams sbf_save_object
#' @param db_dump_name A string of the name for the database backup file
#'
#' @return TRUE (or errors)
#' @export
#' @details Wrapper on `psql::psql_backup()`
#' @family postgresql functions
#'
#' @examples
#' \dontrun{
#' sbf_backup_pg()
#'
#' sbf_backup_pg("database-22")
#' }
sbf_backup_pg <- function(db_dump_name = sbf_get_db_name(),
                          sub = sbf_get_sub(),
                          main = sbf_get_main(),
                          config_path = getOption("psql.config_path", NULL),
                          config_value = getOption("psql.config_value", "default")) {
  lifecycle::deprecate_stop(
    "0.2.0",
    "sbf_backup_pg()",
    "subfoldr2ext::sbfx_backup_pg()"
  )
}

#' Create PostgreSQL database
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' `sbf_create_pg()` was moved to `subfoldr2ext::sbfx_create_pg()`.
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
                          config_value = getOption("psql.config_value", "default")) {
  lifecycle::deprecate_stop(
    "0.2.0",
    "sbf_create_pg()",
    "subfoldr2ext::sbfx_create_pg()"
  )
}

#' Execute SQL statement for PostgreSQL database
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' `sbf_execute_pg()` was moved to `subfoldr2ext::sbfx_execute_pg()`.
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
                           config_value = getOption("psql.config_value", "default")) {
  lifecycle::deprecate_stop(
    "0.2.0",
    "sbf_execute_pg()",
    "subfoldr2ext::sbfx_execute_pg()"
  )
}

#' List tables in a schema
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' `sbf_list_tables_pg()` was moved to `subfoldr2ext::sbfx_list_tables_pg()`.
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
                               config_value = getOption("psql.config_value", "default")) {
  lifecycle::deprecate_stop(
    "0.2.0",
    "sbf_list_tables_pg()",
    "subfoldr2ext::sbfx_list_tables_pg()"
  )
}

#' Load a table from a PostgreSQL database
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' `sbf_load_data_from_pg()` was moved to `subfoldr2ext::sbfx_load_data_from_pg()`.
#'
#' Read/load a table from a PostgreSQL database as a data frame into R.
#'
#' @inheritParams psql::psql_read_table
#' @param x A string of the table name
#'
#' @return A data frame
#' @export
#' @details Wrapper on `psql::psql_read_table()`
#' @family postgresql functions
#' @family load functions
#'
#' @examples
#' \dontrun{
#' sbf_load_data_from_pg("capture")
#' sbf_load_data_from_pg("counts", "boat_count")
#' }
sbf_load_data_from_pg <- function(x,
                                  schema = getOption("psql.schema", "public"),
                                  config_path = getOption("psql.config_path", NULL),
                                  config_value = getOption("psql.config_value", "default")) {
  lifecycle::deprecate_stop(
    "0.2.0",
    "sbf_load_data_from_pg()",
    "subfoldr2ext::sbfx_load_data_from_pg()"
  )
}

#' Load Data Frames from PostgreSQL Database
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' `sbf_load_datas_from_pg()` was moved to `subfoldr2ext::sbfx_load_datas_from_pg()`.
#'
#' Load all the tables in a schema as data frames into your environment from a
#' PostgreSQL database.
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
                                   config_value = getOption("psql.config_value", "default")) {
  lifecycle::deprecate_stop(
    "0.2.0",
    "sbf_load_datas_from_pg()",
    "subfoldr2ext::sbfx_load_datas_from_pg()"
  )
}

#' Add data frame to PostgreSQL database
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' `sbf_save_data_to_pg()` was moved to `subfoldr2ext::sbfx_save_data_to_pg()`.
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
                                x_name = NULL,
                                schema = getOption("psql.schema", "public"),
                                config_path = getOption("psql.config_path", NULL),
                                config_value = getOption("psql.config_value", "default")) {
  lifecycle::deprecate_stop(
    "0.2.0",
    "sbf_save_data_to_pg()",
    "subfoldr2ext::sbfx_save_data_to_pg()"
  )
}

#' Set Schema Name
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' `sbf_set_schema()` was moved to `subfoldr2ext::sbfx_set_schema()`.
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
  lifecycle::deprecate_stop(
    "0.2.0",
    "sbf_set_schema()",
    "subfoldr2ext::sbfx_set_schema()"
  )
}

#' Get Schema Name
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' `sbf_get_schema()` was moved to `subfoldr2ext::sbfx_get_schema()`.
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
  lifecycle::deprecate_stop(
    "0.2.0",
    "sbf_get_schema()",
    "subfoldr2ext::sbfx_get_schema()"
  )
}

#' Reset Schema Name
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' `sbf_reset_schema()` was moved to `subfoldr2ext::sbfx_reset_schema()`.
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
  lifecycle::deprecate_stop(
    "0.2.0",
    "sbf_reset_schema()",
    "subfoldr2ext::sbfx_reset_schema()"
  )
}

#' Set the Config File path
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' `sbf_set_config_file()` was moved to `subfoldr2ext::sbfx_set_config_file()`.
#'
#' A wrapper to quickly set the `psql.config_path` options parameter.
#'
#' @param path A file path to the location of the yaml file containing your
#'   connection details.
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
  lifecycle::deprecate_stop(
    "0.2.0",
    "sbf_set_config_file()",
    "subfoldr2ext::sbfx_set_config_file()"
  )
}

#' Get the Config File Path
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' `sbf_get_config_file()` was moved to `subfoldr2ext::sbfx_get_config_file()`.
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
  lifecycle::deprecate_stop(
    "0.2.0",
    "sbf_get_config_file()",
    "subfoldr2ext::sbfx_get_config_file()"
  )
}

#' Reset the Config File Path
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' `sbf_reset_config_file()` was moved to `subfoldr2ext::sbfx_reset_config_file()`.
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
  lifecycle::deprecate_stop(
    "0.2.0",
    "sbf_reset_config_file()",
    "subfoldr2ext::sbfx_reset_config_file()"
  )
}

#' Set the Config Value
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' `sbf_set_config_value()` was moved to `subfoldr2ext::sbfx_set_config_value()`.
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
  lifecycle::deprecate_stop(
    "0.2.0",
    "sbf_set_config_value()",
    "subfoldr2ext::sbfx_set_config_value()"
  )
}

#' Get the Config File Value
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' `sbf_get_config_value()` was moved to `subfoldr2ext::sbfx_get_config_value()`.
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
  lifecycle::deprecate_stop(
    "0.2.0",
    "sbf_get_config_value()",
    "subfoldr2ext::sbfx_get_config_value()"
  )
}

#' Reset the Config File Value
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' `sbf_reset_config_value()` was moved to `subfoldr2ext::sbfx_reset_config_value()`.
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
  lifecycle::deprecate_stop(
    "0.2.0",
    "sbf_reset_config_value()",
    "subfoldr2ext::sbfx_reset_config_value()"
  )
}
