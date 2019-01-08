save_rds <- function(x, class, sub, x_name, exists) {
  dir <- file_path(sbf_get_main(), class, sub)
  dir_create(dir)
  file <- file_path(dir, x_name)
  file <- paste0(file, ".rds")
  if(isTRUE(exists) && !file.exists(file))
    err("file '", file, "' doesn't exist")
  if(isFALSE(exists) && file.exists(file))
    err("file '", file, "' already exists")
  saveRDS(x, file)
  invisible(file)
}

save_csv <- function(x, class, sub, x_name) {
  dir <- file_path(sbf_get_main(), class, sub)
  dir_create(dir)
  file <- file_path(dir, x_name)
  file <- paste0(file, ".csv")
  write.csv(x, file, row.names = FALSE)
  invisible(file)
}

save_txt <- function(txt, class, sub, x_name) {
  dir <- file_path(sbf_get_main(), class, sub)
  dir_create(dir)
  file <- file_path(dir, x_name)
  file <- paste0(file, ".txt")
  cat(txt, file = file)
  invisible(file)
}

save_meta <- function(meta, class, sub, x_name) {
  dir <- file_path(sbf_get_main(), class, sub)
  dir_create(dir)
  x_name <- paste0("_", x_name)
  file <- file_path(dir, x_name)
  file <- paste0(file, ".rds")
  saveRDS(meta, file)
  invisible(file)
}

#' Save Object
#'
#' @param x The object to save.
#' @param x_name A string of the name to save as.
#' @param sub A string specifying the path to the sub folder (by default the current sub folder).
#' @param exists A logical scalar specifying whether the saved object must already exist.
#' @return An invisible string of the path to the saved object.
#' @export
sbf_save_object <- function(x, x_name = substitute(x), sub = sbf_get_sub(), exists = NA) {
  x_name <- chk_deparse(x_name)
  check_x_name(x_name)
  check_vector(sub, "", length = c(0L, 1L))
  check_scalar(exists, c(TRUE, NA))
  
  sub <- sanitize_path(sub)
  
  save_rds(x, "objects", sub = sub, x_name = x_name, exists = exists)
}

#' Save Data
#'
#' @param x The data frame(s) to save.
#' @param x_name A string of the name to save as or a string of the name to prepend to the name of each data frame.
#' @inheritParams sbf_save_object
#' @param exists A logical scalar specifying whether the saved object(s) must already exist.
#' @param ... Unused.
#' @return An invisible character vector of the path to the saved object.
#' @export
sbf_save_data <- function(x, x_name, sub = sbf_get_sub(), exists = NA, ...) {
  UseMethod("sbf_save_data")
}

#' @export
sbf_save_data.data.frame <- function(x, x_name = substitute(x), sub = sbf_get_sub(), 
                                     exists = NA, ...) {
  x_name <- chk_deparse(x_name)
  check_x_name(x_name)
  check_vector(sub, "", length = c(0L, 1L))
  check_scalar(exists, c(TRUE, NA))
  check_unused(...)
  
  sub <- sanitize_path(sub)
  
  save_rds(x, "data", sub = sub, x_name = x_name, exists = exists)
}

#' @export
sbf_save_data.list <- function(x, x_name = "", sub = sbf_get_sub(), 
                               exists = NA, ...) {
  check_named(x, unique = TRUE)
  check_string(x_name)
  check_unused(...)
  
  if(!length(x)) return(character(0))
  
  if(!all(vapply(x, is.data.frame, TRUE)))
    err("list x includes objects which are not data frames")
  
  names(x) <- p0(x_name, names(x))
  
  paths <- mapply(sbf_save_data, x, names(x),
                  MoreArgs = list(sub = sub, exists = exists), SIMPLIFY = FALSE)
  paths <- unlist(paths)
  paths <- unname(paths)
  invisible(paths)
}

