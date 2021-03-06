test_that("object",{
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  teardown(sbf_reset())

  x <- 1
  expect_warning(sbf_load_objects(), "no objects to load")
  
  expect_error(sbf_save_object(x_name = "x"), "argument \"x\" is missing, with no default")
  expect_error(sbf_save_object(), "^`nchar[(]x_name[)]` must be greater than 0, not 0[.]$", class = "chk_error")
  expect_identical(sbf_save_object(x), file.path(sbf_get_main(), "objects/x.rds"))
  expect_identical(sbf_load_object("x"), x)
  expect_identical(sbf_load_object("x", exists = NA), x)
  chk::expect_chk_error(sbf_load_object("x", exists = FALSE))
  chk::expect_chk_error(sbf_load_object("x2"))
  expect_null(sbf_load_object("x2", exists = FALSE))
  expect_null(sbf_load_object("x2", exists = NA))
  
  y <- 2
  expect_identical(sbf_save_objects(env = as.environment(list(x = x, y = y))), 
                   c(file.path(sbf_get_main(), "objects/x.rds"),
                     file.path(sbf_get_main(), "objects/y.rds")))
  x <- 0
  y <- 0
  expect_identical(sbf_load_objects(), c("x", "y"))
  expect_identical(x, 1)
  expect_identical(y, 2)
 
  expect_true(sbf_object_exists("x")) 
  expect_false(sbf_object_exists("x2")) 

  expect_identical(sbf_reset_sub(), character(0))
  expect_identical(sbf_load_object("x"), x)
  
  expect_identical(list.files(file.path(sbf_get_main(), "objects")),
                   sort(c("x.rds", "y.rds")))
  
  data <- sbf_load_objects_recursive(".rds", sub = character(0))
  
  expect_is(data, "tbl_df")
  expect_identical(colnames(data), c("objects", "name", "sub", "file"))
  expect_identical(nrow(data), 0L)
  expect_is(data$objects, "list")
  
  data <- sbf_load_objects_recursive(include_root = FALSE, 
                                     sub = character(0))
  expect_is(data, "tbl_df")
  expect_identical(colnames(data), c("objects", "name", "sub", "file"))
  expect_identical(nrow(data), 0L)
  
  data <- sbf_load_objects_recursive(sub = character(0))
  expect_is(data, "tbl_df")
  expect_identical(colnames(data), c("objects", "name", "sub", "file"))
  expect_identical(unlist(data$objects), c(x, y))
  expect_identical(data$name, c("x", "y"))
  expect_identical(data$sub, c("", ""))
  expect_identical(data$file, 
                   c(file.path(sbf_get_main(), "objects/x.rds"),
                     file.path(sbf_get_main(), "objects/y.rds")))
  
  expect_identical(sbf_save_object(x, sub = "t2/t3"), 
                   file.path(sbf_get_main(), "objects/t2/t3/x.rds"))
  
  data <- sbf_load_objects_recursive(sub = character(0))
  expect_is(data, "tbl_df")
  expect_identical(colnames(data), c("objects", "name", "sub", "sub1", "sub2", "file"))
  expect_is(data$objects, "list")
  expect_identical(unlist(data$objects), c(x, x, y))
  expect_identical(data$name, c("x", "x", "y"))
  expect_identical(data$sub1, c("t2", NA, NA))
  expect_identical(data$sub2, c("t3", NA, NA))
  expect_identical(data$sub, c("t2/t3", "", ""))
  expect_identical(data$file, 
                   c(file.path(sbf_get_main(), "objects/t2/t3/x.rds"),
                     file.path(sbf_get_main(), "objects/x.rds"),
                     file.path(sbf_get_main(), "objects/y.rds")))
  
  data <- sbf_load_objects_recursive(sub = character(0), include_root = FALSE)
  expect_is(data, "tbl_df")
  expect_identical(colnames(data), c("objects", "name", "sub", "sub1", "sub2", "file"))
  expect_identical(unlist(data$objects), x)
  expect_identical(data$name, "x")
  expect_identical(data$sub, "t2/t3")
  expect_identical(data$sub1, "t2")
  expect_identical(data$sub2, "t3")
  expect_identical(data$file, 
                   file.path(sbf_get_main(), "objects/t2/t3/x.rds"))
  
  data2 <- sbf_load_objects_recursive("^x", sub = character(0), include_root = FALSE)
  expect_identical(data2, data)
  
  data <- sbf_load_objects_recursive(sub = "t2")
  expect_is(data, "tbl_df")
  expect_identical(colnames(data), c("objects", "name", "sub", "file"))
  expect_identical(unlist(data$objects), x)
  expect_identical(data$name, "x")
  expect_identical(data$sub, "t3")
  expect_identical(data$file, 
                   file.path(sbf_get_main(), "objects/t2/t3/x.rds"))
  
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))
  chk::expect_chk_error(sbf_load_object("x"))
  expect_identical(sbf_set_sub("sub"), "sub")
  expect_identical(sbf_save_object(x), file.path(sbf_get_main(), "objects/sub/x.rds"))
  expect_identical(sbf_load_object("x"), x)
  expect_identical(sbf_load_object("x", exists = NA), x)
  chk::expect_chk_error(sbf_load_object("x", exists = FALSE))
  chk::expect_chk_error(sbf_load_object("x2"))
  expect_null(sbf_load_object("x2", exists = NA))
  expect_null(sbf_load_object("x2", exists = FALSE))
})

