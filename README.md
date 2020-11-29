# run_analysis

The dataset includes the following files:
=========================================

- 'README.rm'
- 'CodeBook.rm': Shows information about the variables used
- 'run_analysis.R': script used to generate the tidy data set called "run_analysis_tidy_dataset.txt"
- 'tidyDataset.txt': the tidy data set


The Script run_analysis.R does the following:
-defines the working directory and url for the data
-downloads and unzips the data
-read files
-rename col name of X_test.txt file with values from features.txt file
-replace activity code by activity name
-merge the test files
-merge the train files
-merge train and test files
-add descriptive activity names to name the activities in the data set
-created a tidy dataset witth select mean and std
