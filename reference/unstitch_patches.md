# Unstitch patches

Separates patches from a multi-panel plot created via `{patchwork}` into
a list of the individual plots.

## Usage

``` r
unstitch_patches(x)
```

## Arguments

- x:

  An object of class `"ggplot"` and generally also `"patchwork"`.

## Details

Iteratively splits `patchwork` objects into smaller elements until a
list of simple `ggplot` plots is created. If `x` is a `ggplot` object
but not a `patchwork` object, it is simply returned.

## Examples

``` r
p <- ggplot2::ggplot() + ggplot2::ggtitle("1")
# combine into a patchwork then split it back into its individual plots
if (requireNamespace("patchwork", quietly = TRUE)) {
  pw <- patchwork::wrap_plots(p, p)
  length(subfoldr2:::unstitch_patches(pw))
}
#> [1] 2
```
