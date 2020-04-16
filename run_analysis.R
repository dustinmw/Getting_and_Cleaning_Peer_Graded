## Getting and Cleaning Data: Week 4 | Course Project
## You should create one R script called run_analysis.R that does the following.

## 1.  Merges the training and the test sets to create one Data set.
## 2.  Extracts only the measurements on the mean and standard deviation for each measurement.
## 3.  Uses descriptive activity names to name the activities in the Data set
## 4.  Appropriately labels the Data set with descriptive variable names.
## 5.  From the Data set in step 4, creates a second, independent tidy Data set with the average 
##     of each variable for each activity and each subject.


# Install libraries used in this assignment
library(data.table)
library(reshape2)


## 1.  Merges the training and the test sets to create one Data set.


x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)

y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)

featuresData <- rbind(x_train, X_test)
activityData <- rbind(y_train, y_test)
subjectData <- rbind(subject_train, subject_test)

names(featuresData)<- c("features")
names(activityData)<-c("activity")
names(subjectData)<-c("subject")

featuresnames <- read.table("./UCI HAR Dataset/features.txt", header = FALSE)
names(featuresData)<- featuresnames$V2

combineData <- cbind(subjectData, activityData)
Data <- cbind(featuresData, combineData)


## 2.  Extracts only the measurements on the mean and standard deviation for each measurement.


check_features <- featuresnames$V2[grep("mean\\(\\)|std\\(\\)", featuresnames$V2)]

selectednames<-c(as.character(check_features), "subject", "activity" )

Data<-subset(Data,select=selectednames)


## 3.  Uses descriptive activity names to name the activities in the Data set


activities<-read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE)

names(activities) <- c('act_id', 'act_name')
activityData[, 1] = activities[activityData[, 1], 2]

names(activityData) <- "activity"

combineData <- cbind(subjectData, activityData)
Data <- cbind(featuresData, combineData)
Data<-subset(Data,select=selectednames)


## 4.  Appropriately labels the Data set with descriptive variable names.


names(Data)<-gsub("^t", "Time", names(Data))
names(Data)<-gsub("^f", "Frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))


## 5.  From the Data set in step 4, creates a second, independent tidy Data set with the average 
##     of each variable for each activity and each subject.


FinalData<-aggregate(. ~subject + activity, Data, mean)
FinalData<-FinalData[order(FinalData$subject,FinalData$activity),]

write.table(FinalData, file = "FinalData.txt", row.names = FALSE)

