local_main <- function(env = parent.frame()) {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(.local_envir = env), "output"))
  withr::defer(sbf_reset(), envir = env)
}

exists_regexp <- function(file) {
  paste0(
    "^File '.*",
    file,
    "' already exists and `getOption[(]\"sbf.overwrite\"[)]` is FALSE[.]$"
  )
}

test_that("existing files are replaced by default", {
  local_main()

  x <- 1
  sbf_save_object(x)
  x <- 2
  expect_identical(
    sbf_save_object(x),
    file.path(sbf_get_main(), "objects/x.rds")
  )
  expect_identical(sbf_load_object("x"), 2)

  sbf_save_number(x)
  x <- 3
  sbf_save_number(x)
  expect_identical(sbf_load_number("x"), 3)

  sbf_set_sub("sub")
  sbf_save_object(x)
  expect_identical(sbf_set_sub("sub", rm = TRUE, ask = FALSE), "sub")
  expect_identical(
    list.files(file.path(sbf_get_main(), "objects/sub")),
    character(0)
  )
})

test_that("sbf.overwrite must be a flag", {
  local_main()
  withr::local_options(sbf.overwrite = NA)

  x <- 1
  expect_error(
    sbf_save_object(x),
    "^`getOption[(]\"sbf.overwrite\"[)]` must be a flag [(]TRUE or FALSE[)][.]$",
    class = "chk_error"
  )
})

test_that("first save attempt works when sbf.overwrite is FALSE", {
  local_main()
  withr::local_options(sbf.overwrite = FALSE, sbf.ask = FALSE)

  x <- 1
  y <- "two"
  data <- data.frame(a = 1:2)
  gp <- ggplot2::ggplot(data, ggplot2::aes(x = a, y = a)) +
    ggplot2::geom_point()

  expect_identical(
    sbf_save_object(x),
    file.path(sbf_get_main(), "objects/x.rds")
  )
  expect_identical(
    sbf_save_data(data),
    file.path(sbf_get_main(), "data/data.rds")
  )
  expect_identical(
    sbf_save_number(x),
    file.path(sbf_get_main(), "numbers/x.rds")
  )
  expect_identical(
    sbf_save_string(y),
    file.path(sbf_get_main(), "strings/y.rds")
  )
  expect_identical(
    sbf_save_block(y),
    file.path(sbf_get_main(), "blocks/y.rds")
  )
  expect_identical(
    sbf_save_table(data),
    file.path(sbf_get_main(), "tables/data.rds")
  )
  expect_identical(
    sbf_save_plot(gp, width = 2, dpi = 72),
    file.path(sbf_get_main(), "plots/gp.rds")
  )
  expect_identical(
    sbf_save_excel(data),
    file.path(sbf_get_main(), "excel/data.xlsx")
  )

  expect_identical(sbf_load_object("x"), 1)
  expect_identical(sbf_load_number("x"), 1)
  expect_identical(sbf_load_string("y"), "two")
  expect_identical(sbf_load_block("y"), "two")
  expect_identical(sbf_load_table("data"), data)

  # same name in a different sub folder is not an overwrite
  sbf_set_sub("sub")
  expect_identical(
    sbf_save_object(x),
    file.path(sbf_get_main(), "objects/sub/x.rds")
  )
  expect_identical(sbf_set_sub("empty", rm = TRUE), "empty")
})

test_that("second save attempt errors when sbf.overwrite is FALSE", {
  local_main()
  withr::local_options(sbf.overwrite = FALSE)

  x <- 1
  y <- "two"
  data <- data.frame(a = 1:2)
  gp <- ggplot2::ggplot(data, ggplot2::aes(x = a, y = a)) +
    ggplot2::geom_point()
  png <- system.file(
    "extdata",
    "example.png",
    package = "subfoldr2",
    mustWork = TRUE
  )

  sbf_save_object(x)
  sbf_save_data(data)
  sbf_save_number(x)
  sbf_save_string(y)
  sbf_save_block(y)
  sbf_save_table(data)
  sbf_save_plot(gp, width = 2, dpi = 72)
  sbf_save_excel(data)
  sbf_save_png(png)

  x <- 2
  y <- "three"
  data2 <- data
  data <- data.frame(a = 3:4)

  expect_error(
    sbf_save_object(x),
    exists_regexp("objects/x[.]rds"),
    class = "chk_error"
  )
  expect_error(
    sbf_save_data(data),
    exists_regexp("data/data[.]rds"),
    class = "chk_error"
  )
  expect_error(
    sbf_save_number(x),
    exists_regexp("numbers/x[.]yaml"),
    class = "chk_error"
  )
  expect_error(
    sbf_save_string(y),
    exists_regexp("strings/y[.]yaml"),
    class = "chk_error"
  )
  expect_error(
    sbf_save_block(y),
    exists_regexp("blocks/y[.]yaml"),
    class = "chk_error"
  )
  expect_error(
    sbf_save_table(data),
    exists_regexp("tables/data[.]yaml"),
    class = "chk_error"
  )
  expect_error(
    sbf_save_plot(gp, width = 3, dpi = 72),
    exists_regexp("plots/gp[.]png"),
    class = "chk_error"
  )
  expect_error(
    sbf_save_excel(data),
    exists_regexp("excel/data[.]rds"),
    class = "chk_error"
  )
  expect_error(
    sbf_save_png(png),
    exists_regexp("windows/example[.]png"),
    class = "chk_error"
  )

  expect_error(
    sbf_save_objects(env = as.environment(list(x = x, z = 3))),
    exists_regexp("objects/x[.]rds"),
    class = "chk_error"
  )
  expect_error(
    sbf_save_datas(env = as.environment(list(data = data))),
    exists_regexp("data/data[.]rds"),
    class = "chk_error"
  )
  expect_error(
    sbf_save_numbers(env = as.environment(list(x = x))),
    exists_regexp("numbers/x[.]yaml"),
    class = "chk_error"
  )
  expect_error(
    sbf_save_strings(env = as.environment(list(y = y))),
    exists_regexp("strings/y[.]yaml"),
    class = "chk_error"
  )

  # the first saves are not altered
  expect_identical(sbf_load_object("x"), 1)
  expect_identical(sbf_load_data("data"), data2)
  expect_identical(sbf_load_number("x"), 1)
  expect_identical(sbf_load_string("y"), "two")
  expect_identical(sbf_load_block("y"), "two")
  expect_identical(sbf_load_table("data"), data2)
  expect_identical(
    sbf_load_plots_recursive("gp", meta = TRUE)$width,
    2
  )
})

