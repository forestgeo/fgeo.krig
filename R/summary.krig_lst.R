#' Summary objects of class "krig_lst".
#'
#' This method helps you to visualize the output of `krig()` (which outputs
#' objects of class "krig_lst"). It is similar to [utils::str()] but a little
#' cleaner. version of `str()`.
#' 
#' @param object The result of `krig()`.
#' @inheritDotParams base::summary
#' 
#' @family methods for common generics
#'
#' @return Prints a cleaner version of `str()` and returns its input invisibly.
#' @export
#'
#' @examples
#' result <- krig(soil_fake, c("c", "p"), quiet = TRUE)
#' summary(result)
#' str(result)
summary.krig_lst <- function(object, ...) {
  nms <- names(object)
  for (i in seq_along(nms)) {
    cat("var:", nms[[i]], "\n")
    summarize_krig(object[[i]])
  }
  invisible(object)
}

summarize_krig <- function(object, ...) {
  cat(
    smry_df(object$df, "df"),
    cat("\n"),
    smry_df(object$df.poly, "df.poly"),
    cat("\n"),
    smry_other(object$lambda, "lambda"),
    cat("\n"),
    smry_other(object$vg, "vg"),
    cat("\n"),
    smry_other(object$vm, "vm"),
    cat("\n")
  )
  invisible(object)
}

smry_df <- function(.data, ...) {
  cat(
    cat(..., "\n", sep = ""),
    cat(utils::str(.data, give.attr = FALSE))
  )
}

smry_other <- function(x, nm) {
  smry_df(x, nm, "\n'", commas(class(x), "'"))
}
