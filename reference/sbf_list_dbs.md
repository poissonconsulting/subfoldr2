# Gets List of Database Files as a Character Vector

Returns file paths for all database files matching regular expression
x_name.

## Usage

``` r
sbf_list_dbs(
  x_name = ".*",
  sub = sbf_get_sub(),
  main = sbf_get_main(),
  recursive = FALSE,
  include_root = TRUE,
  ext = "sqlite"
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

- recursive:

  A flag specifying whether to recurse into subfolders.

- include_root:

  A flag indicating whether to include objects in the top

- ext:

  A string of the file extension.

## See also

Other list functions:
[`sbf_list_blocks()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_list_blocks.md),
[`sbf_list_datas()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_list_datas.md),
[`sbf_list_numbers()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_list_numbers.md),
[`sbf_list_objects()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_list_objects.md),
[`sbf_list_plots()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_list_plots.md),
[`sbf_list_strings()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_list_strings.md),
[`sbf_list_tables()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_list_tables.md),
[`sbf_list_windows()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_list_windows.md)
