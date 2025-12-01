# Unarchive Main Folder

Unarchives an archived main folder.

## Usage

``` r
sbf_unarchive_main(
  main = sbf_get_main(),
  archive = 1L,
  ask = getOption("sbf.ask", TRUE)
)
```

## Arguments

- main:

  A string specifying the path to the main folder (by default the
  current main folder)

- archive:

  A positive whole number specifying the folder archived folder where 1L
  (the default) indicates the most recently archived folder or a
  character string of the path to the archived folder.

- ask:

  A flag specifying whether to ask before removing the existing folder.

## Value

An invisible string of the path to the previously archived folder.

## See also

Other archive:
[`sbf_archive_main()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_archive_main.md),
[`sbf_get_archive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_get_archive.md)

Other housekeeping functions:
[`sbf_archive_main()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_archive_main.md),
[`sbf_rm_flobs()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_rm_flobs.md),
[`sbf_rm_main()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_rm_main.md)
