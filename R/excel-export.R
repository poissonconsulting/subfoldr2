save_xlsx <- function(x, class, main, sub, x_name) {
  file <- file_name(main, class, sub, x_name, "xlsx")
  openxlsx::write.xlsx(x, file, overwrite = TRUE)
  invisible(file)
}



#' Convert SQLite Database to Excel Workbook
#' 
#' @param x The data frame to save.
#' @inheritParams sbf_save_object
#' @return An invisible string of the path to the saved data.frame
#'
#' @export
sbf_save_xlsx <- function(x, x_name = substitute(x), sub = sbf_get_sub(),
                          main = sbf_get_main()) {
  chk_s3_class(x, "data.frame")
  x_name <- chk_deparse(x_name)
  chk_string(x_name)
  chk_gt(nchar(x_name))
  chk_s3_class(sub, "character")
  chk_range(length(sub), c(0L, 1L))
  chk_string(main)
  
  sub <- sanitize_path(sub)
  main <- sanitize_path(main, rm_leading = FALSE)  
  
  save_rds(x, "xlsx", sub = sub, main = main, x_name = x_name)
  save_xlsx(x, "xlsx", sub = sub, main = main, x_name = x_name)
}


# sbf_load_datas_from_db(db_name = "horse-exploit",
#                        main = "inst",
#                        sub = "")

library(sf)
library(poisspatial)

class(Capture)

deacti

Capture


### to deactivate use tibble::as_tibble() instead of ps_deactivate_sfc()

cap <- tibble::as_tibble(Capture)

class(cap)

class(cap$CaptureID)
class(cap$Capture)


# pass dataframe
# iterates through column names
# checks the class of each column type 
# returns vector indicating if normal, point, polygon, etc 

### this function gets the type of each column type
### if it says drop we will drop that column 
### it it says point we will convert it from sf its appropriate columns (X,Y,Z)
check_column_type <- function(table) {
  
  col_names <- colnames(table)
  
  col_type <- lapply(col_names, function(i) {
    column_class <- class(table[[i]])
    
    if (inherits(table[[i]], "sfc")) {
      if (any(grepl("POINT", column_class))) {
        column_class <- "point"
      } else {
        column_class <- "drop"
      }
    }
    column_class
  })
  
  names(col_type) <- col_names
  col_type
}

check_column_type(Capture)


### write function to drop columns with type of drop 

is.sfc(Capture$Capture)

ps_sfc_to_coords(Capture, "Capture")
### if point is the column type then convert 

convert_point_columns <- function(table){
  
  
  
}


z <- check_column_type(Capture)

for (i in z) {
  print(i)
}






