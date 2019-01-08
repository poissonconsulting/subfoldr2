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


# load_rds_recursive <- function(x_name, class, sub, include_root, fun = identity) {
#   check_string(x_name)
#   check_vector(sub, "", length = c(0L, 1L))
#   sub <- sanitize_path(sub)
#   check_flag(include_root)
#   
#   dir <- file_path(sbf_get_main(), class, sub)
#   
#   if (!dir.exists(dir)) {
#     warning("no ", class, " named '", x_name, "' to load")
#     return(data.frame(x = list()))
#   }
#   pattern <- str_c(x, ".rds$")
# 
#   files <- list.files(dir, pattern = pattern, recursive = TRUE)
#   if(!top) files <- files[grepl("/", files)]
# 
#   if (!length(files)) {
#     warning("no files with pattern ", pattern, " found")
#     return(invisible(FALSE))
#   }
# 
#   subs <- subs_matrix(files) %>% t()
#   subs %<>% plyr::aaply(1, function(x) {x[max(which(!str_detect(x, "^$")))] <- ""; x},
#                         .drop = FALSE)
# 
#   files %<>% str_c(dir, "/", .)
#   files %<>% lapply(readRDS)
#   files %<>% lapply(fun)
# 
#   if (ncol(subs) > 1) {
#     subs <- subs[, -ncol(subs), drop = FALSE]
#     subs %<>% as.data.frame()
#     colnames(subs) <- str_c("Subfolder", 1:ncol(subs))
#     subs %<>% plyr::alply(.margins = 1, function(x) x)
#     if (subfolder_names) files %<>% purrr::map2(subs, merge, by = NULL)
#     subs %<>% dplyr::bind_rows() %>% as.matrix()
#     subs %<>% plyr::alply(.margins = 1, str_c, collapse = "/")
#     subs %<>% str_replace_all("//", "/") %>% str_replace("/$", "")
#     names(files) <- unlist(subs)
#     if (sub != "") names(files) %<>% file_path(sub, .)
#   } else if (sub != "")
#     names(files) <- sub
#   files
# }

# Load Objects as List Column in Data Frame
#
# Recursively loads all the objects named x_name as a 
# list column in a data frame.
# The objects are in the first column which is named objects.
# @inheritParams save_object
# @param top A flag indicating whether to include objects in the top folder.
# @export
# sbf_load_object_recursive <- function(x_name, sub = sbf_get_sub(), include_root = FALSE) {
#   load_rds_recursive(x_name, "objects", sub, include_root)
# }

