# TODO: DRY. Duplicated in fgeo.analyze.

#' Create objects of class "data.frame" from other fgeo classes.
#'
#' Most of the popular, general-purpose tools for data science input objects of
#' class "data.frame" (<https://www.tidyverse.org/>). However, several __fgeo__
#' functions (either inherited from the original CTFS R Package or contributed
#' by ForestGEO partners) output data of different class. Taking as input
#' different classes of __fgeo__ objects, `to_df()` provides a simple,
#' consistent way to create dataframes.
#'
#' This generic provides methods for classes that cannot be correctly coerced
#' simply with [base::as.data.frame()] (or similar functions from the
#' __tibble__ package).
#'
#' @param .x An fgeo object of supported class.
#' @param ... Other arguments passed to methods.
#'
#' @seealso [to_df.krig_lst()].
#'
#' @family fgeo generics
#' @keywords internal
#'
#' @return A dataframe.
#' @export
to_df <- function(.x, ...) {
  UseMethod("to_df")
}

#' @export
to_df.default <- function(.x, ...) {
  rlang::abort(glue("Can't deal with data of class {class(.x)}"))
}

# Class krig_lst ----------------------------------------------------------

#' Dataframe objects of class "krig_lst".
#'
#' This method creates a dataframe from the output of `fgeo.krig::krig()`
#' (which is a list of class "krig_lst").
#'
#' @param .x The output of `fgeo.krig::krig()`.`
#' @param name Name for the column to hold soil variable-names.
#' @param item Character string; either "df" or "df.poly".
#' @inheritDotParams to_df
#'
#' @seealso [to_df()].
#'
#' @family methods for fgeo generics
#'
#' @return A dataframe.
#' @export
#'
#' @examples
#' \dontrun{
#' if (!requireNamespace("fgeo.krig")) {
#'   stop("This example requires fgeo.krig. Please install it")
#' }
#' library(fgeo.krig)
#'
#' vars <- c("c", "p")
#' krig <- krig(soil_fake, vars, quiet = TRUE)
#' to_df(krig)
#' }
to_df.krig_lst <- function(.x, name = "var", item = "df", ...) {
  stopifnot(is.character(name), is.character(item))
  stopifnot(length(item) == 1, item == "df" || item == "df.poly")

  lst <- purrr::map(.x, item)
  purrr::map_dfr(lst, tibble::as.tibble, .id = name)
}

