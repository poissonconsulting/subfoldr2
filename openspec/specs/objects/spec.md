# Objects Specification

## Purpose

Provides the generic save/load family for arbitrary R objects. Objects
are stored as `.rds` files under `<main>/objects/<sub>/`.

## Requirements

### Requirement: Saving a single R object

`sbf_save_object()` SHALL write the given R object as an `.rds` file at
`<main>/objects/<sub>/<x_name>.rds`, creating any missing directories,
and invisibly return the saved file path.

#### Scenario: Saving to the current main and sub

- **GIVEN** `sbf_get_main()` returns `"output"` and `sbf_get_sub()`
  returns `character(0)`
- **WHEN** the user calls `sbf_save_object(x, x_name = "x")`
- **THEN** the file `output/objects/x.rds` exists and contains `x`

#### Scenario: Saving to a nested sub folder

- **WHEN** the user calls `sbf_save_object(x, x_name = "x",
  sub = "step/a")`
- **THEN** the file `output/objects/step/a/x.rds` exists

### Requirement: Default naming from the argument expression

When `x_name` is omitted, `sbf_save_object()` SHALL deparse the
expression passed as `x` and use it as the file name.

#### Scenario: Using the variable name

- **WHEN** the user calls `sbf_save_object(my_var)`
- **THEN** the resulting file is named `my_var.rds`

### Requirement: Loading a single R object

`sbf_load_object()` SHALL read the `.rds` file at
`<main>/objects/<sub>/<x_name>.rds` and return the deserialised object.
When `exists = TRUE` (the default) and the file does not exist, the
function SHALL error. When `exists = FALSE` or `exists = NA` and the
file is missing, it SHALL return `NULL`.

#### Scenario: Round-trip save and load

- **GIVEN** `sbf_save_object(x, x_name = "x")` was called
- **WHEN** the user calls `sbf_load_object("x")`
- **THEN** the return value is identical to the original `x`

#### Scenario: Missing file with exists = TRUE

- **GIVEN** no object has been saved with name `"missing"`
- **WHEN** the user calls `sbf_load_object("missing")`
- **THEN** the function errors

#### Scenario: Missing file with exists = FALSE

- **WHEN** the user calls `sbf_load_object("missing", exists = FALSE)`
- **THEN** the function returns `NULL`

### Requirement: Bulk save from environment

`sbf_save_objects()` SHALL iterate over every binding in the supplied
environment (defaulting to the caller frame) and save each one using
`sbf_save_object()`. It SHALL return an invisible character vector of
the written file paths. When the environment is empty, a warning is
emitted.

#### Scenario: Saving all variables in the calling frame

- **GIVEN** the calling frame contains `x <- 1` and `y <- 2`
- **WHEN** the user calls `sbf_save_objects()`
- **THEN** both `output/objects/x.rds` and `output/objects/y.rds` are
  written

### Requirement: Bulk load into environment

`sbf_load_objects()` SHALL read every `.rds` file directly within the
`objects/<sub>/` directory and assign each to the target environment
(default: the caller). A `rename` function (default `identity`) SHALL
be applied to each file's base name to produce the binding name. When
no files are present, a warning is emitted and the function returns an
empty character vector invisibly.

#### Scenario: Loading back into the calling frame

- **GIVEN** `output/objects/x.rds` and `output/objects/y.rds` exist
- **WHEN** the user calls `sbf_load_objects()` from an empty frame
- **THEN** variables `x` and `y` are bound in that frame

#### Scenario: Renaming on load

- **WHEN** the user calls `sbf_load_objects(rename = toupper)`
- **THEN** `X` and `Y` are bound instead of `x` and `y`

### Requirement: Recursive load as list column

`sbf_load_objects_recursive()` SHALL walk the `objects/<sub>/`
directory, optionally restricted by a regular expression on the file
base name (`x_name`), and return a tibble whose first column `objects`
is a list column of the deserialised objects, plus columns `name`,
`sub` and `file`. When `include_root = FALSE`, objects directly inside
`<sub>/` are excluded. The `drop` argument MAY specify sub folder or
file names to omit.

#### Scenario: Recursive load returns tibble

- **GIVEN** `output/objects/x.rds`, `output/objects/a/y.rds` exist
- **WHEN** the user calls `sbf_load_objects_recursive()`
- **THEN** the returned tibble has one row per file with columns
  `objects`, `name`, `sub`, `file`

#### Scenario: Excluding the root

- **WHEN** `include_root = FALSE` is passed
- **THEN** the row for `output/objects/x.rds` is excluded

### Requirement: Listing object files

`sbf_list_objects()` SHALL return a named character vector of full file
paths for `.rds` files in the `objects/<sub>/` directory whose base
names match the regular expression `x_name` (default `".*"`).
`recursive = TRUE` SHALL recurse into sub directories;
`include_root = FALSE` SHALL exclude files directly in `<sub>/`.

#### Scenario: Default non-recursive listing

- **GIVEN** `output/objects/x.rds` exists
- **WHEN** the user calls `sbf_list_objects()`
- **THEN** the result includes that path

### Requirement: Path resolution helper

`sbf_path_object()` SHALL return the canonical file path for an object
of a given `x_name` and `ext` (only `"rds"` is permitted) under the
current main/sub folder. When `exists = TRUE`, it SHALL error if the
file is absent; when `exists = FALSE`, it SHALL error if it is
present; when `exists = NA` (the default), no existence check is
performed.

#### Scenario: Non-existence check

- **GIVEN** no object `"missing"` has been saved
- **WHEN** the user calls `sbf_path_object("missing", exists = TRUE)`
- **THEN** the function errors

### Requirement: Recursive sub listing by name

`sbf_subs_object_recursive()` SHALL return a character vector of the
sub folder paths (relative to `objects/<sub>/`) that contain an
`.rds` file whose base name equals `x_name`.

#### Scenario: Finding subs for a specific name

- **GIVEN** `output/objects/x.rds` and `output/objects/a/x.rds` exist
- **WHEN** the user calls `sbf_subs_object_recursive("x")`
- **THEN** the result includes the sub folder paths that contain `x.rds`

### Requirement: Object existence check (deprecated)

`sbf_object_exists()` SHALL return a logical flag indicating whether
the corresponding `.rds` file exists. It SHALL emit a soft deprecation
notice referencing version `0.0.0.9045`.
Callers SHOULD switch to `file.exists(sbf_path_object())` or similar.

#### Scenario: Existing object

- **GIVEN** object `"x"` has been saved
- **WHEN** the user calls `sbf_object_exists("x")`
- **THEN** the function returns `TRUE`
- **AND** emits a lifecycle soft-deprecation notice
