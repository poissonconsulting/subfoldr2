# Convert Legacy Metadata Files to YAML

Converts legacy metadata files (saved with the `.rda` extension as RDS
files) to the human- and machine-readable `.yaml` files now used by the
package. Each `.rda` file in the main folder is read, written to a
`.yaml` file of the same name and then deleted.

## Usage

``` r
sbf_convert_meta(main = sbf_get_main(), ask = getOption("sbf.ask", TRUE))
```

## Arguments

- main:

  A string specifying the path to the main folder (by default the
  current main folder)

- ask:

  A flag specifying whether to ask before converting the files.

## Value

An invisible character vector of the paths to the `.yaml` files created.

## See also

Other housekeeping functions:
[`sbf_archive_main()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_archive_main.md),
[`sbf_rm_flobs()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_rm_flobs.md),
[`sbf_rm_main()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_rm_main.md),
[`sbf_unarchive_main()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_unarchive_main.md)
