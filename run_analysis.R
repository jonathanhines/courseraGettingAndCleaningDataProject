# If the source isn't downloaded yet go get it and download it
if (!file.exists("UCI HAR Dataset")) {
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", method="curl", destfile = "project.zip")
  write(date(), file="dateDownloaded.txt")
  unzip("project.zip")
  unlink("project.zip")
}

# Get the base data to work from
workFrame <- read.table("UCI HAR Dataset//train//X_train.txt")
xTest <- read.table("UCI HAR Dataset//test//X_test.txt")
workFrame <- rbind( workFrame, xTest )
rm(xTest)

# Load the names of the dataset columns
features <- read.table("UCI HAR Dataset//features.txt", stringsAsFactors = FALSE)
names(workFrame) <- features[,2]

# Load the activity column as a factor
activity <- read.table("UCI HAR Dataset//train//y_train.txt")
activityTest <- read.table("UCI HAR Dataset//test//y_test.txt")
activityLabels <- read.table("UCI HAR Dataset//activity_labels.txt", stringsAsFactors = FALSE)
activity <- factor(rbind(activity,activityTest)[,1], labels = activityLabels[,2])
rm(activityTest, activityLabels)

# Load the subject column
subject <- read.table("UCI HAR Dataset//train//subject_train.txt")
subjectTest <- read.table("UCI HAR Dataset//test//subject_test.txt")
subject <- rbind( subject, subjectTest )
rm( subjectTest )

# Convert subject from a data.frame into a vector of integers
subject <- subject[,1]

# Get only the columns we need for the final result
workFrame <- workFrame[,( grepl("mean()",features[,2],fixed=TRUE) | grepl("std()",features[,2], fixed=TRUE) )]

workFrame$activity <- activity
workFrame$subject <- subject