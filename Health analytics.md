# Health Analytics. Mini case study

## 1. Business questions to resolve using SQL:

### 1.1 How many unique users exist in the logs dataset?
```sql
SELECT 
  COUNT(DISTINCT id) AS unique_users
FROM health.user_logs;
```
Result: 
|              | 
|--------------:| 
| unique_users | 
| 554          | 


### 1.2 How many total measurements do we have per user on average?
A temporary table is created, in order to be used in the following questions.

```sql
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
```

|                     | 
|---------------------:| 
| avg_measure_by_user | 
| 79.23               | 



### 1.3 What about the median number of measurements per user?
```sql
SELECT
  ROUND (
    PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY measure_frequency)::NUMERIC,
    2
  ) AS median_measurement_by_user
FROM measure_frequency_by_user;
```
|                     | 
|---------------------:| 
| median_measurement_by_user | 
| 2.00              | 


### 1.4 How many users have 3 or more measurements?
```sql
SELECT
  COUNT(*) AS users_with_more_than_2_measurements
FROM measure_frequency_by_user
WHERE measure_frequency >= 3;
```
|                     | 
|---------------------:| 
| users_with_more_than_2_measurements | 
| 209              | 


If the list of users is needed:
```sql
SELECT *
FROM measure_frequency_by_user
WHERE measure_frequency >= 3
ORDER BY measure_frequency DESC
LIMIT 10;
```

| id                                       | measure_frequency |
|-----------------------------------------:|------------------:|
| 054250c692e07a9fa9e62e345231df4b54ff435d | 22325             |
| 0f7b13f3f0512e6546b8d2c0d56e564a2408536a | 1589              |
| ee653a96022cc3878e76d196b1667d95beca2db6 | 1235              |
| abc634a555bbba7d6d6584171fdfa206ebf6c9a0 | 1212              |
| 576fdb528e5004f733912fae3020e7d322dbc31a | 1018              |
| 87be2f14a5550389cb2cba03b3329c54c993f7d2 | 747               |
| 46d921f1111a1d1ad5dd6eb6e4d0533ab61907c9 | 651               |
| fba135f6a50a2e3f371e47f943b025705f9d9617 | 633               |
| d696925de5e9297694ef32a1c9871f3629bec7e5 | 597               |
| 6c2f9a8372dac248192c50219c97f9087ab778ba | 582               |


### 1.5 How many users have 1,000 or more measurements?
```sql
SELECT
  COUNT(*) AS users_with_1000_or_more_measurements
FROM measure_frequency_by_user
WHERE measure_frequency >= 1000;
```

|                     | 
|---------------------:| 
| users_with_1000_or_more_measurements | 
| 5              | 


If the list of users is needed:
```sql
SELECT *
FROM measure_frequency_by_user
WHERE measure_frequency >= 1000
ORDER BY measure_frequency DESC
LIMIT 10;
```

## 2. Looking at the logs data - what is the number and percentage of the active user base who:

### 2.1 Have logged blood glucose measurements?
First, a CTE is created to get the frequency of users with 'blood_glucose' measure.
After that, the percentage is calculated based on the total of users.

```sql
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
```

| total_users | blood_glucose_user_frequency | blood_glucose_user_percentage |
|-------------:|------------------------------:|-------------------------------:|
| 554         | 325                          | 58.66                         |




### 2.2 Have at least 2 types of measurements?
### 2.3 Have all 3 measures - blood glucose, weight and blood pressure?

## 3. For users that have blood pressure measurements:
### 3.1 What is the median systolic/diastolic blood pressure values?

