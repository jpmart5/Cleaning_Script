# Load zip file from github repo
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://github.com/jpmart5/UCI_HAR_Dataset.zip/" 
download.file(fileUrl,destfile="./data/UCI_HAR_Dataset.zip/")

# Unzip dataSet to /data directory
unzip(zipfile="./data/UCI_HAR_Dataset.zip/",exdir="./data")

# Read in trng tables:
x_train <- read.table("./data/UCI_HAR_Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI_HAR_Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI_HAR_Dataset/train/subject_train.txt")

# Read in testing tables fm data directory:
x_test <- read.table("./data/UCI_HAR_Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI_HAR_Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI_HAR_Dataset/test/subject_test.txt")

# Reading vector off of features table:
features <- read.table('./data/UCI_HAR_Dataset/features.txt')

# Reading vector off of activity labels table:
activityLabels = read.table('./data/UCI_HAR_Dataset/activity_labels.txt')

# Assigning tables column labels:
colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"
      
colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"
      
colnames(activityLabels) <- c('activityId','activityType')

# Merging data into single set:
mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
setAllInOne <- rbind(mrg_train, mrg_test)

# Read col names:
colNames <- colnames(setAllInOne)

# Vector for ID, mean and standard deviation:
mean_and_std <- (grepl("activityId" , colNames) | 
                 grepl("subjectId" , colNames) | 
                 grepl("mean.." , colNames) | 
                 grepl("std.." , colNames) 
                 )

# Subset from setAllInOne:
setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]

# Naming activities in data set with descriptive names
setWithActivityNames <- merge(setForMeanAndStd, activityLabels,
                              by='activityId',
                              all.x=TRUE)

# 2nd data set creation for avg of each variable and subject:
secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]

# Writing 2nd data set into txt file:
write.table(secTidySet, "secTidySet.txt", row.name=FALSE)






