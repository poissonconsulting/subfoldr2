test_that("data", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  teardown(sbf_reset())

  x <- data.frame(x = 1)
  expect_type(sbf_save_data(x), "character")
  expect_identical(sbf_load_data("x"), x)

  expect_s3_class(sbf_diff_data(x), "data_diff")

  y <- x
  expect_error(sbf_diff_data(y, exists = TRUE))
  expect_s3_class(sbf_diff_data(y), "data_diff")
  expect_s3_class(sbf_diff_data(y, "x"), "data_diff")
  x <- 1
  expect_error(sbf_diff_data(x))
})


test_that("diff_datas", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  teardown(sbf_reset())

  x <- data.frame(x = 1)
  sbf_save_data(x)
  archive1 <- sbf_archive_main(ask = FALSE)

  x <- data.frame(x = 1.00001)
  sbf_save_data(x)
  archive2 <- sbf_archive_main(ask = FALSE)

  diff <- sbf_diff_datas(main = archive1, archive = archive2)
  expect_type(diff, "list")
  expect_identical(names(diff), "data/x")
  expect_s3_class(diff[[1]], "data_diff")
})

test_that("diff_datas", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  teardown(sbf_reset())

  x <- data.frame(x = 1)
  sbf_save_data(x)
  y <- data.frame(x = 2.000001)
  sbf_save_data(y)

  archive1 <- sbf_archive_main(ask = FALSE)

  diff <- sbf_diff_datas()
  expect_identical(names(diff), c("data/x", "data/y"))
  expect_s3_class(diff[[1]], "data_diff")
  expect_s3_class(diff[[2]], "data_diff")
})

test_that("table", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  teardown(sbf_reset())

  x <- data.frame(x = 1)
  expect_type(sbf_save_table(x), "character")
  expect_identical(sbf_load_table("x"), x)

  expect_s3_class(sbf_diff_table(x), "data_diff")

  y <- x
  expect_error(sbf_diff_table(y, exists = TRUE))
  expect_s3_class(sbf_diff_table(y), "data_diff")
  expect_s3_class(sbf_diff_table(y, "x"), "data_diff")
  x <- 1
  expect_error(sbf_diff_table(x))
})
