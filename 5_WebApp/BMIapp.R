######################################

# Body Mass Index (BMI) Calculator   # 
# This will calculate the BMI of     #
#those aged 20 yrs. & above.         #

# This app will again, be created    #
#using the Shiny Web App framework   # 

# Check out the  uploaded pdf for    #
#more info. and explanations         #
#regarding the code and web          #
#application itself.                 #

# See References in the pdf          #

######################################



library(shiny)
library(shinythemes)
#library(data.table)
#library(randomForest)


###########################
##### User Interface ######
###########################


ui <- fluidPage(theme = shinytheme("cyborg"),
                # 'fluidPage()' function.
                navbarPage("BMI Calculator App:",
                           # 'navbarPage()' function. 
                           # Will use title above as the name / title for the navigation bar;
                           # IOW the app's name.
                           
                           tabPanel("Home", # This is the first navigation tab name.
                                   # Input values / parameters.
                                   sidebarPanel( # Panel to the left.
                                     HTML("<h3>Input parameters</h3>"),
                                     sliderInput("height", # ID of slider input.
                                                label = "Height", # Input parameter that appears on app.
                                                value = 182, # Default value on slider.
                                                min = 40,
                                                max = 250),
                                     sliderInput("weight",
                                                label = "Weight", 
                                                value = 75, 
                                                min = 20,
                                                max = 100),
                               
                                     
                                     actionButton("submitbutton", # Initiates the calculation process.
                                               "Submit",
                                               class = "btn btn-primary")
                           ),
                           
                           mainPanel(
                               tags$label(h3('Status / Output')), # Panel to the right.
                               # Status / Output text box.
                               verbatimTextOutput('contents'), 
                               # Contains the 'contents' ID; This is from the output in the server fcn.
                               #around lines 103-110
                               tableOutput('tabledata') # Results Table.
                               # This is output in the server function as well.
                           )   # mainPanel()
                           
                 ), # tabPanel(), Home.
                 
                           tabPanel("About", # This is the second navigation tab name;
                               #beside the 'Home' tab.
                               titlePanel("About"),
                               div(includeMarkdown("about.md.txt"),
                               align = "justify")
                 ) # tabPanel(), About.
                 
        ) # navbarPage()
) # fluidPage()



##################
##### Server #####
##################


# Define server; the logic.
# Recall this is the 2nd component.

server <- function(input, output, session) {
    
    # Input data.
    datasetInput <- reactive({
        
        bmi <- input$weight / (input$height/100) * (input$height/100) # BMI calculation.
        bmi <- data.frame(bmi)
        names(bmi) <- "BMI"
        print(bmi)
        
        
    })

    # Status / Output Text Box.
    output$contents <- renderPrint({
        if (input$submitbutton > 0) {
            isolate("Calculation complete.")
        } else {
          return("Server is ready for calculation.")
        }
    })
    
    # Prediction results table.
    output$tabledata <- renderTable({
        if (input$submitbutton > 0) {
            isolate(datasetInput())
        }
    })
    
}


# Run the application.
# recall this is the 3rd component; fusion of the ui and server
#components.
shinyApp(ui = ui, server = server)

