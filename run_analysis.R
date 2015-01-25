# This solution uses plyr, install it and load it if it isn't present
if( require("plyr", character.only=TRUE) == FALSE ) {
    install.packages("plyr")
    library(plyr)
}

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

# Assignment Requirement 1 Complete - Data sets merged



# Load the names of the data set columns
features <- read.table("UCI HAR Dataset//features.txt", stringsAsFactors = FALSE)

# Attach the names to the data set
names(workFrame) <- features[,2]

# Assignment Requirement 4 Complete - Descriptive Labels on Data set



# Load the activity column as a factor
activity <- read.table("UCI HAR Dataset//train//y_train.txt")
activityTest <- read.table("UCI HAR Dataset//test//y_test.txt")
activityLabels <- read.table("UCI HAR Dataset//activity_labels.txt", stringsAsFactors = FALSE)

# This provides the descriptive activity names required in Assignment Step 3
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
# Assignment Requirement 2 Complete - Extracted only the mean and standard deviation of each measurement

workFrame$activity <- activity
workFrame$subject <- subject

# Assignment Requirement 3 Complete - Used descriptive names to name activities in data set



# This step takes the mean of each column in the step 4 result and takes it's 
# mean grouped by subject and activity 
meansBySubjectActivity <- ddply( workFrame,c("activity","subject"),colwise(mean) )

# Update the column headings to reflect that this is now a mean of a larger set
meansNames <- names(meansBySubjectActivity)
meansNames <- c(meansNames[1:2],paste(meansNames[-(1:2)],"-mean()",sep=""))
meansNames <- gsub("mean()","MEAN",meansNames, fixed = TRUE)
meansNames <- gsub("std()","STD",meansNames, fixed = TRUE)
meansNames <- gsub("-","",meansNames)
names(meansBySubjectActivity) <- meansNames

# Assignment Requirement 5 Complete - Second intepentent tidy data set with the 
#      average of each varaible for each activity and each subject


# Write the results for assignemnt submission
write.table( 
    meansBySubjectActivity, 
    file="means_by_activity_subject.txt", 
    row.names = FALSE
)

# Final Cleanup
rm( features, activity, subject, meansNames )
# rm( meansBySubjectActivity, workFrame )