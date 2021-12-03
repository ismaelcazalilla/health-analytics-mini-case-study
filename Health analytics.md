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
|--------------| 
| unique_users | 
| 554          | 


### 1.2 How many total measurements do we have per user on average?
```sql
WITH measure_frequency_by_user AS (
  SELECT 
    id,
    COUNT(measure) AS measure_frequency
  FROM health.user_logs
  GROUP BY id
)

SELECT
  ROUND(
    AVG(measure_frequency),
    2
  ) AS avg_measure_by_user
FROM measure_frequency_by_user;
```

|                     | 
|---------------------| 
| avg_measure_by_user | 
| 79.23               | 



### 1.3 What about the median number of measurements per user?

### 1.4 How many users have 3 or more measurements?
### 1.5 How many users have 1,000 or more measurements?

## 2. Looking at the logs data - what is the number and percentage of the active user base who:

### 2.1 Have logged blood glucose measurements?

### 2.2 Have at least 2 types of measurements?
### 2.3 Have all 3 measures - blood glucose, weight and blood pressure?

## 3. For users that have blood pressure measurements:
### 3.1 What is the median systolic/diastolic blood pressure values?

