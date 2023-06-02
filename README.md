README
================
Sara Colom
2023-06-02

This repo contains the source function to generate one or two-way cross
tab summary stats on the fly with `var_summarise()`

# Installation

Make sure you have `devtools` already installed and loaded.

- `install.packages("devtools")`
- `library(devtools)`
- `install_github("ucsf-bhhi/SummaryTable", host = "https://remotes.r-lib.org/reference/install_github.html")`

# Examples

This package was created to generate summary statics tables for one to
two-cross tabs on the fly. You need to provide a data set with the
variables you want to summarise.

Read in library

``` r
library(SummaryTable)
library(dplyr)
#> Warning: package 'dplyr' was built under R version 4.2.3
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
```

## Example

### Data: iris

This is the output for `Sepal.Width` a continuous variable w/o
stratification. Without any other sepcification, the function spits out
the mean and SD.

``` r
#var_summarise(dat = iris, var = "Sepal.Width")
```