test_that("object",{
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  teardown(sbf_reset())

  x <- 1
  sbf_set_sub("one")
  sbf_save_object(x)

  data <- sbf_load_objects_recursive(sub = character(0))
  expect_is(data, "tbl_df")
  expect_identical(colnames(data), c("objects", "name", "sub", "file"))
  expect_identical(data$sub, c("one"))

  sbf_set_sub("one", "two")
  sbf_save_object(x)
  
  data <- sbf_load_objects_recursive(sub = character(0))
  expect_is(data, "tbl_df")
  expect_identical(colnames(data), c("objects", "name", "sub", "sub1", "sub2", "file"))
  expect_identical(data$sub, c("one/two", "one"))
  
  expect_identical(sbf_subs_object_recursive("x", sub = character(0)), c("one/two", "one"))
  expect_identical(sbf_subs_object_recursive("x2", sub = character(0)), character(0))
})

test_that("data",{
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  teardown(sbf_reset())

  y <- 1
  expect_warning(sbf_load_datas(), "no data to load")
  
  expect_error(sbf_save_data(), "argument \"x\" is missing, with no default")
  expect_error(sbf_save_data(y), "^`x` must inherit from S3 class 'data.frame'[.]$", class = "chk_error")
  x <- data.frame(x = 1)
  expect_identical(sbf_save_data(x), file.path(sbf_get_main(), "data/x.rds"))
  expect_identical(sbf_load_data("x"), x)
  chk::expect_chk_error(sbf_load_data("x2"))
  
  expect_true(sbf_data_exists("x")) 
  expect_false(sbf_data_exists("x2")) 
  
  y <- data.frame(z = 3)
  expect_identical(sbf_save_datas(env = as.environment(list(x = x, y = y))), 
                   c(file.path(sbf_get_main(), "data/x.rds"),
                     file.path(sbf_get_main(), "data/y.rds")))
  expect_identical(list.files(file.path(sbf_get_main(), "data")),
                   sort(c("x.rds", "y.rds")))
  x <- 0
  y <- 0
  expect_identical(sbf_load_datas(), c("x", "y"))
  expect_identical(x, data.frame(x = 1))
  expect_identical(y, data.frame(z = 3))
  
  data <- sbf_load_datas_recursive()
  expect_is(data, "tbl_df")
  expect_identical(colnames(data), c("data", "name", "sub", "file"))
  expect_identical(data$data[[1]], data.frame(x = 1))
  expect_identical(data$name, c("x", "y"))
  expect_identical(data$file, 
                   c(file.path(sbf_get_main(), "data/x.rds"),
                     file.path(sbf_get_main(), "data/y.rds")))
  
  expect_identical(sbf_reset_sub(), character(0))
  expect_identical(sbf_load_data("x"), x)
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))
  chk::expect_chk_error(sbf_load_data("x"))
  expect_identical(sbf_set_sub("sub"), "sub")
  expect_identical(sbf_save_data(x),file.path(sbf_get_main(), "data/sub/x.rds"))
  expect_identical(sbf_load_data("x"), x)
  expect_identical(sbf_load_data("x", exists = NA), x)
  chk::expect_chk_error(sbf_load_data("x", exists = FALSE))
  chk::expect_chk_error(sbf_load_data("x2"))
  expect_null(sbf_load_data("x2", exists = NA))
  expect_null(sbf_load_data("x2", exists = FALSE))
})

