# README

This file describes how the script _run_analysis.R_ works and the how the code book _CodeBook.md_ is structured.

## Source Code Description
The _run_analysis.R_ code imports the _dplyr_ library, which delivers the _group_by()_ and the _summarize_each()_ functions that are used in the code.

It then defines the utility functions:

* _getArchivedData()_: Checks whether the input data is provided and downloads it otherwise.
* _readData()_: Performs read operation over the specified data files.

The actual execution of the algorithm starts from the section "2. Getting Data".
The list of characters _archivePaths_ defines 8 paths to the input files.
The data from these files is read to the list of data.frames _rawData_ with the help of the _readData()_ function.

In the section "3. Cleaning data" the test and training data are brought to a tidy format. Subject and activity data is merged with the measurements in both data sets.

The following assignments tasks are being fullfilled one after the other in the section "4. Do the assignment tasks":

- Merge the training and the test sets to create one data set. This is done by applying _rbind()_.
- Extract only the variables on the mean and standard deviation for each measurement. This is done by applying _grep()_ function with the pattern which selects only the variables which contain "subject"", "activity"", "mean()" or "std()" in their names.
- Use descriptive activity names to name the activities in the data set. This is done by using factors with the labels from _the activity_labels.txt_ instead of the activity id's.
- Appropriately labels the data set with descriptive variable names. This is done by applying _colnames()_ function.
- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. This is done by applying the _group_by()_ and _summarize_each()_ functions.

## Input

The source code assumes the existence of the following directory _UCI HAR Dataset_. If the directory does not exist, then the [zip file](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) from the assignment is being downloaded and extracted.

The following filepaths are used by the code:

* _UCI HAR Dataset/activity_labels.txt_
* _UCI HAR Dataset/features.txt_
* _UCI HAR Dataset/test/X_test.txt_
* _UCI HAR Dataset/test/y_test.txt_
* _UCI HAR Dataset/test/subject_test.txt_
* _UCI HAR Dataset/train/X_train.txt_
* _UCI HAR Dataset/train/y_train.txt_
* _UCI HAR Dataset/train/subject_train.txt_

The files are described in the _features_info.txt_ and _README.txt_ files in the _UCI HAR Dataset_ directory.

## Output

The _output.txt_ files contains the resulting data.frame of the assignment. Please, use the codebook _CodeBook.md_ to learn more about it.