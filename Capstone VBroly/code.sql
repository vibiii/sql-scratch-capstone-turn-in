-- Question 1
SELECT *
 FROM survey
 LIMIT 10;

 -- Question 2
 SELECT question, count(distinct user_id)
 FROM survey
 GROUP BY question;

 -- Question 4 - Query 1
SELECT *
FROM quiz
LIMIT 5;

-- Question 4 - Query 2
SELECT *
FROM home_try_on
LIMIT 5;

-- Question 4 - Query 3
SELECT * 
FROM purchase
LIMIT 5;

-- Question 5
SELECT q.user_id,
CASE WHEN h.user_id IS NOT NULL THEN 'True' ELSE 'False' END AS 'is_home_try',
h.number_of_pairs,
CASE WHEN p.user_id IS NOT NULL THEN 'True' ELSE 'False' END AS 'is_purchase'
FROM
quiz AS q
LEFT JOIN home_try_on AS h
ON q.user_id = h.user_id
LEFT JOIN purchase AS p
ON h.user_id = p.user_id
LIMIT 10;

-- Question 6 - Query 1 : overall conversion rates
WITH funnel AS (SELECT q.user_id,
CASE WHEN h.user_id IS NOT NULL THEN 'True' ELSE 'False' END AS 'is_home_try',
h.number_of_pairs,
CASE WHEN p.user_id IS NOT NULL THEN 'True' ELSE 'False' END AS 'is_purchase'
FROM
quiz AS q
LEFT JOIN home_try_on AS h
ON q.user_id = h.user_id
LEFT JOIN purchase AS p
ON h.user_id = p.user_id)
SELECT COUNT (distinct user_id) AS 'quiz', SUM (CASE WHEN is_home_try = 'True' then 1 ELSE 0 END) AS 'home_try', SUM (CASE WHEN is_purchase = 'True' then 1 ELSE 0 END) AS 'purchase'
FROM funnel;

-- Question 6 - Query 2 : AB Test result
WITH funnel AS (SELECT q.user_id,
CASE WHEN h.user_id IS NOT NULL THEN 'True' ELSE 'False' END AS 'is_home_try',
h.number_of_pairs,
CASE WHEN p.user_id IS NOT NULL THEN 'True' ELSE 'False' END AS 'is_purchase'
FROM
quiz AS q
LEFT JOIN home_try_on AS h
ON q.user_id = h.user_id
LEFT JOIN purchase AS p
ON h.user_id = p.user_id)
SELECT number_of_pairs, count (*) AS total_users, 1.0*sum (CASE WHEN is_purchase= 'True' THEN 1 ELSE 0 END) / count(*) AS conversion_rate
FROM funnel
WHERE number_of_pairs IS NOT NULL
GROUP BY number_of_pairs;

--Question 6 - Query 3 : most common results of the style quiz
SELECT style, count(*) AS total_answers
FROM quiz
GROUP BY style
ORDER BY number_answers DESC;

-- Question 6 - Query 4 : most common types of purchases
SELECT style, count(*) as total_purchases
FROM purchase
GROUP BY style
ORDER BY total_purchases DESC;

-- Question 6 - Query 5 : most common results of the color quiz
SELECT color, count(*) AS number_answers
FROM quiz
GROUP BY color
ORDER BY number_answers DESC;

-- Question 6 - Query 6 : most common colors of purchases
SELECT CASE 
WHEN color LIKE '%Black%' THEN 'Black'
WHEN color LIKE '%Tortoise%' THEN 'Tortoise'
WHEN color LIKE '%Crystal%' THEN 'Crystal'
ELSE 'Other' END AS purchase_color, count(*) as total_purchases
FROM purchase
GROUP BY purchase_color
ORDER BY total_purchases DESC;

-- Question 6 - Query 7 : conversion per color 
WITH conversion AS (SELECT q.user_id, q.color,
CASE WHEN p.user_id IS NOT NULL THEN 'True' ELSE 'False' END AS 'is_purchase'
FROM
quiz AS q
LEFT JOIN purchase AS p
ON q.user_id = p.user_id)
SELECT color AS quiz_color, count(distinct user_id) AS 'answered_quiz', sum(case when is_purchase = 'True' THEN 1 ELSE 0 END) AS has_purchased
FROM conversion
GROUP BY quiz_color;

-- Question 6 - Query 8 : color bought by the people who answered "Black" to the color quiz and made a purchase
WITH color AS (SELECT q.user_id AS user_id, q.color AS quiz_color,p.color AS purchase_color
FROM quiz as q
LEFT JOIN purchase as p
on q.user_id = p.user_id
WHERE purchase_color IS NOT NULL)
SELECT count (distinct user_id), quiz_color, CASE WHEN purchase_color LIKE '%Black' THEN 'Black' ELSE 'Other' END AS purchase_black
FROM color
WHERE quiz_color = 'Black'
GROUP BY quiz_color,purchase_color


-- Question 6 - Query 9 :Most sold products
SELECT product_id, style, model_name, color, count(*) as total_purchases
FROM purchase
GROUP BY product_id
ORDER BY total_purchases DESC;


