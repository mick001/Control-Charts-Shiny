################################################################################
#' xbar-s chart function
#' 
#' This function builds a xbar-s control chart
#'
#' @param data a dataframe object
#' @param group_size
#' @param n_sigma
#' @importFrom dplyr %>% mutate group_by summarise
#' @return a dplyr dataframe object
#' 
#' @export

xbar_s <- function(data, group_size, n_sigma)
{
    # Number of samples
    samples <- dim(data)[1]
    # Group data and summarise
    out <- data %>%
        mutate(group = rep(1:samples, each = group_size, length = samples)) %>%
        group_by(group) %>%
        summarise(data_points = mean(y))
    # Build control chart
    out <- out %>% mutate(x = row_number(),
                          center = mean(data_points),
                          lcl = center - n_sigma * sd(data_points),
                          ucl = center + n_sigma * sd(data_points))
    return(out)
}

################################################################################
#' xbar-r chart function
#' 
#' This function builds a xbar-r control chart
#'
#' @param data a dataframe object
#' @param group_size
#' @param n_sigma
#' @importFrom dplyr %>% mutate group_by summarise
#' @return a dplyr dataframe object
#' 
#' @export

xbar_r <- function(data, group_size, n_sigma)
{
    # Number of samples
    samples <- dim(data)[1]
    # Group data and summarise
    out <- data %>%
        mutate(group = rep(1:samples, each = group_size, length = samples)) %>%
        group_by(group) %>%
        summarise(data_points = mean(y),
                  shape = diff_range(y))
    # Build control chart
    out <- out %>% mutate(x = row_number(),
                          center = mean(data_points),
                          lcl = center - n_sigma * mean(shape) / (constant(group_size, "d2") * sqrt(group_size)),
                          ucl = center + n_sigma * mean(shape) / (constant(group_size, "d2") * sqrt(group_size)) )
    return(out)
}

################################################################################
#' S chart function
#' 
#' This function builds a s control chart
#'
#' @param data a dataframe object
#' @param group
#' @param n_sigma
#' @importFrom dplyr %>% mutate group_by summarise
#' @return a dplyr dataframe object
#' 
#' @export
#'

s_ <- function(data, group_size, n_sigma)
{
    # Number of samples
    samples <- dim(data)[1]
    # Group data and summarise
    out <- data %>%
        mutate(group = rep(1:samples, each = group_size, length = samples)) %>%
        group_by(group) %>%
        summarise(data_points = sd(y))
    
    # Build control chart
    out <- out %>% mutate(x = row_number(),
                          center = mean(data_points),
                          lcl = center - n_sigma * (center * sqrt(1 - constant(group_size, "c4")**2) ) / (constant(group_size, "c4") ),
                          ucl = center + n_sigma * (center * sqrt(1 - constant(group_size, "c4")**2) ) / (constant(group_size, "c4") ))
    return(out)
}

################################################################################
#' r chart function
#' 
#' This function builds a s control chart
#'
#' @param data a dataframe object
#' @param group
#' @param n_sigma
#' @importFrom dplyr %>% mutate group_by summarise
#' @return a dplyr dataframe object
#' 
#' @export
#'

r_ <- function(data, group_size, n_sigma)
{
    # Number of samples
    samples <- dim(data)[1]
    # Group data and summarise
    out <- data %>%
        mutate(group = rep(1:samples, each = group_size, length = samples)) %>%
        group_by(group) %>%
        summarise(data_points = diff_range(y))
    
    # Build control chart
    out <- out %>% mutate(x = row_number(),
                          center = mean(data_points),
                          lcl = center - n_sigma * (center * constant(group_size, "d3")) / (constant(group_size, "d2")),
                          ucl = center + n_sigma * (center * constant(group_size, "d3")) / (constant(group_size, "d2")) )
    return(out)
}

################################################################################
#' Switch chart function
#' 
#' This function builds the appropriate control chart
#' according to the selected type
#' 
#' @param type type of chart
#' @param data a dataframe object
#' @param group_size
#' @param n_sigma
#' @return a dplyr dataframe object
#' @export
#' 

control_chart <- function(type, data, group_size, n_sigma)
{
    # Build the appropriate chart
    out_chart <- switch(type,
                        xbar_s = xbar_s(data, group_size, n_sigma),
                        xbar_r = xbar_r(data, group_size, n_sigma),
                        s = s_(data, group_size, n_sigma),
                        r = r_(data, group_size, n_sigma) )
    # Return
    out_chart
}
