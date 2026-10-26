# sbf_save_table validates proportion and format_column

    Code
      sbf_save_table(x, proportion = NA)
    Condition
      Error in `sbf_save_table()`:
      ! `proportion` must be a flag (TRUE or FALSE).
    Code
      sbf_save_table(x, proportion = TRUE)
    Condition
      Error in `sbf_save_table()`:
      ! Columns 'estimate', 'lower' and 'upper' in `x` must be proportions between 0 and 1 when `proportion = TRUE`.
    Code
      sbf_save_table(data.frame(x = 0.5), proportion = TRUE)
    Condition
      Error in `sbf_save_table()`:
      ! `x` must have a numeric column 'estimate' when `proportion = TRUE`.
    Code
      sbf_save_table(x, format_column = 1)
    Condition
      Error in `sbf_save_table()`:
      ! `format_column` must be a list.
    Code
      sbf_save_table(x, format_column = list(~ round(.)))
    Condition
      Error in `sbf_save_table()`:
      ! `format_column` must be a list of two-sided formulas of the form `column ~ fun(.)`.
    Code
      sbf_save_table(x, format_column = list(n ~ round(.), n ~ round(.)))
    Condition
      Error in `sbf_save_table()`:
      ! `format_column` must not include duplicate columns.
    Code
      sbf_save_table(x, format_column = list(lower ~ round(.)))
    Condition
      Error in `sbf_save_table()`:
      ! `format_column` must not include the following columns: 'lower'.
    Code
      sbf_save_table(x, format_column = list(z ~ round(.)))
    Condition
      Error in `sbf_save_table()`:
      ! `format_column` columns must be in `x`: 'z' not found.
    Code
      sbf_save_table(x, format_column = list(chr ~ round(.)))
    Condition
      Error in `sbf_save_table()`:
      ! `format_column` columns must be numeric: 'chr'.
    Code
      sbf_save_table(x, format_column = list(n ~ 1:2))
    Condition
      Error in `sbf_save_table()`:
      ! `format_column` function for column 'n' must return a vector of the same length as the column.

---

    Code
      sbf_save_table(data.frame(x = 1))
    Condition
      Error in `sbf_save_table()`:
      ! `getOption("sbf.save_md")` must be a flag (TRUE or FALSE).

# md_table rounds estimates with sd, CIs and s-values

    Code
      writeLines(md_table(x))
    Output
      | term  |  estimate |   sd |   lower |   upper | zscore | svalue |
      | :---- | --------: | ---: | ------: | ------: | -----: | -----: |
      | bA    |    0.53   | 0.16 |    0.21 |    0.87 |  3.215 |    6.1 |
      | bB    |   12.4    | 1.8  |    8.9  |   16    |  6.900 |   11.2 |
      | sigma | 1230      |      | 1000    | 1600    |        |        |
      | bC    |   -0.0123 |      |         |         | -1.200 |    0.0 |

# md_table rounds proportions from the nearer of 0 and 1

    Code
      writeLines(md_table(x))
    Output
      | estimate |  lower | upper |
      | -------: | -----: | ----: |
      |   0.9950 | 0.970  | 0.999 |
      |   0.500  | 0.31   | 0.69  |
      |   0.0123 | 0.0040 | 0.030 |
      |   1.000  | 0.90   | 1.00  |
    Code
      writeLines(md_table(x, proportion = TRUE))
    Output
      | estimate |  lower |   upper |
      | -------: | -----: | ------: |
      |   0.9950 | 0.970  | 0.99910 |
      |   0.500  | 0.31   | 0.69    |
      |   0.0123 | 0.0040 | 0.030   |
      |   1.000  | 0.90   | 1.00    |

# md_table formats data values

    Code
      writeLines(md_table(x))
    Output
      | chr  |     int |         whole |            dbl | lgl   | fct | date       | time     | dttm                |
      | :--- | ------: | ------------: | -------------: | :---- | :-- | :--------- | :------- | :------------------ |
      | a\|b |       1 |         2.000 |      2.500     | TRUE  | x   | 2024-01-01 | 00:00:00 | 2024-01-01 12:00:00 |
      | c d  |    2000 | 2,000,000     | 12,350         | FALSE | y   | 2024-01-02 | 00:01:00 | 2024-01-01 12:00:01 |
      |      |         |               |     -0.0001234 |       |     | 2024-01-03 | 01:00:00 | 2024-01-01 12:00:02 |
      | e    | -12,345 |         3.000 |    Inf         | TRUE  | x   |            |          |                     |

# md_table applies format_column

    Code
      writeLines(md_table(x, format_column = list(year ~ as.character(.), zscore ~
        round(.x, 1), w ~ .)))
    Output
      | year | zscore |            w |
      | ---: | -----: | -----------: |
      | 2023 |    3.2 | 1,234,567.25 |
      | 2024 |   -6.9 |         0.3  |
      | 2025 |        |         1    |

# md_table handles empty tables

    Code
      writeLines(md_table(data.frame(a = numeric(0), b = character(0))))
    Output
      |   a | b   |
      | --: | :-- |

# md_entities replaces decimal alignment padding

    Code
      writeLines(md_entities(md_table(x)))
    Output
      | chr  | estimate |   sd |    int |     dbl |
      | :--- | -------: | ---: | -----: | ------: |
      | a\|b | 0.53 | 0.16 | 1 | 1.000 |
      | c | 12.4&#8199; | 1.8&#8199; | 20,000 | 10.00&#8199; |
      |  |  |  |  | Inf&#8200;&#8199;&#8199;&#8199; |

