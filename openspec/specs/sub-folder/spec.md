# Sub Folder Specification

## Purpose

The sub folder is the current path (relative to each artefact class
directory) that save and load helpers default to. It allows callers to
organise artefacts hierarchically without passing `sub = ` on every call.

## Requirements

### Requirement: Current sub folder is resolvable from options

`sbf_get_sub()` SHALL return the value of the R option `sbf.sub`,
sanitised as a relative path, or a length-zero character vector when the
option is unset.

#### Scenario: Default sub folder is empty

- **WHEN** the user calls `sbf_get_sub()` after a fresh package load
- **THEN** the function returns `character(0)`

### Requirement: Sub folder can be set

`sbf_set_sub()` SHALL accept one or more character vectors, combine them
with `/` separators, sanitise the result, store it in the `sbf.sub`
option, and invisibly return the resulting path.

#### Scenario: Single segment

- **WHEN** the user calls `sbf_set_sub("step1")`
- **THEN** `sbf_get_sub()` returns `"step1"`

#### Scenario: Multi-segment via vector

- **WHEN** the user calls `sbf_set_sub("a", "b/c")`
- **THEN** `sbf_get_sub()` returns `"a/b/c"`

### Requirement: Sub folder can be reset

`sbf_reset_sub()` SHALL clear the `sbf.sub` option so that `sbf_get_sub()`
returns `character(0)`. It MAY additionally remove the previous sub
folder content when `rm = TRUE`.

#### Scenario: Reset after set

- **GIVEN** `sbf_set_sub("step1")` has been called
- **WHEN** the user calls `sbf_reset_sub()`
- **THEN** `sbf_get_sub()` returns `character(0)`

### Requirement: Appending to the current sub folder

`sbf_add_sub()` SHALL append the given path segment(s) to the current
sub folder and update the option accordingly.

#### Scenario: Adding a nested step

- **GIVEN** the current sub folder is `"a"`
- **WHEN** the user calls `sbf_add_sub("b")`
- **THEN** `sbf_get_sub()` returns `"a/b"`

### Requirement: Walking up the sub folder

`sbf_up_sub()` SHALL accept a positive whole number `n` and remove the
last `n` segments from the current sub folder. It SHALL error when `n`
exceeds the current depth.

#### Scenario: Moving up one level

- **GIVEN** the current sub folder is `"a/b/c"`
- **WHEN** the user calls `sbf_up_sub()`
- **THEN** `sbf_get_sub()` returns `"a/b"`

#### Scenario: Moving up past the root

- **GIVEN** the current sub folder is `"a"`
- **WHEN** the user calls `sbf_up_sub(n = 2L)`
- **THEN** the function errors indicating `n` exceeds the sub-folder depth

### Requirement: Removing a sub folder during set

The package SHALL recursively delete the artefact class directories (`objects/`, `data/`, `numbers/`, `strings/`, `tables/`, `blocks/`, `plots/`, `dbs/`, `flobs/`, `pdfs/`, `windows/`) corresponding to the previous sub folder when `rm = TRUE` is passed to `sbf_set_sub()`, `sbf_reset_sub()` or `sbf_add_sub()`, optionally after user confirmation.

#### Scenario: Clearing a sub folder before re-running a step

- **GIVEN** files exist under `output/objects/step1/` and
  `output/data/step1/`
- **WHEN** the user calls `sbf_set_sub("step1", rm = TRUE, ask = FALSE)`
- **THEN** those class-specific `step1/` directories are removed
- **AND** other classes' `step1/` directories are also removed if present