test_that("number",{
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  teardown(sbf_reset())

  y <- numeric(0)
  expect_warning(sbf_load_numbers(), "no numbers to load")
  expect_error(sbf_save_number(), "argument \"x\" is missing, with no default")
  expect_error(sbf_save_number(y), "^`x` must be a number [(]non-missing numeric scalar[)][.]$", class = "chk_error")
  x <- 1L
  expect_identical(sbf_save_number(x), file.path(sbf_get_main(), "numbers/x.rds"))
  
  expect_true(sbf_number_exists("x")) 
  expect_false(sbf_number_exists("x2")) 

  expect_identical(sbf_load_number("x"), 1)
  expect_identical(list.files(file.path(sbf_get_main(), "numbers")),
                   sort(c("x.csv", "x.rds")))
  csv <- read.csv(file.path(sbf_get_main(), "numbers", "x.csv"))
  expect_equal(csv, data.frame(x = 1))
  
  y <- 3
  expect_identical(sbf_save_numbers(env = as.environment(list(x = x, y = y))), 
                   c(file.path(sbf_get_main(), "numbers/x.rds"),
                     file.path(sbf_get_main(), "numbers/y.rds")))
  expect_identical(list.files(file.path(sbf_get_main(), "numbers")),
                   sort(c("x.csv", "x.rds", "y.csv", "y.rds")))
  x <- 0
  y <- 0
  expect_identical(sbf_load_numbers(), c("x", "y"))
  expect_identical(x, 1)
  expect_identical(y, 3)
  
  data <- sbf_load_numbers_recursive()
  expect_is(data, "tbl_df")
  expect_identical(colnames(data), c("numbers", "name", "sub", "file"))
  expect_identical(data$numbers, c(1, 3))
  expect_identical(data$name, c("x", "y"))
  expect_identical(data$file, 
                   c(file.path(sbf_get_main(), "numbers/x.rds"),
                     file.path(sbf_get_main(), "numbers/y.rds")))
  
  chk::expect_chk_error(sbf_load_number("x2"))
  expect_identical(sbf_reset_sub(), character(0))
  expect_identical(sbf_load_number("x"), 1)
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))
  chk::expect_chk_error(sbf_load_number("x"))
  expect_identical(sbf_set_sub("sub"), "sub")
  expect_identical(sbf_save_number(x), file.path(sbf_get_main(), "numbers/sub/x.rds"))
  expect_identical(sbf_load_number("x"), 1)
  expect_identical(sbf_load_number("x", exists = NA), 1)
  chk::expect_chk_error(sbf_load_number("x2", exists = TRUE))
  expect_null(sbf_load_number("x2", exists = NA))
  expect_null(sbf_load_number("x2", exists = FALSE))
})

