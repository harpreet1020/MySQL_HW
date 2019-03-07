USE sakila;

-- 1a
SELECT first_name, last_name
	FROM actor;

-- 1b 
SELECT CONCAT (first_name, ' ', last_name) AS ' Actor_Name' From actor;

-- 2a 
SELECT actor_id, first_name, last_name
	FROM actor
WHERE first_name = "JOE";

-- 2b
SELECT * 
	FROM actor
WHERE last_name LIKE "%GEN%";

-- 2c
SELECT actor_id, first_name, last_name
	FROM actor
WHERE last_name LIKE "%LI%"
ORDER BY last_name, first_name;

-- 2d
SELECT country_id, country
	FROM country 
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a
ALTER TABLE actor 
ADD COLUMN description BLOB;

-- 3b
ALTER TABLE actor 
DROP COLUMN description;

-- 4a
SELECT last_name, COUNT(*) AS 'name_count' 
	FROM actor
GROUP BY last_name;

-- 4b
SELECT DISTINCT last_name, COUNT(last_name) AS 'name_count'
	FROM actor
GROUP BY last_name
HAVING COUNT('name_count') >= 2;

-- 4c 
UPDATE  actor 
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

-- 4d
UPDATE actor 
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS' ;

SELECT * FROM actor
WHERE first_name = "HARPO";

-- 5a
DESCRIBE sakila.address;

-- 6a
DESCRIBE sakila.staff;

SELECT first_name, last_name, address
	FROM staff s
INNER JOIN address a
	ON s.address_id = a.address_id;

-- 6b
DESCRIBE sakila.payment;

SELECT first_name, last_name, SUM(amount)
	FROM staff s
INNER JOIN payment p 
	ON s.staff_id = p.staff_id
GROUP BY p.staff_id
ORDER BY last_name ASC;

-- 6c
DESCRIBE sakila.film;
DESCRIBE sakila.film_actor;

SELECT title, COUNT(actor_id)
	FROM film f
INNER JOIN film_actor a
	ON f.film_id = a.film_id
GROUP BY title;

-- 6d
DESCRIBE sakila.inventory;

SELECT title, COUNT(inventory_id)
	FROM film f
INNER JOIN inventory i
	ON f.film_id = i.film_id
WHERE title = 'Hunchback Impossible';

-- 6e
SELECT customer.customer_id, customer.first_name, customer.last_name, SUM(payment.amount)
	FROM payment
INNER JOIN customer
	ON customer.customer_id = payment.customer_id
GROUP BY payment.customer_id
ORDER BY last_name ASC;

-- 7a
SELECT film.title, film.language_id, language.name
	FROM film
INNER JOIN language
	ON film.language_id = language.language_id
    WHERE film.title LIKE "K%" OR film.title LIKE "Q%";

-- This also works for 7a 
SELECT title
FROM film
WHERE language_id IN(
	SELECT language_id 
	FROM language
	WHERE language_id = 1
)
AND title LIKE "K%" OR title LIKE "Q%";
 
-- 7b
SELECT actor.first_name, actor.last_name 
FROM actor 
WHERE actor_id IN(
	SELECT actor_id
    FROM film_actor 
    WHERE film_id IN(
		SELECT film_id 
        FROM film
        WHERE title = "Alone Trip")
);

-- 7c 
SELECT country.country, customer.first_name, customer.last_name, customer.email
FROM customer 
JOIN country  
ON customer.customer_id = country.country_id 
WHERE country = "Canada";

-- 7d
SELECT title
FROM film
WHERE film_id IN(
	SELECT film_id
    FROM film_category 
	WHERE category_id IN(
		SELECT category_id 
        FROM category 
        WHERE name = "Family"
    )
);
-- USING VIEW for 7d
SELECT title, category
FROM film_list
WHERE category = 'Family';

-- 7e
SELECT film.title, inventory.film_id, COUNT(rental.inventory_id)
	FROM inventory 
INNER JOIN rental
	ON inventory.inventory_id = rental.inventory_id
INNER JOIN film
	ON inventory.film_id = film.film_id
GROUP BY rental.inventory_id 
ORDER BY COUNT(rental.inventory_id) DESC;

-- 7f 
SELECT store, total_sales
FROM sales_by_store;

-- 7g 
SELECT s.store_id, city, country
FROM store s
INNER JOIN customer cu
ON s.store_id = cu.store_id
INNER JOIN staff st
ON s.store_id = st.store_id
INNER JOIN address a
ON cu.address_id = a.address_id
INNER JOIN city ci
ON a.city_id = ci.city_id
INNER JOIN country coun
ON ci.country_id = coun.country_id;

-- 7h 
SELECT category.name, SUM(payment.amount) AS gross_revenue
FROM category 
INNER JOIN film_category fc
	ON fc.category_id = category.category_id
INNER JOIN inventory 
	ON inventory.film_id = fc.film_id 
INNER JOIN rental
	ON rental.inventory_id = inventory.inventory_id 
INNER JOIN payment 
	ON payment. rental_id = rental.rental_id 
GROUP BY name
ORDER BY gross_revenue DESC
LIMIT 5;

-- 8a In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
DROP VIEW IF EXISTS top_five_genres;
CREATE VIEW top_five_genres AS

SELECT category.name, SUM(payment.amount) AS gross_revenue
FROM category 
INNER JOIN film_category fc
	ON fc.category_id = category.category_id
INNER JOIN inventory 
	ON inventory.film_id = fc.film_id 
INNER JOIN rental
	ON rental.inventory_id = inventory.inventory_id 
INNER JOIN payment 
	ON payment. rental_id = rental.rental_id 
GROUP BY name
ORDER BY gross_revenue DESC
LIMIT 5;


-- 8b. How would you display the view that you created in 8a?
SELECT * FROM top_five_genres;

-- 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
DROP VIEW  top_five_genres;






















