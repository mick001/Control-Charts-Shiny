# Imports
require(shiny)
require(ggplot2)
require(dplyr)

# Load auxiliary functions (local and the chartconstant package which is not on CRAN)
source("build_charts_functions.R", local = TRUE)
source("plot_functions.R", local = TRUE)
source("https://raw.githubusercontent.com/mick001/chartconstants/master/chartconstants/R/auxiliary_functions.R")
source("https://raw.githubusercontent.com/mick001/chartconstants/master/chartconstants/R/constant_functions.R")
source("https://raw.githubusercontent.com/mick001/chartconstants/master/chartconstants/R/main_function.R")

# Default df
default_df <- mtcars

################################################################################
#' Shiny User interface function
#'
#' @param ... shiny objects
#' @importFrom shiny fluidPage sidebarLayout sidebarPanel tags p fileInput selectInput
#' @importFrom shiny numericInput uiOutput mainPanel plotOutput dataTableOutput
#' @export
#'

ui <- fluidPage(
    
    # Use sidebar layout
    sidebarLayout(
        
        sidebarPanel(
    
            # Header1
            tags$h1("Control chart utility"),
            # Paragraph 1
            p("Upload your data in .csv format and plot the selected variable in a control chart."),
    
            # Input file
            # Default size limit is 5 MB
            fileInput(inputId = "uploaded_file",
                      label = "Upload a .csv file:"),
    
            # Select chart type
            selectInput(inputId = "plot_type",
                        label = "Select the type of control chart:",
                        choices = c("xbar_s", "s")),

            # Select group size
            numericInput(inputId = "group",
                         label = "Group size:",
                         value = 2,
                         min = 2,
                         step = 1),
    
            # Select number of sigmas for chart boundaries
            numericInput(inputId = "n_sigma",
                         label = "Number of sigmas for control limits:",
                         value = 3,
                         min = 1,
                         max = 10,
                         step = 0.25),
    
            # Available variables
            uiOutput('variables')
    
        ),
    
        mainPanel(
            # Chart plot
            plotOutput(outputId = "chartplot"),
    
            # Table output
            dataTableOutput("data_table")
        )
    )
)

################################################################################
#' Shiny server function
#'
#' @param input input
#' @param output output
#' @importFrom shiny reactive renderUI selectInput renderPlot
#' 
#' @export
#'

server <- function(input, output)
{
    # Load file reactive
    load_file <- reactive({
        file <- input$uploaded_file
        file
    })
    
    # Get variables names reactive
    get_var_names <- reactive({
        file <- load_file()
        if( is.null(file) )
        {
            var_names <- names(default_df)
            
        }else
        {
            var_names <- names(read.csv(file$datapath))
            var_names
        }
    })
    
    # Render available variables to be used
    output$variables <- renderUI({
        choices <- get_var_names()
        selectInput(inputId = "my_var", label = "Choose variable:", choices = choices)
    })
   
    # Render plot
    output$chartplot <- renderPlot({
        
        # Load file
        file <- load_file()

        if( is.null(file) )
        {
            data <- default_df
        }else
        {
            data <- read.csv(file$datapath)
        }
        
        y <- input$my_var
            
        data <- data %>% select_(.dots = list(y = y))
        # Return chart data
        plot_data <- control_chart(type = input$plot_type,
                                   data = data,
                                   group = input$group,
                                   n_sigma = input$n_sigma)
            # Return plot
        pl <- plot_chart(plot_data = plot_data, y)
        # Print out plot
        print(pl)
    })
    
    # Data table
    output$data_table <- renderDataTable({
        
        # Load file
        file <- load_file()
        
        if( is.null(file) )
        {
            data <- default_df
        }else
        {
            data <- read.csv(file$datapath)
        }

        y <- input$my_var

        data <- data %>% select_(.dots = list(y = y))
            
        # Return chart data
        plot_data <- control_chart(type = input$plot_type,
                                   data = data,
                                   group = input$group,
                                   n_sigma = input$n_sigma)
        # Format data as data.frame
        out_df <- as.data.frame(plot_data)
        # Return to table
        out_df
    })
}

# Run Shiny app
shinyApp(ui = ui,
         server = server)
