test_that("data",{
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  teardown(sbf_reset())

  x <- data.frame(x = 1)
  expect_is(sbf_save_data(x), "character")
  expect_identical(sbf_load_data("x"), x)
  
  expect_is(sbf_diff_data(x), "data_diff")
  
  y <- x
  expect_error(sbf_diff_data(y, exists = TRUE))
  expect_is(sbf_diff_data(y), "data_diff")
  expect_is(sbf_diff_data(y, "x"), "data_diff")
  x <- 1
  expect_error(sbf_diff_data(x))
})

test_that("table",{
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  teardown(sbf_reset())

  x <- data.frame(x = 1)
  expect_is(sbf_save_table(x), "character")
  expect_identical(sbf_load_table("x"), x)
  
  expect_is(sbf_diff_table(x), "data_diff")
  
  y <- x
  expect_error(sbf_diff_table(y, exists = TRUE))
  expect_is(sbf_diff_table(y), "data_diff")
  expect_is(sbf_diff_table(y, "x"), "data_diff")
  x <- 1
  expect_error(sbf_diff_table(x))
})
