#! /bin/bash

# download data files from site into staging directory, remove headers, copy to HDFS
./loading_and_modeling/load_data_lake.sh

# create schema-on-read SQL tables of each file
spark-sql -f ./loading_and_modeling/hive_base_ddl.sql

# transform data into analytical tables with proper data types and useful transformations
spark-sql -f ./transforming/my_complications_ddl.sql
spark-sql -f ./transforming/my_effective_care_ddl.sql
spark-sql -f ./transforming/my_hospitals_ddl.sql
spark-sql -f ./transforming/my_survey_responses_ddl.sql

# run 4 queries to answer the 4 exercise_1 questions
spark-sql -f ./investigations/best_hospitals/best_hospitals.sql
spark-sql -f ./investigations/best_states/best_states.sql
spark-sql -f ./investigations/hospital_variability/hospital_variability.sql
spark-sql -f ./investigations/hospitals_and_patients/hospitals_and_patients.sql

# clean exit
exit
