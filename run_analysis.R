library(dplyr)
# lists of labels and features
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
features <- read.table("./UCI HAR Dataset/features.txt")

# merge training and testing sets
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")

subject_data <- rbind(subject_train, subject_test)
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)

# extract only the means and stds
means_stds <- grepl("mean",features$V2) | grepl("std",features$V2)
num_variables <- sum(means_stds)

x_data <- x_data[,means_stds]
data <- cbind(subject_data,y_data,x_data)

# name the activities
data[,2] <- activity_labels[data[,2],2]

# label the variables
colnames(data) <- c("subject","activity",as.character(features[means_stds,2]))

# make tidy
data <- tbl_df(data)
tidy <- data %>% group_by(subject, activity) %>% summarise_each(funs(mean))
write.table(x = tidy, file = "tidyset.txt", row.name = FALSE) 
