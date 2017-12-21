DROP TABLE my_survey_responses;

CREATE table my_survey_responses as
SELECT
provider_number,
CASE WHEN communication_with_nurses_improvement_points = '10 out of 10' THEN 10
     ELSE cast(substr(communication_with_nurses_improvement_points,1,1) as decimal(1,0))
     END AS communication_with_nurses_improvement_points,
CASE WHEN communication_with_nurses_dimension_score = '10 out of 10' THEN 10
     ELSE cast(substr(communication_with_nurses_dimension_score,1,1) as decimal(1,0))
     END AS communication_with_nurses_dimension_score,
CASE WHEN communication_with_doctors_improvement_points = '10 out of 10' THEN 10
     ELSE cast(substr(communication_with_doctors_improvement_points,1,1) as decimal(1,0))
     END AS communication_with_doctors_improvement_points,
CASE WHEN communication_with_doctors_dimension_score = '10 out of 10' THEN 10
     ELSE cast(substr(communication_with_doctors_dimension_score,1,1) as decimal(1,0))
     END AS communication_with_doctors_dimension_score,
CASE WHEN responsiveness_of_hospital_staff_improvement_points = '10 out of 10' THEN 10
     ELSE cast(substr(responsiveness_of_hospital_staff_improvement_points,1,1) as 
     decimal(1,0)) 
     END AS responsiveness_of_hospital_staff_improvement_points,
CASE WHEN responsiveness_of_hospital_staff_dimension_score = '10 out of 10' THEN 10
     ELSE cast(substr(responsiveness_of_hospital_staff_dimension_score,1,1) as 
     decimal(1,0)) 
     END AS responsiveness_of_hospital_staff_dimension_score,
CASE WHEN pain_management_improvement_points = '10 out of 10' THEN 10
     ELSE cast(substr(pain_management_improvement_points,1,1) as decimal(1,0))
     END AS pain_management_improvement_points,
CASE WHEN pain_management_dimension_score = '10 out of 10' THEN 10
     ELSE cast(substr(pain_management_dimension_score,1,1) as decimal(1,0))
     END AS pain_management_dimension_score,
CASE WHEN communication_about_medicines_improvement_points = '10 out of 10' THEN 10
     ELSE cast(substr(communication_about_medicines_improvement_points,1,1) as
     decimal(1,0))  
     END AS communication_about_medicines_improvement_points,
CASE WHEN communication_about_medicines_dimension_score = '10 out of 10' THEN 10
     ELSE cast(substr(communication_about_medicines_dimension_score,1,1) as decimal(1,0)) 
     END AS communication_about_medicines_dimension_score,
CASE WHEN cleanliness_and_quietness_of_hospital_environment_improvement_points = '10 out 
     of 10' THEN 10
     ELSE 
     cast(substr(cleanliness_and_quietness_of_hospital_environment_improvement_points,
     1,1) as decimal(1,0)) 
     END AS cleanliness_and_quietness_of_hospital_environ_improvement_points,
CASE WHEN cleanliness_and_quietness_of_hospital_environment_dimension_score = '10 out of 
     10' THEN 10
     ELSE cast(substr(cleanliness_and_quietness_of_hospital_environment_dimension_score,
     1,1) as decimal(1,0)) 
     END AS cleanliness_and_quietness_of_hospital_environ_dimension_score,
CASE WHEN discharge_information_improvement_points = '10 out of 10' THEN 10
     ELSE cast(substr(discharge_information_improvement_points,1,1) as decimal(1,0))
     END AS discharge_information_improvement_points,
CASE WHEN discharge_information_dimension_score = '10 out of 10' THEN 10
     ELSE cast(substr(discharge_information_dimension_score,1,1) as decimal(1,0))
     END AS discharge_information_dimension_score,
CASE WHEN overall_rating_of_hospital_improvement_points = '10 out of 10' THEN 10
     ELSE cast(substr(overall_rating_of_hospital_improvement_points,1,1) as decimal(1,0)) 
     END AS overall_rating_of_hospital_improvement_points,
CASE WHEN overall_rating_of_hospital_dimension_score = '10 out of 10' THEN 10
     ELSE cast(substr(overall_rating_of_hospital_dimension_score,1,1) as decimal(1,0)) 
     END AS overall_rating_of_hospital_dimension_score,
cast(hcahps_base_score as decimal(2,0)) as hcahps_base_score, 
cast(hcahps_consistency_score as decimal(2,0)) as hcahps_consistency_score,
cast(hcahps_base_score + hcahps_consistency_score as decimal(3,0)) as patient_experience_of_care_domain_score
FROM survey_responses
WHERE communication_with_nurses_improvement_points NOT LIKE 'Not%'
AND communication_with_doctors_improvement_points NOT LIKE 'Not%'
AND responsiveness_of_hospital_staff_improvement_points NOT LIKE 'Not%'
AND pain_management_improvement_points NOT LIKE 'Not%'
AND communication_about_medicines_improvement_points NOT LIKE 'Not%'
AND cleanliness_and_quietness_of_hospital_environment_improvement_points NOT LIKE 'Not%'
AND discharge_information_improvement_points NOT LIKE 'Not%'
AND overall_rating_of_hospital_improvement_points NOT LIKE 'Not%'
;
