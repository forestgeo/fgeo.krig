context("summary.krig_lst")

test_that("outputs correct names", {
  res <- krig(soil_fake, "c", quiet = TRUE)
  out <- utils::capture.output(summary(res))
  correct_names <- names(res[[1]]) %>%
    purrr::map_lgl(~ any(suppressWarnings(stringr::str_detect(.x, out)))) %>%
    all()
  expect_true(correct_names)
})
