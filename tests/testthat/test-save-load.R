context("save-load")

test_that("object",{
  teardown(sbf_reset_sub(rm = TRUE, ask = FALSE))
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))
  
  sbf_set_main(tempdir())
  x <- 1
  expect_error(sbf_save_object(), "argument \"x\" is missing, with no default")
  expect_identical(sbf_save_object(x), x)
  expect_identical(sbf_load_object("x"), x)
  expect_error(sbf_load_object("x2"), "/objects/x2.rds' does not exist")
  expect_identical(sbf_reset_sub(), character(0))
  expect_identical(sbf_load_object("x"), x)
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))
  expect_error(sbf_load_object("x"), "/objects/x.rds' does not exist")
  expect_identical(sbf_set_sub("sub"), "sub")
  expect_identical(sbf_save_object(x), x)
  expect_identical(sbf_load_object("x"), x)
  expect_error(sbf_load_object("x2"), "/objects/sub/x2.rds' does not exist")
})

test_that("data",{
  teardown(sbf_reset_sub(rm = TRUE, ask = FALSE))
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))

  sbf_set_main(tempdir())
  y <- 1
  expect_error(sbf_save_data(), "argument \"x\" is missing, with no default")
  expect_error(sbf_save_data(y), "x must inherit from class data.frame")
  x <- data.frame(x = 1)
  expect_identical(sbf_save_data(x), x)
  expect_identical(sbf_load_data("x"), x)
  expect_error(sbf_load_data("x2"), "/data/x2.rds' does not exist")
  expect_identical(sbf_reset_sub(), character(0))
  expect_identical(sbf_load_data("x"), x)
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))
  expect_error(sbf_load_data("x"), "/data/x.rds' does not exist")
  expect_identical(sbf_set_sub("sub"), "sub")
  expect_identical(sbf_save_data(x), x)
  expect_identical(sbf_load_data("x"), x)
  expect_error(sbf_load_data("x2"), "/data/sub/x2.rds' does not exist")
})

test_that("table",{
  teardown(sbf_reset_sub(rm = TRUE, ask = FALSE))
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))

  sbf_set_main(tempdir())
  y <- 1
  expect_error(sbf_save_table(), "argument \"x\" is missing, with no default")
  expect_error(sbf_save_table(y), "x must inherit from class data.frame")
  x <- data.frame(x = 1)
  expect_identical(sbf_save_table(x), x)
  expect_identical(sbf_load_table("x"), x)
  expect_identical(list.files(file.path(sbf_get_main(), "tables")),
                   c("x.csv", "x.rds"))
  csv <- read.csv(paste0(file.path(sbf_get_main(), "tables", "x"), ".csv"))
  expect_equal(csv, x)
  expect_error(sbf_load_table("x2"), "/tables/x2.rds' does not exist")
  expect_identical(sbf_reset_sub(), character(0))
  expect_identical(sbf_load_table("x"), x)
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))
  expect_error(sbf_load_table("x"), "/tables/x.rds' does not exist")
  expect_identical(sbf_set_sub("sub"), "sub")
  expect_identical(sbf_save_table(x), x)
  expect_identical(sbf_load_table("x"), x)
  expect_error(sbf_load_table("x2"), "/tables/sub/x2.rds' does not exist")
})
