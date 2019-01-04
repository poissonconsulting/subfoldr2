save_rds <- function(x, class, sub, x_name) {
  sub <- sanitize_path(sub)
  dir <- file_path(sbf_get_main(), class, sub)
  dir_create(dir)
  file <- file_path(dir, x_name)
  file <- paste0(file, ".rds")
  saveRDS(x, file)
  invisible(x)
}

#' Save Object
#'
#' @param x The object to save.
#' @param x_name A string of the name to save as.
#' @param sub A string specifying the path to the sub folder (by default the current sub folder).
#' @return An invisible copy of x.
#' @export
sbf_save_object <- function(x, x_name = substitute(x), sub = sbf_get_sub()) {
  x_name <- chk_deparse(x_name)
  check_string(x_name)
  check_vector(sub, "", length = c(0L, 1L))

  save_rds(x, "objects", sub = sub, x_name = x_name)
}

#' Save Data
#'
#' @param x The data frame to save.
#' @inheritParams sbf_save_object
#' @return An invisible copy of x.
#' @export
sbf_save_data <- function(x, x_name = substitute(x), sub = sbf_get_sub()) {
  check_data(x)
  x_name <- chk_deparse(x_name)
  check_string(x_name)
  check_vector(sub, "", length = c(0L, 1L))
  
  save_rds(x, "data", sub = sub, x_name = x_name)
}
