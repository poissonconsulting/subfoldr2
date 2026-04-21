# Deprecated PostgreSQL and AWS Functions Specification

## Purpose

A group of PostgreSQL, schema, config and AWS helpers that used to
live in this package have been moved to the `subfoldr2ext` package.
Their stubs remain exported so that existing scripts produce clear
migration errors instead of "object not found".

## Requirements

### Requirement: PostgreSQL connection helpers are deprecated

The PostgreSQL helpers `sbf_open_pg()`, `sbf_close_pg()`, `sbf_create_pg()`, `sbf_backup_pg()`, `sbf_execute_pg()`, `sbf_list_tables_pg()`, `sbf_load_data_from_pg()`, `sbf_load_datas_from_pg()` and `sbf_save_data_to_pg()` SHALL hard-stop via `lifecycle::deprecate_stop("0.2.0")`, naming the replacement in the `subfoldr2ext` package (e.g. `subfoldr2ext::sbfx_open_pg()`).

#### Scenario: Calling a deprecated pg function

- **WHEN** the user calls `sbf_open_pg()`
- **THEN** the function errors with a lifecycle deprecation message
  pointing to `subfoldr2ext::sbfx_open_pg()`

### Requirement: Schema helpers are deprecated

The schema helpers `sbf_set_schema()`, `sbf_get_schema()` and `sbf_reset_schema()` SHALL hard-stop via `lifecycle::deprecate_stop("0.2.0")` and redirect to their `subfoldr2ext::sbfx_*_schema()` counterparts.

#### Scenario: Calling a deprecated schema function

- **WHEN** the user calls `sbf_set_schema("capture")`
- **THEN** the function errors pointing to
  `subfoldr2ext::sbfx_set_schema()`

### Requirement: Config file and value helpers are deprecated

The config helpers `sbf_set_config_file()`, `sbf_get_config_file()`, `sbf_reset_config_file()`, `sbf_set_config_value()`, `sbf_get_config_value()` and `sbf_reset_config_value()` SHALL hard-stop via `lifecycle::deprecate_stop("0.2.0")` and redirect to their `subfoldr2ext::sbfx_*` counterparts.

#### Scenario: Calling a deprecated config function

- **WHEN** the user calls `sbf_set_config_file()`
- **THEN** the function errors pointing to
  `subfoldr2ext::sbfx_set_config_file()`

### Requirement: AWS file download helper is deprecated

`sbf_save_aws_files()` SHALL hard-stop via
`lifecycle::deprecate_stop("0.2.0")` and redirect to
`subfoldr2ext::sbfx_save_aws_files()`.

#### Scenario: Calling the deprecated AWS helper

- **WHEN** the user calls `sbf_save_aws_files(bucket_name = "x")`
- **THEN** the function errors pointing to
  `subfoldr2ext::sbfx_save_aws_files()`
