# Open SQLite Database Connection

Opens a
[RSQLite::SQLiteConnection](https://rsqlite.r-dbi.org/reference/SQLiteConnection-class.html)
to a SQLite database. Foreign key constraints are enabled.

## Usage

``` r
sbf_open_db(
  db_name = sbf_get_db_name(),
  sub = sbf_get_sub(),
  main = sbf_get_main(),
  exists = TRUE,
  caption = NULL,
  report = NA,
  tag = NULL,
  ask = getOption("sbf.ask", TRUE)
)
```

## Arguments

- db_name:

  A string of the database name.

- sub:

  A string specifying the path to the sub folder (by default the current
  sub folder).

- main:

  A string specifying the path to the main folder (by default the
  current main folder)

- exists:

  A logical scalar specifying whether the database must already exist.

- caption:

  A string specifying the database metadata table caption. If NULL the
  caption is unchanged. If the caption is not specified for a databases
  it is set to be "". Deprecated.

- report:

  A logical scalar specifying whether to include the database metadata
  table in the report. If report = NA the setting is not changed.
  Soft-deprecated. If the report status is not specified for a databases
  it is included in the report. deprecated.

- tag:

  A string of the tag. Deprecated.

- ask:

  A flag specifying whether to ask before deleting an existing database
  (if exists = FALSE).

## See also

Other database functions:
[`sbf_add_blob_column_to_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_add_blob_column_to_db.md),
[`sbf_close_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_close_db.md),
[`sbf_copy_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_copy_db.md),
[`sbf_create_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_create_db.md),
[`sbf_execute_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_execute_db.md),
[`sbf_query_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_query_db.md),
[`sbf_upload_flobs_to_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_upload_flobs_to_db.md)
