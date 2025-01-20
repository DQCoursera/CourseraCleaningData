# Load necessary libraries
library(dplyr)

# Define paths to the train and test sets
train_path <- "UCI HAR Dataset/train"
test_path <- "UCI HAR Dataset/test"
activity_labels_path <- "UCI HAR Dataset/activity_labels.txt"
features_path <- "UCI HAR Dataset/features.txt"

# Function to read data with column names from filenames
read_data_with_column_names <- function(file_path) {
    data <- read.table(file_path, header = FALSE)
    column_name <- gsub("(_train|_test)\\.txt$", "", basename(file_path))
    colnames(data) <- column_name
    return(data)
}

# Function to load and prepare a dataset (train or test)
load_and_prepare_data <- function(data_path, subject_file, y_file, x_file) {
    # Read subject data
    subject_data <- read.table(file.path(data_path, subject_file), header = FALSE, col.names = c("subject"))
    
    # Read activity labels (y)
    activity_data <- read.table(file.path(data_path, y_file), header = FALSE, col.names = c("activity"))
    
    # Read the feature measurements (X)
    feature_data <- read.table(file.path(data_path, x_file), header = FALSE)
    
    # Combine subject, activity, and feature data
    combined_data <- cbind(subject_data, activity_data, feature_data)
    return(combined_data)
}

# Read activity labels file (activity_labels.txt)
activity_labels <- read.table(activity_labels_path, header = FALSE, col.names = c("activity_id", "activity_name"))

# Read features file (features.txt)
features <- read.table(features_path, header = FALSE, col.names = c("index", "feature_name"))

# Load training and testing data
train_data <- load_and_prepare_data(train_path, "subject_train.txt", "y_train.txt", "X_train.txt")
test_data <- load_and_prepare_data(test_path, "subject_test.txt", "y_test.txt", "X_test.txt")

# Combine train and test data into one dataset
combined_data <- rbind(train_data, test_data)

# Map activity IDs to activity names
combined_data$activity <- factor(combined_data$activity, levels = activity_labels$activity_id, labels = activity_labels$activity_name)

# Sort combined data by subject column in ascending order
combined_data <- combined_data[order(combined_data$subject), ]

# Assign feature column names
feature_names <- features$feature_name
colnames(combined_data)[3:ncol(combined_data)] <- feature_names

# Filter columns that contain "mean()" or "std()" in their names
mean_std_columns <- grep("-(mean|std)\\(\\)", feature_names)  # Find indices of features with "mean()" or "std()"

# Subset the combined dataset: keep the first two columns (subject, activity) and the selected feature columns
final_data <- combined_data[, c(1, 2, mean_std_columns + 2)]  # +2 to offset for subject and activity

# Create a tidy dataset where we average the feature values per subject and activity
tidy_data <- final_data %>%
    group_by(subject, activity) %>%
    summarise(across(starts_with("tBodyAcc") | starts_with("tGravityAcc") | starts_with("fBodyAcc") | 
                         starts_with("tBodyGyro") | starts_with("fBodyGyro") | starts_with("mag") |
                         starts_with("angle"), mean, .names = "mean_{.col}"), .groups = "drop")

# Save the tidy data to a CSV file
write.csv(tidy_data, "tidy_data.csv", row.names = FALSE)
