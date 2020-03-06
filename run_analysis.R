## 1. Extract the data

X_test <- read.table("./test/X_test.txt")
Y_test <- read.table("./test/Y_test.txt")
Subject_test <- read.table("./test/subject_test.txt")

X_train <- read.table("./train/X_train.txt")
Y_train<- read.table("./train/Y_train.txt")
Subject_train <- read.table("./train/subject_train.txt")
## Then merge them

subject_data <- rbind(Subject_train, Subject_test)
activity_data <- rbind(Y_train,Y_test)
features_data <- rbind(X_train, X_test)
names(subject_data) <- c("subject")
names(activity_data) <- c("activity")
final_data <- cbind(features_data, subject_data, activity_data)
##2. Extract the mean and standard deviation

Features_names <- read.table("features.txt")
select_data_names <- Features_names$V2[grep("mean\\(\\)|std\\(\\)", Features_names$V2)]
Names <- c(as.character(select_data_names),"subject","activity")
Subset_data <- subset(final_data, select=Names)
##3. Uses descriptive activity names to name the activities in the data set
activity_labels <- read.table("activity_labels.txt")
Subset_data$activity[Subset_data$activity=="1"] <- "Walking"
Subset_data$activity[Subset_data$activity=="2"] <- "Walking upstairs"
Subset_data$activity[Subset_data$activity=="3"] <- "Walking downstairs"
Subset_data$activity[Subset_data$activity=="4"] <- "Sitting"
Subset_data$activity[Subset_data$activity=="5"] <- "Standing"
Subset_data$activity[Subset_data$activity=="6"] <- "Laying"

##4. Appropriately labels the data set with descriptive variable names.
names(Subset_data) <- gsub("^t","time",names(Subset_data))
names(Subset_data) <- gsub("^f","frequency",names(Subset_data))
names(Subset_data) <- gsub("Acc","Accelartor",names(Subset_data))
names(Subset_data) <- gsub("Gyro","Gyroscope",names(Subset_data))
names(Subset_data) <- gsub("Mag","Magnitude",names(Subset_data))
names(Subset_data) <- gsub("BodyBody","Body",names(Subset_data))

##5. creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(plyr)
tidy_data <- aggregate(.~subject+activity,Subset_data,mean)
tidy_data <- tidy_data[order(tidy_data$subject, tidy_data$activity),]
write.table(tidy_data,file="tidydata.txt",row.name=FALSE)
