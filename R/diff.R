#' Diff Data
#'
#' Find differences with existing data.
#' If doesn't existx is compared to itself.
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_object
#' @return A daff difference object.
#' @family compare functions
#' @export
sbf_diff_data <- function(x, x_name = substitute(x),
                          sub = sbf_get_sub(), main = sbf_get_main()) {
  chk_s3_class(x, "data.frame")
  x_name <- chk_deparse(x_name)

  if (!requireNamespace("daff", quietly = TRUE)) {
    stop("Please `install.packages('daff')`.", call. = FALSE)
  }

  existing <- sbf_load_data(x_name, sub = sub, main = main, exists = NA)
  if (is.null(existing)) existing <- x
  daff::diff_data(existing, x)
}


#' Diff Datas
#'
#' Find differences with existing data.
#' If doesn't exist  is compared to itself.
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_object
#' @inheritParams sbf_list_objects
#' @inheritParams sbf_unarchive_main
#' @inheritParams base::all.equal
#' @inheritParams waldo::compare
#' @return A named list of character vectors.
#' @family compare functions
#' @export
sbf_diff_datas <- function(x_name = ".*",
                           sub = sbf_get_sub(),
                           main = sbf_get_main(),
                           archive = 1L,
                           recursive = FALSE,
                           include_root = TRUE,
                           exists = NA) {
  chk_lgl(exists)

  if (!requireNamespace("daff", quietly = TRUE)) {
    stop("Please `install.packages('daff')`.", call. = FALSE)
  }

  if (!vld_whole_number(archive) && !vld_dir(archive)) {
    chkor_vld(vld_whole_number(archive), vld_dir(archive))
  }
  if (vld_numeric(archive)) {
    archive <- sbf_get_archive(main = main, archive = archive)
  }

  main_files <- sbf_list_datas(
    x_name = x_name, sub = sub, main = main,
    recursive = recursive, include_root = include_root
  )

  archive_files <- sbf_list_datas(
    x_name = x_name, sub = sub, main = archive,
    recursive = recursive, include_root = include_root
  )

  all_file_names <- union(names(main_files), names(archive_files))

  if (!length(all_file_names)) {
    return(structure(list(), .Names = character(0)))
  }

  all_file_names <- sort(all_file_names)

  diff <- lapply(all_file_names,
    FUN = diff_data,
    main = main, archive = archive
  )
  names(diff) <- all_file_names
  diff
}

#' Diff Table
#'
#' Find differences with existing table data.
#' If doesn't exist (exists = NA) x is compared to itself.
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_object
#' @return A daff difference object.
#' @family compare functions
#' @export
sbf_diff_table <- function(x, x_name = substitute(x),
                           sub = sbf_get_sub(), main = sbf_get_main(),
                           exists = NA) {
  chk_s3_class(x, "data.frame")
  x_name <- chk_deparse(x_name)

  if (!requireNamespace("daff", quietly = TRUE)) {
    stop("Please `install.packages('daff')`.", call. = FALSE)
  }

  existing <- sbf_load_table(x_name, sub = sub, main = main, exists = exists)
  if (is.null(existing)) existing <- x
  daff::diff_data(existing, x)
}
