SELECT 
  COUNT(DISTINCT id) AS unique_users
FROM health.user_logs;


DROP TABLE IF EXISTS measure_frequency_by_user;
CREATE TEMP TABLE measure_frequency_by_user AS
  SELECT
    id,
    COUNT(measure) AS measure_frequency
  FROM health.user_logs
  GROUP BY id;

SELECT
  ROUND(
    AVG(measure_frequency),
    2
  ) AS avg_measure_by_user
FROM measure_frequency_by_user;


SELECT
  ROUND (
    PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY measure_frequency)::NUMERIC,
    2
  ) AS median_measurement_by_user
FROM measure_frequency_by_user;


SELECT
  COUNT(*) AS users_with_more_than_2_measurements
FROM measure_frequency_by_user
WHERE measure_frequency >= 3;


SELECT *
FROM measure_frequency_by_user
WHERE measure_frequency >= 3
ORDER BY measure_frequency DESC
LIMIT 10;


SELECT
  COUNT(*) AS users_with_1000_or_more_measurements
FROM measure_frequency_by_user
WHERE measure_frequency >= 1000;


SELECT *
FROM measure_frequency_by_user
WHERE measure_frequency >= 1000
ORDER BY measure_frequency DESC
LIMIT 10;


WITH blood_glucose_users AS (
  SELECT
    (
      SELECT
        COUNT(DISTINCT id)
      FROM health.user_logs
      WHERE measure = 'blood_glucose'
    ) AS blood_glucose_user_frequency,
    
    COUNT(DISTINCT id) AS total_users
  FROM health.user_logs
)

SELECT
  total_users,
  blood_glucose_user_frequency,
  ROUND(
    100 * blood_glucose_user_frequency / total_users::NUMERIC,
    2
  ) AS blood_glucose_user_percentage
FROM blood_glucose_users;


WITH measure_frequencies AS
(
  SELECT
    id,
    COUNT(measure) AS measure_frequency,
    COUNT(DISTINCT measure) AS uniques_measure_frequency
  FROM health.user_logs
  GROUP BY id
)

SELECT
  (
    SELECT COUNT(DISTINCT id) FROM health.user_logs
  ) AS total_users,
  
  COUNT(id) AS users_with_at_least_2_measures_frequency,
  
  ROUND (
    100 * COUNT(id) / ( SELECT COUNT(DISTINCT id) FROM health.user_logs )::NUMERIC,
    2
  ) AS users_with_at_least_2_measures_percentage

FROM measure_frequencies
WHERE uniques_measure_frequency = 3;


WITH measure_frequencies AS
(
  SELECT
    id,
    COUNT(measure) AS measure_frequency,
    COUNT(DISTINCT measure) AS uniques_measure_frequency
  FROM health.user_logs
  GROUP BY id
)

SELECT
  (
    SELECT COUNT(DISTINCT id) FROM health.user_logs
  ) AS total_users,
  
  COUNT(id) AS users_with_the_3_measures_frequency,
  
  ROUND (
    100 * COUNT(id) / ( SELECT COUNT(DISTINCT id) FROM health.user_logs )::NUMERIC,
    2
  ) AS users_with_the_3_measures_percentage

FROM measure_frequencies
WHERE uniques_measure_frequency = 3;


SELECT
  ROUND(
      CAST(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY systolic) AS NUMERIC),
      2
    ) AS systolic_median,
    
  ROUND(
    CAST(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY diastolic) AS NUMERIC),
    2
  ) AS diastolic_median
FROM health.user_logs
WHERE measure = 'blood_pressure';