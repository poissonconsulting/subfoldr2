# Tables Specification

## Purpose

Persist data frames intended for report tables, together with caption
and report metadata. Tables are stored as `.rds`, `.csv` and `.rda`
files under `<main>/tables/<sub>/`.

## Requirements

### Requirement: Saving a report table

`sbf_save_table()` SHALL validate that `x` is a data frame with only
logical, numeric, character, factor, `Date`, `hms` or `POSIXct`
columns. It SHALL then write `<x_name>.rds`, `<x_name>.csv` and
`<x_name>.rda`. The `.rda` metadata SHALL contain `caption` (default
`""`), `report` (default `TRUE`) and `tag` (default `""`).

#### Scenario: Valid table

- **WHEN** the user calls `sbf_save_table(df, x_name = "t",
  caption = "Summary")`
- **THEN** the files `output/tables/t.rds`, `output/tables/t.csv` and
  `output/tables/t.rda` all exist
- **AND** the `.rda` metadata has `caption = "Summary"`

#### Scenario: Unsupported column types

- **WHEN** the user calls `sbf_save_table(data.frame(x = list(1, 2)))`
- **THEN** the function errors naming the offending column

### Requirement: Loading a table

`sbf_load_table()` SHALL return the data frame stored at
`<main>/tables/<sub>/<x_name>.rds`, with the same `exists` semantics
as `sbf_load_object()`.

#### Scenario: Round-trip

- **GIVEN** `sbf_save_table(df, x_name = "t")` was called
- **WHEN** the user calls `sbf_load_table("t")`
- **THEN** the returned data frame equals the original

### Requirement: No bulk save for tables

The package SHALL NOT provide a bulk save function for tables because each table carries per-table caption metadata; callers SHALL invoke `sbf_save_table()` for each table individually.

#### Scenario: Bulk save is absent

- **WHEN** a user inspects the package namespace
- **THEN** no `sbf_save_tables()` function is exported

### Requirement: Bulk load tables

`sbf_load_tables()` SHALL read every `.rds` file in `tables/<sub>/`
into the target environment.

#### Scenario: Loading all tables

- **GIVEN** `output/tables/t.rds` exists
- **WHEN** the user calls `sbf_load_tables()` from an empty frame
- **THEN** `t` is bound in that frame

### Requirement: Recursive load as list column

`sbf_load_tables_recursive()` SHALL return a tibble with a list
column `tables` of the deserialised data frames plus `name`, `sub`,
`file`. When `meta = TRUE`, `caption`, `report` and `tag` SHALL be
appended; the `tag` argument MAY filter rows by regex.

#### Scenario: Recursive load with meta

- **GIVEN** tables exist in the root and a sub folder
- **WHEN** the user calls `sbf_load_tables_recursive(meta = TRUE)`
- **THEN** the tibble includes `caption`, `report`, `tag`

### Requirement: Listing, path, and subs

`sbf_list_tables()` SHALL accept `ext` of `"rds"` or `"csv"`.
`sbf_path_table()` SHALL resolve the canonical path with those
extensions. `sbf_subs_table_recursive()` SHALL return sub folders
containing a table with the given name.

#### Scenario: Listing CSV sidecars

- **GIVEN** `output/tables/t.csv` exists
- **WHEN** the user calls `sbf_list_tables(ext = "csv")`
- **THEN** the result includes that path

### Requirement: Table existence check (deprecated)

`sbf_table_exists()` SHALL return whether the `.rds` file exists and
emit a soft deprecation notice referencing version `0.0.0.9045`.

#### Scenario: Existing table

- **GIVEN** a table `"t"` was saved
- **WHEN** the user calls `sbf_table_exists("t")`
- **THEN** the function returns `TRUE`
- **AND** emits a lifecycle soft-deprecation notice
