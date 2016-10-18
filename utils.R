#' Computes  max(x) - min(x)
#'
#' @param x numeric vector
#' @param ... other numeric vectors
#' @return A numeric vector of length one
#' @examples
#' diff_range(x = 1:5)
#' diff_range(x = c(1:5, NA), na.rm = TRUE)
#' @export
#'
diff_range <- function(x, ...) {diff(range(x, ...))}
