CREATE DATABASE saas_analysis;
USE saas_analysis;
CREATE TABLE customers (
  customer_id INT,
  created_at DATE,
  segment VARCHAR(50),
  country VARCHAR(50)
);
CREATE TABLE subscriptions (
  subscription_id INT,
  customer_id INT,
  start_date DATE,
  end_date DATE,
  monthly_amount DECIMAL(10,2),
  status VARCHAR(20)
);
CREATE TABLE events (
  customer_id INT,
  event_name VARCHAR(50),
  event_date DATE,
  source VARCHAR(50)
);
drop table subscriptions;
drop table events;
drop table customers;

CREATE TABLE subscriptions (
  subscription_id INT,
  customer_id INT,
  start_date DATE,
  end_date DATE,
  monthly_amount DECIMAL(10,2),
  status VARCHAR(20));

CREATE TABLE customers (
  customer_id INT,
  created_at DATE,
  segment VARCHAR(50),
  country VARCHAR(50)
);

CREATE TABLE events (
  customer_id INT,
  event_name VARCHAR(50),
  event_date DATE,
  source VARCHAR(50)
);
DROP TABLE IF EXISTS events;
DROP TABLE IF EXISTS customers;
SELECT COUNT(*) FROM subscriptions;
SELECT * FROM events;
SELECT COUNT(*) FROM customers;
SELECT * FROM customers;
DROP TABLE IF EXISTS subscriptions;
SELECT COUNT(*) FROM subscriptions;
SELECT *  FROM subscriptions;
SELECT * FROM customers LIMIT 5;
SELECT * FROM events LIMIT 5;
SELECT * FROM subscriptions LIMIT 5;
SELECT customer_id, COUNT(*)
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;
SELECT event_id, COUNT(*)
FROM events
GROUP BY event_id
HAVING COUNT(*) > 1;
SELECT subscription_id, COUNT(*)
FROM subscriptions
GROUP BY subscription_id
HAVING COUNT(*) > 1;
SELECT COUNT(*) AS total_customers
FROM customers;
SELECT status, COUNT(*) AS cnt
FROM subscriptions
GROUP BY status;
SELECT s.customer_id
FROM subscriptions s
LEFT JOIN events e
  ON s.customer_id = e.customer_id
WHERE e.customer_id IS NULL;

SELECT customer_id, COUNT(*) AS total_events
FROM events
GROUP BY customer_id
ORDER BY total_events DESC;

ALTER DATABASE saas_analysis
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

ALTER TABLE customers CONVERT TO CHARACTER SET utf8mb4;
ALTER TABLE subscriptions CONVERT TO CHARACTER SET utf8mb4;
ALTER TABLE events CONVERT TO CHARACTER SET utf8mb4;
USE saas_analysis;
SELECT COUNT(*) FROM subscriptions;
SELECT COUNT(*) FROM events;
SELECT COUNT(*) FROM customers;

UPDATE events
SET event_date = STR_TO_DATE(event_date, '%Y-%m-%d')
WHERE event_date IS NOT NULL;
WITH monthly_mrr AS (
    SELECT
        DATE_FORMAT(start_date, '%Y-%m-01') AS month,
        SUM(mrr) AS total_mrr
    FROM subscriptions
    WHERE status = 'active'
    GROUP BY 1
)
SELECT * FROM monthly_mrr
ORDER BY month;
DESCRIBE customers;
DESCRIBE subscriptions;
DESCRIBE events;
SELECT * FROM subscriptions LIMIT 5;
SELECT * FROM events LIMIT 5;
UPDATE events
SET event_type = 'trial'
WHERE event_type IN ('trial_start', 'trial start', 'free_trial');
SET SQL_SAFE_UPDATES = 0;
UPDATE events
SET event_type = 'trial'
WHERE event_type IN ('trial_start', 'trial start', 'free_trial');
UPDATE events
SET event_type = 'activated'
WHERE event_type IN ('activate', 'activation', 'activated');

UPDATE events
SET event_type = 'paid'
WHERE event_type IN ('purchase', 'payment', 'paid');

UPDATE events
SET event_type = 'churned'
WHERE event_type IN ('churn', 'cancelled', 'canceled', 'churned');

DELETE e1
FROM events e1
JOIN events e2
  ON e1.customer_id = e2.customer_id
 AND e1.event_type = e2.event_type
 AND e1.event_date = e2.event_date
 AND e1.event_id > e2.event_id;
 SELECT event_type, COUNT(*) 
FROM events 
GROUP BY event_type;
DESCRIBE subscriptions;
SELECT * FROM subscriptions LIMIT 5;

SELECT 
    DATE_FORMAT(start_date, '%Y-%m-01') AS month,
    SUM(mrr) AS total_mrr
