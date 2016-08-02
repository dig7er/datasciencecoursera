library(dplyr)

# Peer Graded Assignment: Getting and Cleaning Data Course Project

# 1. Define functions

#' Downloads the zip file from a specified URL
#' @param url A URL to the archived data
#' @return a path to the extracted zip folder
getArchivedData <- function(url) {
  localDir <- "./UCI HAR Dataset/"
  localFilename <- "getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  
  if (!dir.exists(localDir)) {
    download.file(url = url, destfile = localFilename, method = "curl")
    unzip(localFilename, overwrite = TRUE)
  }
    
  localDir
}

#' Reads data from a specified filepath
#' @param filepath A path to a specified file
#' @return a data frame with data from the specified file
readData <- function(filepath) {
  read.table( filepath, as.is = TRUE )
}

# 2. Getting Data

# 2.1. Download the zip archive
#' A URL to the archived data for this assignment
dataUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dataDir <- getArchivedData(dataUrl)

# 2.2. Read data from the archived files
#' A list of paths to files within the zip archive
archivePaths <- list(
  activities = paste(dataDir, "activity_labels.txt", sep=""),
  features = paste(dataDir, "features.txt", sep=""),
  x_test = paste(dataDir, "test/X_test.txt", sep=""),
  y_test = paste(dataDir, "test/y_test.txt", sep=""),
  subject_test = paste(dataDir, "test/subject_test.txt", sep=""),
  x_train = paste(dataDir, "train/X_train.txt", sep=""),
  y_train = paste(dataDir, "train/y_train.txt", sep=""),
  subject_train = paste(dataDir, "train/subject_train.txt", sep="")
)
rawData <- lapply(archivePaths, readData)

# 3. Cleaning Data
# 3.1. Merge all test data into one data set (observation subject, observation activity, observation values/variables)
testData.tidy <- cbind(rawData$subject_test, rawData$y_test, rawData$x_test)

# 3.2. Make the test data set tidy by providing meaningful variable names (by using the second column of the features set as names for variables)
colnames(testData.tidy) <- c("subject", "activity", rawData$features$V2)

# 3.3. Merge all train data into one tidydata set (observation subject, observation activity, observation values/variables)
trainData.tidy <- cbind(rawData$subject_train, rawData$y_train, rawData$x_train)

# 3.4. Make the train data set tidy by providing meaningful variable names (by using the second column of the features set as names for variables)
colnames(trainData.tidy) <- c("subject", "activity", rawData$features$V2)

# 4. Do the assignment tasks
# 4.1. Merge the training and the test sets to create one data set.
data <- rbind(trainData.tidy, testData.tidy)

# 4.2. Extracts the subject, activity and only variables on the mean and standard deviation for each measurement.
data <- data[grep("(subject|activity|(mean|std)\\(\\))", colnames(data))]

# 4.3. Use descriptive activity names to name the activities in the data set (using labels from the 2nd column of the activities_labels.txt)
data$activity <- factor(data$activity, labels = rawData$activities$V2)

# 4.4 From the data set, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
data_by_subject_by_activity <- group_by(data, subject, activity)
mean_by_subject_by_activity <- summarize_each(data_by_subject_by_activity, c("mean"))

# 4.5. Write the resulting data set to the file.
write.table(mean_by_subject_by_activity, file="output.txt", row.names=FALSE)

#5. Print the data frame
print(mean_by_subject_by_activity)