context("save-load")

test_that("object",{
  teardown(sbf_reset_sub(rm = TRUE, ask = FALSE))
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))
  
  tempdir <- tempdir()
  sbf_set_main(tempdir)
  x <- 1
  expect_warning(sbf_load_objects(), "no objects to load")
  
  expect_error(sbf_save_object(x_name = "x"), "argument \"x\" is missing, with no default")
  expect_error(sbf_save_object(), "x_name must have at least 1 character")
  expect_identical(sbf_save_object(x), sub("//", "/", file.path(tempdir, "objects/x.rds")))
  expect_identical(sbf_save_object(x, exists = TRUE), sub("//", "/", file.path(tempdir, "objects/x.rds")))
  expect_error(sbf_save_object(x, exists = FALSE), 
               paste0("file '", sub("//", "/", file.path(tempdir, "objects/x.rds")), "' already exists"))
  expect_error(sbf_save_object(x, x_name = "y", exists = TRUE), 
               paste0("file '", sub("//", "/", file.path(tempdir, "objects/y.rds")), "' doesn't exist"))
  expect_error(sbf_save_object(x, x_name = "y", exists = TRUE), 
               paste0("file '", sub("//", "/", file.path(tempdir, "objects/y.rds")), "' doesn't exist"))
  expect_error(sbf_save_object(x, x_name = "_x"), "x_name must match regular expression")
  expect_identical(sbf_load_object("x"), x)
  expect_error(sbf_load_object("x2"), "/objects/x2.rds' does not exist")
  
  y <- 2
  expect_identical(sbf_save_objects(env = as.environment(list(x = x, y = y))), 
                   c(sub("//", "/", file.path(tempdir, "objects/x.rds")),
                     sub("//", "/", file.path(tempdir, "objects/y.rds"))))
  x <- 0
  y <- 0
  expect_identical(sbf_load_objects(), c("x", "y"))
  expect_identical(x, 1)
  expect_identical(y, 2)
  
  expect_identical(sbf_reset_sub(), character(0))
  expect_identical(sbf_load_object("x"), x)
  
  expect_identical(list.files(file.path(sbf_get_main(), "objects")),
                   sort(c("x.rds", "y.rds")))
  
  expect_warning(data <- sbf_load_objects_recursive(".rds", sub = character(0)),
                 "no objects matching regular expression '.rds'")
  
  expect_is(data, "data.frame")
  expect_identical(colnames(data), c("objects", "name", "file"))
  expect_identical(nrow(data), 0L)
  
  expect_warning(sbf_load_objects_recursive(include_root = FALSE, 
                                            sub = character(0)),
                 "no objects matching regular expression '.*'")
  
  data <- sbf_load_objects_recursive(sub = character(0))
  expect_is(data, "data.frame")
  expect_identical(colnames(data), c("objects", "name", "file"))
  expect_identical(unlist(data$objects), c(x, y))
  expect_identical(data$name, c("x", "y"))
  expect_identical(data$file, 
                   c(sub("//", "/", file.path(tempdir, "objects/x.rds")),
                     sub("//", "/", file.path(tempdir, "objects/y.rds"))))
  
  expect_identical(sbf_save_object(x, sub = "t2/t3"), 
                   sub("//", "/", file.path(tempdir, "objects/t2/t3/x.rds")))
  
  data <- sbf_load_objects_recursive(sub = character(0))
  expect_is(data, "data.frame")
  expect_identical(colnames(data), c("objects", "name", "sub1", "sub2", "file"))
  expect_identical(unlist(data$objects), c(x, x, y))
  expect_identical(data$name, c("x", "x", "y"))
  expect_identical(data$sub1, c("t2", NA, NA))
  expect_identical(data$sub2, c("t3", NA, NA))
  expect_identical(data$file, 
                   c(sub("//", "/", file.path(tempdir, "objects/t2/t3/x.rds")),
                     sub("//", "/", file.path(tempdir, "objects/x.rds")),
                     sub("//", "/", file.path(tempdir, "objects/y.rds"))))
  
  data <- sbf_load_objects_recursive(sub = character(0), include_root = FALSE)
  expect_is(data, "data.frame")
  expect_identical(colnames(data), c("objects", "name", "sub1", "sub2", "file"))
  expect_identical(unlist(data$objects), x)
  expect_identical(data$name, "x")
  expect_identical(data$sub1, "t2")
  expect_identical(data$sub2, "t3")
  expect_identical(data$file, 
                   sub("//", "/", file.path(tempdir, "objects/t2/t3/x.rds")))
  
  data <- sbf_load_objects_recursive(sub = "t2")
  expect_is(data, "data.frame")
  expect_identical(colnames(data), c("objects", "name", "sub1", "file"))
  expect_identical(unlist(data$objects), x)
  expect_identical(data$name, "x")
  expect_identical(data$sub1, "t3")
  expect_identical(data$file, 
                   sub("//", "/", file.path(tempdir, "objects/t2/t3/x.rds")))
  
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))
  expect_error(sbf_load_object("x"), "/objects/x.rds' does not exist")
  expect_identical(sbf_set_sub("sub"), "sub")
  expect_identical(sbf_save_object(x), sub("//", "/", file.path(tempdir, "objects/sub/x.rds")))
  expect_identical(sbf_load_object("x"), x)
  expect_error(sbf_load_object("x2"), "/objects/sub/x2.rds' does not exist")
})

