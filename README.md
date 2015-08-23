**Getting and Cleaning Data - Course Project**

This repository contains the run\_analysis.R which handles the data
retrieveal from the provided URL link and cleans it to generate a
dataset containing the cleaned data.

The dataset being used is: [*Human Activity Recognition Using
Smartphones*](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

**Files**

The code takes for granted all the data is present in the same folder,
un-compressed and without names altered.

The files to be utilized to generate a cleaned data set are as follows:

-   test/subject\_test.txt

-   test/X\_test.txt

-   test/y\_test.txt

-   train/subject\_train.txt

-   train/X\_train.txt

-   train/y\_train.txt

-   features.txt

-   activity\_labels.txt

CodeBook.md describes the variables, the data, and any transformations
or work that was performed to clean up the data.

run\_analysis.R contains all the code to perform the analyses described
in the 5 steps. They can be launched in RStudio by just importing the
file. The final output of this R source code is ‘clean\_data.txt’.
