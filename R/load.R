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
#' @export
sbf_load_object <- function(x_name, sub = sbf_get_sub()) {
  load_rds(x_name, class = "objects", sub = sub)
}

#' Load Data
#'
#' @inheritParams sbf_save_object
#' @export
sbf_load_data <- function(x_name, sub = sbf_get_sub()) {
  load_rds(x_name, class = "data", sub = sub)
}

#' Load Number
#'
#' @inheritParams sbf_save_object
#' @export
sbf_load_number <- function(x_name, sub = sbf_get_sub()) {
  load_rds(x_name, class = "numbers", sub = sub)
}

#' Load String
#'
#' @inheritParams sbf_save_object
#' @export
sbf_load_string <- function(x_name, sub = sbf_get_sub()) {
  load_rds(x_name, class = "strings", sub = sub)
}

#' Load Code Block
#'
#' @inheritParams sbf_save_object
#' @export
sbf_load_block <- function(x_name, sub = sbf_get_sub()) {
  load_rds(x_name, class = "blocks", sub = sub)
}

#' Load Table
#'
#' @inheritParams sbf_save_object
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
#' @export
sbf_load_objects <- function(sub = sbf_get_sub(), env = parent.frame()) {
  load_rdss("objects", sub, env)
}

#' Load Datas
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects
#' @export
sbf_load_datas <- function(sub = sbf_get_sub(), env = parent.frame()) {
  load_rdss("data", sub, env)
}

#' Load Tables
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects
#' @export
sbf_load_tables <- function(sub = sbf_get_sub(), env = parent.frame()) {
  load_rdss("tables", sub, env)
}

#' Load Numbers
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects
#' @export
sbf_load_numbers <- function(sub = sbf_get_sub(), env = parent.frame()) {
  load_rdss("numbers", sub, env)
}

#' Load Strings
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects
#' @export
sbf_load_strings <- function(sub = sbf_get_sub(), env = parent.frame()) {
  load_rdss("strings", sub, env)
}

#' Load Blocks
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects
#' @export
sbf_load_blocks <- function(sub = sbf_get_sub(), env = parent.frame()) {
  load_rdss("blocks", sub, env)
}
