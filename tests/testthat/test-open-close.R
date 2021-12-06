test_that("pdf", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  graphics.off()
  withr::defer(graphics.off())

  expect_identical(dev.cur(), c("null device" = 1L))
  expect_identical(sbf_open_pdf("x"), file.path(sbf_get_main(), "pdfs/x.pdf"))
  expect_identical(dev.cur(), c("pdf" = 2L))
  expect_identical(sbf_close_pdf(), c("null device" = 1L))
  expect_identical(dev.cur(), c("null device" = 1L))
  expect_identical(
    list.files(file.path(sbf_get_main(), "pdfs")),
    sort(c("x.pdf"))
  )
  expect_identical(sbf_open_pdf("x"), file.path(sbf_get_main(), "pdfs/x.pdf"))
  expect_identical(dev.cur(), c("pdf" = 2L))
  expect_identical(sbf_close_pdf(), c("null device" = 1L))
  expect_identical(dev.cur(), c("null device" = 1L))
  expect_identical(
    list.files(file.path(sbf_get_main(), "pdfs")),
    sort(c("x.pdf"))
  )

  expect_identical(sbf_set_sub("sub"), "sub")
  expect_identical(dev.cur(), c("null device" = 1L))
  expect_identical(sbf_open_pdf("x2"), file.path(sbf_get_main(), "pdfs/sub/x2.pdf"))
  expect_identical(dev.cur(), c("pdf" = 2L))
  expect_identical(sbf_close_pdf(), c("null device" = 1L))
  expect_identical(dev.cur(), c("null device" = 1L))
})

test_that("db", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  withr::defer(graphics.off())

  expect_error(sbf_open_db("x"), "^`file` must specify an existing file [(]'.*dbs/x.sqlite' can't be found[)].$", class = "chk_error")

  conn <- sbf_open_db("x", exists = NA)
  withr::defer(suppressWarnings(DBI::dbDisconnect(conn)))
  expect_s4_class(conn, "SQLiteConnection")
  expect_true(sbf_close_db(conn))
  expect_s4_class(conn, "SQLiteConnection")
  expect_warning(sbf_close_db(conn), "Already disconnected")
})
