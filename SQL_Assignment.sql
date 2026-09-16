
USE sakila;
 
-- 1. Get all customers whose first name starts with 'J' and who are active.
-- J% = starts with J; active = 1 means active customer.
SELECT *
FROM customer
WHERE first_name LIKE 'J%'
  AND active = 1;
 
-- 2. Find all films where the title contains 'ACTION' or the description contains 'WAR'.
SELECT *
FROM film
WHERE title LIKE '%ACTION%'
   OR description LIKE '%WAR%';
 
-- 3. List all customers whose last name is not 'SMITH' and whose first name ends with 'a'.
SELECT *
FROM customer
WHERE last_name != 'SMITH'
  AND first_name LIKE '%A';
 
-- 4. Get all films where rental rate is greater than 3.0 and replacement cost is not null.
SELECT *
FROM film
WHERE rental_rate > 3.0
  AND replacement_cost IS NOT NULL;
 
-- 5. Count how many customers exist in each store who have active status = 1.
-- GROUP BY makes one group for each store.
SELECT store_id, COUNT(*) AS active_customers
FROM customer
WHERE active = 1
GROUP BY store_id;
 
-- 6. Show distinct film ratings available in the film table.
SELECT DISTINCT rating
FROM film;
 
-- 7. Find the number of films for each rental duration where average length is more than 100 minutes.
-- HAVING filters the grouped result after AVG(length) is calculated.
SELECT rental_duration,
       COUNT(*) AS film_count,
       AVG(length) AS avg_length
FROM film
GROUP BY rental_duration
HAVING AVG(length) > 100;
 
-- 8. List payment dates and total amount paid per date, only for days with more than 100 payments.
SELECT DATE(payment_date) AS payment_day,
       SUM(amount) AS total_amount,
       COUNT(payment_id) AS payment_count
FROM payment
GROUP BY DATE(payment_date)
HAVING COUNT(payment_id) > 100
ORDER BY payment_day;
 
-- 9. Find customers whose email is null or ends with '.org'.
SELECT *
FROM customer
WHERE email IS NULL
   OR email LIKE '%.org';
 
-- 10. List films with rating 'PG' or 'G', ordered by rental rate descending.
SELECT *
FROM film
WHERE rating = 'PG' OR rating = 'G'
ORDER BY rental_rate DESC;
 
-- 11. Count films for each length where title starts with 'T' and count is more than 5.
SELECT length, COUNT(*) AS film_count
FROM film
WHERE title LIKE 'T%'
GROUP BY length
HAVING COUNT(*) > 5;
 
-- 12. List all actors who have appeared in more than 10 films.
-- JOIN actor and film_actor using actor_id, then count films for each actor.
SELECT a.actor_id,
       a.first_name,
       a.last_name,
       COUNT(fa.film_id) AS film_count
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
HAVING COUNT(fa.film_id) > 10
ORDER BY film_count DESC;
 
-- 13. Top 5 films with highest rental rates and longest lengths combined.
SELECT film_id, title, rental_rate, length
FROM film
ORDER BY rental_rate DESC, length DESC
LIMIT 5;
 
-- 14. Show all customers with total number of rentals, most to least.
-- LEFT JOIN keeps all customers, even if a customer has no rental.
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       COUNT(r.rental_id) AS total_rentals
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_rentals DESC;
 
-- 15. List film titles that have never been rented.
-- Connect film -> inventory -> rental and keep films with zero rentals.
SELECT f.film_id,
       f.title
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title
HAVING COUNT(r.rental_id) = 0
ORDER BY f.title;
 
 
 
-- 16. Identify duplicates in customer table without using customer_id.
-- Here, first_name + last_name + email are used to identify repeated customer records.
SELECT first_name,
       last_name,
       email,
       COUNT(*) AS duplicate_count
FROM customer
GROUP BY first_name, last_name, email
HAVING COUNT(*) > 1;
 
-- 17. Number of times letter 'a' is repeated in each film description.
-- Compare original length with length after removing letter a.
SELECT film_id,
       title,
       description,
       LENGTH(LOWER(description)) - LENGTH(REPLACE(LOWER(description), 'a', '')) AS count_a
FROM film;
 
-- 18. Number of times each vowel is repeated in each film description.
-- Same LENGTH and REPLACE method is used for a, e, i, o and u.
SELECT film_id,
       title,
       LENGTH(LOWER(description)) - LENGTH(REPLACE(LOWER(description), 'a', '')) AS count_a,
       LENGTH(LOWER(description)) - LENGTH(REPLACE(LOWER(description), 'e', '')) AS count_e,
       LENGTH(LOWER(description)) - LENGTH(REPLACE(LOWER(description), 'i', '')) AS count_i,
       LENGTH(LOWER(description)) - LENGTH(REPLACE(LOWER(description), 'o', '')) AS count_o,
       LENGTH(LOWER(description)) - LENGTH(REPLACE(LOWER(description), 'u', '')) AS count_u
FROM film;
 
-- 19. Display payments made by each customer - month wise.
-- YEAR and MONTH separate the payment date for grouping.
SELECT customer_id,
       YEAR(payment_date) AS payment_year,
       MONTH(payment_date) AS payment_month,
       SUM(amount) AS total_payment
FROM payment
GROUP BY customer_id, YEAR(payment_date), MONTH(payment_date)
ORDER BY customer_id, payment_year, payment_month;
 
-- 20. Display payments made by each customer - year wise.
SELECT customer_id,
       YEAR(payment_date) AS payment_year,
       SUM(amount) AS total_payment
FROM payment
GROUP BY customer_id, YEAR(payment_date)
ORDER BY customer_id, payment_year;
 
-- 21. Display payments made by each customer - week wise.
SELECT customer_id,
       YEAR(payment_date) AS payment_year,
       WEEK(payment_date) AS payment_week,
       SUM(amount) AS total_payment
FROM payment
GROUP BY customer_id, YEAR(payment_date), WEEK(payment_date)
ORDER BY customer_id, payment_year, payment_week;
 
-- 22. Check whether a hardcoded year is a leap year.
-- Change 2024 below to test another year.
SELECT 2024 AS given_year,
       CASE
           WHEN MOD(2024, 400) = 0
                OR (MOD(2024, 4) = 0 AND MOD(2024, 100) != 0)
           THEN 'Leap Year'
           ELSE 'Not a Leap Year'
       END AS result;
 
-- 23. Display number of days remaining in the current year from today.
-- DATEDIFF finds the difference between Dec 31 and today.
SELECT CURDATE() AS today,
       DATEDIFF(
           DATE(CONCAT(YEAR(CURDATE()), '-12-31')),
           CURDATE()
       ) AS days_remaining;
 
-- 24. Display quarter number (Q1, Q2, Q3, Q4) for payment dates.
SELECT payment_id,
       customer_id,
       payment_date,
       CONCAT('Q', QUARTER(payment_date)) AS quarter_number
FROM payment;