FROM subscriptions
WHERE status = 'active'
GROUP BY 1
ORDER BY 1;
DESCRIBE subscriptions;
SELECT * FROM subscriptions LIMIT 1;
UPDATE subscriptions
SET start_date = STR_TO_DATE(start_date, '%Y-%m-%d')
WHERE start_date IS NOT NULL;
UPDATE subscriptions
SET start_date = STR_TO_DATE(start_date, '%Y-%m-%d')
WHERE start_date IS NOT NULL;
UPDATE subscriptions
SET end_date = STR_TO_DATE(end_date, '%Y-%m-%d')
WHERE end_date IS NOT NULL;
UPDATE subscriptions
SET end_date = NULL
WHERE end_date = '';
UPDATE subscriptions
SET start_date = NULL
WHERE start_date = '';

UPDATE subscriptions
SET end_date = STR_TO_DATE(end_date, '%Y-%m-%d')
WHERE end_date IS NOT NULL;
UPDATE subscriptions
SET start_date = STR_TO_DATE(start_date, '%Y-%m-%d')
WHERE start_date IS NOT NULL;


SELECT subscription_id, start_date, end_date 
FROM subscriptions 
LIMIT 10;
SELECT 
    DATE_FORMAT(start_date, '%Y-%m-01') AS month,
    SUM(monthly_price) AS total_mrr
FROM subscriptions
WHERE status = 'active'
GROUP BY 1
ORDER BY 1;
SELECT 
    DATE_FORMAT(start_date, '%Y-%m-01') AS month,
    SUM(monthly_price) * 12 AS arr
FROM subscriptions
WHERE status = 'active'
GROUP BY 1
ORDER BY 1;
SELECT 
    AVG(customer_mrr) AS arpc
FROM (
    SELECT 
        customer_id,
        SUM(monthly_price) AS customer_mrr
    FROM subscriptions
    WHERE status = 'active'
    GROUP BY customer_id
) t;
WITH churned AS (
    SELECT 
        DATE_FORMAT(end_date, '%Y-%m-01') AS month,
        COUNT(DISTINCT customer_id) AS churned_customers
    FROM subscriptions
    WHERE status = 'canceled'
    GROUP BY 1
),
total AS (
    SELECT 
        DATE_FORMAT(start_date, '%Y-%m-01') AS month,
        COUNT(DISTINCT customer_id) AS total_customers
    FROM subscriptions
    GROUP BY 1
)
SELECT 
    c.month,
    churned_customers / total_customers AS logo_churn_rate
FROM churned c
JOIN total t ON c.month = t.month;
WITH churned_mrr AS (
    SELECT 
        DATE_FORMAT(end_date, '%Y-%m-01') AS month,
        SUM(monthly_price) AS churned_mrr
    FROM subscriptions
    WHERE status = 'canceled'
    GROUP BY 1
),
total_mrr AS (
    SELECT 
        DATE_FORMAT(start_date, '%Y-%m-01') AS month,
        SUM(monthly_price) AS total_mrr
    FROM subscriptions
    GROUP BY 1
)
SELECT 
    c.month,
    churned_mrr / total_mrr AS revenue_churn_rate
FROM churned_mrr c
JOIN total_mrr t ON c.month = t.month;
WITH funnel AS (
    SELECT
        customer_id,
        MAX(event_type = 'signup') AS signup,
        MAX(event_type = 'trial') AS trial,
        MAX(event_type = 'activated') AS activated,
        MAX(event_type = 'paid') AS paid,
        MAX(event_type = 'churned') AS churned
    FROM events
    GROUP BY customer_id
)
SELECT
    SUM(signup) AS signup_users,
    SUM(trial) AS trial_users,
    SUM(activated) AS activated_users,
    SUM(paid) AS paid_users,
    SUM(churned) AS churned_users
FROM funnel;
WITH funnel AS (
    SELECT
        customer_id,
        source,
        MAX(event_type = 'signup') AS signup,
        MAX(event_type = 'trial') AS trial,
        MAX(event_type = 'activated') AS activated,
        MAX(event_type = 'paid') AS paid
    FROM events
    GROUP BY customer_id, source
)
SELECT 
    source,
    SUM(signup) AS signup_users,
    SUM(trial) AS trial_users,
    SUM(activated) AS activated_users,
    SUM(paid) AS paid_users
FROM funnel
GROUP BY source;

SELECT event_type, COUNT(DISTINCT customer_id) AS users
FROM events
GROUP BY event_type;

SELECT 
  DATE_FORMAT(end_date, '%Y-%m-01') AS month,
  COUNT(DISTINCT customer_id) AS churned_customers
FROM subscriptions
WHERE status = 'canceled'
GROUP BY 1;
SELECT source, COUNT(DISTINCT customer_id) AS users
FROM events
WHERE event_type = 'signup'
GROUP BY source;






 









