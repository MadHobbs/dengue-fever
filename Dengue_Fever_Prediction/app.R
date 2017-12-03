#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Code to read in input to form data frame by Eric Hung, via Stack Overflow.
# Find it here: 
#   https://stackoverflow.com/questions/36342833/r-input-value-by-user-to-dataframe-via-shiny
#
# Find out more about building applications with Shiny here:
#    http://shiny.rstudio.com/
#

library(shiny)

library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "Predicting Dengue"),
  ## Sidebar content
  dashboardSidebar(
    sidebarMenu(
      menuItem("Manually Input Data", tabName = "input_one_observation", icon = icon("hand-right", lib = "glyphicon")),
      menuItem("Input Data Table", tabName = "input_df", icon = icon("table"))
    )
  ),
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "input_one_observation",
              
              h2("Manually Input Predictors"),
              h4("Input as many rows as you like. Each row will get passed into our random forest model which will predict the number of Dengue Fever cases for a week with the conditions you enter.
                 See 'Results' at the end bottom of the page."),
              h4("You must enter a value for all variables."),
              hr(),
              
              sidebarLayout(
                
                sidebarPanel(
                  
                sliderInput(inputId = "week_of_year", 
                                             label = "Week of Year (1 to 52)", 
                                             value = 1, min = 1, max = 52), 
                numericInput(inputId = "avg_temp", 
                                     label = "Week's Average Temperature (degrees C)", 
                                     value = NA),
                numericInput(inputId = "total_precip", 
                                      label = "Week's Total Precipitation (mm)", 
                                      value = NA), 
                hr(),
                actionButton("addrow", "Add Row"),
                actionButton("revrow", "Remove Row")
              
              ), 
              mainPanel(
                dataTableOutput("table")
              )
              ),
              
              h3("Results"),
              dataTableOutput("prediction_table")
      ),
      
      # Second tab content
      tabItem(tabName = "input_df",
              # Copy the line below to make a file upload manager
              fileInput("file", label = h3("Select data file")),
              dataTableOutput("table_file")
      )
    )
  )
)

server <- function(input, output, session) {
  
  values <- reactiveValues()
  
  values$DT <- data.frame(week_of_year = NA,
                          avg_temperature = NA,
                          total_precipitation = NA,
                          stringsAsFactors = FALSE)
  
  newEntry <- observeEvent(input$addrow, {
    newLine <- c(input$week_of_year, input$avg_temp, input$total_precip)
    values$DT <- rbind(values$DT, newLine)
  })
  
  newEntry <- observeEvent(input$revrow, {
    deleteLine <- values$DT[-nrow(values$DT), ]
    values$DT <- deleteLine
  })
  
  output$table <- renderDataTable({
    values$DT
  })
}

shinyApp(ui = ui, server = server)

