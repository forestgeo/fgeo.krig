## Test environments

* local: windows 10 x64 (R 3.5.2)
* travis: 
  * mac os x 10.13.3 (R 3.5.2)
  * ubuntu 14.04 (R 3.2, 3.3, oldrel, release, devel)
* win-builder (R devel and release)

## R CMD check results

* using R Under development (unstable) (2019-01-31 r76038)
* using platform: x86_64-w64-mingw32 (64-bit)
* this is package 'fgeo.krig' version '1.0.0.9000'

Status: 1 ERROR, 1 WARNING, 1 NOTE
WARNING
New submission
Version contains large components (1.0.0.9000) ... FIXME
Strong dependencies not in mainstream repositories:
  fgeo.tool
Availability using Additional_repositories specification:
  fgeo.tool   yes   https://forestgeo.github.io/drat/
  
ERROR  ... FIXME
  > library(testthat)
  > library(fgeo.krig)
  > 
  > test_check("fgeo.krig")
  -- 1. Failure: passes regression test (@test-krig.R#56)  -----------------------
  `result_head` has changed from known value recorded in 'ref-krig'.
  106/237 mismatches
  x[3]: "1   10 10  94.17480521"
  y[3]: "1   10 10  94.15453088"
  
  x[4]: "2   30 10  81.80377710"
  y[4]: "2   30 10  81.78541849"
  
  x[5]: "3   50 10  70.31237775"
  y[5]: "3   50 10  70.29584957"
  
  x[6]: "4   70 10  59.69851082"
  y[6]: "4   70 10  59.68372925"
  
  x[7]: "5   90 10  49.96008167"
  y[7]: "5   90 10  49.94696439"
  
  == testthat results  ===========================================================
  OK: 51 SKIPPED: 0 FAILED: 1
  1. Failure: passes regression test (@test-krig.R#56) 

## Downstream dependencies

TODO