test_that("string",{
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  teardown(sbf_reset())

  y <- "two words"
  expect_warning(sbf_load_strings(), "no strings to load")
  expect_error(sbf_save_string(), "argument \"x\" is missing, with no default")
  expect_identical(sbf_save_string(y), file.path(sbf_get_main(), "strings/y.rds"))
  
  expect_true(sbf_string_exists("y")) 
  expect_false(sbf_string_exists("x2")) 

  expect_identical(sbf_load_string("y"), "two words")
  expect_identical(list.files(file.path(sbf_get_main(), "strings")),
                   sort(c("y.rda", "y.rds", "y.txt")))
  txt <- readLines(file.path(sbf_get_main(), "strings", "y.txt"), warn = FALSE)
  expect_equal(txt, "two words")
  
  x <- "one"
  expect_identical(sbf_save_strings(env = as.environment(list(x = x, y = y))), 
                   c(file.path(sbf_get_main(), "strings/x.rds"),
                     file.path(sbf_get_main(), "strings/y.rds")))
  expect_identical(list.files(file.path(sbf_get_main(), "strings")),
                   sort(c("x.rda", "x.rds", "x.txt", "y.rda", "y.rds", "y.txt")))
  x <- 0
  y <- 0
  expect_identical(sbf_load_strings(), c("x", "y"))
  expect_identical(x, "one")
  expect_identical(y, "two words")
  
  data <- sbf_load_strings_recursive()
  expect_is(data, "tbl_df")
  expect_identical(colnames(data), c("strings", "name", "sub", "file"))
  expect_identical(data$strings, c("one", "two words"))
  expect_identical(data$name, c("x", "y"))
  expect_identical(data$file, 
                   c(file.path(sbf_get_main(), "strings/x.rds"),
                     file.path(sbf_get_main(), "strings/y.rds")))
  
  chk::expect_chk_error(sbf_load_string("x2"))
  expect_identical(sbf_reset_sub(), character(0))
  expect_identical(sbf_load_string("y"), "two words")
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))
  chk::expect_chk_error(sbf_load_string("x"))
  expect_identical(sbf_set_sub("sub"), "sub")
  expect_identical(sbf_save_string(y), file.path(sbf_get_main(), "strings/sub/y.rds"))
  expect_identical(sbf_load_string("y"), "two words")
  expect_identical(sbf_load_string("y", exists = NA), "two words")
  chk::expect_chk_error(sbf_load_string("y", exists = FALSE))
  chk::expect_chk_error(sbf_load_string("x2"))
  expect_null(sbf_load_string("x2", exists = NA))
  expect_null(sbf_load_string("x2", exists = FALSE))
  
  data <- sbf_load_strings_recursive()
  expect_identical(colnames(data), c("strings", "name", "sub", "file"))
  expect_identical(data$strings, "two words")
  expect_identical(data$name, "y")
  expect_identical(sbf_load_strings_recursive(tag = "y"), data[-1,])
})

test_that("datas_to_db",{
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  teardown(sbf_reset())

  x <- data.frame(x = 1)
  y <- data.frame(z = 3)
  expect_error(sbf_save_datas_to_db(env = as.environment(list(x = x, y = y))),
               "^`file` must specify an existing file [(]'.*dbs/database.sqlite' can't be found[)].$", class = "chk_error")
  
  conn <- sbf_open_db(exists = NA)
  teardown(suppressWarnings(DBI::dbDisconnect(conn)))
  expect_identical(list.files(file.path(sbf_get_main(), "dbs")),
                   "database.sqlite")
  
  expect_error(sbf_save_datas_to_db(env = as.environment(list(x = x, y = y))),
               "The following data frames in 'x' are unrecognised: 'y' and 'x'; but exists = TRUE.")
  
  DBI::dbExecute(conn, "CREATE TABLE x (
                  x INTEGER PRIMARY KEY NOT NULL)")
  
  sbf_execute_db("CREATE TABLE y (
                  z INTEGER PRIMARY KEY NOT NULL)")
  
  expect_identical(sbf_save_datas_to_db(env = as.environment(list(x = x, y = y))),
                   c("y", "x"))
  
  expect_error(sbf_save_datas_to_db(env = as.environment(list(x = x, y = y))),
               "UNIQUE constraint failed: y.z")
  
  expect_true(sbf_close_db(conn))
  x <- 0
  y <- 0
  
  expect_error(sbf_load_datas_from_db("z"), 
               "^`file` must specify an existing file [(]'.*dbs/z.sqlite' can't be found[)].$", class = "chk_error")
  expect_identical(sbf_load_datas_from_db(), c("x", "y"))
  expect_identical(x, tibble::tibble(x = 1L))
  expect_identical(y, tibble::tibble(z = 3L))
  expect_identical(sbf_load_datas_from_db(rename = function(x) paste0("db", x)), c("dbx", "dby"))
  expect_identical(dbx, tibble::tibble(x = 1L))
  expect_identical(dby, tibble::tibble(z = 3L))
  
  expect_error(sbf_save_data_to_db(x, db_name = "database"),
               "UNIQUE constraint failed: x.x")
  x$x <- 4
  file <- sbf_save_data_to_db(x, db_name = "database")
  expect_match(file, ".+/dbs/database.sqlite")
  expect_identical(sbf_load_data_from_db("x"), tibble::tibble(x = c(1L, 4L)))
  
  expect_identical(sbf_load_db_metatable(),
                   tibble::tibble(Table = c("X", "Y"),
                                  Column = c("X", "Z"),
                                  Meta = c(NA_character_, NA_character_),
                                  Description = c(NA_character_, NA_character_)))
  
  x <- sbf_load_db_metatable()
  x$Description <- c("xy", "the End.")
  expect_identical(sbf_save_db_metatable_descriptions(x), x[c("Table", "Column", "Description")])
  expect_identical(x, sbf_load_db_metatable())
  expect_identical(sbf_save_db_metatable_descriptions(x), x[0,c("Table", "Column", "Description")])
  expect_identical(sbf_save_db_metatable_descriptions(x, overwrite = TRUE), x[c("Table", "Column", "Description")])
  x$Description <- c("xzy", NA)
  expect_identical(sbf_save_db_metatable_descriptions(x), x[0, c("Table", "Column", "Description")])
  expect_identical(sbf_save_db_metatable_descriptions(x, overwrite = TRUE), x[c("Table", "Column", "Description")])
  expect_identical(x, sbf_load_db_metatable())
  x$Description <- c("notxzy", "yes")
  expect_identical(sbf_save_db_metatable_descriptions(x)$Description, "yes")
  expect_identical(sbf_save_db_metatable_descriptions(x), x[0, c("Table", "Column", "Description")])
  expect_identical(sbf_save_db_metatable_descriptions(x, overwrite = TRUE), x[c("Table", "Column", "Description")])
  
  x$Table[1] <- "NotTable"
  expect_error(sbf_save_db_metatable_descriptions(x))
  expect_identical(sbf_save_db_metatable_descriptions(x, strict = FALSE), x[0, c("Table", "Column", "Description")])
  expect_identical(sbf_save_db_metatable_descriptions(x, strict = FALSE, overwrite = TRUE)$Description, "yes")
  
  x$Table[1] <- "X"
  x$Description <- NA_character_
  expect_identical(sbf_save_db_metatable_descriptions(x, overwrite = TRUE), x[c("Table", "Column", "Description")])
  
  expect_identical(sbf_load_db_metatable(), x)
  
  expect_identical(sbf_save_db_metatable_descriptions(x), x[c("Table", "Column", "Description")])
})

