context("save-load")

test_that("object",{
  teardown(sbf_reset_sub(rm = TRUE, ask = FALSE))
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))
  
  tempdir <- tempdir()
  sbf_set_main(tempdir)
  x <- 1
  expect_error(sbf_save_object(x_name = "x"), "argument \"x\" is missing, with no default")
  expect_error(sbf_save_object(), "x_name must have at least 1 character")
  expect_match(sbf_save_object(x), sub("//", "/", file.path(tempdir, "objects/x.rds")))
  expect_match(sbf_save_object(x, exists = TRUE), sub("//", "/", file.path(tempdir, "objects/x.rds")))
  expect_error(sbf_save_object(x, exists = FALSE), 
               paste0("file '", sub("//", "/", file.path(tempdir, "objects/x.rds")), "' already exists"))
  expect_error(sbf_save_object(x, x_name = "y", exists = TRUE), 
               paste0("file '", sub("//", "/", file.path(tempdir, "objects/y.rds")), "' doesn't exist"))
  expect_error(sbf_save_object(x, x_name = "y", exists = TRUE), 
               paste0("file '", sub("//", "/", file.path(tempdir, "objects/y.rds")), "' doesn't exist"))
  expect_error(sbf_save_object(x, x_name = "_x"), "x_name must match regular expression")
  expect_identical(sbf_load_object("x"), x)
  expect_error(sbf_load_object("x2"), "/objects/x2.rds' does not exist")
  expect_identical(sbf_reset_sub(), character(0))
  expect_identical(sbf_load_object("x"), x)
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))
  expect_error(sbf_load_object("x"), "/objects/x.rds' does not exist")
  expect_identical(sbf_set_sub("sub"), "sub")
  expect_match(sbf_save_object(x), sub("//", "/", file.path(tempdir, "objects/sub/x.rds")))
  expect_identical(sbf_load_object("x"), x)
  expect_error(sbf_load_object("x2"), "/objects/sub/x2.rds' does not exist")
})

test_that("data.data.frame",{
  teardown(sbf_reset_sub(rm = TRUE, ask = FALSE))
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))

  tempdir <- tempdir()
  sbf_set_main(tempdir)
  y <- 1
  expect_error(sbf_save_data(), "no applicable method for 'sbf_save_data' applied to an object of class \"NULL\"")
  expect_error(sbf_save_data(y), "no applicable method for 'sbf_save_data' applied to an object of class")
  x <- data.frame(x = 1)
  expect_match(sbf_save_data(x), sub("//", "/", file.path(tempdir, "data/x.rds")))
  expect_match(sbf_save_data(x, exists = TRUE), sub("//", "/", file.path(tempdir, "data/x.rds")))
  expect_error(sbf_save_data(x, exists = FALSE), 
               paste0("file '", sub("//", "/", file.path(tempdir, "data/x.rds")), "' already exists"))
  expect_error(sbf_save_data(x, x_name = "y", exists = TRUE), 
               paste0("file '", sub("//", "/", file.path(tempdir, "data/y.rds")), "' doesn't exist"))
  expect_error(sbf_save_data(x, x_name = "y", exists = TRUE), 
               paste0("file '", sub("//", "/", file.path(tempdir, "data/y.rds")), "' doesn't exist"))
  expect_error(sbf_save_data(x, x_name = "_x"), "x_name must match regular expression")
  expect_identical(sbf_load_data("x"), x)
  expect_error(sbf_load_data("x2"), "/data/x2.rds' does not exist")
  expect_identical(sbf_reset_sub(), character(0))
  expect_identical(sbf_load_data("x"), x)
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))
  expect_error(sbf_load_data("x"), "/data/x.rds' does not exist")
  expect_identical(sbf_set_sub("sub"), "sub")
  expect_match(sbf_save_data(x), sub("//", "/", file.path(tempdir, "data/sub/x.rds")))
  expect_identical(sbf_load_data("x"), x)
  expect_error(sbf_load_data("x2"), "/data/sub/x2.rds' does not exist")
})

