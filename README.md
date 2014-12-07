Script explaination
===================

## Introduction
R script called run_analysis.R that does the following: 
- Merges the training and the test sets to create one data set.
- Extracts only the measurements on the mean and standard deviation for each measurement. 
- Uses descriptive activity names to name the activities in the data set.
- Appropriately labels the data set with descriptive variable names.  
- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Prerequisites
Before you run the "run_analysis.R", you must copy Samsung dataset into working directory (same diretory of "run_analysis.R") and named it with "dataset".

## How the script work

### Loading data
- The first stage of this script load dataset into memory. These data includes: train data, train subject ID, train label ID, test data, test subject ID, test label ID, feature names.

- After that, it merge train and test data into one data frame

### Cleaning data
- Step 1: Extracts only the measurements on the mean and standard deviation columns.
- Step 2: Group dataset by subject using subject ID.
- Step 3: Appropriately labels the data set with descriptive variable names. These variables includes: 'subjectId', 'activityLabel' and mean, standard deviation feature names.
- Step 4: For each subject, group the data by activities and calculate average of each variable. This step include the rearrange variables.
- Step 5: Save the data into text file.

