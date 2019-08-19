file_name <- function(main, class, sub, x_name, ext) {
  dir <- file_path(main, class, sub)
  dir_create(dir)
  file <- file_path(dir, x_name)
  ext <- sub("[.]$", "", ext)
  if(!identical(ext, file_ext(x_name)))
    file <- paste0(file, ".", ext)
  
  file
}

save_rds <- function(x, class, main, sub, x_name) {
  file <- file_name(main, class, sub, x_name, "rds")
  saveRDS(x, file)
  invisible(file)
}

save_csv <- function(x, class, sub, main, x_name) {
  x[vapply(x, is.list, TRUE)] <- NULL
  file <- file_name(main, class, sub, x_name, "csv")
  write.csv(x, file, row.names = FALSE)
  invisible(file)
}

save_txt <- function(txt, class, sub, main, x_name) {
  file <- file_name(main, class, sub, x_name, "txt")
  writeLines(txt, file)
  invisible(file)
}

save_meta <- function(meta, class, sub, main, x_name) {
  file <- file_name(main, class, sub, x_name, "rda")
  meta <- lapply(meta, unname)
  saveRDS(meta, file)
  invisible(file)
}

read_meta <- function(class, sub, main, x_name) {
  file <- file_name(main, class, sub, x_name, "rda")
  if(!file.exists(file)) return(list())
  readRDS(file)
}

#' Save Object
#'
#' @param x The object to save.
#' @param x_name A string of the name.
#' @param sub A string specifying the path to the sub folder (by default the current sub folder).
#' @param main A string specifying the path to the main folder (by default the current main folder)
#' @return An invisible string of the path to the saved object.
#' @export
sbf_save_object <- function(x, x_name = substitute(x), sub = sbf_get_sub(),
                            main = sbf_get_main()) {
  x_name <- chk_deparse(x_name)
  check_x_name(x_name)
  check_vector(sub, "", length = c(0L, 1L))
  check_string(main)
  
  sub <- sanitize_path(sub)
  main <- sanitize_path(main, rm_leading = FALSE)  
  
  save_rds(x, "objects", sub = sub, main = main, x_name = x_name)
}

#' Save Data
#'
#' @param x The data frame to save.
#' @inheritParams sbf_save_object
#' @return An invisible string of the path to the saved data.frame
#' @export
sbf_save_data <- function(x, x_name = substitute(x), sub = sbf_get_sub(),
                          main = sbf_get_main()) {
  check_data(x)
  x_name <- chk_deparse(x_name)
  check_x_name(x_name)
  check_vector(sub, "", length = c(0L, 1L))
  check_string(main)
  
  sub <- sanitize_path(sub)
  main <- sanitize_path(main, rm_leading = FALSE)  
  
  save_rds(x, "data", sub = sub, main = main, x_name = x_name)
}

#' Save Number
#'
#' @param x The number to save.
#' @inheritParams sbf_save_object
#' @return An invisible string of the path to the saved object.
#' @export
sbf_save_number <- function(x, x_name = substitute(x), sub = sbf_get_sub(),
                            main = sbf_get_main()) {
  x_name <- chk_deparse(x_name)
  chk_number(x)
  x <- as.double(x)
  check_x_name(x_name)
  check_vector(sub, "", length = c(0L, 1L))
  check_string(main)
  
  sub <- sanitize_path(sub)
  main <- sanitize_path(main, rm_leading = FALSE)  
  
  save_csv(x, "numbers", sub = sub, main = main, x_name = x_name)
  save_rds(x, "numbers", sub = sub, main = main, x_name = x_name)
}

#' Save String
#' 
#' A string in this context is a character vector of length one of inline text.
#'
#' @param x The string to save.
#' @inheritParams sbf_save_object
#' @param report A flag specifying whether to include in a report.
#' @param tag A string of the tag.
#' @return An invisible string of the path to the saved object.
#' @export
sbf_save_string <- function(x, x_name = substitute(x), sub = sbf_get_sub(),
                            main = sbf_get_main(), report = TRUE, tag = "") {
  x_name <- chk_deparse(x_name)
  check_string(x)
  check_x_name(x_name)
  check_vector(sub, "", length = c(0L, 1L))
  check_string(main)
 
  check_flag(report)
  check_string(tag)
  
  sub <- sanitize_path(sub)
  main <- sanitize_path(main, rm_leading = FALSE)
  
  meta <- list(report = report, tag = tag)
  save_meta(meta, "strings", sub = sub, main = main, x_name = x_name)
  save_txt(x, "strings", sub = sub, main = main, x_name = x_name)
  save_rds(x, "strings", sub = sub, main = main, x_name = x_name)
}

