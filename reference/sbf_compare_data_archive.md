# Compare Data Archive

Compares existing data to archived data using using waldo::compare.

## Usage

``` r
sbf_compare_data_archive(
  x_name = ".*",
  sub = sbf_get_sub(),
  main = sbf_get_main(),
  archive = 1L,
  recursive = FALSE,
  include_root = TRUE,
  tolerance = sqrt(.Machine$double.eps),
  ignore_attr = FALSE
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

- tolerance:

  numeric \\\ge\\ 0. Differences smaller than `tolerance` are not
  reported. The default value is close to `1.5e-8`.

- ignore_attr:

  Ignore differences in specified attributes? Supply a character vector
  to ignore differences in named attributes. By default the
  `"waldo_opts"` attribute is listed in `ignore_attr` so that changes to
  it are not reported; if you customize `ignore_attr`, you will probably
  want to do this yourself.

  For backward compatibility with
  [`all.equal()`](https://rdrr.io/r/base/all.equal.html), you can also
  use `TRUE`, to all ignore differences in all attributes. This is not
  generally recommended as it is a blunt tool that will ignore many
  important functional differences.

## Value

A named list of character vectors.

## See also

Other compare functions:
[`sbf_compare_data()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_compare_data.md),
[`sbf_diff_data()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_diff_data.md),
[`sbf_diff_data_archive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_diff_data_archive.md),
[`sbf_diff_table()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_diff_table.md),
[`sbf_is_equal_data()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_is_equal_data.md),
[`sbf_is_equal_data_archive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_is_equal_data_archive.md)
