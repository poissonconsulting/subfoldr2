load_rds <- function(x_name, class, sub, main, fun = NULL) {
  check_string(x_name)
  check_vector(sub, "", length = c(0L, 1L))
  check_string(main)
  
  sub <- sanitize_path(sub)
  main <- sanitize_path(main, rm_leading = FALSE)
  
  dir <- file_path(main, class, sub, x_name)
  file <- paste0(dir, ".rds")
  if (!file.exists(file)) err("file '", file, "' does not exist")
  object <- readRDS(file)
  if(!is.null(fun))
    object <- fun(object)
  object
}

#' Load Object
#'
#' @inheritParams sbf_save_data
#' @return An R object.
#' @export
sbf_load_object <- function(x_name, sub = sbf_get_sub(), main = sbf_get_main()) {
  load_rds(x_name, class = "objects", sub = sub, main = main)
}

#' Load Data
#'
#' @inheritParams sbf_save_object
#' @return A data frame.
#' @export
sbf_load_data <- function(x_name, sub = sbf_get_sub(), main = sbf_get_main()) {
  load_rds(x_name, class = "data", sub = sub, main = main)
}

#' Load Number
#'
#' @inheritParams sbf_save_object
#' @return A number.
#' @export
sbf_load_number <- function(x_name, sub = sbf_get_sub(), main = sbf_get_main()) {
  load_rds(x_name, class = "numbers", sub = sub, main = main)
}

#' Load String
#'
#' @inheritParams sbf_save_object
#' @return A string.
#' @export
sbf_load_string <- function(x_name, sub = sbf_get_sub(), main = sbf_get_main()) {
  load_rds(x_name, class = "strings", sub = sub, main = main)
}

#' Load Code Block
#'
#' @inheritParams sbf_save_object
#' @return A code block.
#' @export
sbf_load_block <- function(x_name, sub = sbf_get_sub(), main = sbf_get_main()) {
  load_rds(x_name, class = "blocks", sub = sub, main = main)
}

#' Load Table
#'
#' @inheritParams sbf_save_object
#' @return A data frame.
#' @export
sbf_load_table <- function(x_name, sub = sbf_get_sub(), main = sbf_get_main()) {
  load_rds(x_name, class = "tables", sub = sub, main = main)
}

#' Load Plot
#'
#' @inheritParams sbf_save_object
#' @return A ggplot object.
#' @export
sbf_load_plot <- function(x_name, sub = sbf_get_sub(), main = sbf_get_main()) {
  load_rds(x_name, class = "plots", sub = sub, main = main)
}

#' Load Plot Data
#'
#' @inheritParams sbf_save_object
#' @return A ggplot object.
#' @export
sbf_load_plot_data <- function(x_name, sub = sbf_get_sub(), main = sbf_get_main()) {
  load_rds(x_name, class = "plots", sub = sub, main = main, fun = get_plot_data)
}

load_rdss <- function(class, sub, main, env, rename, fun = NULL) {
  check_vector(sub, "", length = c(0L, 1L))
  check_string(main)

  check_environment(env)
  check_function(rename, nargs = 1L)
  
  sub <- sanitize_path(sub)
  main <- sanitize_path(main, rm_leading = FALSE)

  path <- file_path(main, class, sub)
  files <- tools::list_files_with_exts(path, "rds")
  
  if (!length(files)) {
    warning("no ", class, " to load")
    return(invisible(character(0)))
  }
  names <- tools::file_path_sans_ext(basename(files))
  for (i in seq_along(files)) {
    object <- readRDS(files[i])
    if(!is.null(fun))
      object <- fun(object)
    assign(rename(names[i]), object, envir = env)
  }
  invisible(names)
}

#' Load Objects
#'
#' @inheritParams sbf_save_object
#' @param rename A single function argument which takes a character vector
#' and returns a character vector of the same length.
#' Used to rename objects before they are loaded into the environment.
#' @param env The environment to  the objects into
#' @return A invisble character vector of the objects' names.
#' @export
sbf_load_objects <- function(sub = sbf_get_sub(), main = sbf_get_main(), 
                             rename = identity, env = parent.frame()) {
  load_rdss("objects", sub = sub, main = main, env = env, rename = rename)
}

#' Load Datas
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects
#' @return A invisble character vector of the data frames' names.
#' @export
sbf_load_datas <- function(sub = sbf_get_sub(), main = sbf_get_main(),
                           rename = identity, env = parent.frame()) {
  load_rdss("data", sub = sub, main = main, env = env, rename = rename)
}

#' Load Tables
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects
#' @return A invisble character vector of the data frames' names.
#' @export
sbf_load_tables <- function(sub = sbf_get_sub(), main = sbf_get_main(),
                            rename = identity, env = parent.frame()) {
  load_rdss("tables", sub = sub, main = main, env = env, rename = rename)
}

