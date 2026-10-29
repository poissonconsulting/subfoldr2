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

test_that("sbf_save_table deletes old md if option sbf.save_md is FALSE", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  x <- data.frame(x = 1)
  sbf_save_table(x)
  expect_true(file.exists(file.path(sbf_get_main(), "tables", "x.md")))
  withr::with_options(list(sbf.save_md = FALSE), sbf_save_table(x))
  expect_false(file.exists(file.path(sbf_get_main(), "tables", "x.md")))
})

test_that("sbf_save_table does not use thousands separators in no_big_mark", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  counts <- data.frame(year = c(2024L, 2025L), count = c(1500L, 980L))
  sbf_save_table(counts, no_big_mark = "year")
  expect_identical(
    sbf_load_table_md("counts"),
    c(
      "| year | count |",
      "| ---: | ----: |",
      "| 2024 | 1,500 |",
      "| 2025 |   980 |"
    )
  )
  expect_snapshot(sbf_save_table(counts, no_big_mark = "yr"), error = TRUE)
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
    sbf_save_table(data.frame(estimate = 0.5, sd = 0.8), proportion = TRUE)
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

test_that("proportion sd can be up to sd(c(0, 1))", {
  x <- data.frame(estimate = 0.5, sd = c(0, sd(c(0, 1)), NA))
  expect_identical(chk_proportion_cols(x), x)
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
    c("|    x |", "| ---: |", "|  1.5 |", "| 12   |")
  )
  expect_identical(
    sbf_load_table_md("x", sub = "sub", entities = TRUE),
    c("|    x |", "| ---: |", "| 1.5 |", "| 12&#8200;&#8199; |")
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

test_that("format_data keeps only significant trailing zeros", {
  expect_identical(
    format_data(c(0.5, 0.48, 160, 1.0001, 12.3049, 0.1 + 0.2, 12345.678, NA)),
    c("0.5", "0.48", "160", "1.000", "12.30", "0.3", "12,350", "")
  )
  expect_identical(format_data(c(1L, 20000L)), c("1", "20,000"))
})

test_that("thousands separators are used for numbers of 1000 or more", {
  expect_identical(
    format_data(c(11615L, 1595L, 9640L, 999L)),
    c("11,615", "1,595", "9,640", "999")
  )
  expect_identical(format_data(c(9640, -1595, 999)), c("9,640", "-1,595", "999"))
  expect_identical(format_data(c(2024L, 2025L)), c("2,024", "2,025"))

  x <- data.frame(
    year = c(2024L, 2025L),
    estimate = c(9500, 12000),
    lower = c(8000, 9000),
    upper = c(11000, 16000)
  )
  expect_snapshot(writeLines(md_table(x)))
})

test_that("no_big_mark columns do not have thousands separators", {
  x <- data.frame(
    year = c(2024L, 2025L),
    yr = c(2024, 2025.5),
    count = c(1500L, 20000L),
    length = c(1234.5, 12.5),
    estimate = c(9500, 12000),
    lower = c(8000, 9000),
    upper = c(11000, 16000)
  )
  md <- sbf_as_md(
    x,
    round = TRUE,
    format_column = list(length ~ round(., 0)),
    no_big_mark = c("year", "yr", "length", "estimate")
  )
  expect_snapshot(writeLines(md))
  expect_identical(
    sbf_as_md(x["year"], no_big_mark = "year"),
    c("| year |", "| ---: |", "| 2024 |", "| 2025 |")
  )
  expect_identical(
    sbf_as_md(x["year"]),
    c("|  year |", "| ----: |", "| 2,024 |", "| 2,025 |")
  )
  # character values returned by format_column are used as is
  expect_identical(
    sbf_as_md(
      x["length"],
      round = TRUE,
      format_column = list(length ~ format(., big.mark = ",")),
      no_big_mark = "length"
    )[3],
    "| 1,234.5 |"
  )
})

test_that("no_big_mark columns must be numeric columns in x", {
  x <- data.frame(year = 2024L, site = "a")
  expect_snapshot(sbf_as_md(x, no_big_mark = "yr"), error = TRUE)
  expect_snapshot(sbf_as_md(x, no_big_mark = "site"), error = TRUE)
  expect_snapshot(sbf_as_md(x, no_big_mark = NA_character_), error = TRUE)
})

test_that("rounding up to a power of ten drops the extra decimal place", {
  # estimate -0.20 has 2 dp, so its upper CL of 0.997 rounds to 1.0 not 1.00
  x <- data.frame(estimate = -0.2, lower = -0.7, upper = 0.997, sd = 0.3)
  expect_identical(format_estimates(x, proportion = FALSE)$upper, "1.0")
  expect_identical(cl_dp(c(0.997, 0.5), c(2, 2), FALSE), c(1, 2))

  # three significant digits without CLs
  expect_identical(signif_dp(c(9.996, 9.94, 99.96), 3), c(1, 2, 0))
  expect_identical(format_data(9.9996), "10.00")

  # a proportion is never rounded to 1
  expect_identical(signif_dp(0.99996, 2, proportion = TRUE), 6)
  expect_identical(signif_dp(0.999996, 2, proportion = TRUE), 7)
})

test_that("round_as_estimate rounds columns to the precision of the estimate", {
  x <- data.frame(
    moment = c("mean", "variance", "skewness", "none"),
    observed = c(0.035721, 0.851812, -0.084993, 12.3456),
    estimate = c(-0.003744, 0.984321, -0.010281, NA),
    lower = c(-0.2419, 0.6597, -0.6116, NA),
    upper = c(0.2577, 1.366, 0.6234, NA),
    svalue = c(0.4, 1.1, 0.3, NA)
  )
  md <- format_estimates(x, proportion = FALSE, round_as_estimate = "observed")
  expect_identical(md$estimate[1:3], c("0.00", "0.98", "-0.01"))
  expect_identical(md$observed, c("0.04", "0.85", "-0.08", "12.35"))

  # rounded from the sd, or to three significant digits without limits
  y <- data.frame(
    observed = c(1234.5, 0.21),
    estimate = c(1180, 0.2),
    sd = c(35, NA)
  )
  md <- format_estimates(y, proportion = FALSE, round_as_estimate = "observed")
  expect_identical(md$estimate, c("1,180", "0.200"))
  expect_identical(md$observed, c("1,234", "0.210"))

  expect_snapshot(writeLines(md_table(x, round_as_estimate = "observed")))
})

test_that("sbf_save_table saves round_as_estimate rounding in md", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  x <- data.frame(
    observed = 0.035721,
    estimate = -0.003744,
    lower = -0.2419,
    upper = 0.2577
  )
  sbf_save_table(x, round_as_estimate = "observed")
  md <- sbf_load_table_md("x")
  expect_match(md[3], "0.04", fixed = TRUE)
  expect_identical(sbf_load_table("x")$observed, 0.035721)
})

test_that("sbf_save_table validates round_as_estimate", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  x <- data.frame(estimate = 0.5, lower = 0.2, upper = 0.9, n = 2.5, chr = "a")
  expect_snapshot(error = TRUE, {
    sbf_save_table(x, round_as_estimate = 1)
    sbf_save_table(x, round_as_estimate = c("n", "n"))
    sbf_save_table(x, round_as_estimate = NA_character_)
    sbf_save_table(x, round_as_estimate = "lower")
    sbf_save_table(x, round_as_estimate = "z")
    sbf_save_table(x, round_as_estimate = "chr")
    sbf_save_table(
      x,
      round_as_estimate = "n",
      format_column = list(n ~ round(.))
    )
    sbf_save_table(data.frame(n = 1), round_as_estimate = "n")
    sbf_save_table(x, round_as_estimate = "n", proportion = TRUE)
  })
})

test_that("sbf_save_plot saves md of the rounded ggplot data", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  data <- data.frame(
    year = 2019:2021,
    estimate = c(0.53124, 0.6, 0.72),
    lower = c(0.21234, 0.3, 0.4),
    upper = c(0.87012, 0.9, 0.95),
    length = c(1.23456, 12.3456, 123.456)
  )
  x <- ggplot2::ggplot(data, ggplot2::aes(year, estimate)) +
    ggplot2::geom_point()
  sbf_save_plot(
    x,
    format_column = list(length ~ round(., 1)),
    no_big_mark = "year"
  )
  expect_snapshot(writeLines(sbf_load_plot_md("x")))
  expect_identical(sbf_load_plot("x")@data, data)
  expect_equal(read.csv(file.path(sbf_get_main(), "plots", "x.csv")), data)
  expect_identical(
    sbf_path_plot("x", ext = "md"),
    file.path(sbf_get_main(), "plots/x.md")
  )
  expect_length(sbf_list_plots(), 1L)
})

