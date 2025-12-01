# Create SQLite Database

Create SQLite Database

## Usage

``` r
sbf_create_db(
  db_name = sbf_get_db_name(),
  sub = sbf_get_sub(),
  main = sbf_get_main(),
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

- ask:

  A flag specifying whether to ask before deleting an existing database.

## See also

Other database functions:
[`sbf_add_blob_column_to_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_add_blob_column_to_db.md),
[`sbf_close_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_close_db.md),
[`sbf_copy_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_copy_db.md),
[`sbf_execute_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_execute_db.md),
[`sbf_open_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_open_db.md),
[`sbf_query_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_query_db.md),
[`sbf_upload_flobs_to_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_upload_flobs_to_db.md)
