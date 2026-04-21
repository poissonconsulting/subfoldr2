# Excel Export Specification

## Purpose

Export data frames as Excel (`.xlsx`) workbooks under
`<main>/excel/<sub>/`. Spatial columns are flattened before export
(non-point `sfc` columns dropped; point columns decomposed into
`_X`/`_Y`/`_Z` coordinate columns; `blob` columns dropped). Large
data frames exceeding Excel's row limit can be split across sheets.

## Requirements

### Requirement: Default workbook name helper

`sbf_get_workbook_name()` SHALL return the basename of the current
working directory.

#### Scenario: Default workbook name

- **WHEN** the user calls `sbf_get_workbook_name()` with a working
  directory named `"analysis"`
- **THEN** the function returns `"analysis"`

### Requirement: Saving a single data frame as its own workbook

`sbf_save_excel()` SHALL validate that `x` inherits from
`data.frame`, then:

- Process spatial columns via the package's `process_sf_columns()`
  helper (converting point geometries to coordinate columns,
  dropping non-point `sfc` columns and `blob` columns). An
  optional `epgs` argument SHALL reproject point geometries to the
  given EPSG code before extracting coordinates.
- Split the data frame across up to `max_sheets` sheets
  (default `1L`) when row count exceeds Excel's 1,048,576 row limit.
- Write `<main>/excel/<sub>/<x_name>.xlsx` and a companion `.rds`.

#### Scenario: Small data frame

- **WHEN** the user calls `sbf_save_excel(iris, x_name = "iris")`
- **THEN** `output/excel/iris.xlsx` and `output/excel/iris.rds` exist

#### Scenario: Splitting a large data frame

- **GIVEN** a data frame `big` with 2,100,000 rows
- **WHEN** the user calls `sbf_save_excel(big, x_name = "big",
  max_sheets = 3L)`
- **THEN** the workbook contains 3 sheets named `big_1`, `big_2`,
  `big_3`

### Requirement: Bulk save data frames as individual workbooks

`sbf_save_excels()` SHALL iterate over the supplied environment and
save every data frame binding via `sbf_save_excel()`.

#### Scenario: Bulk save

- **GIVEN** the calling frame contains data frames `a` and `b`
- **WHEN** the user calls `sbf_save_excels()`
- **THEN** `output/excel/a.xlsx` and `output/excel/b.xlsx` are both
  written

### Requirement: Combining data frames into a single workbook

`sbf_save_workbook()` SHALL iterate over the supplied environment,
collect every data frame binding into a named list, and write one
workbook `<main>/excel/<sub>/<workbook_name>.xlsx` with one sheet per
data frame, plus a companion `.rds`. Spatial columns SHALL be
flattened as described in `sbf_save_excel()`.

#### Scenario: Multiple frames into one workbook

- **GIVEN** the calling frame contains `a` and `b`
- **WHEN** the user calls `sbf_save_workbook(workbook_name = "all")`
- **THEN** `output/excel/all.xlsx` contains sheets `a` and `b`

### Requirement: Converting a database to a workbook

`sbf_save_db_to_workbook()` SHALL open the canonical SQLite database,
read all tables via `readwritesqlite::rws_read()`, optionally filter
tables out by a regular expression `exclude_tables` (default
`"^$"`, matching nothing), and write the remaining tables to a
single Excel workbook at
`<main>/excel/<sub>/<workbook_name>.xlsx`.

#### Scenario: Export with exclusion

- **GIVEN** a database with tables `sites`, `species`, and
  `captures`
- **WHEN** the user calls
  `sbf_save_db_to_workbook(exclude_tables = "sites|species")`
- **THEN** the resulting workbook contains only the `captures` sheet

### Requirement: Writing data frames to an arbitrary xlsx path

`sbf_write_datas_to_xlsx()` SHALL write every data frame in the
supplied environment to the given `.xlsx` path as separate sheets
named after each binding. When the target file exists and
`exists = FALSE`, the function SHALL optionally prompt to delete it.
When no data frames are present, the function SHALL warn and return
an empty character vector.

#### Scenario: Writing to an arbitrary path

- **GIVEN** the calling frame contains `a` and `b` data frames
- **WHEN** the user calls
  `sbf_write_datas_to_xlsx("combined.xlsx")`
- **THEN** `combined.xlsx` exists with sheets `a` and `b`