test_that("table",{
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  teardown(sbf_reset())

  y <- 1
  expect_warning(sbf_load_tables(), "no tables to load")
  expect_error(sbf_save_table(), "argument \"x\" is missing, with no default")
  expect_error(sbf_save_table(y), "^`x` must inherit from S3 class 'data.frame'[.]$", class = "chk_error")
  x <- data.frame(x = 1)
  expect_error(sbf_save_table(data.frame(zz = I(list(t = 3))), x_name = "y"),
               "^The following columns in `x` are not logical, numeric, character, factor, Date or POSIXct: 'zz'[.]$", class = "chk_error")
  
  expect_identical(sbf_save_table(x), file.path(sbf_get_main(), "tables/x.rds"))
  
  expect_true(sbf_table_exists("x")) 
  expect_false(sbf_table_exists("x2")) 

  expect_identical(sbf_load_table("x"), x)
  expect_identical(list.files(file.path(sbf_get_main(), "tables")),
                   sort(c("x.rda", "x.csv", "x.rds")))
  csv <- read.csv(file.path(sbf_get_main(), "tables", "x.csv"))
  expect_equal(csv, x)
  meta <- readRDS(paste0(file.path(sbf_get_main(), "tables", "x.rda")))
  expect_identical(meta, list(caption = "", report = TRUE, tag = ""))
  
  y <- data.frame(z = 2L)
  expect_identical(sbf_save_table(y, report = FALSE, caption = "A caption"), 
                   file.path(sbf_get_main(), "tables/y.rds"))
  x <- 0
  y <- 0
  expect_identical(sbf_load_tables(), c("x", "y"))
  expect_identical(x, data.frame(x = 1))
  expect_identical(y, data.frame(z = 2L))
  
  data <- sbf_load_tables_recursive()
  expect_is(data, "tbl_df")
  expect_identical(colnames(data), c("tables", "name", "sub", "file"))
  expect_identical(data$tables[[1]], data.frame(x = 1))
  expect_identical(data$name, c("x", "y"))
  expect_identical(data$file, 
                   c(file.path(sbf_get_main(), "tables/x.rds"),
                     file.path(sbf_get_main(), "tables/y.rds")))
  
  data2 <- sbf_load_tables_recursive(meta = TRUE)
  expect_identical(colnames(data2), c("tables", "name", "sub", "file", "caption", "report", "tag"))
  expect_identical(data2[c("tables", "name", "sub", "file")], data)
  expect_identical(data2$caption, c("", "A caption"))
  expect_identical(data2$report, c(TRUE, FALSE))
  
  expect_identical(data$tables[[1]], data.frame(x = 1))
  expect_identical(data$name, c("x", "y"))
  expect_identical(data$file,
                   c(file.path(sbf_get_main(), "tables/x.rds"),
                     file.path(sbf_get_main(), "tables/y.rds")))
  
  chk::expect_chk_error(sbf_load_table("x2"))
  expect_identical(sbf_reset_sub(), character(0))
  expect_identical(sbf_load_table("x"), x)
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))
  chk::expect_chk_error(sbf_load_table("x"))
  expect_identical(sbf_set_sub("sub"), "sub")
  expect_identical(sbf_save_table(x), file.path(sbf_get_main(), "tables/sub/x.rds"))
  expect_identical(sbf_load_table("x"), x)
  expect_identical(sbf_load_table("x", exists = NA), x)
  chk::expect_chk_error(sbf_load_table("x", exists = FALSE))
  chk::expect_chk_error(sbf_load_table("x2"))
  expect_null(sbf_load_table("x2", exists = NA))
  chk::expect_chk_error(sbf_load_table("x2", exists = TRUE))
})

