test_that("compare",{
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  teardown(sbf_reset())
  
  x <- data.frame(x = 1)
  expect_is(sbf_save_data(x), "character")
  expect_identical(sbf_load_data("x"), x)
  
  expect_is(sbf_compare_data(x), "waldo_compare")
  expect_identical(as.character(sbf_compare_data(x)), character(0))

  x <- data.frame(x = 1.00001)
  
  expect_is(sbf_compare_data(x, "x"), "waldo_compare")
  
  expect_identical(as.character(sbf_compare_data(x, "x")), "  `saved[[1]]`: \033[32m1.00000\033[39m\n`current[[1]]`: \033[32m1.00001\033[39m")
})
