#' Compare Data
#'
#' Compares data using waldo::compare.
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_object
#' @inheritParams base::all.equal
#' @inheritParams waldo::compare
#' @return A character vector with class "waldo_compare".
#' @family compare functions
#' @export
sbf_compare_data <- function(x, x_name = substitute(x),
                             sub = sbf_get_sub(), main = sbf_get_main(),
                             tolerance = sqrt(.Machine$double.eps),
                             ignore_attr = FALSE) {
  rlang::check_installed("waldo")

  chk_s3_class(x, "data.frame")
  x_name <- chk_deparse(x_name)

  sub <- sanitize_path(sub)
  main <- sanitize_path(main, rm_leading = FALSE)

  existing <- sbf_load_data(x_name, sub = sub, main = main, exists = NA)
  waldo::compare(existing, x,
    x_arg = "saved", y_arg = "current",
    tolerance = tolerance,
    ignore_attr = ignore_attr
  )
}

#' Compare Data Archive
#'
#' Compares existing data to archived data using using waldo::compare.
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
sbf_compare_data_archive <- function(x_name = ".*", sub = sbf_get_sub(),
                                     main = sbf_get_main(),
                                     archive = 1L,
                                     recursive = FALSE,
                                     include_root = TRUE,
                                     tolerance = sqrt(.Machine$double.eps),
                                     ignore_attr = FALSE) {
  rlang::check_installed("waldo")

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

  compare <- lapply(all_file_names,
    FUN = compare_data,
    main = main, archive = archive, tolerance = tolerance,
    ignore_attr = ignore_attr
  )
  names(compare) <- all_file_names
  compare
}
