
<!-- README.md is generated from README.Rmd. Please edit that file -->

# <img src="https://i.imgur.com/vTLlhbp.png" align="right" height=88 /> Analyze soils

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Travis build
status](https://travis-ci.org/forestgeo/fgeo.krig.svg?branch=master)](https://travis-ci.org/forestgeo/fgeo.krig)
[![Coverage
status](https://coveralls.io/repos/github/forestgeo/fgeo.krig/badge.svg)](https://coveralls.io/r/forestgeo/fgeo.krig?branch=master)
[![CRAN
status](http://www.r-pkg.org/badges/version/fgeo.krig)](https://cran.r-project.org/package=fgeo.krig)

## Installation

Install the development version of **fgeo.krig**:

    # install.packages("devtools")
    devtools::install_github("forestgeo/fgeo.krig")

Or [install all **fgeo** packages in one
step](https://forestgeo.github.io/fgeo/index.html#installation).

For details on how to install packages from GitHub, see [this
article](https://goo.gl/dQKEeg).

## Example

``` r
library(dplyr)
library(fgeo.tool)
library(fgeo.krig)
```

### Krige soil data

Using custom parameters and multiple soil variable.

``` r
params <- list(
  model = "circular", range = 100, nugget = 1000, sill = 46000, kappa = 0.5
)

vars <- c("c", "p")
custom <- krig(soil_fake, vars, params = params, quiet = TRUE)
#> Gessing: plotdim = c(1000, 460)

# Showing only the first item of the resulting output
to_df(custom)
#> # A tibble: 2,300 x 4
#>    var       x     y     z
#>    <chr> <dbl> <dbl> <dbl>
#>  1 c        10    10  2.29
#>  2 c        30    10  2.31
#>  3 c        50    10  2.22
#>  4 c        70    10  2.04
#>  5 c        90    10  1.79
#>  6 c       110    10  1.54
#>  7 c       130    10  1.55
#>  8 c       150    10  1.64
#>  9 c       170    10  1.77
#> 10 c       190    10  1.89
#> # ... with 2,290 more rows
```

Using automated parameters.

``` r
result <- krig(soil_fake, var = "c", quiet = TRUE)
#> Gessing: plotdim = c(1000, 460)
summary(result)
#> var: c 
#> df
#> Classes 'tbl_df', 'tbl' and 'data.frame':    1150 obs. of  3 variables:
#>  $ x: num  10 30 50 70 90 110 130 150 170 190 ...
#>  $ y: num  10 10 10 10 10 10 10 10 10 10 ...
#>  $ z: num  2.13 2.12 2.1 2.09 2.07 ...
#> 
#> df.poly
#> Classes 'tbl_df', 'tbl' and 'data.frame':    1150 obs. of  3 variables:
#>  $ gx: num  10 30 50 70 90 110 130 150 170 190 ...
#>  $ gy: num  10 10 10 10 10 10 10 10 10 10 ...
#>  $ z : num  2.13 2.12 2.1 2.09 2.07 ...
#> 
#> lambda
#> 'numeric'
#>  num 1
#> 
#> vg
#> 'variogram'
#> List of 20
#>  $ u               : num [1:9] 60.9 86.5 103 122.7 146.1 ...
#>  $ v               : num [1:9] 0.284 0.422 0.882 0.543 0.211 ...
#>  $ n               : num [1:9] 7 9 10 10 18 19 36 34 38
#>  $ sd              : num [1:9] 0.414 0.48 0.633 0.501 0.405 ...
#>  $ bins.lim        : num [1:31] 1.00e-12 2.00 2.38 2.84 3.38 ...
#>  $ ind.bin         : logi [1:30] FALSE FALSE FALSE FALSE FALSE FALSE ...
#>  $ var.mark        : num 0.317
#>  $ beta.ols        : num 1.36e-09
#>  $ output.type     : chr "bin"
#>  $ max.dist        : num 320
#>  $ estimator.type  : chr "classical"
#>  $ n.data          : int 30
#>  $ lambda          : num 1
#>  $ trend           : chr "cte"
#>  $ pairs.min       : num 5
#>  $ nugget.tolerance: num 1e-12
#>  $ direction       : chr "omnidirectional"
#>  $ tolerance       : chr "none"
#>  $ uvec            : num [1:30] 1 2.19 2.61 3.11 3.7 ...
#>  $ call            : language variog(geodata = geodata, breaks = breaks, trend = trend, pairs.min = 5)
#> 
#> vm
#> 'variomodel', variofit'
#> List of 17
#>  $ nugget               : num 0.352
#>  $ cov.pars             : num [1:2] 0 160
#>  $ cov.model            : chr "exponential"
#>  $ kappa                : num 0.5
#>  $ value                : num 4.64
#>  $ trend                : chr "cte"
#>  $ beta.ols             : num 1.36e-09
#>  $ practicalRange       : num 480
#>  $ max.dist             : num 320
#>  $ minimisation.function: chr "optim"
#>  $ weights              : chr "npairs"
#>  $ method               : chr "WLS"
#>  $ fix.nugget           : logi FALSE
#>  $ fix.kappa            : logi TRUE
#>  $ lambda               : num 1
#>  $ message              : chr "optim convergence code: 0"
#>  $ call                 : language variofit(vario = vg, ini.cov.pars = c(initialVal, startRange), cov.model = varModels[i],      nugget = initialVal)
```

[Get started with
**fgeo**](https://forestgeo.github.io/fgeo/articles/fgeo.html)

## Information

  - [Getting help](SUPPORT.md).
  - [Contributing](CONTRIBUTING.md).
  - [Contributor Code of Conduct](CODE_OF_CONDUCT.md).
