# Add blob column

Add named empty blob column to database

## Usage

``` r
sbf_add_blob_column_to_db(
  column_name,
  table_name,
  db_name = sbf_get_db_name(),
  sub = sbf_get_sub(),
  main = sbf_get_main()
)
```

## Arguments

- column_name:

  A string of the name of the BLOB column.

- table_name:

  A string of the name of the existing table.

- db_name:

  A string of the database name.

- sub:

  A string specifying the path to the sub folder (by default the current
  sub folder).

- main:

  A string specifying the path to the main folder (by default the
  current main folder)

## Value

Invisible TRUE.

## See also

Other flob:
[`sbf_save_flobs_from_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_flobs_from_db.md),
[`sbf_upload_flobs_to_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_upload_flobs_to_db.md)

Other database functions:
[`sbf_close_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_close_db.md),
[`sbf_copy_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_copy_db.md),
[`sbf_create_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_create_db.md),
[`sbf_execute_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_execute_db.md),
[`sbf_open_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_open_db.md),
[`sbf_query_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_query_db.md),
[`sbf_upload_flobs_to_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_upload_flobs_to_db.md)
