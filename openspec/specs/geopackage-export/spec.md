# Geopackage Export Specification

## Purpose

Export `sf` data frames as OGC GeoPackage (`.gpkg`) files under
`<main>/gpkg/<sub>/`, in addition to a serialised `.rds` copy. Only
point geometries are preserved in the GeoPackage; other `sfc` columns
are dropped during export.

## Requirements

### Requirement: Saving a single sf data frame as a geopackage

`sbf_save_gpkg()` SHALL require that `x` inherits from `data.frame`
and `sf`. The name `"gpkg"` SHALL be reserved and rejected as an
`x_name`. The function SHALL write `<main>/gpkg/<sub>/<x_name>.rds`
and `<main>/gpkg/<sub>/<x_name>.gpkg` using `sf::st_write()` with
`delete_layer = TRUE`.

#### Scenario: Valid sf input

- **WHEN** the user calls `sbf_save_gpkg(pts, x_name = "pts")`
- **THEN** `output/gpkg/pts.rds` and `output/gpkg/pts.gpkg` exist

#### Scenario: Reserved name

- **WHEN** the user calls `sbf_save_gpkg(pts, x_name = "gpkg")`
- **THEN** the function errors indicating `"gpkg"` is a reserved
  prefix

### Requirement: Bulk export of sf data frames

`sbf_save_gpkgs()` SHALL iterate over the supplied environment and,
for every binding containing an `sfc` column, export geopackages.
When `all_sfcs = TRUE` (the default) each non-active `sfc` column
SHALL also be exported as `<name>_<column_name>_.gpkg` by temporarily
setting it as the active geometry column before export.

#### Scenario: Bulk export of an sf frame

- **GIVEN** the calling frame contains a single `sf` tibble `pts`
  with only a point geometry
- **WHEN** the user calls `sbf_save_gpkgs()`
- **THEN** `output/gpkg/pts.gpkg` is written

#### Scenario: Skipping non-sf frames

- **GIVEN** the calling frame contains only data frames without
  `sfc` columns
- **WHEN** the user calls `sbf_save_gpkgs()`
- **THEN** the function warns that no sfs were saved and returns an
  empty character vector invisibly
