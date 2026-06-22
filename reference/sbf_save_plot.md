# Save Plot

Saves a ggplot object. By default it saves the last plot to be modified
or created.

## Usage

``` r
sbf_save_plot(
  x = ggplot2::last_plot(),
  x_name = substitute(x),
  sub = sbf_get_sub(),
  main = sbf_get_main(),
  caption = "",
  report = TRUE,
  tag = "",
  units = "in",
  width = NA,
  height = width,
  dpi = 300,
  limitsize = TRUE,
  csv = 1000L,
  drop_uninformative_cols = TRUE
)
```

## Arguments

- x:

  The ggplot object to save.

- x_name:

  A string of the name.

- sub:

  A string specifying the path to the sub folder (by default the current
  sub folder).

- main:

  A string specifying the path to the main folder (by default the
  current main folder)

- caption:

  A string of the caption.

- report:

  A flag specifying whether to include in a report.

- tag:

  A string of the tag.

- units:

  A string of the units. Can be "in" (default) or "mm" or "cm".

- width:

  A number of the plot width in inches.

- height:

  A number of the plot width in inches.

- dpi:

  A number of the resolution in dots per inch.

- limitsize:

  When `TRUE` (the default),
  [`ggsave()`](https://ggplot2.tidyverse.org/reference/ggsave.html) will
  not save images larger than 50x50 inches, to prevent the common error
  of specifying dimensions in pixels.

- csv:

  A count specifying the maximum number of rows to save as a csv file.

- drop_uninformative_cols:

  A flag indicating whether to drop uninformative columns via
  [`tidyplus::drop_uninformative_columns()`](https://poissonconsulting.github.io/tidyplus/reference/drop_uninformative_columns.html)
  (`TRUE`; default) or not (`FALSE`). Currently soft-deprecated. Will be
  fully deprecated in future versions so that uninformative columns are
  always dropped in csv files and always kept in xlsx files.

## Details

The function saves:

1.  A `png` file of the plot.

2.  An `rda` file of the plot metadata.

3.  An `rds` file of the plot.

4.  A `csv` of the data passed to
    [`ggplot()`](https://ggplot2.tidyverse.org/reference/ggplot.html),
    provided it has at least one row and no more than `csv` rows. If `x`
    is a `patchwork` object, only the data for the first patch is saved,
    to maintain compatibility with previous versions.

5.  An `xlsx` workbook with a sheet for the data passed to each
    [`ggplot()`](https://ggplot2.tidyverse.org/reference/ggplot.html)
    call and a sheet for each geom layer. Sheets are labelled
    `<p>_<l>_<geom>`, where `<p>` is the patch index (1 for a simple
    `ggplot`), `<l>` is the layer index (`0` for the
    [`ggplot()`](https://ggplot2.tidyverse.org/reference/ggplot.html)
    data), and `<geom>` is the layer type (e.g. `point`, `line`). Layers
    with more than `csv` rows are omitted.

The `csv` and `xlsx` files are named using the `x_name` argument. Not
specifying `x` overwrites existing files that used `x_name = "plot"`.

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
[`sbf_save_png()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_png.md),
[`sbf_save_spatial()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_spatial.md),
[`sbf_save_spatials()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_spatials.md),
[`sbf_save_string()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_string.md),
[`sbf_save_strings()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_strings.md),
[`sbf_save_table()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_table.md),
[`sbf_save_window()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_window.md),
[`sbf_save_workbook()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_workbook.md)

## Examples

``` r
if (FALSE) { # \dontrun{
require(ggplot2)
require(patchwork)
ggplot(mtcars) +
  geom_line(aes(mpg, cyl, color = cyl), mtcars) +
  ggtitle("1")
sbf_save_plot()

p_patches <-
  ((ggplot(mtcars) +
      geom_line(aes(mpg, cyl, color = cyl), mtcars) +
      ggtitle("1")) +
     (ggplot() +
        geom_line(aes(Sepal.Length, Petal.Length), iris) +
        ggtitle("2"))) /
  ((ggplot() +
      geom_point(aes(mpg, cyl, color = cyl), mtcars) +
      ggtitle("3")) +
     ((ggplot(iris) +
         geom_point(aes(Sepal.Length, Petal.Length)) +
         ggtitle("4")) +
        (ggplot() +
           geom_point(aes(Sepal.Length, Petal.Length, color = Species),
                      iris) +
           ggtitle("5") +
           theme(legend.position = "none"))))
p_patches
sbf_save_plot(p_patches)
} # }
```
