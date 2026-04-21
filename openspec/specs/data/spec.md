# Data Frames Specification

## Purpose

Save and load arbitrary data frames under `<main>/data/<sub>/`. Data
frames are stored as `.rds` files without sidecar metadata.

## Requirements

### Requirement: Saving a data frame

`sbf_save_data()` SHALL validate that `x` inherits from `data.frame`,
then write `x` as `<main>/data/<sub>/<x_name>.rds` and invisibly return
the saved path.

#### Scenario: Valid data frame

- **WHEN** the user calls `sbf_save_data(iris, x_name = "iris")`
- **THEN** the file `output/data/iris.rds` exists and deserialises to
  a data frame with the same content

#### Scenario: Non-data-frame input

- **WHEN** the user calls `sbf_save_data(1:5)`
- **THEN** the function errors

### Requirement: Loading a data frame

`sbf_load_data()` SHALL read the `.rds` file at
`<main>/data/<sub>/<x_name>.rds` and return the deserialised data
frame. The same `exists` semantics defined for `sbf_load_object()`
SHALL apply.

#### Scenario: Round-trip

- **GIVEN** `sbf_save_data(iris, x_name = "iris")` was called
- **WHEN** the user calls `sbf_load_data("iris")`
- **THEN** the returned data frame equals the original

### Requirement: Bulk save data frames

`sbf_save_datas()` SHALL save every `data.frame` binding in the
supplied environment (default: caller frame) using `sbf_save_data()`.
Non-data-frame bindings SHALL be skipped. When no data frames are
present, a warning is emitted.

#### Scenario: Mixed environment

- **GIVEN** the calling frame has `df <- data.frame(x = 1)` and
  `v <- 1:3`
- **WHEN** the user calls `sbf_save_datas()`
- **THEN** `output/data/df.rds` is written
- **AND** `v` is not saved

### Requirement: Bulk load data frames

`sbf_load_datas()` SHALL read every `.rds` file directly within
`data/<sub>/` and assign each to the target environment. A `rename`
function MAY transform the binding names.

#### Scenario: Loading all saved data frames

- **GIVEN** `output/data/df.rds` exists
- **WHEN** the user calls `sbf_load_datas()` from an empty frame
- **THEN** `df` is bound in that frame

### Requirement: Recursive load as list column

`sbf_load_datas_recursive()` SHALL return a tibble with a list column
`data` containing the deserialised data frames and metadata columns
`name`, `sub`, `file`, matching the behaviour of
`sbf_load_objects_recursive()`.

#### Scenario: Recursive load

- **GIVEN** `output/data/a.rds` and `output/data/sub/b.rds` exist
- **WHEN** the user calls `sbf_load_datas_recursive()`
- **THEN** the result contains two rows

### Requirement: Listing and pathing data files

`sbf_list_datas()` SHALL mirror the listing behaviour of
`sbf_list_objects()` for the `data/` class and only permit
`ext = "rds"`. `sbf_path_data()` SHALL return the canonical path
with the same `exists` semantics as `sbf_path_object()` and only
permit `ext = "rds"`.

#### Scenario: Listing existing data files

- **GIVEN** `output/data/df.rds` exists
- **WHEN** the user calls `sbf_list_datas()`
- **THEN** the result includes that path

### Requirement: Recursive sub listing by data name

`sbf_subs_data_recursive()` SHALL return the sub folder paths (relative
to `data/<sub>/`) that contain an `.rds` file with base name equal to
`x_name`.

#### Scenario: Finding subs

- **GIVEN** `output/data/df.rds` and `output/data/a/df.rds` exist
- **WHEN** the user calls `sbf_subs_data_recursive("df")`
- **THEN** the result contains the sub paths for those files

### Requirement: Data existence check (deprecated)

`sbf_data_exists()` SHALL return whether the `.rds` file exists and
emit a soft deprecation notice referencing version `0.0.0.9045`.

#### Scenario: Existing data

- **GIVEN** `sbf_save_data(df)` was called
- **WHEN** the user calls `sbf_data_exists("df")`
- **THEN** the function returns `TRUE`
- **AND** emits a lifecycle soft-deprecation notice
