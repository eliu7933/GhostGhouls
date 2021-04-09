# GhostGhouls

This project includes an analysis to determine different kinds of monsters based off of different factors such as whether the creature has a soul, the bone length, the color of the creature, rotting flesh, and hair length.

There are various files in the repository each playing its part in this analysis. This README.md file includes information about this project. The .gitignore file tells which files to ignore. The GhostGhoulsAnalysis.R file includes the different analyses that were performed to draw predictions. The test.csv and train.csv files are files that include the datasets with the train.csv file including a "type" column which is the outcome variable of the analysis. Other files such as classification_submission_rf.csv, multilayerperceptron.csv, probs_gbm.csv, probs_svm.csv, and xgbTree_probs.csv are files that contains predictions that was also used in the analysis.

Methods that were used for data cleaning and feature engineering included stacking all of the predicitons that were created using different prediction modeling. These files are classification_submission_rf.csv, multilayerperceptron.csv, probs_gbm.csv, probs_svm.csv, and xgbTree_probs.csv. Pre-processing was also used to make these predictions independent of one another which could then be applied to a modeling method to draw new predictions.

Methods that were used to generate predictions were random forest with cross validation and/or repeated cross validation.
