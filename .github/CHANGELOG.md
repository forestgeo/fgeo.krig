# fgeo.krig 1.0.1 ([GitHub](https://github.com/forestgeo/fgeo.krig/releases) and [drat](https://forestgeo.github.io/drat/))

This release marks that __fgeo.krig__ now meets CRAN standards. This is an internal release focused on making the package more reliable and easier to maintain (see [NEWS](../NEWS.md)).

### More reliable

* Require minimum versions of R packages.

* Require R >= 3.3 (imposed by dependency RandomFields).

* Check build on the three main platforms.

### Easier to maintain

* The website now builds on Travis CI and deploys on the gh-branch.

* .travis.yml now includes parameters that make the builds less likely to fail.
