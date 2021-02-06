list_files <- function(x_name, class, sub, main, recursive, include_root, ext = "rds") {
  chk_string(x_name)
  chk_s3_class(sub, "character")
  chk_range(length(sub), c(0L, 1L))
  chk_string(main)
  chk_flag(recursive)
  chk_flag(include_root)
  chk_string(ext)
  
  sub <- sanitize_path(sub)
  main <- sanitize_path(main, rm_leading = FALSE)
  
  dir <- file_path(main, class, sub)
  
  ext <- p0("[.]", ext, "$")
  
  files <- list.files(dir, pattern = ext, recursive = recursive)
  files <- sanitize_path(files)
  names(files) <- file.path(dir, files)
  files <- sub(ext, "", files)
  files <- files[grepl(x_name, basename(files))]
  if(!include_root) files <- files[grepl("/", files)]
  names <- file_path(class, sub, files)
  files <- names(files)
  if(length(files)) {
    names(files) <- names
  } else 
    names(files) <- character(0)
  files
}

#' Gets List of Object Files as a Character Vector
#'
#' Returns file paths for all object files matching regular expression x_name.
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects_recursive
#' @param x_name A regular expression of the object names to match.
#' @param recursive A flag specifying whether to recurse into subfolders.
#' @param ext A string of the file extension.
#' @export
sbf_list_objects <- function(x_name = ".*", sub = sbf_get_sub(), 
                             main = sbf_get_main(),
                             recursive = FALSE, include_root = TRUE,
                             ext = "rds") {
  chk_string(ext)
  chk_subset(ext, "rds")
  list_files(x_name, "objects", sub = sub, main = main, 
             recursive = recursive,
             include_root = include_root, ext = ext)
}

#' Gets List of Data Files as a Character Vector
#'
#' Returns file paths for all data files matching regular expression x_name.
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects_recursive
#' @inheritParams sbf_list_objects
#' @export
sbf_list_datas <- function(x_name = ".*", sub = sbf_get_sub(), 
                           main = sbf_get_main(),
                           recursive = FALSE, include_root = TRUE,
                           ext = "rds") {
  chk_string(ext)
  chk_subset(ext, "rds")
  list_files(x_name, "data", sub = sub, main = main, 
             recursive = recursive,
             include_root = include_root, ext = ext)
}

#' Gets List of Data Files as a Character Vector
#'
#' Returns file paths for table files matching regular expression x_name.
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects_recursive
#' @inheritParams sbf_list_objects
#' @export
sbf_list_tables <- function(x_name = ".*", sub = sbf_get_sub(), 
                            main = sbf_get_main(),
                            recursive = FALSE, include_root = TRUE,
                            ext = "rds") {
  chk_string(ext)
  chk_subset(ext, c("rds", "csv"))
  list_files(x_name, "tables", sub = sub, main = main, 
             recursive = recursive,
             include_root = include_root, ext = ext)
}

#' Gets List of Number Files as a Character Vector
#'
#' Returns file paths for all number .rds files matching regular expression x_name.
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects_recursive
#' @inheritParams sbf_list_objects
#' @export
sbf_list_numbers <- function(x_name = ".*", sub = sbf_get_sub(), 
                             main = sbf_get_main(),
                             recursive = FALSE, include_root = TRUE,
                             ext = "rds") {
  chk_string(ext)
  chk_subset(ext, c("rds", "csv"))
  list_files(x_name, "numbers", sub = sub, main = main, 
             recursive = recursive,
             include_root = include_root, ext = ext)
}

#' Gets List of String Files as a Character Vector
#'
#' Returns file paths for all string .rds files matching regular expression x_name.
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects_recursive
#' @inheritParams sbf_list_objects
#' @export
sbf_list_strings <- function(x_name = ".*", sub = sbf_get_sub(), 
                             main = sbf_get_main(),
                             recursive = FALSE, include_root = TRUE,
                             ext = "rds") {
  chk_string(ext)
  chk_subset(ext, c("rds", "txt"))
  list_files(x_name, "strings", sub = sub, main = main, 
             recursive = recursive,
             include_root = include_root, ext = ext)
}

#' Gets List of Block Files as a Character Vector
#'
#' Returns file paths for all block files matching regular expression x_name.
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects_recursive
#' @inheritParams sbf_list_objects
#' @export
sbf_list_blocks <- function(x_name = ".*", sub = sbf_get_sub(), 
                            main = sbf_get_main(),
                            recursive = FALSE, include_root = TRUE,
                            ext = "rds") {
  chk_string(ext)
  chk_subset(ext, c("rds", "txt"))
  list_files(x_name, "blocks", sub = sub, main = main, 
             recursive = recursive,
             include_root = include_root, ext = ext)
}

#' Gets List of Plot Files as a Character Vector
#'
#' Returns file paths for all plot files matching regular expression x_name.
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects_recursive
#' @inheritParams sbf_list_objects
#' @export
sbf_list_plots <- function(x_name = ".*", sub = sbf_get_sub(), 
                           main = sbf_get_main(),
                           recursive = FALSE, include_root = TRUE,
                           ext = "rds") {
  chk_string(ext)
  chk_subset(ext, c("rds", "png"))
  list_files(x_name, "plots", sub = sub, main = main, 
             recursive = recursive,
             include_root = include_root, ext = ext)
}

#' Gets List of Window Files as a Character Vector
#'
#' Returns file paths for all window files matching regular expression x_name.
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects_recursive
#' @inheritParams sbf_list_objects
#' @export
sbf_list_windows <- function(x_name = ".*", sub = sbf_get_sub(), 
                             main = sbf_get_main(),
                             recursive = FALSE, include_root = TRUE,
                             ext = "png") {
  chk_string(ext)
  chk_subset(ext, "png")
  list_files(x_name, "windows", sub = sub, main = main, 
             recursive = recursive,
             include_root = include_root, ext = ext)
}

#' Gets List of Database Files as a Character Vector
#'
#' Returns file paths for all database files matching regular expression x_name.
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_objects_recursive
#' @inheritParams sbf_list_objects
#' @export
sbf_list_dbs <- function(x_name = ".*", sub = sbf_get_sub(), 
                         main = sbf_get_main(),
                         recursive = FALSE, include_root = TRUE,
                         ext = "sqlite") {
  chk_string(ext)
  chk_subset(ext, "sqlite")
  list_files(x_name, "dbs", sub = sub, main = main, 
             recursive = recursive,
             include_root = include_root, ext = ext)
}
