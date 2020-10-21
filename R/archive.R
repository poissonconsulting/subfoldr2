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
#' @export
sbf_archive_main <- function(main = sbf_get_main(), ask = getOption("sbf.ask", TRUE), tz = dtt_default_tz()) {
  chk_dir(main)
  chk_flag(ask)
  chk_string(tz)
  
  date_time <- dtt_sys_date_time(tz = tz)
  date_time <- format(date_time, format = "%Y-%m-%d-%H-%M-%S")
  
  new_main <- paste(main, date_time, sep = "-")
  
  msg <- paste0("Rename directory '", main, "' to '", new_main, "'?")

  if (!ask || yesno(msg)) {
    fs::dir_copy(main, new_main, overwrite = FALSE)
  }
  return(invisible(new_main))
}
