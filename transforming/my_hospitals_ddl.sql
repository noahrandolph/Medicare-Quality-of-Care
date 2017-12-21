DROP TABLE my_hospitals;

CREATE table my_hospitals as
SELECT
provider_id,
hospital_name,
state,
cast(hospital_overall_rating as decimal(1,0)) hospital_overall_rating
FROM hospitals
WHERE hospital_overall_rating NOT LIKE 'Not%'
;
