context("krig_breaks")

test_that("outputs the expected values", {
  expect_equal(krig_breaks(1, 2, 2), c(1, 2))
  expect_equal(krig_breaks(2, 4, 2), c(2, 4))
  expect_equal(krig_breaks(2, 8, 3), c(2, 4, 8))
})

test_that("fails as expected", {
  expect_error(krig_breaks("a", 1, 1), "is not TRUE")
  expect_error(krig_breaks(1, "a", 1), "is not TRUE")
  expect_error(krig_breaks(1, 1, "a"), "is not TRUE")
  expect_error(krig_breaks(1, 2, 0), "is not TRUE")
  expect_warning(krig_breaks(2, 1, 3), "Expected")
  expect_error(krig_breaks(1, 2, 1), "is not TRUE")
  expect_error(krig_breaks(0, 2, 2), "is not TRUE")
})
