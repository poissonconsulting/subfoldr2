# Load Number

Load Number

## Usage

``` r
sbf_load_number(
  x_name,
  sub = sbf_get_sub(),
  main = sbf_get_main(),
  exists = TRUE
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

- exists:

  A logical scalar specifying whether the file should exist.

## Value

A number or NULL if doesn't exist.

## See also

Other load functions:
[`load_rdss_recursive()`](https://poissonconsulting.github.io/subfoldr2/reference/load_rdss_recursive.md),
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
[`sbf_load_numbers()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_numbers.md),
[`sbf_load_numbers_recursive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_numbers_recursive.md),
[`sbf_load_object()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_object.md),
[`sbf_load_objects()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_objects.md),
[`sbf_load_objects_recursive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_objects_recursive.md),
[`sbf_load_plot()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_plot.md),
[`sbf_load_plot_data()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_plot_data.md),
[`sbf_load_plots_data()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_plots_data.md),
[`sbf_load_plots_data_recursive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_plots_data_recursive.md),
[`sbf_load_plots_recursive()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_load_plots_recursive.md),
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
