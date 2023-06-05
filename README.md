README
================
Sara Colom
2023-06-05

This repo contains the source function to generate one or two-way cross
tab summary stats on the fly with `var_summarise()`

# Installation

Make sure you have `devtools`, `credentials` and `remotes` already
installed and loaded. Also be sure to be active on the **UCSF VPN**.

- `install.packages("devtools")`
- `install.packages("credentials")`
- `install.packages("remotes"`
- `library(devtools)`
- `library(credentials)`
- `library(remotes)`

Steps are commented out below beneath its description.

``` r
#set config
# usethis::use_git_config(user.name = "YourName", user.email = "your@mail.com")

#Go to github page to generate token
# usethis::create_github_token() 

#paste your PAT into pop-up that follows...
# credentials::set_github_pat()

#now remotes::install_github() will work
# remotes::install_github("ucsf-bhhi/SummaryTable")
```

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