#' Save Table
#'
#' @param x The data frame to save.
#' @inheritParams sbf_save_object
#' @param caption A string of the caption.
#' @param report A flag specifying whether to include in a report.
#' @param tag A string of the tag.
#' @return An invisible string of the path to the saved object.
#' @export
sbf_save_table <- function(x, x_name = substitute(x), sub = sbf_get_sub(), 
                           main = sbf_get_main(),
                           caption = "", report = TRUE, tag = "") {
  x_name <- chk_deparse(x_name)
  check_table(x, x_name = x_name)
  check_x_name(x_name)
  check_vector(sub, "", length = c(0L, 1L))
  check_string(main)
  
  check_string(caption)
  check_flag(report)
  check_string(tag)

  sub <- sanitize_path(sub)
  main <- sanitize_path(main, rm_leading = FALSE)  
  
  meta <- list(caption = caption, report = report, tag = tag)
  save_meta(meta, "tables", sub = sub, main = main, x_name = x_name)
  save_csv(x, "tables", sub = sub, main = main, x_name = x_name)
  save_rds(x, "tables", sub = sub, main = main, x_name = x_name)
}

#' Save Block
#' 
#' A block in this context is a character vector of length one of.
#' 
#' @param x A string of the block to save.
#' @inheritParams sbf_save_object
#' @inheritParams sbf_save_table
#' @return An invisible string of the path to the saved object.
#' @export
sbf_save_block <- function(x, x_name = substitute(x), sub = sbf_get_sub(),
                           main = sbf_get_main(),
                           caption = "", report = TRUE, tag = "") {
  check_string(x)
  check_nchar(x)
  x_name <- chk_deparse(x_name)
  check_x_name(x_name)
  check_vector(sub, "", length = c(0L, 1L))
  check_string(main, coerce = TRUE)
  
  check_string(caption)
  check_flag(report)
  check_string(tag)
  
  sub <- sanitize_path(sub)
  main <- sanitize_path(main, rm_leading = FALSE)  
  
  meta <- list(caption = caption, report = report, tag = tag)
  save_meta(meta, "blocks", sub = sub, main = main, x_name = x_name)
  save_txt(x, "blocks", sub = sub, main = main, x_name = x_name)
  save_rds(x, "blocks", sub = sub, main = main, x_name = x_name)
}

#' Save Plot
#'
#' Saves a ggplot object.
#' By default it saves the last plot to be modified or created.
#' 
#' @param x The ggplot object to save. 
#' @inheritParams sbf_save_object
#' @inheritParams sbf_save_table
#' @inheritParams ggplot2::ggsave
#' @param width A number of the plot width in inches.
#' @param height A number of the plot width in inches.
#' @param units A string of the units. Can be "in" (default) or "mm" or "cm".
#' @param dpi A number of the resolution in dots per inch.
#' @param csv A count specifying the maximum number of rows to save as a csv file.
#' @export
sbf_save_plot <- function(x = ggplot2::last_plot(), x_name = substitute(x),
                          sub = sbf_get_sub(), 
                          main = sbf_get_main(),
                          caption = "", report = TRUE, 
                          tag = "",
                          units = "in",
                          width = NA, height = width, dpi = 300,
                          limitsize = TRUE,
                          csv = 1000L) {
  
  check_inherits(x, "ggplot")
  x_name <- chk_deparse(x_name)
  if(identical(x_name, "ggplot2::last_plot()"))
    x_name <- "plot"
  check_x_name(x_name)
  check_vector(sub, "", length = c(0L, 1L))
  check_string(main)
  
  check_string(caption)
  check_flag(report)
  check_string(tag)
  check_scalar(units, c("in", "mm", "cm"))
  
  sub <- sanitize_path(sub)
  main <- sanitize_path(main, rm_leading = FALSE)  
  
  chk_number(dpi)
  chk_gt(dpi)
  check_count(csv)

  csv <- as.integer(csv)
  
  filename <- file_name(main, "plots", sub, x_name, "png")
  
  dim <- plot_size(c(width, height), units = units)
  
  ggplot2::ggsave(filename, plot = x, width = dim[1], height = dim[2], 
                  dpi = dpi, limitsize = limitsize)
  
  meta <- list(caption = caption, report = report, tag = tag, 
               width = dim[1], height = dim[2],
               dpi = dpi)
  save_meta(meta, "plots", sub = sub, main = main, x_name = x_name)
  
  data <- x$data
  if(is.data.frame(data) && nrow(data) <= csv)
    save_csv(data, "plots", sub = sub, main = main, x_name = x_name)
  
  save_rds(x, "plots", sub = sub, main = main, x_name = x_name)
}

