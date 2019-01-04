context("save")

test_that("object",{
  sbf_set_main(tempdir())
  x <- 1
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
