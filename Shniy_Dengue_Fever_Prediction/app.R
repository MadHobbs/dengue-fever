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
library(caret)

# load data which constructs random forest model
#sj_data_for_model <- read.csv("sj_data_for_model.csv")
#iq_data_for_model <- read.csv("iq_data_for_model.csv")

# construct two random forest models
#sj_model <- train(total_cases ~ ., 
                  #data = sj_data_for_model, 
                 # method = "rf", 
                 # trControl =  trainControl(method = "oob"), 
                 # ntree = 500, 
                 # tuneGrid = data.frame(mtry = 1:12), 
                 # importance = TRUE)
#iq_model <- train(total_cases ~ ., 
               #   data = iq_data_for_model, 
               #   method = "rf", 
               #   trControl =  trainControl(method = "oob"), 
               #   ntree = 500, 
               #   tuneGrid = data.frame(mtry = 1:12), 
               #   importance = TRUE)

ui <- dashboardPage(
  dashboardHeader(title = "Predicting Dengue"),

  ## Sidebar content
  dashboardSidebar(
    sidebarMenu(
      menuItem("Our model", tabName = "our_model", icon = icon("world")),
      menuItem("Manually Input Data", tabName = "input_one_observation", icon = icon("hand-right", lib = "glyphicon")),
      menuItem("Input Data Table", tabName = "input_df", icon = icon("table"))
    )
  ),
  dashboardBody(

    tabItems(
      # First tab content
      tabItem(tabName = "our_model",
              h2("Predicting Weekly Dengue Fever Cases"),
              h3("San Juan, Puerto Rico and Iquitos, Ecuador"),
              dataTableOutput("our_sj_table")

      ),
      # Second tab content
      tabItem(tabName = "input_one_observation",
              
              h2("Manually Input Predictors"),
              h4("Input as many rows as you like. Each row will get passed into our random forest model which will predict the number of Dengue Fever cases for a week with the conditions you enter.
                 See 'Results' at the end bottom of the page."),
              h4("You must enter a value for all variables."),
              hr(),
              
              sidebarLayout(
                
                sidebarPanel(
                numericInput(inputId = "year", 
                              label = "Year", 
                              value = NA, min = 0),
                  
                sliderInput(inputId = "week_of_year", 
                                             label = "Week of Year (1 to 52)", 
                                             value = 1, min = 1, max = 52), 
                numericInput(inputId = "precipitation_amt_mm", 
                             label = "Week's Total Precipitation (mm)", 
                             value = NA), 
                numericInput(inputId = "avg_temp", 
                                     label = "Week's Average Temperature (degrees C)", 
                                     value = NA),
                numericInput(inputId = "relative_humidity_percent", 
                             label = "Relative Humidity Percent", 
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
  
  sj_data_for_model <- read.csv("sj_data_for_model.csv")
  
  output$our_sj_table <- renderDataTable({sj_data_for_model})
  
  sj_model <- train(total_cases ~ ., 
                    data = sj_data_for_model, 
                     method = "rf", 
                     trControl =  trainControl(method = "oob"), 
                     ntree = 500, 
                     tuneGrid = data.frame(mtry = 1:12), 
                     importance = TRUE)
  
  values <- reactiveValues()
  
  values$DT <- data.frame(year = NA, 
                          week_of_year = NA,
                          precipitation_amt_mm = NA,
                          avg_temp = NA,
                          relative_humidity_percent = NA,
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
  
  # impute missing values in values$DT
  #values$DT <- preProcess(values$DT)
  
  output$prediction_table <- renderDataTable(values$DT)
  
  #filedata <- reactive({
   # infile <- input$datafile
   # if (is.null(infile)) {
    #  # User has not uploaded a file yet
    #  return(NULL)
    #  data <- read.csv(infile$datapath)
    #  data
   # }
   # read.csv(infile$datapath)
    
  #})
  
  
  output$table_file <- DT::renderDataTable({input$file})
}

shinyApp(ui = ui, server = server)

