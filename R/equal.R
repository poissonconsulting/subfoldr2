#' Is Equal Data
#' 
#' Test if equal using \code{\link{all.equal}()}.
#' If doesn't exist and exists = NA or exists = FALSE then returns TRUE.
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_object
#' @inheritParams base::all.equal
#' @return A named logical scalar.
#' @export
sbf_is_equal_data <- function(x, x_name = substitute(x), 
                              sub = sbf_get_sub(), main = sbf_get_main(), 
                              exists = TRUE, tolerance = sqrt(.Machine$double.eps),
                              check.attributes = TRUE, countEQ = FALSE) {
  chk_s3_class(x, "data.frame")
  x_name <- chk_deparse(x_name)
  chk_scalar(exists)
  chk_logical(exists)
  
  sub <- sanitize_path(sub)
  main <- sanitize_path(main, rm_leading = FALSE)
  
  file <- file_path("data", sub, x_name)

  existing <- sbf_load_data(x_name, sub = sub, main = main, exists = NA)
  if(is.null(existing)) {
    if(vld_true(exists)) return(setNames(FALSE, file))
    return (setNames(TRUE, file))
  }
  if(vld_false(exists)) return(setNames(FALSE, file))
  equal <- all.equal(existing, x, tolerance = tolerance, 
                     check.attributes = check.attributes, countEQ = countEQ)
  setNames(equal, file)
}
# 
# sbf_is_equal_datas <- function(
#   x_name = ".*", sub = sbf_get_sub(), main = sbf_get_main(),
#   archive = 1L, recursive = FALSE, include_root = TRUE,
#   exists = TRUE, tolerance = sqrt(.Machine$double.eps),
#   check.attributes = TRUE, countEQ = FALSE) {
# 
#   main_files <- sbf_list_datas(x_name = x_name, sub = sub, main = main,
#                                full_path = FALSE, recursive = recursive, include_root = include_root)
# 
#   archive <- sbf_get_archive(main, archive = archive)
# 
#   archive_files <- sbf_list_datas(x_name = x_name, sub = sub, main = archive,
#                                   recursive = recursive, include_root = include_root)
# 
#   shared_files <-
# 
# 
# 
# 
# }

# true if in both and all.equal
# false if in main and not all.equal or missing archive
# na if not in main but in archive
# return as named logical vector!
# exists = TRUE then only those that in archive
# exists = FALSE then only those that not in archive.... will all be false but use to find extras
# exists = NA then doesn't care
# 
# also the archive argument to all functions (except sbf_get_archive()) should also accept string so user can specify.
