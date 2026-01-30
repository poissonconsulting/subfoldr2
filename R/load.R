load_rds <- function(x_name, class, sub, main, fun = NULL, exists = TRUE) {
  path <- get_path(x_name, class, sub, main, ext = "rds", exists = exists)
  
  if (!vld_file(path)) {
    return(NULL)
  }
  object <- readRDS(path)
  
  if (!is.null(fun)) {
    object <- fun(object)
  }
  
  if (class == "spatial") {
    valid <- valid_spatial(object)
    if (!valid) wrn(backtick_chk(x_name), "is not a valid spatial object.")
  }
  
  object
}

#' Load Object
#'
#' @inheritParams sbf_save_data
#' @param exists A logical scalar specifying whether the file should exist.
#' @return An R object or NULL if doesn't exist.
#' @family load functions
#' @export
sbf_load_object <- function(x_name,
                            sub = sbf_get_sub(),
                            main = sbf_get_main(),
                            exists = TRUE) {
  load_rds(x_name, class = "objects", sub = sub, main = main, exists = exists)
}

#' Load Data
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_object
#' @return A data frame or NULL if doesn't exist.
#' @family load functions
#' @export
sbf_load_data <- function(x_name,
                          sub = sbf_get_sub(),
                          main = sbf_get_main(),
                          exists = TRUE) {
  load_rds(x_name, class = "data", sub = sub, main = main, exists = exists)
}

#' Load Spatial Data
#'
#' Loads an sf tbl that must meet the same requirements as `sbf_save_spatial`.
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_object
#' @return An sf tbl or NULL if doesn't exist.
#' @family load functions
#' @export
sbf_load_spatial <- function(x_name,
                             sub = sbf_get_sub(),
                             main = sbf_get_main(),
                             exists = TRUE) {
  load_rds(x_name, class = "spatial", sub = sub, main = main, exists = exists)
}

#' Load Number
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_object
#' @return A number or NULL if doesn't exist.
#' @family load functions
#' @export
sbf_load_number <- function(x_name,
                            sub = sbf_get_sub(),
                            main = sbf_get_main(),
                            exists = TRUE) {
  load_rds(x_name, class = "numbers", sub = sub, main = main, exists = exists)
}

#' Load String
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_object
#' @return A string or NULL if doesn't exist.
#' @family load functions
#' @export
sbf_load_string <- function(x_name,
                            sub = sbf_get_sub(),
                            main = sbf_get_main(),
                            exists = TRUE) {
  load_rds(x_name, class = "strings", sub = sub, main = main, exists = exists)
}

#' Load Code Block
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_object
#' @return A code block or NULL if doesn't exist.
#' @family load functions
#' @export
sbf_load_block <- function(x_name,
                           sub = sbf_get_sub(),
                           main = sbf_get_main(),
                           exists = TRUE) {
  load_rds(x_name, class = "blocks", sub = sub, main = main, exists = exists)
}

#' Load Table
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_object
#' @return A data frame or NULL if doesn't exist.
#' @family load functions
#' @export
sbf_load_table <- function(x_name,
                           sub = sbf_get_sub(),
                           main = sbf_get_main(),
                           exists = TRUE) {
  load_rds(x_name, class = "tables", sub = sub, main = main, exists = exists)
}

#' Load Plot
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_object
#' @return A ggplot object or NULL if doesn't exist.
#' @family load functions
#' @export
sbf_load_plot <- function(x_name,
                          sub = sbf_get_sub(),
                          main = sbf_get_main(),
                          exists = TRUE) {
  load_rds(x_name, class = "plots", sub = sub, main = main, exists = exists)
}

#' Load Plot Data
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_object
#' @return A data.frame or NULL if doesn't exist.
#' @family load functions
#' @export
sbf_load_plot_data <- function(x_name,
                               sub = sbf_get_sub(),
                               main = sbf_get_main(),
                               exists = TRUE) {
  load_rds(x_name,
           class = "plots",
           sub = sub,
           main = main,
           fun = get_plot_data,
           exists = exists
  )
}

