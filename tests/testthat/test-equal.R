test_that("multiplication works", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  teardown(sbf_reset())
  
  x <- data.frame(x = 1)
  expect_is(sbf_save_data(x), "character")
  expect_identical(sbf_load_data("x"), x)
  
  expect_true(sbf_is_equal_data(x))
  expect_identical(names(sbf_is_equal_data(x)), file.path(sbf_get_main(), "data/x.rds"))
  
  y <- x
  expect_false(sbf_is_equal_data(y))
  expect_identical(names(sbf_is_equal_data(y)), file.path(sbf_get_main(), "data/y.rds"))
  expect_true(sbf_is_equal_data(y, exists = NA))
  expect_true(sbf_is_equal_data(y, exists = FALSE))
  expect_true(sbf_is_equal_data(y, "x"))
  expect_true(sbf_is_equal_data(y, "x", exists = NA))
  expect_false(sbf_is_equal_data(y, "x", exists = FALSE))
  x <- 1
  expect_chk_error(sbf_is_equal_data(x))
})
