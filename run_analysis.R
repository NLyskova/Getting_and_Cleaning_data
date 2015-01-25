#Download and unzip the dataset
fileUrl <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="Dataset.zip",method="curl")
unzip(zipfile="Dataset.zip")

#get rid of spaces in the directory name
dir.create("UCI_HAR_Dataset")
file.rename("UCI HAR Dataset", "UCI_HAR_Dataset")
path.dataset <- "./UCI_HAR_Dataset"

#Read all the files apart from those in the "Inertial Signals" directories
#Type of activity
data.Y.Test  <- read.table(file.path(path.dataset, "test" , "y_test.txt"),header = FALSE)
data.Y.Train <- read.table(file.path(path.dataset, "train", "y_train.txt"),header = FALSE)
#Subject (volunteers)
data.Subject.Train <- read.table(file.path(path.dataset, "train", "subject_train.txt"),header = FALSE)
data.Subject.Test  <- read.table(file.path(path.dataset, "test" , "subject_test.txt"),header = FALSE)
#Features (measured quantities)
data.X.Test  <- read.table(file.path(path.dataset, "test" , "X_test.txt" ),header = FALSE)
data.X.Train <- read.table(file.path(path.dataset, "train", "X_train.txt"),header = FALSE)

# 1. Merge the training and the test sets to create one data set.
data.Y <- rbind(data.Y.Test,data.Y.Train)
data.Subject <- rbind(data.Subject.Test,data.Subject.Train)
data.X <- rbind(data.X.Test,data.X.Train)
# Label the columns
names(data.Subject) <-c("Volunteer")
names(data.Y) <- c("Activity")
data.X.Names <- read.table(file.path(path.dataset, "features.txt"),head=FALSE)
str(data.X.Names)
names(data.X) <- as.character(data.X.Names$V2)

merged.dataset <- cbind(data.X,data.Subject,data.Y)

# 2. Extract only the measurements on the mean and standard deviation for each measurement. 
mean.and.std.X <- grep("mean\\(\\)|std\\(\\)",data.X.Names$V2,ignore.case=FALSE)
mean.and.std.dataset <- merged.dataset[,mean.and.std.X]
merged.dataset <- cbind(data.Subject,data.Y,mean.and.std.dataset)
                        
# 3. Use descriptive activity names to name the activities in the data set.
Activity.Labels  <- read.table(file.path(path.dataset, "activity_labels.txt" ),header = FALSE)
#Activity.Labels
merged.dataset$Activity <- Activity.Labels$V2[merged.dataset$Activity]
merged.dataset$Activity <- gsub("WALKING_DOWNSTAIRS","Walking Downstairs",merged.dataset$Activity)
merged.dataset$Activity <- gsub("WALKING_UPSTAIRS","Walking Upstairs",merged.dataset$Activity)
merged.dataset$Activity <- gsub("WALKING","Walking",merged.dataset$Activity)
merged.dataset$Activity <- gsub("LAYING","Laying",merged.dataset$Activity)
merged.dataset$Activity <- gsub("STANDING","Standing",merged.dataset$Activity)
merged.dataset$Activity <- gsub("SITTING","Sitting",merged.dataset$Activity)

# 4.Appropriately label the data set with descriptive variable names. 
# From features_info.txt:
# prefix 't' -> time
# prefix 'f' -> frequency
# 'Acc' -> Accelerometer
# 'Gyro' -> Gyroscope 
# 'Mag' -> Magnitude

names(merged.dataset) <- gsub("^t", "time", names(merged.dataset))
names(merged.dataset) <- gsub("tBody", "timeBody", names(merged.dataset))
names(merged.dataset) <- gsub("^f", "frequency", names(merged.dataset))
names(merged.dataset) <- gsub("Acc", "Accelerometer", names(merged.dataset))
names(merged.dataset) <- gsub("Gyro", "Gyroscope", names(merged.dataset))
names(merged.dataset) <- gsub("Mag", "Magnitude", names(merged.dataset))
# Remove the parenthesis
names(merged.dataset) <- gsub("\\(\\)", "", names(merged.dataset))
# Replace `BodyBody' by `Body'
names(merged.dataset) <- gsub("BodyBody", "Body", names(merged.dataset))

# 5. From the data set in step 4, create a second, independent tidy data set 
# with the average of each variable for each activity and each subject.
library(data.table)
tidy.dataset <- data.table(merged.dataset)
tidy.dataset <- tidy.dataset[, lapply(.SD, mean), by = "Volunteer,Activity"]
write.table(tidy.dataset, file = "tidydata.txt",row.name=FALSE)

