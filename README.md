Getting-and-Cleaning-Data-Course-Project
========================================

Submission for Coursera "Getting and Cleaning Data" Course Project

The run_analysis.R script performs the following operations:

1. Downloads the Dataset.zip file.
2. Unzips the Dataset.zip file.
3. Creates a dt_activites Data Table from the activity_labels.txt file.
4. Creates Data Tables from the following training files:
  1. subject_train.txt
  2. y_train.txt
  3. X_train.txt
5. Column binds the 3 subject/train data tables created above as the dt_train data table.
6. Creates Data Tables from the following trest files:
  1. subject_test.txt
  2. y_test.txt
  3. X_test.txt
7. Column binds the 3 subject/test data tables created above as the dt_test data table.
8. Row binds the dt_train and dt_test data tables as the dt_tidy data table.
9. Creates a dt_features data table from the features.txt file.
10. Names the columns of the dt_tidy data table for later reference.
11. Uses sqldf to select only the means and std feature names from the dt_features data table.
12. Prune the dt_tidy data table to include only the Subject, Activity, mean(s) and std(s) columns.
13. Create an empty dt_tidy_means_sd data table to hold the final data table.
14. Names the columns of the dt_tidy_means_sd data table for later reference.
15. For each subject, and each activity:
  1. create a temporary data table containing the subjects data only.
  2. row bind the subject, activity and averages of the variables, mean and sd, to the dt_tidy_means_sd data table.
16. Convert the Activity column to factors.
17. Convert the Subject column to factors.
18. write the final data table to dt_tidy_means_sd.txt

See codebook.txt for details of the variables.

The data* used by this script was obtained from:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#


\* Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012
