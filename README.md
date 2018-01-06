Noah Randolph
30 Oct. 2017

This README document will also serve as the architecture design document.

To run the program, clone the repository "w205_fall_2017" from the Github account for noahrandolph. Navigate one level down to the "exercise_1" directory. Run the command "./run_all_scripts.sh". This assumes you have the connectivity and system requirements including Spark-SQL, Hadoop distributed file system (HDFS), Postgres, Hive Metastore, and the Bash Unix shell.

The high-level design of the program begins with downloading and saving the Medicare .csv files from data.medicare.gov into a staging directory. The headers are removed from each of the five .csv files of interest and the files are renamed. HDFS directories are then created and the five files are moved into them. All of the preceding actions are executed via the "load_data_lake.sh" script.

Next, a schema-on-read is defined in the script "hive_base_ddl.sql" using Spark-SQL. The schema structure can be seen in the file "ERD_Schema_on_Read.png." 

Following the schema-on-read, the data is then transformed into analytical tables, with proper data types and useful transformations. See the file "ERD_Analytical_Exercise_1.png" for the analytical schema. For each table in the schema, data rows with no available data are assumed to be without analytic usefulness and are removed. Only certain columns from the original "ERD_Schema_on_Read.png" tables remain, based on their analytical utility. The original table "measures" is not used in the analytical ERD, since it was found to have redundant information with the "complications" and "effective_care" tables, as well as the fact that the dates in the data do not span far back in history.

Lastly the analyses are performed via .sql scripts to answer the four exercise questions. These analyses are described with their accompanying .txt files in the subdirectories of "investigations," which are "best_hospitals," "best_states," "hospital_variability," and "hospitals_and_patients." The same .txt files also contain the resulting outputs of the analyses, which are ranking tables for all but "hospitals_and_patients.txt," which gives a correlation coefficient.

![](README_files/ERD_Analytical.png)


