test_that("is_equal_data", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  teardown(sbf_reset())
  
  x <- data.frame(x = 1)
  expect_is(sbf_save_data(x), "character")
  expect_identical(sbf_load_data("x"), x)
  
  expect_true(sbf_is_equal_data(x))
  expect_identical(names(sbf_is_equal_data(x)), "data/x")
  
  y <- x
  expect_false(sbf_is_equal_data(y))
  expect_identical(names(sbf_is_equal_data(y)), "data/y")
  expect_equivalent(sbf_is_equal_data(y, exists = NA), NA)
  expect_false(sbf_is_equal_data(y, exists = TRUE))
  expect_true(sbf_is_equal_data(y, exists = FALSE))
  expect_true(sbf_is_equal_data(y, "x"))
  expect_true(sbf_is_equal_data(y, "x", exists = NA))
  expect_true(sbf_is_equal_data(y, "x", exists = FALSE))
  x <- 1
  expect_chk_error(sbf_is_equal_data(x))
})
