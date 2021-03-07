######################################

# Building a ML / Data-Driven        # 
#Web Application in R                #
# Code Part 2                        #

# This app aims to build an          #
#Iris Predictor which deploys a      #
#ML model of the Iris dataset.       #
# This will again, be created using  #
#the Shiny Web App framework         # 

# Check out the  uploaded pdf(s) for #
#more info. and explanations         #
#regarding the code and application  #  
#itself.                             #

# See References in the pdf(s)       #

######################################


library(shiny)
library(data.table)
library(randomForest)




# After initially deploying the predictive model
#in an RDS file (in 'model' file), the line below
#reads-in the Random Forest model.
# This model will be used for making the prediction.
model <- readRDS("model.rds")
# Assign to 'model' object.



# Recall the three components:
#1. UI
#2. Server
#3. Shiny App Function (will piece together / combine the UI & Server)

###########################
##### User Interfrace #####
###########################


ui <- pageWithSidebar(
    
    
    # Page header.
    headerPanel('Iris Predictor Numeric App'),
    
    
    # Input values.
    # After running the app, you will see this sidebar panel on the left.
    # These input values below are the input parameters.
    sidebarPanel(
        HTML("<h3>Input parameters</h3>"),
        #tags$label(h3('Input parameters')),
        numericInput("Sepal.Length", 
                     label = "Sepal Length", 
                     value = 5.1),
        numericInput("Sepal.Width", 
                     label = "Sepal Width", 
                     value = 3.6),
        numericInput("Petal.Length", 
                     label = "Petal Length", 
                     value = 1.4),
        numericInput("Petal.Width", 
                     label = "Petal Width", 
                     value = 0.2),
        
        actionButton("submitbutton", "Submit", 
                     class = "btn btn-primary")
    ),
    
    # After running the app, you will see this main panel on the right.
    # Once 'Submit' is selected, the input parameters will be sent
    #to the server function.
    # And the server will use these input parameters and send it to the predictive
    #model (Random Forest Model) to make a prediction.
    # Once the prediction has been made, the generated output value
    #will then be sent back into the main panel.
    mainPanel(
        tags$label(h3('Status / Output')), # Status / Output Text Box.
        verbatimTextOutput('contents'),
        tableOutput('tabledata') # This comes from the prediction results table.
        # The results will be displayed in 'tabledata'
        #(below the text message in the app).
        
    )
)



##################
##### Server #####
##################


server<- function(input, output, session) {
    
    
    # Input Data / Input Parameters.
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
            # These are the input parameter values from the UI.
            stringsAsFactors = FALSE)
        
        
        Species <- 0
        df <- rbind(df, Species)
        input <- transpose(df)
        # Three lines above help create a data frame.
        
        write.table(input,"input.csv", sep=",", quote = FALSE, row.names = FALSE, col.names = FALSE)
        # Write the data frame as an output csv file.
        
        test <- read.csv(paste("input", ".csv", sep=""), header = TRUE)
        # Will read back in the csv file and put it in the 'test' object.
        
        # Create an output onject.
        Output <- data.frame(Prediction=predict(model,test), 
                             # A data frame will be created.
                             # Apply the 'Prediction' function in order to make a prediction
                             #using the random forest model on the input 'test' data.
                             round(predict(model,test,type="prob"), 3))
        # Once the prediction has been made, the probability will also be stated in 3 digits.
        print(Output)
        # The prediction will be sent to the 'Output' object & will be printed out.
        # It will be representing the 'dataSetInput'.
        
    })
    # Generally, the csv file containing the input parameters will be generated using the code above
    
    
    # Status/Output Text Box.
    output$contents <- renderPrint({
        if (input$submitbutton>0) { 
            isolate("Calculation complete.") 
        } else {
            return("Server is ready for calculation.")
        }
    })
    
    
    # Prediction results table
    # Prediction results will be sent to 'output$tabledata'
    output$tabledata <- renderTable({
        if (input$submitbutton>0) { 
            isolate(datasetInput()) # refer to line 138
            # The prediction result will be inserted here 'isolate(datasetInput)'.
            # This will be sent to the main panel in the UI to be displayed;
            #specifically, 'tableData'.
        } 
    })
    
}

# Generally, this shows the output prediction results

##############################
#### Create the shiny app ####             
##############################


shinyApp(ui = ui, server = server)
