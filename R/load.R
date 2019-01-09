load_rds <- function(x_name, class, sub) {
  check_string(x_name)
  check_vector(sub, "", length = c(0L, 1L))
  sub <- sanitize_path(sub)
  
  dir <- file_path(sbf_get_main(), class, sub, x_name)
  file <- paste0(dir, ".rds")
  if (!file.exists(file)) err("file '", file, "' does not exist")
  readRDS(file)
}

#' Load Object
#'
#' @inheritParams sbf_save_data
#' @return An R object.
#' @export
sbf_load_object <- function(x_name, sub = sbf_get_sub()) {
  load_rds(x_name, class = "objects", sub = sub)
}

#' Load Data
#'
#' @inheritParams sbf_save_object
#' @return A data frame.
#' @export
sbf_load_data <- function(x_name, sub = sbf_get_sub()) {
  load_rds(x_name, class = "data", sub = sub)
}

#' Load Number
#'
#' @inheritParams sbf_save_object
#' @return A number.
#' @export
sbf_load_number <- function(x_name, sub = sbf_get_sub()) {
  load_rds(x_name, class = "numbers", sub = sub)
}

#' Load String
#'
#' @inheritParams sbf_save_object
#' @return A string.
#' @export
sbf_load_string <- function(x_name, sub = sbf_get_sub()) {
  load_rds(x_name, class = "strings", sub = sub)
}

#' Load Code Block
#'
#' @inheritParams sbf_save_object
#' @return A code block.
#' @export
sbf_load_block <- function(x_name, sub = sbf_get_sub()) {
  load_rds(x_name, class = "blocks", sub = sub)
}

#' Load Table
#'
#' @inheritParams sbf_save_object
#' @return A data frame.
#' @export
sbf_load_table <- function(x_name, sub = sbf_get_sub()) {
  load_rds(x_name, class = "tables", sub = sub)
}

load_rdss <- function(class, sub, env) {
  check_vector(sub, "", length = c(0L, 1L))
  sub <- sanitize_path(sub)
  check_environment(env)
  
  path <- file_path(sbf_get_main(), class, sub)
  files <- tools::list_files_with_exts(path, "rds")
  
  if (!length(files)) {
    warning("no ", class, " to load")
    return(invisible(character(0)))
  }
  names <- tools::file_path_sans_ext(basename(files))
  for (i in seq_along(files)) {
    object <- readRDS(files[i])
    assign(names[i], object, envir = env)
  }
  invisible(names)
}

#' Load Objects
#'
#' @inheritParams sbf_save_object
#' @param env The environment to  the objects into
#' @return A invisble character vector of the object's names.
#' @export
sbf_load_objects <- function(sub = sbf_get_sub(), env = parent.frame()) {
  load_rdss("objects", sub, env)
}

#' Load Datas
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects
#' @return A invisble character vector of the data frame's names.
#' @export
sbf_load_datas <- function(sub = sbf_get_sub(), env = parent.frame()) {
  load_rdss("data", sub, env)
}

#' Load Tables
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects
#' @return A invisble character vector of the data frame's names.
#' @export
sbf_load_tables <- function(sub = sbf_get_sub(), env = parent.frame()) {
  load_rdss("tables", sub, env)
}

#' Load Numbers
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects
#' @return A invisble character vector of the numbers's names.
#' @export
sbf_load_numbers <- function(sub = sbf_get_sub(), env = parent.frame()) {
  load_rdss("numbers", sub, env)
}

#' Load Strings
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects
#' @return A invisble character vector of the string's names.
#' @export
sbf_load_strings <- function(sub = sbf_get_sub(), env = parent.frame()) {
  load_rdss("strings", sub, env)
}

#' Load Blocks
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects
#' @return A invisble character vector of the blocks's names.
#' @export
sbf_load_blocks <- function(sub = sbf_get_sub(), env = parent.frame()) {
  load_rdss("blocks", sub, env)
}

#' Save Data Frames to Database
#' 
#' @inheritParams sbf_save_object
#' @inheritParams sbf_save_objects
#' @inheritParams readwritesqlite::rws_write_sqlite
#' @return An invisible character vector of the paths to the saved objects.
#' @export
sbf_load_datas_from_db <- function(x_name, sub = sbf_get_sub(), env = parent.frame()) {
  check_environment(env)
  
  conn <- sbf_open_db(x_name, sub = sub, exists = TRUE)
  on.exit(sbf_close_db(conn))
  
  datas <- rws_read_sqlite(conn)
  mapply(assign, names(datas), datas, MoreArgs = list(envir = env))
  invisible(names(datas))
}

load_rdss_recursive <- function(pattern, class, sub, include_root, fun = identity) {
  check_string(pattern)
  check_vector(sub, "", length = c(0L, 1L))
  sub <- sanitize_path(sub)
  check_flag(include_root)

  dir <- file_path(sbf_get_main(), class, sub)

  files <- list.files(dir, pattern = "[.]rds$", recursive = TRUE)
  names(files) <- file.path(dir, files)
  files <- sub("[.]rds$", "", files)
  files <- files[grepl(pattern, files)]
  if(!include_root) files <- files[grepl("/", files)]

  if (!length(files)) {
    warning("no ", class, " matching regular expression '", pattern, "'")
    return(data.frame(x = list()))
  }
   
  objects <- lapply(names(files), readRDS)
  objects <- lapply(objects, fun)
  
  data <- data.frame(x = I(objects))
  names(data) <- class

  data <- cbind(data, subfolder_columns(files))
  
  as_conditional_tibble(data)
}

#' Load Objects as List Column in Data Frame
#'
#' Recursively loads all the objects matching the regular expression pattern as the 
#' the first (list) column (named objects) in a data frame.
#' Subsequent character vector columns specify the object names (named name) 
#' and sub folders (named Sub1, Sub2 etc).
#' @inheritParams sbf_save_object
#' @param pattern A string of the regular expression to match. 
#' @param include_root A flag indicating whether to include objects in the top sub folder.
#' @export
sbf_load_objects_recursive <- function(pattern = ".*", sub = sbf_get_sub(), include_root = TRUE) {
  load_rdss_recursive(pattern, "objects", sub, include_root)
}