test_that("sbf_save_plot md has no rows if data exceeds csv row limit", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  x <- ggplot2::ggplot(data.frame(estimate = c(0.5, 0.7), n = 1:2))
  sbf_save_plot(x, csv = 1L)
  expect_identical(
    sbf_load_plot_md("x"),
    c("| estimate |   n |", "| -------: | --: |")
  )
})

test_that("sbf_save_plot ignores format_column for uninformative columns", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  x <- ggplot2::ggplot(data.frame(x = c(1.5, 2.5), n = 1.5))
  sbf_save_plot(x, format_column = list(n ~ round(.)))
  expect_identical(
    sbf_load_plot_md("x"),
    c("|   x |", "| --: |", "| 1.5 |", "| 2.5 |")
  )
})

test_that("sbf_save_plot saves no md if no ggplot data or option FALSE", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  sbf_save_plot(ggplot2::ggplot(), x_name = "none", proportion = TRUE)
  expect_null(sbf_load_plot_md("none", exists = NA))

  withr::local_options(sbf.save_md = FALSE)
  sbf_save_plot(ggplot2::ggplot(data.frame(x = 1:2)), x_name = "off")
  expect_null(sbf_load_plot_md("off", exists = NA))
})

test_that("sbf_save_table drop_sd rounds by sd and drops it from md", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  x <- data.frame(estimate = 1.23456, lower = 0.5, upper = 2.5, sd = 0.0123)
  sbf_save_table(x, drop_sd = TRUE)
  expect_snapshot(writeLines(sbf_load_table_md("x")))
  expect_identical(sbf_load_table("x"), x)

  expect_snapshot(error = TRUE, {
    sbf_save_table(x, drop_sd = NA)
    sbf_save_table(x["estimate"], drop_sd = TRUE)
  })
})