test_that("data",{
  teardown(sbf_reset_sub(rm = TRUE, ask = FALSE))
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))
  
  tempdir <- tempdir()
  sbf_set_main(tempdir)
  y <- 1
  expect_warning(sbf_load_datas(), "no data to load")
  
  expect_error(sbf_save_data(), "argument \"x\" is missing, with no default")
  expect_error(sbf_save_data(y), "x must inherit from class data.frame")
  x <- data.frame(x = 1)
  expect_identical(sbf_save_data(x), sub("//", "/", file.path(tempdir, "data/x.rds")))
  expect_identical(sbf_save_data(x, exists = TRUE), sub("//", "/", file.path(tempdir, "data/x.rds")))
  expect_error(sbf_save_data(x, exists = FALSE), 
               paste0("file '", sub("//", "/", file.path(tempdir, "data/x.rds")), "' already exists"))
  expect_error(sbf_save_data(x, x_name = "y", exists = TRUE), 
               paste0("file '", sub("//", "/", file.path(tempdir, "data/y.rds")), "' doesn't exist"))
  expect_error(sbf_save_data(x, x_name = "y", exists = TRUE), 
               paste0("file '", sub("//", "/", file.path(tempdir, "data/y.rds")), "' doesn't exist"))
  expect_error(sbf_save_data(x, x_name = "_x"), "x_name must match regular expression")
  expect_identical(sbf_load_data("x"), x)
  expect_error(sbf_load_data("x2"), "/data/x2.rds' does not exist")
  
  y <- data.frame(z = 3)
  expect_identical(sbf_save_datas(env = as.environment(list(x = x, y = y))), 
                   c(sub("//", "/", file.path(tempdir, "data/x.rds")),
                     sub("//", "/", file.path(tempdir, "data/y.rds"))))
  expect_identical(list.files(file.path(sbf_get_main(), "data")),
                   sort(c("x.rds", "y.rds")))
  x <- 0
  y <- 0
  expect_identical(sbf_load_datas(), c("x", "y"))
  expect_identical(x, data.frame(x = 1))
  expect_identical(y, data.frame(z = 3))
  
  data <- sbf_load_datas_recursive()
  expect_is(data, "data.frame")
  expect_identical(colnames(data), c("data", "name", "file"))
  expect_identical(data$data[[1]], data.frame(x = 1))
  expect_identical(data$name, c("x", "y"))
  expect_identical(data$file, 
                   c(sub("//", "/", file.path(tempdir, "data/x.rds")),
                     sub("//", "/", file.path(tempdir, "data/y.rds"))))
  
  expect_identical(sbf_reset_sub(), character(0))
  expect_identical(sbf_load_data("x"), x)
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))
  expect_error(sbf_load_data("x"), "/data/x.rds' does not exist")
  expect_identical(sbf_set_sub("sub"), "sub")
  expect_identical(sbf_save_data(x), sub("//", "/", file.path(tempdir, "data/sub/x.rds")))
  expect_identical(sbf_load_data("x"), x)
  expect_error(sbf_load_data("x2"), "/data/sub/x2.rds' does not exist")
})

