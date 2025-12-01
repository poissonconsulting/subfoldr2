# Get Database Name

Gets database name (without the extension or path). By default (ie if
not set) 'database'.

## Usage

``` r
sbf_get_db_name()
```

## Value

A string specifying the current database name (without the extension or
path).

## See also

Other db_name:
[`sbf_set_db_name()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_set_db_name.md)

Other directory functions:
[`sbf_add_sub()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_add_sub.md),
[`sbf_get_archive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_get_archive.md),
[`sbf_get_main()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_get_main.md),
[`sbf_get_sub()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_get_sub.md),
[`sbf_get_workbook_name()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_get_workbook_name.md),
[`sbf_reset()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_reset.md),
[`sbf_reset_db_name()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_reset_db_name.md),
[`sbf_reset_main()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_reset_main.md),
[`sbf_reset_sub()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_reset_sub.md),
[`sbf_set_db_name()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_set_db_name.md),
[`sbf_set_main()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_set_main.md),
[`sbf_set_sub()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_set_sub.md),
[`sbf_up_sub()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_up_sub.md)

## Examples

``` r
sbf_get_db_name()
#> [1] "database"
```