test_that("sbf_save_plot drop_sd rounds by sd and drops it from md", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  x <- data.frame(estimate = c(1.23456, 2.34567), sd = 0.0123)
  sbf_save_plot(ggplot2::ggplot(x), x_name = "p", drop_sd = TRUE)
  expect_snapshot(writeLines(sbf_load_plot_md("p")))

  expect_snapshot(error = TRUE, {
    sbf_save_plot(ggplot2::ggplot(x["estimate"]), drop_sd = TRUE)
    sbf_save_plot(ggplot2::ggplot(), drop_sd = TRUE)
  })
})

test_that("sbf_save_plot deletes old md if no ggplot data or option FALSE", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  sbf_save_plot(ggplot2::ggplot(data.frame(x = 1:2)), x_name = "p")
  expect_type(sbf_load_plot_md("p"), "character")
  sbf_save_plot(ggplot2::ggplot(), x_name = "p")
  expect_null(sbf_load_plot_md("p", exists = NA))

  sbf_save_plot(ggplot2::ggplot(data.frame(x = 1:2)), x_name = "p")
  withr::with_options(
    list(sbf.save_md = FALSE),
    sbf_save_plot(ggplot2::ggplot(data.frame(x = 1:2)), x_name = "p")
  )
  expect_null(sbf_load_plot_md("p", exists = NA))
})

test_that("sbf_save_plot validates proportion and format_column before saving", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  data <- data.frame(estimate = c(0.5, 1.5), n = c(2.5, 3.5))
  x <- ggplot2::ggplot(data)
  expect_snapshot(error = TRUE, {
    sbf_save_plot(x, proportion = NA)
    sbf_save_plot(x, proportion = TRUE)
    sbf_save_plot(x, csv = 1L, format_column = list(z ~ round(.)))
    sbf_save_plot(x, round_as_estimate = "z")
    sbf_save_plot(ggplot2::ggplot(), format_column = list(n ~ round(.)))
  })
  expect_false(dir.exists(file.path(sbf_get_main(), "plots")))
})

test_that("md_table rounds numeric columns with classes such as units", {
  x <- data.frame(length = units::set_units(c(1.234567, 2.5), m))
  expect_identical(
    md_table(x),
    c("| length |", "| -----: |", "|  1.235 |", "|  2.5   |")
  )
})
