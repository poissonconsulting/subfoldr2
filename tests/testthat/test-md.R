test_that("sbf_save_table saves md alongside unrounded csv and rds", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  x <- data.frame(estimate = 0.53124, lower = 0.21234, upper = 0.87012)
  expect_identical(sbf_save_table(x), file.path(sbf_get_main(), "tables/x.rds"))
  expect_identical(
    readLines(file.path(sbf_get_main(), "tables/x.md")),
    c(
      "| estimate | lower | upper |",
      "| -------: | ----: | ----: |",
      "|     0.53 |  0.21 |  0.87 |"
    )
  )
  expect_identical(sbf_load_table("x"), x)
  csv <- read.csv(file.path(sbf_get_main(), "tables", "x.csv"))
  expect_equal(csv, x)
})

test_that("sbf_save_table does not save md if option sbf.save_md is FALSE", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())
  withr::local_options(sbf.save_md = FALSE)

  x <- data.frame(x = 1)
  sbf_save_table(x)
  expect_identical(
    list.files(file.path(sbf_get_main(), "tables")),
    sort(c("x.yaml", "x.csv", "x.rds"))
  )
})

test_that("sbf_save_table md does not affect listing or loading tables", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  birds <- data.frame(x = 1.5)
  sbf_save_table(birds)
  sbf_save_table(birds, sub = "sub")
  expect_length(sbf_list_tables(), 1L)
  expect_identical(nrow(sbf_load_tables_recursive()), 2L)
})

test_that("sbf_save_table validates proportion and format_column", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  x <- data.frame(estimate = 0.5, lower = 0.2, upper = 1.2, n = 2.5, chr = "a")
  expect_snapshot(error = TRUE, {
    sbf_save_table(x, proportion = NA)
    sbf_save_table(x, proportion = TRUE)
    sbf_save_table(data.frame(x = 0.5), proportion = TRUE)
    sbf_save_table(x, format_column = 1)
    sbf_save_table(x, format_column = list(~ round(.)))
    sbf_save_table(x, format_column = list(n ~ round(.), n ~ round(.)))
    sbf_save_table(x, format_column = list(lower ~ round(.)))
    sbf_save_table(x, format_column = list(z ~ round(.)))
    sbf_save_table(x, format_column = list(chr ~ round(.)))
    sbf_save_table(x, format_column = list(n ~ 1:2))
  })
  withr::local_options(sbf.save_md = NA)
  expect_snapshot(error = TRUE, sbf_save_table(data.frame(x = 1)))
})

test_that("md_table rounds estimates with sd, CIs and s-values", {
  x <- data.frame(
    term = c("bA", "bB", "sigma", "bC"),
    estimate = c(0.53124, 12.4321, 1234.5, -0.0123456),
    sd = c(0.16123, 1.8, NA, NA),
    lower = c(0.21234, 8.91, 1000.1, NA),
    upper = c(0.87012, 16.02, 1600.2, NA),
    zscore = c(3.21456, 6.9, NA, -1.2),
    svalue = c(6.123, 11.2, NA, 0.04)
  )
  expect_snapshot(writeLines(md_table(x)))
})

test_that("md_table rounds proportions from the nearer of 0 and 1", {
  x <- data.frame(
    estimate = c(0.995, 0.5, 0.0123, 1),
    lower = c(0.97, 0.31, 0.004, 0.9),
    upper = c(0.9991, 0.69, 0.03, 1)
  )
  expect_snapshot({
    writeLines(md_table(x))
    writeLines(md_table(x, proportion = TRUE))
  })
})

test_that("md_table formats data values", {
  x <- data.frame(
    chr = c("a|b", "c\nd", NA, "e"),
    int = c(1L, 2000L, NA, -12345L),
    whole = c(2, 2000000, NA, 3),
    dbl = c(2.5, 12345.678, -0.0001234, Inf),
    lgl = c(TRUE, FALSE, NA, TRUE),
    fct = factor(c("x", "y", NA, "x")),
    date = as.Date("2024-01-01") + c(0:2, NA),
    time = hms::hms(c(0, 60, 3600, NA)),
    dttm = as.POSIXct("2024-01-01 12:00:00", tz = "UTC") + c(0:2, NA)
  )
  expect_snapshot(writeLines(md_table(x)))
})

test_that("md_table applies format_column", {
  x <- data.frame(
    year = 2023:2025,
    zscore = c(3.21456, -6.9, NA),
    w = c(1234567.25, 0.1 + 0.2, 1)
  )
  expect_snapshot(writeLines(md_table(
    x,
    format_column = list(
      year ~ as.character(.),
      zscore ~ round(.x, 1),
      w ~ .
    )
  )))
})

test_that("md_table handles empty tables", {
  expect_identical(md_table(data.frame()), character(0))
  expect_snapshot(writeLines(md_table(data.frame(
    a = numeric(0),
    b = character(0)
  ))))
})

test_that("sbf_load_table_md loads md lines", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  x <- data.frame(x = c(1.5, 12))
  sbf_save_table(x, sub = "sub")
  expect_identical(
    sbf_path_table("x", sub = "sub", ext = "md"),
    file.path(sbf_get_main(), "tables/sub/x.md")
  )
  expect_identical(
    sbf_load_table_md("x", sub = "sub"),
    c("|      x |", "| -----: |", "|  1.500 |", "| 12.00  |")
  )
  expect_identical(
    sbf_load_table_md("x", sub = "sub", entities = TRUE),
    c("|      x |", "| -----: |", "| 1.500 |", "| 12.00&#8199; |")
  )
  expect_null(sbf_load_table_md("y", exists = NA))
  expect_error(sbf_load_table_md("y"), class = "chk_error")
})

test_that("md_entities replaces decimal alignment padding", {
  x <- data.frame(
    chr = c("a|b", "c", NA),
    estimate = c(0.53124, 12.4, NA),
    sd = c(0.16, 1.8, NA),
    int = c(1L, 20000L, NA),
    dbl = c(1, 10, Inf)
  )
  expect_snapshot(writeLines(md_entities(md_table(x))))
  expect_identical(md_entities(character(0)), character(0))
})
