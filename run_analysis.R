
url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'

# Download the data if its not already here
if(! file.exists('Dataset.zip')) {
        download.file(url, 'Dataset.zip', method='curl')
}

# Unzip the data if its not already here
if(! file.exists('UCI HAR Dataset')) {
        unzip('Dataset.zip')
}

library(data.table)

## Load Data Sets
# Load Activity Labels (not yet as factors)
dt_activities <- as.data.table( read.table(file = "UCI HAR Dataset//activity_labels.txt", stringsAsFactors = F, col.names = c("Level", "Activity")) )

# Load Training Data
dt_subject_train <- as.data.table( read.table(file = "UCI HAR Dataset//train/subject_train.txt") )
dt_y_train <- as.data.table( read.table(file = "UCI HAR Dataset/train/y_train.txt") )
dt_X_train <- as.data.table( read.table(file = "UCI HAR Dataset/train/X_train.txt") )

# Bind the training tables
dt_train <- cbind(dt_subject_train, dt_y_train, dt_X_train)

# Load Test Data
dt_subject_test <- as.data.table( read.table(file = "UCI HAR Dataset//test/subject_test.txt") )
dt_y_test <- as.data.table( read.table(file = "UCI HAR Dataset/test/y_test.txt") )
dt_X_test <- as.data.table( read.table(file = "UCI HAR Dataset/test/X_test.txt") )

# Bind the test tables
dt_test <- cbind(dt_subject_test, dt_y_test, dt_X_test)

# Merge the training and test sets to one data set
dt_tidy <- rbind(dt_train, dt_test)

# Get the feature names to use later in descriptively naming the activities in the data set
dt_features <- as.data.table( read.table(file = "UCI HAR Dataset/features.txt", stringsAsFactors = F) )

library(sqldf)
# Descriptively name the activities in the data set
colnames(dt_tidy) <- c("Subject", "Activity", dt_features$V2)

# Extract only the mean and standard deviation for each measurement
dt_feature_means_sd <- sqldf("select * from dt_features where V2 like '%mean%' or V2 like '%std%'")
dt_tidy <- dt_tidy[, c("Subject", "Activity", dt_feature_means_sd$V2), with = F]

# Create a second tidy data set with the average of each
# variable for each activity and each subject
dt_tidy_means_sd <- data.table(matrix(NA, nrow=0, ncol=88))

# Descriptively name the activities in the data set
colnames(dt_tidy_means_sd) <- c("Subject", "Activity", dt_feature_means_sd$V2)

# Populate the final data table
for( subject in unique(dt_tidy$Subject) ){
        for( activity in unique(subset(dt_tidy, Subject == subject)$Activity) ){
                dt_sub <- subset(dt_tidy, Subject == subject & Activity == activity)
                dt_tidy_means_sd <- rbind(dt_tidy_means_sd, as.data.table( as.list( c(Subject=subject, Activity=activity, colMeans(dt_sub[,3:88, with = F]) ) ) ) )
        }
}

# Convert the Activities to Factors
dt_tidy_means_sd[[2]] <- factor(dt_tidy_means_sd[[2]], levels = dt_activities$Level, labels = dt_activities$Activity)

# Convert the Subjects to Factors
dt_tidy_means_sd$Subject <- as.factor(dt_tidy_means_sd$Subject)

# Write the final table
write.table(dt_tidy_means_sd, "dt_tidy_means_sd.txt", row.names = F)
