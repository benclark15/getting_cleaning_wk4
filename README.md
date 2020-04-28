# getting_cleaning_wk4
Script, codebook, readme and output data file for Week 4 assignment

The run_analysis.R script takes a number of disparate data files, processes and merges them into a tidy data set.  The following data files are processed:

* activity_labels.txt - Contains the IDs (1-6) and names of each of the six activities for which measurements were taken
* features.txt - Contains the names of each of the measurements (features taken for each activity.  These are used as the basis for the column names in the first merged dataset)
* y_train.txt - Contains the IDs (1-6) of each of the activities for which each measurement was taken in the training dataset
* subject_train.txt - Contains the IDs(1-30) of each of the subjects for the training dataset
* x_train.txt - The training dataset.  Contains measurements for each of the 561 features, for each activity and each subject.  However, the column names are not descriptive and the activity and subject IDs are not currently in this dataset, and must be merged from others.
* y_test.txt - Contains the IDs (1-6) of each of the activities for which each measurement was taken in the test dataset
* subject_test.txt - Contains the IDs(1-30) of each of the subjects for the test dataset
* x_test.txt - test training dataset.  Contains measurements for each of the 561 features, for each activity and each subject.  However, the column names are not descriptive and the activity and subject IDs are not currently in this dataset, and must be merged from others.

The script works in the following way:

1) The activity IDs are bound on to the beginning of the training and test datasets
2) The subject IDs are bound on to the beginning of the training and test datasets
3) The training and test datasets are merged, to form a single dataset, merged_dt
4) The first two columns (subject and activity) are given descriptive names and the dataset is then ordered by these same variables
5) The script then loops through the features file, assigning each row of the dataset to each column of the measurements in the merged dataset, so as to make the column names much more descriptive. Reserved characters are stripped out and a unique number is given to each column, so as to not disable subsequent dplyr functions.
6) Only the measurement columns that are mean or standard deviation are stripped to be used in the final dataset.
7) The activity IDs are replaced with activity names (more descriptive).
8) The final dataset is grouped by subject and activity and a mean is calculated for each measureable variable against each subject/activity combination.
9) This tidy dataset is then written to the final output file, tidyData.txt
