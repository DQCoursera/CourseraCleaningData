# CourseraCleaningData
This repository is for the module 4 course project for the getting and cleaning data course in Coursera.

# Code Function
Lines 1-9
Code loads necessary library, defines path to test dataset, training dataset, the activity labels file, and the feature labels file, assuming "UCI HAR Dataset" is a folder in the working directory.

Lines 10-16
Function reads the files from "UCI HAR Dataset" folder and assigns a column name based off the name of the file, excluding "_train" or "_test"

Lines 18-32
Creates a dataframe to be filled later on

Lines 34-38
Maps the activities to the number, and the features to the number from their respective .txt files

Lines 40-45
Training and test data set loaded and then put into dataframe

Line 48
Activity numbers replaced with mapped labels

Line 51
Sorts dataset by subject column in ascending order

Lines 54-55
Adds feature names to column names starting from column 3 as columns 1 & 2 are subject & activity
At this point the combined dataset is finalized and the tidy dataset is to be created

Lines 58-71
Filter to columns that have mean or std in their names to gather all of the means and standard deviations
Create a new dataset with subject, activity, and the above filtered columns
Create a final tidy dataset with all all of the values averaged per activity, so each subject has 6 rows assigned to them for the 6 activities and save the tidy dataset to working directory
