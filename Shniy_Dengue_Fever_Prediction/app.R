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
library(tidyverse)

load(file = "sj_model.rda",.GlobalEnv)
load(file = "iq_model.rda",.GlobalEnv)

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
              h4("Input as many rows as you like. 
                 Each row will get passed into our random forest model 
                 which will predict the number of Dengue Fever cases for 
                 a week with the conditions you enter. Our model was trained
                 on data from NOAA's Dengue Fever Prediction page (sourced through Driven Data). "),
              h4("You must enter a value for all variables. For climate data,
                  visit Weather Underground API. For the current Normalized Difference Vegetation
                  Index (NDVI), 
                  visit https://www.ncdc.noaa.gov/cdr/terrestrial/normalized-difference-vegetation-index"),
              hr(),
              
              sidebarLayout(
                
                sidebarPanel(
                checkboxGroupInput("which_city", label = h3("Which City?"), 
                                     choices = list("San Juan, Puerto Rico" = "sj", "Iquitos, Ecuador" = "iq"), 
                                     selected = 0),
                numericInput(inputId = "precipitation_amt_mm", 
                             label = "Week's Total Precipitation (mm)", 
                             value = 0, min = 0), 
                numericInput(inputId = "precip_lag", 
                             label = "12 Weeks Ago Total Precipitation (mm)", 
                             value = 0, min = 0), 
                numericInput(inputId = "station_avg_temp_c", 
                                     label = "Week's Average Temperature (degrees C)", 
                                     value = 0),
                numericInput(inputId = "temp_lag", 
                             label = "12 Weeks Ago Average Temperature (degrees C)", 
                             value = 0),
                numericInput(inputId = "relative_humidity_percent", 
                             label = "Week's Average Relative Humidity Percent", 
                             value = 0, min = 0, max = 100), 
                numericInput(inputId = "humidity_lag", 
                             label = "12 Weeks Ago Average Relative Humidity Percent", 
                             value = 0, min = 0, max = 100), 
                numericInput(inputId = "ndvi_ne", 
                             label = "NDVI NE", 
                             value = 0, min = -1, max = 1),
                numericInput(inputId = "ndvi_nw", 
                             label = "NDVI NW", 
                             value = 0, min = -1, max = 1),
                numericInput(inputId = "ndvi_se", 
                             label = "NDVI SE", 
                             value = 0, min = -1, max = 1),
                numericInput(inputId = "ndvi_sw", 
                             label = "NDVI SW", 
                             value = 0, min = -1, max = 1),

                hr(),
                actionButton("addrow", "Add Row"),
                actionButton("revrow", "Remove Row")
              
              ), 
              mainPanel(
                h1("Predictions"),
                hr(),
                hr(),
                dataTableOutput("predictions")
              )
              )
              
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
  
  pred_values <- reactiveValues()
  
  pred_values$DT <- data.frame(predicted_num_cases = NA,
    which_city =  NA,
    precipitation_amt_mm =  NA,
    precip_lag =  NA,
    station_avg_temp_c =  NA,
    temp_lag =  NA,
    relative_humidity_percent =  NA,
    humidity_lag =  NA,
    ndvi_ne =  NA,
    ndvi_nw =  NA,
    ndvi_se =  NA,
    ndvi_sw =  NA,
    stringsAsFactors = FALSE)
  
  newEntry <- observeEvent(input$addrow, {
    preds <- c
    newLine <- data.frame(
      precipitation_amt_mm = input$precipitation_amt_mm,
      precip_lag = input$precip_lag,
      station_avg_temp_c = input$station_avg_temp_c,
      temp_lag = input$temp_lag,
      relative_humidity_percent = input$relative_humidity_percent,
      humidity_lag = input$humidity_lag,
      ndvi_ne = input$ndvi_ne,
      ndvi_nw = input$ndvi_nw,
      ndvi_se = input$ndvi_se,
      ndvi_sw = input$ndvi_sw)
    
    if(input$which_city == "sj") {
      newPredLine <- c(predict(sj_model, newLine), input$which_city, 
                       input$precipitation_amt_mm, 
                       input$precip_lag, input$station_avg_temp_c,
                       input$temp_lag, input$relative_humidity_percent, input$humidity_lag,
                       input$ndvi_ne, input$ndvi_nw, input$ndvi_se, input$ndvi_sw)
    } 
    else if (input$which_city == "iq") {
      newPredLine <- c(predict(iq_model, newLine), input$which_city, 
                       input$precipitation_amt_mm, 
                       input$precip_lag, input$station_avg_temp_c,
                       input$temp_lag, input$relative_humidity_percent, input$humidity_lag,
                       input$ndvi_ne, input$ndvi_nw, input$ndvi_se, input$ndvi_sw)
    }
    else {
      newPredLine <- c()
    }
    
    pred_values$DT <- rbind(pred_values$DT, newPredLine)
  })
  
  newEntry <- observeEvent(input$revrow, {
    deleteLine <- pred_values$DT[-nrow(pred_values$DT), ]
    pred_values$DT <- deleteLine
  })
  
  output$predictions <- renderDataTable({pred_values$DT})
}

shinyApp(ui = ui, server = server)

