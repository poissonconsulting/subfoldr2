#' Archive Main Folder
#'
#' Archives main folder by copy to a director of the same name
#' with the current date and time appended.
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_set_sub
#' @param tz A string specifying the time zone for the current date and time.
#'
#' @return An invisible string of the path to the archived folder.
#' @family  archive
#' @family housekeeping functions
#' @export
sbf_archive_main <- function(main = sbf_get_main(),
                             ask = getOption("sbf.ask", TRUE),
                             tz = dtt_default_tz()) {
  chk_string(main)
  chk_flag(ask)
  chk_string(tz)

  if(!vld_dir(main)) {
    cli::cli_alert_info(paste0("Directory '", main, "' does not exist."))
    return(invisible(character()))
  }

  archive <- get_new_main(main, tz)
  if (fs::file_exists(archive)) {
    Sys.sleep(1L)
    archive <- get_new_main(main, tz)
    if (fs::file_exists(archive)) {
      stop("File '", archive, "' already exists.")
    }
  }

  msg <- paste0("Copy directory '", main, "' to '", archive, "'?")

  if (!ask || yesno(msg)) {
    fs::dir_copy(main, archive, overwrite = FALSE)
    cli::cli_alert_success(paste0("Directory '", main, "' copied to '", archive, "'"))
  } else {
    cli::cli_alert_warning(paste0("Directory '", main, "' was not copied"))
  }
  return(invisible(archive))
}

#' Unarchive Main Folder
#'
#' Unarchives an archived main folder.
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_set_sub
#' @param archive A positive whole number specifying the folder archived folder
#' where 1L (the default) indicates the most recently archived folder or
#' a character string of the path to the archived folder.
#'
#' @return An invisible string of the path to the previously archived folder.
#' @family  archive
#' @family housekeeping functions
#' @export
sbf_unarchive_main <- function(main = sbf_get_main(),
                               archive = 1L,
                               ask = getOption("sbf.ask", TRUE)) {
  if (!vld_whole_number(archive) && !vld_dir(archive)) {
    chkor_vld(vld_whole_number(archive), vld_dir(archive))
  }
  chk_flag(ask)

  if (vld_numeric(archive)) {
    archive <- sbf_get_archive(main = main, archive = archive)
  }

  sbf_rm_main(main, ask = ask)

  msg <- paste0("Copy directory '", archive, "' to '", main, "'?")

  if (!ask || yesno(msg)) {
    fs::dir_copy(archive, main, overwrite = FALSE)
    sbf_rm_main(archive, ask = FALSE)
  }
  return(invisible(archive))
}

#' Get Archive Directory
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_set_sub
#' @inheritParams sbf_unarchive_main
#'
#' @return A string of the path to the archived directory.
#' @family archive
#' @family directory functions
#' @export
sbf_get_archive <- function(main = sbf_get_main(), archive = 1L) {
  chk_string(main)
  chk_whole_number(archive)
  chk_gt(archive)

  files <- fs::dir_ls(dirname(main),
    type = "directory",
    regexp = ".*-\\d{4,4}(-\\d{2,2}){5,5}$"
  )

  if (!length(files)) {
    stop(
      "There are no archived folders for '",
      basename(main), "' in '",
      dirname(main), "'."
    )
  }

  if (length(files) < archive) {
    stop(
      "There are only ",
      length(files),
      " archived folders for '",
      basename(main), "' in '",
      dirname(main), "'."
    )
  }

  files <- rev(sort(files))
  files[archive]
}
