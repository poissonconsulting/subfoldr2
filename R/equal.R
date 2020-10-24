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
  if(is.null(existing)) 
    return(setNames(!exists, file))
  equal <- all.equal(existing, x, tolerance = tolerance, 
                     check.attributes = check.attributes, countEQ = countEQ)
  setNames(equal, file)
}


# all_equal_data <- function(name, main, archive) {
#   main <- file_path(main, name, ".rds")
#   main <- 
#     
# }
# 
# sbf_is_equal_datas <- function(
#   x_name = ".*", sub = sbf_get_sub(), main = sbf_get_main(),
#   archive = 1L, recursive = FALSE, include_root = TRUE,
#   exists = TRUE, tolerance = sqrt(.Machine$double.eps),
#   check.attributes = TRUE, countEQ = FALSE) {
# 
#   archive <- sbf_get_archive(main, archive = archive)
# 
#   main_files <- sbf_list_datas(x_name = x_name, sub = sub, main = main,
#                                recursive = recursive, include_root = include_root)
# 
#   archive_files <- sbf_list_datas(x_name = x_name, sub = sub, main = archive,
#                                   recursive = recursive, include_root = include_root)
# 
#   shared_file_names <- intersect(names(main_files), names(archive_files))
#   all_file_names <- union(names(main_files), names(archive_files))
#   if(!length(all_file_names)) return(logical(0))
#   
#   equal <- rep(NA, length(all_files_names))
#   names(equal) <- all_file_names
#   
#   all_equal <- vapply(shared_file_names, all_equal_data_impl, FUN.VALUE = TRUE, 
#                       main = main, archive  = archive)
#   
#   if(vld_true(exists)) equal[!names(equal) %in% shared_file_names] <- FALSE
#   if(vld_false(exists)) equal[!names(equal) %in% shared_file_names] <- TRUE
#   
#   equal <- equal[order(names(equal))]
#   equal
# }

# true if in both and all.equal
# false if in main and not all.equal or missing archive
# na if not in main but in archive
# exists = TRUE then only those that in archive
# exists = FALSE then only those that not in archive.... will all be false but use to find extras
# exists = NA then doesn't care
# 
# also the archive argument to all functions (except sbf_get_archive()) should also accept string so user can specify.
