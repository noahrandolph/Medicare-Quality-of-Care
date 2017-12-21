-- NUMBER RANK THE HOSPITALS BY SURVEY RESPONSES


DROP TABLE 
hospital_rank_by_survey_responses;

CREATE TABLE 
hospital_rank_by_survey_responses as
SELECT 
provider_number, 
patient_experience_of_care_domain_score,
overall_rating_of_hospital_dimension_score,
communication_with_doctors_dimension_score,
communication_with_nurses_dimension_score,
RANK() OVER (ORDER BY patient_experience_of_care_domain_score DESC, overall_rating_of_hospital_dimension_score DESC, communication_with_doctors_dimension_score DESC,
communication_with_nurses_dimension_score DESC) AS rank
FROM my_survey_responses
;



-- NUMBER RANK THE HOSPITALS BY COMPLICATIONS AND EFFECTIVE CARE MEASURES



DROP TABLE
avg_complications_compared_to_national;

CREATE TABLE
avg_complications_compared_to_national as
SELECT
provider_id,
AVG(compared_to_national) as avg_compared_to_national
FROM my_complications
GROUP BY provider_id
;


DROP TABLE
effective_care_percentages;

CREATE TABLE
effective_care_percentages as
SELECT
provider_id,
AVG(score) as avg_percent
FROM my_effective_care
WHERE measure_id IN ('IMM_2', 'IMM_3_OP_27_FAC_ADHPCT', 'OP_2', 'OP_23', 'OP_29', 'OP_30', 'OP_31', 'OP_4', 'STK_4', 'VTE_5') 
GROUP BY provider_id
;


DROP TABLE
effective_care_procedure_times;

CREATE TABLE
effective_care_procedure_times as
SELECT
provider_id,
AVG(score) as avg_time
FROM my_effective_care
WHERE measure_id IN ('OP_1', 'OP_3b', 'OP_5') 
GROUP BY provider_id
;

DROP TABLE 
hospital_rank_by_measures_scores;

CREATE TABLE 
hospital_rank_by_measures_scores as
SELECT
hospitals.provider_id as provider_id,
hospitals.hospital_name as hospital_name,
hospitals.hospital_overall_rating as overall_rating,
complications.avg_compared_to_national as avg_complications_rating,
care_percentage.avg_percent as avg_care_percentage,
care_times.avg_time as avg_care_time,
RANK() OVER (ORDER BY hospitals.hospital_overall_rating DESC, complications.avg_compared_to_national DESC, care_percentage.avg_percent DESC, care_times.avg_time)
AS rank  
FROM my_hospitals hospitals
JOIN avg_complications_compared_to_national complications
ON hospitals.provider_id = complications.provider_id
JOIN effective_care_percentages care_percentage
ON hospitals.provider_id = care_percentage.provider_id
JOIN effective_care_procedure_times care_times
ON hospitals.provider_id = care_times.provider_id
;



-- CALCULATE COVARIANCE OF THE NUMBER RANKS BY HOSPITAL FROM THE TWO RANKINGS ABOVE


DROP TABLE
hospital_rank_by_measures_mean;

CREATE TABLE
hospital_rank_by_measures_mean as
SELECT
AVG(rank) as avg_rank
FROM hospital_rank_by_measures_scores
;


DROP TABLE
hospital_rank_by_measures_std_dev;

CREATE TABLE
hospital_rank_by_measures_std_dev as
SELECT
SQRT(SUM(POW(scores.rank - mean_rank.avg_rank, 2))/COUNT(scores.rank)) as standard_deviation
FROM hospital_rank_by_measures_scores as scores
CROSS JOIN hospital_rank_by_measures_mean as mean_rank
;


DROP TABLE
hospital_rank_by_surveys_mean;

CREATE TABLE
hospital_rank_by_surveys_mean as
SELECT
AVG(rank) as avg_rank
FROM hospital_rank_by_survey_responses
;


DROP TABLE
hospital_rank_by_surveys_std_dev;

CREATE TABLE
hospital_rank_by_surveys_std_dev as
SELECT
SQRT(SUM(POW(responses.rank - mean_rank.avg_rank, 2))/COUNT(responses.rank)) as standard_deviation
FROM hospital_rank_by_survey_responses as responses
CROSS JOIN hospital_rank_by_surveys_mean as mean_rank
;


DROP TABLE
hospital_rank_means;

CREATE TABLE
hospital_rank_means as
SELECT
meas_mean.avg_rank as meas_rank_avg,
surv_mean.avg_rank as surv_rank_avg
FROM hospital_rank_by_measures_mean as meas_mean
CROSS JOIN hospital_rank_by_surveys_mean as surv_mean
;


DROP TABLE
hospital_rank_covariance;

CREATE TABLE
hospital_rank_covariance as
SELECT
SUM((scores.rank - means.meas_rank_avg)*(responses.rank - means.surv_rank_avg))/COUNT(scores.rank) as covariance
FROM hospital_rank_by_measures_scores as scores
JOIN hospital_rank_by_survey_responses as responses
ON scores.provider_id = responses.provider_number
CROSS JOIN
hospital_rank_means as means
;



-- CALCULATE SPEARMAN'S RANK CORRELATION COEFFICIENT FROM THE COVARIANCE AND TWO STANDARD DEVIATIONS ABOVE


DROP TABLE
spearmans_rank_correlation_coeff;

CREATE TABLE
spearmans_rank_correlation_coeff as
SELECT
cast(covariance.covariance/(meas_std_dev.standard_deviation * surv_std_dev.standard_deviation) as decimal(4,3)) as correlation_coefficient
FROM hospital_rank_covariance as covariance
CROSS JOIN
hospital_rank_by_measures_std_dev as meas_std_dev
CROSS JOIN
hospital_rank_by_surveys_std_dev as surv_std_dev
;


SELECT * FROM spearmans_rank_correlation_coeff;
