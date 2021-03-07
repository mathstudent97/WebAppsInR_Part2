#####################################
# This file creates the model and   #
#other csv files that will be part  #
#of the dataset used by the web app.#
# Code Part 1                       #
#####################################



# Importing libraries
library(RCurl) 
# This package will be used for downloading the iris CSV file
# This allows us to read the dataset
library(randomForest)
# This package will help us create the Prediction model
library(caret)
# This package allows us to do the data splitting
#using a ratio of 80.20


# Importing the Iris data set
iris <- read.csv(url("https://raw.githubusercontent.com/dataprofessor/data/master/iris.csv"))
# Creating a data object known as 'iris'
# Will read in the csv
# Which will retrieve the csv file from the data professor github 


# Performs stratified random split of the data set
# This helps organize the dataset
TrainingIndex <- createDataPartition(iris$Species, p=0.8, list = FALSE)
# The 'p=0.8' represents the 80% split stated above (having to do with the
#caret package); this will go into the 'TrainingIndex'
TrainingSet <- iris[TrainingIndex,] 
# Training Set
# We will subsequently use the training index to create a training set
# In which it will perform slicing of the original iris data frame
# And then the remaining 20% will go to the 'TestingSet' below
TestingSet <- iris[-TrainingIndex,] 
# Test Set


# This will write the files within the folder / location of which the
#'model', 'app-numeric', and 'app-slider' files are placed & saved
# IOW, we want all app files to be located in the SAME directory
write.csv(TrainingSet, "training.csv")#, file = 'training.csv')
write.csv(TestingSet, "testing.csv") #file = 'testing.csv')


# Here, we will read in the 'training.csv' file
TrainSet <- read.csv("training.csv", header = TRUE)
# We will delete the first column, which is the index number
TrainSet <- TrainSet[,-1]


# Building the Random Forest Model
# Here, we are specifying that we want to predict the species of the iris flower
#and we will be using all 4 input parameters (indicated by '~ .')
# The dataset will be using the 'TrainsSet' for making the model
# 'mtry' value are the 4 parameters
model <- randomForest(Species ~ ., data = TrainSet, ntree = 500, mtry = 4, importance = TRUE)

# Save model to RDS file
# so, we can deploy the model in an rds format
saveRDS(model, file = 'model.rds')