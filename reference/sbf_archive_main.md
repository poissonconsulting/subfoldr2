# Archive Main Folder

Archives main folder by copy to a director of the same name with the
current date and time appended.

## Usage

``` r
sbf_archive_main(
  main = sbf_get_main(),
  ask = getOption("sbf.ask", TRUE),
  tz = dtt_default_tz()
)
```

## Arguments

- main:

  A string specifying the path to the main folder (by default the
  current main folder)

- ask:

  A flag specifying whether to ask before removing the existing folder.

- tz:

  A string specifying the time zone for the current date and time.

## Value

An invisible string of the path to the archived folder.

## See also

Other archive:
[`sbf_get_archive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_get_archive.md),
[`sbf_unarchive_main()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_unarchive_main.md)

Other housekeeping functions:
[`sbf_rm_flobs()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_rm_flobs.md),
[`sbf_rm_main()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_rm_main.md),
[`sbf_unarchive_main()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_unarchive_main.md)
