# Save Dataframe to Excel Workbook

Save Dataframe to Excel Workbook

## Usage

``` r
sbf_save_excel(
  x,
  x_name = substitute(x),
  max_sheets = 1L,
  sub = sbf_get_sub(),
  main = sbf_get_main(),
  epgs = NULL
)
```

## Arguments

- x:

  The data frame to save.

- x_name:

  A string of the name.

- max_sheets:

  An integer specifying the maximum number of sheets to split your table
  into for writing to excel. The default is 1.

- sub:

  A string specifying the path to the sub folder (by default the current
  sub folder).

- main:

  A string specifying the path to the main folder (by default the
  current main folder)

- epgs:

  The projection to convert to

## Value

An invisible string of the path to the saved data.frame

## Details

This takes a data frame and saves it to their own excel workbook.

This function will split up large dataframes into smaller tables for
writing to excel because excel only allows a maximum number of
1,048,576. For the `max_sheets` argument you can pass a number higher
then the required and it will only return as many sheets as there is
data.

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
[`sbf_save_table()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_table.md),
[`sbf_save_window()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_window.md),
[`sbf_save_workbook()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_workbook.md)

Other excel:
[`sbf_get_workbook_name()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_get_workbook_name.md),
[`sbf_save_db_to_workbook()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_db_to_workbook.md),
[`sbf_save_excels()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_excels.md),
[`sbf_save_workbook()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_workbook.md)

## Examples

``` r
if (FALSE) { # \dontrun{
sbf_save_excel()
} # }
```
