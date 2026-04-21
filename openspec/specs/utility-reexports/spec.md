# Utility Helpers and Re-exports Specification

## Purpose

Miscellaneous utility helpers that support the rest of the package
but do not belong to a single artefact class.

## Requirements

### Requirement: Basename without extension

`sbf_basename_sans_ext()` SHALL return the basename of the supplied
file paths with any extension stripped, by composing
`basename()` and `tools::file_path_sans_ext()`.

#### Scenario: Basic path

- **WHEN** the user calls `sbf_basename_sans_ext("path/file.ext")`
- **THEN** the function returns `"file"`

#### Scenario: Vectorised input

- **WHEN** the user calls
  `sbf_basename_sans_ext(c("a/b.rds", "c.csv"))`
- **THEN** the function returns `c("b", "c")`

### Requirement: Re-exporting `dttr2::dtt_default_tz`

The `dtt_default_tz()` function from the `dttr2` package SHALL be
re-exported so that subfoldr2 consumers can reference the default
time zone without directly importing `dttr2`.

#### Scenario: Re-export available

- **WHEN** the user calls `subfoldr2::dtt_default_tz()`
- **THEN** the call succeeds and returns a time-zone string
