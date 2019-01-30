# Small dataset that still preserves plot dimensions via guess_plotdim()
df0 <- fgeo.krig::soil_random
df_gx <- tail(dplyr::arrange(df0, gx))
df_gy <- tail(dplyr::arrange(df0, gy))
df <- rbind(df_gx, df_gy)



context("krig")

# Keep despite guess_plotdim() is externa. What matters here is not the function
# but the value it returs. Else, the output of krig and friends will change.
test_that("plotdimensions are guessed correctly", {
  expect_equal(fgeo.tool::guess_plotdim(df), c(1000, 500))
})

vars <- c("c", "p")
out_lst <- krig(soil_fake, vars, quiet = TRUE)

test_that("outputs object of expected structure at the surface of the list", {
  expect_named(out_lst, vars)
  expect_is(out_lst, "krig_lst")
  expect_is(out_lst, "list")
  expect_is(out_lst[[1]][[1]], "data.frame")
  expect_is(out_lst[[1]][[1]], "tbl")
  expect_is(out_lst[[1]][[2]], "data.frame")
  expect_is(out_lst[[1]][[2]], "tbl")
})

test_that("prints as an unclassed list (i.e. doesn't show attr ...)", {
  output <- capture_output(print(krig(soil_fake, vars, quiet = TRUE)))
  expect_false(grepl("krig_lst", output))
})



result <- krig(df, var = "m3al", quiet = TRUE)[[1]]

test_that("fails if var is of length greater than 1", {
  expect_error(
    krig(df, var = c("m3al", "wrong_name"), quiet = TRUE)[[1]],
    "isn't in your data"
  )
})

test_that("keeps quiet if asked to", {
  expect_message(krig(df, var = "m3al"), "computing omnidirectional")
  expect_message(krig(df, var = "m3al", quiet = TRUE), "Guessing.*plotdim")
})

test_that("passes regression test", {
  result_head <- lapply(result, head, 50)
  # Print all of the original output for a more comprehensive comparison
  result_head[[1]] <- as.data.frame(result_head[[1]])
  result_head[[2]] <- as.data.frame(result_head[[2]])
  expect_known_output(result_head, "ref-krig", print = TRUE, update = TRUE)
})

test_that("returns the expected value.", {
  expect_type(result, "list")
  nms <- c("df", "df.poly", "lambda", "vg", "vm")
  expect_named(result, nms)
  expect_is(result, "list")
  expect_is(result$df, "data.frame")
  expect_is(result$df.poly, "data.frame")
  expect_is(result$lambda, "numeric")
  expect_type(result$vg, "list")
  expect_named(result$vg)
  expect_is(result$vm, "variomodel")
  expect_is(result$vm, "variofit")
})



# Checks ------------------------------------------------------------------

test_that("outputs the same with plotdim given directly or via guess_plotdim", {
  expect_equal(
    krig(
      soil_random, "m3al",
      quiet = TRUE, plotdim = c(1000, 500),
    )[[1]],
    krig(
      soil_random, "m3al",
      quiet = TRUE, plotdim = fgeo.tool::guess_plotdim(soil_random),
    )[[1]]
  )
})

test_that("check_GetKrigSoil() fails with wrong input", {
  numeric_input <- as.matrix(df)
  expect_error(krig(numeric_input, var = "m3al"), "is not TRUE")

  rnm <- stats::setNames(df, c("wrong_x", "wrong_gy", "m3al"))
  expect_error(
    krig(rnm, var = "m3al"),
    "Ensure your data set has these variables:"
  )
  cero_row <- data.frame(gx = numeric(0), gy = numeric(0))
  expect_error(
    suppressWarnings(krig(cero_row, var = "m3al")),
    "Ensure `df.soil` has one or more rows"
  )
  expect_error(
    krig(df, var = "non-existent-var"),
    "The variable-name passed to `var` isn't in your data"
  )
  expect_error(krig(df, var = 888), "is not TRUE")
  expect_error(
    krig(df),
    "argument \"var\" is missing"
  )
  expect_error(krig(df, var = "m3al", gridSize = "3"))
  expect_error(krig(df, var = "m3al", xSize = "3"))
  expect_error(krig(df, var = "m3al", ySize = "3"))
  wrong_type <- 1
  expect_error(krig(df, var = "m3al", params = wrong_type))
  bad_not_a_number <- "a"
  expect_error(krig(df, var = "m3al", breaks = bad_not_a_number))
  bad_not_logical <- "a"
  expect_error(krig(df, var = "m3al", useKsLine = bad_not_logical))
})
