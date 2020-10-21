test_that("archive",{
  teardown(sbf_reset_main())
  expect_chk_error(sbf_archive_main())
  
  sbf_set_main(tempdir())
  x <- 1
  sbf_save_number(x)
  expect_identical(sbf_load_number("x"), x)
  new_main <- sbf_archive_main(ask = FALSE)
  expect_error(sbf_load_number("x"))
  expect_identical(sbf_load_number("x", main = new_main), x)
  expect_true(grepl("\\d{4,4}(-\\d{2,2}){5,5}$", new_main))
})
