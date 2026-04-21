# Strings Specification

## Purpose

Persist inline text strings (length-one character vectors) together
with report metadata. Each string is saved as an `.rds`, a `.txt` and
an `.rda` file under `<main>/strings/<sub>/`.

## Requirements

### Requirement: Saving a string

`sbf_save_string()` SHALL validate that `x` is a string (length-one
non-`NA` character) and write three files: `<x_name>.rds`,
`<x_name>.txt` and `<x_name>.rda`. The `.rda` metadata SHALL contain
`report` (logical, default `TRUE`) and `tag` (character, default
`""`).

#### Scenario: Default save

- **WHEN** the user calls `sbf_save_string("hello", x_name = "greet")`
- **THEN** the files `output/strings/greet.rds`,
  `output/strings/greet.txt` and `output/strings/greet.rda` exist
- **AND** the `.txt` file contains the single line `hello`

#### Scenario: Non-string input

- **WHEN** the user calls `sbf_save_string(c("a", "b"))`
- **THEN** the function errors

### Requirement: Loading a string

`sbf_load_string()` SHALL return the string stored at
`<main>/strings/<sub>/<x_name>.rds`, with the same `exists` semantics
as `sbf_load_object()`.

#### Scenario: Round-trip

- **GIVEN** `sbf_save_string("hi", x_name = "s")` was called
- **WHEN** the user calls `sbf_load_string("s")`
- **THEN** the returned value equals `"hi"`

### Requirement: Bulk save and load strings

`sbf_save_strings()` SHALL save every binding in the supplied
environment that the package's `is_string` predicate identifies as a
string. `sbf_load_strings()` SHALL read every `.rds` file in
`strings/<sub>/` into the target environment with an optional
`rename` function.

#### Scenario: Mixed environment save

- **GIVEN** the calling frame contains `a <- "x"` and `b <- 1`
- **WHEN** the user calls `sbf_save_strings()`
- **THEN** `output/strings/a.rds` is written
- **AND** `b` is not saved

### Requirement: Recursive load as character column

`sbf_load_strings_recursive()` SHALL return a tibble with a character
column `strings` and metadata columns `name`, `sub`, `file`. When
`meta = TRUE`, columns including `report` and `tag` SHALL be appended.
The `tag` argument MAY filter rows by regex match on the metadata tag.
When no strings match, the function SHALL return an empty tibble.

#### Scenario: Tag filter

- **GIVEN** two strings saved with tags `"a"` and `"b"`
- **WHEN** the user calls `sbf_load_strings_recursive(tag = "^a$")`
- **THEN** the result includes only the row tagged `"a"`

### Requirement: Listing, path, and subs

`sbf_list_strings()` SHALL list string files with `ext` of `"rds"` or
`"txt"`. `sbf_path_string()` SHALL resolve the canonical path with
those same extensions. `sbf_subs_string_recursive()` SHALL return sub
folder paths containing a string with the given name.

#### Scenario: Listing TXT sidecars

- **GIVEN** `output/strings/greet.txt` exists
- **WHEN** the user calls `sbf_list_strings(ext = "txt")`
- **THEN** the result includes that path

### Requirement: String existence check (deprecated)

`sbf_string_exists()` SHALL return whether the `.rds` file exists and
emit a soft deprecation notice referencing version `0.0.0.9045`.

#### Scenario: Existing string

- **GIVEN** a string `"s"` was saved
- **WHEN** the user calls `sbf_string_exists("s")`
- **THEN** the function returns `TRUE`
- **AND** emits a lifecycle soft-deprecation notice