test_that("number",{
  teardown(sbf_reset_sub(rm = TRUE, ask = FALSE))
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))
  
  tempdir <- tempdir()
  sbf_set_main(tempdir)
  y <- numeric(0)
  expect_warning(sbf_load_numbers(), "no numbers to load")
  expect_error(sbf_save_number(), "argument \"x\" is missing, with no default")
  expect_error(sbf_save_number(y), "x must have 1 element")
  x <- 1L
  expect_identical(sbf_save_number(x), sub("//", "/", file.path(tempdir, "numbers/x.rds")))
  
  expect_identical(sbf_save_number(x, exists = TRUE), sub("//", "/", file.path(tempdir, "numbers/x.rds")))
  expect_error(sbf_save_number(x, exists = FALSE), 
               paste0("file '", sub("//", "/", file.path(tempdir, "numbers/x.rds")), "' already exists"))
  expect_error(sbf_save_number(x, x_name = "y", exists = TRUE), 
               paste0("file '", sub("//", "/", file.path(tempdir, "numbers/y.rds")), "' doesn't exist"))
  expect_error(sbf_save_number(x, x_name = "y", exists = TRUE), 
               paste0("file '", sub("//", "/", file.path(tempdir, "numbers/y.rds")), "' doesn't exist"))
  
  expect_error(sbf_save_number(x, x_name = "_x"), "x_name must match regular expression")
  expect_identical(sbf_load_number("x"), 1)
  expect_identical(list.files(file.path(sbf_get_main(), "numbers")),
                   sort(c("x.csv", "x.rds", "y.csv")))
  csv <- read.csv(file.path(sbf_get_main(), "numbers", "x.csv"))
  expect_equal(csv, data.frame(x = 1))
  
  y <- 3
  expect_identical(sbf_save_numbers(env = as.environment(list(x = x, y = y))), 
                   c(sub("//", "/", file.path(tempdir, "numbers/x.rds")),
                     sub("//", "/", file.path(tempdir, "numbers/y.rds"))))
  expect_identical(list.files(file.path(sbf_get_main(), "numbers")),
                   sort(c("x.csv", "x.rds", "y.csv", "y.rds")))
  x <- 0
  y <- 0
  expect_identical(sbf_load_numbers(), c("x", "y"))
  expect_identical(x, 1)
  expect_identical(y, 3)
  
  data <- sbf_load_numbers_recursive()
  expect_is(data, "data.frame")
  expect_identical(colnames(data), c("numbers", "name", "file"))
  expect_identical(data$numbers, c(1, 3))
  expect_identical(data$name, c("x", "y"))
  expect_identical(data$file, 
                   c(sub("//", "/", file.path(tempdir, "numbers/x.rds")),
                     sub("//", "/", file.path(tempdir, "numbers/y.rds"))))
  
  expect_error(sbf_load_number("x2"), "/numbers/x2.rds' does not exist")
  expect_identical(sbf_reset_sub(), character(0))
  expect_identical(sbf_load_number("x"), 1)
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))
  expect_error(sbf_load_number("x"), "/numbers/x.rds' does not exist")
  expect_identical(sbf_set_sub("sub"), "sub")
  expect_identical(sbf_save_number(x), sub("//", "/", file.path(tempdir, "numbers/sub/x.rds")))
  expect_identical(sbf_load_number("x"), 1)
  expect_error(sbf_load_number("x2"), "/numbers/sub/x2.rds' does not exist")
})

