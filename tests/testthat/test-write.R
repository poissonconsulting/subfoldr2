test_that("sbf_write_datas_to_xlsx", {
  path <- withr::local_tempfile(fileext = ".xlsx")

  expect_false(file.exists(path))
  expect_identical(expect_warning(sbf_write_datas_to_xlsx(path)), character(0))
  expect_false(file.exists(path))
  
  mtcars2 <- data.frame(x = 1)
  expect_identical(sbf_write_datas_to_xlsx(path), "mtcars2")
  expect_true(file.exists(path))
})
