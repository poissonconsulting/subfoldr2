strip_spaces <- function(x) {
  x <- gsub(intToUtf8(0x2007), "", x, fixed = TRUE)
  gsub(intToUtf8(0x2008), "", x, fixed = TRUE)
}

test_that("format_report_table() rounds estimates and CLs from the CI", {
  x <- data.frame(
    estimate = c(62.57, 62.57, 62.57, 1000.4, 0.0687),
    lower = c(40.31, 55.12, 61.92, 998.2, -27.1),
    upper = c(110.4, 70.93, 63.41, 1002.7, 41.2)
  )
  table <- format_report_table(x)$table
  expect_identical(table$estimate, c("63", "62.6", "62.57", "1,000.4", "0"))
  expect_identical(table$lower, c("40", "55", "61.9", "998", "-27"))
  expect_identical(table$upper, c("110", "71", "63.4", "1,003", "41"))
})

test_that("format_report_table() uses the sd column when present", {
  x <- data.frame(estimate = 62.57, lower = 40.31, upper = 110.4, sd = 9)
  table <- format_report_table(x)$table
  expect_identical(table$estimate, "62.6")
  expect_identical(table$lower, "40")
  expect_identical(table$upper, "110")
  expect_identical(table$sd, "9.0")
})

test_that("format_report_table() handles prefixed estimates and proportions", {
  x <- data.frame(
    efficiency_estimate = c(0.9634, 0.9951),
    efficiency_lower = c(0.9012, 0.9702),
    efficiency_upper = c(0.9921, 0.99951)
  )
  table <- format_report_table(x, proportion = TRUE)$table
  expect_identical(table$efficiency_estimate, c("0.963", "0.9951"))
  expect_identical(table$efficiency_lower, c("0.901", "0.970"))
  expect_identical(table$efficiency_upper, c("0.9921", "0.99951"))
})

test_that("format_report_table() formats estimates without CLs, s-values and other columns", {
  x <- data.frame(
    year = c(2013L, 2014L),
    estimate = c(1979.6, 0.0012345),
    svalue = c(10.234, 3.21),
    ratio = c(1 / 3, 10.123456),
    n = c(12, 1500),
    term = c("a", "b")
  )
  table <- format_report_table(x)$table
  expect_identical(table$year, c("2013", "2014"))
  expect_identical(table$estimate, c("1,980", "0.00123"))
  expect_identical(table$svalue, c("10.2", "3.2"))
  expect_identical(table$ratio, c("0.333", "10.1"))
  expect_identical(table$n, c("12", "1500"))
  expect_identical(table$term, c("a", "b"))
})

test_that("align_decimal() aligns on the decimal point without adding zeros", {
  aligned <- align_decimal(c("63", "1,000.4", "0.25", NA))
  expect_identical(strip_spaces(aligned), c("63", "1,000.4", "0.25", NA))
  expect_identical(length(unique(nchar(aligned[1:3]))), 1L)
  expect_false(any(grepl("0$", aligned[1])))
})

test_that("sbf_save_table() saves unrounded rds and csv and a rounded md", {
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  x <- data.frame(
    term = c("a", "b"),
    estimate = c(62.57, 6489.89),
    lower = c(40.31, 4188.08),
    upper = c(110.4, 10971.1)
  )
  sbf_save_table(x)
  expect_identical(sbf_load_table("x"), x)
  csv <- readr::read_csv(
    file.path(sbf_get_main(), "tables/x.csv"),
    show_col_types = FALSE
  )
  expect_equal(csv$estimate, x$estimate)
  md <- readLines(file.path(sbf_get_main(), "tables/x.md"), encoding = "UTF-8")
  expect_identical(
    md[1:2],
    c("| term | estimate | lower | upper |", "|:---|---:|---:|---:|")
  )
  expect_identical(
    strip_spaces(md[3:4]),
    c("| a | 63 | 40 | 110 |", "| b | 6,500 | 4,200 | 11,000 |")
  )
})

test_that("sbf_save_table() errors on percentages with proportion = TRUE", {
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  x <- data.frame(estimate = 96.3, lower = 90.1, upper = 99.2)
  expect_error(
    sbf_save_table(x, proportion = TRUE),
    "convert percentages to proportions"
  )
  expect_error(sbf_save_table(x, proportion = "yes"), class = "chk_error")
})