test_that("string",{
  teardown(sbf_reset_sub(rm = TRUE, ask = FALSE))
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))
  
  tempdir <- tempdir()
  sbf_set_main(tempdir)
  y <- "two words"
  expect_warning(sbf_load_strings(), "no strings to load")
  expect_error(sbf_save_string(), "argument \"x\" is missing, with no default")
  expect_identical(sbf_save_string(y), sub("//", "/", file.path(tempdir, "strings/y.rds")))
  expect_identical(sbf_save_string(y, exists = TRUE), sub("//", "/", file.path(tempdir, "strings/y.rds")))
  expect_error(sbf_save_string(y, exists = FALSE), 
               paste0("file '", sub("//", "/", file.path(tempdir, "strings/y.rds")), "' already exists"))
  expect_error(sbf_save_string(y, x_name = "x", exists = TRUE), 
               paste0("file '", sub("//", "/", file.path(tempdir, "strings/x.rds")), "' doesn't exist"))
  expect_error(sbf_save_string(y, x_name = "x", exists = TRUE), 
               paste0("file '", sub("//", "/", file.path(tempdir, "strings/x.rds")), "' doesn't exist"))
  
  expect_error(sbf_save_string(y, x_name = "_x"), "x_name must match regular expression")
  expect_identical(sbf_load_string("y"), "two words")
  expect_identical(list.files(file.path(sbf_get_main(), "strings")),
                   sort(c("x.txt", "y.rds", "y.txt")))
  txt <- readLines(file.path(sbf_get_main(), "strings", "y.txt"), warn = FALSE)
  expect_equal(txt, "two words")
  
  x <- "one"
  expect_identical(sbf_save_strings(env = as.environment(list(x = x, y = y))), 
                   c(sub("//", "/", file.path(tempdir, "strings/x.rds")),
                     sub("//", "/", file.path(tempdir, "strings/y.rds"))))
  expect_identical(list.files(file.path(sbf_get_main(), "strings")),
                   sort(c("x.rds", "x.txt", "y.rds", "y.txt")))
  x <- 0
  y <- 0
  expect_identical(sbf_load_strings(), c("x", "y"))
  expect_identical(x, "one")
  expect_identical(y, "two words")
  
  data <- sbf_load_strings_recursive()
  expect_is(data, "data.frame")
  expect_identical(colnames(data), c("strings", "name", "file"))
  expect_identical(data$strings, c("one", "two words"))
  expect_identical(data$name, c("x", "y"))
  expect_identical(data$file, 
                   c(sub("//", "/", file.path(tempdir, "strings/x.rds")),
                     sub("//", "/", file.path(tempdir, "strings/y.rds"))))
  
  expect_error(sbf_load_string("x2"), "/strings/x2.rds' does not exist")
  expect_identical(sbf_reset_sub(), character(0))
  expect_identical(sbf_load_string("y"), "two words")
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))
  expect_error(sbf_load_string("x"), "/strings/x.rds' does not exist")
  expect_identical(sbf_set_sub("sub"), "sub")
  expect_identical(sbf_save_string(y), sub("//", "/", file.path(tempdir, "strings/sub/y.rds")))
  expect_identical(sbf_load_string("y"), "two words")
  expect_error(sbf_load_string("x2"), "/strings/sub/x2.rds' does not exist")
})

