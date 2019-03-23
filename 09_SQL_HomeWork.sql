USE sakila;

-- 1A. Display the first and last names of all actors from the table actor

SELECT a.first_name, a.last_name
FROM actor a;

-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 

-- 1B. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.

SELECT CONCAT(a.first_name, ' ' ,a.last_name) AS Actor_Name
FROM actor a; 

-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 

-- 2A. You need to find the ID number, first name, 
-- and last name of an actor, of whom you know only 
-- the first name, "Joe." What is one query would you use to obtain this information?

SELECT a.actor_id, a.first_name, a.last_name FROM actor a
WHERE first_name LIKE "Joe%"; 

-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 

-- 2B Find all actors whose last name contain the letters GEN:

SELECT * FROM actor a
WHERE last_name LIKE "%GEN%"; 

-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 
  
-- 2C. Find all actors whose last names contain the letters LI. This time, order the 
-- rows by last name and first name, in that order: 

SELECT a.last_name, a.first_name FROM actor a
WHERE last_name LIKE "%LI%"
ORDER BY last_name ASC 

-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 

-- 2D. Using IN, display the country_id and country columns of the following countries:
-- Afghanistan, Bangladesh, and China:

SELECT country_id, country, last_update
FROM country 
WHERE country IN ('Afghanistan','Bangladesh', 'China'); 

-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 

-- 3A. You want to keep a description of each actor. You don't think you will be performing queries on a description, 
-- so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).

ALTER TABLE actor
ADD COLUMN description BLOB AFTER last_name;

-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 

-- 3B. Very quickly you realize that entering descriptions for each actor is too much effort.
-- Delete the description column.
 
ALTER TABLE actor 
DROP description 

-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 

-- 4A. List the last names of actors, as well as how many actors have that last name.

SELECT last_name, COUNT(*) AS '# 0f Actors Recurring Last Name'
FROM actor GROUP BY last_name; 

-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 

-- 4B. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors

SELECT last_name, COUNT(*) AS '# of recurring' 
FROM actor
GROUP BY last_name
HAVING count(*) >= 2;

-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 

-- 4C. The actor HARPO WILLIAMS was accidentally entered in the actor table 
-- as GROUCHO WILLIAMS. Write a query to fix the record.

UPDATE actor SET first_name = 'HARPO' WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

-- SELECT i.actor_id, i.first_name, i.last_name FROM actor i 
-- WHERE first_name LIKE "HARPO";  

-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 	

-- 4D. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! 
-- In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
 
UPDATE actor SET first_name = 'GROUCHO' WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS';

-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 

-- 5A. You cannot locate the schema of the address table. Which query would you use to re-create it?
-- Hint: https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html

-- DESCRIBE sakila.address; 

SHOW CREATE TABLE sakila.address;

-- CREATE TABLE `address` (
--   `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
--   `address` varchar(50) NOT NULL,
--   `address2` varchar(50) DEFAULT NULL,
--   `district` varchar(20) NOT NULL,
--   `city_id` smallint(5) unsigned NOT NULL,
--   `postal_code` varchar(10) DEFAULT NULL,
--   `phone` varchar(20) NOT NULL,
--   `location` geometry NOT NULL,
--   `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
--   PRIMARY KEY (`address_id`),
--   KEY `idx_fk_city_id` (`city_id`),
--   SPATIAL KEY `idx_location` (`location`),
--   CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
-- ) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8
	
-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 

--  6A. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address: 

SELECT first_name, last_name, address, cty.city
FROM staff s
JOIN address a ON s.address_id = a.address_id
JOIN city cty ON (cty.city_id = a.city_id)

-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 

-- 6B. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.

SELECT first_name, last_name, SUM(amount) AS 'Total Aug 2005' 
FROM staff s
INNER JOIN payment p 
ON s.staff_id = p.staff_id AND payment_date LIKE '2005-08%'
GROUP BY p.staff_id; 

-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 

-- 6C. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.

SELECT f.title AS 'Film Name', COUNT(fa.actor_id) AS 'Number of Actors' 
FROM film_actor fa INNER JOIN film f 
ON fa.film_id= f.film_id
GROUP BY f.title; 

