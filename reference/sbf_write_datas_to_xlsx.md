# Write Datas to Excel File

Writes all the data frames in the environment to an xlsx file. Each data
frame is saved to a sheet with the same name.

## Usage

``` r
sbf_write_datas_to_xlsx(
  path,
  exists = NA,
  env = parent.frame(),
  ask = getOption("sbf.ask", TRUE)
)
```

## Arguments

- path:

  A string of the path to the xlsx file (with the extension).

- exists:

  A logical scalar specifying whether the file should exist.

- env:

  An environment.

- ask:

  A flag specifying whether to ask before deleting an existing database
  (if exists = FALSE).

## Value

An invisible character vector of the names of the data frames.
