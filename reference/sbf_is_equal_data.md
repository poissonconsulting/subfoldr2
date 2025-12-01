# Is Equal Data

Test if data is equal using
[`all.equal()`](https://rdrr.io/r/base/all.equal.html). If doesn't exist
returns FALSE, unless exists = FALSE in which case returns TRUE or
exists = NA in which case returns NA.

## Usage

``` r
sbf_is_equal_data(
  x,
  x_name = substitute(x),
  sub = sbf_get_sub(),
  main = sbf_get_main(),
  exists = TRUE,
  tolerance = sqrt(.Machine$double.eps),
  check.attributes = TRUE
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

- tolerance:

  numeric \\\ge\\ 0. Differences smaller than `tolerance` are not
  reported. The default value is close to `1.5e-8`.

- check.attributes:

  logical indicating if the
  [`attributes`](https://rdrr.io/r/base/attributes.html) of `target` and
  `current` (other than the names) should be compared.

## Value

A named flag.

## See also

Other compare functions:
[`sbf_compare_data()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_compare_data.md),
[`sbf_compare_data_archive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_compare_data_archive.md),
[`sbf_diff_data()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_diff_data.md),
[`sbf_diff_data_archive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_diff_data_archive.md),
[`sbf_diff_table()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_diff_table.md),
[`sbf_is_equal_data_archive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_is_equal_data_archive.md)
