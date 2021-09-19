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

save_xlsx <- function(x, class, main, sub, x_name) {
  file <- file_name(main, class, sub, x_name, "xlsx")
  writexl::write_xlsx(x, file)
  invisible(file)
}

# this finds which columns have a sfc geomertry other then points 
# returns the names of the columns
find_sfc_columns_to_drop <- function(table) {
  col_drop <- character()
  for (i in colnames(table)) {
    if (inherits(table[[i]], "sfc")) {
      if (!any(grepl("^sfc_POINT$", class(table[[i]])))) {
        col_drop <- c(col_drop, i)
      }
    }
  }
  col_drop
}

## this finds which columns have a point sfc column
## returns the names of the columns
find_columns_points <- function(table) {
  col_point <- character()
  for (i in colnames(table)) {
    if (inherits(table[[i]], "sfc_POINT")) {
      col_point <- c(col_point, i)
    }
  }
  col_point
}

## this finds which columns have class blob
## returns the names of the columns
find_blob_columns_to_drop <- function(table) {
  col_blob <- character()
  for (i in colnames(table)) {
    if (inherits(table[[i]], "blob")) {
      col_blob <- c(col_blob, i)
    }
  }
  col_blob
}

# converts the coords to a different projection
convert_coords <- function(table, epgs) {
  points <- find_columns_points(table)
  for (i in points) {
    table <- sf::st_set_geometry(table, i)
    table <- sf::st_transform(table, epgs)
  }
  table
}

process_sf_columns <- function(table, epgs){
  # identify names of columns with point geometry
  points <- find_columns_points(table)
  
  # convert coords to other formats
  if (!is.null(epgs)) {
    table <- convert_coords(table, epgs)
  }
  
  # convert from sfc object to normal df
  table <- tibble::as_tibble(table)
  
  # this drops any sfc columns that are not point geometry
  drop_columns <- find_sfc_columns_to_drop(table)
  table <- table[ , !names(table) %in% drop_columns, drop = FALSE]
  
  # this drops columns that are blobs
  drop_blob_columns <- find_blob_columns_to_drop(table)
  table <- table[ , !names(table) %in% drop_blob_columns, drop = FALSE]
  
  # this converts point columns into their X, Y and Z coordinates
  # robust for multiple point columns
  for (column in points) {
    X <- paste0(column, "_X")
    Y <- paste0(column, "_Y")
    Z <- paste0(column, "_Z")
    table <- convert_sfc_to_coords(table, column, X, Y, Z)
  }
  table
}

split_excel_large <- function(x, x_name, max_sheets) {
  # this function is for splitting large tables into smaller tables
  # as excel has a maximum number of rows allowed per sheet
  # split into enough new dataframes
  x_split <- split(x, (as.numeric(rownames(x))-1) %/% 1048575L)
  # error catching for giving more sheets then have been split into
  len_x_split <- length(x_split)
  if (max_sheets > len_x_split) {
    max_sheets <- len_x_split
  }
  x_split <- x_split[seq_len(max_sheets)]
  # don't append numbers if only 1 sheet
  if (max_sheets == 1) {
    x_names <- x_name
  } else {
    x_names <- character(length(x_split))
    for (i in seq(length(x_split))) {
      x_names[i] <- paste0(x_name, "_", i)
    }
  }
  # rename them
  names(x_split) <- x_names
  # return named list of dataframes
  x_split
}