test_that("block",{
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  teardown(sbf_reset())

  sbf_set_main(tempdir())
  y <- "two words"
  expect_warning(sbf_load_blocks(), "no blocks to load")
  expect_error(sbf_save_block(), "argument \"x\" is missing, with no default")
  expect_identical(sbf_save_block(y), file.path(sbf_get_main(), "blocks/y.rds"))
  
  expect_true(sbf_block_exists("y")) 
  expect_false(sbf_block_exists("x2")) 

  expect_identical(sbf_load_block("y"), "two words")
  expect_identical(list.files(file.path(sbf_get_main(), "blocks")),
                   sort(c("y.rda", "y.rds", "y.txt")))
  txt <- readLines(file.path(sbf_get_main(), "blocks", "y.txt"), warn = FALSE)
  expect_equal(txt, "two words")
  
  one <- "some code"
  expect_identical(sbf_save_block(one, tag = "R"), file.path(sbf_get_main(), "blocks/one.rds"))
  one <- 0
  y <- 0
  expect_identical(sbf_load_blocks(), c("one", "y"))
  expect_identical(one, "some code")
  expect_identical(y, "two words")
  
  data <- sbf_load_blocks_recursive()
  expect_is(data, "tbl_df")
  expect_identical(colnames(data), c("blocks", "name", "sub", "file"))
  expect_identical(data$blocks, c("some code", "two words"))
  expect_identical(data$name, c("one", "y"))
  expect_identical(data$file, 
                   c(file.path(sbf_get_main(), "blocks/one.rds"),
                     file.path(sbf_get_main(), "blocks/y.rds")))
  
  data2 <- sbf_load_blocks_recursive(meta = TRUE)
  expect_identical(colnames(data2), c("blocks", "name", "sub", "file", "caption", "report", "tag"))
  expect_identical(data2[c("blocks", "name", "sub", "file")], data)
  expect_identical(data2$tag, c("R", ""))
  
  data3 <- sbf_load_blocks_recursive(meta = TRUE, tag = "R")
  expect_identical(data3, data2[1,])
  
  chk::expect_chk_error(sbf_load_block("x2"))
  expect_identical(sbf_reset_sub(), character(0))
  expect_identical(sbf_load_block("y"), "two words")
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))
  chk::expect_chk_error(sbf_load_block("x"))
  expect_identical(sbf_set_sub("sub"), "sub")
  expect_identical(sbf_save_block(y), file.path(sbf_get_main(), "blocks/sub/y.rds"))
  expect_identical(sbf_load_block("y"), "two words")
  expect_identical(sbf_load_block("y", exists = NA), "two words")
  chk::expect_chk_error(sbf_load_block("y", exists = FALSE))
  chk::expect_chk_error(sbf_load_block("x2"))
  expect_null(sbf_load_block("x2", exists = NA))
  expect_null(sbf_load_block("x2", exists = FALSE))
})