test_that("second attempt to save window errors when sbf.overwrite is FALSE", {
  local_main()
  withr::local_options(sbf.overwrite = FALSE)

  # sbf_save_window() cannot write a first file without a screen device, so
  # the existing file is created with sbf_save_png() instead
  x <- system.file(
    "extdata",
    "example.png",
    package = "subfoldr2",
    mustWork = TRUE
  )
  sbf_save_png(x)

  graphics.off()
  withr::defer(graphics.off())
  grDevices::pdf(NULL)
  plot(1)
  expect_error(
    sbf_save_window("example"),
    exists_regexp("windows/example[.]png"),
    class = "chk_error"
  )
})

test_that("second pdf errors when sbf.overwrite is FALSE", {
  local_main()
  withr::local_options(sbf.overwrite = FALSE)

  graphics.off()
  withr::defer(graphics.off())

  expect_identical(sbf_open_pdf("x"), file.path(sbf_get_main(), "pdfs/x.pdf"))
  sbf_close_pdf()
  expect_error(
    sbf_open_pdf("x"),
    exists_regexp("pdfs/x[.]pdf"),
    class = "chk_error"
  )
  expect_identical(dev.cur(), c("null device" = 1L))
})

test_that("databases can be reopened and written when sbf.overwrite is FALSE", {
  local_main()
  withr::local_options(sbf.overwrite = FALSE)

  conn <- sbf_open_db(exists = NA)
  DBI::dbExecute(conn, "CREATE TABLE x (a INTEGER)")
  sbf_close_db(conn)

  x <- data.frame(a = 1L)
  expect_identical(
    sbf_save_data_to_db(x, silent = TRUE),
    file.path(sbf_get_main(), "dbs/database.sqlite")
  )
  expect_identical(
    sbf_save_data_to_db(x, silent = TRUE),
    file.path(sbf_get_main(), "dbs/database.sqlite")
  )
})

test_that("rm = TRUE with ask = FALSE errors on a folder with files when sbf.overwrite is FALSE", {
  local_main()
  withr::local_options(sbf.overwrite = FALSE, sbf.ask = FALSE)

  x <- 1
  sbf_set_sub("sub")
  sbf_save_object(x)

  expect_error(
    sbf_set_sub("sub", rm = TRUE),
    "^Directory '.*objects/sub' contains files and `getOption[(]\"sbf.overwrite\"[)]` is FALSE[.]$",
    class = "chk_error"
  )
  expect_error(
    sbf_reset_sub(rm = TRUE),
    "^Directory '.*output' contains files and `getOption[(]\"sbf.overwrite\"[)]` is FALSE[.]$",
    class = "chk_error"
  )
  expect_error(
    sbf_set_main(sbf_get_main(), rm = TRUE),
    "^Directory '.*output' contains files and `getOption[(]\"sbf.overwrite\"[)]` is FALSE[.]$",
    class = "chk_error"
  )
  expect_identical(sbf_load_object("x", sub = "sub"), 1)

  expect_identical(sbf_set_sub("sub2", rm = TRUE), "sub2")
})

test_that("rm = TRUE with ask = TRUE deletes a folder with files when confirmed and sbf.overwrite is FALSE", {
  local_main()
  withr::local_options(sbf.overwrite = FALSE, usethis.quiet = TRUE)
  local_mocked_bindings(yesno = function(...) TRUE)

  x <- 1
  sbf_set_sub("sub")
  sbf_save_object(x)

  expect_identical(sbf_set_sub("sub", rm = TRUE, ask = TRUE), "sub")
  expect_identical(
    list.files(file.path(sbf_get_main(), "objects/sub")),
    character(0)
  )

  sbf_save_object(x)
  expect_identical(sbf_reset_sub(rm = TRUE, ask = TRUE), character(0))
  expect_false(dir.exists(sbf_get_main()))
})
