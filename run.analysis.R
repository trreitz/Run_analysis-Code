getwd()

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="/Users/tristanreitz/Desktop/R Programming/phonemovement.zip")

# Unzip dataSet to /data directory
unzip(zipfile="/Users/tristanreitz/Desktop/R Programming/phonemovement.zip",exdir="./R Programming")


x_train <- read.table("./R Programming/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./R Programming/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./R Programming/UCI HAR Dataset/train/subject_train.txt")

# Reading testing tables:
x_test <- read.table("./R Programming/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./R Programming/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./R Programming/UCI HAR Dataset/test/subject_test.txt")

# Reading feature vector:
features <- read.table('./R Programming/UCI HAR Dataset/features.txt')

# Reading activity labels:
activityLabels = read.table('./R Programming/UCI HAR Dataset/activity_labels.txt')

#Column Naming with colname function. (had help from rpub on this, could not figure out. practice)

colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

#Merging data.
mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
setAllInOne <- rbind(mrg_train, mrg_test)

#looking at data for my own edification (Mistake, lots of useless data displayed)
head(mrg_train)


#Merging 
colNames <- colnames(setAllInOne)

# mean and standard deviation assignment (help from rpubs, was confused)
mean_and_std <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) 
)

# SUBSETTING (help from rpubs)
setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]


#putting activity names there (r pubs help)
setWithActivityNames <- merge(setForMeanAndStd, activityLabels,
                              by='activityId',
                              all.x=TRUE)

secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]


write.table(secTidySet, "secTidySet.txt", row.name=FALSE)
