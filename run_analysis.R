library(plyr)

# |||||||||||||||||||||||||||||||
# Merge traning and test sets
# |||||||||||||||||||||||||||||||

#---- load
x_train <- read.table("uci_har_dataset/train/X_train.txt")
y_train <- read.table("uci_har_dataset/train/y_train.txt")
subject_train <- read.table("uci_har_dataset/train/subject_train.txt")
x_test <- read.table("uci_har_dataset/test/X_test.txt")
y_test <- read.table("uci_har_dataset/test/y_test.txt")
subject_test <- read.table("uci_har_dataset/test/subject_test.txt")

#---- combine
x_table <- rbind(x_train, x_test)
y_table <- rbind(y_train, y_test)
sub_table <- rbind(subject_train, subject_test)

# |||||||||||||||||||||||||||||||||||
# Grab mean and standard deviation
# |||||||||||||||||||||||||||||||||||

#---- load features
features <- read.table("uci_har_dataset/features.txt")

#---- grab desired features
desired_features <- grep(".*mean.*|.*std.*", as.character(features[,2]))
desired_features.names <- features[desired_features,2]
desired_features.names = gsub('-mean', 'Mean', desired_features.names)
desired_features.names = gsub('-std', 'Std', desired_features.names)
desired_features.names <- gsub('[-()]', '', desired_features.names)

#---- subset the desired columns
x_table <- x_table[, desired_features]

#---- correct the column names
names(x_table) <- desired_features.names

# |||||||||||||||||||||||||
# Set activities names
# |||||||||||||||||||||||||

#---- load activities
activities <- read.table("uci_har_dataset/activity_labels.txt")

#---- add activity names
y_table[, 1] <- activities[y_table[, 1], 2]
names(y_table) <- "activity"


# |||||||||||||||||||||||||||||||||||
# Add descriptive variable names
# |||||||||||||||||||||||||||||||||||

#---- give subject column name
names(sub_table) <- "subject"

#---- bind all the data in a single data set
full_table <- cbind(x_table, y_table, sub_table)

# ||||||||||||||||||||||||
# Create tidy data set
# ||||||||||||||||||||||||

#---- split, apply anonymous fn, and create new data frame
averages_table <- ddply(full_table, .(subject, activity), function(x) colMeans(x[, 1:66]))
write.table(averages_table, "./tidy_averages.txt", row.name=FALSE)