#' @export
sbf_save_data.environment <- function(x, x_name = "", sub = sbf_get_sub(), 
                                      exists = NA,
                                      silent = getOption("sbf.silent", FALSE), ...) {
  check_flag(silent)
  check_unused(...)
  
  x <- as.list(x)
  
  x <- x[vapply(x, is.data.frame, TRUE)]
  if(!length(x)) {
    if(!silent) {
      wrn(p0("environment x has no data frames"))
    }
    return(invisible(character(0)))
  }
  
  sbf_save_data(x, x_name = x_name, sub = sub, exists = exists)
}

#' Save Number
#'
#' @param x The number to save.
#' @inheritParams sbf_save_object
#' @return An invisible string of the path to the saved object.
#' @export
sbf_save_number <- function(x, x_name = substitute(x), sub = sbf_get_sub(),
                            exists = NA) {
  x_name <- chk_deparse(x_name)
  x <- check_number(x, coerce = TRUE)
  check_x_name(x_name)
  check_vector(sub, "", length = c(0L, 1L))
  check_scalar(exists, c(TRUE, NA))
  
  sub <- sanitize_path(sub)
  
  save_csv(x, "numbers", sub = sub, x_name = x_name)
  save_rds(x, "numbers", sub = sub, x_name = x_name, exists = exists)
}

#' Save String
#'
#' @param x The string to save.
#' @inheritParams sbf_save_object
#' @return An invisible string of the path to the saved object.
#' @export
sbf_save_string <- function(x, x_name = substitute(x), sub = sbf_get_sub(),
                            exists = NA) {
  x_name <- chk_deparse(x_name)
  x <- check_string(x, coerce = TRUE)
  check_x_name(x_name)
  check_vector(sub, "", length = c(0L, 1L))
  check_scalar(exists, c(TRUE, NA))
  
  sub <- sanitize_path(sub)
  
  save_txt(x, "strings", sub = sub, x_name = x_name)
  save_rds(x, "strings", sub = sub, x_name = x_name, exists = exists)
}

#' Save Code Block
#'
#' @param x A string of the code block to save.
#' @inheritParams sbf_save_object
#' @inheritParams sbf_save_table
#' @param language A string specifying the computer language (currently unused).
#' @return An invisible string of the path to the saved object.
#' @export
sbf_save_block <- function(x, x_name = substitute(x), sub = sbf_get_sub(),
                           exists = NA,
                           caption = NULL, report = TRUE, language = NULL) {
  check_string(x)
  check_nchar(x)
  x_name <- chk_deparse(x_name)
  check_x_name(x_name)
  check_vector(sub, "", length = c(0L, 1L))
  check_scalar(exists, c(TRUE, NA))

  checkor(check_null(caption), check_string(caption))
  checkor(check_null(language), check_string(language))
  check_flag(report)
  
  sub <- sanitize_path(sub)
  
  meta <- list(caption = caption, report = report, language = language)
  save_meta(meta, "blocks", sub = sub, x_name = x_name)
  save_txt(x, "blocks", sub = sub, x_name = x_name)
  save_rds(x, "blocks", sub = sub, x_name = x_name, exists = exists)
}

#' Save Table
#'
#' @param x The data frame to save.
#' @inheritParams sbf_save_object
#' @param caption A string of the caption.
#' @param report A flag specifying whether to include in a report.
#' @return An invisible string of the path to the saved object.
#' @export
sbf_save_table <- function(x, x_name = substitute(x), sub = sbf_get_sub(), 
                           exists = NA,
                           caption = NULL, report = TRUE) {
  check_data(x)
  x_name <- chk_deparse(x_name)
  check_x_name(x_name)
  check_vector(sub, "", length = c(0L, 1L))
  check_scalar(exists, c(TRUE, NA))

  checkor(check_null(caption), check_string(caption))
  check_flag(report)
  
  sub <- sanitize_path(sub)
  
  meta <- list(caption = caption, report = report)
  save_meta(meta, "tables", sub = sub, x_name = x_name)
  save_csv(x, "tables", sub = sub, x_name = x_name)
  save_rds(x, "tables", sub = sub, x_name = x_name, exists = exists)
}
