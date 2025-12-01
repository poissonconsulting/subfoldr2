# Open PDF Device

Opens a pdf device in the current pdfs subfolder using
`grDevices::[pdf][grDevices::pdf]()`.

## Usage

``` r
sbf_open_pdf(
  x_name = "plots",
  sub = sbf_get_sub(),
  main = sbf_get_main(),
  width = 6,
  height = width
)
```

## Arguments

- x_name:

  A string of the name.

- sub:

  A string specifying the path to the sub folder (by default the current
  sub folder).

- main:

  A string specifying the path to the main folder (by default the
  current main folder)

- width:

  A positive number indicating the width in inches.

- height:

  A positive number indicating the height in inches.

## See also

Other graphic functions:
[`sbf_close_pdf()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_close_pdf.md),
[`sbf_close_window()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_close_window.md),
[`sbf_close_windows()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_close_windows.md),
[`sbf_open_window()`](https://poissonconsulting.github.io/subfoldr2/reference/sbf_open_window.md)