save_workbook <- function(x, sub, main, workbook_name, epgs) {
  x <- lapply(x, function(i) {
    x <- process_sf_columns(i, epgs)
  })
  
  save_rds(x, "excel", sub = sub, main = main, x_name = workbook_name)
  save_xlsx(x, "excel", sub = sub, main = main, x_name = workbook_name)
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
  chk_string(x_name)
  chk_gt(nchar(x_name))
  chk_s3_class(sub, "character")
  chk_range(length(sub), c(0L, 1L))
  chk_string(main)
  
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
  chk_s3_class(x, "data.frame")
  x_name <- chk_deparse(x_name)
  chk_string(x_name)
  chk_gt(nchar(x_name))
  chk_s3_class(sub, "character")
  chk_range(length(sub), c(0L, 1L))
  chk_string(main)
  
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
  chk_string(x_name)
  chk_gt(nchar(x_name))
  chk_s3_class(sub, "character")
  chk_range(length(sub), c(0L, 1L))
  chk_string(main)
  
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
  chk_string(x)
  chk_string(x_name)
  chk_gt(nchar(x_name))
  chk_s3_class(sub, "character")
  chk_range(length(sub), c(0L, 1L))
  chk_string(main)
 
  chk_flag(report)
  chk_string(tag)
  
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
  chk_s3_class(x, "data.frame")
  valid <- vapply(x, is_valid_table_column, TRUE)
  if(any(!valid)) {
    abort_chk("the following columns in `x` are not logical, numeric, character, factor, Date or POSIXct: ", 
             cc(names(x)[!valid], " and "))
  }
  chk_string(x_name)
  chk_gt(nchar(x_name))
  chk_s3_class(sub, "character")
  chk_range(length(sub), c(0L, 1L))
  chk_string(main)
  
  chk_string(caption)
  chk_flag(report)
  chk_string(tag)

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
  chk_string(x)
  chk_gt(nchar(x))
  x_name <- chk_deparse(x_name)
  chk_string(x_name)
  chk_gt(nchar(x_name))
  chk_s3_class(sub, "character")
  chk_range(length(sub), c(0L, 1L))
  chk_string(main)
  
  chk_string(caption)
  chk_flag(report)
  chk_string(tag)
  
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
  
  chk_s3_class(x, "ggplot")
  x_name <- chk_deparse(x_name)
  if(identical(x_name, "ggplot2::last_plot()"))
    x_name <- "plot"
  chk_string(x_name)
  chk_gt(nchar(x_name))
  chk_s3_class(sub, "character")
  chk_range(length(sub), c(0L, 1L))
  chk_string(main)
  
  chk_string(caption)
  chk_flag(report)
  chk_string(tag)
  chk_string(units)
  chk_subset(units, c("in", "mm", "cm"))
  
  sub <- sanitize_path(sub)
  main <- sanitize_path(main, rm_leading = FALSE)  
  
  chk_number(dpi)
  chk_gt(dpi)
  chk_whole_number(csv); chk_gte(csv)

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
  
  chk_string(x_name)
  chk_gt(nchar(x_name))
  chk_s3_class(sub, "character")
  chk_range(length(sub), c(0L, 1L))
  chk_string(main)
  chk_string(caption)
  chk_flag(report)
  chk_string(tag)

  chk_string(units)
  chk_subset(units, c("in", "mm", "cm"))
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
  chk_file(x)
  chk_ext(x, "png")
  chk_string(x_name)
  chk_gt(nchar(x_name))
  chk_s3_class(sub, "character")
  chk_range(length(sub), c(0L, 1L))
  chk_string(main)
  
  chk_string(caption)
  chk_flag(report)
  chk_string(tag)

  chk_string(units)
  chk_subset(units, c("in", "mm", "cm"))

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

#' Save Dataframe to Excel Workbook
#' 
#' @details This takes a data frame and saves it to their own excel workbook. 
#' 
#' This function will split up large dataframes into smaller tables for writing
#'  to excel because excel only allows a maximum number of 1,048,576. For the
#'  `max_sheets` argument you can pass a number higher then the required 
#'  and it will only return as many sheets as there is data. 
#' 
#' @param x The data frame to save.
#' @param max_sheets An integer specifying the maximum number of sheets to split 
#'  your table into for writing to excel. The default is 1.
#' @param epgs The projection to convert to
#' @inheritParams sbf_save_object
#' @family excel
#' @return An invisible string of the path to the saved data.frame
#' @examples 
#' \dontrun{
#' sbf_save_excel()
#' }
#' @export
sbf_save_excel <- function(x, 
                           x_name = substitute(x), 
                           max_sheets = 1L,
                           sub = sbf_get_sub(),
                           main = sbf_get_main(), 
                           epgs = NULL) {
  chk::chk_s3_class(x, "data.frame")
  x_name <- chk_deparse(x_name)
  chk::chk_string(x_name)
  chk::chk_gt(nchar(x_name))
  chk::chk_integer(max_sheets)
  chk::chk_gt(max_sheets)
  chk::chk_s3_class(sub, "character")
  chk::chk_range(length(sub))
  chk::chk_string(main)
  chk::chk_null_or(epgs, chk::chk_number)
  
  sub <- sanitize_path(sub)
  main <- sanitize_path(main, rm_leading = FALSE)  
  
  x <- process_sf_columns(x, epgs)
  x <- split_excel_large(x, x_name, max_sheets) 
  
  save_rds(x, "excel", sub = sub, main = main, x_name = x_name)
  save_xlsx(x, "excel", sub = sub, main = main, x_name = x_name)
}

#' Save Dataframes to Excel Workbook
#'
#' This takes the data frames from the environment and saves them to a
#' single excel workbook where each table is its own spreadsheet.
#'   
#' @param epgs The projection to convert to
#' @param workbook_name The name of the excel workbook you are creating. Default
#'  is the base name of the current working directory. 
#' @inheritParams sbf_save_objects
#' @family excel
#' @return An invisible string of the path to the saved data.frame
#' @examples 
#' \dontrun{
#' sbf_save_workbook()
#' }
#' @export

sbf_save_workbook <- function(workbook_name = basename(getwd()),
                              sub = sbf_get_sub(),
                              main = sbf_get_main(), 
                              env = parent.frame(),
                              epgs = NULL) {
  chk::chk_string(workbook_name)
  chk::chk_s3_class(sub, "character")
  chk::chk_range(length(sub))
  chk::chk_string(main)
  chk::chk_null_or(epgs, chk::chk_number)
  chk::chk_s3_class(env, "environment")
  
  names <- objects(envir = env)
  is <- vector("logical", length(names))
  
  datas <- list()
  # create named list of all dataframes in the environment
  for (i in seq_along(names)) {
    x_name <- names[i]
    x <- get(x = x_name, envir = env)
    is[i] <- is.data.frame(x) 
    if (is[i]) {
      datas[[x_name]] <- x
    }
  }
  
  save_workbook(datas, sub, main, workbook_name, epgs)

  names <- names[is]
  if(!length(names)) {
    warning("no datas to save")
    invisible(character(0))
  }
  
  names <- file_path(main, "excel", sub, workbook_name)
  names <- p0(names, ".xlsx")
  invisible(names)
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
                                db_name = sbf_get_db_name(),
                                sub = sbf_get_sub(),
                                main = sbf_get_main(),
                                commit = TRUE, strict = TRUE,
                                silent = getOption("rws.silent", FALSE)
) {
  chk_s3_class(x, "data.frame")
  x_name <- chk_deparse(x_name)
  chk_string(x_name)
  chk_gt(nchar(x_name))
  
  conn <- sbf_open_db(db_name, sub = sub, main = main, exists = TRUE)
  on.exit(sbf_close_db(conn))
  
  rws_write(x, x_name = x_name, exists = TRUE, 
                   commit = commit, strict = strict, conn = conn,
                   silent = silent)
  invisible(file_name(main, "dbs", sub, db_name, ext = "sqlite"))
}

#' Saves Meta Table Descriptions to Database
#' 
#' Saves meta table descriptions to a database.
#' Its important to note that if overwrite = TRUE and x includes
#' blank descriptions then existing non-blank descriptions will be overwritten.
#'  
#' @inheritParams sbf_save_object
#' @inheritParams sbf_save_data_to_db
#' @param x A data.frame with Table, Column and Description columns.
#' @param strict A flag specifying whether to error if x has extraneous descriptions.
#' @param overwrite A flag specifying whether to overwrite existing descriptions.
#' @return A invisible data.frame of the altered descriptions.
#' @export
sbf_save_db_metatable_descriptions <- function(x, db_name = sbf_get_db_name(), 
                                  sub = sbf_get_sub(), main = sbf_get_main(),
                                  overwrite = FALSE, strict = TRUE) {
  check_data(x, values = list(Table = "", Column = "", Description = c("", NA)))
  chk_flag(overwrite)
  chk_flag(strict)
  
  conn <- sbf_open_db(db_name, sub = sub, main = main, exists = TRUE)
  on.exit(sbf_close_db(conn))
  
  x <- x[c("Table", "Column", "Description")]
  if(!nrow(x)) return(invisible(x))
  
  meta <- sbf_load_db_metatable(db_name, sub = sub, main = main)
  x$TableColumn <- paste(x$Table, x$Column)
  meta$TableColumn <- paste(meta$Table, meta$Column)
  if(strict && !vld_subset(x$TableColumn, meta$TableColumn)) { 
    stop("All Table and Column names must be in db.", call. = FALSE)
  }
  
  if(!overwrite) {
    meta <- meta[is.na(meta$Description),,drop = FALSE]
  }
  x <- x[x$TableColumn %in% meta$TableColumn,,drop = FALSE]
  x$TableColumn <- NULL
  if(nrow(x)) {
    rws_describe_meta(x, conn = conn)
  }
  invisible(x)
}

#' Save Objects
#' 
#' @inheritParams sbf_save_object
#' @param env An environment.
#' @return An invisible character vector of the paths to the saved objects.
#' @export
sbf_save_objects <- function(sub = sbf_get_sub(),
                             main = sbf_get_main(), env = parent.frame()) {
  chk_s3_class(env, "environment")
  
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
  chk_s3_class(env, "environment")
  
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
  chk_s3_class(env, "environment")
  
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
  chk_s3_class(env, "environment")
  
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

#' Save Excels 
#' 
#' Saves tables from the environment to their own excel workbook. Each table
#'   will be its own excel workbook. 
#' 
#' @param epgs The projection to convert to
#' @inheritParams sbf_save_datas
#' @family excel
#' @return An invisible string of the path to the saved data.frame
#' @examples 
#' \dontrun{
#' sbf_save_excels()
#' }
#' @export
sbf_save_excels <- function(sub = sbf_get_sub(), 
                            main = sbf_get_main(), 
                            env = parent.frame(), 
                            epgs = NULL) {
  chk::chk_s3_class(env, "environment")
  
  names <- objects(envir = env)
  is <- vector("logical", length(names))
  for (i in seq_along(names)) {
    x_name <- names[i]
    x <- get(x = x_name, envir = env)
    is[i] <- is.data.frame(x)
    if(is[i]) sbf_save_excel(x, x_name, 1L, sub, main, epgs = epgs)
  }
  names <- names[is]
  if(!length(names)) {
    warning("no datas to save")
    invisible(character(0))
  }
  names <- file_path(main, "excel", sub, names)
  names <- p0(names, ".xlsx")
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
sbf_save_datas_to_db <- function(db_name = sbf_get_db_name(), sub = sbf_get_sub(),
                                 main = sbf_get_main(),
                                 commit = TRUE, strict = TRUE,
                                 env = parent.frame(),
                                 silent = getOption("rws.silent", FALSE)
) {
  chk_s3_class(env, "environment")
  
  conn <- sbf_open_db(db_name, sub = sub, main = main, exists = TRUE)
  on.exit(sbf_close_db(conn))
  
  rws_write(env, exists = TRUE, 
                   commit = commit, strict = strict, conn = conn,
                   silent = silent)
}

#' Save Database to Excel Workbook
#'
#' Converts a database to an single excel workbook where each table is its own
#' spreadsheet.
#' @param exclude_tables A regular expression listing tables to be excluded.
#' @inheritParams sbf_save_workbook
#' @inheritParams sbf_open_db
#' @family excel
#' @examples 
#' \dontrun{
#' sbf_save_db_to_workbook()
#' 
#' # exclude the sites table
#' sbf_save_db_to_workbook(exclude_tables = "sites")
#' 
#' # exclude the sites and species table
#' sbf_save_db_to_workbook(exclude_tables = "sites|species")
#' }
#' @export

sbf_save_db_to_workbook <- function(workbook_name = sbf_get_workbook_name(), 
                                    db_name = sbf_get_db_name(), 
                                    exclude_tables = "^$",
                                    sub = sbf_get_sub(), 
                                    main = sbf_get_main(), 
                                    epgs = NULL) {
  chk::chk_string(exclude_tables)
  
  conn <- sbf_open_db(db_name, sub = sub, main = main)
  on.exit(sbf_close_db(conn))
  datas <- rws_read(conn)
  # exclude listed tables
  datas <- datas[datas = !grepl(exclude_tables, names(datas))]
  save_workbook(datas, sub, main, workbook_name, epgs)
  
  names <- file_path(main, "excel", sub, workbook_name)
  names <- p0(names, ".xlsx")
  invisible(names)
}

#' Download files from AWS S3
#'
#' Download files from an AWS S3 bucket into the analysis. 
#' 
#' @param bucket_name A string of the AWS S3 bucket name.
#' @param data_type A string (by default `NULL`) for which data type to return.
#'   Check the folder names within the shiny-upload in AWS for options common
#'   examples include punch-data, tracks, logger, image and pdf.
#' @param year A whole number (by default `NULL`) indicating which year to
#'   return. Format YYYY.
#' @param month A whole number (by default `NULL`) indicating which month to
#'   return. Format MM.
#' @param day A whole number (by default `NULL`) indicating which day to return.
#'   Format DD.
#' @param file_name A string (by default `NULL`) containing the name of the file
#'   to return. Do not include extension type.
#' @param file_extension A string (by default `NULL`) with the file extension to
#'   return. Do not include period.
#' @param max_request_size A whole number (by default `1000`) indicating the
#'   maximum number of files to be returned.
#' @param silent A flag (by default `FALSE`) to silence messages about number of
#'   files returned. Set to `TRUE` to silence messages.
#' @param aws_access_key_id A string of your AWS user access key ID. The default
#'   is the environment variable named `AWS_ACCESS_KEY_ID`.
#' @param aws_secret_access_key A string of your AWS user secret access key. The
#'   default is the environment variable named `AWS_SECRET_ACCESS_KEY`.
#' @param region A string of the AWS region. The default is the environment
#'   variable named `AWS_REGION`.
#' @inheritParams sbf_save_object
#' @examples 
#' \dontrun{
#' sbf_save_aws_files(bucket_name = "exploit-upload-poissonconsulting", 
#' data_type = "upload-recapture",
#' year = 2021,
#' file_name = "processed_data",
#' file_extension = "csv")
#' }
#' @export

sbf_save_aws_files <- function(bucket_name,
                               sub = sbf_get_sub(), 
                               main = sbf_get_main(), 
                               data_type = NULL,
                               year = NULL,
                               month = NULL,
                               day = NULL,
                               file_name = NULL,
                               file_extension = NULL,
                               max_request_size = 1000,
                               silent = TRUE,
                               aws_access_key_id = Sys.getenv("AWS_ACCESS_KEY_ID"),
                               aws_secret_access_key = Sys.getenv("AWS_SECRET_ACCESS_KEY"),
                               region = Sys.getenv("AWS_REGION", "ca-central-1")) {
  
  file_list <- readwriteaws::rwa_list_su_files(bucket_name = bucket_name,
                                               data_type = data_type,
                                               year = year,
                                               month = month,
                                               day = day,
                                               file_name = file_name,
                                               file_extension = file_extension,
                                               max_request_size = max_request_size,
                                               silent = TRUE,
                                               aws_access_key_id = aws_access_key_id,
                                               aws_secret_access_key = aws_secret_access_key,
                                               region = region)
  
  dir <- file_path(main, "aws", sub)
  dir_create(dir)
  
  readwriteaws::rwa_download_files(file_list = file_list, 
                                   directory = dir, 
                                   bucket_name = bucket_name,
                                   aws_access_key_id = aws_access_key_id,
                                   aws_secret_access_key =  aws_secret_access_key,
                                   region = region)
  
  invisible(file_list)
}

