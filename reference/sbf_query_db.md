# Query Existing Database

Really just a wrapper on DBI::dbGetQuery().

## Usage

``` r
sbf_query_db(
  sql,
  db_name = sbf_get_db_name(),
  sub = sbf_get_sub(),
  main = sbf_get_main()
)
```

## Arguments

- sql:

  A string of the SQL statement to execute.

- db_name:

  A string of the database name.

- sub:

  A string specifying the path to the sub folder (by default the current
  sub folder).

- main:

  A string specifying the path to the main folder (by default the
  current main folder)

## Value

A scalar numeric of the number of rows affected by the statement.

## See also

Other database functions:
[`sbf_add_blob_column_to_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_add_blob_column_to_db.md),
[`sbf_close_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_close_db.md),
[`sbf_copy_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_copy_db.md),
[`sbf_create_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_create_db.md),
[`sbf_execute_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_execute_db.md),
[`sbf_open_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_open_db.md),
[`sbf_upload_flobs_to_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_upload_flobs_to_db.md)
