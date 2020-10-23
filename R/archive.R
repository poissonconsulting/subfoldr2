#' Archive Main Folder
#' 
#' Archives main folder by copy to a director of the same name 
#' with the current date and time appended.
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_set_sub
#' @param tz A string specifying the time zone for the current date and time.
#'
#' @return An invisible string of the name for the archived main folder.
#' @family  archive
#' @export
sbf_archive_main <- function(main = sbf_get_main(), ask = getOption("sbf.ask", TRUE), tz = dtt_default_tz()) {
  chk_dir(main)
  chk_flag(ask)
  chk_string(tz)
  
  date_time <- dtt_sys_date_time(tz = tz)
  date_time <- format(date_time, format = "%Y-%m-%d-%H-%M-%S")
  
  new_main <- paste(main, date_time, sep = "-")

  msg <- paste0("Copy directory '", main, "' to '", new_main, "'?")

  if (!ask || yesno(msg)) {
    fs::dir_copy(main, new_main, overwrite = FALSE)
  }
  return(invisible(new_main))
}

#' Unarchive Main Folder
#' 
#' Unarchives an archived main folder.
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_set_sub
#' @param archive A positive whole number specifying the folder to unarchive 
#' where 1L (the default) indicates the most recently archived folder.
#'
#' @return An invisible string of the name of the unarchived main folder.
#' @family  archive
#' @export
sbf_unarchive_main <- function(main = sbf_get_main(), archive = 1L, ask = getOption("sbf.ask", TRUE)) {
  chk_string(main)
  chk_whole_number(archive)
  chk_gt(archive)
  chk_flag(ask)
  
  files <- fs::dir_ls(dirname(main), type = "directory", regexp = ".*-\\d{4,4}(-\\d{2,2}){5,5}$")
  if(!length(files))
    stop("There are no archived folders for '", basename(main) , "' in '", dirname(main), "'.")

  if(length(files) < archive)
    stop("There are only ", length(files), " archived folders for '", basename(main) , "' in '", dirname(main), "'.")
    
  new_main <- rev(sort(files))[archive]
  
  sbf_rm_main(main, ask = ask)

  msg <- paste0("Copy directory '", new_main, "' to '", main, "'?")
  
  if (!ask || yesno(msg)) {
    fs::dir_copy(new_main, main, overwrite = FALSE)
    sbf_rm_main(new_main, ask = FALSE)
  }
  return(invisible(new_main))
}