test_that("block",{
  teardown(sbf_reset_sub(rm = TRUE, ask = FALSE))
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))
  
  tempdir <- tempdir()
  sbf_set_main(tempdir)
  y <- "two words"
  expect_warning(sbf_load_blocks(), "no blocks to load")
  expect_error(sbf_save_block(), "argument \"x\" is missing, with no default")
  expect_identical(sbf_save_block(y), sub("//", "/", file.path(tempdir, "blocks/y.rds")))
  expect_identical(sbf_save_block(y, exists = TRUE), sub("//", "/", file.path(tempdir, "blocks/y.rds")))
  expect_error(sbf_save_block(y, exists = FALSE), 
               paste0("file '", sub("//", "/", file.path(tempdir, "blocks/y.rds")), "' already exists"))
  expect_error(sbf_save_block(y, x_name = "x", exists = TRUE), 
               paste0("file '", sub("//", "/", file.path(tempdir, "blocks/x.rds")), "' doesn't exist"))
  expect_error(sbf_save_block(y, x_name = "x", exists = TRUE), 
               paste0("file '", sub("//", "/", file.path(tempdir, "blocks/x.rds")), "' doesn't exist"))
  
  expect_error(sbf_save_block(y, x_name = "_x"), "x_name must match regular expression")
  expect_identical(sbf_load_block("y"), "two words")
  expect_identical(list.files(file.path(sbf_get_main(), "blocks")),
                   sort(c("_x.rda", "_y.rda", "x.txt", "y.rds", "y.txt")))
  txt <- readLines(file.path(sbf_get_main(), "blocks", "y.txt"), warn = FALSE)
  expect_equal(txt, "two words")
  
  one <- "some code"
  expect_identical(sbf_save_block(one), sub("//", "/", file.path(tempdir, "blocks/one.rds")))
  one <- 0
  y <- 0
  expect_identical(sbf_load_blocks(), c("one", "y"))
  expect_identical(one, "some code")
  expect_identical(y, "two words")
  
  data <- sbf_load_blocks_recursive()
  expect_is(data, "data.frame")
  expect_identical(colnames(data), c("blocks", "name", "file"))
  expect_identical(data$blocks, c("some code", "two words"))
  expect_identical(data$name, c("one", "y"))
  expect_identical(data$file, 
                   c(sub("//", "/", file.path(tempdir, "blocks/one.rds")),
                     sub("//", "/", file.path(tempdir, "blocks/y.rds"))))
  
  expect_error(sbf_load_block("x2"), "/blocks/x2.rds' does not exist")
  expect_identical(sbf_reset_sub(), character(0))
  expect_identical(sbf_load_block("y"), "two words")
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))
  expect_error(sbf_load_block("x"), "/blocks/x.rds' does not exist")
  expect_identical(sbf_set_sub("sub"), "sub")
  expect_identical(sbf_save_block(y), sub("//", "/", file.path(tempdir, "blocks/sub/y.rds")))
  expect_identical(sbf_load_block("y"), "two words")
  expect_error(sbf_load_block("x2"), "/blocks/sub/x2.rds' does not exist")
})

test_that("table",{
  teardown(sbf_reset_sub(rm = TRUE, ask = FALSE))
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))
  
  tempdir <- tempdir()
  sbf_set_main(tempdir)
  y <- 1
  expect_warning(sbf_load_tables(), "no tables to load")
  expect_error(sbf_save_table(), "argument \"x\" is missing, with no default")
  expect_error(sbf_save_table(y), "x must inherit from class data.frame")
  x <- data.frame(x = 1)
  expect_identical(sbf_save_table(x), sub("//", "/", file.path(tempdir, "tables/x.rds")))
  expect_identical(sbf_save_table(x, exists = TRUE), sub("//", "/", file.path(tempdir, "tables/x.rds")))
  expect_error(sbf_save_table(x, exists = FALSE), 
               paste0("file '", sub("//", "/", file.path(tempdir, "tables/x.rds")), "' already exists"))
  expect_error(sbf_save_table(x, x_name = "y", exists = TRUE), 
               paste0("file '", sub("//", "/", file.path(tempdir, "tables/y.rds")), "' doesn't exist"))
  expect_error(sbf_save_table(x, x_name = "y", exists = TRUE), 
               paste0("file '", sub("//", "/", file.path(tempdir, "tables/y.rds")), "' doesn't exist"))
  expect_error(sbf_save_table(x, x_name = "_x"), "x_name must match regular expression")
  
  expect_error(sbf_save_table(x, x_name = "_x"), "x_name must match regular expression")
  expect_identical(sbf_load_table("x"), x)
  expect_identical(list.files(file.path(sbf_get_main(), "tables")),
                   sort(c("_x.rda", "_y.rda", "x.csv", "x.rds", "y.csv")))
  csv <- read.csv(file.path(sbf_get_main(), "tables", "x.csv"))
  expect_equal(csv, x)
  meta <- readRDS(paste0(file.path(sbf_get_main(), "tables", "_x.rda")))
  expect_identical(meta, list(caption = NULL, report = TRUE))
  
  y <- data.frame(z = 2L)
  expect_identical(sbf_save_table(y), sub("//", "/", file.path(tempdir, "tables/y.rds")))
  x <- 0
  y <- 0
  expect_identical(sbf_load_tables(), c("x", "y"))
  expect_identical(x, data.frame(x = 1))
  expect_identical(y, data.frame(z = 2L))
  
  data <- sbf_load_tables_recursive()
  expect_is(data, "data.frame")
  expect_identical(colnames(data), c("tables", "name", "file"))
  expect_identical(data$tables[[1]], data.frame(x = 1))
  expect_identical(data$name, c("x", "y"))
  expect_identical(data$file, 
                   c(sub("//", "/", file.path(tempdir, "tables/x.rds")),
                     sub("//", "/", file.path(tempdir, "tables/y.rds"))))
  
  expect_error(sbf_load_table("x2"), "/tables/x2.rds' does not exist")
  expect_identical(sbf_reset_sub(), character(0))
  expect_identical(sbf_load_table("x"), x)
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))
  expect_error(sbf_load_table("x"), "/tables/x.rds' does not exist")
  expect_identical(sbf_set_sub("sub"), "sub")
  expect_identical(sbf_save_table(x), sub("//", "/", file.path(tempdir, "tables/sub/x.rds")))
  expect_identical(sbf_load_table("x"), x)
  expect_error(sbf_load_table("x2"), "/tables/sub/x2.rds' does not exist")
})

