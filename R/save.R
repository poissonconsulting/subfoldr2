file_name <- function(class, sub, x_name, ext, exists = NA) {
  dir <- file_path(sbf_get_main(), class, sub)
  dir_create(dir)
  file <- file_path(dir, x_name)
  ext <- sub("[.]$", "", ext)
  if(!identical(ext, file_ext(x_name)))
    file <- paste0(file, ".", ext)
  
  if(isTRUE(exists) && !file.exists(file))
    err("file '", file, "' doesn't exist")
  if(isFALSE(exists) && file.exists(file))
    err("file '", file, "' already exists")
  
  file
}

save_rds <- function(x, class, sub, x_name, exists) {
  file <- file_name(class, sub, x_name, "rds", exists = exists)
  saveRDS(x, file)
  invisible(file)
}

save_csv <- function(x, class, sub, x_name) {
  file <- file_name(class, sub, x_name, "csv")
  write.csv(x, file, row.names = FALSE)
  invisible(file)
}

save_txt <- function(txt, class, sub, x_name) {
  file <- file_name(class, sub, x_name, "txt")
  cat(txt, file = file)
  invisible(file)
}

save_meta <- function(meta, class, sub, x_name) {
  x_name <- paste0("_", x_name)
  file <- file_name(class, sub, x_name, "rda")
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
#' @param x The data frame to save.
#' @inheritParams sbf_save_object
#' @return An invisible string of the path to the saved data.frame
#' @export
sbf_save_data <- function(x, x_name = substitute(x), sub = sbf_get_sub(),
                            exists = NA) {
  check_data(x)
  x_name <- chk_deparse(x_name)
  check_x_name(x_name)
  check_vector(sub, "", length = c(0L, 1L))
  check_scalar(exists, c(TRUE, NA))
  
  sub <- sanitize_path(sub)
  
  save_rds(x, "data", sub = sub, x_name = x_name, exists = exists)
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

#' Save Objects
#' 
#' @inheritParams sbf_save_object
#' @param env An environment.
#' @return An invisible character vector of the paths to the saved objects.
#' @export
sbf_save_objects <- function(sub = sbf_get_sub(), env = parent.frame()) {
  check_environment(env)
  
  names <- objects(envir = env)
  if(!length(names)) {
    warning("no objects to save")
    invisible(character(0))
  }
  for (x_name in names) {
    x <- get(x = x_name, envir = env)
    sbf_save_object(x, x_name, sub)
  }
  names <- file_path(sbf_get_main(), "objects", sub, names)
  names <- p0(names, ".rds")
  invisible(names)
}

#' Save Data Frames
#' 
#' @inheritParams sbf_save_object
#' @inheritParams sbf_save_objects
#' @return An invisible character vector of the paths to the saved objects.
#' @export
sbf_save_datas <- function(sub = sbf_get_sub(), env = parent.frame()) {
  check_environment(env)
  
  names <- objects(envir = env)
  is <- vector("logical", length(names))
  for (i in seq_along(names)) {
    x_name <- names[i]
    x <- get(x = x_name, envir = env)
    is[i] <- is.data.frame(x)
    if(is[i]) sbf_save_data(x, x_name, sub)
  }
  names <- names[is]
  if(!length(names)) {
    warning("no datas to save")
    invisible(character(0))
  }
  names <- file_path(sbf_get_main(), "data", sub, names)
  names <- p0(names, ".rds")
  invisible(names)
}

#' Save Numbers
#' 
#' @inheritParams sbf_save_object
#' @inheritParams sbf_save_objects
#' @return An invisible character vector of the paths to the saved objects.
#' @export
sbf_save_numbers <- function(sub = sbf_get_sub(), env = parent.frame()) {
  check_environment(env)
  
  names <- objects(envir = env)
  is <- vector("logical", length(names))
  for (i in seq_along(names)) {
    x_name <- names[i]
    x <- get(x = x_name, envir = env)
    is[i] <- is_number(x)
    if(is[i]) sbf_save_number(x, x_name, sub)
  }
  names <- names[is]
  if(!length(names)) {
    warning("no numbers to save")
    invisible(character(0))
  }
  names <- file_path(sbf_get_main(), "numbers", sub, names)
  names <- p0(names, ".rds")
  invisible(names)
}

#' Save Strings
#' 
#' @inheritParams sbf_save_object
#' @inheritParams sbf_save_objects
#' @return An invisible character vector of the paths to the saved objects.
#' @export
sbf_save_strings <- function(sub = sbf_get_sub(), env = parent.frame()) {
  check_environment(env)
  
  names <- objects(envir = env)
  is <- vector("logical", length(names))
  for (i in seq_along(names)) {
    x_name <- names[i]
    x <- get(x = x_name, envir = env)
    is[i] <- is_string(x)
    if(is[i]) sbf_save_string(x, x_name, sub)
  }
  names <- names[is]
  if(!length(names)) {
    warning("no strings to save")
    invisible(character(0))
  }
  names <- file_path(sbf_get_main(), "strings", sub, names)
  names <- p0(names, ".rds")
  invisible(names)
}

#' Save Data Frames to Database
#' 
#' @inheritParams sbf_save_object
#' @inheritParams sbf_save_objects
#' @inheritParams readwritesqlite::rws_write_sqlite
#' @return An invisible character vector of the paths to the saved objects.
#' @export
sbf_save_datas_to_db <- function(x_name, sub = sbf_get_sub(),  
                           commit = TRUE, strict = TRUE, env = parent.frame()) {
  check_environment(env)
  
  conn <- sbf_open_db(x_name, sub = sub, exists = TRUE)
  on.exit(sbf_close_db(conn))
  
  rws_write_sqlite(env, commit = commit, strict = strict, conn = conn,
                   x_name = x_name)
}

# Save Plot
#
# @inheritParams save_object
# @param x The ggplot2 object to save (by default taken from the last plot)
# @inheritParams sbf_save_object
# @inheritParams sbf_save_table
# @inheritParams ggplot2::ggsave
# @param csv A flag specifying whether to save a csv of the plot data.
# @export
# save_plot <- function(x = ggplot2::last_plot(), x_name, sub = sbf_get_sub(), 
#                       exists = NA,
#                       caption = NULL, report = TRUE,
#                       width = NA, height = NA, 
#                       units = "in", dpi = 300) {
#   
# check_string(x)
# check_filename(x)
# 
# check_flag(report)
# check_string(main)
# check_string(sub)
# check_string(caption)
# check_flag(ask)
# check_length1(width, c(1, NA))
# check_length1(height, c(1, NA))
# check_flag(csv)
# 
# if (is.null(plot)) error("plot is NULL")
# 
# if (is.na(width)) width <- height
# if (is.na(height)) height <- width
# 
# if (is.na(width)) {
#   if (!length(grDevices::dev.list())) {
#     width = 6
#     height = 6
#   } else {
#     dim <- grDevices::dev.size(units = "in")
#     width <- dim[1]
#     height <- dim[2]
#   }
# }
# 
# save_rds(plot, "plots", main = main, sub = sub, x_name = x, ask = ask)
# 
# meta <- list(width = width, height = height, dpi = dpi, caption = caption, report = report)
# file <- file_path(main, "plots", sub, str_c("_", x)) %>% str_c(".RDS")
# saveRDS(obj, file = file)
# 
# file <- file_path(main, "plots", sub, x) %>% str_c(".csv")
# if (csv) {
#   if(inherits(plot$data, "data.frame")) {
#     data <- plot$data
#     # remove columns that are lists
#     data[vapply(data, is.list, TRUE)] <- NULL
#     readr::write_csv(data, path = file)
#   }
# }
# file %<>% str_replace("[.]csv$", ".png")
# ggplot2::ggsave(file, plot = plot, width = width, height = height, dpi = dpi)
# 
#   invisible(x)
# }

