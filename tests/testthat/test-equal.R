test_that("is_equal_data", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  x <- data.frame(x = 1)
  expect_type(sbf_save_data(x), "character")
  expect_identical(sbf_load_data("x"), x)

  expect_true(sbf_is_equal_data(x))
  expect_identical(names(sbf_is_equal_data(x)), "data/x")

  y <- x
  expect_false(sbf_is_equal_data(y))
  expect_identical(names(sbf_is_equal_data(y)), "data/y")
  expect_equal(sbf_is_equal_data(y, exists = NA), NA,
    ignore_attr = TRUE
  )
  expect_false(sbf_is_equal_data(y, exists = TRUE))
  expect_true(sbf_is_equal_data(y, exists = FALSE))
  expect_true(sbf_is_equal_data(y, "x"))
  expect_true(sbf_is_equal_data(y, "x", exists = NA))
  expect_true(sbf_is_equal_data(y, "x", exists = FALSE))
  x <- 1
  expect_chk_error(sbf_is_equal_data(x))
})

test_that("is_equal_datas", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  x <- data.frame(x = 1)
  sbf_save_data(x)
  y <- data.frame(x = 2.000001)
  sbf_save_data(y)

  expect_message(sbf_archive_main(ask = FALSE))

  expect_identical(
    sbf_is_equal_data_archive(),
    c("data/x" = TRUE, "data/y" = TRUE)
  )
  expect_identical(
    sbf_is_equal_data_archive("x"),
    c("data/x" = TRUE)
  )
  expect_identical(
    sbf_is_equal_data_archive("z"),
    structure(logical(0),
      .Names = character(0)
    )
  )

  expect_message(sbf_rm_main(ask = FALSE))
  expect_identical(
    sbf_is_equal_data_archive(),
    c("data/x" = FALSE, "data/y" = FALSE)
  )
  expect_identical(
    sbf_is_equal_data_archive(exists = FALSE),
    c("data/x" = TRUE, "data/y" = TRUE)
  )
  expect_identical(
    sbf_is_equal_data_archive(exists = NA),
    c("data/x" = NA, "data/y" = NA)
  )

  sbf_save_data(x)
  expect_identical(
    sbf_is_equal_data_archive(),
    c("data/x" = TRUE, "data/y" = FALSE)
  )
  expect_identical(
    sbf_is_equal_data_archive(exists = FALSE),
    c("data/x" = TRUE, "data/y" = TRUE)
  )
  expect_identical(
    sbf_is_equal_data_archive(exists = NA),
    c("data/x" = TRUE, "data/y" = NA)
  )

  sbf_save_data(x, "z")
  expect_identical(
    sbf_is_equal_data_archive(),
    c("data/x" = TRUE, "data/y" = FALSE, "data/z" = FALSE)
  )
  expect_identical(
    sbf_is_equal_data_archive(exists = FALSE),
    c("data/x" = TRUE, "data/y" = TRUE, "data/z" = TRUE)
  )
  expect_identical(
    sbf_is_equal_data_archive(exists = NA),
    c("data/x" = TRUE, "data/y" = NA, "data/z" = NA)
  )

  y <- data.frame(x = 2)
  sbf_save_data(y)
  expect_identical(
    sbf_is_equal_data_archive(),
    c("data/x" = TRUE, "data/y" = FALSE, "data/z" = FALSE)
  )
  expect_identical(
    sbf_is_equal_data_archive(tolerance = 0.1),
    c("data/x" = TRUE, "data/y" = TRUE, "data/z" = FALSE)
  )
})

test_that("is_equal_datas", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  x <- data.frame(x = 1)
  sbf_save_data(x)
  expect_message(archive1 <- sbf_archive_main(ask = FALSE))

  x <- data.frame(x = 1.00001)
  sbf_save_data(x)
  expect_message(archive2 <- sbf_archive_main(ask = FALSE))

  expect_identical(
    sbf_is_equal_data_archive(main = archive1, archive = archive2),
    c("data/x" = FALSE)
  )
  expect_identical(
    sbf_is_equal_data_archive(main = archive1, archive = archive2, tolerance = 0.1),
    c("data/x" = TRUE)
  )
})
