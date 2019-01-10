
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Travis build
status](https://travis-ci.org/poissonconsulting/subfoldr2.svg?branch=master)](https://travis-ci.org/poissonconsulting/subfoldr2)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/poissonconsulting/subfoldr2?branch=master&svg=true)](https://ci.appveyor.com/project/poissonconsulting/subfoldr2)
[![Coverage
status](https://codecov.io/gh/poissonconsulting/subfoldr2/branch/master/graph/badge.svg)](https://codecov.io/github/poissonconsulting/subfoldr2?branch=master)
[![License:
MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)

# subfoldr2

`subfoldr2` is an opinionated R package to facilitate the saving and
loading of R objects, data frames, strings, numbers and plots.

## Main Directory

By default files are saved to `output` unless overridden using
`sbf_set_main()`.

## Saving and Loading R Objects

An R object can be written using `sbf_save_object()` and read using
`sbf_load_object()`. All R objects are saved as `.rds` files in
`objects` (in the main folder). The user can save objects to a
particular directory within `objects` using `sbf_set_sub()` or the `sub
= sbf_get_sub()` argument of `sbf_save_object()`. This is useful if the
user wishes to save groups of objects together.

``` r
library(subfoldr2)
sbf_set_main(tempdir())

x <- 1
sbf_save_object(x)
sbf_save_object(3, "y")
x <- x * 2
sbf_set_sub("twice")
sbf_save_object(x)

list.files(sbf_get_main(), recursive = TRUE)
#> [1] "objects/twice/x.rds" "objects/x.rds"       "objects/y.rds"
sbf_reset_sub()
sbf_load_object("x")
#> [1] 1
sbf_load_object("x", sub = "twice")
#> [1] 2
```

The user can load all the objects in the current sub folder into the
calling environment using `sbf_load_objects()` or recursively load all
the objects as a list column in a data frame using
`sbf_load_objects_recursive()`.

``` r
rm(x)
sbf_load_objects()
print(x)
#> [1] 1
sbf_load_objects_recursive()
#> # A tibble: 3 x 4
#>   objects   name  sub1  file                                               
#>   <I(list)> <chr> <chr> <chr>                                              
#> 1 <dbl [1]> x     twice /var/folders/48/q6ltldjs251000_wvjrdy_vm0000gn/T/R…
#> 2 <dbl [1]> x     <NA>  /var/folders/48/q6ltldjs251000_wvjrdy_vm0000gn/T/R…
#> 3 <dbl [1]> y     <NA>  /var/folders/48/q6ltldjs251000_wvjrdy_vm0000gn/T/R…
```

To recursively delete a subdirectory call `sbf_set_sub()` with `rm =
TRUE`.

``` r
sbf_set_sub("twice", rm = TRUE, ask = FALSE)
sbf_load_objects_recursive()
#> [1] objects name    file   
#> <0 rows> (or 0-length row.names)
```

All the objects in the calling environment can be saved to the current
subdirectory using `sbf_save_objects()`.

``` r
ls()
#> [1] "x" "y"
sbf_save_objects()
sbf_load_objects_recursive()
#> # A tibble: 2 x 3
#>   objects   name  file                                                     
#>   <I(list)> <chr> <chr>                                                    
#> 1 <dbl [1]> x     /var/folders/48/q6ltldjs251000_wvjrdy_vm0000gn/T/Rtmpf4B…
#> 2 <dbl [1]> y     /var/folders/48/q6ltldjs251000_wvjrdy_vm0000gn/T/Rtmpf4B…
```

## Saving and Loading Data Frames, Numbers and Strings

There are equivalent.

## Installation

To install the latest development version from the Poisson drat
[repository](https://github.com/poissonconsulting/drat)

``` r
install.packages("drat")
drat::addRepo("poissonconsulting")
install.packages("subfoldr2")
```

## Contribution

Please report any
[issues](https://github.com/poissonconsulting/subfoldr2/issues).

[Pull requests](https://github.com/poissonconsulting/subfoldr2/pulls)
are always welcome.

Please note that this project is released with a [Contributor Code of
Conduct](CONDUCT.md). By participating in this project you agree to
abide by its terms.