-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 

-- 6D. How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT title, (
SELECT COUNT(*) FROM inventory
WHERE film.film_id = inventory.film_id) AS 'Number of Copies'
FROM film
WHERE title = 'Hunchback Impossible';

-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 

-- 6E. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
-- List the customers alphabetically by last name:

SELECT p.customer_id, c.last_name, c.first_name, SUM(p.amount) AS 'Total Amount Paid'
FROM customer c
INNER JOIN payment p 
ON c.customer_id= p.customer_id
GROUP BY p.customer_id ORDER BY c.last_name  

-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 

-- 7A. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
-- As an unintended consequence, films starting with the letters K and Q have also soared in popularity.
-- Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.

SELECT title
FROM film WHERE title 
LIKE 'K%' OR title LIKE 'Q%'
AND title IN 
(SELECT title FROM film WHERE language_id = '1');

-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 

-- 7B. Use subqueries to display all actors who appear in the film Alone Trip.

SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(Select actor_id FROM film_actor WHERE film_id IN 
(SELECT film_id FROM film WHERE title = 'Alone Trip')); 

-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 

-- 7C. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. 
-- Use joins to retrieve this information.

SELECT c.first_name, c.last_name, c.email, country.country 
FROM customer c
JOIN address a ON (c.address_id = a.address_id)
JOIN city cty ON (cty.city_id = a.city_id)
JOIN country ON (country.country_id = cty.country_id)
WHERE country.country= 'Canada'; 

-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 

-- 7D. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

SELECT title, category
FROM film_list
WHERE category = 'Family';

-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 

-- 7e. Display the most frequently rented movies in descending order.

SELECT f.title, COUNT(rental_id) AS 'Times Rented'
FROM rental r 
JOIN inventory i ON (r.inventory_id = i.inventory_id)
JOIN film f ON (i.film_id = f.film_id)
GROUP BY f.title
ORDER BY `Times Rented` DESC;

-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 


-- 7Ff. Write a query to display how much business, in dollars, each store brought in.

SELECT s.store_id, SUM(amount)AS '$ Revenue'
FROM payment p
JOIN rental r ON (p.rental_id = r.rental_id)
JOIN inventory i ON (i.inventory_id = r.inventory_id)
JOIN store s ON (s.store_id = i.store_id)
GROUP BY s.store_id; 

-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 

-- 7G. Write a query to display for each store its store ID, city, and country.

SELECT s.store_id, cty.city, country.country 
FROM store s
JOIN address a ON (s.address_id = a.address_id)
JOIN city cty ON (cty.city_id = a.city_id)
JOIN country ON (country.country_id = cty.country_id);

-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 

 -- 7H. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.) 

SELECT c.name AS 'Genre', SUM(p.amount) AS 'Gross Revenue' 
FROM category c
JOIN film_category fc ON (c.category_id=fc.category_id)
JOIN inventory i ON (fc.film_id=i.film_id)
JOIN rental r ON (i.inventory_id=r.inventory_id)
JOIN payment p ON (r.rental_id=p.rental_id)
GROUP BY c.name ORDER BY Gross DESC LIMIT 5;

-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 

 -- 8A. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. 
 -- If you haven't solved 7h, you can substitute another query to create a view.

CREATE VIEW genre_gross_revenue AS
SELECT c.name AS 'Genre', SUM(p.amount) AS 'Gross Revenue' 
FROM category c
JOIN film_category fc ON (c.category_id=fc.category_id)
JOIN inventory i ON (fc.film_id=i.film_id)
JOIN rental r ON (i.inventory_id=r.inventory_id)
JOIN payment p ON (r.rental_id=p.rental_id)
GROUP BY c.name ORDER BY Gross DESC LIMIT 5;

-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 

 -- 8B. How would you display the view that you created in 8a?
 
SELECT * FROM genre_gross_revenue;

-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 

-- 8C. You find that you no longer need the view top_five_genres. Write a query to delete it.

DROP VIEW genre_gross_revenue;

