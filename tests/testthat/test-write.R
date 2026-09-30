test_that("sbf_write_datas_to_xlsx", {
  path <- withr::local_tempfile(fileext = ".xlsx")

  expect_false(file.exists(path))
  expect_warning(sbf_write_datas_to_xlsx(path))
  expect_false(file.exists(path))

  mtcars2 <- data.frame(x = 1)
  expect_identical(sbf_write_datas_to_xlsx(path), "mtcars2")
  expect_true(file.exists(path))
})

test_that("sbf_write_datas_to_xlsx exists TRUE/FALSE", {
  path <- withr::local_tempfile(fileext = ".xlsx")
  mtcars2 <- data.frame(x = 1)

  expect_error(sbf_write_datas_to_xlsx(path, exists = TRUE))
  expect_false(file.exists(path))

  expect_identical(sbf_write_datas_to_xlsx(path, exists = FALSE), "mtcars2")
  expect_true(file.exists(path))

  # exists = TRUE now overwrites the existing file
  mtcars2 <- data.frame(x = 2)
  expect_identical(sbf_write_datas_to_xlsx(path, exists = TRUE), "mtcars2")
  expect_identical(readxl::read_xlsx(path)$x, 2)

  mtcars2 <- data.frame(x = 3)
  expect_identical(
    sbf_write_datas_to_xlsx(path, exists = FALSE, ask = FALSE),
    "mtcars2"
  )
  expect_identical(readxl::read_xlsx(path)$x, 3)
})
