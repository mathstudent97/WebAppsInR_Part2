#####################################

# Building an ML / Data-Driven       # 
#Web Application in R                #

# This app aims to build an          #
#Iris Predictor which deploys an     #
#ML model of the Iris dataset.       #
# Again, using the Shiny Web App     # 
#framework                           #
            

# Check out uploaded pdf(s) for more #
#info.                               #


# See References in pdf              #

######################################


library(shiny)
library(data.table)
library(randomForest)


# Read in the Random Forest model
model <- readRDS("model.rds")


###########################
##### User Interfrace #####
###########################

ui <- pageWithSidebar(
    
    # Page header
    headerPanel('Iris Predictor'),
    
    # Input Values
    sidebarPanel(
        #HTML("<h3>Input parameters</h3>"),
        tags$label(h3('Input parameters')),
        numericInput("Sepal.Length",
                     label = "Sepal Length",
                     value = 5.1),
        numericInput("Sepal.Width", 
                     label = "Sepal Width",
                     value = 3.6),
        numericInput("Petal.Lenth",
                     label = "Petal Length",
                     value = 1.4),
        numericInput("Petal.Width",
                     label = "Petal Width",
                     value = 0.2),
        
        actionButton("submitbutton", "Submit",
                     class = "btn btn-primary")
        
 ),
 
 mainPanel(
     tags$label(h3('Status/Output')), # Status/Output Text Box
     verbatimTextOutput('contents'),
     tableOutput('tabledata') # Prediction results table
     
  )
)



##################
##### Server #####
##################

server <- function(input, output, session) {
    
    # Input Data
    datasetInput <- reactive({
        
        df <- data.frame(
            Name = c("Sepal Length",
                     "Sepal Width",
                     "Petal Length",
                     "Petal Width"),
            Value = as.character(c(input$Sepal.Length,
                                   input$Sepal.Width,
                                   input$Petal.Length,
                                   input$Petal.Width)),
            stringsAsFactors = FALSE)
        
        Species <- 0
        df <- rbind(df, Species)
        input <- transpose(df)
        write.table(input, "input.csv", sep = ",", quote = FALSE, row.names = FALSE, col.names = FALSE)
        
        test <- read.csv(paste("input", ".csv", sep=""), header = TRUE)
        
        Output <- data.frame(Prediction = predict(model, test), round(predict(model, test, type="prob"), 3))
        print(Output)
        
    })
        
    # Status/Output Text Box
    output$contents <- renderPrint({
        if (input$submitbutton > 0) {
            isolate("Calculation complete.")
        } else {
            return("Server is ready for calculation")
        }
    })
    
    # Prediction Results Table
    output$tabledata <- renderTable({
        if (input$submitbutton > 0) {
            isolate(datasetInput())
        }
    })
    
    
 } 
    

# Run the application 
# recall this is the 3rd component; fusion of the ui and server
#components
shinyApp(ui = ui, server = server)
