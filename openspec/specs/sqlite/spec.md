# SQLite Database Specification

## Purpose

Manage SQLite databases stored under `<main>/dbs/<sub>/` and the data
frames saved into them. Databases are addressable by a name that
defaults to the `sbf.db_name` option.

## Requirements

### Requirement: Default database name option

`sbf_get_db_name()` SHALL return the value of the R option
`sbf.db_name`, defaulting to `"database"`. `sbf_set_db_name()` SHALL
validate that the argument is a non-empty string and set the option
accordingly, returning it invisibly. `sbf_reset_db_name()` SHALL reset
the option to `"database"`.

#### Scenario: Default name

- **WHEN** the user calls `sbf_get_db_name()` after a fresh package
  load
- **THEN** the function returns `"database"`

#### Scenario: Set then reset

- **GIVEN** `sbf_set_db_name("analysis")` has been called
- **WHEN** the user calls `sbf_reset_db_name()`
- **THEN** `sbf_get_db_name()` returns `"database"`

### Requirement: Opening a SQLite connection

`sbf_open_db()` SHALL open a SQLite connection to
`<main>/dbs/<sub>/<db_name>.sqlite` with foreign-key constraints
enabled. When `exists = TRUE` and the file is missing, the function
SHALL error. When `exists = FALSE` and the file exists, it SHALL
optionally prompt (when `ask = TRUE`) before deleting the existing
file and then open a fresh connection; if the user declines, the
function SHALL return `FALSE` without opening a connection.

The deprecated arguments `caption`, `report`, and `tag` SHALL hard-
stop via `lifecycle::deprecate_stop()` if passed.

#### Scenario: Opening an existing database

- **GIVEN** `output/dbs/database.sqlite` exists
- **WHEN** the user calls `conn <- sbf_open_db()`
- **THEN** `conn` is an open `SQLiteConnection`

#### Scenario: Creating a database

- **GIVEN** `output/dbs/new.sqlite` does not exist
- **WHEN** the user calls `sbf_open_db("new", exists = FALSE,
  ask = FALSE)`
- **THEN** a new connection to `output/dbs/new.sqlite` is returned

#### Scenario: Deprecated caption argument

- **WHEN** the user passes `caption = "x"` to `sbf_open_db()`
- **THEN** the function errors with a lifecycle deprecation message

### Requirement: Closing a database connection

`sbf_close_db()` SHALL call `DBI::dbDisconnect()` on the supplied
connection.

#### Scenario: Closing an open connection

- **GIVEN** `conn <- sbf_open_db()` returned an open connection
- **WHEN** the user calls `sbf_close_db(conn)`
- **THEN** `DBI::dbIsValid(conn)` returns `FALSE`

### Requirement: Creating and copying databases

`sbf_create_db()` SHALL create a new, empty SQLite database at the
canonical path by calling `sbf_open_db(exists = FALSE)` and
immediately closing the returned connection. `sbf_copy_db()` SHALL
copy an existing SQLite file (with extension `.db`, `.sqlite`, or
`.sqlite3`) to the canonical path, honouring the same `exists` and
`ask` semantics as `sbf_open_db()`.

#### Scenario: Creating a fresh database

- **GIVEN** `output/dbs/fresh.sqlite` does not exist
- **WHEN** the user calls `sbf_create_db("fresh", ask = FALSE)`
- **THEN** `output/dbs/fresh.sqlite` exists as an empty SQLite file

#### Scenario: Copying an existing file

- **GIVEN** a local file `source.sqlite`
- **WHEN** the user calls `sbf_copy_db("source.sqlite",
  db_name = "copy", exists = FALSE, ask = FALSE)`
- **THEN** `output/dbs/copy.sqlite` is a byte copy of `source.sqlite`

### Requirement: Saving a single data frame to a database

`sbf_save_data_to_db()` SHALL open the database at the canonical
path, call `readwritesqlite::rws_write()` on the supplied data frame
with `exists = TRUE`, commit (when `commit = TRUE`), and close the
connection on exit. It SHALL invisibly return the `.sqlite` file path.

#### Scenario: Writing one data frame

- **GIVEN** `output/dbs/database.sqlite` contains an empty table `iris`
- **WHEN** the user calls `sbf_save_data_to_db(iris)`
- **THEN** rows from `iris` are written to that table

### Requirement: Bulk saving data frames to a database

`sbf_save_datas_to_db()` SHALL write every `data.frame` in the
supplied environment to the database via
`readwritesqlite::rws_write()`, opening and closing the connection
automatically.

