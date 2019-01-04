load_rds <- function(x_name, class, sub) {
  dir <- file_path(sbf_get_main(), class, sub, x_name)
  file <- paste0(dir, ".rds")
  if (!file.exists(file)) err("file '", file, "' does not exist")
  readRDS(file)
}

#' Load Object
#'
#' @inheritParams sbf_save_data
#' @export
sbf_load_object <- function(x_name, sub = sbf_get_sub()) {
  check_string(x_name)
  sub <- sanitize_path(sub)
  load_rds(x_name, class = "objects", sub = sub)
}

#' Load Data
#'
#' @inheritParams sbf_save_object
#' @export
sbf_load_data <- function(x_name, sub = sbf_get_sub()) {
  check_string(x_name)
  sub <- sanitize_path(sub)
  load_rds(x_name, class = "data", sub = sub)
}

#' Load Data
#'
#' @inheritParams sbf_save_object
#' @export
sbf_load_number <- function(x_name, sub = sbf_get_sub()) {
  check_string(x_name)
  sub <- sanitize_path(sub)
  load_rds(x_name, class = "numbers", sub = sub)
}

#' Load Table
#'
#' @inheritParams sbf_save_object
#' @export
sbf_load_table <- function(x_name, sub = sbf_get_sub()) {
  check_string(x_name)
  sub <- sanitize_path(sub)
  load_rds(x_name, class = "tables", sub = sub)
}
