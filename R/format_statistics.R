#' Format factors as `X (X\%)` instead of `X\% (X)`
#'
#' Almost an exact copy of the equivilent function from `atable`,
#' this function just formats factors as e.g. 15 (25%) rather than
#' 25% (15) as `atable` does. It is a personal-preference thing...
#'
#' When `atableExtra` loads, this function automatically overrides the `atable` version
#'
#' @param x a `statistics_factor` object as created by `atable:::statistics.factor`
#' @param factorformat how to format the values
#' @param ... passed to/from other methods
#' @details
#' Option `factorformat` uses the `glue` package to create strings.
#' Although `glue` parses the values within the braces (`{` and `}`), this is not permitted
#' in this case as only strings are passed to `glue`. Values that can be used in
#' the are braces are `N`, `total` and `percent`.
#' @export
#' @importFrom atable format_statistics atable_options
#' @importFrom glue glue
#'
#' @examples
#' data(mtcars)
#' mtcars$cyl <- as.factor(mtcars$cyl)
#' atable(mtcars, target_cols = "cyl")
format_statistics.statistics_factor <- function (x,
              factorformat = "{N} ({percent}%)",
              ...) {

  nn <- names(x)
  N <- unlist(x)
  total <- sum(N)
  percent <- atable_options("format_numbers")(100 * N/total)
  value <- glue::glue(factorformat)
  format_statistics_out <- data.frame(tag = factor(nn, levels = nn),
                                      value = value, row.names = NULL,
                                      stringsAsFactors = FALSE,
                                      check.names = FALSE,
                                      fix.empty.names = FALSE)
  return(format_statistics_out)
}







#' Format summary statistics for numeric variables when using \code{numstats}
#'
#' format_statistics.numeric_stats can use any statistic returned by \code{numstats}.
#' It returns the type of table expected by \code{atable}.
#'
#' @param x a \code{numstats} object
#' @param numstats either a number (1 to 3) or a named character, where the name
#' is used as the row name and the second part in the formatting. See details for
#' more info.
#' @param missingformat either a logical or a named string defining the format
#' as for \code{numstats}.
#' @param ... passed to/from other methods
#' @details
#'
#' Options \code{numstats} and \code{missingformat} use the \code{glue} package
#' to create strings. Although \code{glue} parses the values within the braces
#' (`\{` and `\}`), this is not permitted in this case as only strings are passed
#' to \code{glue} after being formatted by \code{atable_options("format_numbers")}.
#' To format the numbers differently, reassign that function.
#'
#' The \code{numstats} argument allows the flexible formatting of the statistics
#' and label. It accepts either a number (1 to 3) or a names character string.
#' Number 1 is equivalent to \code{c("Mean (SD)" = "{mean} ({sd})")}. Number 2
#' is equivalent to \code{c("Min - Max" = "{q0} - {q1}")} and number 3 is
#' equivalent to \code{c("Median [Quartiles]" = "{q0.5} [{q0.25}; {q0.75}]")}.
#' Any parameter returned by \code{numeric_stats} can be used.
#'
#' \code{missingformat} works in the same way as \code{numstats}. Tt defaults to
#' \code{c("Valid (missing)" = "{Nvalid} ({Nmissing})")}.
#'
#'
#' @export
#'
#' @examples
#'
#' require(atable)
#' atable_options(statistics.numeric = numeric_stats)
#' data(mtcars)
#' # atableExtra default
#' atable(mpg ~ am, mtcars)
#' # specify only mean
#' atable(mpg ~ am, mtcars, numstats = c("Mean (SD)" = "{mean} ({sd})"))
#' # specify options by number
#' atable(mpg ~ am, mtcars, numstats = 1:2)
#' atable(mpg ~ am, mtcars, numstats = c(1,3))
#' # change to square brackets
#' atable(mpg ~ am, mtcars, numstats = c("Mean [SD]" = "{mean} [{sd}]"))

format_statistics.numeric_stats <- function(x,
          numstats = c("Mean (SD)" = "{mean} ({sd})"),
          missingformat = c("Valid (missing)" = "{Nvalid} ({Nmissing})"),
          ...){

  # numeric input to numstats
  if(is.numeric(numstats)){
    if(any(numstats < 1 | numstats > 3)) stop("Unknown numstats value")
    defaults <- c("Mean (SD)" = "{mean} ({sd})",
                  "Min - Max" = "{q0} - {q1}",
                  "Median [Quartiles]" = "{q0.5} [{q0.25}; {q0.75}]")
    numstats <- defaults[numstats]
    rm(defaults)
  }

  # missing format
  if(!is.logical(missingformat) & !is.character(missingformat))
    stop("Unexpected class of missingformat")
  if(is.logical(missingformat)){
    if(missingformat){
      missingformat <- c("Valid (missing)" = "{Nvalid} ({Nmissing})")
      all <- c(numstats, missingformat)
    } else {
      all <- numstats
    }
  } else {
    all <- c(numstats, missingformat)
  }

  # check all variables exist
  r <- gregexpr("\\{[[:alnum:][:punct:]]{1,}\\}", all)
  ss <- unlist(regmatches(all, r))
  ss <- gsub("\\{|\\}", "", ss)

  all_exist <- all(ss %in% names(x))
  if(!all_exist){
    missing <- ss[!ss %in% names(x)]
    names(missing) <- NULL
    stop("Undefined statistics referenced: ", paste(missing, collapse = ", "))
  }

  # prepare values
  for(i in names(x)){
    assign(i, atable_options("format_numbers")(x[i]))
  }

  vals <- sapply(all, function(y) glue::glue(y))

  out <- data.frame(
    tag = factor(names(vals), levels = names(vals)),
    value = vals,
    stringsAsFactors = FALSE,
    row.names = NULL)
  # the factor needs levels for the non-alphabetic order
  return(out)
}



#' @export
#' @describeIn format_statistics.numeric_stats
format_statistics.numeric_stats_np <- function(x,
            numstats_np = 3,
            missingformat_np = c("Valid (missing)" = "{Nvalid} ({Nmissing})"),
            ...){

  out <- format_statistics.numeric_stats(x,
            numstats = numstats_np,
            missingformat = missingformat_np, ...)

  return(out)
}


