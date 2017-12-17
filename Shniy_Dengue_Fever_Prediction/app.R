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
library(lubridate)
library(dplyr)
library(ggplot2)
library(rwunderground)
library(httr)
require(stats)
library(stats)
library(curl)
library(randomForest)
library(caret)

#library(tidyverse)
#library(mnormt)

#library(XML)
#library(gridExtra)
#library(rappdirs)
#library(xml2)
#library(hoardr)
#library(rnoaa)

lag_num_weeks <- 12

set_api_key("a483d97cf372d5c9")

load(file = "sj_model.rda",.GlobalEnv)
load(file = "iq_model.rda",.GlobalEnv)


#get default values
IQ_ne <- 0.26364
IQ_nw <- 0.23297
IQ_se <- 0.24980
IQ_sw <- 0.26214

SJ_ne <- 0.05770
SJ_nw <- 0.06808
SJ_sw <- 0.16597
SJ_se <- 0.17719


computerToday <- format(Sys.Date(), "%Y%m%d")


#ghcnd(stationid = "SPQT")


#shiny app
ui <- dashboardPage(
  
  dashboardHeader(title = "Predicting Dengue"),
  
  ## Sidebar content
  dashboardSidebar(
    sidebarMenu(
      menuItem("Our model", tabName = "our_model", icon = icon("world")),
      menuItem("Input Data", tabName = "input_one_observation", icon = icon("hand-right", lib = "glyphicon")),
      img(src="wundergroundLogo_4c_rev.png", align = "center", width = 200)
      
    )
  ),
  dashboardBody(
    
    tabItems(
      # First tab content
      tabItem(tabName = "our_model",
              h2("Predicting Weekly Dengue Fever Cases"),
              h3("San Juan, Puerto Rico and Iquitos, Ecuador"),
              dataTableOutput("our_sj_table"),
              img(src="dengue.jpg", width = 500),
              h4("We present two random forest models trained separately on weekly dengue fever cases  
                 and environmental predictors for San Juan, Puerto Rico and Iquitos, Perú. The
                 data comes from NOAA's Dengue Fever Prediction page (sourced through Driven Data) and
                 contain data from 1990 to 2008 (San Juan) and 2000 to 2010 (Iquitos). 
                 These models 
                 use weekly average temperature, relative humidity, total precipitation, and
                 Normalized Difference Vegetation Index (NDVI). We also incorporate 12-week time lagged
                 average temperature, relative humidity, and total precipitation."),
              h4("See the plots below for comparisons of our predicted values and the acutal values.
                 The San Juan model yielded an RMSE of 27.5 and the Iquitos model yielded an RMSE of 3.87. 
                 Note that Iquitos tended to have fewer cases per week than San Juan."),
              fluidRow(
                img(src="Iquitos.png", width = 400),
                img(src="SanJuan.png", align= "right", width = 400)
              )
              ),
      # Second tab content
      tabItem(tabName = "input_one_observation",
              
              h2("Input Predictors"),
              h4("Select one city at a time with the check boxes."),              
              h4("You must enter a value for all variables if you choose to manually enter data. To find current Normalized Difference Vegetation
                 Index (NDVI), vist NOAA (https://www.ncdc.noaa.gov/cdr/terrestrial/normalized-difference-vegetation-index)."),
              h4("If you choose the 'Entered Date' option, weather data will be collected from 
                 WeatherUnderground (https://www.wunderground.com/). 
                 and the NDVI used will be the average from the training data"),
              h4("Input as many rows as you like. 
                 Each row will get passed into our random forest model 
                 which will predict the number of Dengue Fever cases for 
                 a week with the conditions you enter."),
              hr(),
              
              sidebarLayout(
                
                sidebarPanel(
                  checkboxGroupInput("which_city", label = h3("Which City?"), 
                                     choices = list("San Juan, Puerto Rico: Manual" = "sj", "Iquitos, Ecuador: Manual" = "iq", "San Juan, Puerto Rico: Entered Date" = "sj2", "Iquitos, Ecuador: Entered Date" = "iq2" ), 
                                     selected = "sj"),
                  numericInput(inputId = "now", 
                               label = "Date of preditction (YYYYMMDD)", 
                               value = computerToday, min = 0),
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
  
  output$predictions <- renderDataTable({pred_values$DT}, options = list(scrollX = TRUE))
  
  
  newEntry <- observeEvent(input$addrow, {
    preds <- c()
    if(input$which_city == "sj" | input$which_city == "iq") {
      
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
    }
    else if(input$which_city == "sj2") {
      todayDate <-input$now
      startWeek <- format(as.Date(as.character(todayDate), format="%Y%m%d")-days(5), "%Y%m%d")
      lagDate <- format(as.Date(as.character(todayDate), format="%Y%m%d")-weeks(lag_num_weeks), "%Y%m%d")
      starWeekLag <- format(as.Date(lagDate, format="%Y%m%d")-days(5), "%Y%m%d")
      
      SJlocation <- set_location(airport_code = "SJT")
      
      dayDataSJ <- history_range(location = SJlocation, startWeek, as.character(todayDate), use_metric = T)
      lagDataSJ <- history_range(location = SJlocation, starWeekLag, lagDate, use_metric = T)
      
      dayDataSJ[is.na(dayDataSJ)] <- 0
      lagDataSJ[is.na(lagDataSJ)] <- 0
      
      dayTempSJ <- mean(dayDataSJ$temp)
      dayHumidSJ <- mean(dayDataSJ$hum)
      dayPrecipSJ <- 10*sum(dayDataSJ$precip)
      
      tempLagSJ <- mean(lagDataSJ$temp)
      humidLagSJ <- mean(lagDataSJ$hum)
      precipLagSJ <- 10*sum(lagDataSJ$precip)
      
      newLine <- data.frame(
        precipitation_amt_mm = dayPrecipSJ,
        precip_lag = precipLagSJ,
        station_avg_temp_c = dayTempSJ,
        temp_lag = tempLagSJ,
        relative_humidity_percent = dayHumidSJ,
        humidity_lag = humidLagSJ,
        ndvi_ne = SJ_ne,
        ndvi_nw = SJ_nw,
        ndvi_se = SJ_se,
        ndvi_sw = SJ_sw)
    }
    else if(input$which_city == "iq2") {
      todayDate <-input$now
      startWeek <- format(as.Date(as.character(todayDate), format="%Y%m%d")-days(5), "%Y%m%d")
      lagDate <- format(as.Date(as.character(todayDate), format="%Y%m%d")-weeks(lag_num_weeks), "%Y%m%d")
      startWeekLag <- format(as.Date(lagDate, format="%Y%m%d")-days(5), "%Y%m%d")
      
      IQlocation <- set_location(airport_code = "IQT")
      
      dayDataIQ <- history_range(location = IQlocation, startWeek, as.character(todayDate), use_metric = T)
      lagDataIQ <- history_range(location = IQlocation, startWeekLag, lagDate, use_metric = T)
      
      dayDataIQ[is.na(dayDataIQ)] <- 0
      lagDataIQ[is.na(lagDataIQ)] <- 0
      
      dayTempIQ <- mean(dayDataIQ$temp)
      dayHumidIQ <- mean(dayDataIQ$hum)
      dayPrecipIQ <- 10*sum(dayDataIQ$precip)
      
      tempLagIQ <- mean(lagDataIQ$temp)
      humidLagIQ <- mean(lagDataIQ$hum)
      precipLagIQ <- 10*sum(lagDataIQ$precip)
      
      newLine <- data.frame(
        precipitation_amt_mm = dayPrecipIQ,
        precip_lag = precipLagIQ,
        station_avg_temp_c = dayTempIQ,
        temp_lag = tempLagIQ,
        relative_humidity_percent = dayHumidIQ,
        humidity_lag = humidLagIQ,
        ndvi_ne = IQ_ne,
        ndvi_nw = IQ_nw,
        ndvi_se = IQ_se,
        ndvi_sw = IQ_sw)
    }
    
    if(input$which_city == "sj") {
      newPredLine <- c(as.numeric(stats::predict(sj_model, newLine)[1]), input$which_city,
                       input$precipitation_amt_mm,
                       input$precip_lag, input$station_avg_temp_c,
                       input$temp_lag, input$relative_humidity_percent, input$humidity_lag,
                       input$ndvi_ne, input$ndvi_nw, input$ndvi_se, input$ndvi_sw)
    }
    else if (input$which_city == "iq") {
      newPredLine <- c(as.numeric(stats::predict(iq_model, newLine)[1]), input$which_city, 
                       input$precipitation_amt_mm, 
                       input$precip_lag, input$station_avg_temp_c,
                       input$temp_lag, input$relative_humidity_percent, input$humidity_lag,
                       input$ndvi_ne, input$ndvi_nw, input$ndvi_se, input$ndvi_sw)
    }
    else if (input$which_city == "iq2"){
      newPredLine <- c(as.numeric(stats::predict(iq_model, newLine)[1]), "iq", 
                       dayPrecipIQ, 
                       precipLagIQ, dayTempIQ,
                       tempLagIQ, dayHumidIQ, humidLagIQ,
                       IQ_ne, IQ_nw, IQ_se, IQ_sw)
    }
    else if (input$which_city == "sj2"){
      newPredLine <- c(as.numeric(stats::predict(sj_model, newLine)[1]), "sj", 
                       dayPrecipSJ, 
                       precipLagSJ, dayTempSJ,
                       tempLagSJ, dayHumidSJ, humidLagSJ,
                       SJ_ne, SJ_nw, SJ_se, SJ_sw)
    }
    else {
      newPredLine <- c()
    }
    
    pred_values$DT <- isolate(rbind(pred_values$DT, newPredLine))
  })
  
  newEntry <- observeEvent(input$revrow, {
    deleteLine <- pred_values$DT[-nrow(pred_values$DT), ]
    pred_values$DT <- deleteLine
  })
  
  
}

shinyApp(ui = ui, server = server)

