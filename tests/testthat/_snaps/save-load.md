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

