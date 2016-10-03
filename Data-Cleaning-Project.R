# Load zip file from github repo
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://github.com/jpmart5/UCI_HAR_Dataset.zip/commit/ed0551a3a9a8c74de678d3aa6544232d8f575fa6" 
download.file(fileUrl,destfile="./data/UCI_HAR_Dataset.zip")

# Read in trng tables:
x_train <- read.table("https://github.com/jpmart5/UCI_HAR_Dataset.zip/blob/ed0551a3a9a8c74de678d3aa6544232d8f575fa6/train/X_train.txt")
y_train <- read.table("https://github.com/jpmart5/UCI_HAR_Dataset.zip/blob/ed0551a3a9a8c74de678d3aa6544232d8f575fa6/train/y_train.txt")
subject_train <- read.table("https://github.com/jpmart5/UCI_HAR_Dataset.zip/blob/ed0551a3a9a8c74de678d3aa6544232d8f575fa6/train/subject_train.txt")

# Read in testing tables fm data directory:
x_test <- read.table("https://github.com/jpmart5/UCI_HAR_Dataset.zip/blob/master/test/X_test.txt")
y_test <- read.table("https://github.com/jpmart5/UCI_HAR_Dataset.zip/blob/master/test/y_test.txt")
subject_test <- read.table("https://github.com/jpmart5/UCI_HAR_Dataset.zip/blob/master/test/subject_test.txt")

# Reading vector off of features table:
features <- read.table('https://github.com/jpmart5/UCI_HAR_Dataset.zip/blob/master/features.txt')

# Reading vector off of activity labels table:
activityLabels = read.table('https://github.com/jpmart5/UCI_HAR_Dataset.zip/blob/master/activity_labels.txt')

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






