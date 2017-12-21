DROP TABLE my_effective_care;

CREATE table my_effective_care as
SELECT
provider_id,
measure_id,
measure_name,
CASE WHEN score = 'Very High (60,000+ patients annually)' THEN 4
     WHEN score = 'High (40,000 - 59,999 patients annually)' THEN 3
     WHEN score = 'Medium (20,000 - 39,999 patients annually)' THEN 2
     WHEN score = 'Low (0 - 19,999 patients annually)' THEN 1
     WHEN score = 'Not Available' THEN NULL
     ELSE cast(score as decimal(6,0)) END AS score,
cast(sample as decimal(6,0)) as sample,
cast(score*sample as decimal(6,0)) as numerator,
cast(concat (substr(measure_start_date, 7, 4), '-',
	     substr(measure_start_date, 1, 2), '-', 
	     substr(measure_start_date, 4, 2)) as date) as measure_start_date,
cast(concat (substr(measure_end_date, 7, 4), '-', 
	     substr(measure_end_date, 1, 2), '-', 
	     substr(measure_end_date, 4, 2)) as date) as measure_end_date
FROM effective_care 
WHERE score NOT LIKE 'Not%'
AND sample NOT LIKE 'Not%'
;
