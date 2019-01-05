context("as_tibble.krig_lst")

test_that("as_tibble.krig_lst returns a tibble", {
  expect_is(
    as_tibble(krig(fgeo.krig::soil_fake, c("c", "p"), quiet = TRUE)),
    "tbl"
  )
})



context("as.data.frame.krig_lst")

test_that("as.data.frame.krig_lst returns a data.frame", {
  expect_is(
    as.data.frame(krig(fgeo.krig::soil_fake, c("c", "p"), quiet = TRUE)),
    "data.frame"
  )
})

test_that("as.data.frame.krig_lst takes arguments via `...`", {
  krig_result <- krig(
    fgeo.krig::soil_fake,
    var = c("c", "p"),
    plotdim = c(1000, 460),
    quiet = TRUE
  )

  expect_is(
    as.data.frame(krig_result)[["var"]],
    "factor"
  )
  expect_is(
    as.data.frame(krig_result, stringsAsFactors = FALSE)[["var"]],
    "character"
  )
})
