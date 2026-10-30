# Save Table

Saves a data frame as `.rds` and `.csv` files with the unrounded values
and as a `.md` file with the values rounded and formatted for display.

## Usage

``` r
sbf_save_table(
  x,
  x_name = substitute(x),
  sub = sbf_get_sub(),
  main = sbf_get_main(),
  caption = "",
  report = TRUE,
  tag = "",
  notes = "",
  proportion = FALSE,
  format_column = list(),
  round_as_estimate = character(0),
  no_big_mark = character(0),
  drop_sd = FALSE
)
```

## Arguments

- x:

  The data frame to save.

- x_name:

  A string of the name.

- sub:

  A string or character vector specifying the path to the sub folder (by
  default the current sub folder).

- main:

  A string specifying the path to the main folder (by default the
  current main folder)

- caption:

  A string of the caption.

- report:

  A flag specifying whether to include in a report.

- tag:

  A string of the tag.

- notes:

  A string of additional notes to save with the metadata.

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

- no_big_mark:

  A character vector of numeric columns (e.g. `year`) to format without
  commas as thousands separators in the `.md` file.

- drop_sd:

  A flag specifying whether to drop the `sd` column from the `.md` file
  after using it to round `estimate`, `lower` and `upper`. If `TRUE`
  there must be a numeric `sd` column. The `.rds` and `.csv` files
  retain the `sd` column.

## Value

An invisible string of the path to the saved object.

## Details

In the `.md` file, estimates are rounded following the rounding policy
in the usepois report template, which is adapted from Cole (2015). The
column `estimate` is rounded to the second significant digit of the
column `sd` if present and otherwise of 1/4 of the interval between the
columns `lower` and `upper`. The columns `lower` and `upper` are rounded
to one fewer decimal place than the estimate but to at least two
significant digits. Estimates without an `sd` or interval are rounded to
three significant digits. The column `svalue` is rounded to one decimal
place. Other double columns are rounded to four significant digits,
without adding trailing zeros beyond the digits of the value, while
integer columns are not rounded. Significant trailing zeros are
retained, commas are used as thousands separators for numbers of 1000 or
more except in the columns named by `no_big_mark`, and numeric columns
are padded with spaces to align their decimal points. The `.md` file is
not saved if `getOption("sbf.save_md")` is `FALSE`, in which case any
existing `.md` file for the table is deleted.

## References

Cole, T.J. 2015. Too many digits: the presentation of numerical data.
Archives of Disease in Childhood 100(7): 608-609.
[doi:10.1136/archdischild-2014-307149](https://doi.org/10.1136/archdischild-2014-307149)
.

## See also

Other save functions:
[`sbf_basename_sans_ext()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_basename_sans_ext.md),
[`sbf_save_aws_files()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_aws_files.md),
[`sbf_save_block()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_block.md),
[`sbf_save_data()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_data.md),
[`sbf_save_data_to_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_data_to_db.md),
[`sbf_save_data_to_pg()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_data_to_pg.md),
[`sbf_save_datas()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_datas.md),
[`sbf_save_datas_to_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_datas_to_db.md),
[`sbf_save_db_metatable_descriptions()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_db_metatable_descriptions.md),
[`sbf_save_db_to_workbook()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_db_to_workbook.md),
[`sbf_save_excel()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_excel.md),
[`sbf_save_excels()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_excels.md),
[`sbf_save_gpkg()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_gpkg.md),
[`sbf_save_gpkgs()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_gpkgs.md),
[`sbf_save_number()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_number.md),
[`sbf_save_numbers()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_numbers.md),
[`sbf_save_object()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_object.md),
[`sbf_save_objects()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_objects.md),
[`sbf_save_plot()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_plot.md),
[`sbf_save_png()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_png.md),
[`sbf_save_spatial()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_spatial.md),
[`sbf_save_spatials()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_spatials.md),
[`sbf_save_string()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_string.md),
[`sbf_save_strings()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_strings.md),
[`sbf_save_window()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_window.md),
[`sbf_save_workbook()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_workbook.md)

## Examples

``` r
if (FALSE) { # \dontrun{
sbf_save_table(
  coef,
  caption = "Parameter estimates.",
  format_column = list(zscore ~ round(., 1))
)
sbf_save_table(ppc, round_as_estimate = "observed")
sbf_save_table(counts, no_big_mark = "year")
} # }
```
