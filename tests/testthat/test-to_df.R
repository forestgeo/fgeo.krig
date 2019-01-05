context("to_df.krig_lst")

vars <- c("c", "p")
out_lst <- fgeo.krig::krig(fgeo.krig::soil_fake, vars, quiet = TRUE)
out_df <- to_df(out_lst)

test_that("passes silently with data of correct class", {
  expect_silent(head(out_df))
})

test_that("fails with unknown class", {
  expect_error(to_df(character(1)), "Can't deal with data of class")
  expect_error(to_df(data.frame(1)), "Can't deal with data of class")
  expect_error(to_df(list(1)), "Can't deal with data of class")

  expect_error(to_df(out_lst, name = 1))
  expect_error(to_df(out_lst, item = 1))
  expect_error(to_df(out_lst, item = "bad_item"))
  expect_error(to_df(out_lst, item = c("df", "df.poly")))
})

test_that("outputs an object of the expected class", {
  # no-longer class krig_lst
  expect_false(any("krig_lst" %in% class(to_df(out_lst))))
  expect_is(to_df(out_lst), "data.frame")
  expect_is(to_df(out_lst), "tbl")
})
