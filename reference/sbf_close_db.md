# Close Database Connection

Closes the database connection.

## Usage

``` r
sbf_close_db(conn)
```

## Arguments

- conn:

  A
  [DBI::DBIConnection](https://dbi.r-dbi.org/reference/DBIConnection-class.html)
  object, as returned by
  [`dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html).

## Details

The function is just a wrapper on
`[dbDisconnect][DBI::dbDisconnect](conn)`.

## See also

Other database functions:
[`sbf_add_blob_column_to_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_add_blob_column_to_db.md),
[`sbf_copy_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_copy_db.md),
[`sbf_create_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_create_db.md),
[`sbf_execute_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_execute_db.md),
[`sbf_open_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_open_db.md),
[`sbf_query_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_query_db.md),
[`sbf_upload_flobs_to_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_upload_flobs_to_db.md)
