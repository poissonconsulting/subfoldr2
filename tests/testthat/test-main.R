test_that("main",{
  teardown(sbf_reset_main())
  expect_identical(sbf_reset_main(), "output")
  expect_identical(sbf_get_main(), "output")
  expect_identical(sbf_set_main("output2"), "output2")
  expect_identical(sbf_get_main(), "output2")
  expect_identical(sbf_set_main("/"), "/")
  expect_identical(sbf_reset_main(), "output")
  expect_identical(sbf_get_main(), "output")
  expect_identical(sbf_set_main(), character(0))
})

test_that("main not change sub",{
  teardown(sbf_reset())
  sbf_reset()
  sbf_set_sub("sub/sub2")
  expect_identical(sbf_get_sub(), "sub/sub2")
  expect_identical(sbf_set_main("output2"), "output2")
  expect_identical(sbf_get_sub(), "sub/sub2")
})

test_that("rm_main",{
  teardown(sbf_reset())
  sbf_set_main(tempdir())
  
  x <- 1
  sbf_save_number(x)
  expect_true(dir.exists(tempdir()))
  expect_identical(basename(sbf_rm_main(ask = FALSE)), basename(tempdir()))
  expect_false(dir.exists(tempdir()))
})
