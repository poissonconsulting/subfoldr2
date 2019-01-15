context("open-close")

test_that("pdf",{
  teardown(sbf_reset_sub(rm = TRUE, ask = FALSE))
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))
  graphics.off()
  teardown(graphics.off())
  
  sbf_set_main(tempdir())
  expect_identical(dev.cur(), c("null device" = 1L))
  expect_error(sbf_open_pdf(), "argument \"x_name\" is missing, with no default")
  expect_identical(sbf_open_pdf("x"), sub("//", "/", file.path(sbf_get_main(), "pdfs/x.pdf")))
  expect_identical(dev.cur(), c("pdf" = 2L))
  expect_identical(sbf_close_pdf(), c("null device" = 1L))
  expect_identical(dev.cur(), c("null device" = 1L))
  expect_identical(list.files(file.path(sbf_get_main(), "pdfs")),
                   sort(c("x.pdf")))
  expect_identical(sbf_open_pdf("x"), sub("//", "/", file.path(sbf_get_main(), "pdfs/x.pdf")))
  expect_identical(dev.cur(), c("pdf" = 2L))
  expect_identical(sbf_close_pdf(), c("null device" = 1L))
  expect_identical(dev.cur(), c("null device" = 1L))
  expect_identical(list.files(file.path(sbf_get_main(), "pdfs")),
                   sort(c("x.pdf")))

  expect_identical(sbf_set_sub("sub"), "sub")
  expect_identical(dev.cur(), c("null device" = 1L))
  expect_identical(sbf_open_pdf("x2"), sub("//", "/", file.path(sbf_get_main(), "pdfs/sub/x2.pdf")))
  expect_identical(dev.cur(), c("pdf" = 2L))
  expect_identical(sbf_close_pdf(), c("null device" = 1L))
  expect_identical(dev.cur(), c("null device" = 1L))
})

test_that("db",{
  teardown(sbf_reset_sub(rm = TRUE, ask = FALSE))
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))
  teardown(graphics.off())
  
  sbf_set_main(tempdir())  
  expect_error(sbf_open_db(), "argument \"x_name\" is missing, with no default")
  expect_error(sbf_open_db("x"), 
               paste0("file '", sub("//", "/", file.path(sbf_get_main(), "dbs/x.sqlite")), "' doesn't exist"))

  conn <- sbf_open_db("x", exists = NA)
  teardown(suppressWarnings(DBI::dbDisconnect(conn)))
  expect_is(conn, "SQLiteConnection")
  expect_true(sbf_close_db(conn))
  expect_is(conn, "SQLiteConnection")
  expect_warning(sbf_close_db(conn), "Already disconnected")
})
