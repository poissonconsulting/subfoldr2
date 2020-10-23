# sbf_all_equal_datas <- function(
#   x_name = ".*", sub = sbf_get_sub(), main = sbf_get_main(), 
#   archive = 1L, recursive = FALSE, include_root = TRUE) {
#   
#   datas <- sbf_list_datas(
#     x_name = x_name, sub = sub, main = main, 
#     recursive = recursive, include_root = include_root)
#   
#   
#   
#   data <- load_rdss_recursive(x_name, "data", sub = sub, main = main,
#                               include_root = include_root)
#   data
# }

# true if in both and all.equal
# false if in main and not all.equal or missing archive
# na if not in main but in archive
# return as named logical vector!
# exists = TRUE then only those that in archive
# exists = FALSE then only those that not in archive.... will all be false but use to find extras
# exists = NA then doesn't care
# 