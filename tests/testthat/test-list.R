test_that("object",{
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  teardown(sbf_reset())
  
  x <- 1
  expect_identical(sbf_save_object(x), file.path(sbf_get_main(), "objects/x.rds"))
  
  expect_match(sbf_list_objects("x"), file.path(sbf_get_main(), "objects/x.rds"))
  expect_match(sbf_list_objects("x", full_path = FALSE), "objects/x")
  x <- 3
  expect_identical(sbf_save_object(x, sub = "down"),
                   file.path(sbf_get_main(), "objects/down/x.rds"))

  expect_identical(sbf_list_objects("x", recursive = TRUE),
               c(file.path(sbf_get_main(), "objects/down/x.rds"),
               file.path(sbf_get_main(), "objects/x.rds")))

  expect_identical(sbf_list_objects("x", recursive = TRUE, full_path = FALSE),
                   c("objects/down/x", "objects/x"))
  
  expect_identical(sbf_list_objects("x"),
               file.path(sbf_get_main(), "objects/x.rds"))

  expect_identical(sbf_list_objects("x", full_path = FALSE),
                   "objects/x")
  
  y <- 4
  expect_identical(sbf_save_object(y), file.path(sbf_get_main(), "objects/y.rds"))
  expect_identical(sbf_list_objects("x", recursive = TRUE),
               c(file.path(sbf_get_main(), "objects/down/x.rds"),
               file.path(sbf_get_main(), "objects/x.rds")))

  expect_identical(sbf_list_objects("y"),
               file.path(sbf_get_main(), "objects/y.rds"))

  expect_identical(sbf_list_objects(),
               c(file.path(sbf_get_main(), "objects/x.rds"),
               file.path(sbf_get_main(), "objects/y.rds")))
  
  expect_identical(sbf_list_objects(sub = "down"),
                file.path(sbf_get_main(), "objects/down/x.rds"))

    expect_identical(sbf_list_objects(recursive = TRUE),
               c(file.path(sbf_get_main(), "objects/down/x.rds"),
               file.path(sbf_get_main(), "objects/x.rds"),
               file.path(sbf_get_main(), "objects/y.rds")))
    
    expect_identical(sbf_list_objects(recursive = TRUE, full_path = FALSE),
                     c("objects/down/x",
                       "objects/x",
                       "objects/y"))
  
  expect_identical(sbf_list_objects("down", recursive = TRUE), character(0))
  expect_identical(sbf_list_objects("rds", recursive = TRUE), character(0))
  expect_identical(sbf_list_objects("rds", recursive = TRUE, full_path = TRUE), character(0))
})

test_that("data",{
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  teardown(sbf_reset())
  
  x <- data.frame(x = 1)
  expect_identical(sbf_save_data(x), file.path(sbf_get_main(), "data/x.rds"))
  
  expect_match(sbf_list_datas("x"),
               file.path(sbf_get_main(), "data/x.rds"))
  expect_match(sbf_list_datas("x", full_path = FALSE),
               "data/x")
  x <- data.frame(y = 3)
  expect_identical(sbf_save_data(x, sub = "down"),
                   file.path(sbf_get_main(), "data/down/x.rds"))

  expect_identical(sbf_list_datas("x", recursive = TRUE),
               c(file.path(sbf_get_main(), "data/down/x.rds"),
               file.path(sbf_get_main(), "data/x.rds")))

  expect_identical(sbf_list_datas("x", recursive = TRUE, full_path = FALSE),
                   c("data/down/x",
                     "data/x"))
  
  expect_identical(sbf_list_datas("x", recursive = FALSE),
               file.path(sbf_get_main(), "data/x.rds"))
  
  expect_identical(sbf_list_datas("x", recursive = FALSE, full_path = FALSE),
                   "data/x")
})
