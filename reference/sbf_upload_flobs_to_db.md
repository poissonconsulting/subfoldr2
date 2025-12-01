# Upload flobs

Uploads all files to database by default dir = NULL then uploads flobs
subdirectory corresponding to database using
dbflobr::import_all_flobs().

## Usage

``` r
sbf_upload_flobs_to_db(
  db_name = sbf_get_db_name(),
  sub = sbf_get_sub(),
  main = sbf_get_main(),
  dir = NULL,
  dbflobr_sub = FALSE,
  exists = FALSE,
  replace = FALSE
)
```

## Arguments

- db_name:

  A string of the database name.

- sub:

  A logical scalar specifying whether to import flobs based on their
  filename (sub = FALSE) or the name of their subdirectory (sub = TRUE)
  which must only contain 1 file. If sub = NA and replace = TRUE then
  the names of the subdirectories are used irrespective of whether they
  include files and existing flobs are deleted if the corresponding
  subdirectory is empty. If sub = TRUE or sub = NA then recursion is
  just one subfolder deep.

- main:

  A string specifying the path to the main folder (by default the
  current main folder)

- dir:

  A string of the path to the directory to import the files from. Files
  need to be within nested folders like 'table1/column1/a.csv'. This
  structure is created automatically if save_all_flobs() function is
  used.

- dbflobr_sub:

  A logical scalar specifying whether to import flobs based on their
  filename (sub = FALSE) or the name of their subdirectory (sub = TRUE)
  which must only contain 1 file. If sub = NA and replace = TRUE then
  the names of the subdirectories are used irrespective of whether they
  include files and existing flobs are deleted if the corresponding
  subdirectory is empty. If sub = TRUE or sub = NA then recursion is
  just one subfolder deep.

- exists:

  A logical scalar specifying whether the column must (TRUE) or mustn't
  (FALSE) already exist or whether it doesn't matter (NA). IF FALSE, a
  new BLOB column is created.

- replace:

  A flag indicating whether to replace existing flobs (TRUE) or not
  (FALSE).

## Value

An invisible named list indicating directory path, file names and
whether files were successfully written to database.

## See also

Other flob:
[`sbf_add_blob_column_to_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_add_blob_column_to_db.md),
[`sbf_save_flobs_from_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_flobs_from_db.md)

Other database functions:
[`sbf_add_blob_column_to_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_add_blob_column_to_db.md),
[`sbf_close_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_close_db.md),
[`sbf_copy_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_copy_db.md),
[`sbf_create_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_create_db.md),
[`sbf_execute_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_execute_db.md),
[`sbf_open_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_open_db.md),
[`sbf_query_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_query_db.md)
