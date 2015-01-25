#Coursera Getting and Cleaning Data - Project
This is a submission for for the Getting and Cleaning Data class project.

##Running the script

To run the script, place it in a folder for which you have write permissions,
set your working directory to the directory containing the script.  At the
R console issue:

`source('run_analysis.R')`

The script will install and load **plyr** if it is not already on your system.
*It will also download the data to the local directory if it is not found*
so be prepared for it to take a while if you don't already have the data set.

##Results

Final results of the script are two data frames.

**workFrame** is the large data frame with all standard deviation and means of each
of the Human Activity Recognition Using Smartphones Data Set measurements extracted.

**meansBySubjectActivity** is a long form dataset with the mean of each std and 
mean column in **workFrame** grouped by *activity* and *subject*

The script will also write the contents of **meansBySubjectActivity** into
a text file in the working directory called **means_by_activity_subject.txt**.
The file can be loaded using this command:

`result <- read.table("means_by_activity_subject.txt", header= TRUE)`