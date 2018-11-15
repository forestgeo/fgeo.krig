#' Sequence of n exponentially increasing values.
#'
#' @param first,last Numeric; first and last value of the list.
#' @param n Length of returned value.
#'
#' @return A numeric vector of length `n`.
#'
#' @author Graham Zemunik (grah.zem@@gmail.com).
#'
#' @export
#' @examples
#' out <- krig_breaks(1, 10, 10)
#' plot(out)
krig_breaks <- function(first, last, n) {
  check_krig_breaks(first, last, n)

  v <- vector()
  m <- 1 / (n - 1)
  quotient <- (last / first)^m

  v[1] <- first
  for (i in 2:n)
    v[i] <- v[i - 1] * quotient

  v
}

check_krig_breaks <- function(first, last, n) {
  stopifnot(
    is.numeric(first), is.numeric(last), is.numeric(n), n > 1, first > 0
  )

  expr <- expr(first < last)
  increasing <- eval_tidy(expr)
  msg <- paste0(
    "Expected ", expr_label(expr), " but first = ", first, "and last = ", last
  )
  if (!increasing) warn(msg)
}
