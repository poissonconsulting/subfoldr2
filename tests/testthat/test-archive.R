test_that("archive",{
  teardown(sbf_reset_main())
  expect_chk_error(sbf_archive_main())
  
  sbf_set_main(tempdir())
  x <- 1
  sbf_save_number(x)
  expect_identical(sbf_load_number("x"), x)
  new_main <- sbf_archive_main(ask = FALSE)
  expect_identical(sbf_load_number("x"), x)
  expect_identical(sbf_load_number("x", main = new_main), x)
  expect_true(grepl("\\d{4,4}(-\\d{2,2}){5,5}$", new_main))
})

test_that("unarchive",{
  sbf_set_main(file.path(tempdir(), "output"))
  sbf_rm_main(ask = FALSE)
  teardown(sbf_rm_main(ask = FALSE))
  
  x <- 1
  sbf_save_number(x)
  new_main1 <- sbf_archive_main(ask = FALSE)
  x <- 2
  sbf_save_number(x)
  Sys.sleep(1L)
  new_main2 <- sbf_archive_main(ask = FALSE)
  x <- 3
  sbf_save_number(x)
  Sys.sleep(1L)
  new_main3 <- sbf_archive_main(ask = FALSE)
  
  expect_identical(sbf_load_number("x"), 3)
  expect_equal(sbf_unarchive_main(number = 3L, ask = FALSE), new_main1)
  expect_identical(sbf_load_number("x"), 1)
  expect_equal(sbf_unarchive_main(ask = FALSE), new_main3)
  expect_identical(sbf_load_number("x"), 3)
  expect_error(sbf_unarchive_main(number = 2L, ask = FALSE))
  expect_equal(sbf_unarchive_main(ask = FALSE), new_main2)
  expect_identical(sbf_load_number("x"), 2)
  expect_error(sbf_unarchive_main(ask = FALSE))
})