test_that("data.list",{
  teardown(sbf_reset_sub(rm = TRUE, ask = FALSE))
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))

  tempdir <- tempdir()
  sbf_set_main(tempdir)
  y <- list(x = data.frame(z = 1), a = 1)
  
  expect_error(sbf_save_data(y), "list x includes objects which are not data frames")
  y$a <- NULL
  expect_identical(sbf_save_data(y), list(x = sub("//", "/", file.path(tempdir, "data/x.rds"))))
  expect_identical(sbf_save_data(y, exists = TRUE), list(x = sub("//", "/", file.path(tempdir, "data/x.rds"))))
  expect_error(sbf_save_data(y, exists = FALSE), 
               paste0("file '", sub("//", "/", file.path(tempdir, "data/x.rds")), "' already exists"))
  expect_error(sbf_save_data(y, x_name = "y", exists = TRUE), 
               paste0("file '", sub("//", "/", file.path(tempdir, "data/yx.rds")), "' doesn't exist"))
  expect_error(sbf_save_data(y, x_name = "y", exists = TRUE), 
               paste0("file '", sub("//", "/", file.path(tempdir, "data/yx.rds")), "' doesn't exist"))
  expect_identical(sbf_load_data("x"), y$x)
  expect_error(sbf_load_data("x2"), "/data/x2.rds' does not exist")
  expect_identical(sbf_reset_sub(), character(0))
  expect_identical(sbf_load_data("x"), y$x)
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))
  expect_error(sbf_load_data("x"), "/data/x.rds' does not exist")
  expect_identical(sbf_set_sub("sub"), "sub")
  y$a <- data.frame(aa = 3)
  expect_identical(sbf_save_data(y), 
                   list(x = sub("//", "/", file.path(tempdir, "data/sub/x.rds")),
                        a = sub("//", "/", file.path(tempdir, "data/sub/a.rds"))))
  expect_identical(sbf_load_data("a"), y$a)
  expect_error(sbf_load_data("x2"), "/data/sub/x2.rds' does not exist")
})

test_that("number",{
  teardown(sbf_reset_sub(rm = TRUE, ask = FALSE))
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))

  tempdir <- tempdir()
  sbf_set_main(tempdir)
  y <- numeric(0)
  expect_error(sbf_save_number(), "argument \"x\" is missing, with no default")
  expect_error(sbf_save_number(y), "x must have 1 element")
  x <- 1L
  expect_match(sbf_save_number(x), sub("//", "/", file.path(tempdir, "numbers/x.rds")))
  
  expect_match(sbf_save_number(x, exists = TRUE), sub("//", "/", file.path(tempdir, "numbers/x.rds")))
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
  expect_error(sbf_load_number("x2"), "/numbers/x2.rds' does not exist")
  expect_identical(sbf_reset_sub(), character(0))
  expect_identical(sbf_load_number("x"), 1)
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))
  expect_error(sbf_load_number("x"), "/numbers/x.rds' does not exist")
  expect_identical(sbf_set_sub("sub"), "sub")
  expect_match(sbf_save_number(x), sub("//", "/", file.path(tempdir, "numbers/sub/x.rds")))
  expect_identical(sbf_load_number("x"), 1)
  expect_error(sbf_load_number("x2"), "/numbers/sub/x2.rds' does not exist")
})

test_that("string",{
  teardown(sbf_reset_sub(rm = TRUE, ask = FALSE))
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))

  tempdir <- tempdir()
  sbf_set_main(tempdir)
  y <- "two words"
  expect_error(sbf_save_string(), "argument \"x\" is missing, with no default")
  expect_match(sbf_save_string(y), sub("//", "/", file.path(tempdir, "strings/y.rds")))
  expect_match(sbf_save_string(y, exists = TRUE), sub("//", "/", file.path(tempdir, "strings/y.rds")))
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
  expect_error(sbf_load_string("x2"), "/strings/x2.rds' does not exist")
  expect_identical(sbf_reset_sub(), character(0))
  expect_identical(sbf_load_string("y"), "two words")
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))
  expect_error(sbf_load_string("x"), "/strings/x.rds' does not exist")
  expect_identical(sbf_set_sub("sub"), "sub")
  expect_match(sbf_save_string(y), sub("//", "/", file.path(tempdir, "strings/sub/y.rds")))
  expect_identical(sbf_load_string("y"), "two words")
  expect_error(sbf_load_string("x2"), "/strings/sub/x2.rds' does not exist")
})

