#################################################################
##Getting and Cleaning Data
## Assignment "Getting and Cleaning Data Course Project"
## filename:  run_analysis.R
## Created by: Dong Guo
## Created on: 11/20/2014
#################################################################

#Load Library into R
library(pryr)
library(plyr)
library(data.table)
library(tcltk)


## Project
setwd("C:\\GTemp\\R\\GettingAndCleaningData\\Getting-and-Cleaning-Data-Course-Project")
# read data into seperate data table
activeLabel <- read.table(".\\data\\activity_labels.txt")
features <- read.table(".\\data\\features.txt")
features <- features[like(features$V2,"mean") |like(features$V2,"std"),]


# read train data & clean train data
train <- read.table(".\\data\\train\\X_train.txt")

# change colume names by using names in features data.table
#       filter columns just columns in features to just 79 columns
train <- train[,features$V1]
#       change column names
colnames(train) <- features[,2]

# read Active Name 
trainActive <- read.table(".\\data\\train\\Y_train.txt")
trainActive$value <- activeLabel[trainActive[,1],2]
colnames(trainActive) <- c("ActiveID","ActiveName")
subjectTrain <- read.table(".\\data\\train\\subject_train.txt")
colnames(subjectTrain) <- "SubjectID"

#combine tables by columns
train <- cbind(subjectTrain,trainActive,train)
head(train,1)


# read test data & clean test data
test <- read.table(".\\data\\test\\X_test.txt")
# change colume names
test <- test[,features$V1]
colnames(test) <- features[,2]
# read Active Name 
testActive <- read.table(".\\data\\test\\Y_test.txt")
testActive$value <- activeLabel[testActive[,1],2]
colnames(testActive) <- c("ActiveID","ActiveName")
subjectTest <- read.table(".\\data\\test\\subject_test.txt")
colnames(subjectTest) <- "SubjectID"
test <- cbind(subjectTest,testActive,test)
head(test,1)


#1. Merges the training and the test sets to create one data set.
# merge two data table to one
all <- rbind(train,test)
rm(train)
rm(test)
#2. Extracts only the measurements on the mean and standard deviation for each measurement. 
#3. Uses descriptive activity names to name the activities in the data set
#4. Appropriately labels the data set with descriptive variable names. 
#5. From the data set in step 4, creates a second, independent tidy data set 
#   with the average of each variable for each activity and each subject.

tidy <- ddply(all,.(SubjectID,ActiveName),function(x) {colMeans(x[,4:82])})
write.table(tidy,".\\tidy.txt",row.names=FALSE)

