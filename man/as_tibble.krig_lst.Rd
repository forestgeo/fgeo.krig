% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/as_tibble.R
\name{as_tibble.krig_lst}
\alias{as_tibble.krig_lst}
\alias{as.data.frame.krig_lst}
\title{Coerce objects of class "krig_lst" to dataframe or tbl (tibble).}
\usage{
\method{as_tibble}{krig_lst}(x, .id = "var", item = "df", ...)

\method{as.data.frame}{krig_lst}(x, row.names = NULL, optional = FALSE,
  .id = "var", item = "df", ...)
}
\arguments{
\item{x}{The output of \code{fgeo.krig::krig()}.`}

\item{.id}{Name for the column to hold soil variable-names.}

\item{item}{Character string; either "df" or "df.poly".}

\item{...}{Arguments passed to the \code{\link[base:as.data.frame]{base::as.data.frame()}} (not used in
\code{\link[=as_tibble.krig_lst]{as_tibble.krig_lst()}}).}

\item{row.names}{\code{NULL} or a character vector giving the row
    names for the data frame.  Missing values are not allowed.}

\item{optional}{logical. If \code{TRUE}, setting row names and
    converting column names (to syntactic names: see
    \code{\link{make.names}}) is optional.  Note that all of \R's
    \pkg{base} package \code{as.data.frame()} methods use
    \code{optional} only for column names treatment, basically with the
    meaning of \code{\link{data.frame}(*, check.names = !optional)}.
    See also the \code{make.names} argument of the \code{matrix} method.}
}
\value{
A dataframe.
}
\description{
This method creates a dataframe from the output of \code{fgeo.krig::krig()}
(which is a list of class "krig_lst").
}
\examples{
vars <- c("c", "p")
krig <- krig(soil_fake, vars, quiet = TRUE)

as_tibble(krig)

head(as.data.frame(krig, stringsAsFactors = FALSE))
}
\seealso{
\code{\link[base:as.data.frame]{base::as.data.frame()}}, \code{\link[tibble:as_tibble]{tibble::as_tibble()}}.
}
\concept{methods for fgeo generics}
