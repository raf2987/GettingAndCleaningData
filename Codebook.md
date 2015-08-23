**Getting and Cleaning Data Course Project**

***August 23, 2015***

**Project Instruction**

The purpose of this project is to demonstrate your ability to collect,
work with, and clean a data set. The goal is to prepare tidy data that
can be used for later analysis. You will be graded by your peers on a
series of yes/no questions related to the project. You will be required
to submit: 1) a tidy data set as described below, 2) a link to a Github
repository with your script for performing the analysis, and 3) a code
book that describes the variables, the data, and any transformations or
work that you performed to clean up the data called CodeBook.md. You
should also include a README.md in the repo with your scripts. This repo
explains how all of the scripts work and how they are connected.  \
\
One of the most exciting areas in all of data science right now is
wearable computing - see for example [this
article ](http://www.insideactivitytracking.com/data-science-activity-tracking-and-the-battle-for-the-worlds-top-sports-brand/).
Companies like Fitbit, Nike, and Jawbone Up are racing to develop the
most advanced algorithms to attract new users. The data linked to from
the course website represent data collected from the accelerometers from
the Samsung Galaxy S smartphone. A full description is available at the
site where the data was obtained: \
\
<http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones> \
\
Here are the data for the project: \
\
<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip> \
\
 You should create one R script called run\_analysis.R that does the
following. 

1.  Merges the training and the test sets to create one data set.

2.  Extracts only the measurements on the mean and standard deviation
    > for each measurement. 

3.  Uses descriptive activity names to name the activities in the data
    > set

4.  Appropriately labels the data set with descriptive variable names. 

5.  From the data set in step 4, creates a second, independent tidy data
    > set with the average of each variable for each activity and
    > each subject.

The following steps where implemented in run\_analysis. R to be able to
perform the project requirements to collect and clean the data and
generate a final data frame.

Introduction
============

The script run\_analysis.R performs the 5 steps described in the course
project's definition. All similar data are merged using the rbind
function. Then columns with the mean and standard deviation measures
where extracted to create a whole dataset. Appropriate names where
assigned to the columns taken from features.txt while activity numbers
where assigned a descriptive name using activity\_labels.txt. A new data
set was then created containing the average measures for each subject
and activity type.

**Variables Used**

-   The variables
    x\_train, y\_train, x\_test, y\_test, subject\_train and subject\_test contain
    the data from the downloaded files.

-   x\_data, y\_data and subject\_data merge the previous datasets to
    further analysis.

-   features contains the correct names for the x\_data dataset, which
    are applied to the column names stored in mean\_std, a numeric
    vector used to extract the desired data.

-   A similar approach is taken with activity names
    through the activities variable.

-   all\_data merges x\_data, y\_data and subject\_data in a
    big dataset.

-   Finally, ave\_data contains the relevant averages which will be
    later stored in a ‘*clean\_data.txt’* file.  The ddply() from the
    plyr package is used to apply colMeans() and ease the development.

**Data Collection.**

1.  *The file is downloaded from the provided url and saved in the
    ‘data’ directory.*

    if(!file.exists("./data")){dir.create("./data")}

    fileUrl &lt;-
    "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

    if (!file.exists("./data/Dataset.zip")){

    download.file(fileUrl,destfile="./data/Dataset.zip")

    }

2.  *Unzip the file and set the work directory.*

    \# Unzip the required file

    unzip(zipfile="./data/Dataset.zip",exdir="./data")

    \# Set the pathname for the files

    path\_r &lt;- file.path("./data" , "UCI HAR Dataset")

    The unzipped files are in the ‘UCI HAR Dataset’ foler.

**Read the data files.**

The following files will be read:

-   test/X\_test.txt

-   test/Y\_test.txt

-   test/subject\_text.txt

-   train/X\_train.txt

-   train/Y\_train.txt

-   train/subject\_train.txt

-   features.txt

-   activity\_labels.txt

The Y\_train and Y\_test files contains values of ‘Activity’ variables.

The X\_train and X\_test files contains values of ‘Features’ variables.

The subject\_train and subject\_test files contains values of ‘Subject’
variables

The features.txt contains values for ‘Features’ variables

The activity\_labels.txt contains labels for ‘Activity’ variables.

1.  *Read the test, train and subject files.*

    x\_train &lt;- read.table(file.path(path\_r, "train",
    "X\_train.txt"),header = FALSE)

    y\_train &lt;- read.table(file.path(path\_r, "train",
    "Y\_train.txt"),header = FALSE)

    subject\_train &lt;- read.table(file.path(path\_r, "train",
    "subject\_train.txt"),header = FALSE)

    x\_test &lt;- read.table(file.path(path\_r, "test" , "X\_test.txt"
    ),header = FALSE)

    y\_test &lt;- read.table(file.path(path\_r, "test" , "Y\_test.txt"
    ),header = FALSE)

    subject\_test &lt;- read.table(file.path(path\_r, "test" ,
    "subject\_test.txt"),header = FALSE)

**Merge the train and test files to create data sets.**

1.  Concatenate the data tables by row.

    \# create 'x' data set

    x\_data &lt;- rbind(x\_train, x\_test)

    \# create 'y' data set

    y\_data &lt;- rbind(y\_train, y\_test)

    \# create 'subject' data set

    subject\_data &lt;- rbind(subject\_train, subject\_test)

**Extracts the measurements on the mean and standard deviation**

> features &lt;- read.table(file.path(path\_r,
> "features.txt"),head=FALSE)
>
> \# get only columns with mean() or std() in their names
>
> mean\_std &lt;- grep("-(mean|std)\\\\(\\\\)", features\[, 2\])
>
> \# subset the desired columns
>
> x\_data &lt;- x\_data\[, mean\_std\]
>
> \# correct the column names
>
> names(x\_data) &lt;- features\[mean\_std, 2\]

**Use descriptive names for activity**

> activities &lt;- read.table(file.path(path\_r,
> "activity\_labels.txt"),header = FALSE)
>
> \# update values with correct activity names
>
> y\_data\[, 1\] &lt;- activities\[y\_data\[, 1\], 2\]
>
> \# correct column name
>
> names(y\_data) &lt;- "activity"

**Appropriately label the data set with descriptive variable names**

\# correct column name

names(subject\_data) &lt;- "subject"

\# bind all the data in a single data set

all\_data &lt;- cbind(x\_data, y\_data, subject\_data)

**Create a second, independent tidy data set with the average of each
variable**

> ave\_data &lt;- ddply(all\_data, .(subject, activity), function(x)
> colMeans(x\[, 1:66\]))
>
> write.table(ave\_data, "clean\_data.txt", row.name=FALSE)
