/*Q1: Create a query that lists each movie, the film category it is classified in, 
   and the number of times it has been rented out*/

SELECT
    f.title AS film_title,
    c.name AS category_name,
    count(*) AS rental_count
FROM
    film f
    JOIN film_category fc ON fc.film_id = f.film_id
    JOIN category c ON c.category_id = fc.category_id
    JOIN inventory i ON i.film_id = f.film_id
    JOIN rental r ON r.inventory_id = i.inventory_id
WHERE
    c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
GROUP BY
    1,2
ORDER BY
   2,1;


/*Q2: Can you provide a table with the movie titles and divide them into 4 levels (first_quarter, 
second_quarter, third_quarter, and final_quarter) based on the quartiles(25%, 50%, 75%)
of the average rental duration(in the number of days) for movies across all categories?*/

SELECT 
	title, 
	name, 
	rental_duration,
	NTILE(4) OVER (ORDER BY title) AS standard_quartile
FROM 
	(SELECT 
	 	f.title title, 
	 	c.name name, 
	 	f.rental_duration rental_duration
	 FROM film f
	 JOIN film_category fc ON f.film_id = fc.film_id
	 JOIN category c ON fc.category_id = c.category_id
	 where 
	 	c.name in ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
	 ) t1
GROUP BY 
	1,2,3
ORDER BY 
	3,4


/*Q3: Write a query that returns the store ID for the store, the year and month and the number of 
rental orders each store has fulfilled for that month. Your table should include a column for each
of the following: year, month, store ID and count of rental orders fulfilled during that month.*/

SELECT 
	 DATE_PART('month', rental_date) AS rental_month, 
	 DATE_PART('year', rental_date) AS rental_year,
       s.store_id, 
	 COUNT(rental_date) AS count_rental
FROM rental r 
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN staff st ON r.staff_id = st.staff_id
JOIN store s ON st.store_id = s.store_id
GROUP BY 
	1,2,3
ORDER BY 
	4 desc;


/*Q4: Can you write a query to capture the customer name, month and year of payment, 
and total payment amount for each month by these top 10 paying customers?*/

WITH t1 AS
  	(SELECT 
   		cu.customer_id, 
   		sum(p.amount) pay_amt
     FROM payment p
     JOIN customer  cu ON cu.customer_id = p.customer_id
     GROUP BY 
   		cu.customer_id
     ORDER BY 
   		pay_amt DESC
     LIMIT 10)
SELECT 
	 date_trunc('month', payment_date) as pay_month, 
     cu.first_name || ' ' || cu.last_name as full_name,
     COUNT(*) AS count_per_month, SUM(p.amount) AS pay_amt
FROM t1
JOIN payment p ON t1.customer_id = p.customer_id
JOIN customer AS cu ON cu.customer_id = p.customer_id
GROUP BY 
	1,2
ORDER BY 
	2;