test_that("plot",{
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  teardown(sbf_reset())

  sbf_close_windows()
  teardown(sbf_close_windows())
  
  y <- 1
  expect_error(sbf_save_plot(y), "^`x` must inherit from S3 class 'ggplot'[.]$",
               class = "chk_error")
  
  x <- ggplot2::ggplot()
  expect_identical(sbf_save_plot(x), file.path(sbf_get_main(), "plots/x.rds"))
  expect_equal(sbf_load_plot("x"), x)
  expect_identical(sbf_load_plot_data("x"), data.frame())
  
  expect_true(sbf_plot_exists("x")) 
  expect_false(sbf_plot_exists("x2")) 

  y <- ggplot2::ggplot(data = data.frame(x = 1, y = 2), ggplot2::aes(x = x, y = y))
  expect_identical(sbf_save_plot(y), file.path(sbf_get_main(), "plots/y.rds"))
  
  expect_equal(sbf_load_plot("y"), y)
  expect_identical(sbf_load_plot_data("y"), data.frame(x = 1, y = 2))
  
  expect_identical(list.files(file.path(sbf_get_main(), "plots")),
                   sort(c("x.rda", "y.rda", "x.png", "x.rds",
                          "y.csv", "y.png", "y.rds")))
  
  expect_identical(sbf_load_plots_data(), c("x", "y"))
  expect_identical(x, data.frame())
  expect_identical(y, data.frame(x = 1, y = 2))
  
  z <- ggplot2::ggplot(data = data.frame(x = 2, y = 3), ggplot2::aes(x = x, y = y))
  expect_identical(sbf_save_plot(z), file.path(sbf_get_main(), "plots/z.rds"))
  expect_equal(sbf_load_plot("z"), z)
  
  t <- ggplot2::ggplot(data = data.frame(x = c(2,3), y = c(3,2)), ggplot2::aes(x = x, y = y))
  expect_identical(sbf_save_plot(csv = 1L, dpi = 320L, caption = "one c",
                                 report = FALSE, width = 2.55, height = 3L, units = "cm"), file.path(sbf_get_main(), "plots/plot.rds"))
  expect_equal(sbf_load_plot("plot"), t)
  
  expect_identical(list.files(file.path(sbf_get_main(), "plots")),
                   sort(c("plot.rda", "x.rda", "y.rda", "z.rda",
                          "plot.png", "plot.rds", "x.png", "x.rds",
                          "y.csv", "y.png", "y.rds", "z.csv",
                          "z.png", "z.rds")))
  
  data <- sbf_load_plots_recursive()
  expect_is(data, "tbl_df")
  expect_identical(colnames(data), c("plots", "name", "sub", "file"))
  expect_is(data$plots[[2]], "ggplot")
  expect_identical(data$name, c("plot", "x", "y", "z"))
  expect_identical(data$file, 
                   c(file.path(sbf_get_main(), "plots/plot.rds"),
                     file.path(sbf_get_main(), "plots/x.rds"),
                     file.path(sbf_get_main(), "plots/y.rds"),
                     file.path(sbf_get_main(), "plots/z.rds")))
  
  data2 <- sbf_load_plots_recursive(meta = TRUE)
  expect_identical(colnames(data2), c("plots", "name", "sub", "file", "caption", "report", 
                                      "tag",
                                      "width", "height", "dpi"))
  expect_identical(data2$caption[1:2], c("one c", ""))
  expect_identical(data2$report[1:2], c(FALSE, TRUE))
  expect_equal(data2$width[1:2], c(1.003937, 6.000000))
  expect_equal(data2$height[1:2], c(1.181102, 6.000000), tolerance = 1e-06)
  expect_identical(data2$dpi[1:2], c(320, 300))
  
  data <- sbf_load_plots_data_recursive()
  expect_is(data, "tbl_df")
  expect_identical(colnames(data), c("plots_data", "name", "sub", "file"))
  expect_identical(data$plots_data[[2]], data.frame())
  expect_identical(data$name, c("plot", "x", "y", "z"))
  expect_identical(data$file, 
                   c(file.path(sbf_get_main(), "plots/plot.rds"),
                     file.path(sbf_get_main(), "plots/x.rds"),
                     file.path(sbf_get_main(), "plots/y.rds"),
                     file.path(sbf_get_main(), "plots/z.rds")))
})

