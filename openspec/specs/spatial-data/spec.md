# Spatial Data Specification

## Purpose

Persist `sf` tibble spatial data frames as `.rds` files under
`<main>/spatial/<sub>/`. Spatial data is subject to stricter
validation than generic data frames so that downstream consumers can
rely on an index column and a single geometry column with a defined
projection.

## Requirements

### Requirement: Saving a spatial tibble

`sbf_save_spatial()` SHALL require that `x`:

- inherits from `sf` and `data.frame`;
- has at least one row and at least two columns;
- has a non-missing projection (`sf::st_crs(x)` is not `NA`);
- has exactly one geometry column (`sfc`);
- has a first column (not the geometry column) with no missing values
  and no duplicates.

When all checks pass, the function SHALL write `x` as
`<main>/spatial/<sub>/<x_name>.rds`. Missing `x_name` SHALL default
to the deparsed expression of `x`.

#### Scenario: Valid sf tibble

- **GIVEN** an `sf` tibble `pts` with an `id` first column and point
  geometry
- **WHEN** the user calls `sbf_save_spatial(pts)`
- **THEN** `output/spatial/pts.rds` exists

#### Scenario: Missing projection

- **GIVEN** an `sf` tibble whose `st_crs()` is `NA`
- **WHEN** the user calls `sbf_save_spatial(x)`
- **THEN** the function errors indicating a missing projection

#### Scenario: Duplicated index column

- **GIVEN** an `sf` tibble whose first column has duplicate values
- **WHEN** the user calls `sbf_save_spatial(x)`
- **THEN** the function errors indicating duplicated values in the
  first column

### Requirement: Loading a spatial tibble

`sbf_load_spatial()` SHALL read the `.rds` file at
`<main>/spatial/<sub>/<x_name>.rds` and validate the loaded object
against the same `sf` requirements; when the loaded object is not a
valid spatial object the function SHALL emit a warning but return
the object. The `exists` argument SHALL have the same semantics as in
`sbf_load_object()`.

#### Scenario: Loading a saved spatial tibble

- **GIVEN** a spatial `pts` was saved
- **WHEN** the user calls `sbf_load_spatial("pts")`
- **THEN** the returned value is the original `sf` tibble

### Requirement: Bulk save and load of spatial data

`sbf_save_spatials()` SHALL save every data frame binding in the
supplied environment using `sbf_save_spatial()`.
`sbf_load_spatials()` SHALL read every `.rds` file in
`spatial/<sub>/` and assign the values into the target environment
with an optional `rename` function.

#### Scenario: Bulk save

- **GIVEN** the calling frame contains one valid `sf` tibble `pts`
- **WHEN** the user calls `sbf_save_spatials()`
- **THEN** `output/spatial/pts.rds` is written
