#' Calculate summary statistics for numeric variables
#' This function is designed to be compatible with `atable` as a substitute for
#' it's default function (`atable:::statistics.numeric()`). It returns mean,
#' SD, any specified quantiles, number of observations, number of valid and missing
#' values. Together with the appropriate formatting function, This allows a simple
#' and flexible approach to defining the formats.
#'
#' @param x data
#' @param quantiles list of quantiles to calculate
#' @param ... passed to/from other methods
#' @details
#'
#' @return list of class `numeric_stats` with one element for each quantile (e.g. `q0.5` for median),
#' mean, sd, N (length), Nvalid (number of non-`NA`s) and Nmissing (number of `NA`s)
#' @export
#'
#' @seealso format_statistics.numeric_stats
#'
#' @examples
#' require(atable)
#' data(mtcars)
#' # single use (specify in atable call)
#' atable(mpg ~ am, mtcars, statistics.numeric = numeric_stats)
#' # or change atables default
#' atable_options(statistics.numeric = numeric_stats)
#' atable(mpg ~ am, mtcars)
#'
numeric_stats <- function(x, quantiles = c(0, .25, .5, .75, 1), ...){
  if(!is.numeric(x)) stop("x should be numeric")

  # quantiles
  statistics_out <- as.list(stats::quantile(x, quantiles, na.rm = TRUE))
  names(statistics_out) <- paste0("q", quantiles)

  # normal stuff
  statistics_out$mean <- base::mean(x, na.rm = TRUE)
  statistics_out$sd <- stats::sd(x, na.rm = TRUE)
  statistics_out$N <- length(x)
  statistics_out$Nmissing <- sum(is.na(x))
  statistics_out$Nvalid <- sum(!is.na(x))

  class(statistics_out) <- c("numeric_stats", class(statistics_out))
  return(statistics_out)

}

# x <- numeric_stats(rnorm(20, 50, 10))
#
#
#
#
#
# format_statistics(x, numstats = c("Mean (SD)" = "{mean} ({sd})",
#                                   "Min - Max" = "{q0} - {q1}"),
#                   missingformat = FALSE)
# format_statistics(x, c("Median" = "{q0.5*10}"),
#                   missingformat = FALSE)
#
#
# atable(mpg ~ am, mtcars, statistics.numeric = numeric_stats,
#        numstats = 1)


