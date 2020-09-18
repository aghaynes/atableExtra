<!-- README.md is generated from README.Rmd. Please edit that file -->

atableExtra
===========

[`atable`](https://CRAN.R-project.org/package=atable) is a package
simplifying the task of creating tables of summary statistics similar to
those found as the first table of a clinical trial publication. Although
it is very flexible, utilising this flexibility involves writing new
functions to calculate other measures and statistics. `atableExtra`
provides some additional functions to simplify this task. `atableExtra`
also changes some `atable` default settings.

Installation
------------

<!-- You can install the released version of atableExtra from [CRAN](https://CRAN.R-project.org) with: -->
<!-- ```{r , eval=FALSE} -->
<!-- library(atableExtra) -->
<!-- ## basic example code -->
<!-- ``` -->
<!-- And the development version from [GitHub](https://github.com/) with: -->

    # install.packages("devtools")
    devtools::install_github("aghaynes/atableExtra")

Factors
-------

`atableExtra` changes the default formatting of factors from
`percentage (N)` to `N (percentage)`.

    library(atable)
    atable_options(format_to = "Console")
    data(mtcars)
    mtcars$cyl <- as.factor(mtcars$cyl)
    atable(mtcars, target_cols = "cyl")
    #>   Group         value   
    #> 1 Observations          
    #> 2               32      
    #> 3 cyl                   
    #> 4      4        34% (11)
    #> 5      6        22% (7) 
    #> 6      8        44% (14)
    #> 7      missing  0% (0)

    library(atableExtra)
    #> Loading required package: glue
    #> Registered S3 method overwritten by 'atableExtra':
    #>   method                              from  
    #>   format_statistics.statistics_factor atable
    atable(mtcars, target_cols = "cyl")
    #>   Group         value   
    #> 1 Observations          
    #> 2               32      
    #> 3 cyl                   
    #> 4      4        11 (34%)
    #> 5      6        7 (22%) 
    #> 6      8        14 (44%)
    #> 7      missing  0 (0%)

Numeric
-------

`atableExtra` also provides a flexible approach to formatting numeric
variables via the `numeric_stats` function and it’s appropriate
`format_statistics` method. It’s default settings mimic those from
`atable`:

    # atable
    atable(mtcars, target_cols = "mpg")
    #>   Group                value 
    #> 1 Observations               
    #> 2                      32    
    #> 3 mpg                        
    #> 4      Mean (SD)       20 (6)
    #> 5      valid (missing) 32 (0)
    # atableExtra
    atable_options(statistics.numeric = numeric_stats) # replace the default function
    atable(mtcars, target_cols = "mpg")
    #>   Group                value 
    #> 1 Observations               
    #> 2                      32    
    #> 3 mpg                        
    #> 4      Mean (SD)       20 (6)
    #> 5      Valid (missing) 32 (0)

It’s easy to change the format though via the `numstats` argument that
takes either numbers 1 to 3 (defaults to 1)…

    atable(mtcars, target_cols = "mpg", numstats = 1:3)
    #>   Group                   value      
    #> 1 Observations                       
    #> 2                         32         
    #> 3 mpg                                
    #> 4      Mean (SD)          20 (6)     
    #> 5      Min - Max          10 - 34    
    #> 6      Median [Quartiles] 19 [15; 23]
    #> 7      Valid (missing)    32 (0)

… or named characters…

    atable(mtcars, target_cols = "mpg", 
           numstats = c("Mean" = "{mean}", "Median" = "{q0.5}"))
    #>   Group                value 
    #> 1 Observations               
    #> 2                      32    
    #> 3 mpg                        
    #> 4      Mean            20    
    #> 5      Median          19    
    #> 6      Valid (missing) 32 (0)

Any quantile can be used (0th (= minimum), 25th, median, 75th and 100th
(=maximum) are available by default) via the `quantiles` argument and
referred to as e.g. `q0.1` for the 10th percentile.

    atable(mtcars, target_cols = "mpg", 
           quantiles = .1, 
           numstats = c("10th percentile" = "{q0.1}"))
    #>   Group                value 
    #> 1 Observations               
    #> 2                      32    
    #> 3 mpg                        
    #> 4      10th percentile 14    
    #> 5      Valid (missing) 32 (0)

The number of valid/missing observations can be turned off via the
`missingformat` argument…

    atable(mtcars, target_cols = "mpg", missingformat = FALSE)
    #>   Group          value 
    #> 1 Observations         
    #> 2                32    
    #> 3 mpg                  
    #> 4      Mean (SD) 20 (6)

… or modified as per the `numstats` argument…

    atable(mtcars, target_cols = "mpg", missingformat = c("Missing" = "{Nmissing}"))
    #>   Group          value 
    #> 1 Observations         
    #> 2                32    
    #> 3 mpg                  
    #> 4      Mean (SD) 20 (6)
    #> 5      Missing   0
