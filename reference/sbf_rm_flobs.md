# Delete Flobs Subdfolder

Delete Flobs Subdfolder

## Usage

``` r
sbf_rm_flobs(
  sub = sbf_get_sub(),
  main = sbf_get_main(),
  ask = getOption("sbf.ask", TRUE)
)
```

## Arguments

- sub:

  A string specifying the path to the sub folder (by default the current
  sub folder).

- main:

  A string specifying the path to the main folder (by default the
  current main folder)

- ask:

  A flag specifying whether to ask before deleting the subfolder.

## Value

A invisible string of the directory deleted.

## See also

Other housekeeping functions:
[`sbf_archive_main()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_archive_main.md),
[`sbf_rm_main()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_rm_main.md),
[`sbf_unarchive_main()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_unarchive_main.md)
