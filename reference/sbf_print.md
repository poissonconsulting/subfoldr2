# Print ggplot Object

Retries printing a ggplot object if grid errors occurs.

## Usage

``` r
sbf_print(
  x,
  newpage = is.null(vp),
  vp = NULL,
  ntry = getOption("sbf.ntry", 3L),
  plot = getOption("sbf.plot", TRUE)
)
```

## Arguments

- x:

  An object to print.

- newpage:

  draw new (empty) page first?

- vp:

  viewport to draw plot in

- ntry:

  A positive whole number specifying the number of tries.

- plot:

  A flag indicating whether or not to print the plot.

## Details

Grid errors include the text "cannot pop the top-level viewport" or "no
applicable method for 'depth'"
