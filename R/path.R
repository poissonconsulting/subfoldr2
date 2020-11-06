get_path <- function(x_name, class, sub, main, ext, exists) {
  chk_lgl(exists)
  path <- create_file_path(x_name, class = class, sub = sub, main = main, ext = ext)
  if(!is.na(exists))
    check_files(path, exists = exists, x_name = "`x_name`")
  path
}

#' Path to Object
#'
#' @inheritParams sbf_save_data
#' @param ext A string specifying the extension.
#' @param exists A logical scalar specifying whether the file should exist.
#' @return A string indicating the path.
#' @export
sbf_path_object <- function(x_name, sub = sbf_get_sub(), main = sbf_get_main(), ext = "rds", exists = NA) {
  chk_string(ext)
  chk_subset(ext, "rds")
  get_path(x_name, class = "objects", sub = sub, main = main, ext = ext, exists = exists)
}

#' Path to Data
#'
#' @inheritParams sbf_save_data
#' @inheritParams sbf_path_object
#' @return A string indicating the path.
#' @export
sbf_path_data <- function(x_name, sub = sbf_get_sub(), main = sbf_get_main(), ext = "rds", exists = NA) {
  chk_string(ext)
  chk_subset(ext, "rds")
  get_path(x_name, class = "data", sub = sub, main = main, ext = ext, exists = exists)
}

#' Path to Number
#'
#' @inheritParams sbf_save_data
#' @inheritParams sbf_path_object
#' @return A string indicating the path.
#' @export
sbf_path_number <- function(x_name, sub = sbf_get_sub(), main = sbf_get_main(), ext = "rds", exists = NA) {
  chk_string(ext)
  chk_subset(ext, c("rds", "csv"))
  get_path(x_name, class = "number", sub = sub, main = main, ext = ext, exists = exists)
}

#' Path to String
#'
#' @inheritParams sbf_save_data
#' @inheritParams sbf_path_object
#' @return A string indicating the path.
#' @export
sbf_path_string <- function(x_name, sub = sbf_get_sub(), main = sbf_get_main(), ext = "rds", exists = NA) {
  chk_string(ext)
  chk_subset(ext, c("rds", "txt"))
  get_path(x_name, class = "string", sub = sub, main = main, ext = ext, exists = exists)
}

#' Path to Code Block
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_path_object
#' @return A string indicating the path.
#' @export
sbf_path_block <- function(x_name, sub = sbf_get_sub(), main = sbf_get_main(), ext = "rds", exists = NA) {
  chk_string(ext)
  chk_subset(ext, c("rds", "txt"))
  get_path(x_name, class = "blocks", sub = sub, main = main, ext = ext, exists = exists)
}

#' Path to Table
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_path_object
#' @return A string indicating the path.
#' @export
sbf_path_table <- function(x_name, sub = sbf_get_sub(), main = sbf_get_main(), ext = "rds", exists = NA) {
  chk_string(ext)
  chk_subset(ext, c("rds", "csv"))
  get_path(x_name, class = "tables", sub = sub, main = main, ext = ext, exists = exists)
}

#' Path to Plot
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_path_object
#' @return A string indicating the path.
#' @export
sbf_path_plot <- function(x_name, sub = sbf_get_sub(), main = sbf_get_main(), ext = "rds", exists = NA) {
  chk_string(ext)
  chk_subset(ext, c("rds", "png"))
  get_path(x_name, class = "plots", sub = sub, main = main, ext = ext, exists = exists)
}

#' Path to Window
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_path_object
#' @return A string indicating the path.
#' @export
sbf_path_window <- function(x_name, sub = sbf_get_sub(), main = sbf_get_main(), ext = "png", exists = NA) {
  chk_string(ext)
  chk_subset(ext, "png")
  get_path(x_name, class = "windows", sub = sub, main = main, ext = ext, exists = exists)
}

#' Path to Database
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_path_object
#' @return A string indicating the path.
#' @export
sbf_path_db <- function(x_name = sbf_get_db_name(), sub = sbf_get_sub(), main = sbf_get_main(), ext = "sqlite", exists = NA) {
  chk_string(ext)
  chk_subset(ext, "sqlite")
  get_path(x_name, class = "dbs", sub = sub, main = main, ext = ext, exists = exists)
}
