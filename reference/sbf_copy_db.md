# Copy SQLite Database

Copys an existing SQLite database to the subfolder.

## Usage

``` r
sbf_copy_db(
  path,
  db_name = sbf_get_db_name(),
  sub = sbf_get_sub(),
  main = sbf_get_main(),
  exists = FALSE,
  ask = getOption("sbf.ask", TRUE)
)
```

## Arguments

- path:

  A string of the path to the database to copy (with the extension).

- db_name:

  A string of the name for the new database (without the extension).

- sub:

  A string specifying the path to the sub folder (by default the current
  sub folder).

- main:

  A string specifying the path to the main folder (by default the
  current main folder)

- exists:

  A logical scalar specifying whether the new database must already
  exist.

- ask:

  A flag specifying whether to ask before deleting an existing database
  (if exists = FALSE).

## Value

A flag indicating whether successfully copied.

## See also

Other database functions:
[`sbf_add_blob_column_to_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_add_blob_column_to_db.md),
[`sbf_close_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_close_db.md),
[`sbf_create_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_create_db.md),
[`sbf_execute_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_execute_db.md),
[`sbf_open_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_open_db.md),
[`sbf_query_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_query_db.md),
[`sbf_upload_flobs_to_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_upload_flobs_to_db.md)
