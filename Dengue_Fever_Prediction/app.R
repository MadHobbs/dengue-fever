#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "Basic dashboard"),
  ## Sidebar content
  dashboardSidebar(
    sidebarMenu(
      menuItem("Input Predictions For One Week", tabName = "input_one_observation", icon = icon("cog", lib = "glyphicon")),
      menuItem("Input Data Table", tabName = "input_df", icon = icon("th"))
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
                                      value = NA)
              
              ), 
              mainPanel()
              )
      ),
      
      # Second tab content
      tabItem(tabName = "input_df",
              # Copy the line below to make a file upload manager
              fileInput("file", label = h3("Select data file"))
      )
    )
  )
)

server <- function(input, output) {
  set.seed(122)
  histdata <- rnorm(500)
  
  output$plot1 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
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