test_that("datas_to_db",{
  teardown(sbf_reset_sub(rm = TRUE, ask = FALSE))
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))
  
  tempdir <- tempdir()
  sbf_set_main(tempdir)
  x <- data.frame(x = 1)
  y <- data.frame(z = 3)
  expect_error(sbf_save_datas_to_db("z", env = as.environment(list(x = x, y = y))),
               paste0("file '", sub("//", "/", file.path(tempdir, "dbs/z.sqlite")), "' doesn't exist"))
  
  conn <- sbf_open_db("z")
  teardown(suppressWarnings(DBI::dbDisconnect(conn)))
  expect_error(sbf_save_datas_to_db("z", env = as.environment(list(x = x, y = y))),
               "exists = TRUE but the following data frames in 'x' are unrecognised: 'y' and 'x'")
  
  DBI::dbGetQuery(conn, "CREATE TABLE x (
                  x INTEGER PRIMARY KEY NOT NULL)")
  
  DBI::dbGetQuery(conn, "CREATE TABLE y (
                  z INTEGER PRIMARY KEY NOT NULL)")
  
  expect_identical(sbf_save_datas_to_db("z", env = as.environment(list(x = x, y = y))),
                   c("y", "x"))
  
  expect_error(sbf_save_datas_to_db("z", env = as.environment(list(x = x, y = y))),
               "UNIQUE constraint failed: y.z")
  
  expect_true(sbf_close_db(conn))
  x <- 0
  y <- 0
  
  expect_identical(sbf_load_datas_from_db("z"), c("x", "y"))
  expect_identical(x, tibble::tibble(x = 1L))
  expect_identical(y, tibble::tibble(z = 3L))
})

