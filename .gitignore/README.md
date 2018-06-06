# Getting and Cleaning Data Course Project

Nathaniel Taylor

June, 2018

## Project instructions

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

## Data and instructions for the project

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You should create one R script called run_analysis.R that does the following.
1.  Merges the training and the test sets to create one data set.
2.  Extracts only the measurements on the mean and standard deviation for each measurement.
3.  Uses descriptive activity names to name the activities in the data set
4.  Appropriately labels the data set with descriptive variable names.
5.  From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Steps taken to create the tidy data set

### Download the data

Data were downloaded to a local folder by clicking on the provided link

### Set file path and dataset

```R
setwd("/Users/ntaylor/Documents/NHTaylor/Coursera/Data Science Specialization/3. Getting and Cleaning Data/Course Project/UCI HAR Dataset")
        path <- file.path("/Users/ntaylor/Documents/NHTaylor/Coursera/Data Science Specialization/3. Getting and Cleaning Data/Course Project/UCI HAR Dataset")
        har_data_list <- list.files(path, recursive = TRUE)
        har_data_list
```

### 1. Load files into variable nad merge training and test data into one data set

```R
        features <- read.csv(file = './features.txt', header = FALSE, sep = ' ')
                features <- as.character(features[,2])
        
        train_x <- read.table('./train/X_train.txt')
        train_activity <- read.csv('./train/y_train.txt', header = FALSE, sep = ' ')
        train_subject <- read.csv('./train/subject_train.txt',header = FALSE, sep = ' ')
        train <-  data.frame(train_subject, train_activity, train_x)
                names(train) <- c(c('subject', 'activity'), features)
        
        test_x <- read.table('./test/X_test.txt')
        test_activity <- read.csv('./test/y_test.txt', header = FALSE, sep = ' ')
        test_subject <- read.csv('./test/subject_test.txt', header = FALSE, sep = ' ')
        test <-  data.frame(test_subject, test_activity, test_x)
                names(test) <- c(c('subject', 'activity'), features)
        
        traintest_data <- rbind(train, test)
```

### 2. Extract only the measurements on te mean and standard deviation for each measurement

```R
mean_std <- grep('mean|std', features)
        traintest_data_mean_std <- traintest_data[,c(1,2,mean_std + 2)]  
```

### 3. Set descriptive activity names

```R
activity_labels <- read.table('./activity_labels.txt', header = FALSE)
                activity_labels <- as.character(activity_labels[,2])
                traintest_data_mean_std$activity <- activity_labels[traintest_data_mean_std$activity] 
```

### 4. Label data set with descriptive variable names

```R
        names(traintest_data_mean_std) <- gsub("^t", "Time", names(traintest_data_mean_std))
        names(traintest_data_mean_std) <- gsub("^f", "Frequency", names(traintest_data_mean_std))
        names(traintest_data_mean_std) <- gsub("Acc", "Accelerometer", names(traintest_data_mean_std))
        names(traintest_data_mean_std) <- gsub("Gyro", "Gyroscope", names(traintest_data_mean_std))
        names(traintest_data_mean_std) <- gsub("Mag", "Magnitude", names(traintest_data_mean_std))
        names(traintest_data_mean_std) <- gsub("-mean-", "_Mean_", names(traintest_data_mean_std))
        names(traintest_data_mean_std) <- gsub("-std-", "_StandardDeviation_", names(traintest_data_mean_std))
```

### 5. Create tidy data set with the average of each variable for each activity and each subject

```R
        tidy_data <- aggregate(traintest_data_mean_std[,3:81], by = list(activity = traintest_data_mean_std$activity, subject = traintest_data_mean_std$subject),FUN = mean)
        write.table(x = tidy_data, file = "tidy_data.txt", row.names = FALSE)
```

### 6. Produce Codebook 

```R
        library(dataMaid)
        makeCodebook(tidy_data, replace = TRUE)
```


 
        
