context("to_df.krig_lst")

test_that("to_df.krig_lst fails with unknown class", {
  expect_error(to_df(data.frame(1)), "Can't deal with data of class")
  expect_error(to_df(list(1)), "Can't deal with data of class")
})

test_that("to_df.krig_lst returns a tibble/dataframe", {
  out_lst <- krig(fgeo.krig::soil_fake, c("c", "p"), quiet = TRUE)

  expect_false(any("krig_lst" %in% class(to_df(out_lst))))
  expect_is(to_df(out_lst), "data.frame")
  expect_is(to_df(out_lst), "tbl")
})
