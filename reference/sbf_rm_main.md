# Remove Main

Remove Main

## Usage

``` r
sbf_rm_main(main = sbf_get_main(), ask = getOption("sbf.ask", TRUE))
```

## Arguments

- main:

  A string specifying the path to the main folder (by default the
  current main folder)

- ask:

  A flag specifying whether to ask before removing the existing folder.

## Value

An invisible copy of the main folder.

## See also

Other reset:
[`sbf_reset_main()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_reset_main.md),
[`sbf_reset_sub()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_reset_sub.md)

Other housekeeping functions:
[`sbf_archive_main()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_archive_main.md),
[`sbf_rm_flobs()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_rm_flobs.md),
[`sbf_unarchive_main()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_unarchive_main.md)