#### Scenario: Bulk save

- **GIVEN** the calling frame contains data frames matching existing
  database tables
- **WHEN** the user calls `sbf_save_datas_to_db()`
- **THEN** each matching table is populated

### Requirement: Loading data frames from a database

`sbf_load_data_from_db()` SHALL read a single named table via
`readwritesqlite::rws_read_table()`. `sbf_load_datas_from_db()` SHALL
read every table via `readwritesqlite::rws_read()` and assign each
result into the target environment, transformed by an optional
`rename` function.

#### Scenario: Loading a single table

- **GIVEN** `output/dbs/database.sqlite` contains a table `iris`
- **WHEN** the user calls `sbf_load_data_from_db("iris")`
- **THEN** the return value is a data frame of that table's rows

#### Scenario: Bulk load renames

- **WHEN** the user calls `sbf_load_datas_from_db(rename = toupper)`
  into an empty frame
- **THEN** the frame gains bindings whose names are the upper-cased
  table names

### Requirement: Querying and executing SQL

`sbf_query_db()` SHALL execute a SQL statement via
`DBI::dbGetQuery()` against the canonical database and return the
result as a data frame. `sbf_execute_db()` SHALL execute a SQL
statement via `DBI::dbExecute()` and return the number of affected
rows. Both SHALL open and close the connection themselves.

#### Scenario: Select query

- **GIVEN** a populated database
- **WHEN** the user calls `sbf_query_db("SELECT COUNT(*) FROM iris")`
- **THEN** the return value is a one-row data frame with the count

#### Scenario: Execute statement

- **WHEN** the user calls `sbf_execute_db("DELETE FROM iris")`
- **THEN** the function returns the number of deleted rows

### Requirement: Meta table access

`sbf_load_db_metatable()` SHALL return the database's meta table
(Table, Column, Description rows) via the package's internal
`db_metatable_from_connection()` helper.
`sbf_save_db_metatable_descriptions()` SHALL apply rows of a
`Table/Column/Description` data frame to the database's meta table
via `readwritesqlite::rws_describe_meta()`. When `strict = TRUE` and
any `Table/Column` pair is not present in the meta table, the
function SHALL stop. When `overwrite = FALSE` (the default), only
rows whose existing `Description` is `NA` SHALL be updated.

#### Scenario: Strict mode with unknown column

- **GIVEN** a meta table that does not contain column `"foo"`
- **WHEN** the user calls
  `sbf_save_db_metatable_descriptions(data.frame(Table = "iris",
  Column = "foo", Description = "x"))`
- **THEN** the function errors

### Requirement: Listing, pathing, and existence of databases

`sbf_list_dbs()` SHALL list `.sqlite` files under `dbs/<sub>/` with
`ext = "sqlite"` only. `sbf_path_db()` SHALL resolve the canonical
path for the given database name.

#### Scenario: Listing databases

- **GIVEN** `output/dbs/database.sqlite` exists
- **WHEN** the user calls `sbf_list_dbs()`
- **THEN** the result includes that path

### Requirement: Blob column helpers (flobs)

`sbf_add_blob_column_to_db()` SHALL add an empty blob column to a
table via `dbflobr::add_blob_column()`.
`sbf_save_flobs_from_db()` SHALL export all blobbed files into a
`<main>/flobs/<sub>/<db_name>/` directory via
`dbflobr::save_all_flobs()`, honouring a `dbflobr_sub` argument that
controls whether each file is nested in a per-column subdirectory.
`sbf_upload_flobs_to_db()` SHALL import files back into the database
via `dbflobr::import_all_flobs()`. All three SHALL open and close
the database connection automatically and SHALL check that the
`dbflobr` package is installed.

#### Scenario: Add blob column

- **GIVEN** a table `photos` with no blob column
- **WHEN** the user calls
  `sbf_add_blob_column_to_db("image", "photos")`
- **THEN** the table gains an empty blob column named `image`

#### Scenario: Exporting flobs

- **WHEN** the user calls `sbf_save_flobs_from_db()` on a database
  with blobs
- **THEN** files are written under `output/flobs/database/`

### Requirement: Removing the flobs sub folder

`sbf_rm_flobs()` SHALL recursively delete the
`<main>/flobs/<sub>/` directory, optionally prompting when
`ask = TRUE`.

#### Scenario: Removing flobs

- **GIVEN** `output/flobs/` exists
- **WHEN** the user calls `sbf_rm_flobs(ask = FALSE)`
- **THEN** the flobs directory is removed
