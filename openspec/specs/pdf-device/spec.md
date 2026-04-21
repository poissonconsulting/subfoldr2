# PDF Graphics Device Specification

## Purpose

Provide a PDF graphics device scoped to the current `pdfs/<sub>/`
directory. PDF devices allow multiple plots to be written into a
single file but are not incorporated into generated reports.

## Requirements

### Requirement: Opening a PDF device

`sbf_open_pdf()` SHALL open a PDF graphics device via
`grDevices::pdf()` at
`<main>/pdfs/<sub>/<x_name>.pdf` using the supplied `width` and
`height` in inches (defaulting to 6 x 6), creating any missing
directories. The function SHALL invisibly return the resulting file
path.

#### Scenario: Default PDF path

- **WHEN** the user calls `sbf_open_pdf()` with the default main and
  sub folders
- **THEN** a PDF device writing to `output/pdfs/plots.pdf` is opened

#### Scenario: Non-positive dimensions

- **WHEN** the user calls `sbf_open_pdf(width = -1)`
- **THEN** the function errors

### Requirement: Closing a PDF device

`sbf_close_pdf()` SHALL close the current graphics device via
`grDevices::dev.off()`.

#### Scenario: Closing after writing

- **GIVEN** a PDF device opened by `sbf_open_pdf()` is current
- **WHEN** the user calls `sbf_close_pdf()`
- **THEN** the PDF file is finalised and the device is closed
