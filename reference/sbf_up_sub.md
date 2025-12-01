# Move Up Sub Folder

Moves up the sub folder hierarchy.

## Usage

``` r
sbf_up_sub(n = 1L, rm = FALSE, ask = getOption("sbf.ask", TRUE))
```

## Arguments

- n:

  A positive int of the number of subfolders to move up.

- rm:

  A flag specifying whether to remove the folder and all its contents if
  it already exists.

- ask:

  A flag specifying whether to ask before removing the existing folder.

## Value

An invisible string specifying the new sub folder.

## See also

Other directory functions:
[`sbf_add_sub()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_add_sub.md),
[`sbf_get_archive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_get_archive.md),
[`sbf_get_db_name()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_get_db_name.md),
[`sbf_get_main()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_get_main.md),
[`sbf_get_sub()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_get_sub.md),
[`sbf_get_workbook_name()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_get_workbook_name.md),
[`sbf_reset()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_reset.md),
[`sbf_reset_db_name()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_reset_db_name.md),
[`sbf_reset_main()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_reset_main.md),
[`sbf_reset_sub()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_reset_sub.md),
[`sbf_set_db_name()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_set_db_name.md),
[`sbf_set_main()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_set_main.md),
[`sbf_set_sub()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_set_sub.md)

## Examples

``` r
sbf_set_sub("nameofsub/othersub/yetothersub")
sbf_up_sub()
sbf_get_sub()
#> [1] "nameofsub/othersub"
sbf_reset_sub()
```
