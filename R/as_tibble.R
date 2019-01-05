#' Coerce objects of class "krig_lst" to dataframe or tbl (tibble).
#'
#' This method creates a dataframe from the output of `fgeo.krig::krig()`
#' (which is a list of class "krig_lst").
#'
#' @inheritParams tibble::as_tibble
#' @inheritParams base::as.data.frame
#' @param x The output of `fgeo.krig::krig()`.`
#' @param .id Name for the column to hold soil variable-names.
#' @param item Character string; either "df" or "df.poly".
#' @param ... Arguments passed to the [base::as.data.frame()] (not used in
#'   [as_tibble.krig_lst()]).
#'
#' @seealso [base::as.data.frame()], [tibble::as_tibble()].
#'
#' @return A dataframe.
#'
#' @examples
#' vars <- c("c", "p")
#' krig <- krig(soil_fake, vars, quiet = TRUE)
#'
#' as_tibble(krig)
#'
#' df <- as.data.frame(krig)
#' head(df)
#' class(df$var)
#'
#' df2 <- as.data.frame(krig, stringsAsFactors = FALSE)
#' head(df2)
#' class(df2$var)
#' @family methods for fgeo generics
#' @export
as_tibble.krig_lst <- function(x, .id = "var", item = "df", ...) {
  stopifnot(is.character(.id), is.character(item))
  stopifnot(length(item) == 1, item == "df" || item == "df.poly")

  lst <- purrr::map(x, item)
  purrr::map_dfr(lst, tibble::as.tibble, .id = .id)
}

#' @rdname as_tibble.krig_lst
#' @export
as.data.frame.krig_lst <- function(x,
                                   row.names = NULL,
                                   optional = FALSE,
                                   .id = "var",
                                   item = "df",
                                   ...) {
  tbl <- as_tibble(x, .id = .id, item = item)
  as.data.frame(
    unclass(tbl),
    row.names = row.names,
    optional = optional, ...
  )
}
