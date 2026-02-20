# Load a table from a PostgreSQL database

**\[deprecated\]**

`sbf_load_data_from_pg()` was moved to
`subfoldr2ext::sbfx_load_data_from_pg()`.

Read/load a table from a PostgreSQL database as a data frame into R.

## Usage

``` r
sbf_load_data_from_pg(
  x,
  schema = getOption("psql.schema", "public"),
  config_path = getOption("psql.config_path", NULL),
  config_value = getOption("psql.config_value", "default")
)
```

## Arguments

- x:

  A string of the table name

- schema:

  A string of the schema name. Default value is `"public"`.

- config_path:

  A string of a file path to the yaml configuration file. The default
  value grabs the file path from the psql.config_path option and uses
  `NULL` if no value supplied.

- config_value:

  A string of the name of value. The default value grabs the value from
  the psql.config_value option and uses `"default"` if no value is
  supplied.

## Value

A data frame

## Details

Wrapper on `psql::psql_read_table()`

## See also

Other postgresql functions:
[`sbf_backup_pg()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_backup_pg.md),
[`sbf_close_pg()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_close_pg.md),
[`sbf_create_pg()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_create_pg.md),
[`sbf_execute_pg()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_execute_pg.md),
[`sbf_get_config_file()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_get_config_file.md),
[`sbf_get_config_value()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_get_config_value.md),
[`sbf_get_schema()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_get_schema.md),
[`sbf_list_tables_pg()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_list_tables_pg.md),
[`sbf_load_datas_from_pg()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_datas_from_pg.md),
[`sbf_open_pg()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_open_pg.md),
[`sbf_reset_config_file()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_reset_config_file.md),
[`sbf_reset_config_value()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_reset_config_value.md),
[`sbf_reset_schema()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_reset_schema.md),
[`sbf_save_data_to_pg()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_data_to_pg.md),
[`sbf_set_config_file()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_set_config_file.md),
[`sbf_set_config_value()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_set_config_value.md),
[`sbf_set_schema()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_set_schema.md)

Other load functions:
[`load_rdss_recursive()`](https://poissonconsulting.github.io/subfoldr2/reference/load_rdss_recursive.md),
[`sbf_load_block()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_block.md),
[`sbf_load_blocks()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_blocks.md),
[`sbf_load_blocks_recursive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_blocks_recursive.md),
[`sbf_load_data()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_data.md),
[`sbf_load_data_from_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_data_from_db.md),
[`sbf_load_datas()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_datas.md),
[`sbf_load_datas_from_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_datas_from_db.md),
[`sbf_load_datas_from_pg()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_datas_from_pg.md),
[`sbf_load_datas_recursive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_datas_recursive.md),
[`sbf_load_db_metatable()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_db_metatable.md),
[`sbf_load_number()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_number.md),
[`sbf_load_numbers()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_numbers.md),
[`sbf_load_numbers_recursive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_numbers_recursive.md),
[`sbf_load_object()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_object.md),
[`sbf_load_objects()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_objects.md),
[`sbf_load_objects_recursive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_objects_recursive.md),
[`sbf_load_plot()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_plot.md),
[`sbf_load_plot_data()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_plot_data.md),
[`sbf_load_plots_data()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_plots_data.md),
[`sbf_load_plots_data_recursive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_plots_data_recursive.md),
[`sbf_load_plots_recursive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_plots_recursive.md),
[`sbf_load_spatial()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_spatial.md),
[`sbf_load_spatials()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_spatials.md),
[`sbf_load_string()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_string.md),
[`sbf_load_strings()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_strings.md),
[`sbf_load_strings_recursive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_strings_recursive.md),
[`sbf_load_table()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_table.md),
[`sbf_load_tables()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_tables.md),
[`sbf_load_tables_recursive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_tables_recursive.md),
[`sbf_load_windows_recursive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_windows_recursive.md),
[`sbf_subs_block_recursive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_subs_block_recursive.md),
[`sbf_subs_data_recursive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_subs_data_recursive.md),
[`sbf_subs_number_recursive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_subs_number_recursive.md),
[`sbf_subs_object_recursive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_subs_object_recursive.md),
[`sbf_subs_plot_recursive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_subs_plot_recursive.md),
[`sbf_subs_string_recursive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_subs_string_recursive.md),
[`sbf_subs_table_recursive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_subs_table_recursive.md),
[`sbf_subs_window_recursive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_subs_window_recursive.md)

## Examples

``` r
if (FALSE) { # \dontrun{
sbf_load_data_from_pg("capture")
sbf_load_data_from_pg("counts", "boat_count")
} # }
```
