################################################################################
#' Plot chart function
#' 
#' This function plots the control chart
#'
#' @param plot_data a dataframe object
#' @param plot_type type of plot
#' @param var_name variable name
#' @importFrom ggplot2 ggplot geom_line geom_point labs
#' @return a ggplot object (plot)
#' 
#' @export
#' 

plot_chart <- function(plot_data, plot_type, var_name)
{
    # Plot the chart
    pl <- ggplot(plot_data, aes(x, data_points)) + geom_point(colour = "green", size = 6)
    pl <- pl + 
        geom_line(aes(x, data_points, colour = "Data points trace"), data = plot_data) +
        geom_line(aes(x, center, colour = "Center"), data = plot_data, lwd = 2) +
        geom_line(aes(x, lcl, colour = "LCL"), data = plot_data, lwd = 2) +
        geom_line(aes(x, ucl, colour = "UCL"), data = plot_data, lwd = 2) +
        
        # Add legend
        scale_colour_manual(values = c("navyblue", "blue", "red", "red")) +
        # Add labels and title
        labs(title = paste("Control chart displayed:", plot_type) ,x = "Group", y = var_name)
    
    return(pl)
}
