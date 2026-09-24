system2("air", c("format", "."))
styler::style_pkg(filetype = c("Rmd"))
lintr::lint_package(
  linters = lintr::linters_with_defaults(
    line_length_linter = lintr::line_length_linter(1000),
    object_name_linter = lintr::object_name_linter(regexes = ".*")
  )
)

roxygen2md::roxygen2md()
devtools::document()

devtools::build_readme()

pkgdown::build_home()
pkgdown::build_reference()
pkgdown::build_site()
browseURL("docs/index.html")

devtools::test()
devtools::check()
