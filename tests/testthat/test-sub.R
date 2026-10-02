test_that("sub", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  expect_identical(sbf_reset_sub(), character(0))
  expect_identical(sbf_get_sub(), character(0))
  expect_identical(sbf_set_sub("sub"), "sub")
  expect_identical(sbf_get_sub(), "sub")
  expect_identical(
    sbf_set_sub(c("sub", "wub"), "mub/yub"),
    c("sub/wub/mub/yub")
  )
  expect_identical(sbf_set_sub("sub", "tub"), "sub/tub")
  expect_identical(sbf_set_sub("sub/rub", "tub"), "sub/rub/tub")
  expect_identical(sbf_set_sub("sub/"), "sub")
  expect_identical(sbf_set_sub("/sub"), "sub")
  expect_identical(sbf_set_sub("sub/", "tub"), "sub/tub")
  expect_identical(sbf_add_sub("bub", "nub"), "sub/tub/bub/nub")
  expect_identical(sbf_up_sub(), "sub/tub/bub")
  expect_identical(sbf_up_sub(2), "sub")
  expect_identical(sbf_up_sub(), character(0))
  expect_error(
    sbf_up_sub(3),
    "^`n` [(]3[)] must not exceed the number of subfolders [(]0[)][.]$",
    class = "chk_error"
  )

  expect_identical(sbf_reset_sub(), character(0))
  expect_identical(sbf_get_sub(), character(0))
})

test_that("sub argument accepts a character vector", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  data <- data.frame(x = 1)
  path <- file.path(sbf_get_main(), "data", "clean", "fwa", "rm.rds")

  expect_identical(sbf_save_data(data, "rm", sub = c("clean", "fwa")), path)
  expect_identical(sbf_load_data("rm", sub = "clean/fwa"), data)
  expect_identical(sbf_load_data("rm", sub = c("clean", "fwa")), data)
  expect_identical(sbf_path_data("rm", sub = c("clean", "fwa")), path)
  expect_identical(
    sbf_list_datas(sub = c("clean", "fwa")),
    sbf_list_datas(sub = "clean/fwa")
  )
  expect_identical(
    sbf_save_datas(
      sub = c("clean", "fwa"),
      env = as.environment(list(data = data))
    ),
    file.path(sbf_get_main(), "data", "clean", "fwa", "data.rds")
  )
  expect_identical(
    sbf_save_workbook(
      "wb",
      sub = c("clean", "fwa"),
      env = as.environment(list(data = data))
    ),
    file.path(sbf_get_main(), "excel", "clean", "fwa", "wb.xlsx")
  )

  sbf_save_number(1, "n", sub = c("clean", "fwa", "deep"))
  expect_identical(sbf_load_number("n", sub = "clean/fwa/deep"), 1)
})
