test_that("compare",{
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  teardown(sbf_reset())
  
  x <- data.frame(x = 1)
  expect_is(sbf_save_data(x), "character")
  expect_identical(sbf_load_data("x"), x)
  
  expect_is(sbf_compare_data(x), "waldo_compare")
  expect_identical(as.character(sbf_compare_data(x)), character(0))
  
  x <- data.frame(x = 1.00001)
  
  expect_is(sbf_compare_data(x, "x"), "waldo_compare")
  
  skip_on_ci()
  
  expect_identical(as.character(sbf_compare_data(x, "x")), "  `saved[[1]]`: \033[32m1.00000\033[39m\n`current[[1]]`: \033[32m1.00001\033[39m")
})


test_that("compare_datas", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  teardown(sbf_reset())
  
  x <- data.frame(x = 1)
  sbf_save_data(x)
  y <- data.frame(x = 2.000001)
  sbf_save_data(y)
  
  archive1 <- sbf_archive_main(ask = FALSE)
  
  expect_identical(sbf_compare_datas(), 
                   list(`data/x` = structure(character(0), class = "waldo_compare"), 
                        `data/y` = structure(character(0), class = "waldo_compare")))
  
  expect_identical(sbf_compare_datas("x"), 
                   list(`data/x` = structure(character(0), class = "waldo_compare")))

  expect_identical(sbf_compare_datas("z"), 
                   structure(list(), .Names = character(0)))

  sbf_rm_main(ask = FALSE)
  
  skip_on_ci()
  
  expect_identical(sbf_compare_datas(), list(`data/x` = structure("`main` is \033[32mNULL\033[39m\n`archive` is \033[32man S3 object of class <data.frame>\033[39m", class = "waldo_compare"), 
                                             `data/y` = structure("`main` is \033[32mNULL\033[39m\n`archive` is \033[32man S3 object of class <data.frame>\033[39m", class = "waldo_compare")))

  sbf_save_data(x, "z")
  expect_identical(sbf_compare_datas(), list(`data/x` = structure("`main` is \033[32mNULL\033[39m\n`archive` is \033[32man S3 object of class <data.frame>\033[39m", class = "waldo_compare"), 
                                             `data/y` = structure("`main` is \033[32mNULL\033[39m\n`archive` is \033[32man S3 object of class <data.frame>\033[39m", class = "waldo_compare"), 
                                             `data/z` = structure("`main` is \033[32man S3 object of class <data.frame>\033[39m\n`archive` is \033[32mNULL\033[39m", class = "waldo_compare")))
})

test_that("compare_datas", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  teardown(sbf_reset())
  
  x <- data.frame(x = 1)
  sbf_save_data(x)
  archive1 <- sbf_archive_main(ask = FALSE)
  
  x <- data.frame(x = 1.00001)
  sbf_save_data(x)
  archive2 <- sbf_archive_main(ask = FALSE)
  
  expect_identical(sbf_compare_datas(main = archive1, archive = archive2, tolerance = 0.1), 
                   list(`data/x` = structure(character(0), class = "waldo_compare")))
  skip_on_ci()
  
  expect_identical(sbf_compare_datas(main = archive1, archive = archive2), 
                   list(`data/x` = structure("   `main[[1]]`: \033[32m1.00000\033[39m\n`archive[[1]]`: \033[32m1.00001\033[39m", class = "waldo_compare")))
})
