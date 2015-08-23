# Getting and Cleaning Data
# Course Project
#
# The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for 
# analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be 
# required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for 
# performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work 
# that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your
# scripts. This repo explains how all of the scripts work and how they are connected.  
# One of the most exciting areas in all of data science right now is wearable computing - see for example this article . 
# Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. 
# The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S 
# smartphone. A full description is available at the site where the data was obtained: 
#  
#  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
#
#Here are the data for the project: 
#  
#  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
#
#You should create one R script called run_analysis.R that does the following. 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#
####################################################################################################################################################
#
library(plyr)

if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if (!file.exists("./data/Dataset.zip")){
  download.file(fileUrl,destfile="./data/Dataset.zip")
}

# Unzip the required file
unzip(zipfile="./data/Dataset.zip",exdir="./data")

# Set the pathname for the files

path_r <- file.path("./data" , "UCI HAR Dataset")

x_train <- read.table(file.path(path_r, "train", "X_train.txt"),header = FALSE)
y_train <- read.table(file.path(path_r, "train", "Y_train.txt"),header = FALSE)
subject_train <- read.table(file.path(path_r, "train", "subject_train.txt"),header = FALSE)

x_test <- read.table(file.path(path_r, "test" , "X_test.txt" ),header = FALSE)
y_test <- read.table(file.path(path_r, "test" , "Y_test.txt" ),header = FALSE)
subject_test <- read.table(file.path(path_r, "test" , "subject_test.txt"),header = FALSE)

# 1. Merges the training and the test sets to create one data set.

# create 'x' data set
x_data <- rbind(x_train, x_test)

# create 'y' data set
y_data <- rbind(y_train, y_test)

# create 'subject' data set
subject_data <- rbind(subject_train, subject_test)

#
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
#

features <- read.table(file.path(path_r, "features.txt"),head=FALSE)

# get only columns with mean() or std() in their names
mean_std <- grep("-(mean|std)\\(\\)", features[, 2])

# subset the desired columns
x_data <- x_data[, mean_std]

# correct the column names
names(x_data) <- features[mean_std, 2]


# 3. Use descriptive activity names to name the activities in the data set
###############################################################################

activities <- read.table(file.path(path_r, "activity_labels.txt"),header = FALSE)

# update values with correct activity names
y_data[, 1] <- activities[y_data[, 1], 2]

# correct column name
names(y_data) <- "activity"

# 4. Appropriately label the data set with descriptive variable names
###############################################################################

# correct column name
names(subject_data) <- "subject"

# bind all the data in a single data set
all_data <- cbind(x_data, y_data, subject_data)

# 5. Create a second, independent tidy data set with the average of each variable
# for each activity and each subject
###############################################################################

ave_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(ave_data, "clean_data.txt", row.name=FALSE)