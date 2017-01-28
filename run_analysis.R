activity_labels <- read.table("uci_har_dataset/activity_labels.txt")
features <- read.table("uci_har_dataset/features.txt")

desired_features <- grep(".*mean.*|.*std.*", as.character(features[,2]))
desired_features.names <- features[desired_features,2]
desired_features.names = gsub('-mean', 'Mean', desired_features.names)
desired_features.names = gsub('-std', 'Std', desired_features.names)
desired_features.names <- gsub('[-()]', '', desired_features.names)