#' Load Numbers
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects
#' @return A invisble character vector of the numbers' names.
#' @export
sbf_load_numbers <- function(sub = sbf_get_sub(), main = sbf_get_main(),
                             rename = identity, env = parent.frame()) {
  load_rdss("numbers", sub = sub, main = main, env = env, rename = rename)
}

#' Load Strings
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects
#' @return A invisble character vector of the string' names.
#' @export
sbf_load_strings <- function(sub = sbf_get_sub(), main = sbf_get_main(),
                             rename = identity, env = parent.frame()) {
  load_rdss("strings", sub = sub, main = main, env = env, rename = rename)
}

#' Load Blocks
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects
#' @return A invisble character vector of the blocks' names.
#' @export
sbf_load_blocks <- function(sub = sbf_get_sub(), main = sbf_get_main(),
                            rename = identity, env = parent.frame()) {
  load_rdss("blocks", sub = sub, main = main, env = env, rename = rename)
}

#' Load Plots
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects
#' @return A invisble character vector of the plots' names.
#' @export
sbf_load_plots_data <- function(sub = sbf_get_sub(), main = sbf_get_main(),
                                rename = identity, env = parent.frame()) {
  load_rdss("plots", sub = sub, main = main, env = env, rename = rename)
}

#' Load Plots Data
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects
#' @return A invisble character vector of the plots' names.
#' @export
sbf_load_plots_data <- function(sub = sbf_get_sub(), main = sbf_get_main(),
                                rename = identity, env = parent.frame()) {
  load_rdss("plots", sub = sub, main = main, env = env, rename = rename,
            fun = get_plot_data)
}

#' Save Data Frames to Database
#' 
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects
#' @inheritParams readwritesqlite::rws_write_sqlite
#' @return An invisible character vector of the paths to the saved objects.
#' @export
sbf_load_datas_from_db <- function(x_name, sub = sbf_get_sub(), main = sbf_get_main(),
                                   rename = identity, env = parent.frame()) {
  check_environment(env)
  check_function(rename, nargs = 1L)
  
  conn <- sbf_open_db(x_name, sub = sub, main = main)
  on.exit(sbf_close_db(conn))
  
  datas <- rws_read_sqlite(conn)
  names(datas) <- rename(names(datas))
  mapply(assign, names(datas), datas, MoreArgs = list(envir = env))
  invisible(names(datas))
}

load_rdss_recursive <- function(pattern, class, sub, main, include_root, meta = FALSE,
                                fun = NULL, ext = "rds") {
  check_string(pattern)
  check_vector(sub, "", length = c(0L, 1L))
  check_string(main)
  check_flag(include_root)
  check_flag(meta)
  
  sub <- sanitize_path(sub)
  main <- sanitize_path(main, rm_leading = FALSE)

  dir <- file_path(main, class, sub)
  
  ext <- p0("[.]", ext, "$")

  files <- list.files(dir, pattern = ext, recursive = TRUE)
  names(files) <- file.path(dir, files)
  files <- sub(ext, "", files)
  files <- files[grepl(pattern, files)]
  if(!include_root) files <- files[grepl("/", files)]

  if (!length(files)) {
    data <- data.frame(x = I(list()))
    names(data) <- class
    data$name <- character(0)
    data$file <- character(0)
    return(data)
  }
   
  objects <- lapply(names(files), readRDS)
  if(!is.null(fun))
    objects <- lapply(objects, fun)
  
  data <- data.frame(x = I(objects))
  names(data) <- class

  data <- cbind(data, subfolder_columns(files))
  
  if(meta)
    data <- cbind(data, meta_columns(names(files)))
  
  as_conditional_tibble(data)
}

#' Load Objects as List Column in Data Frame
#'
#' Recursively loads all the objects with names matching the regular expression pattern as the 
#' the first (list) column (named objects) in a data frame.
#' Subsequent character vector columns specify the object names (named name) 
#' and sub folders (named sub1, sub2 etc).
#' @inheritParams sbf_save_object
#' @param pattern A string of the regular expression to match. 
#' @param include_root A flag indicating whether to include objects in the top sub folder.
#' @export
sbf_load_objects_recursive <- function(pattern = ".*", sub = sbf_get_sub(), 
                                       main = sbf_get_main(), include_root = TRUE) {
  load_rdss_recursive(pattern, "objects", sub = sub, main = main, 
                      include_root = include_root)
}

#' Load Data Frames as List Column in Data Frame
#'
#' Recursively loads all the data frames with names matching the regular expression pattern as the 
#' the first (list) column (named data) in a data frame.
#' Subsequent character vector columns specify the object names (named name) 
#' and sub folders (named sub1, sub2 etc).
#' 
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects_recursive
#' @export
sbf_load_datas_recursive <- function(pattern = ".*", sub = sbf_get_sub(), 
                                     main = sbf_get_main(), include_root = TRUE) {
  load_rdss_recursive(pattern, "data", sub = sub, main = main, 
                      include_root = include_root)
}

