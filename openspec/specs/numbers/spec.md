# Numbers Specification

## Purpose

Persist numeric scalars for use in reports. Each number is saved as an
`.rds` file plus a `.csv` file and a `.rda` metadata file under
`<main>/numbers/<sub>/`.

## Requirements

### Requirement: Saving a number

`sbf_save_number()` SHALL accept a scalar number `x`, coerce it to
double, round it to `signif` significant digits (default 22), and
write three files: `<x_name>.rds`, `<x_name>.csv` (a one-row data
frame with column `x`) and `<x_name>.rda` (metadata list). The
metadata list SHALL contain `report` (logical) and `tag` (character
string).

#### Scenario: Default save

- **WHEN** the user calls `sbf_save_number(3.14159, x_name = "pi")`
- **THEN** the files `output/numbers/pi.rds`, `output/numbers/pi.csv`
  and `output/numbers/pi.rda` all exist
- **AND** the `.rda` metadata has `report = TRUE` and `tag = ""`

#### Scenario: Custom report metadata

- **WHEN** the user calls `sbf_save_number(42, report = FALSE,
  tag = "internal")`
- **THEN** the `.rda` metadata has `report = FALSE` and `tag = "internal"`

#### Scenario: Non-number input

- **WHEN** the user calls `sbf_save_number("text")`
- **THEN** the function errors

### Requirement: Loading a number

`sbf_load_number()` SHALL return the numeric scalar stored at
`<main>/numbers/<sub>/<x_name>.rds`, with `exists` semantics as per
`sbf_load_object()`.

#### Scenario: Round-trip

- **GIVEN** `sbf_save_number(42, x_name = "answer")` was called
- **WHEN** the user calls `sbf_load_number("answer")`
- **THEN** the return value is `42`

### Requirement: Bulk save numbers

`sbf_save_numbers()` SHALL iterate over the supplied environment and
save every binding that satisfies the package's `is_number` predicate
(a length-one numeric) using `sbf_save_number()`. Non-matching
bindings SHALL be skipped; when no numbers are present, a warning is
emitted.

#### Scenario: Mixed environment

- **GIVEN** the calling frame contains `a <- 1`, `b <- "x"`
- **WHEN** the user calls `sbf_save_numbers()`
- **THEN** `output/numbers/a.rds` is written
- **AND** `b` is not saved

### Requirement: Bulk load numbers

`sbf_load_numbers()` SHALL read every `.rds` file in `numbers/<sub>/`
and assign the value to the target environment, with optional `rename`
function.

#### Scenario: Loading numbers

- **GIVEN** `output/numbers/a.rds` exists containing `1`
- **WHEN** the user calls `sbf_load_numbers()` from an empty frame
- **THEN** `a` is bound to `1`

### Requirement: Recursive load as numeric column

`sbf_load_numbers_recursive()` SHALL return a tibble with a numeric
column `numbers` and metadata columns `name`, `sub`, `file`. When
`meta = TRUE`, additional columns from the `.rda` metadata (including
`report` and `tag`) SHALL be appended. The `tag` argument MAY restrict
results to rows whose metadata tag matches the given regular
expression.

#### Scenario: Meta columns

- **GIVEN** one number was saved with `report = FALSE, tag = "internal"`
- **WHEN** the user calls `sbf_load_numbers_recursive(meta = TRUE)`
- **THEN** the returned tibble includes `report` and `tag` columns

### Requirement: Listing, path, and subs

`sbf_list_numbers()` SHALL list number files and allow `ext` of
`"rds"` or `"csv"`. `sbf_path_number()` SHALL return the canonical
path with those same extensions permitted. `sbf_subs_number_recursive()`
SHALL return the sub folders containing a given number name.

#### Scenario: Listing CSV sidecars

- **GIVEN** `output/numbers/pi.csv` exists
- **WHEN** the user calls `sbf_list_numbers(ext = "csv")`
- **THEN** the result includes that path

### Requirement: Number existence check (deprecated)

`sbf_number_exists()` SHALL return whether the `.rds` file exists and
emit a soft deprecation notice referencing version `0.0.0.9045`.

#### Scenario: Checking presence

- **GIVEN** a number `"answer"` has been saved
- **WHEN** the user calls `sbf_number_exists("answer")`
- **THEN** the function returns `TRUE`
- **AND** emits a lifecycle soft-deprecation notice
