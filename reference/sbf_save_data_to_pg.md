# Add data frame to PostgreSQL database

**\[deprecated\]**

`sbf_save_data_to_pg()` was moved to
`subfoldr2ext::sbfx_save_data_to_pg()`.

Add data with a data frame to your PostgreSQL database. The data frame
name must match the table name in your database, if not use the
`tbl_name` argument to pass the table name.

## Usage

``` r
sbf_save_data_to_pg(
  x,
  x_name = NULL,
  schema = getOption("psql.schema", "public"),
  config_path = getOption("psql.config_path", NULL),
  config_value = getOption("psql.config_value", "default")
)
```

## Arguments

- x:

  The data frame to save.

- x_name:

  A string of the name.

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

A scalar numeric.

## Details

Wrapper on `psql::psql_add_data()`

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
[`sbf_load_data_from_pg()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_data_from_pg.md),
[`sbf_load_datas_from_pg()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_datas_from_pg.md),
[`sbf_open_pg()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_open_pg.md),
[`sbf_reset_config_file()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_reset_config_file.md),
[`sbf_reset_config_value()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_reset_config_value.md),
[`sbf_reset_schema()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_reset_schema.md),
[`sbf_set_config_file()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_set_config_file.md),
[`sbf_set_config_value()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_set_config_value.md),
[`sbf_set_schema()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_set_schema.md)

Other save functions:
[`sbf_basename_sans_ext()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_basename_sans_ext.md),
[`sbf_save_aws_files()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_aws_files.md),
[`sbf_save_block()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_block.md),
[`sbf_save_data()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_data.md),
[`sbf_save_data_to_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_data_to_db.md),
[`sbf_save_datas()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_datas.md),
[`sbf_save_datas_to_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_datas_to_db.md),
[`sbf_save_db_metatable_descriptions()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_db_metatable_descriptions.md),
[`sbf_save_db_to_workbook()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_db_to_workbook.md),
[`sbf_save_excel()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_excel.md),
[`sbf_save_excels()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_excels.md),
[`sbf_save_gpkg()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_gpkg.md),
[`sbf_save_gpkgs()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_gpkgs.md),
[`sbf_save_number()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_number.md),
[`sbf_save_numbers()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_numbers.md),
[`sbf_save_object()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_object.md),
[`sbf_save_objects()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_objects.md),
[`sbf_save_plot()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_plot.md),
[`sbf_save_png()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_png.md),
[`sbf_save_spatial()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_spatial.md),
[`sbf_save_spatials()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_spatials.md),
[`sbf_save_string()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_string.md),
[`sbf_save_strings()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_strings.md),
[`sbf_save_table()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_table.md),
[`sbf_save_window()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_window.md),
[`sbf_save_workbook()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_workbook.md)

## Examples

``` r
if (FALSE) { # \dontrun{
sbf_save_data_to_pg(outing, "creel")
sbf_save_data_to_pg(outing_new, "creel", "outing")
} # }
```
