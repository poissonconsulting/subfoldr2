# sbf_as_md with round = TRUE matches the md file of sbf_save_table

    Code
      writeLines(sbf_load_table_md("x"))
    Output
      | term |     estimate |        lower |        upper | svalue |     observed | length |      n |
      | :--- | -----------: | -----------: | -----------: | -----: | -----------: | -----: | -----: |
      | a    |         0.53 |         0.21 |         0.87 |    1.2 |         0.60 |    1.2 |      1 |
      | b\|c |        12.3  |         9.9  |        15    |    5.7 |        11.0  |  123.5 | 20,000 |
      |      | 1,230,000    | 1,000,000    | 1,500,000    |   12.0 | 1,200,000    |        |        |

# sbf_as_md does not round by default and keeps text as text

    Code
      writeLines(sbf_as_md(x))
    Output
      | term | estimate |       big |   n | code |
      | :--- | -------: | --------: | --: | :--- |
      | a    |  0.53124 | 123,456.7 |   1 | 001  |
      | b    | 12.3456  |           |   2 | 12.5 |

# sbf_as_md and sbf_round_data validate arguments

    Code
      sbf_as_md(1)
    Condition
      Error in `sbf_as_md()`:
      ! `x` must inherit from S3 class 'data.frame', not S3 class 'numeric'.
    Code
      sbf_as_md(x, round = NA)
    Condition
      Error in `sbf_as_md()`:
      ! `round` must be a flag (TRUE or FALSE).
    Code
      sbf_as_md(x, proportion = TRUE)
    Condition
      Error in `sbf_as_md()`:
      ! `proportion`, `format_column` and `round_as_estimate` must not be set when `round = FALSE`.
    Code
      sbf_as_md(x, format_column = list(n ~ round(.)))
    Condition
      Error in `sbf_as_md()`:
      ! `proportion`, `format_column` and `round_as_estimate` must not be set when `round = FALSE`.
    Code
      sbf_as_md(x, round_as_estimate = "n")
    Condition
      Error in `sbf_as_md()`:
      ! `proportion`, `format_column` and `round_as_estimate` must not be set when `round = FALSE`.
    Code
      sbf_as_md(x, round = TRUE)
    Condition
      Error in `sbf_as_md()`:
      ! `estimate`, `lower`, `upper` and `sd` columns in `x` must be numeric: 'upper' not numeric.
    Code
      sbf_round_data(x)
    Condition
      Error in `sbf_round_data()`:
      ! `estimate`, `lower`, `upper` and `sd` columns in `x` must be numeric: 'upper' not numeric.
    Code
      sbf_round_data(x["estimate"], proportion = TRUE)
    Condition
      Error in `sbf_round_data()`:
      ! Columns 'estimate' in `x` must be proportions between 0 and 1 when `proportion = TRUE`.
    Code
      sbf_round_data(x["n"], format_column = list(z ~ round(.)))
    Condition
      Error in `sbf_round_data()`:
      ! `format_column` columns must be in `x`: 'z' not found.
    Code
      sbf_round_data(x["n"], format_column = list(n ~ 1:3))
    Condition
      Error in `sbf_round_data()`:
      ! `format_column` function for column 'n' must return a vector of the same length as the column.