#' Load Data Frame from Database
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_save_data_to_db
#' @inheritParams sbf_load_objects
#' @inheritParams readwritesqlite::rws_read
#' @return A data.frame of the table.
#' @family load functions
#' @export
sbf_load_data_from_db <- function(x_name,
                                  db_name = sbf_get_db_name(),
                                  sub = sbf_get_sub(),
                                  main = sbf_get_main()) {
  chk_string(x_name)
  chk_string(db_name)
  
  conn <- sbf_open_db(db_name, sub = sub, main = main)
  on.exit(sbf_close_db(conn))
  
  rws_read_table(x_name, conn = conn)
}

#' Load Data Frame of Meta Table from Database
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_save_data_to_db
#' @return A data.frame of the table.
#' @family load functions
#' @export
sbf_load_db_metatable <- function(db_name = sbf_get_db_name(),
                                  sub = sbf_get_sub(),
                                  main = sbf_get_main()) {
  conn <- sbf_open_db(db_name, sub = sub, main = main)
  on.exit(sbf_close_db(conn))
  
  db_metatable_from_connection(conn)
}

load_rdss <- function(class, sub, main, env, rename, fun = NULL) {
  chk_character(sub)
  chk_range(length(sub))
  chk_string(main)
  
  chk_s3_class(env, "environment")
  chk_function(rename)
  
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
    
    if (class == "spatial") {
      valid <- valid_spatial(object)
      if (!valid) wrn(backtick_chk(names[i]), "is not a valid spatial object.")
    }
    
    if (!is.null(fun)) {
      object <- fun(object)
    }
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
#' @family load functions
#' @export
sbf_load_objects <- function(sub = sbf_get_sub(),
                             main = sbf_get_main(),
                             rename = identity,
                             env = parent.frame()) {
  load_rdss("objects", sub = sub, main = main, env = env, rename = rename)
}

#' Load Datas
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects
#' @return A invisble character vector of the data frames' names.
#' @family load functions
#' @export
sbf_load_datas <- function(sub = sbf_get_sub(),
                           main = sbf_get_main(),
                           rename = identity,
                           env = parent.frame()) {
  load_rdss("data", sub = sub, main = main, env = env, rename = rename)
}

#' Load Spatial Datas
#'
#' Loads sf tbls that must meet the same requirements as `sbf_save_spatials`.
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects
#' @return A invisble character vector of the data frames' names.
#' @family load functions
#' @export
sbf_load_spatials <- function(sub = sbf_get_sub(),
                              main = sbf_get_main(),
                              rename = identity,
                              env = parent.frame()) {
  load_rdss("spatial", sub = sub, main = main, env = env, rename = rename)
}

#' Load Tables
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects
#' @return A invisble character vector of the data frames' names.
#' @family load functions
#' @export
sbf_load_tables <- function(sub = sbf_get_sub(),
                            main = sbf_get_main(),
                            rename = identity,
                            env = parent.frame()) {
  load_rdss("tables", sub = sub, main = main, env = env, rename = rename)
}

#' Load Numbers
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects
#' @return A invisble character vector of the numbers' names.
#' @family load functions
#' @export
sbf_load_numbers <- function(sub = sbf_get_sub(),
                             main = sbf_get_main(),
                             rename = identity,
                             env = parent.frame()) {
  load_rdss("numbers", sub = sub, main = main, env = env, rename = rename)
}

#' Load Strings
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects
#' @return A invisble character vector of the string' names.
#' @family load functions
#' @export
sbf_load_strings <- function(sub = sbf_get_sub(),
                             main = sbf_get_main(),
                             rename = identity,
                             env = parent.frame()) {
  load_rdss("strings", sub = sub, main = main, env = env, rename = rename)
}

#' Load Blocks
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects
#' @return A invisble character vector of the blocks' names.
#' @family load functions
#' @export
sbf_load_blocks <- function(sub = sbf_get_sub(),
                            main = sbf_get_main(),
                            rename = identity,
                            env = parent.frame()) {
  load_rdss("blocks", sub = sub, main = main, env = env, rename = rename)
}

#' Load Plots Data
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects
#' @return A invisble character vector of the plots' names.
#' @family load functions
#' @export
sbf_load_plots_data <- function(sub = sbf_get_sub(),
                                main = sbf_get_main(),
                                rename = identity,
                                env = parent.frame()) {
  load_rdss("plots",
            sub = sub, main = main, env = env, rename = rename,
            fun = get_plot_data
  )
}

#' Load Data Frames from Database
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects
#' @param db_name A string of the database name.
#' @inheritParams readwritesqlite::rws_write
#' @return An invisible character vector of the paths to the saved objects.
#' @family load functions
#' @export
sbf_load_datas_from_db <- function(db_name = sbf_get_db_name(),
                                   sub = sbf_get_sub(),
                                   main = sbf_get_main(),
                                   rename = identity,
                                   env = parent.frame()) {
  chk_s3_class(env, "environment")
  chk_function(rename)
  
  conn <- sbf_open_db(db_name, sub = sub, main = main)
  on.exit(sbf_close_db(conn))
  
  datas <- rws_read(conn)
  names(datas) <- rename(names(datas))
  mapply(assign, names(datas), datas, MoreArgs = list(envir = env))
  invisible(names(datas))
}

load_rdss_recursive <- function(x_name, class, sub, main, include_root,
                                tag = ".*", meta = FALSE, drop = character(0),
                                fun = NULL, ext = "rds") {
  chk_string(x_name)
  chk_character(sub)
  chk_range(length(sub))
  chk_string(main)
  chk_flag(include_root)
  chk_string(tag)
  chk_flag(meta)
  
  sub <- sanitize_path(sub)
  main <- sanitize_path(main, rm_leading = FALSE)
  
  dir <- file_path(main, class, sub)
  
  ext <- p0("[.]", ext, "$")
  
  files <- list.files(dir, pattern = ext, recursive = TRUE)
  names(files) <- file.path(dir, files)
  files <- sub(ext, "", files)
  files <- files[grepl(x_name, basename(files))]
  if (!include_root) files <- files[grepl("/", files)]
  
  if (!length(files)) {
    data <- tibble(x = I(list()))
    class(data$x) <- "list"
    names(data) <- class
    data$name <- character(0)
    data$sub <- character(0)
    data$file <- character(0)
    return(data)
  }
  
  if(length(drop) > 0) {
    files <- files[! grepl(pattern = paste0(drop, collapse = '|'), x = files)]
  }
  
  objects <- lapply(names(files), readRDS)
  if (!is.null(fun)) {
    objects <- lapply(objects, fun)
  }
  
  data <- data.frame(x = I(objects))
  names(data) <- class
  data <- cbind(data, subfolder_columns(files))
  
  is_tag <- rep(TRUE, nrow(data))
  if (tag != ".*") {
    is_tag <- grepl(tag, meta_columns(names(files))$tag)
  }
  
  if (meta) data <- cbind(data, meta_columns(names(files)))
  
  data <- data[is_tag, ]
  class(data[[1]]) <- "list"
  as_tibble(data)
}

subs_rds_recursive <- function(x_name,
                               class,
                               sub,
                               main,
                               include_root,
                               ext = "rds") {
  chk_string(x_name)
  chk_character(sub)
  chk_range(length(sub))
  chk_string(main)
  chk_flag(include_root)
  
  sub <- sanitize_path(sub)
  main <- sanitize_path(main, rm_leading = FALSE)
  
  dir <- file_path(main, class, sub)
  
  ext <- p0("[.]", ext, "$")
  files <- list.files(dir, pattern = p0("^", x_name, ext), recursive = TRUE)
  
  names(files) <- file.path(dir, files)
  files <- sub(ext, "", files)
  files <- files[basename(files) == x_name]
  if (!include_root) files <- files[grepl("/", files)]
  
  if (!length(files)) {
    return(character(0))
  }
  
  subfolder_columns(files)$sub
}

#' Load Objects as List Column in Data Frame
#'
#' Recursively loads all the objects with names matching the regular expression
#' x_name as the the first (list) column (named objects) in a data frame.
#' Subsequent character vector columns specify the object names (named name)
#' and sub folders (named sub1, sub2 etc).
#' @inheritParams sbf_save_object
#' @param x_name A string of the regular expression to match.
#' @param include_root A flag indicating whether to include objects in the top
#' sub folder.
#' @family load functions
#' @export
sbf_load_objects_recursive <- function(x_name = ".*",
                                       sub = sbf_get_sub(),
                                       main = sbf_get_main(),
                                       include_root = TRUE) {
  load_rdss_recursive(x_name, "objects",
                      sub = sub, main = main,
                      include_root = include_root
  )
}

#' Load Data Frames as List Column in Data Frame
#'
#' Recursively loads all the data frames with names matching the regular
#' expression x_name as the first (list) column (named data) in a data frame.
#' Subsequent character vector columns specify the object names (named name)
#' and sub folders (named sub1, sub2 etc).
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects_recursive
#' @family load functions
#' @export
sbf_load_datas_recursive <- function(x_name = ".*",
                                     sub = sbf_get_sub(),
                                     main = sbf_get_main(),
                                     include_root = TRUE) {
  data <- load_rdss_recursive(x_name, "data",
                              sub = sub, main = main,
                              include_root = include_root
  )
  data
}

#' Load Numbers as Column in Data Frame
#'
#' Recursively loads all the numbers with names matching the regular expression
#' x_name as the first double column (named numbers) in a data frame.
#' Subsequent character vector columns specify the object names (named name)
#' and sub folders (named sub1, sub2 etc).
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects_recursive
#' @param tag A string of the regular expression that the tag must match to be
#' included.
#' @param meta A flag specifying whether to include the report, caption and any
#' other metadata as columns.
#' @family load functions
#' @export
sbf_load_numbers_recursive <- function(x_name = ".*",
                                       sub = sbf_get_sub(),
                                       main = sbf_get_main(),
                                       include_root = TRUE,
                                       tag = ".*",
                                       meta = FALSE) {
  data <- load_rdss_recursive(x_name, "numbers",
                              sub = sub, main = main,
                              include_root = include_root, tag = tag, meta = meta
  )
  data[1] <- unname(unlist(data[1]))
  data
}

#' Load Strings as Column in Data Frame
#'
#' Recursively loads all the numbers with names matching the regular expression
#' x_name as the first character column (named strings) in a data frame.
#' Subsequent character vector columns specify the object names (named name)
#' and sub folders (named sub1, sub2 etc).
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects_recursive
#' @param tag A string of the regular expression that the tag must match to be
#' included.
#' @param meta A flag specifying whether to include the report, caption and any
#' other metadata as columns.
#' @family load functions
#' @export
sbf_load_strings_recursive <- function(x_name = ".*",
                                       sub = sbf_get_sub(),
                                       main = sbf_get_main(),
                                       include_root = TRUE,
                                       tag = ".*",
                                       meta = FALSE) {
  data <- load_rdss_recursive(x_name, "strings",
                              sub = sub, main = main,
                              include_root = include_root, tag = tag, meta = meta
  )
  if (nrow(data)) {
    data[1] <- unname(unlist(data[1]))
  } else {
    data[1] <- character(0)
  }
  data
}

#' Load Data Frames as List Column in Data Frame
#'
#' Recursively loads all the data frames with names matching the regular
#' expression x_name as the first (list) column (named tables) in a data frame.
#' Subsequent character vector columns specify the object names (named name)
#' and sub folders (named sub1, sub2 etc).
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects_recursive
#' @param tag A string of the regular expression that the tag must match to be
#' included.
#' @param meta A flag specifying whether to include the report, caption and any
#' other metadata as columns.
#' @family load functions
#' @export
sbf_load_tables_recursive <- function(x_name = ".*",
                                      sub = sbf_get_sub(),
                                      main = sbf_get_main(),
                                      include_root = TRUE,
                                      tag = ".*",
                                      meta = FALSE) {
  load_rdss_recursive(x_name, "tables",
                      sub = sub, main = main,
                      include_root = include_root, tag = tag, meta = meta
  )
}

#' Load Blocks as Column in Data Frame
#'
#' Recursively loads all the code blocks with names matching the regular
#' expression x_name as the first character column (named blocks) in a data
#' frame.
#' Subsequent character vector columns specify the object names (named name)
#' and sub folders (named sub1, sub2 etc).
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects_recursive
#' @inheritParams sbf_load_tables_recursive
#' @family load functions
#' @export
sbf_load_blocks_recursive <- function(x_name = ".*",
                                      sub = sbf_get_sub(),
                                      main = sbf_get_main(),
                                      include_root = TRUE,
                                      tag = ".*",
                                      meta = FALSE) {
  data <- load_rdss_recursive(x_name, "blocks",
                              sub = sub, main = main,
                              include_root = include_root, tag = tag, meta = meta
  )
  data[1] <- unname(unlist(data[1]))
  data
}

#' Load Plots as List Column in Data Frame
#'
#' Recursively loads all the plots with names matching the regular expression
#' x_name as the first (list) column (named plots) in a data frame.
#' Subsequent character vector columns specify the object names (named name)
#' and sub folders (named sub1, sub2 etc).
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects_recursive
#' @inheritParams sbf_load_tables_recursive
#' @family load functions
#' @export
sbf_load_plots_recursive <- function(x_name = ".*",
                                     sub = sbf_get_sub(),
                                     main = sbf_get_main(),
                                     include_root = TRUE,
                                     tag = ".*",
                                     meta = FALSE,
                                     drop = character(0)) {
  load_rdss_recursive(x_name, "plots",
                      sub = sub, main = main,
                      include_root = include_root, tag = tag, meta = meta, drop = drop
  )
}

#' Load Plots Data as List Column in Data Frame
#'
#' Recursively loads all the default data from the plots with names matching
#' the regular expression x_name as the first (list) column (named plots_data)
#' in a data frame.
#' Subsequent character vector columns specify the object names (named name)
#' and sub folders (named sub1, sub2 etc).
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects_recursive
#' @inheritParams sbf_load_tables_recursive
#' @family load functions
#' @export
sbf_load_plots_data_recursive <- function(x_name = ".*",
                                          sub = sbf_get_sub(),
                                          main = sbf_get_main(),
                                          include_root = TRUE,
                                          tag = ".*",
                                          meta = FALSE) {
  data <- load_rdss_recursive(x_name, "plots",
                              sub = sub, main = main,
                              include_root = include_root, tag = tag,
                              meta = meta, fun = get_plot_data
  )
  names(data)[1] <- "plots_data"
  data
}

#' Load Window Paths as Character Column in Data Frame
#'
#' Recursively loads all the paths
#' to the png files with names matching the regular expression x_name as the
#' the first (list) column (named windows) in a data frame.
#' Subsequent character vector columns specify the object names (named name)
#' and sub folders (named sub1, sub2 etc).
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects_recursive
#' @inheritParams sbf_load_tables_recursive
#' @family load functions
#' @export
sbf_load_windows_recursive <- function(x_name = ".*",
                                       sub = sbf_get_sub(),
                                       main = sbf_get_main(),
                                       include_root = TRUE,
                                       tag = ".*",
                                       meta = FALSE) {
  data <- load_rdss_recursive(x_name, "windows",
                              sub = sub, main = main,
                              include_root = include_root, tag = tag,
                              meta = meta, ext = "rda"
  )
  data$file <- replace_ext(data$file, "png")
  data$windows <- data$file
  data
}

#' Gets Subs of an Object as a Character Vector
#'
#' Recursively returns all the subs of objects with name x_name.
#' @inheritParams sbf_save_object
#' @param x_name A string of the name.
#' @inheritParams sbf_load_objects_recursive
#' @family load functions
#' @export
sbf_subs_object_recursive <- function(x_name,
                                      sub = sbf_get_sub(),
                                      main = sbf_get_main(),
                                      include_root = TRUE) {
  subs_rds_recursive(x_name, "objects",
                     sub = sub, main = main,
                     include_root = include_root
  )
}

#' Gets Subs of a Data Frame as a Character Vector
#'
#' Recursively returns all the subs of data frames of objects with name x_name.
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects_recursive
#' @inheritParams sbf_subs_object_recursive
#' @family load functions
#' @export
sbf_subs_data_recursive <- function(x_name,
                                    sub = sbf_get_sub(),
                                    main = sbf_get_main(),
                                    include_root = TRUE) {
  subs_rds_recursive(x_name, "data",
                     sub = sub, main = main,
                     include_root = include_root
  )
}

#' Gets Subs of a Number as a Character Vector
#'
#' Recursively returns all the subs of number with name x_name.
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects_recursive
#' @inheritParams sbf_subs_object_recursive
#' @family load functions
#' @export
sbf_subs_number_recursive <- function(x_name,
                                      sub = sbf_get_sub(),
                                      main = sbf_get_main(),
                                      include_root = TRUE) {
  subs_rds_recursive(x_name, "numbers",
                     sub = sub, main = main,
                     include_root = include_root
  )
}

#' Gets Subs of a String as a Character Vector
#'
#' Recursively returns all the subs of string with name x_name.
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects_recursive
#' @inheritParams sbf_subs_object_recursive
#' @family load functions
#' @export
sbf_subs_string_recursive <- function(x_name,
                                      sub = sbf_get_sub(),
                                      main = sbf_get_main(),
                                      include_root = TRUE) {
  subs_rds_recursive(x_name, "strings",
                     sub = sub, main = main,
                     include_root = include_root
  )
}

#' Gets Subs of a Block as a Character Vector
#'
#' Recursively returns all the subs of block with name x_name.
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects_recursive
#' @inheritParams sbf_subs_object_recursive
#' @family load functions
#' @export
sbf_subs_block_recursive <- function(x_name,
                                     sub = sbf_get_sub(),
                                     main = sbf_get_main(),
                                     include_root = TRUE) {
  subs_rds_recursive(x_name, "blocks",
                     sub = sub, main = main,
                     include_root = include_root
  )
}

#' Gets Subs of a Table as a Character Vector
#'
#' Recursively returns all the subs of table with name x_name.
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects_recursive
#' @inheritParams sbf_subs_object_recursive
#' @family load functions
#' @export
sbf_subs_table_recursive <- function(x_name,
                                     sub = sbf_get_sub(),
                                     main = sbf_get_main(),
                                     include_root = TRUE) {
  subs_rds_recursive(x_name, "tables",
                     sub = sub, main = main,
                     include_root = include_root
  )
}

#' Gets Subs of a Plot as a Character Vector
#'
#' Recursively returns all the subs of plot with name x_name.
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects_recursive
#' @inheritParams sbf_subs_object_recursive
#' @family load functions
#' @export
sbf_subs_plot_recursive <- function(x_name,
                                    sub = sbf_get_sub(),
                                    main = sbf_get_main(),
                                    include_root = TRUE) {
  subs_rds_recursive(x_name, "plots",
                     sub = sub, main = main,
                     include_root = include_root
  )
}

#' Gets Subs of a Window as a Character Vector
#'
#' Recursively returns all the subs of window with name x_name.
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects_recursive
#' @inheritParams sbf_subs_object_recursive
#' @family load functions
#' @export
sbf_subs_window_recursive <- function(x_name,
                                      sub = sbf_get_sub(),
                                      main = sbf_get_main(),
                                      include_root = TRUE) {
  subs_rds_recursive(x_name, "windows",
                     sub = sub, main = main,
                     include_root = include_root
  )
}
