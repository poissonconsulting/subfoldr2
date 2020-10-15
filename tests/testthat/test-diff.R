test_that("data",{
  teardown(sbf_reset_sub(rm = TRUE, ask = FALSE))
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))
  
  sbf_set_main(tempdir())
  x <- data.frame(x = 1)
  expect_is(sbf_save_data(x), "character")
  expect_identical(sbf_load_data("x"), x)
  
  expect_is(sbf_diff_data(x), "data_diff")
  
  y <- x
  expect_error(sbf_diff_data(y))
  expect_is(sbf_diff_data(y, "x"), "data_diff")
  x <- 1
  expect_error(sbf_diff_data(x))
})

test_that("table",{
  teardown(sbf_reset_sub(rm = TRUE, ask = FALSE))
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))
  
  sbf_set_main(tempdir())
  x <- data.frame(x = 1)
  expect_is(sbf_save_table(x), "character")
  expect_identical(sbf_load_table("x"), x)
  
  expect_is(sbf_diff_table(x), "data_diff")
  
  y <- x
  expect_error(sbf_diff_table(y))
  expect_is(sbf_diff_table(y, "x"), "data_diff")
  x <- 1
  expect_error(sbf_diff_table(x))
})

test_that("plot_data",{
  teardown(sbf_reset_sub(rm = TRUE, ask = FALSE))
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))
  
  sbf_set_main(tempdir())
  
  x <- data.frame(x = 1, y = 2)
  z <- ggplot2::ggplot(data = x, ggplot2::aes(x = x, y = y))
  
  expect_is(sbf_save_plot(z), "character")
  expect_identical(sbf_load_plot_data("z"), x)
  
  expect_is(sbf_diff_plot_data(x, "z"), "data_diff")
  
  expect_error(sbf_diff_plot_data(x))
  x <- 1
  expect_error(sbf_diff_plot_data(x))
})
