# Diff Table

Find differences with existing table data. If doesn't exist (exists =
NA) x is compared to itself.

## Usage

``` r
sbf_diff_table(
  x,
  x_name = substitute(x),
  sub = sbf_get_sub(),
  main = sbf_get_main(),
  exists = NA
)
```

## Arguments

- x:

  The object to save.

- x_name:

  A string of the name.

- sub:

  A string specifying the path to the sub folder (by default the current
  sub folder).

- main:

  A string specifying the path to the main folder (by default the
  current main folder)

- exists:

  A logical scalar specifying whether the file should exist.

## Value

A daff difference object.

## See also

Other compare functions:
[`sbf_compare_data()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_compare_data.md),
[`sbf_compare_data_archive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_compare_data_archive.md),
[`sbf_diff_data()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_diff_data.md),
[`sbf_diff_data_archive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_diff_data_archive.md),
[`sbf_is_equal_data()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_is_equal_data.md),
[`sbf_is_equal_data_archive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_is_equal_data_archive.md)
