# ------ load features
features = read.csv("features.txt", header=FALSE, sep = " ")
colnames(features) = c("col_id", "col_name")
selected_col_index = grep("(-mean\\(\\)|-std\\(\\))",features$col_name)
features$col_name = gsub("(\\(\\))","",features$col_name,ignore.case=T)
features$col_name = gsub("-","_",features$col_name,ignore.case=T)

# ------ load activity_labels
activity_labels = read.csv("activity_labels.txt", header=FALSE, sep = " ")
colnames(activity_labels) = c("activity_id", "activity_name")

# ------ load test data
test_data = read.table("test/X_test.txt", header=FALSE, strip.white=TRUE)
colnames(test_data) = features$col_name
test_data = test_data[,selected_col_index]

# ------ add subject,activity to test data
subject_test = scan("test/subject_test.txt")
test_data$subject = subject_test
y_test = scan("test/y_test.txt")
test_data$activity = activity_labels$activity_name[y_test]

# ------ load train data
train_data = read.table("train/X_train.txt", header=FALSE, strip.white=TRUE)
colnames(train_data) = features$col_name
train_data = train_data[,selected_col_index]

# ------ add subject,activity to train data
subject_train = scan("train/subject_train.txt")
train_data$subject = subject_train
y_train = scan("train/y_train.txt")
train_data$activity = activity_labels$activity_name[y_train]

# ------ merge data
data = rbind(train_data, test_data)

# ------ calculate mean
result = aggregate(. ~ subject + activity, data, mean)

write.table(result, "tidy_data.txt", row.names=FALSE)
