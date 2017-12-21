DROP TABLE my_complications;

CREATE table my_complications as
SELECT
provider_id,
measure_name,
measure_id,
CASE WHEN compared_to_national = 'Worse than the National Rate' THEN 1
     WHEN compared_to_national = 'No Different than the National Rate' THEN 2
     WHEN compared_to_national = 'Better than the National Rate' THEN 3
     ELSE NULL END AS compared_to_national,
cast(score as decimal(5,2)) as score,
cast(denominator as decimal(5,0)) as denominator,
cast(score*denominator as decimal(5,1)) as numerator,
cast(concat (substr(measure_start_date, 7, 4), '-',
	     substr(measure_start_date, 1, 2), '-', 
	     substr(measure_start_date, 4, 2)) as date) as measure_start_date,
cast(concat (substr(measure_end_date, 7, 4), '-', 
	     substr(measure_end_date, 1, 2), '-', 
	     substr(measure_end_date, 4, 2)) as date) as measure_end_date
FROM complications 
WHERE compared_to_national NOT LIKE 'Not%' 
AND compared_to_national NOT LIKE 'Num%'
AND score NOT LIKE 'Not%'
AND denominator NOT LIKE 'Not%'
;
