## Load Data
# load test data
testdata <- read.table("./UCI HAR Dataset/test/X_test.txt")
label.index <- read.table("./UCI HAR Dataset/test/y_test.txt")
test.subjects <- read.table("./UCI HAR Dataset/test/subject_test.txt")
# load training data
traindata <- read.table("./UCI HAR Dataset/train/X_train.txt")
train.index <- read.table("./UCI HAR Dataset/train/y_train.txt")
train.subjects <- read.table("./UCI HAR Dataset/train/subject_train.txt")
# load features
features <- read.table("./UCI HAR Dataset/features.txt")

# GOAL: find all mean calculations
# only using lower case mean to avoid angle measurements with 'Mean'
mean <- grepl("mean", features$V2)
# remove meanfreq since not mean of measurement but of frequency components
# as described in features_info.txt document
freq <- grepl("Freq", features$V2)

# subset features without meanfreq
features <- features[!(freq),]
#subset 46 features with mean
mean.features <- features[mean,]

## Goal: find all standard deviation calculations
std <- grepl("std", features$V2)
# subset 33 features calculating standard deviation
std.features <- features[std,]

# combine standard deviation and mean calculations
SnM.features <- rbind(mean.features, std.features)

# Subset data to desired measurements
measured.date <- traindata[,SnM.features$V1]
measured.date <- testdata[,SnM.features$V1]

# convert label index to label names
test.label <- lapply(label.index,function(x) gsub(1,"Walking",x))
test.label <- lapply(test.label,function(x) gsub(2,"Walking_Upstairs",x))
test.label <- lapply(test.label,function(x) gsub(3,"Walking_Downstairs",x))
test.label <- lapply(test.label,function(x) gsub(4,"Sitting",x))
test.label <- lapply(test.label,function(x) gsub(5,"Standing",x))
test.label <- lapply(test.label,function(x) gsub(6,"Laying",x))

# bind labels to appropriate test data
testdata <- cbind(test.label, test.subjects, testdata)

# convert label index to label names
train.label <- lapply(train.index,function(x) gsub(1,"Walking",x))
train.label <- lapply(train.label,function(x) gsub(2,"Walking_Upstairs",x))
train.label <- lapply(train.label,function(x) gsub(3,"Walking_Downstairs",x))
train.label <- lapply(train.label,function(x) gsub(4,"Sitting",x))
train.label <- lapply(train.label,function(x) gsub(5,"Standing",x))
train.label <- lapply(train.label,function(x) gsub(6,"Laying",x))

traindata <- cbind(train.label, train.subjects, traindata)

# bind test data with training data
totaldata <- rbind(testdata, traindata)

# name variables
names(totaldata) <- c("Label", "Subject", as.character(SnM.features$V2))

# create new feature text file for code book
write.table(SnM.features, file = "NewFeatures.txt")
write.table(totaldata$Label, file = "NewLabel.txt")
