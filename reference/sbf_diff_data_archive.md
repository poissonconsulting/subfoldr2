# Diff Data Archive

Find differences with existing data and archived data. If doesn't exist
(exists = NA) x is compared to itself.

## Usage

``` r
sbf_diff_data_archive(
  x_name = ".*",
  sub = sbf_get_sub(),
  main = sbf_get_main(),
  archive = 1L,
  recursive = FALSE,
  include_root = TRUE,
  exists = NA
)
```

## Arguments

- x_name:

  A string of the name.

- sub:

  A string specifying the path to the sub folder (by default the current
  sub folder).

- main:

  A string specifying the path to the main folder (by default the
  current main folder)

- archive:

  A positive whole number specifying the folder archived folder where 1L
  (the default) indicates the most recently archived folder or a
  character string of the path to the archived folder.

- recursive:

  A flag specifying whether to recurse into subfolders.

- include_root:

  A flag indicating whether to include objects in the top sub folder.

- exists:

  A logical scalar specifying whether the file should exist.

## Value

A named list of character vectors.

## See also

Other compare functions:
[`sbf_compare_data()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_compare_data.md),
[`sbf_compare_data_archive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_compare_data_archive.md),
[`sbf_diff_data()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_diff_data.md),
[`sbf_diff_table()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_diff_table.md),
[`sbf_is_equal_data()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_is_equal_data.md),
[`sbf_is_equal_data_archive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_is_equal_data_archive.md)
