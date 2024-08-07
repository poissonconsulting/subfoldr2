test_that("compare", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  x <- data.frame(x = 1)
  expect_type(sbf_save_data(x), "character")
  expect_identical(sbf_load_data("x"), x)

  expect_s3_class(sbf_compare_data(x), "waldo_compare")
  expect_identical(as.character(sbf_compare_data(x)), character(0))

  x <- data.frame(x = 1.00001)

  compare <- sbf_compare_data(x, "x")
  expect_s3_class(compare, "waldo_compare")
})

test_that("compare_datas", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  x <- data.frame(x = 1)
  sbf_save_data(x)
  y <- data.frame(x = 2.000001)
  sbf_save_data(y)

  expect_message(archive1 <- sbf_archive_main(ask = FALSE))

  comparison <- sbf_compare_data_archive()

  expect_type(comparison, "list")
  expect_identical(names(comparison), c("data/x", "data/y"))
  expect_s3_class(comparison[["data/x"]], "waldo_compare")

  comparison <- sbf_compare_data_archive("x")
  expect_type(comparison, "list")
  expect_identical(names(comparison), "data/x")
  expect_s3_class(comparison[["data/x"]], "waldo_compare")
  expect_identical(nchar(comparison[["data/x"]]), integer(0))

  comparison <- sbf_compare_data_archive("z")
  expect_type(comparison, "list")
  expect_identical(names(comparison), character(0))

  expect_message(sbf_rm_main(ask = FALSE))

  skip_on_ci()

  comparison <- sbf_compare_data_archive()
  expect_type(comparison, "list")
  expect_identical(names(comparison), c("data/x", "data/y"))
  expect_s3_class(comparison[["data/x"]], "waldo_compare")

  sbf_save_data(x, "z")
  comparison <- sbf_compare_data_archive()
  expect_type(comparison, "list")
  expect_identical(names(comparison), c("data/x", "data/y", "data/z"))
})

test_that("compare_datas", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  x <- data.frame(x = 1)
  sbf_save_data(x)
  expect_message(archive1 <- sbf_archive_main(ask = FALSE))

  x <- data.frame(x = 1.00001)
  sbf_save_data(x)
  expect_message(archive2 <- sbf_archive_main(ask = FALSE))


  comparison <- sbf_compare_data_archive(
    main = archive1,
    archive = archive2,
    tolerance = 0.1
  )

  expect_type(comparison, "list")
  expect_identical(names(comparison), "data/x")
  expect_s3_class(comparison[["data/x"]], "waldo_compare")

  skip_on_ci()

  comparison <- sbf_compare_data_archive(main = archive1, archive = archive2)

  expect_type(comparison, "list")
  expect_identical(names(comparison), "data/x")
  expect_s3_class(comparison[["data/x"]], "waldo_compare")
})
