# Plots Specification

## Purpose

Persist ggplot objects for inclusion in reports. Each plot produces a
PNG render plus an `.rds` serialisation and `.rda` metadata file. A
CSV of the plot's default data set is also saved when the data set
has no more than `csv` rows. Files are written under
`<main>/plots/<sub>/`.

## Requirements

### Requirement: Saving a ggplot

`sbf_save_plot()` SHALL validate that `x` inherits from `ggplot` and
then:

- Render the plot to `<x_name>.png` using `ggplot2::ggsave()` at the
  supplied `width`/`height`/`dpi` (dimensions resolved by the package's
  `plot_size()` helper when `width`/`height` are `NA`).
- Write `<x_name>.rds` with the ggplot object.
- Write `<x_name>.rda` with metadata `caption`, `report`, `tag`,
  `width`, `height`, `dpi`.
- Optionally write `<x_name>.csv` with the plot's default data frame
  when present and `nrow(data) <= csv` (default `csv = 1000L`). The
  `tidyplus::drop_uninformative_columns()` helper SHALL be applied
  before writing.

#### Scenario: Saving the last plot

- **GIVEN** a ggplot object is the most recently created plot
- **WHEN** the user calls `sbf_save_plot(width = 6, height = 4)`
- **THEN** `output/plots/plot.png`, `output/plots/plot.rds`, and
  `output/plots/plot.rda` exist

#### Scenario: Small data set triggers CSV sidecar

- **GIVEN** the ggplot's default data has 10 rows
- **WHEN** the user calls `sbf_save_plot(x_name = "p", csv = 1000L)`
- **THEN** `output/plots/p.csv` is written

#### Scenario: Large data set skips CSV

- **GIVEN** the ggplot's default data has 2000 rows
- **WHEN** the user calls `sbf_save_plot(x_name = "p", csv = 1000L)`
- **THEN** `output/plots/p.csv` is NOT written

#### Scenario: Default x_name from last_plot()

- **WHEN** the user calls `sbf_save_plot()` without specifying `x_name`
- **THEN** the stored files are named `plot.*`

### Requirement: Loading a plot

`sbf_load_plot()` SHALL return the ggplot object stored at
`<main>/plots/<sub>/<x_name>.rds`, with the same `exists` semantics as
`sbf_load_object()`. `sbf_load_plot_data()` SHALL return only the
plot's default data frame (via the package's internal `get_plot_data`
helper).

#### Scenario: Load returns a ggplot

- **GIVEN** `sbf_save_plot()` produced `output/plots/plot.rds`
- **WHEN** the user calls `sbf_load_plot("plot")`
- **THEN** the returned object inherits from class `"ggplot"`

#### Scenario: Load only plot data

- **GIVEN** `output/plots/plot.rds` exists
- **WHEN** the user calls `sbf_load_plot_data("plot")`
- **THEN** the returned object is the default data frame

### Requirement: Recursive plot loading

`sbf_load_plots_recursive()` SHALL return a tibble with list column
`plots` of ggplot objects plus `name`, `sub`, `file`, optionally
appended with meta columns (`caption`, `report`, `tag`, `width`,
`height`, `dpi`). `sbf_load_plots_data_recursive()` SHALL return the
same shape but with the list column named `plots_data` containing the
plots' default data frames.

#### Scenario: Recursive plots

- **GIVEN** two plots exist in the `plots/` tree
- **WHEN** the user calls `sbf_load_plots_recursive(meta = TRUE)`
- **THEN** the tibble has one row per plot with meta columns

### Requirement: Bulk load of plot data only

`sbf_load_plots_data()` SHALL read every plot `.rds` in
`plots/<sub>/`, extract its default data frame via `get_plot_data`,
and assign the data frames into the target environment using the base
plot names (optionally transformed by `rename`).

#### Scenario: Loading data frames for all plots

- **GIVEN** `output/plots/a.rds` and `output/plots/b.rds` exist
- **WHEN** the user calls `sbf_load_plots_data()` from an empty frame
- **THEN** bindings `a` and `b` hold the respective plots' data frames

### Requirement: Listing, path, and subs

`sbf_list_plots()` SHALL accept `ext` of `"rds"` or `"png"`.
`sbf_path_plot()` SHALL resolve the canonical path with those same
extensions. `sbf_subs_plot_recursive()` SHALL return sub folders
containing a plot with the given name.

#### Scenario: Listing PNG renders

- **GIVEN** `output/plots/plot.png` exists
- **WHEN** the user calls `sbf_list_plots(ext = "png")`
- **THEN** the result includes that path

### Requirement: Plot existence check (deprecated)

`sbf_plot_exists()` SHALL return whether the `.rds` file exists and
emit a soft deprecation notice referencing version `0.0.0.9045`.

#### Scenario: Existing plot

- **GIVEN** a plot `"p"` was saved
- **WHEN** the user calls `sbf_plot_exists("p")`
- **THEN** the function returns `TRUE`
- **AND** emits a lifecycle soft-deprecation notice

### Requirement: Retry-printing a ggplot

`sbf_print()` SHALL call `print()` on a ggplot object and, if a
recoverable grid error occurs (text matching "cannot pop the top-level
viewport" or "no applicable method for 'depth'"), retry printing up to
`ntry` times (default 3, via `options(sbf.ntry = )`). When
`plot = FALSE` (via `options(sbf.plot = )`) the function SHALL return
invisibly without printing. If `ntry` attempts all fail, the function
SHALL propagate the last non-recoverable error message.

#### Scenario: Successful first print

- **WHEN** the user calls `sbf_print(p)` on a ggplot that prints cleanly
- **THEN** the plot renders and the function returns `p` invisibly

#### Scenario: Plot disabled via option

- **GIVEN** `options(sbf.plot = FALSE)` is set
- **WHEN** the user calls `sbf_print(p)`
- **THEN** the function returns invisibly without drawing
