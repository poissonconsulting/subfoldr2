rm_class <- function(sub, main, class, ask) {
  chk_string(class)
  chk_flag(ask)

  sub <- sanitize_sub(sub)
  main <- sanitize_path(main, rm_leading = FALSE)
  dir <- file_path(main, class, sub)
  if (!file.exists(dir)) {
    return(invisible(character(0)))
  }
  if (ask && !yesno()) {
    return(invisible(character(0)))
  }
  unlink(dir, recursive = TRUE)
  invisible(dir)
}

#' Delete Flobs Subdfolder
#'
#' @inheritParams sbf_save_object
#' @param ask A flag specifying whether to ask before deleting the subfolder.
#' @return A invisible string of the directory deleted.
#' @family housekeeping functions
#' @export
sbf_rm_flobs <- function(
  sub = sbf_get_sub(),
  main = sbf_get_main(),
  ask = getOption("sbf.ask", TRUE)
) {
  chk_flag(ask)

  rm_class(sub = sub, main = main, class = "flobs", ask = ask)
}

rm_all <- function(ask) {
  chk_flag(ask)

  main <- sbf_get_main()
  sub <- sbf_get_sub()

  if (!dir.exists(main)) {
    return(NULL)
  }

  if (identical(sub, character(0))) {
    if (!ask) {
      chk_no_rm(main)
    }
    return(sbf_rm_main(ask = ask))
  }
  msg <- paste("Delete '", sub, "' subfolders of directory '", main, "'?")

  classes <- c(
    "objects",
    "data",
    "numbers",
    "strings",
    "tables",
    "blocks",
    "plots",
    "dbs",
    "flobs",
    "pdfs",
    "windows",
    "gpkg"
  )
  dirs <- file_path(main, classes, sub)
  if (!ask) {
    chk_no_rm(dirs)
  }

  if (!ask || yesno(msg)) {
    unlink(dirs, recursive = TRUE)
  }
}

chk_no_rm <- function(dirs) {
  if (get_overwrite()) {
    return(invisible(dirs))
  }
  has_files <- vapply(
    dirs,
    function(dir) length(list.files(dir, recursive = TRUE)) > 0L,
    TRUE
  )
  if (any(has_files)) {
    abort_chk(
      "Directory '",
      dirs[has_files][1],
      "' contains files and `getOption(\"sbf.overwrite\")` is FALSE.",
      call = NULL
    )
  }
  invisible(dirs)
}