test_that("window",{
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  teardown(sbf_reset())
  
  sbf_close_windows()
  teardown(sbf_close_windows())
  expect_error(sbf_save_window(), "^No such device[.]$")
  
  skip('run locally as uses screen devices') 
  expect_identical(sbf_reset_main(rm = TRUE, ask = FALSE), "output")
  sbf_open_window()
  plot(x~y, data = data.frame(x = c(5,4), y = c(6,7)))
  expect_identical(sbf_save_window(height = 7L, dpi  = 300L), 
                   file.path(sbf_get_main(), "windows/window.png"))
  sbf_close_window()
  expect_identical(list.files(file.path(sbf_get_main(), "windows")),
                   sort(c("window.rda", "window.png")))
  
  meta <- readRDS(paste0(file.path(sbf_get_main(), "windows", "window.rda")))
  expect_identical(meta, list(caption = "", report = TRUE,
                              width = 6, height = 7, dpi = 300))
  
  gp <- ggplot2::ggplot(data = data.frame(x = c(4,5), y = c(6,7)), ggplot2::aes(x = x, y = y))
  gp <- gp + ggplot2::geom_point()
  sbf_open_window(4,3)
  print(gp)
  expect_identical(sbf_save_window("t2", dpi = 72, caption = "nice one", report = FALSE), 
                   file.path(sbf_get_main(), "windows/t2.png"))
  
  expect_identical(list.files(file.path(sbf_get_main(), "windows")),
                   sort(c("t2.rda", "window.rda", "t2.png", "window.png")))
  
  meta <- readRDS(paste0(file.path(sbf_get_main(), "windows", "t2.rda")))
  expect_identical(meta, list(caption = "nice one", report = FALSE,
                              width = 4, height = 3, dpi = 72))
  
  data <- sbf_load_windows_recursive(sub = character(0))
  expect_is(data, "tbl_df")
  expect_identical(colnames(data), c("windows", "name", "file"))
  expect_identical(data$name, c("t2", "window"))
  expect_identical(data$windows[1], "output/windows/t2.png")
  expect_identical(data$windows, data$file)
  
  data2 <- sbf_load_windows_recursive(sub = character(0), meta = TRUE)
  
  expect_identical(colnames(data2), c("windows", "name", "file", "caption",
                                      "report", "width", "height", "dpi"))
  expect_identical(data2[c("windows", "name", "file")], data)
  expect_identical(data2$caption, c("nice one", ""))
  expect_identical(data2$report, c(FALSE, TRUE))
  expect_identical(data2$width, c(4, 6))
  expect_identical(data2$height, c(3, 7))
  expect_identical(data2$dpi, c(72, 300))
})

test_that("png",{
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  teardown(sbf_reset())
  
  x <- system.file("extdata", "example.png", package = "subfoldr2", mustWork = TRUE)
  
  sbf_save_png(x, caption = "map")
  
  expect_identical(list.files(file.path(sbf_get_main(), "windows")),
                   sort(c("example.rda", "example.png")))
  
  meta <- readRDS(paste0(file.path(sbf_get_main(), "windows", "example.rda")))
  expect_identical(meta, list(caption = "map", report = TRUE, tag = "",
                              width = 6, height = 5.992, dpi = 125))
  
  data <- sbf_load_windows_recursive(sub = character(0))
  expect_is(data, "tbl_df")
  expect_identical(colnames(data), c("windows", "name", "sub", "file"))
  expect_identical(data$name, c("example"))
})

test_that("save table glue",{
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  teardown(sbf_reset())

  data <- data.frame(x = 1)
  sbf_save_table(data, caption = "character")
  sbf_save_table(data, x_name = "data2", caption = glue::glue("glue"))
  
  expect_identical(sbf_load_tables_recursive(meta = TRUE)$caption,
                   c("character", "glue"))
})
