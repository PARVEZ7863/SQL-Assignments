-- SQL ASSIGNMENT 3
 
USE sakila;
 
-- ============================================================
-- 1. Display all customer details who have made more than 5 payments.
--  We are checking payment count customer-wise.
--  Only customers having more than 5 payments will come.
--  First subquery finds customer IDs with more than 5 payments, then main query shows their full details.
-- ============================================================
 
SELECT *
FROM sakila.customer
WHERE customer_id IN (
    SELECT customer_id
    FROM sakila.payment
    GROUP BY customer_id
    HAVING COUNT(*) > 5
);
 
 
-- ============================================================
-- 2. Find the names of actors who have acted in more than 10 films.
-- We are counting films for every actor.
-- Only actors with more than 10 films will come.
-- Subquery finds actor IDs having more than 10 films, then main query shows actor names.
-- ============================================================
 
SELECT first_name, last_name
FROM sakila.actor
WHERE actor_id IN (
    SELECT actor_id
    FROM sakila.film_actor
    GROUP BY actor_id
    HAVING COUNT(*) > 10
);
 
 
 
-- ============================================================
-- 3. Find the names of customers who never made a payment.
-- We are checking customers who do not have any payment record.
-- NOT EXISTS is used for this check.
-- For each customer, subquery checks payment table and returns only customers where no payment is found.
-- ============================================================
 
SELECT c.first_name, c.last_name
FROM sakila.customer c
WHERE NOT EXISTS (
    SELECT 1
    FROM sakila.payment p
    WHERE p.customer_id = c.customer_id
);
 
 
-- ============================================================
-- 4. List all films whose rental rate is higher than the average rental rate of all films.
--  First we are finding average rental rate.
-- Then we are showing films above that average.
-- Subquery calculates average rental rate and main query compares each film rental rate with that value.
-- ============================================================
 
SELECT film_id, title, rental_rate
FROM sakila.film
WHERE rental_rate > (
    SELECT AVG(rental_rate)
    FROM sakila.film
);
 
 
-- ============================================================
-- 5. List the titles of films that were never rented.
-- We are checking rental records through inventory table.
-- Films having no rental record will come.
-- Subquery checks whether each film has any matching rental, and NOT EXISTS keeps only films never rented.
-- ============================================================
 
SELECT f.title
FROM sakila.film f
WHERE NOT EXISTS (
    SELECT 1
    FROM sakila.inventory i
    JOIN sakila.rental r
        ON r.inventory_id = i.inventory_id
    WHERE i.film_id = f.film_id
);
 
-- ------------------------------------------------------------
 
 
-- ============================================================
-- 6. Display the customers who rented films in the same month as customer with ID 5.
--  First we are finding rental month of customer ID 5.
--  Then we are checking other customers who rented in same month.
--  Subquery gets the rental month of customer 5 and main query shows customers who rented in that same month.
-- ============================================================
 
SELECT DISTINCT
       c.customer_id,
       c.first_name,
       c.last_name
FROM sakila.customer c
JOIN sakila.rental r
    ON r.customer_id = c.customer_id
WHERE MONTH(r.rental_date) IN (
    SELECT MONTH(rental_date)
    FROM sakila.rental
    WHERE customer_id = 5
);
 
-- • If teacher wants to remove customer ID 5 from result, use below condition:
-- AND c.customer_id <> 5

 
 
-- ============================================================
-- 7. Find all staff members who handled a payment greater than the average payment amount.
-- First we are finding average payment amount.
-- Then we are finding staff who handled payment above average.
-- Inner subquery gets average payment amount and outer subquery finds staff IDs who handled higher payments.
-- ============================================================
 
SELECT *
FROM sakila.staff
WHERE staff_id IN (
    SELECT staff_id
    FROM sakila.payment
    WHERE amount > (
        SELECT AVG(amount)
        FROM sakila.payment
    )
);
 
-- ------------------------------------------------------------
 
 
-- ============================================================
-- 8. Show the title and rental duration of films whose rental duration is greater than the average.
-- First we are finding average rental duration.
-- Then films above that duration will come.
-- Subquery calculates average rental duration and main query shows films having rental duration more than that.
-- ============================================================
 
SELECT title, rental_duration
FROM sakila.film
WHERE rental_duration > (
    SELECT AVG(rental_duration)
    FROM sakila.film
);
 
-- ------------------------------------------------------------
 
 
-- ============================================================
-- 9. Find all customers who have the same address as customer with ID 1.
-- First we are finding address ID of customer 1.
-- Then we are finding customers with same address ID.
-- Subquery gets address ID of customer 1 and main query shows all customers having that same address.
-- ============================================================
 
SELECT customer_id, first_name, last_name, address_id
FROM sakila.customer
WHERE address_id = (
    SELECT address_id
    FROM sakila.customer
    WHERE customer_id = 1
);
 
-- • If teacher wants to remove customer ID 1 from result, use below condition:
-- AND customer_id <> 1
 
-- ------------------------------------------------------------
 
 
-- ============================================================
-- 10. List all payments that are greater than the average of all payments.
-- First we are finding average payment amount.
-- Then payments above that average will come.
-- Subquery finds average amount and main query shows only payments which are greater than that average.
-- ============================================================
 
SELECT *
FROM sakila.payment
WHERE amount > (
    SELECT AVG(amount)
    FROM sakila.payment
);
