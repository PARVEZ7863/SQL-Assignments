-- SQL ASSIGNMENT 4

USE sakila;


-- ============================================================
-- 1. List all customers along with the films they have rented.
--  We are joining customer, rental, inventory and film tables.
--  This will show customer name with the film rented by them.
--  Customer is connected to rental, rental to inventory, and inventory to film to get the film title.
-- ============================================================

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    f.title AS film_title
FROM sakila.customer c
JOIN sakila.rental r
    ON c.customer_id = r.customer_id
JOIN sakila.inventory i
    ON r.inventory_id = i.inventory_id
JOIN sakila.film f
    ON i.film_id = f.film_id;


-- ============================================================
-- 2. List all customers and show their rental count,
--  including those who haven't rented any films.
-- LEFT JOIN is used to keep all customers.
-- COUNT will show 0 also when customer has no rental.
-- LEFT JOIN keeps every customer and COUNT counts how many rental records are available for each customer.
-- ============================================================

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(r.rental_id) AS rental_count
FROM sakila.customer c
LEFT JOIN sakila.rental r
    ON c.customer_id = r.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY rental_count DESC;


-- ============================================================
-- 3. Show all films along with their category.
--    Include films that don't have a category assigned.
-- LEFT JOIN is used because all films should come.
-- film_category connects film table with category table.
-- Film is joined to film_category and category, and LEFT JOIN keeps the film even if category is missing.
-- ============================================================

SELECT
    f.film_id,
    f.title,
    c.name AS category_name
FROM sakila.film f
LEFT JOIN sakila.film_category fc
    ON f.film_id = fc.film_id
LEFT JOIN sakila.category c
    ON fc.category_id = c.category_id;


-- ------------------------------------------------------------


-- ============================================================
-- 4. Show all customers and staff emails from both customer
--  and staff tables using a full outer join.
--  Simulate FULL OUTER JOIN using LEFT + RIGHT + UNION.
--  MySQL does not directly support FULL OUTER JOIN.
--  LEFT JOIN and RIGHT JOIN are combined using UNION.
--  LEFT JOIN gives all customers, RIGHT JOIN gives all staff, and UNION combines both results.
-- ============================================================

SELECT
    c.email AS customer_email,
    s.email AS staff_email,
    c.store_id
FROM sakila.customer c
LEFT JOIN sakila.staff s
    ON c.store_id = s.store_id

UNION

SELECT
    c.email AS customer_email,
    s.email AS staff_email,
    s.store_id
FROM sakila.customer c
RIGHT JOIN sakila.staff s
    ON c.store_id = s.store_id;


-- ------------------------------------------------------------


-- ============================================================
-- 5. Find all actors who acted in the film "ACADEMY DINOSAUR".
-- actor is connected to film through film_actor table.
-- We are filtering only the required film title.
-- How it works: actor joins with film_actor and film, then WHERE filters only ACADEMY DINOSAUR.
-- ============================================================

SELECT
    a.actor_id,
    a.first_name,
    a.last_name
FROM sakila.actor a
JOIN sakila.film_actor fa
    ON a.actor_id = fa.actor_id
JOIN sakila.film f
    ON fa.film_id = f.film_id
WHERE f.title = 'ACADEMY DINOSAUR';


-- ------------------------------------------------------------


-- ============================================================
-- 6. List all stores and the total number of staff members
--  working in each store, even if a store has no staff.
-- LEFT JOIN is used to keep all stores.
-- COUNT gives total staff for each store.
-- Store is LEFT JOINed with staff and GROUP BY counts staff members store-wise.
-- ============================================================

SELECT
    s.store_id,
    COUNT(st.staff_id) AS total_staff
FROM sakila.store s
LEFT JOIN sakila.staff st
    ON s.store_id = st.store_id
GROUP BY s.store_id;


-- ============================================================
-- 7. List the customers who have rented films more than 5 times.
-- Include their name and total rental count.
-- We are counting rentals customer-wise.
-- HAVING is used because we are filtering after GROUP BY.
-- Customer joins with rental, GROUP BY counts rentals for each customer, and HAVING keeps counts above 5.
-- ============================================================

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(r.rental_id) AS total_rentals
FROM sakila.customer c
JOIN sakila.rental r
    ON c.customer_id = r.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
HAVING COUNT(r.rental_id) > 5
ORDER BY total_rentals DESC;
