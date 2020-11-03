#' Write Datas to Excel File
#'
#' Writes all the data frames in the environment to an xlsx file.
#' Each data frame is saved to a sheet with the same name.
#' 
#' @param exists A logical scalar specifying whether the file should exist.
#' @param path A string of the path to the xlsx file (with the extension).
#' @param ask A flag specifying whether to ask before deleting an existing database (if exists = FALSE).
#' @inheritParams sbf_save_objects
#'
#' @return An invisible character vector of the names of the data frames.
#' @export
sbf_write_datas_to_xlsx <- function(path, exists = NA, env = parent.frame(),
                                    ask = getOption("sbf.ask", TRUE)) {
  chk_string(path)
  chk_lgl(exists)
  chk_flag(ask)
  chk_s3_class(env, "environment")
  
  if(!requireNamespace("writexl", quietly = TRUE))
    stop("Please `install.packages('writexl')`.", call. = FALSE)
  
  
  if (isTRUE(exists)) chk_file(file)
  
  if (isFALSE(exists) && file.exists(file)) {
    if (ask && !yesno("Delete file '", file, "'?")) return(character(0))
    file.remove(file)
  }
  
  names <- objects(envir = env)
  datas <- list()
  for (i in seq_along(names)) {
    x_name <- names[i]
    x <- get(x = x_name, envir = env)
    if(is.data.frame(x))
      datas[[x_name]] <- x
  }
  if(length(datas)) {
    writexl::write_xlsx(datas, path = path)
  } else {
    warning("no datas to write")
    return(invisible(character(0)))
  }
  names(datas)
}
