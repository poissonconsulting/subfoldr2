test_that("archive", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  teardown(sbf_reset())

  expect_chk_error(sbf_archive_main(ask = FALSE))

  x <- 1
  sbf_save_number(x)
  expect_identical(sbf_load_number("x"), x)
  new_main <- sbf_archive_main(ask = FALSE)
  expect_identical(sbf_load_number("x"), x)
  expect_identical(sbf_load_number("x", main = new_main), x)
  expect_true(grepl("\\d{4,4}(-\\d{2,2}){5,5}$", new_main))
})

test_that("get_archive", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  teardown(sbf_reset())

  x <- 1
  sbf_save_number(x)
  new_main1 <- sbf_archive_main(ask = FALSE)
  x <- 2
  sbf_save_number(x)
  new_main2 <- sbf_archive_main(ask = FALSE)

  expect_equal(sbf_get_archive(archive = 2L), new_main1)
  expect_equal(sbf_get_archive(archive = 1L), new_main2)
  expect_error(sbf_get_archive(archive = 3L))
})

test_that("unarchive", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  teardown(sbf_reset())

  x <- 1
  sbf_save_number(x)
  archive1 <- sbf_archive_main(ask = FALSE)
  x <- 2
  sbf_save_number(x)
  archive2 <- sbf_archive_main(ask = FALSE)
  x <- 3
  sbf_save_number(x)
  archive3 <- sbf_archive_main(ask = FALSE)

  expect_identical(sbf_load_number("x"), 3)
  expect_equal(sbf_unarchive_main(archive = archive1, ask = FALSE), archive1)
  expect_identical(sbf_load_number("x"), 1)
  expect_equal(sbf_unarchive_main(ask = FALSE), archive3)
  expect_identical(sbf_load_number("x"), 3)
  expect_error(sbf_unarchive_main(archive = 2L, ask = FALSE))
  expect_equal(sbf_unarchive_main(ask = FALSE), archive2)
  expect_identical(sbf_load_number("x"), 2)
  expect_error(sbf_unarchive_main(ask = FALSE))
})
