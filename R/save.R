file_name <- function(class, sub, x_name, ext) {
  dir <- file_path(sbf_get_main(), class, sub)
  dir_create(dir)
  file <- file_path(dir, x_name)
  ext <- sub("[.]$", "", ext)
  if(!identical(ext, file_ext(x_name)))
    file <- paste0(file, ".", ext)
  
  file
}

save_rds <- function(x, class, sub, x_name) {
  file <- file_name(class, sub, x_name, "rds")
  saveRDS(x, file)
  invisible(file)
}

save_csv <- function(x, class, sub, x_name) {
  x[vapply(x, is.list, TRUE)] <- NULL
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
  meta <- lapply(meta, unname)
  saveRDS(meta, file)
  invisible(file)
}

#' Save Object
#'
#' @param x The object to save.
#' @param x_name A string of the name.
#' @param sub A string specifying the path to the sub folder (by default the current sub folder).
#' @return An invisible string of the path to the saved object.
#' @export
sbf_save_object <- function(x, x_name = substitute(x), sub = sbf_get_sub()) {
  x_name <- chk_deparse(x_name)
  check_x_name(x_name)
  check_vector(sub, "", length = c(0L, 1L))

  sub <- sanitize_path(sub)
  
  save_rds(x, "objects", sub = sub, x_name = x_name)
}

#' Save Data
#'
#' @param x The data frame to save.
#' @inheritParams sbf_save_object
#' @return An invisible string of the path to the saved data.frame
#' @export
sbf_save_data <- function(x, x_name = substitute(x), sub = sbf_get_sub()) {
  check_data(x)
  x_name <- chk_deparse(x_name)
  check_x_name(x_name)
  check_vector(sub, "", length = c(0L, 1L))

  sub <- sanitize_path(sub)
  
  save_rds(x, "data", sub = sub, x_name = x_name)
}

#' Save Number
#'
#' @param x The number to save.
#' @inheritParams sbf_save_object
#' @return An invisible string of the path to the saved object.
#' @export
sbf_save_number <- function(x, x_name = substitute(x), sub = sbf_get_sub()) {
  x_name <- chk_deparse(x_name)
  x <- check_number(x, coerce = TRUE)
  check_x_name(x_name)
  check_vector(sub, "", length = c(0L, 1L))

  sub <- sanitize_path(sub)
  
  save_csv(x, "numbers", sub = sub, x_name = x_name)
  save_rds(x, "numbers", sub = sub, x_name = x_name)
}

#' Save String
#'
#' @param x The string to save.
#' @inheritParams sbf_save_object
#' @return An invisible string of the path to the saved object.
#' @export
sbf_save_string <- function(x, x_name = substitute(x), sub = sbf_get_sub()) {
  x_name <- chk_deparse(x_name)
  x <- check_string(x, coerce = TRUE)
  check_x_name(x_name)
  check_vector(sub, "", length = c(0L, 1L))

  sub <- sanitize_path(sub)
  
  save_txt(x, "strings", sub = sub, x_name = x_name)
  save_rds(x, "strings", sub = sub, x_name = x_name)
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
                           caption = NULL, report = TRUE) {
  x_name <- chk_deparse(x_name)
  check_table(x, x_name = x_name)
  check_x_name(x_name)
  check_vector(sub, "", length = c(0L, 1L))

  checkor(check_null(caption), check_string(caption))
  check_flag(report)
  
  sub <- sanitize_path(sub)
  
  meta <- list(caption = caption, report = report)
  save_meta(meta, "tables", sub = sub, x_name = x_name)
  save_csv(x, "tables", sub = sub, x_name = x_name)
  save_rds(x, "tables", sub = sub, x_name = x_name)
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
                           caption = NULL, report = TRUE, language = NULL) {
  check_string(x)
  check_nchar(x)
  x_name <- chk_deparse(x_name)
  check_x_name(x_name)
  check_vector(sub, "", length = c(0L, 1L))

  checkor(check_null(caption), check_string(caption))
  checkor(check_null(language), check_string(language))
  check_flag(report)
  
  sub <- sanitize_path(sub)
  
  meta <- list(caption = caption, report = report, language = language)
  save_meta(meta, "blocks", sub = sub, x_name = x_name)
  save_txt(x, "blocks", sub = sub, x_name = x_name)
  save_rds(x, "blocks", sub = sub, x_name = x_name)
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
#' @param dpi A number of the resolution in dots per inch.
#' @param csv A count specifying the maximum number of rows to save as a csv file.
#' @export
sbf_save_plot <- function(x = ggplot2::last_plot(), x_name = substitute(x),
                          sub = sbf_get_sub(), 
                          caption = NULL, report = TRUE,
                          width = NA, height = width, dpi = 300,
                          csv = 1000L) {
  
  check_inherits(x, "ggplot")
  x_name <- chk_deparse(x_name)
  if(identical(x_name, "ggplot2::last_plot()"))
    x_name <- "plot"
  check_x_name(x_name)
  check_vector(sub, "", length = c(0L, 1L))

  checkor(check_null(caption), check_string(caption))
  check_flag(report)
  csv <- check_pos_int(csv, coerce = TRUE)
  
  din <- plot_size(width, height)
  
  filename <- file_name("plots", sub, x_name, "png")
  
  ggplot2::ggsave(filename, plot = x, width = din["width"], height = din["height"], 
                  dpi = dpi)
  
  meta <- list(caption = caption, report = report, width = din["width"], height = din["height"],
               dpi = dpi)
  save_meta(meta, "plots", sub = sub, x_name = x_name)
  
  data <- x$data
  if(is.data.frame(data) && nrow(data) <= csv)
    save_csv(data, "plots", sub = sub, x_name = x_name)
  
  save_rds(x, "plots", sub = sub, x_name = x_name)
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
                            width = NA, height = width, dpi = 300,
                            caption = NULL, report = TRUE) {
  
  check_x_name(x_name)
  check_vector(sub, "", length = c(0L, 1L))

  checkor(check_null(caption), check_string(caption))
  check_flag(report)
  
  filename <- file_name("windows", sub, x_name, "png")
  
  device <- grDevices::dev.cur()
  if(identical(device, c("null device" = 1L)))
    err("no such device")
  
  din <- plot_size(width, height)

  grDevices::dev.print(device = grDevices::png, filename = filename, 
                       width = din["width"], height = din["height"],
                       units = "in", res = dpi)

  meta <- list(caption = caption, report = report, width = din["width"],
               height = din["height"], res = dpi)
  save_meta(meta, "windows", sub = sub, x_name = x_name)
  invisible(filename)
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
#' @inheritParams sbf_open_db
#' @inheritParams readwritesqlite::rws_write_sqlite
#' @return An invisible character vector of the paths to the saved objects.
#' @export
sbf_save_datas_to_db <- function(x_name, sub = sbf_get_sub(),
                                 exists = TRUE,
                                 commit = TRUE, strict = TRUE,
                                 env = parent.frame(),
                                 ask = getOption("sbf.ask", TRUE),
                                 silent = getOption("rws.silent", FALSE)
                                 ) {
  check_environment(env)
  
  conn <- sbf_open_db(x_name, sub = sub, exists = exists, ask = ask)
  on.exit(sbf_close_db(conn))
  
  rws_write_sqlite(env, exists = exists, 
                   commit = commit, strict = strict, conn = conn,
                   x_name = x_name, silent = silent)
}
