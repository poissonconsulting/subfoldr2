test_that("sbf_print", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  teardown(sbf_reset())
  
  setup(pdf(NULL))
  teardown(dev.off())
  
  data <- data.frame(x = 1)
  gp <- ggplot2::ggplot(data = data, ggplot2::aes(x = x, y = y)) + ggplot2::geom_point()
  expect_error(sbf_print(gp), "^ object 'y' not found\n$")
  data$y <- 1
  gp <- ggplot2::ggplot(data = data, ggplot2::aes(x = x, y = y)) + ggplot2::geom_point()
  expect_identical(sbf_print(gp), gp)
})  