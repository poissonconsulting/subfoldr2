# Round Data

Rounds the numeric columns of a data frame in the same way as the `.md`
file saved by
[`sbf_save_table()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_table.md)
and
[`sbf_save_plot()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_plot.md).

## Usage

``` r
sbf_round_data(
  x,
  proportion = FALSE,
  format_column = list(),
  round_as_estimate = character(0)
)
```

## Arguments

- x:

  A data frame.

- proportion:

  A flag specifying whether the columns `estimate`, `lower`, `upper` and
  `sd` are proportions, in which case significant digits are counted
  from the nearer of 0 and 1 in the `.md` file. The `sd` must not exceed
  `sd(c(0, 1))`.

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

`x` with its numeric columns rounded.

## Details

The rounding is described in
[`sbf_save_table()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_table.md).
The numeric columns stay numeric, so significant trailing zeros are not
kept when the values are printed; use
[`sbf_as_md()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_as_md.md)
with `round = TRUE` to keep them. Integer columns and columns that are
not numeric are not altered. Columns formatted by `format_column` are
replaced by the values returned by the function, which are not rounded
further.

## See also

[`sbf_as_md()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_as_md.md)

## Examples

``` r
x <- data.frame(
  estimate = c(0.53124, 12.3456),
  lower = c(0.21234, 9.8765),
  upper = c(0.87012, 15.4321),
  length = c(1.23456, 123.456)
)
sbf_round_data(x)
#>   estimate lower upper  length
#> 1     0.53  0.21  0.87   1.235
#> 2    12.30  9.90 15.00 123.500
sbf_round_data(x, format_column = list(length ~ round(., 1)))
#>   estimate lower upper length
#> 1     0.53  0.21  0.87    1.2
#> 2    12.30  9.90 15.00  123.5
```
