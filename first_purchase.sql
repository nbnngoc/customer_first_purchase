SELECT DISTINCT
u.id,
CONCAT(u.first_name," ",u.last_name) AS customer_name,
u.email,
u.age,
u.gender,
u.country,
EXTRACT(DATE FROM u.created_at) AS sign_up_date,
EXTRACT(DATE FROM fp.first_purchase) AS first_purchase,
EXTRACT(HOUR FROM (fp.first_purchase - u.created_at)) AS hours_to_first_purchase
FROM bigquery-public-data.thelook_ecommerce.users AS u
JOIN
(
SELECT DISTINCT
orders.user_id,
fp.first_purchase
FROM bigquery-public-data.thelook_ecommerce.orders AS orders
JOIN 
  (
    SELECT 
    user_id,
    MIN(created_at) AS first_purchase 
    FROM bigquery-public-data.thelook_ecommerce.orders 
    GROUP BY user_id
  ) AS fp
ON orders.user_id = fp.user_id
ORDER BY 2
) AS fp
ON fp.user_id = u.id
WHERE EXTRACT(YEAR FROM u.created_at) = 2022 OR EXTRACT(YEAR FROM u.created_at) = 2021
ORDER BY 7 DESC
