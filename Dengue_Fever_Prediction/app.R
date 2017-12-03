#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Code to read in input to form data frame by Eric Hung, via Stack Overflow.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "Predicting Dengue"),
  ## Sidebar content
  dashboardSidebar(
    sidebarMenu(
      menuItem("Input Predictions For One Week", tabName = "input_one_observation", icon = icon("cog", lib = "glyphicon")),
      menuItem("Input Data Table", tabName = "input_df", icon = icon("table"))
    )
  ),
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "input_one_observation",
              
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
                dataTableOutput("table"),
                hr(),
                h3("Predictions"),
                dataTableOutput("prediction_table")
                
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
  
 # output$print <- renderPrint({ input$week_of_year })
  
 # output$table <- renderDataTable({
    #data <- data.frame(input$week_of_year, input$avg_temp, input$total_precip)
    #colnames(data) = c("week_of_year", "avg_temp", "total_precip")
    #data
   # })
  #
 # output$results <- output$table$week_of_year
  
  #output$table_file <- renderDataTable(read.csv(input$file))
  
  #histdata <- data.frame(input$week_of_year, input$avg_temp, input$total_precip)

 # })
}


#ui <- fluidPage(
   
   # Application title
   #titlePanel("Use Our Model To Predict Dengue Fever"),
   #tags$img(height = 100, width = 100, scr = "dengue.jpg"),
   
   # Sidebar with a slider input for number of bins 
   #sidebarLayout(
    
     # sidebar
   #   sidebarPanel(
    #    
    #    tags$h3("Input Variables"),
    #    tags$hr(),
        
        # make default values be averages from our data
     #    sliderInput(inputId = "week_of_year", 
     #                 label = "Week of Year (1 to 52)", 
     #                 value = 1, min = 1, max = 52), 
     #    numericInput(inputId = "avg_temp", 
              #        label = "Week's Average Temperature (degrees C)", 
              #        value = NA),
       #  numericInput(inputId = "total_precip", 
             #         label = "Week's Total Precipitation (mm)", 
             #         value = NA),
        # numericInput(inputId = "total_precip", 
              #        label = "Week's Total Precipitation (mm)", value = NA),
         #actionButton(inputId = "go", label = "Submit")
        
        
     # ),
      
      # Show a plot of the generated distribution
     # mainPanel(
       #  plotOutput("hist")
     # )
  # )
   
#)

# Define server logic required to draw a histogram
#server <- function(input, output) {
  
  #data <- eventReactive(input$go, {rnorm(input$week_of_year)})
  
  # output$hist <- renderPlot({
   #  hist(data())
   #})
#}

# Run the application 
shinyApp(ui = ui, server = server)

