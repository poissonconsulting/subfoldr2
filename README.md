
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

`subfoldr2` is an R package to facilitate the saving and loading of

  - R objects
  - data frames (and tables)
  - strings (and code blocks)
  - numbers
  - ggplot objects (and windows)

and the opening and closing of

  - graphics windows
  - pdfs
  - database (SQLite) connections

## Main Folder

By default files are saved to `output` unless overridden using
`sbf_set_main()` which can take a relative or absolute path.

``` r
library(subfoldr2)
sbf_set_main(tempdir(), "output")
sbf_get_main()
#> [1] "/var/folders/48/q6ltldjs251000_wvjrdy_vm0000gn/T/RtmpdFbH8V/output"
```

## Saving and Loading R Objects

### Single Objects

An R object can be written using `sbf_save_object()` and read using
`sbf_load_object()`.

``` r
x <- 1
sbf_save_object(x)
sbf_load_object("x")
#> [1] 1
```

All R objects are saved as `.rds` files in folder `objects` (in the main
folder).

``` r
list.files(sbf_get_main(), recursive = TRUE)
#> [1] "objects/x.rds"
```

### Subfolders

The user can save objects to a particular sub folder within `objects`
using `sbf_set_sub()` or the `sub = sbf_get_sub()` argument of
`sbf_save_object()`.

``` r
sbf_set_sub("times2")
x <- x * 2
sbf_save_object(x)
sbf_save_object(x * 3, x_name = "x3", sub = "times2/times3")
sbf_save_object(data.frame(), x_name = "df", sub = "times2/times3")
list.files(sbf_get_main(), recursive = TRUE)
#> [1] "objects/times2/times3/df.rds" "objects/times2/times3/x3.rds"
#> [3] "objects/times2/x.rds"         "objects/x.rds"
```

### Loading Multiple Objects

The user can load all the objects in the current sub folder into the
calling environment using `sbf_load_objects()` or recursively load all
the objects as a list column in a data frame using
`sbf_load_objects_recursive()`.

``` r
print(sbf_set_sub("times2", "times3"))
#> [1] "times2/times3"
sbf_load_objects()
ls()
#> [1] "df" "x"  "x3"
sbf_load_objects_recursive(sub = "times2")
#> # A tibble: 3 x 4
#>   objects         name  sub1   file                                        
#>   <I(list)>       <chr> <chr>  <chr>                                       
#> 1 <data.frame [0… df    times3 /var/folders/48/q6ltldjs251000_wvjrdy_vm000…
#> 2 <dbl [1]>       x3    times3 /var/folders/48/q6ltldjs251000_wvjrdy_vm000…
#> 3 <dbl [1]>       x     <NA>   /var/folders/48/q6ltldjs251000_wvjrdy_vm000…
```

### Deleting Subfolders

To recursively delete a sub folder call `sbf_set_sub()` with `rm =
TRUE`.

``` r
sbf_set_sub("times2", rm = TRUE, ask = FALSE)
list.files(sbf_get_main(), recursive = TRUE)
#> [1] "objects/x.rds"
```

### Saving Multiple Objects

All the objects in the calling environment can be saved to the current
subdirectory using `sbf_save_objects()`.

``` r
ls()
#> [1] "df" "x"  "x3"
sbf_save_objects()
list.files(sbf_get_main(), recursive = TRUE)
#> [1] "objects/times2/df.rds" "objects/times2/x.rds"  "objects/times2/x3.rds"
#> [4] "objects/x.rds"
rm(x, x3, df)
sbf_load_objects()
print(x3)
#> [1] 6
print(df)
#> data frame with 0 columns and 0 rows
```

## Numbers, Strings and Data Frames

The above functions for saving and loading R objects are members of
families of functions for specific types of object. In particular there
are family members for

  - numbers (numeric scalars)
  - strings (character scalars)
  - data (objects inheriting from data.frame)

<!-- end list -->

``` r
sbf_reset_sub(rm = TRUE, ask = FALSE)
data2 <- data.frame(x = 5:6, y = 7:8)
chr <- "some text"
vec <- c(1,3) # not saved as vector
sbf_save_datas()
sbf_save_strings()
sbf_save_numbers()
list.files(sbf_get_main(), recursive = TRUE)
#> [1] "data/data2.rds"  "data/df.rds"     "numbers/x.csv"   "numbers/x.rds"  
#> [5] "numbers/x3.csv"  "numbers/x3.rds"  "strings/chr.rds" "strings/chr.txt"
```

All types of object are saved as rds files. However to facilitate
viewing, each number is also saved as a csv file and each string is also
saved as a txt file.

## Tables and Code Blocks

Tables are data frames with just numeric, character, factor, Date and
POSIXct columns. As tables are intended for reports they have to be
saved individually with an optional caption using `sbf_save_table()`. As
a result tables cannot be bulk saved however they can be bulked loaded.
Each table is also saved as csv file (to facilitate viewing) and the
metadata including the caption are saved as an rda file (to facilitate
report production).

Code blocks are strings which include optional caption and language
metadata.

## Plots

Plots are ggplot objects with caption, width and height (in inches) and
dpi (dots per inch) metadata. Each plot is also saved as png file of the
specified dimensions and resolution and the default dataset if present
(and \(\leq\) 1,000 rows) is saved as a csv. By default the last ggplot
object created, modified or plotted is saved and the dimensions are
taken from the current graphics device.

A graphics window can be opened using `sbf_open_window()`, where the
`width` and `height` arguments are in inches, and closed using
`sbf_close_window()`.

In addition to individually or bulk loading ggplot objects, the user can
individually or bulk load the default datasets using for example
`sbf_load_plots_data()`.

## Windows

In the case of base or grid graphics the contents of the current window
can be copied to a png file (without an associated rds file) using
`sbf_save_window()` which takes caption, width, height and dpi
arguments. The window names and file paths can be loaded using
`sbf_load_windows_recursive()`.

## Portable Graphics Files

A pdf graphics device can be opened (in the current subfolder of the
pdfs folder) using `sbf_open_pdf()` and the current device can be closed
using `sbf_close_pdf()`. pdf graphics devices have the advantage of
accepting multiple plots.

## Databases

A connection to a SQLite database (in the current subfolder of the dbs
folder) can be opened using `conn <- sbf_open_db()` and an individual
connection can be closed using `sbf_close_db(conn)`.

Alternatively, `sbf_save_datas_to_db()` automatically open and closes
the connection and uses `readwritesqlite::rws_read_sqlite.environment`
to write all the data frames in the calling environment.

The opposite function, `sbf_load_datas_from_db()`, uses
`rws_read_sqlite.SQLiteConnection` to save all the tables to the calling
environment.

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
abide by its terms