#' Load Numbers as Column in Data Frame
#'
#' Recursively loads all the numbers with names matching the regular expression pattern as the 
#' the first double column (named numbers) in a data frame.
#' Subsequent character vector columns specify the object names (named name) 
#' and sub folders (named sub1, sub2 etc).
#' 
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects_recursive
#' @export
sbf_load_numbers_recursive <- function(pattern = ".*", sub = sbf_get_sub(), 
                                       main = sbf_get_main(), include_root = TRUE) {
  data <- load_rdss_recursive(pattern, "numbers", sub = sub, main = main, 
                      include_root = include_root)
  data[1] <- unlist(data[1])
  data
}

#' Load Strings as Column in Data Frame
#'
#' Recursively loads all the numbers with names matching the regular expression pattern as the 
#' the first character column (named strings) in a data frame.
#' Subsequent character vector columns specify the object names (named name) 
#' and sub folders (named sub1, sub2 etc).
#' 
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects_recursive
#' @export
sbf_load_strings_recursive <- function(pattern = ".*", sub = sbf_get_sub(), 
                                       main = sbf_get_main(), include_root = TRUE) {
  data <- load_rdss_recursive(pattern, "strings", sub = sub, main = main, 
                      include_root = include_root)
  data[1] <- unlist(data[1])
  data
}

#' Load Data Frames as List Column in Data Frame
#'
#' Recursively loads all the data frames with names matching the regular expression pattern as the 
#' the first (list) column (named tables) in a data frame.
#' Subsequent character vector columns specify the object names (named name) 
#' and sub folders (named sub1, sub2 etc).
#' 
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects_recursive
#' @param meta A flag specifying whether to include the report, caption and any other metadata as columns.
#' @export
sbf_load_tables_recursive <- function(pattern = ".*", sub = sbf_get_sub(), 
                                      main = sbf_get_main(), 
                                      include_root = TRUE, meta = FALSE) {
  load_rdss_recursive(pattern, "tables", sub = sub, main = main, 
                      include_root = include_root, meta = meta)
}

#' Load Blocks as Column in Data Frame
#'
#' Recursively loads all the code blocks with names matching the regular expression pattern as the 
#' the first character column (named blocks) in a data frame.
#' Subsequent character vector columns specify the object names (named name) 
#' and sub folders (named sub1, sub2 etc).
#' 
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects_recursive
#' @inheritParams sbf_load_tables_recursive
#' @export
sbf_load_blocks_recursive <- function(pattern = ".*", sub = sbf_get_sub(),
                                      main = sbf_get_main(),
                                      include_root = TRUE, meta = FALSE) {
  data <- load_rdss_recursive(pattern, "blocks", sub = sub, main = main, 
                      include_root = include_root, meta = meta)
  data[1] <- unlist(data[1])
  data
}

#' Load Plots as List Column in Data Frame
#'
#' Recursively loads all the plots with names matching the regular expression pattern as the 
#' the first (list) column (named plots) in a data frame.
#' Subsequent character vector columns specify the object names (named name) 
#' and sub folders (named sub1, sub2 etc).
#' 
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects_recursive
#' @inheritParams sbf_load_tables_recursive
#' @export
sbf_load_plots_recursive <- function(pattern = ".*", sub = sbf_get_sub(), 
                                     main = sbf_get_main(),
                                     include_root = TRUE, meta = FALSE) {
  load_rdss_recursive(pattern, "plots", sub = sub, main = main, 
                      include_root = include_root, meta = meta)
}

#' Load Plots Data as List Column in Data Frame
#'
#' Recursively loads all the default data from the plots with names matching the regular expression pattern as the 
#' the first (list) column (named plots_data) in a data frame.
#' Subsequent character vector columns specify the object names (named name) 
#' and sub folders (named sub1, sub2 etc).
#' 
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects_recursive
#' @inheritParams sbf_load_tables_recursive
#' @export
sbf_load_plots_data_recursive <- function(pattern = ".*", sub = sbf_get_sub(), 
                                          main = sbf_get_main(),
                                          include_root = TRUE, meta = FALSE) {
  data <- load_rdss_recursive(pattern, "plots", sub = sub, main = main, 
                      include_root = include_root, meta = meta, fun = get_plot_data)
  names(data)[1] <- "plots_data"
  data
}

#' Load Window Paths as Character Column in Data Frame
#'
#' Recursively loads all the paths
#' to the png files with names matching the regular expression pattern as the 
#' the first (list) column (named windows) in a data frame.
#' Subsequent character vector columns specify the object names (named name) 
#' and sub folders (named sub1, sub2 etc).
#' 
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects_recursive
#' @inheritParams sbf_load_tables_recursive
#' @export
sbf_load_windows_recursive <- function(pattern = ".*", sub = sbf_get_sub(), 
                                       main = sbf_get_main(),
                                       include_root = TRUE, meta = FALSE) {
  data <- load_rdss_recursive(pattern, "windows",sub = sub, main = main, 
                      include_root = include_root, meta = meta, ext = "rda")
  data$file <- replace_ext(data$file, "png")
  data$windows <- data$file
  data
}
