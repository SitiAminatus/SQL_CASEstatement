use mavenmovies;

-- CASE statement
/*
CASE Statement process IF/THEN logical operator in a given order. order is matter in this CASE statement
SELECT columnName,
	CASE
		WHEN logic THEN 'value'
		WHEN logic THEN 'value'
		ELSE 'value' --this ELSE is quite important to give you a sufficient response of what's going on in the execution process
	END AS 'newColumnName'
FROM columnTable


this statement identical with creating a label of the value in your record and store the label data into a new column
*/

/*
I will try to create a new field/column/feature as film_duration_category
from each record we have in length feature
*/

SELECT length
FROM film
ORDER BY length; -- our film duration is in between 46-185

SELECT DISTINCT length,
	CASE
		WHEN length BETWEEN 46 AND 60  THEN 'Short_Films'
        WHEN length BETWEEN 61 AND 120 THEN 'Standard-Length_Films'
        WHEN length > 120 THEN 'Extended-Length_FIlm'
		ELSE 'something wrong, check the logic'
	END AS 'film_category'
FROM film
ORDER BY length;

-- CASE ASSIGNMENT
/*
“I’d like to know which store each customer goes to, and whether or not they are active. 
Could you pull a list of first and last names of all customers, 
and label them as either ‘store 1 active’, ‘store 1 inactive’, ‘store 2 active’, or ‘store 2 inactive’?”
*/
SELECT *
FROM customer;

SELECT DISTINCT active -- to make sure the unique value in active status
FROM customer; 

SELECT first_name, last_name,
	CASE 
		WHEN store_id = 1 AND active = 0 THEN 'store 1 inactive'
        WHEN store_id = 1 AND active = 1 THEN 'store 1 active'
        WHEN store_id = 2 AND active = 0 THEN 'store 2 inactive'
        WHEN store_id = 2 AND active = 1 THEN 'store 2 active'
        ELSE 'ups something wrong with the logic'
    END AS 'store_and_status'
FROM customer;


-- COUNT & CASE
/*
in the case statement, I implement COUNT aggregate operator to calculate total number in a specific case
I want to count how many copies of film_id in each store
EXPECTED OUTPUT == 
film_id 1 is stored 4 coies in store 1 and 4 copies in store 2. 

SELECT 
COUNT (CASE WHEN value THEN value END) AS 'label'  
FROM
GROUP BY
ORDER BY 
*/

SELECT *
FROM inventory;

SELECT film_id, 
COUNT(film_id) AS count_of_store_1 FROM inventory
WHERE store_id = 1 -- retrieve count of film where store = 1
GROUP BY film_id;

SELECT film_id, 
COUNT(film_id) AS count_of_store_2
FROM inventory
WHERE store_id = 2 -- retrieve count of film where store = 2
GROUP BY film_id;

/*
actually this can be solved if there is no order in writing query
I just want to do this if can, but I can't
COUNT(film_id) WHERE store = 1 AS count_of_store_1 
COUNT(film_id) WHERE store = 2 AS count_of_store_2
FROM inventory
GROUP BY film_id

but unfortunately it can't execute WHERE before FROM

then to cover this problem, we can use CASE statement
*/

SELECT film_id,
	COUNT(CASE WHEN store_id=1 THEN film_id ELSE NULL END) AS 'TotalCopiesinStore1', -- THEN value can be replaced to inventory_id, they will give same calculation
	COUNT(CASE WHEN store_id=2 THEN film_id ELSE NULL END) AS 'TotalCopiesinStore2'
FROM inventory
GROUP BY film_id
ORDER BY film_id;

	
/*
“I’m curious how many inactive customers we have at each store.
Could you please create a table to count the number of customers
broken down by store_id (in rows), and active status (in columns)?"

to address this problem I need to count : 
how many customer which active in store_id = 1 and active in store_id = 2 
how many customer which inactive in store_id = 1 and active in store_id = 2 
*/

SELECT *
FROM customer; -- from this table, I need customer_id, store_id, and active

SELECT store_id, -- this query below return 2 columns named active and 2 column named inactive. but I just need single active and inactive column
	COUNT(CASE WHEN store_id=1 AND active=1 THEN customer_id ELSE NULL END) AS 'active',
    COUNT(CASE WHEN store_id=1 AND active=0 THEN customer_id ELSE NULL END) AS 'inactive',
    COUNT(CASE WHEN store_id=2 AND active=1 THEN customer_id ELSE NULL END) AS 'active',
    COUNT(CASE WHEN store_id=2 AND active=0 THEN customer_id ELSE NULL END) AS 'inactive'
FROM customer
GROUP BY store_id;

-- here given the suiatble query to cover above  problem
SELECT store_id,
	COUNT(CASE WHEN store_id=1 AND active=1 THEN customer_id WHEN store_id=2 AND active=1 THEN customer_id END) AS 'active',
    COUNT(CASE WHEN store_id=1 AND active=0 THEN customer_id WHEN store_id=2 AND active=0 THEN customer_id END) AS 'inactive'
FROM customer
GROUP BY store_id;

-- another solution
SELECT store_id,
	COUNT(CASE WHEN active = 1 THEN customer_id ELSE NULL END) AS 'active',
	COUNT(CASE WHEN active = 0 THEN customer_id ELSE NULL END) AS 'inactive'
FROM customer
GROUP BY store_id;
