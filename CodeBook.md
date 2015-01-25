Code Book
========

## Getting and Cleaning Data Project
The purpose of this project is to demonstrate ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. 

### Source Data
The source data for this project can be found here: 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
A full description of the data used is available at 
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

### Raw Data Information
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

### Files in the dataset
The dataset includes the following files:
* 'README.txt'
* 'features_info.txt': Shows information about the variables used on the feature vector.
* 'features.txt': List of all features.
* 'activity_labels.txt': Links the class labels with their activity name.
* 'train/X_train.txt': Training set.
* 'train/y_train.txt': Training labels.
* 'test/X_test.txt': Test set.
* 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 
* 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
* 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 
* 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 
* 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

### Attribute Information
For each record in the dataset the following information is provided: 
* Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration. 
* Triaxial Angular velocity from the gyroscope. 
* A 561-feature vector with time and frequency domain variables. 
* Its activity label. 
* An identifier of the subject who carried out the experiment.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. 

The set of variables that were estimated from these signals are: 

mean(): Mean value
std(): Standard deviation
mad(): Median absolute deviation 
max(): Largest value in array
min(): Smallest value in array
sma(): Signal magnitude area
energy(): Energy measure. Sum of the squares divided by the number of values. 
iqr(): Interquartile range 
entropy(): Signal entropy
arCoeff(): Autorregresion coefficients with Burg order equal to 4
correlation(): correlation coefficient between two signals
maxInds(): index of the frequency component with largest magnitude
meanFreq(): Weighted average of the frequency components to obtain a mean frequency
skewness(): skewness of the frequency domain signal 
kurtosis(): kurtosis of the frequency domain signal 
bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
angle(): Angle between to vectors.


### Data Transformation
Data manipulation is done with the run_analysis.R script. As a result a tidy data set is produced.

#### Section 1. Merge the training and the test sets to create one data set.
After downloading and unzipping the raw data, read into tables the data located in
* y_test.txt
* y_train.txt
* subject_test.txt
* subject_train.txt
* X_test.txt
* X_train.txt.

Test and training data (X_test.txt, X_train.txt), subject ids (subject_test.txt, subject_train.txt) and activity ids (y_test.txt, y_train.txt) are merged together to obtain one single data set. Activity variables are labelled with the names according to features.txt.

#### Section 2. Extract only the measurements on the mean and standard deviation for each measurement. 

Subset the merged data set  to keep only activity variables (columns) with the measurements on the mean (variables with labels that contain "mean") and standard deviation (variables with labels that contain "std").

#### Section 3. Use descriptive activity names to name the activities in the data set

Values (numbers from 1 to 6) in the "Activity" column in the merged data set are changed with descriptive activity names (Walking, Wlking Upstairs, Walking Downstairs, Laying, Sitting, Standing).

#### Section 4. Appropriately label the data set with descriptive activity names.
'gsub' function is used for pattern replacement to ptoduce more descriptive data labels.

#### Section 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject.

A final tidy data set where numeric variables are averaged for each activity and each subject is created. For this step the "data.table" packages is used.

The tidy data set contains a header, 180 rows and 68 columns. The columns are the following:

* An identifier of the subject who carried out the experiment (__Volunteer__): numbers from 1 to 30
* Type of activity (__Activity__): Walking, Wlking Upstairs, Walking Downstairs, Laying, Sitting, Standing
* A numeric 66-feature vector with time and frequency domain signal variables for X, Y and Z coordinates.  

The numeric vector contains mean and standard deviation data on signals from

* Body Accelerometer
* Gravity Accelerometer 
* Body Accelerometer Jerk
* Body Gyroscope
* Body Gyroscope Jerk
* Body Accelerometer Magnitude
* Body Gyroscope Magnitude

The column names for the numeric vector are constructed in the following way (for example, "timeBodyAccelerometer-mean-X"):
1. First part denotes the domain: "time" or "frequency",
2. The second part comes from the signal type (in the provided example "BodyAccelerometer"),
3. The third part shows whether it is a mean or a standard deviation ("-mean-" or "-std-").
4. The fourth part ("-X", "-Y", "-Z") denotes the coordinate along which the quantity has been measured.

References
----------

1.  <a name="uci-har"/>Human Activity Recognition Using Smartphones Data Set.
    URL: <http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>.
