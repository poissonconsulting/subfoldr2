#' Is Equal Data
#'
#' Test if equal using \code{\link{all.equal}()}.
#' If doesn't exist returns FALSE unless exists = FALSE in which case returns TRUE
#' or exists = NA in which case returns NA.
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_object
#' @inheritParams base::all.equal
#' @return A named flag.
#' @family equal
#' @export
sbf_is_equal_data <- function(x, x_name = substitute(x),
                              sub = sbf_get_sub(), main = sbf_get_main(),
                              exists = TRUE, tolerance = sqrt(.Machine$double.eps),
                              check.attributes = TRUE) {
  chk_s3_class(x, "data.frame")
  x_name <- chk_deparse(x_name)
  chk_scalar(exists)
  chk_logical(exists)

  sub <- sanitize_path(sub)
  main <- sanitize_path(main, rm_leading = FALSE)

  file <- file_path("data", sub, x_name)

  existing <- sbf_load_data(x_name, sub = sub, main = main, exists = NA)
  if (is.null(existing)) {
    return(setNames(!exists, file))
  }
  equal <- vld_true(all.equal(existing, x,
    tolerance = tolerance,
    check.attributes = check.attributes
  ))
  setNames(equal, file)
}

#' Is Equal Datas
#'
#' Test if data are equal using \code{\link{all.equal}()}.
#' If doesn't exist in both returns FALSE
#' unless exists = FALSE in which case returns TRUE
#' or exists = NA in which case returns NA.
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_object
#' @inheritParams sbf_list_objects
#' @inheritParams sbf_unarchive_main
#' @inheritParams base::all.equal
#' @return A named logical vector.
#' @family equal
#' @export
sbf_is_equal_datas <- function(x_name = ".*", sub = sbf_get_sub(), main = sbf_get_main(),
                               archive = 1L, recursive = FALSE, include_root = TRUE,
                               exists = TRUE, tolerance = sqrt(.Machine$double.eps),
                               check.attributes = TRUE) {
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
    return(structure(logical(0), .Names = character(0)))
  }

  equal <- rep(NA, length(all_file_names))
  names(equal) <- all_file_names
  equal <- equal[order(names(equal))]

  shared_file_names <- intersect(names(main_files), names(archive_files))
  all_equal <- vapply(shared_file_names,
    FUN = all_equal_data, TRUE,
    main = main, archive = archive, tolerance = tolerance,
    check.attributes = check.attributes
  )

  equal[names(all_equal)] <- all_equal
  equal[!names(equal) %in% shared_file_names] <- !exists
  equal
}
