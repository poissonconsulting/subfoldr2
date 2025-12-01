# Close PostgreSQL Connection

**\[deprecated\]**

`sbf_close_pg()` was moved to `subfoldr2ext::sbfx_close_pg()`.

Close the PostgreSQL connection when you are done using a database.

## Usage

``` r
sbf_close_pg(conn)
```

## Arguments

- conn:

  A
  [DBI::DBIConnection](https://dbi.r-dbi.org/reference/DBIConnection-class.html)
  object, as returned by
  [`dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html).

## Value

TRUE (or errors).

## Details

Wrapper on
[`DBI::dbDisconnect()`](https://dbi.r-dbi.org/reference/dbDisconnect.html).
It is important to remember to close connections or your database
performance can decrease over time.

## See also

Other postgresql functions:
[`sbf_backup_pg()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_backup_pg.md),
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
[`sbf_save_data_to_pg()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_data_to_pg.md),
[`sbf_set_config_file()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_set_config_file.md),
[`sbf_set_config_value()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_set_config_value.md),
[`sbf_set_schema()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_set_schema.md)

## Examples

``` r
if (FALSE) { # \dontrun{
conn <- sbf_open_pg()
sbf_close_pg(conn)
} # }
```
