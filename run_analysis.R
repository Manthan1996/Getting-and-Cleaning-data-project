run_analysis<-function(){

trainingSubjects <- read.table("C:/Data_Science/data/Getting and  cleaning course project data/UCI HAR Dataset/train/subject_train.txt")
trainingValues <- read.table("C:/Data_Science/data/Getting and  cleaning course project data/UCI HAR Dataset/train/X_train.txt")
trainingActivity <- read.table("C:/Data_Science/data/Getting and  cleaning course project data/UCI HAR Dataset/train/y_train.txt")

testSubjects <- read.table("C:/Data_Science/data/Getting and  cleaning course project data/UCI HAR Dataset/test/subject_test.txt")
testValues <- read.table("C:/Data_Science/data/Getting and  cleaning course project data/UCI HAR Dataset/test/X_test.txt")
testActivity <- read.table("C:/Data_Science/data/Getting and  cleaning course project data/UCI HAR Dataset/test/y_test.txt")

features <- read.table("C:/Data_Science/data/Getting and  cleaning course project data/UCI HAR Dataset/features.txt", as.is = TRUE)

activities <- read.table("C:/Data_Science/data/Getting and  cleaning course project data/UCI HAR Dataset/activity_labels.txt")
colnames(activities) <- c("activityId", "activityLabel")

humanActivity <- rbind(
  cbind(trainingSubjects, trainingValues, trainingActivity),
  cbind(testSubjects, testValues, testActivity)
)

colnames(humanActivity) <- c("subject", features[, 2], "activity")

columnsToKeep <- grepl("subject|activity|mean|std", colnames(humanActivity))

humanActivity <- humanActivity[, columnsToKeep]


humanActivity$activity <- factor(humanActivity$activity, 
levels = activities[, 1], labels = activities[, 2])


humanActivityCols <- colnames(humanActivity)

humanActivityCols <- gsub("[\\(\\)-]", "", humanActivityCols)

humanActivityCols <- gsub("^f", "frequencyDomain", humanActivityCols)
humanActivityCols <- gsub("^t", "timeDomain", humanActivityCols)
humanActivityCols <- gsub("Acc", "Accelerometer", humanActivityCols)
humanActivityCols <- gsub("Gyro", "Gyroscope", humanActivityCols)
humanActivityCols <- gsub("Mag", "Magnitude", humanActivityCols)
humanActivityCols <- gsub("Freq", "Frequency", humanActivityCols)
humanActivityCols <- gsub("mean", "Mean", humanActivityCols)
humanActivityCols <- gsub("std", "StandardDeviation", humanActivityCols)

humanActivityCols <- gsub("BodyBody", "Body", humanActivityCols)

colnames(humanActivity) <- humanActivityCols

library(dplyr)
humanActivityMeans <- humanActivity %>% 
  group_by(subject, activity) %>%
  summarise_each(funs(mean))

write.table(humanActivityMeans, "C:/Data_Science/Rcodes/Gettingandcleaningdatacourse_finalproject/tidy_data.txt", row.names = FALSE, 
quote = FALSE)

}