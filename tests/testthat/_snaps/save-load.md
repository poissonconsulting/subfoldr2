# sbf_load_plots_recursive() fails if at least one sub is populated and we drop all subs.

    Code
      out <- sbf_load_plots_recursive(main = temp_dir)
      out$file <- NULL
      out
    Output
      # A tibble: 5 x 3
        plots      name   sub  
        <list>     <chr>  <chr>
      1 <ggplt2::> plot-1 sub  
      2 <ggplt2::> plot-2 sub  
      3 <ggplt2::> plot-3 sub  
      4 <ggplt2::> plot-2 sub2 
      5 <ggplt2::> plot-3 sub3 

---

    Code
      out <- sbf_load_plots_recursive(main = temp_dir, drop = "sub")
      out$file <- NULL
      out
    Output
      # A tibble: 2 x 3
        plots      name   sub  
        <list>     <chr>  <chr>
      1 <ggplt2::> plot-2 sub2 
      2 <ggplt2::> plot-3 sub3 

# `sbf_load_numbers_recursive()` drops only exact matches.

    Code
      numbers
    Output
      # A tibble: 8 x 5
        numbers name  sub         sub1  sub2 
          <dbl> <chr> <chr>       <chr> <chr>
      1       6 hone  "bone"      bone  <NA> 
      2       5 one   "bone"      bone  <NA> 
      3       8 cone  "bone/zone" bone  zone 
      4       7 one   "bone/zone" bone  zone 
      5       1 one   ""          <NA>  <NA> 
      6       3 one   "one"       one   <NA> 
      7       4 tone  "one"       one   <NA> 
      8       2 ones  ""          <NA>  <NA> 

---

    Code
      numbers_one
    Output
      # A tibble: 3 x 5
        numbers name  sub         sub1  sub2 
          <dbl> <chr> <chr>       <chr> <chr>
      1       6 hone  "bone"      bone  <NA> 
      2       8 cone  "bone/zone" bone  zone 
      3       2 ones  ""          <NA>  <NA> 

---

    Code
      numbers_bone
    Output
      # A tibble: 4 x 3
        numbers name  sub  
          <dbl> <chr> <chr>
      1       1 one   ""   
      2       3 one   "one"
      3       4 tone  "one"
      4       2 ones  ""   

---

    Code
      numbers_onebone
    Output
      # A tibble: 1 x 3
        numbers name  sub  
          <dbl> <chr> <chr>
      1       2 ones  ""   

