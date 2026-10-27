test_that("sbf_as_md with round = TRUE matches the md file of sbf_save_table", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  x <- data.frame(
    term = c("a", "b|c", NA),
    estimate = c(0.53124, 12.3456, 1234567),
    lower = c(0.21234, 9.8765, 1000000),
    upper = c(0.87012, 15.4321, 1500000),
    svalue = c(1.234, 5.678, 12),
    observed = c(0.6, 11, 1200000),
    length = c(1.23456, 123.456, NA),
    n = c(1L, 20000L, NA)
  )
  args <- list(
    format_column = list(length ~ round(., 1)),
    round_as_estimate = "observed"
  )
  do.call(sbf_save_table, c(list(x, x_name = "x"), args))
  expect_identical(
    do.call(sbf_as_md, c(list(x, round = TRUE), args)),
    sbf_load_table_md("x")
  )
  expect_snapshot(writeLines(sbf_load_table_md("x")))
})

test_that("sbf_as_md does not round by default and keeps text as text", {
  x <- data.frame(
    term = c("a", "b"),
    estimate = c(0.53124, 12.3456),
    big = c(123456.7, NA),
    n = 1:2,
    code = c("001", "12.5")
  )
  expect_snapshot(writeLines(sbf_as_md(x)))
  expect_identical(sbf_as_md(data.frame()), character(0))
})

test_that("sbf_as_md and sbf_round_data validate arguments", {
  x <- data.frame(estimate = c(0.5, 1.5), lower = 0.1, upper = "a", n = 2.5)
  expect_snapshot(error = TRUE, {
    sbf_as_md(1)
    sbf_as_md(x, round = NA)
    sbf_as_md(x, proportion = TRUE)
    sbf_as_md(x, format_column = list(n ~ round(.)))
    sbf_as_md(x, round_as_estimate = "n")
    sbf_as_md(x, round = TRUE)
    sbf_round_data(x)
    sbf_round_data(x["estimate"], proportion = TRUE)
    sbf_round_data(x["n"], format_column = list(z ~ round(.)))
    sbf_round_data(x["n"], format_column = list(n ~ 1:3))
  })
})

test_that("sbf_round_data rounds numeric columns as in the md file", {
  x <- data.frame(
    term = c("a", "b", "c"),
    estimate = c(0.53124, 12.3456, NA),
    lower = c(0.21234, 9.8765, NA),
    upper = c(0.87012, 15.4321, NA),
    svalue = c(1.234, 5.678, Inf),
    length = c(1.23456, 123.456, NaN),
    n = c(1L, 123456L, NA)
  )
  expect_identical(
    sbf_round_data(x),
    data.frame(
      term = c("a", "b", "c"),
      estimate = c(0.53, 12.3, NA),
      lower = c(0.21, 9.9, NA),
      upper = c(0.87, 15, NA),
      svalue = c(1.2, 5.7, Inf),
      length = c(1.235, 123.5, NaN),
      n = c(1L, 123456L, NA)
    )
  )
})

test_that("sbf_round_data applies format_column without further rounding", {
  x <- data.frame(length = c(1.23456, 123.456), code = c(1.5, 2.25))
  expect_identical(
    sbf_round_data(
      x,
      format_column = list(length ~ round(., 3), code ~ paste0("#", .))
    ),
    data.frame(length = c(1.235, 123.456), code = c("#1.5", "#2.25"))
  )
})

test_that("sbf_round_data respects proportion", {
  x <- data.frame(estimate = 0.99912, lower = 0.99812, upper = 0.99987)
  expect_identical(
    sbf_round_data(x, proportion = TRUE),
    data.frame(estimate = 0.99912, lower = 0.9981, upper = 0.99987)
  )
})

test_that("sbf_round_data keeps classes of data frame and columns", {
  x <- tibble::tibble(len = units::set_units(c(1.23456, 2), m))
  rounded <- sbf_round_data(x)
  expect_s3_class(rounded, "tbl_df")
  expect_identical(rounded$len, units::set_units(c(1.235, 2), m))
})

test_that("md files do not round integer64 columns", {
  skip_if_not_installed("bit64")
  x <- data.frame(n = bit64::as.integer64(c(123456, 7)))
  expect_identical(
    sbf_as_md(x, round = TRUE),
    c("|       n |", "| ------: |", "| 123,456 |", "|       7 |")
  )
  expect_identical(sbf_round_data(x), x)
})
