## =============================================== ##
##
## Program:     run_analysis.R
##
## Project:     Peer-graded assignment: getting and 
##              cleaning data course project
##
## Programmer:  Nathaniel Taylor: June, 2018 
## 
## =============================================== ##

## ----------------------------------------------- ##
##      Set file path and dataset:
##      Downloaded data from link provided and saved
##      to local folder
## ----------------------------------------------- ##
        
        setwd("/Users/ntaylor/Documents/NHTaylor/Coursera/Data Science Specialization/3. Getting and Cleaning Data/Course Project/UCI HAR Dataset")
        path <- file.path("/Users/ntaylor/Documents/NHTaylor/Coursera/Data Science Specialization/3. Getting and Cleaning Data/Course Project/UCI HAR Dataset")
        har_data_list <- list.files(path, recursive = TRUE)
        har_data_list
        
## ----------------------------------------------- ##
## 1. Load files into variables and merge training
##      and test data into one data set
## ----------------------------------------------- ##        
        
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
        
## ----------------------------------------------- ##
## 2. Extract only the measurements on the mean 
##      and standard deviation for each measurement
## ----------------------------------------------- ##        
        
        mean_std <- grep('mean|std', features)
        traintest_data_mean_std <- traintest_data[,c(1,2,mean_std + 2)]        
        
## ----------------------------------------------- ##
## 3. Set descriptive activity names
## ----------------------------------------------- ##          
        
        activity_labels <- read.table('./activity_labels.txt', header = FALSE)
                activity_labels <- as.character(activity_labels[,2])
                traintest_data_mean_std$activity <- activity_labels[traintest_data_mean_std$activity]        
        
        
        
## ----------------------------------------------- ##
## 4. Label data set with descriptive variable names
## ----------------------------------------------- ##   
        
        names(traintest_data_mean_std) <- gsub("^t", "Time", names(traintest_data_mean_std))
        names(traintest_data_mean_std) <- gsub("^f", "Frequency", names(traintest_data_mean_std))
        names(traintest_data_mean_std) <- gsub("Acc", "Accelerometer", names(traintest_data_mean_std))
        names(traintest_data_mean_std) <- gsub("Gyro", "Gyroscope", names(traintest_data_mean_std))
        names(traintest_data_mean_std) <- gsub("Mag", "Magnitude", names(traintest_data_mean_std))
        names(traintest_data_mean_std) <- gsub("-mean-", "_Mean_", names(traintest_data_mean_std))
        names(traintest_data_mean_std) <- gsub("-std-", "_StandardDeviation_", names(traintest_data_mean_std))

        
## ----------------------------------------------- ##
## 5. Create tidy data set with the average of 
##      each variable for each activity and each
##      subject
## ----------------------------------------------- ## 
        
        tidy_data <- aggregate(traintest_data_mean_std[,3:81], by = list(activity = traintest_data_mean_std$activity, subject = traintest_data_mean_std$subject),FUN = mean)
        write.table(x = tidy_data, file = "tidy_data.txt", row.names = FALSE)
        

## ----------------------------------------------- ##
## 6. Produce Codebook
## ----------------------------------------------- ##  
        
        library(dataMaid)
        makeCodebook(tidy_data, replace = TRUE)
        
        
        
        
        
        
        
        
          