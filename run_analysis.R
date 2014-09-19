
setwd('/home/scott/Dropbox/Coursera/Data Science/Getting and Cleaning Data/Getting-and-Cleaning-Data-Course-Project/')

url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
download.file(url, 'Dataset.zip', method='curl')
unzip('Dataset.zip')
dir()
dir("UCI HAR Dataset/train/")
dir("UCI HAR Dataset/train/Inertial Signals/")

library(data.table)

## Load Data Sets
# Load Activity Labels (not yet as factors)
dt_activities <- as.data.table( read.table(file = "UCI HAR Dataset//activity_labels.txt", stringsAsFactors = F, col.names = c("Level", "Activity")) )

# Load Training Data
dt_subject_train <- as.data.table( read.table(file = "UCI HAR Dataset//train/subject_train.txt") )
dt_y_train <- as.data.table( read.table(file = "UCI HAR Dataset/train/y_train.txt") )
dt_X_train <- as.data.table( read.table(file = "UCI HAR Dataset/train/X_train.txt") )
# TODO: optimize to read only the mean and sd?
# TODO: redo these with fread?

# Bind the training tables
dt_train <- cbind(dt_subject_train, dt_y_train, dt_X_train)

# Load Test Data
dt_subject_test <- as.data.table( read.table(file = "UCI HAR Dataset//test/subject_test.txt") )
dt_y_test <- as.data.table( read.table(file = "UCI HAR Dataset/test/y_test.txt") )
dt_X_test <- as.data.table( read.table(file = "UCI HAR Dataset/test/X_test.txt") )
# TODO: optimize to read only the mean and sd?
# TODO: redo these with fread?

# Bind the test tables
dt_test <- cbind(dt_subject_test, dt_y_test, dt_X_test)

# 1. Merge the training and test sets to one data set
dt_tidy <- rbind(dt_train, dt_test)

# Spot check the constructed tables:
head(dt_train[,list(V1,V2,V3,V4)])
head(dt_tidy[,list(V1,V2,V3,V4)])

tail(dt_test[,list(V1,V2,V3,V4)])
tail(dt_tidy[,list(V1,V2,V3,V4)])


# 2. Extract only the mean and standard deviation for each measurement
# TODO: Prune down the variables

# 3. Descriptively name the activities in the data set
dt_tidy[[2]] <- factor(dt_tidy[[2]], levels = dt_activities$Level, labels = dt_activities$Activity)


# 4. Descriptively label the variables in the data set
# TODO: Get these using read.table, filter for mean, strings.as.factor
dt_features <- as.data.table( read.table(file = "UCI HAR Dataset/features.txt", stringsAsFactors = F) )
library(sqldf)
dt_feature_means <- sqldf("select * from dt_features where V2 like '%mean%' or V2 like '%std%'")


# 5. Create a second tidy data set with the average of each
#    variable for each activity and each subject