test_that("block",{
  teardown(sbf_reset_sub(rm = TRUE, ask = FALSE))
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))

  tempdir <- tempdir()
  sbf_set_main(tempdir)
  y <- "two words"
  expect_error(sbf_save_block(), "argument \"x\" is missing, with no default")
  expect_match(sbf_save_block(y), sub("//", "/", file.path(tempdir, "blocks/y.rds")))
  expect_match(sbf_save_block(y, exists = TRUE), sub("//", "/", file.path(tempdir, "blocks/y.rds")))
  expect_error(sbf_save_block(y, exists = FALSE), 
               paste0("file '", sub("//", "/", file.path(tempdir, "blocks/y.rds")), "' already exists"))
  expect_error(sbf_save_block(y, x_name = "x", exists = TRUE), 
               paste0("file '", sub("//", "/", file.path(tempdir, "blocks/x.rds")), "' doesn't exist"))
  expect_error(sbf_save_block(y, x_name = "x", exists = TRUE), 
               paste0("file '", sub("//", "/", file.path(tempdir, "blocks/x.rds")), "' doesn't exist"))

  expect_error(sbf_save_block(y, x_name = "_x"), "x_name must match regular expression")
  expect_identical(sbf_load_block("y"), "two words")
  expect_identical(list.files(file.path(sbf_get_main(), "blocks")),
                   sort(c("_x.rds", "_y.rds", "x.txt", "y.rds", "y.txt")))
  txt <- readLines(file.path(sbf_get_main(), "blocks", "y.txt"), warn = FALSE)
  expect_equal(txt, "two words")
  expect_error(sbf_load_block("x2"), "/blocks/x2.rds' does not exist")
  expect_identical(sbf_reset_sub(), character(0))
  expect_identical(sbf_load_block("y"), "two words")
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))
  expect_error(sbf_load_block("x"), "/blocks/x.rds' does not exist")
  expect_identical(sbf_set_sub("sub"), "sub")
  expect_match(sbf_save_block(y), sub("//", "/", file.path(tempdir, "blocks/sub/y.rds")))
  expect_identical(sbf_load_block("y"), "two words")
  expect_error(sbf_load_block("x2"), "/blocks/sub/x2.rds' does not exist")
})

test_that("table",{
  teardown(sbf_reset_sub(rm = TRUE, ask = FALSE))
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))

  tempdir <- tempdir()
  sbf_set_main(tempdir)
  y <- 1
  expect_error(sbf_save_table(), "argument \"x\" is missing, with no default")
  expect_error(sbf_save_table(y), "x must inherit from class data.frame")
  x <- data.frame(x = 1)
  expect_match(sbf_save_table(x), sub("//", "/", file.path(tempdir, "tables/x.rds")))
  expect_match(sbf_save_table(x, exists = TRUE), sub("//", "/", file.path(tempdir, "tables/x.rds")))
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
                   sort(c("_x.rds", "_y.rds", "x.csv", "x.rds", "y.csv")))
  csv <- read.csv(file.path(sbf_get_main(), "tables", "x.csv"))
  expect_equal(csv, x)
  meta <- readRDS(paste0(file.path(sbf_get_main(), "tables", "_x.rds")))
  expect_identical(meta, list(caption = NULL, report = TRUE))
  expect_error(sbf_load_table("x2"), "/tables/x2.rds' does not exist")
  expect_identical(sbf_reset_sub(), character(0))
  expect_identical(sbf_load_table("x"), x)
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))
  expect_error(sbf_load_table("x"), "/tables/x.rds' does not exist")
  expect_identical(sbf_set_sub("sub"), "sub")
  expect_match(sbf_save_table(x), sub("//", "/", file.path(tempdir, "tables/sub/x.rds")))
  expect_identical(sbf_load_table("x"), x)
  expect_error(sbf_load_table("x2"), "/tables/sub/x2.rds' does not exist")
})