#' Save Window
#'
#' Saves the current graphics device to a png file.
#' 
#' @inheritParams sbf_save_object
#' @inheritParams sbf_save_table
#' @inheritParams sbf_save_plot
#' 
#' @export
sbf_save_window <- function(x_name = "window",
                            sub = sbf_get_sub(), 
                            main = sbf_get_main(),
                            caption = "", report = TRUE, tag = "",
                            width = NA, height = width, units = "in", 
                            dpi = 300) {
  
  check_x_name(x_name)
  check_vector(sub, "", length = c(0L, 1L))
  check_string(main)
  check_string(caption)
  check_flag(report)
  check_string(tag)

  check_scalar(units, c("in", "mm", "cm"))
  chk_number(dpi)
  chk_gt(dpi)

  sub <- sanitize_path(sub)
  main <- sanitize_path(main, rm_leading = FALSE)  
  
  device <- grDevices::dev.cur()
  if(identical(device, c("null device" = 1L)))
    err("no such device")
  
  filename <- file_name(main, "windows", sub, x_name, "png")
  
  dim <- plot_size(c(width, height), units = units)
  
  grDevices::dev.print(device = grDevices::png, filename = filename, 
                       width = dim[1], height = dim[2],
                       units = "in", res = dpi)
  
  meta <- list(caption = caption, report = report, tag = tag,
               width = dim[1], height = dim[2], dpi = dpi)
  save_meta(meta, "windows", sub = sub, main = main, x_name = x_name)
  invisible(filename)
}

#' Extension-less Base File Names
#' 
#' Just a wrapper on \code{\link{basename}()} and \code{\link[tools]{file_path_sans_ext}()}.
#'
#' @param x A character vector of file paths.
#' @return A character vector of extension-less base file names.
#' @export
#' @examples
#' sbf_basename_sans_ext("path/file.ext")
sbf_basename_sans_ext <- function(x) {
  x <- basename(x)
  x <- tools::file_path_sans_ext(x)
  x
}

#' Save png File
#'
#' Saves a png file to the windows.
#' 
#' @param x A string of the path to the png file to save.
#' @inheritParams sbf_save_object
#' @inheritParams sbf_save_table
#' @inheritParams sbf_save_plot
#' 
#' @export
sbf_save_png <- function(x, x_name = sbf_basename_sans_ext(x),
                         sub = sbf_get_sub(), 
                         main = sbf_get_main(),
                         caption = "", report = TRUE,
                         tag = "",
                         width = NA, units = "in") {
  check_string(x) 
  check_x_name(x_name)
  check_vector(sub, "", length = c(0L, 1L))
  check_string(main)
  
  check_string(caption)
  check_flag(report)
  check_string(tag)

  check_scalar(units, c("in", "mm", "cm"))
  
  if(!file.exists(x)) err("file '", x, "' does not exist")
  
  if(!grepl("[.]png$", x)) err("file '", x, "' must be a .png file")
  
  sub <- sanitize_path(sub)
  main <- sanitize_path(main, rm_leading = FALSE) 
  
  dim <- plot_size(c(width, height = NA), units = units)
  png_dim <- png_dim(x)
  dim[2] <- dim[1] * png_dim[2] / png_dim[1]
  dpi <- png_dim[1] / dim[1]
  
  filename <- file_name(main, "windows", sub, x_name, "png")
  file.copy(x, filename, overwrite = TRUE)
  
  meta <- list(caption = caption, report = report, tag = tag,
               width = dim[1], height = dim[2], dpi = dpi)
  save_meta(meta, "windows", sub = sub, main = main, x_name = x_name)
  invisible(filename)
}

#' Save Data Frame to Existing Database
#' 
#' @inheritParams sbf_save_object
#' @param x_name A string of the table name.
#' @param db_name A string of the database name.
#' @inheritParams sbf_open_db
#' @inheritParams readwritesqlite::rws_write
#' @return An invisible character vector of the paths to the saved objects.
#' @export
sbf_save_data_to_db <- function(x, x_name = substitute(x),
                                db_name = "database",
                                sub = sbf_get_sub(),
                                main = sbf_get_main(),
                                commit = TRUE, strict = TRUE,
                                silent = getOption("rws.silent", FALSE)
) {
  check_data(x)
  x_name <- chk_deparse(x_name)
  check_x_name(x_name)
  
  conn <- sbf_open_db(db_name, sub = sub, main = main, exists = TRUE)
  on.exit(sbf_close_db(conn))
  
  rws_write(x, x_name = x_name, exists = TRUE, 
                   commit = commit, strict = strict, conn = conn,
                   silent = silent)
  invisible(file_name(main, "dbs", sub, db_name, ext = "sqlite"))
}

