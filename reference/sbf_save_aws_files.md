# Download files from AWS S3

**\[deprecated\]**

`sbf_save_aws_files()` was moved to
`subfoldr2ext::sbfx_save_aws_files()`.

Download files from an AWS S3 bucket into the analysis.

## Usage

``` r
sbf_save_aws_files(
  bucket_name,
  sub = sbf_get_sub(),
  main = sbf_get_main(),
  data_type = NULL,
  year = NULL,
  month = NULL,
  day = NULL,
  file_name = NULL,
  file_extension = NULL,
  max_request_size = 1000,
  ask = getOption("sbf.ask", TRUE),
  silent = TRUE,
  aws_access_key_id = Sys.getenv("AWS_ACCESS_KEY_ID"),
  aws_secret_access_key = Sys.getenv("AWS_SECRET_ACCESS_KEY"),
  region = Sys.getenv("AWS_REGION", "ca-central-1")
)
```

## Arguments

- bucket_name:

  A string of the AWS S3 bucket name.

- sub:

  A string specifying the path to the sub folder (by default the current
  sub folder).

- main:

  A string specifying the path to the main folder (by default the
  current main folder)

- data_type:

  A string (by default `NULL`) for which data type to return. Check the
  folder names within the shiny-upload in AWS for options common
  examples include punch-data, tracks, logger, image and pdf.

- year:

  A whole number (by default `NULL`) indicating which year to return.
  Format YYYY.

- month:

  A whole number (by default `NULL`) indicating which month to return.
  Format MM.

- day:

  A whole number (by default `NULL`) indicating which day to return.
  Format DD.

- file_name:

  A string (by default `NULL`) containing the name of the file to
  return. Do not include extension type.

- file_extension:

  A string (by default `NULL`) with the file extension to return. Do not
  include period.

- max_request_size:

  A whole number (by default `1000`) indicating the maximum number of
  files to be returned.

- ask:

  A flag specifying whether to ask before overwriting files.

- silent:

  A flag (by default `FALSE`) to silence messages about number of files
  returned. Set to `TRUE` to silence messages.

- aws_access_key_id:

  A string of your AWS user access key ID. The default is the
  environment variable named `AWS_ACCESS_KEY_ID`.

- aws_secret_access_key:

  A string of your AWS user secret access key. The default is the
  environment variable named `AWS_SECRET_ACCESS_KEY`.

- region:

  A string of the AWS region. The default is the environment variable
  named `AWS_REGION`.

## See also

Other save functions:
[`sbf_basename_sans_ext()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_basename_sans_ext.md),
[`sbf_save_block()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_block.md),
[`sbf_save_data()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_data.md),
[`sbf_save_data_to_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_data_to_db.md),
[`sbf_save_data_to_pg()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_data_to_pg.md),
[`sbf_save_datas()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_datas.md),
[`sbf_save_datas_to_db()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_datas_to_db.md),
[`sbf_save_db_metatable_descriptions()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_db_metatable_descriptions.md),
[`sbf_save_db_to_workbook()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_db_to_workbook.md),
[`sbf_save_excel()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_excel.md),
[`sbf_save_excels()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_excels.md),
[`sbf_save_gpkg()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_gpkg.md),
[`sbf_save_gpkgs()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_gpkgs.md),
[`sbf_save_number()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_number.md),
[`sbf_save_numbers()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_numbers.md),
[`sbf_save_object()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_object.md),
[`sbf_save_objects()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_objects.md),
[`sbf_save_plot()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_plot.md),
[`sbf_save_png()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_png.md),
[`sbf_save_spatial()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_spatial.md),
[`sbf_save_spatials()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_spatials.md),
[`sbf_save_string()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_string.md),
[`sbf_save_strings()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_strings.md),
[`sbf_save_table()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_table.md),
[`sbf_save_window()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_window.md),
[`sbf_save_workbook()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_save_workbook.md)

## Examples

``` r
if (FALSE) { # \dontrun{
sbf_save_aws_files(
  bucket_name = "exploit-upload-poissonconsulting",
  data_type = "upload-recapture",
  year = 2021,
  file_name = "processed_data",
  file_extension = "csv"
)
} # }
```
