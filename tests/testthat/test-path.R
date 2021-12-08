test_that("path object", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  expect_match(sbf_path_object("x"), ".*/objects/x[.]rds")
  expect_match(sbf_path_object("x", exists = FALSE), ".*/objects/x[.]rds")
  chk::expect_chk_error(
    sbf_path_object("x", exists = TRUE),
    "`x_name` must specify existing files"
  )
})

test_that("path db", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  sbf_open_db("bd", exists = NA)
  expect_match(sbf_path_db("bd"), ".*/dbs/bd[.]sqlite")
  expect_match(sbf_path_db("bd", exists = TRUE), ".*/dbs/bd[.]sqlite")
  chk::expect_chk_error(sbf_path_db("bd", exists = FALSE))
})

test_that("path data", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())
  
  data <- tibble(a = 1)
  sbf_save_data(data)
  expect_match(sbf_path_data("data", exists = TRUE), ".*/data/data[.]rds")
  chk::expect_chk_error(sbf_path_data("data", exists = FALSE))
})

test_that("path number", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  sbf_save_number(1)
  expect_match(sbf_path_number("1", exists = TRUE), ".*/numbers/1[.]rds")
  chk::expect_chk_error(sbf_path_number("1", exists = FALSE))
})

test_that("path string", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())
  
  sbf_save_string("a")
  expect_match(sbf_path_string("a", exists = TRUE), ".*/strings/a[.]rds")
  chk::expect_chk_error(sbf_path_string("a", exists = FALSE))
})

test_that("path block", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())
  
  sbf_save_block("a")
  expect_match(sbf_path_block("a", exists = TRUE), ".*/blocks/a[.]rds")
  chk::expect_chk_error(sbf_path_block("a", exists = FALSE))
})

test_that("path tables", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())
  
  table <- data.frame(a = "a")
  
  sbf_save_table(table)
  expect_match(sbf_path_table("table", exists = TRUE), ".*/tables/table[.]rds")
  chk::expect_chk_error(sbf_path_table("table", exists = FALSE))
})

test_that("path plots", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  
  data <- data.frame(x = 1, y = 2)
  plot <- ggplot2::ggplot(data = data, ggplot2::aes(x = x, y = y))
  subfoldr2::sbf_save_plot(plot)
  
  expect_match(sbf_path_plot("plot", exists = TRUE), ".*/plots/plot[.]rds")
  chk::expect_chk_error(sbf_path_plot("plot", exists = FALSE))

})

test_that("path windows", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))

  png <- system.file("extdata", "example.png",
                      package = "subfoldr2",
                      mustWork = TRUE)
  sbf_save_png(png)
  
  expect_match(sbf_path_window("example", exists = TRUE), ".*/windows/example[.]png")
  chk::expect_chk_error(sbf_path_window("example", exists = FALSE))
  
})
