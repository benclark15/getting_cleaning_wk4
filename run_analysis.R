run_analysis <- function(){
  ## DON'T FORGET TO MAKE A README FILE, CODEBOOK AND TIDY DATA TEXT FILE
  library(data.table)
  library(dplyr)
  
  ## Get all of the data files in DT format
  act_labels_dt <- as.data.table(read.table("activity_labels.txt", stringsAsFactors = FALSE, na.strings = "NA"))
  features_dt <- as.data.table(read.table("features.txt", stringsAsFactors = FALSE, na.strings = "NA"))
  ## Train labels are the activity IDs (not names)
  train_labels_dt <- as.data.table(read.table("train/y_train.txt", stringsAsFactors = FALSE, na.strings = "NA"))
  subj_train_dt <- as.data.table(read.table("train/subject_train.txt", stringsAsFactors = FALSE, na.strings = "NA"))
  train_dt <- as.data.table(read.table("train/x_train.txt", stringsAsFactors = FALSE, na.strings = "NA"))
  ## Test labels are the activity IDs (not names)
  test_labels_dt <- as.data.table(read.table("test/y_test.txt", stringsAsFactors = FALSE, na.strings = "NA"))
  subj_test_dt <- as.data.table(read.table("test/subject_test.txt", stringsAsFactors = FALSE, na.strings = "NA"))
  test_dt <- as.data.table(read.table("test/x_test.txt", stringsAsFactors = FALSE, na.strings = "NA"))
  
  ## Put the activity IDs at the beginning of the data sets
  merged_train_dt_1 <- cbind(train_labels_dt,train_dt)
  merged_test_dt_1 <- cbind(test_labels_dt,test_dt)
  
  ## Just take the subject IDs, not the sequential number
  cleaned_subj_train_dt <- select(subj_train_dt,V1)
  ## Append the subject IDs to the training data
  merged_train_dt_2 <- cbind(cleaned_subj_train_dt,merged_train_dt_1)
  
  ## Just take the subject IDs, not the sequential number
  cleaned_subj_test_dt <- select(subj_test_dt,V1)
  ## Append the subject IDs to the test data
  merged_test_dt_2 <- cbind(cleaned_subj_test_dt,merged_test_dt_1)
  
  ## Merge the training and test data to create a single dataset
  merged_dt <- rbind(merged_train_dt_2,merged_test_dt_2)
  
  ## Give an understandable variable name for the subject ID and activity
  names(merged_dt)[1] <- "subjectID"
  names(merged_dt)[2] <- "activity"
  
  ## Order by subject and activity
  merged_dt <- arrange(merged_dt, subjectID, activity)
  
  ## Determine how many features, for following loop
  num_features <- nrow(features_dt)
  
  ## Use each of the feature names as a column name on the merged datatable
  ## These are much more descriptive names than V1, V2, V3, etc
  for (i in 1:num_features){
    ## Have to put i into column name as some names are duplicated otherwise
    new_col_name <- paste(as.character(features_dt[i,2]),sep = "","_",i)
    ## Clean the column name up as it has other reserved characters that can
    ## confuse the dplyr functions
    new_col_name <- gsub("-","_",new_col_name)
    new_col_name <- gsub("\\(\\)","",new_col_name)
    ## 2 is added to i as the first two columns are the subject id and activity
    names(merged_dt)[i+2] <- new_col_name
  }
  
  ## Extract only the column names that have mean or std
  final_dt <- select(merged_dt,matches("subjectID|activity|mean|std"))
  
  ## Replace numeric activity codes with descriptive labels
  final_dt$activity <- as.character(merged_dt$activity)
  final_dt$activity[final_dt$activity == "1"] <- "WALKING"
  final_dt$activity[final_dt$activity == "2"] <- "WALKING_UPSTAIRS"
  final_dt$activity[final_dt$activity == "3"] <- "WALKING_DOWNSTAIRS"
  final_dt$activity[final_dt$activity == "4"] <- "SITTING"
  final_dt$activity[final_dt$activity == "5"] <- "STANDING"
  final_dt$activity[final_dt$activity == "6"] <- "LAYING"
  
  ## Group the data by subject and activity
  by_subj_act <- group_by(final_dt,subjectID,activity)
  
  ## Get the measurable columns to use for the summarise_at
  non_subj_act <- by_subj_act[-(1:2)]
  
  ## Create the final dataset to be written to the output file
  output_ds <- summarise_at(by_subj_act, names(non_subj_act), mean, na.rm = TRUE)
  
  ## Write the output to a file
  write.table(output_ds, "tidyData.txt", sep = ",")
  
}