test_that("plot",{
  teardown(sbf_reset_sub(rm = TRUE, ask = FALSE))
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))
  
  sbf_close_windows()
  teardown(sbf_close_windows())
  
  tempdir <- tempdir()
  sbf_set_main(tempdir)
  y <- 1
  expect_error(sbf_save_plot(y), "x must inherit from class ggplot")
  
  x <- ggplot2::ggplot()
  expect_identical(sbf_save_plot(x), sub("//", "/", file.path(tempdir, "plots/x.rds")))
  expect_equal(sbf_load_plot("x"), x)
  expect_identical(sbf_load_plot_data("x"), data.frame())
  
  y <- ggplot2::ggplot(data = data.frame(x = 1, y = 2), ggplot2::aes(x = x, y = y))
  expect_identical(sbf_save_plot(y), sub("//", "/", file.path(tempdir, "plots/y.rds")))
  
  expect_equal(sbf_load_plot("y"), y)
  expect_identical(sbf_load_plot_data("y"), data.frame(x = 1, y = 2))
  
  expect_identical(list.files(file.path(sbf_get_main(), "plots")),
                   sort(c("_x.rda", "_y.rda", "x.png", "x.rds",
                          "y.csv", "y.png", "y.rds")))
  
  expect_identical(sbf_load_plots_data(), c("x", "y"))
  expect_identical(x, data.frame())
  expect_identical(y, data.frame(x = 1, y = 2))
  
  z <- ggplot2::ggplot(data = data.frame(x = 2, y = 3), ggplot2::aes(x = x, y = y))
  expect_identical(sbf_save_plot(z), sub("//", "/", file.path(tempdir, "plots/z.rds")))
  expect_equal(sbf_load_plot("z"), z)
  
  t <- ggplot2::ggplot(data = data.frame(x = c(2,3), y = c(3,2)), ggplot2::aes(x = x, y = y))
  expect_identical(sbf_save_plot(csv = 1L), sub("//", "/", file.path(tempdir, "plots/plot.rds")))
  expect_equal(sbf_load_plot("plot"), t)
  
  expect_identical(list.files(file.path(sbf_get_main(), "plots")),
                   sort(c("_plot.rda", "_x.rda", "_y.rda", "_z.rda",
                          "plot.png", "plot.rds", "x.png", "x.rds",
                          "y.csv", "y.png", "y.rds", "z.csv",
                          "z.png", "z.rds")))
  
  plots <- sbf_load_plots_recursive()
  expect_is(plots, "data.frame")
  expect_identical(colnames(plots), c("plots", "name", "file"))
  expect_is(plots$plots[[2]], "ggplot")
  expect_identical(plots$name, c("plot", "x", "y", "z"))
  expect_identical(plots$file, 
                   c(sub("//", "/", file.path(tempdir, "plots/plot.rds")),
                     sub("//", "/", file.path(tempdir, "plots/x.rds")),
                     sub("//", "/", file.path(tempdir, "plots/y.rds")),
                     sub("//", "/", file.path(tempdir, "plots/z.rds"))))  
  
  data <- sbf_load_plots_data_recursive()
  expect_is(data, "data.frame")
  expect_identical(colnames(data), c("plots_data", "name", "file"))
  expect_identical(data$plots_data[[2]], data.frame())
  expect_identical(data$name, c("plot", "x", "y", "z"))
  expect_identical(data$file, 
                   c(sub("//", "/", file.path(tempdir, "plots/plot.rds")),
                     sub("//", "/", file.path(tempdir, "plots/x.rds")),
                     sub("//", "/", file.path(tempdir, "plots/y.rds")),
                     sub("//", "/", file.path(tempdir, "plots/z.rds"))))
  
})

test_that("window",{
  teardown(sbf_reset_sub(rm = TRUE, ask = FALSE))
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))
  
  sbf_close_windows()
  teardown(sbf_close_windows())
  expect_error(sbf_save_window(), "no such device")
  
  skip('run locally as uses screen devices') 
  gp <- ggplot2::ggplot(data = data.frame(x = c(2,3), y = c(3,2)), ggplot2::aes(x = x, y = y))
  sbf_open_window()
  print(gp)
  expect_identical(sbf_save_window(), 
                   sub("//", "/", file.path(tempdir, "windows/window.png")))
  sbf_close_window()
  expect_identical(list.files(file.path(sbf_get_main(), "windows")),
                   sort(c("_window.rda", "window.png")))
  
  meta <- readRDS(paste0(file.path(sbf_get_main(), "windows", "_window.rda")))
  expect_identical(meta, list(caption = NULL, report = TRUE,
                              width = 6, height = 6, res = 300))
  
  gp <- ggplot2::ggplot(data = data.frame(x = c(4,5), y = c(6,7)), ggplot2::aes(x = x, y = y))
  sbf_open_window(4,3)
  print(gp)
  expect_identical(sbf_save_window("t2", dpi = 72, caption = "nice one"), 
                   sub("//", "/", file.path(tempdir, "windows/t2.png"))) 
  
  expect_error(sbf_save_window("t2", exists = FALSE), 
               "/windows/t2.png' already exists")
  
  expect_error(sbf_save_window("t3", exists = TRUE), 
               "/windows/t3.png' doesn't exist")
  
  expect_identical(list.files(file.path(sbf_get_main(), "windows")),
                   sort(c("_t2.rda", "_window.rda", "t2.png", "window.png")))
  
  meta <- readRDS(paste0(file.path(sbf_get_main(), "windows", "_t2.rda")))
  expect_identical(meta, list(caption = "nice one", report = TRUE,
                              width = 4, height = 3, res = 72))
})
