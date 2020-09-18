#' Apply numeric_np class to a numeric variable
#'
#' To allow \code{atable} to return different statistics for different variables
#' of the same type (e.g. we want some variables to be formatted as
#' \code{Mean (SD)} and others as \code{Median [IQR]}), they need to be passed
#' to \code{atable} as different classes.
#'
#' @param x
#'
#' @return
#' @export
#'
#' @examples
#' data(mtcars)
#' mtcars$wt_np <- as.numeric_np(mtcars$wt)
#'
as.numeric_np <- function(x){
  if(!"numeric" %in% class(x))
    stop("Not a numeric")
  if(!"numeric_np" %in% class(x))
    class(x) <- c("numeric_np", class(x))
  x
}


# subsetting function
'[.numeric_np' <- function(x, i, j, ...){
  y <- unclass(x)[i, ...]
  class(y) <- c("numeric_np", class(y))
  y
}
















