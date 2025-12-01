# Load Plots as List Column in Data Frame

Recursively loads all the plots with names matching the regular
expression x_name as the first (list) column (named plots) in a data
frame. Subsequent character vector columns specify the object names
(named name) and sub folders (named sub1, sub2 etc).

## Usage

``` r
sbf_load_plots_recursive(
  x_name = ".*",
  sub = sbf_get_sub(),
  main = sbf_get_main(),
  include_root = TRUE,
  tag = ".*",
  meta = FALSE
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

- include_root:

  A flag indicating whether to include objects in the top sub folder.

- tag:

  A string of the regular expression that the tag must match to be
  included.

- meta:

  A flag specifying whether to include the report, caption and any other
  metadata as columns.

## See also

Other load functions:
[`sbf_load_block()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_block.md),
[`sbf_load_blocks()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_blocks.md),
[`sbf_load_blocks_recursive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_blocks_recursive.md),
[`sbf_load_data()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_data.md),
[`sbf_load_data_from_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_data_from_db.md),
[`sbf_load_data_from_pg()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_data_from_pg.md),
[`sbf_load_datas()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_datas.md),
[`sbf_load_datas_from_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_datas_from_db.md),
[`sbf_load_datas_from_pg()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_datas_from_pg.md),
[`sbf_load_datas_recursive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_datas_recursive.md),
[`sbf_load_db_metatable()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_db_metatable.md),
[`sbf_load_number()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_number.md),
[`sbf_load_numbers()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_numbers.md),
[`sbf_load_numbers_recursive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_numbers_recursive.md),
[`sbf_load_object()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_object.md),
[`sbf_load_objects()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_objects.md),
[`sbf_load_objects_recursive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_objects_recursive.md),
[`sbf_load_plot()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_plot.md),
[`sbf_load_plot_data()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_plot_data.md),
[`sbf_load_plots_data()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_plots_data.md),
[`sbf_load_plots_data_recursive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_plots_data_recursive.md),
[`sbf_load_spatial()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_spatial.md),
[`sbf_load_spatials()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_spatials.md),
[`sbf_load_string()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_string.md),
[`sbf_load_strings()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_strings.md),
[`sbf_load_strings_recursive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_strings_recursive.md),
[`sbf_load_table()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_table.md),
[`sbf_load_tables()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_tables.md),
[`sbf_load_tables_recursive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_tables_recursive.md),
[`sbf_load_windows_recursive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_windows_recursive.md),
[`sbf_subs_block_recursive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_subs_block_recursive.md),
[`sbf_subs_data_recursive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_subs_data_recursive.md),
[`sbf_subs_number_recursive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_subs_number_recursive.md),
[`sbf_subs_object_recursive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_subs_object_recursive.md),
[`sbf_subs_plot_recursive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_subs_plot_recursive.md),
[`sbf_subs_string_recursive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_subs_string_recursive.md),
[`sbf_subs_table_recursive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_subs_table_recursive.md),
[`sbf_subs_window_recursive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_subs_window_recursive.md)
