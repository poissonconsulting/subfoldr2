# Graphics Windows Specification

## Purpose

Capture the contents of a base- or grid-graphics device to PNG for
inclusion in reports. Unlike `plots/`, no `.rds` object is produced.
Files are written under `<main>/windows/<sub>/`.

## Requirements

### Requirement: Opening a platform-appropriate graphics window

`sbf_open_window()` SHALL open a new interactive graphics device with
the supplied `width` and `height` (inches, defaulting to 6 x 6). On
Windows this SHALL call `grDevices::windows()`, on macOS
`grDevices::quartz()`, and otherwise `grDevices::x11()`.

#### Scenario: Open on Linux

- **GIVEN** the current platform is Linux
- **WHEN** the user calls `sbf_open_window()`
- **THEN** a new `grDevices::x11()` device is opened

### Requirement: Closing a graphics window

`sbf_close_window()` SHALL close the current device via
`grDevices::dev.off()`, and `sbf_close_windows()` SHALL close all
devices via `grDevices::graphics.off()`.

#### Scenario: Close the current device

- **GIVEN** a graphics device is open
- **WHEN** the user calls `sbf_close_window()`
- **THEN** the current device is closed

### Requirement: Saving the current device to PNG

`sbf_save_window()` SHALL copy the current graphics device to
`<main>/windows/<sub>/<x_name>.png` at the specified width, height,
units and DPI, and additionally write `<x_name>.rda` metadata with
`caption`, `report`, `tag`, `width`, `height`, `dpi`. When no device
is open, the function SHALL error with "no such device".

#### Scenario: Capturing an open device

- **GIVEN** a plot has been drawn on the current device
- **WHEN** the user calls `sbf_save_window(x_name = "w",
  width = 6, height = 4, dpi = 300)`
- **THEN** `output/windows/w.png` and `output/windows/w.rda` exist

#### Scenario: No open device

- **GIVEN** no graphics device is open
- **WHEN** the user calls `sbf_save_window()`
- **THEN** the function errors with "no such device"

### Requirement: Importing a PNG file

`sbf_save_png()` SHALL copy an existing `.png` file into the current
`windows/<sub>/` directory under the given `x_name`, preserving the
aspect ratio derived from the source PNG dimensions, and write an
accompanying `.rda` metadata file.

#### Scenario: Importing a PNG by path

- **GIVEN** a local file `fig.png` exists
- **WHEN** the user calls `sbf_save_png("fig.png")`
- **THEN** `output/windows/fig.png` and `output/windows/fig.rda` exist

#### Scenario: Non-PNG input

- **WHEN** the user passes a non-PNG file to `sbf_save_png()`
- **THEN** the function errors

### Requirement: Recursive load of window metadata and paths

`sbf_load_windows_recursive()` SHALL return a tibble whose first
column `windows` and column `file` are both character vectors of the
PNG file paths, plus `name`, `sub`, and optionally `caption`,
`report`, `tag`, `width`, `height`, `dpi` when `meta = TRUE`. It
SHALL read the `.rda` metadata files to determine which PNGs to
include.

#### Scenario: Locating PNG paths

- **GIVEN** `output/windows/w.png` and `output/windows/w.rda` exist
- **WHEN** the user calls `sbf_load_windows_recursive()`
- **THEN** the tibble has one row for `w` with the PNG path

### Requirement: Listing, path, and subs

`sbf_list_windows()` SHALL list window files with `ext = "png"` only.
`sbf_path_window()` SHALL resolve the canonical path with
`ext = "png"`. `sbf_subs_window_recursive()` SHALL return sub folders
containing a window with the given name.

#### Scenario: Listing window PNGs

- **GIVEN** `output/windows/w.png` exists
- **WHEN** the user calls `sbf_list_windows()`
- **THEN** the result includes that path
