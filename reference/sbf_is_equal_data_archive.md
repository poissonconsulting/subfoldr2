# Is Equal Data Archive

Test if existing data are equal to archived data using
[`all.equal()`](https://rdrr.io/r/base/all.equal.html). If doesn't exist
in both returns FALSE, unless exists = FALSE in which case returns TRUE
or exists = NA in which case returns NA.

## Usage

``` r
sbf_is_equal_data_archive(
  x_name = ".*",
  sub = sbf_get_sub(),
  main = sbf_get_main(),
  archive = 1L,
  recursive = FALSE,
  include_root = TRUE,
  exists = TRUE,
  tolerance = sqrt(.Machine$double.eps),
  check.attributes = TRUE
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

- tolerance:

  numeric \\\ge\\ 0. Differences smaller than `tolerance` are not
  reported. The default value is close to `1.5e-8`.

- check.attributes:

  logical indicating if the
  [`attributes`](https://rdrr.io/r/base/attributes.html) of `target` and
  `current` (other than the names) should be compared.

## Value

A named logical vector.

## See also

Other compare functions:
[`sbf_compare_data()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_compare_data.md),
[`sbf_compare_data_archive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_compare_data_archive.md),
[`sbf_diff_data()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_diff_data.md),
[`sbf_diff_data_archive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_diff_data_archive.md),
[`sbf_diff_table()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_diff_table.md),
[`sbf_is_equal_data()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_is_equal_data.md)
