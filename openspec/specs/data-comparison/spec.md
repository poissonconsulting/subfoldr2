# Data Comparison Specification

## Purpose

Compare data frames against previously saved or archived copies to
detect differences introduced by re-runs of a pipeline. Provides
waldo, daff, and `all.equal()`-based comparison helpers.

## Requirements

### Requirement: Waldo comparison against saved data

`sbf_compare_data()` SHALL load the current saved data frame with the
same `x_name` (using `sbf_load_data(exists = NA)`), then call
`waldo::compare(existing, x, x_arg = "saved", y_arg = "current",
tolerance, ignore_attr)` and return the result. When no saved data
exists, the saved side is `NULL`.

#### Scenario: Comparing against saved data

- **GIVEN** `output/data/df.rds` exists
- **WHEN** the user calls `sbf_compare_data(df2, x_name = "df")`
- **THEN** the return value is a `waldo_compare` result comparing
  the two

### Requirement: Waldo comparison against an archive

`sbf_compare_data_archive()` SHALL list all data files matching the
regular expression `x_name` in both the current main folder and the
`archive`-th archived folder, unioning the file names. For each
unique file name, the function SHALL run
`waldo::compare()` on the pair (loading `NULL` when a side is
missing) and return a named list of `waldo_compare` results.
`archive` MAY be an integer index (delegated to
`sbf_get_archive()`) or a directory path.

#### Scenario: Empty comparison set

- **GIVEN** neither the main folder nor the archive contain matching
  data files
- **WHEN** the user calls `sbf_compare_data_archive()`
- **THEN** the function returns an empty named list

### Requirement: Daff diff against saved data

`sbf_diff_data()` SHALL load the current saved data frame and return
`daff::diff_data(existing, x)`. When no saved data exists, `x` SHALL
be compared against itself.

#### Scenario: No existing data

- **GIVEN** no saved file matches `"df"`
- **WHEN** the user calls `sbf_diff_data(df, x_name = "df")`
- **THEN** the daff diff indicates no differences

### Requirement: Daff diff against an archive

`sbf_diff_data_archive()` SHALL mirror the archive-listing behaviour
of `sbf_compare_data_archive()` but use `daff::diff_data()` instead
of `waldo::compare()`. When a side is missing (and `exists = NA`),
the present side SHALL be diffed against itself.

#### Scenario: Archive-only data

- **GIVEN** one data file exists only in the archive
- **WHEN** the user calls `sbf_diff_data_archive()`
- **THEN** the returned named list includes a diff for that file

### Requirement: Daff diff for tables

`sbf_diff_table()` SHALL load the saved table with the same
`x_name` via `sbf_load_table(exists = )`, defaulting `exists = NA`
so that a missing saved copy does not error; the function then
returns `daff::diff_data(existing, x)`, falling back to `x` vs. `x`
when no saved copy exists.

#### Scenario: Diffing against an existing table

- **GIVEN** `output/tables/t.rds` exists
- **WHEN** the user calls `sbf_diff_table(new_t, x_name = "t")`
- **THEN** the return value is a daff diff object

### Requirement: Equality check against saved data

`sbf_is_equal_data()` SHALL load the saved data frame and run
`all.equal(existing, x, tolerance, check.attributes)`, returning a
single named logical flag whose name is the relative file path. When
no saved data exists, the function SHALL return `!exists` (so
`exists = TRUE` produces `FALSE` and `exists = FALSE` produces
`TRUE`), named by the expected relative file path.

#### Scenario: Equal data

- **GIVEN** `output/data/df.rds` exists and equals `df`
- **WHEN** the user calls `sbf_is_equal_data(df, x_name = "df")`
- **THEN** the function returns `TRUE` named by the relative path

### Requirement: Equality check against an archive

`sbf_is_equal_data_archive()` SHALL return a named logical vector
indexed by file name, where shared files are compared with
`all.equal()` and files present in only one side receive `!exists`.

#### Scenario: Exclusive files

- **GIVEN** one file present only in the main folder and one only in
  the archive
- **WHEN** the user calls
  `sbf_is_equal_data_archive(exists = TRUE)`
- **THEN** both files receive the value `FALSE` in the returned
  vector