#' Save Objects
#' 
#' @inheritParams sbf_save_object
#' @param env An environment.
#' @return An invisible character vector of the paths to the saved objects.
#' @export
sbf_save_objects <- function(sub = sbf_get_sub(),
                             main = sbf_get_main(), env = parent.frame()) {
  check_environment(env)
  
  names <- objects(envir = env)
  if(!length(names)) {
    warning("no objects to save")
    invisible(character(0))
  }
  for (x_name in names) {
    x <- get(x = x_name, envir = env)
    sbf_save_object(x, x_name, sub, main)
  }
  names <- file_path(main, "objects", sub, names)
  names <- p0(names, ".rds")
  invisible(names)
}

#' Save Data Frames
#' 
#' @inheritParams sbf_save_object
#' @inheritParams sbf_save_objects
#' @return An invisible character vector of the paths to the saved objects.
#' @export
sbf_save_datas <- function(sub = sbf_get_sub(),
                           main = sbf_get_main(), env = parent.frame()) {
  check_environment(env)
  
  names <- objects(envir = env)
  is <- vector("logical", length(names))
  for (i in seq_along(names)) {
    x_name <- names[i]
    x <- get(x = x_name, envir = env)
    is[i] <- is.data.frame(x)
    if(is[i]) sbf_save_data(x, x_name, sub, main)
  }
  names <- names[is]
  if(!length(names)) {
    warning("no datas to save")
    invisible(character(0))
  }
  names <- file_path(main, "data", sub, names)
  names <- p0(names, ".rds")
  invisible(names)
}

#' Save Numbers
#' 
#' @inheritParams sbf_save_object
#' @inheritParams sbf_save_objects
#' @return An invisible character vector of the paths to the saved objects.
#' @export
sbf_save_numbers <- function(sub = sbf_get_sub(),
                             main = sbf_get_main(), env = parent.frame()) {
  check_environment(env)
  
  names <- objects(envir = env)
  is <- vector("logical", length(names))
  for (i in seq_along(names)) {
    x_name <- names[i]
    x <- get(x = x_name, envir = env)
    is[i] <- is_number(x)
    if(is[i]) sbf_save_number(x, x_name, sub, main)
  }
  names <- names[is]
  if(!length(names)) {
    warning("no numbers to save")
    invisible(character(0))
  }
  names <- file_path(main, "numbers", sub, names)
  names <- p0(names, ".rds")
  invisible(names)
}

#' Save Strings
#' 
#' @inheritParams sbf_save_object
#' @inheritParams sbf_save_objects
#' @return An invisible character vector of the paths to the saved objects.
#' @export
sbf_save_strings <- function(sub = sbf_get_sub(),
                             main = sbf_get_main(), env = parent.frame()) {
  check_environment(env)
  
  names <- objects(envir = env)
  is <- vector("logical", length(names))
  for (i in seq_along(names)) {
    x_name <- names[i]
    x <- get(x = x_name, envir = env)
    is[i] <- is_string(x)
    if(is[i]) sbf_save_string(x, x_name, sub, main)
  }
  names <- names[is]
  if(!length(names)) {
    warning("no strings to save")
    invisible(character(0))
  }
  names <- file_path(main, "strings", sub, names)
  names <- p0(names, ".rds")
  invisible(names)
}

#' Save Data Frames to Existing Database
#' 
#' @inheritParams sbf_save_object
#' @inheritParams sbf_save_objects
#' @inheritParams sbf_open_db
#' @param db_name A string of the database name.
#' @inheritParams readwritesqlite::rws_write
#' @return An invisible character vector of the paths to the saved objects.
#' @export
sbf_save_datas_to_db <- function(db_name = "database", sub = sbf_get_sub(),
                                 main = sbf_get_main(),
                                 commit = TRUE, strict = TRUE,
                                 env = parent.frame(),
                                 silent = getOption("rws.silent", FALSE)
) {
  check_environment(env)
  
  conn <- sbf_open_db(db_name, sub = sub, main = main, exists = TRUE)
  on.exit(sbf_close_db(conn))
  
  rws_write(env, exists = TRUE, 
                   commit = commit, strict = strict, conn = conn,
                   silent = silent)
}
