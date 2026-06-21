#' Convert Legacy Metadata Files to YAML
#'
#' Converts legacy metadata files (saved with the `.rda` extension as RDS files)
#' to the human- and machine-readable `.yaml` files now used by the package.
#' Each `.rda` file in the main folder is read, written to a `.yaml` file of the
#' same name and then deleted.
#'
#' @inheritParams sbf_save_object
#' @param ask A flag specifying whether to ask before converting the files.
#' @return An invisible character vector of the paths to the `.yaml` files
#' created.
#' @family housekeeping functions
#' @export
sbf_convert_meta <- function(main = sbf_get_main(),
                             ask = getOption("sbf.ask", TRUE)) {
  chk_string(main)
  chk_flag(ask)

  main <- sanitize_path(main, rm_leading = FALSE)

  if (!dir.exists(main)) {
    cli::cli_alert_info("Directory {.file {main}} does not exist.")
    return(invisible(character(0)))
  }

  files <- list.files(main, pattern = "[.]rda$", recursive = TRUE,
                      full.names = TRUE)

  if (!length(files)) {
    cli::cli_alert_info("No {.file .rda} metadata files to convert.")
    return(invisible(character(0)))
  }

  msg <- paste0(
    "Convert ", length(files), " '.rda' metadata file",
    if (length(files) > 1) "s" else "", " in directory '", main,
    "' to '.yaml' and delete the '.rda' file",
    if (length(files) > 1) "s" else "", "?"
  )
  if (ask && !yesno(msg)) {
    return(invisible(character(0)))
  }

  yaml_files <- vapply(files, function(file) {
    meta <- readRDS(file)
    yaml_file <- replace_ext(file, "yaml")
    yaml::write_yaml(meta, yaml_file)
    file.remove(file)
    yaml_file
  }, character(1))
  yaml_files <- unname(yaml_files)

  cli::cli_alert_success(
    "Converted {length(yaml_files)} metadata file{?s} to {.file .yaml}."
  )
  invisible(yaml_files)
}
