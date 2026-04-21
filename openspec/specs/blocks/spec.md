# Code Blocks Specification

## Purpose

Persist multi-line text blocks (typically formatted code or quoted
output) together with caption/report metadata, under
`<main>/blocks/<sub>/`.

## Requirements

### Requirement: Saving a code block

`sbf_save_block()` SHALL validate that `x` is a non-empty string and
write three files: `<x_name>.rds`, `<x_name>.txt` and `<x_name>.rda`.
The `.rda` metadata SHALL contain `caption` (string, default `""`),
`report` (logical, default `TRUE`) and `tag` (string, default `""`).

#### Scenario: Default save

- **WHEN** the user calls
  `sbf_save_block("a <- 1", x_name = "chunk", caption = "Setup")`
- **THEN** the files `output/blocks/chunk.rds`,
  `output/blocks/chunk.txt` and `output/blocks/chunk.rda` exist
- **AND** the `.rda` metadata has `caption = "Setup"`,
  `report = TRUE`, `tag = ""`

### Requirement: Loading a code block

`sbf_load_block()` SHALL return the string stored at
`<main>/blocks/<sub>/<x_name>.rds` with the same `exists` semantics as
`sbf_load_object()`.

#### Scenario: Round-trip

- **GIVEN** `sbf_save_block("a <- 1", x_name = "chunk")` was called
- **WHEN** the user calls `sbf_load_block("chunk")`
- **THEN** the returned value equals `"a <- 1"`

### Requirement: Bulk load blocks

`sbf_load_blocks()` SHALL read every `.rds` file in `blocks/<sub>/`
into the target environment. `sbf_load_blocks_recursive()` SHALL
return a tibble with a character column `blocks` and metadata columns
`name`, `sub`, `file`, optionally including `caption`, `report` and
`tag` when `meta = TRUE`.

#### Scenario: Recursive load with meta

- **GIVEN** blocks exist at the root and in a sub folder
- **WHEN** the user calls `sbf_load_blocks_recursive(meta = TRUE)`
- **THEN** the tibble includes `caption`, `report`, `tag` columns

### Requirement: Listing, path, and subs

`sbf_list_blocks()` SHALL accept `ext` of `"rds"` or `"txt"`.
`sbf_path_block()` SHALL resolve the canonical path with those same
extensions. `sbf_subs_block_recursive()` SHALL return sub folders
containing a block with the given name.

#### Scenario: Listing txt

- **GIVEN** a saved block `"chunk"` exists
- **WHEN** the user calls `sbf_list_blocks(ext = "txt")`
- **THEN** the result includes the path to `chunk.txt`

### Requirement: Block existence check (deprecated)

`sbf_block_exists()` SHALL return whether the `.rds` file exists and
emit a soft deprecation notice referencing version `0.0.0.9045`.

#### Scenario: Existing block

- **GIVEN** a block `"chunk"` was saved
- **WHEN** the user calls `sbf_block_exists("chunk")`
- **THEN** the function returns `TRUE`
- **AND** emits a lifecycle soft-deprecation notice
