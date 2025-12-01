# Execute SQL statement for PostgreSQL database

**\[deprecated\]**

`sbf_execute_pg()` was moved to `subfoldr2ext::sbfx_execute_pg()`.

Execute PostgreSQL statements.

## Usage

``` r
sbf_execute_pg(
  sql,
  config_path = getOption("psql.config_path", NULL),
  config_value = getOption("psql.config_value", "default")
)
```

## Arguments

- sql:

  A string of the SQL statement to execute.

- config_path:

  A string of a file path to the yaml configuration file. The default
  value grabs the file path from the psql.config_path option and uses
  `NULL` if no value supplied.

- config_value:

  A string of the name of value. The default value grabs the value from
  the psql.config_value option and uses `"default"` if no value is
  supplied.

## Value

A scalar numeric of the number of rows affected by the statement.

## Details

Wrapper on `psql::psql_execute_db()`

## See also

Other postgresql functions:
[`sbf_backup_pg()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_backup_pg.md),
[`sbf_close_pg()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_close_pg.md),
[`sbf_create_pg()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_create_pg.md),
[`sbf_get_config_file()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_get_config_file.md),
[`sbf_get_config_value()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_get_config_value.md),
[`sbf_get_schema()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_get_schema.md),
[`sbf_list_tables_pg()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_list_tables_pg.md),
[`sbf_load_data_from_pg()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_data_from_pg.md),
[`sbf_load_datas_from_pg()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_datas_from_pg.md),
[`sbf_open_pg()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_open_pg.md),
[`sbf_reset_config_file()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_reset_config_file.md),
[`sbf_reset_config_value()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_reset_config_value.md),
[`sbf_reset_schema()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_reset_schema.md),
[`sbf_save_data_to_pg()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_data_to_pg.md),
[`sbf_set_config_file()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_set_config_file.md),
[`sbf_set_config_value()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_set_config_value.md),
[`sbf_set_schema()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_set_schema.md)

## Examples

``` r
if (FALSE) { # \dontrun{
sbf_execute_pg(
  "CREATE SCHEMA boat_count"
)
sbf_execute_pg(
  "CREATE TABLE boat_count.input (
  file_name TEXT NOT NULL,
  comment TEXT)"
)
} # }
```
