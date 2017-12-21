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
best_hospitals;

CREATE TABLE
best_hospitals as
SELECT
hospitals.provider_id,
hospitals.hospital_name,
hospitals.hospital_overall_rating as overall_rating,
cast(complications.avg_compared_to_national as decimal(4,3)) as avg_complications_rating,
cast(care_percentage.avg_percent as decimal(4,2)) as avg_care_percentage,
cast(care_times.avg_time as decimal(4,1)) as avg_care_time  
FROM my_hospitals hospitals
JOIN avg_complications_compared_to_national complications
ON hospitals.provider_id = complications.provider_id
JOIN effective_care_percentages care_percentage
ON hospitals.provider_id = care_percentage.provider_id
JOIN effective_care_procedure_times care_times
ON hospitals.provider_id = care_times.provider_id
ORDER BY overall_rating DESC, avg_complications_rating DESC, avg_care_percentage DESC, avg_care_time 
LIMIT 10
;

SELECT * FROM best_hospitals;


