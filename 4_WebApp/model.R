#####################################
# This file creates the model and   #
#other csv files that will be part  #
#of the dataset used by the web app.#
#####################################



# Importing libraries
library(RCurl) 
# This package will be used for downloading the iris CSV file
library(randomForest)
library(caret)


# Importing the Iris data set
iris <- read.csv(text = getURL("https://raw.githubusercontent.com/dataprofessor/data/master/iris.csv") )


# Performs stratified random split of the data set
# This helps organize the dataset
TrainingIndex <- createDataPartition(iris$Species, p=0.8, list = FALSE)
TrainingSet <- iris[TrainingIndex,] 
# Training Set
TestingSet <- iris[-TrainingIndex,] 
# Test Set


# This will write the files within the folder / location of which the
#'model', 'app-numeric', and 'app-slider' are placed
# IOW, we want all app files to be located in the SAME directory
write.csv(TrainingSet, "training.csv", file = 'WebAppsInR_Part2/training.csv')
write.csv(TestingSet, "testing.csv", file = 'WebAppsInR_Part2/testing.csv')


TrainSet <- read.csv("training.csv", header = TRUE)
TrainSet <- TrainSet[,-1]


# Building Random forest model

model <- randomForest(Species ~ ., data = TrainSet, ntree = 500, mtry = 4, importance = TRUE)

# Save model to RDS file
saveRDS(model, file = 'WebAppsInR_Part2/model.rds')
