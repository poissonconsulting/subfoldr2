# Path to Database

Path to Database

## Usage

``` r
sbf_path_db(
  x_name = sbf_get_db_name(),
  sub = sbf_get_sub(),
  main = sbf_get_main(),
  ext = "sqlite",
  exists = NA
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

- ext:

  A string specifying the extension.

- exists:

  A logical scalar specifying whether the file should exist.

## Value

A string indicating the path.
