# Convert to Markdown

Converts a data frame to the lines of a markdown table in the same
format as the `.md` file saved by
[`sbf_save_table()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_table.md)
and
[`sbf_save_plot()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_plot.md).

## Usage

``` r
sbf_as_md(
  x,
  round = FALSE,
  proportion = FALSE,
  format_column = list(),
  round_as_estimate = character(0)
)
```

## Arguments

- x:

  A data frame.

- round:

  A flag specifying whether to round the numeric columns as in the `.md`
  file saved by
  [`sbf_save_table()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_table.md)
  (described there), in which case significant trailing zeros are kept.
  If `FALSE` the values are not rounded.

- proportion:

  A flag specifying whether the columns `estimate`, `lower`, `upper` and
  `sd` are proportions, in which case significant digits are counted
  from the nearer of 0 and 1 in the `.md` file.

- format_column:

  A list of two-sided formulas of the form `column ~ fun(.)` specifying
  how to round and format numeric columns other than `estimate`,
  `lower`, `upper` and `sd` in the `.md` file. The function can return a
  numeric vector, which is formatted without further rounding, or a
  character vector, which is used as is. The values in the `.rds` and
  `.csv` files are not altered.

- round_as_estimate:

  A character vector of numeric columns, other than `estimate`, `lower`,
  `upper`, `sd` and `svalue`, to round in the `.md` file to the same
  number of decimal places as `estimate` in the same row (e.g. an
  `observed` value compared with the estimate). Rows with a missing
  estimate are formatted as data. If `proportion = TRUE` the columns
  must also be proportions.

## Value

A character vector of the lines of the table in markdown format.

## Details

Numeric columns are right-aligned with their decimal points aligned
using spaces and commas as thousands separators only for numbers of
10,000 or more. Other columns, including numbers stored as character,
are left-aligned. List columns and the geometry column of sf objects are
dropped.

## See also

[`sbf_round_data()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_round_data.md)

## Examples

``` r
x <- data.frame(
  term = c("bIntercept", "bYear"),
  estimate = c(0.53124, 12.3456),
  lower = c(0.21234, 9.8765),
  upper = c(0.87012, 15.4321)
)
writeLines(sbf_as_md(x))
#> | term       | estimate |   lower |    upper |
#> | :--------- | -------: | ------: | -------: |
#> | bIntercept |  0.53124 | 0.21234 |  0.87012 |
#> | bYear      | 12.3456  | 9.8765  | 15.4321  |
writeLines(sbf_as_md(x, round = TRUE))
#> | term       | estimate | lower | upper |
#> | :--------- | -------: | ----: | ----: |
#> | bIntercept |     0.53 |  0.21 |  0.87 |
#> | bYear      |    12.3  |  9.9  | 15    |
```
