#' Format factors as `X (X%)` instead of `X% (X)`
#'
#'Almost an exact copy of the equivilent function from `atable`,
#'this function just formats factors as e.g. 15 (25%) rather than
#'25% (15) as `atable` does.
#'
#' @param x
#' @param format_statistics.statistics_factor
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
format_statistics.statistics_factor <- function (x,
              format_statistics.statistics_factor = NULL,
              ...) {

  nn <- names(x)
  value <- unlist(x)
  total <- sum(value)
  percent <- 100 * value/total
  value <- paste0(atable_options("format_numbers")(value),
                  "(", atable_options("format_percent")(percent),
                  "%)")
  format_statistics_out <- data.frame(tag = factor(nn, levels = nn),
                                      value = value, row.names = NULL,
                                      stringsAsFactors = FALSE,
                                      check.names = FALSE,
                                      fix.empty.names = FALSE)
  return(format_statistics_out)
}







#' Format summary statistics for numeric variables when using `numeric_stats`
#'
#' format_statistics.numeric_stats can use any statistic returned by `numeric_stats`.
#'
#' @param x `numeric_stats` object
#' @param numstats either a number (1 to 3, referring to the defaults in the order printed) or a named character of the format shown above (i.e. 'Text to print in table' = '{variable1 to use} ({variable2 to use})'). Defaults to `"Mean (SD)" = "{mean} ({sd})"`, equivilent to 1.
#' @param missingformat either a logical or a named string defining the format
#' @param ...
#' @details
#' All numbers are formatted by the function in `atable_options("format_numbers")`.
#' To use a different method, reassign that function.
#'
#' Options `numstats` and `missingformat` use the `glue` package to create strings.
#' Although `glue` parses the values within the braces (`{`), this is not permitted
#' in this case as only strings are passed to `glue`.
#'
#' @return
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
#'
format_statistics.numeric_stats <- function(x,
                                            numstats = c("Mean (SD)" = "{mean} ({sd})",
                                                         "Min - Max" = "{q0} - {q1}",
                                                         "Median [Quartiles]" = "{q0.5} [{q0.25}; {q0.75}]")[1],
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
  if(!is.logical(missingformat) & !is.character(missingformat)) stop("Unexpected class of missingformat")
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
