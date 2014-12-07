# Constant
NAME_FILTER <- 'mean\\(\\)|std\\(\\)|id|lblId'

# URL
trainSetUrl <- 'dataset/train/X_train.txt'
testSetUrl <- 'dataset/test/X_test.txt'
featureNameUrl <- 'dataset/features.txt'

trainSubjectIdUrl <- 'dataset/train/subject_train.txt'
testSubjectIdUrl <- 'dataset/test/subject_test.txt'

trainLblIDUrl <- 'dataset/train/y_train.txt'
testLblIDUrl <- 'dataset/test/y_test.txt'

activitiesLblUrl <- 'dataset/activity_labels.txt'

# Connection obj
trainSetConn <- file(trainSetUrl, 'r')
rm('trainSetUrl')

testSetConn <- file(testSetUrl, 'r')
rm('testSetUrl')

featureNameConn <- file(featureNameUrl, 'r')
rm('featureNameUrl')

trainSubjectIdConn <- file(trainSubjectIdUrl, 'r')
rm('trainSubjectIdUrl')

testSubjectIdConn <- file(testSubjectIdUrl, 'r')
rm('testSubjectIdUrl')

trainLblIDConn <- file(trainLblIDUrl, 'r')
rm('trainLblIDUrl')

testLblIDConn <- file(testLblIDUrl, 'r')
rm('testLblIDUrl')

activitiesLblConn <- file(activitiesLblUrl, 'r')
rm('activitiesLblUrl')

# Load data
trainSet <- read.table(trainSetConn, header = F,  stringsAsFactors = FALSE)
testSet <- read.table(testSetConn, header = F, stringsAsFactors = FALSE)

# Add feature name
featureName <- read.table(featureNameConn, header = F, stringsAsFactors = FALSE)
featureNameData <- featureName[, 2]
names(trainSet) <- featureNameData
names(testSet) <- featureNameData
rm('featureName')

# Add subject ID for train data
trainSubjectId <- read.table(trainSubjectIdConn, header = F, stringsAsFactors = FALSE)
trainSet$id <- trainSubjectId[, 1]
rm('trainSubjectId')

# Add label ID for train data
trainLblId <- read.table(trainLblIDConn, header = F, stringsAsFactors = FALSE)
trainSet$lblId <- trainLblId[, 1]
rm('trainLblId')

# Add subject ID for test data
testSubjectId <- read.table(testSubjectIdConn, header = F, stringsAsFactors = FALSE)
testSet$id <- testSubjectId[, 1]
rm('testSubjectId')

# Add label ID for test data
testLblId <- read.table(testLblIDConn, header = F, stringsAsFactors = FALSE)
testSet$lblId <- testLblId[, 1]
rm('testLblId')

# Merge dataset
dataset <- rbind(trainSet, testSet)
rm('trainSet')
rm('testSet')

# Filter mean and std and id column
dataset <- dataset[, grepl(NAME_FILTER, names(dataset))]

# Read the activities label
activitiesLabel <- read.table(activitiesLblConn, header = F, stringsAsFactors = FALSE)

# Group dataset by ID
subjectDatasetGroup <- split(dataset, as.factor(dataset$id))

# Get mean and std of each group
result <- dataset[0, ]
count <- 1
names(result) <- c('subjectId', 'activityLabel', featureNameData[grepl(NAME_FILTER, featureNameData)])
sapply(subjectDatasetGroup,
	function(obj) {
		activityGroup <- split(obj, as.factor(obj$lblId))
		sapply(activityGroup,
			function(group) {
                labelId <- group$lblId[[1]]
				recordData <- subset(group, select = -c(id, lblId))
				averageVars <- sapply(recordData, mean)
				averageVars <- as.list(averageVars)
				averageVars['subjectId'] <- obj$id[[1]]
				averageVars['activityLabel'] <- activitiesLabel[labelId, 2]
				result[count, ] <<- averageVars[c(67, 68, 1:66)]
                count <<- count + 1
			}
		)
	}
)

rownames(result) <- NULL
write.table(result, "tidy_data.txt", row.name = FALSE)
rm('result')

close(trainSetConn)
close(testSetConn)
close(featureNameConn)
close(trainSubjectIdConn)
close(testSubjectIdConn)
close(trainLblIDConn)
close(testLblIDConn)
close(activitiesLblConn)

rm('trainSetConn')
rm('testSetConn')
rm('featureNameConn')
rm('trainSubjectIdConn')
rm('testSubjectIdConn')
rm('trainLblIDConn')
rm('testLblIDConn')
rm('activitiesLblConn')