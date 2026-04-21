# Main Folder Specification

## Purpose

The main folder is the top-level directory under which all other subfoldr2
artefact class subdirectories (`objects/`, `data/`, `plots/`, etc.) are
created. It is addressable via an R option so that callers do not need to
thread an explicit path through every save/load call.

## Requirements

### Requirement: Current main folder is resolvable from options

`sbf_get_main()` SHALL return the value of the R option `sbf.main`, or the
default string `"output"` when the option is not set, sanitised as a
relative or absolute filesystem path.

#### Scenario: Default main folder

- **WHEN** a user calls `sbf_get_main()` after a fresh package load
- **THEN** the function returns the string `"output"`

#### Scenario: Option overrides default

- **WHEN** the option `sbf.main` is set to `"my/out"`
- **AND** the user calls `sbf_get_main()`
- **THEN** the function returns `"my/out"`

### Requirement: Main folder can be set

`sbf_set_main()` SHALL accept one or more character vectors, combine them
into a single path, sanitise that path, store it in the `sbf.main` option,
and invisibly return the resulting path.

#### Scenario: Setting a multi-segment path

- **WHEN** the user calls `sbf_set_main("analysis", "output")`
- **THEN** subsequent calls to `sbf_get_main()` return `"analysis/output"`
- **AND** the path is created on disk the next time an artefact is written
  to it

### Requirement: Main folder can be removed

`sbf_rm_main()` SHALL recursively delete the main folder on disk,
optionally prompting the user when `ask = TRUE`, and invisibly return the
path that was targeted.

#### Scenario: Deleting an existing main folder without prompting

- **GIVEN** the main folder exists on disk
- **WHEN** the user calls `sbf_rm_main(ask = FALSE)`
- **THEN** the folder and all its contents are removed
- **AND** a success message is emitted

#### Scenario: Non-existent main folder

- **GIVEN** the main folder does not exist on disk
- **WHEN** the user calls `sbf_rm_main()`
- **THEN** no files are deleted
- **AND** the function returns invisibly without error

### Requirement: Main folder can be reset to the default

`sbf_reset_main()` SHALL reset the `sbf.main` option to `"output"` and
invisibly return `"output"`. It MAY additionally remove the previous main
folder when `rm = TRUE`.

#### Scenario: Resetting after a custom set

- **GIVEN** `sbf_set_main("custom")` was previously called
- **WHEN** the user calls `sbf_reset_main()`
- **THEN** `sbf_get_main()` returns `"output"`

### Requirement: Combined reset helper

`sbf_reset()` SHALL invoke `sbf_reset_db_name()`, `sbf_reset_sub()`, and
`sbf_reset_main()` in that order and invisibly return `NULL`.

#### Scenario: Full reset from a customised state

- **GIVEN** `sbf.main`, `sbf.sub`, and `sbf.db_name` have all been
  customised
- **WHEN** the user calls `sbf_reset()`
- **THEN** `sbf_get_main()` returns `"output"`
- **AND** `sbf_get_sub()` returns a length-zero character vector
- **AND** `sbf_get_db_name()` returns `"database"`
