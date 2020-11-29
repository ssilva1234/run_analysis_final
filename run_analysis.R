#set working directory
directory<-getwd()

#url for the data
url1<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

#download the data
download.file(url1, destfile = file.path(directory, "run_analysis_dataset.zip"))

#unzip the dataset
unzip("run_analysis_dataset.zip", exdir = directory)

#read files
activity_labels<-read.table(file = "./UCI HAR Dataset/activity_labels.txt", header = FALSE, sep = "")
features<-read.table(file = "./UCI HAR Dataset/features.txt", header = FALSE, sep = "")
subject_test<-read.table(file = "./UCI HAR Dataset/test/subject_test.txt", header = FALSE, sep = "", col.names = "Subject")
X_test<-read.table(file = "./UCI HAR Dataset/test/X_test.txt", header = FALSE, sep = "")
y_test<-read.table(file = "./UCI HAR Dataset/test/y_test.txt", header = FALSE, sep = "", col.names = "Activity")
subject_train<-read.table(file = "./UCI HAR Dataset/train/subject_train.txt", header = FALSE, sep = "", col.names = "Subject")
X_train<-read.table(file = "./UCI HAR Dataset/train/X_train.txt", header = FALSE, sep = "")
y_train<-read.table(file = "./UCI HAR Dataset/train/y_train.txt", header = FALSE, sep = "", col.names = "Activity")

#rename col name of X_test.txt file with values from features.txt file
colnames(X_test)<-features$V2
colnames(X_train)<-features$V2

#replace activity code by activity name
for (i in 1:6) {y_test[y_test == i]<-activity_labels[i,2]
}

for (i in 1:6) {y_train[y_train == i]<-activity_labels[i,2]
}

#merge the test files
test<-as.data.frame(do.call(cbind, c(subject_test, y_test, X_test)))

#merge the train files
train<-as.data.frame(do.call(cbind, c(subject_train, y_train, X_train)))

#merge train and test files
library(plyr)
test_train<-as.data.frame(rbind(test, train))

#add descriptive activity names to name the activities in the data set
names(test_train)<-gsub("Acc", "Accelerometer", names(test_train))
names(test_train)<-gsub("Gyro", "Gyroscope", names(test_train))
names(test_train)<-gsub("BodyBody", "Body", names(test_train))
names(test_train)<-gsub("Mag", "Magnitude", names(test_train))
names(test_train)<-gsub("^t", "Time", names(test_train))
names(test_train)<-gsub("^f", "Frequency", names(test_train))
names(test_train)<-gsub("tBody", "TimeBody", names(test_train))
names(test_train)<-gsub("-mean()", "Mean", names(test_train), ignore.case = TRUE)
names(test_train)<-gsub("-std()", "STD", names(test_train), ignore.case = TRUE)
names(test_train)<-gsub("-freq()", "Frequency", names(test_train), ignore.case = TRUE)
names(test_train)<-gsub("angle", "Angle", names(test_train))
names(test_train)<-gsub("gravity", "Gravity", names(test_train))

#select mean and std
library(dplyr)
test_train_final<-dplyr::select(test_train, contains(c("Subject","Activity", "mean", "std")))

#create a txt file
run_analysis_tidy_dataset<-write.table(test_train_final, file = "run_analysis_tidy_dataset.txt", row.names = FALSE)


#create second data set

# First, group data by activity and subject
groupedSet <-group_by(test_train_final, Activity, Subject)
cols.num <- c(3:88)
groupedSet[cols.num] <- sapply(groupedSet[cols.num],as.numeric)
sapply(groupedSet, class)

# Second, extract the average of each variable
summarySet <- summarise_all(groupedSet, mean)

# Write tydi data to output file
write.table(summarySet, file = "./tidyDataset.txt", row.names = FALSE)


