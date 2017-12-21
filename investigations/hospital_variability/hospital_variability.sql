DROP TABLE
complications_measures_means;

CREATE TABLE
complications_measures_means as
SELECT
measure_id,
AVG(numerator) as avg_numerator
FROM my_complications
WHERE numerator IS NOT NULL
GROUP BY measure_id
;

DROP TABLE
complications_measures_std_dev;

CREATE TABLE
complications_measures_std_dev as
SELECT
complications.measure_id as measure_id,
SQRT(SUM(POW(numerator - means.avg_numerator, 2))/COUNT(numerator)) as standard_deviation
FROM my_complications as complications
JOIN complications_measures_means as means
ON complications.measure_id = means.measure_id
WHERE numerator IS NOT NULL
GROUP BY complications.measure_id
;

DROP TABLE
complications_coef_of_variation;

CREATE TABLE
complications_coef_of_variation as
SELECT
std_dev.measure_id as measure_id,
std_dev.standard_deviation/means.avg_numerator as coef_of_var
FROM complications_measures_std_dev as std_dev
JOIN complications_measures_means as means
ON std_dev.measure_id = means.measure_id
;

DROP TABLE
effective_care_measures_means;

CREATE TABLE
effective_care_measures_means as
SELECT
measure_id,
AVG(numerator) as avg_numerator
FROM my_effective_care
WHERE numerator IS NOT NULL
AND measure_id NOT IN ('ED_1b','ED_2b','OP_1','OP_18b','OP_20','OP_21','OP_3b','OP_5')
GROUP BY measure_id
;

DROP TABLE
eff_care_meas_std_dev;

CREATE TABLE
eff_care_meas_std_dev as
SELECT
effective_care.measure_id as measure_id,
SQRT(SUM(POW(numerator - means.avg_numerator, 2))/COUNT(numerator)) as standard_deviation
FROM my_effective_care as effective_care
JOIN effective_care_measures_means as means
ON effective_care.measure_id = means.measure_id
WHERE numerator IS NOT NULL
GROUP BY effective_care.measure_id
;

DROP TABLE
effective_care_coef_of_variation;

CREATE TABLE
effective_care_coef_of_variation as
SELECT
std_dev.measure_id as measure_id,
std_dev.standard_deviation/means.avg_numerator as coef_of_var
FROM eff_care_meas_std_dev as std_dev
JOIN effective_care_measures_means as means
ON std_dev.measure_id = means.measure_id
;


DROP TABLE
effective_care_time_means;

CREATE TABLE
effective_care_time_means as
SELECT
measure_id,
AVG(score) as avg_score
FROM my_effective_care
WHERE measure_id IN ('ED_1b','ED_2b','OP_1','OP_18b','OP_20','OP_21','OP_3b','OP_5')
GROUP BY measure_id
;

DROP TABLE
eff_care_time_std_dev;

CREATE TABLE
eff_care_time_std_dev as
SELECT
effective_care.measure_id as measure_id,
SQRT(SUM(POW(score - means.avg_score, 2))/COUNT(score)) as standard_deviation
FROM my_effective_care as effective_care
JOIN effective_care_time_means as means
ON effective_care.measure_id = means.measure_id
GROUP BY effective_care.measure_id
;

DROP TABLE
effective_care_time_coef_of_variation;

CREATE TABLE
effective_care_time_coef_of_variation as
SELECT
std_dev.measure_id as measure_id,
std_dev.standard_deviation/means.avg_score as coef_of_var
FROM eff_care_time_std_dev as std_dev
JOIN effective_care_time_means as means
ON std_dev.measure_id = means.measure_id
;


DROP TABLE
greatest_procedure_variability;

CREATE TABLE
greatest_procedure_variability as
SELECT
measure_id,
cast(coef_of_var as decimal(3,2)) as coef_of_var
FROM complications_coef_of_variation

UNION ALL

SELECT
measure_id,
cast(coef_of_var as decimal(3,2)) as coef_of_var
FROM effective_care_coef_of_variation

UNION

SELECT
measure_id,
cast(coef_of_var as decimal(3,2)) as coef_of_var
FROM effective_care_time_coef_of_variation
ORDER BY coef_of_var DESC
LIMIT 10
;


SELECT * FROM greatest_procedure_variability;
