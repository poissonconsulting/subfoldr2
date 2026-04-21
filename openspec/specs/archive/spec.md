# Archive Specification

## Purpose

Provides point-in-time snapshots of the main folder so that a pipeline's
outputs can be preserved before being re-generated, and optionally
restored later.

## Requirements

### Requirement: Archiving the main folder

`sbf_archive_main()` SHALL copy the current main folder to a sibling
directory whose name is the main folder basename followed by a dash and
the current date/time (year-month-day-hour-minute-second), in the given
timezone. It SHALL return the archived folder path invisibly. When the
main folder does not exist, it SHALL emit an informational message and
return an empty character vector.

#### Scenario: Archiving an existing main folder

- **GIVEN** the main folder `output/` exists and contains files
- **WHEN** the user calls `sbf_archive_main(ask = FALSE)`
- **THEN** a new sibling directory matching
  `output-YYYY-MM-DD-hh-mm-ss` is created with a full copy of the
  contents
- **AND** the function returns that directory path invisibly

#### Scenario: Archiving a missing main folder

- **GIVEN** the main folder does not exist
- **WHEN** the user calls `sbf_archive_main()`
- **THEN** an informational message is emitted
- **AND** the function returns an empty character vector invisibly

#### Scenario: Archive path collision

- **GIVEN** an archive directory with the computed timestamp already
  exists
- **WHEN** `sbf_archive_main()` is called
- **THEN** the function waits one second and recomputes the timestamp
- **AND** errors if the collision persists

### Requirement: Listing archived folders

`sbf_get_archive()` SHALL return the path to the `archive`-th most
recently created archived folder for the given main folder, where
`archive = 1L` is the most recent. It SHALL error when there are no
matching archives or when the index exceeds the number of archives.

#### Scenario: Most recent archive

- **GIVEN** two archives exist for `output/`
- **WHEN** the user calls `sbf_get_archive()`
- **THEN** the function returns the path to the more recently named
  archive

#### Scenario: No archives

- **WHEN** the user calls `sbf_get_archive()` and no archives exist
- **THEN** the function errors with a message naming the main folder

### Requirement: Restoring an archive

`sbf_unarchive_main()` SHALL delete the current main folder (optionally
after prompting) and copy an archive back to the main folder path.
`archive` MAY be an integer index (delegated to `sbf_get_archive()`) or
a directory path.

#### Scenario: Restoring the most recent archive

- **GIVEN** the most recent archive for `output/` exists
- **WHEN** the user calls `sbf_unarchive_main(archive = 1L, ask = FALSE)`
- **THEN** the current `output/` is removed
- **AND** the archive contents are copied back to `output/`
- **AND** the source archive directory is removed
