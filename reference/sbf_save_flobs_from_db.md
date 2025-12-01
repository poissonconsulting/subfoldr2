# Save flobs

Saves and systematically renames all blobbed files by default (dir =
NULL) to flobs sub directory corresponding to database using
dbflobr::save_all_flobs().

## Usage

``` r
sbf_save_flobs_from_db(
  db_name = sbf_get_db_name(),
  sub = sbf_get_sub(),
  main = sbf_get_main(),
  dir = NULL,
  dbflobr_sub = FALSE,
  replace = FALSE
)
```

## Arguments

- db_name:

  A string of the database name.

- sub:

  A logical scalar specifying whether to save all existing files in a
  subdirectory of the same name (sub = TRUE) or all possible files in a
  subdirectory of the same name (sub = NA) or not nest files within a
  subdirectory (sub = FALSE).

- main:

  A string specifying the path to the main folder (by default the
  current main folder)

- dir:

  A string of the path to the directory to save the files in.

- dbflobr_sub:

  A logical specifying whether to save all existing files in a
  subdirectory of the same name (dbflobr_sub = TRUE) or all possible
  files in a subdirectory of the same name (dbflobr_sub = NA) or not
  nest files within a subdirectory (dbflobr_sub = FALSE).

- replace:

  A flag specifying whether to replace existing files. If sub = TRUE (or
  sub = NA) and replace = TRUE then all existing files within a
  subdirectory are deleted.

## Value

An invisible named list of named vectors of the file names and new file
names saved.

## See also

Other flob:
[`sbf_add_blob_column_to_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_add_blob_column_to_db.md),
[`sbf_upload_flobs_to_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_upload_flobs_to_db.md)
