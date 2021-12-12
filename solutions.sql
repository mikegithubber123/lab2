-- 1 Pokazać pierwsze 10 wyników dla tabeli actor;
select * from actor limit 10;
-- 2 Pokazać filmy z literą ‘z’ w tytule filmu;
select * from film where upper(title) like upper('%Z%');
-- 3 Pokazać najdłuższy wynajem filmu;
select max(rental_duration) from film;
-- 4 Pokazać najdłuższy film;
select * from film order by length desc limit 1;
-- 5 Pokazać filmy których premiera odbyła się po 2000 roku;
select * from film where release_year > 2000;
-- 6 Pokazać filmy wydane w latach 1995-2005;
select * from film where release_year between 1995 and 2005;
-- 7 Zliczyć ilość rekordów dla każdej tabeli;
select schemaname,relname, n_live_tup from pg_stat_user_tables order by n_live_tup desc;

select 'actor' as name, count(*) as count from actor group by name union
select 'address' as name, count(*) as count from address group by name union
select 'category' as name, count(*) as count from category group by name union
select 'city' as name, count(*) as count from city group by name union
select 'country' as name, count(*) as count from country group by name union
select 'customer' as name, count(*) as count from customer group by name union
select 'film' as name, count(*) as count from film group by name union
select 'film_actor' as name, count(*) as count from film_actor group by name union
select 'film_category' as name, count(*) as count from film_category group by name union
select 'inventory' as name, count(*) as count from inventory group by name union
select 'language' as name, count(*) as count from language group by name union
select 'payment' as name, count(*) as count from payment group by name union
select 'rental' as name, count(*) as count from rental group by name union
select 'staff' as name, count(*) as count from staff group by name union
select 'store' as name, count(*) as count from store group by name;
--8 Zliczyć ilość rekordów dla każdej tabeli;
select actor.first_name name, actor.last_name lastname, count(*) count
from film_actor join actor on actor.actor_id = film_actor.actor_id group by name, lastname order by count desc limit 1;
-- 9 Pokazać ilość filmów w każdej kategorii i posortować od największej ilości;
select category.name name, count(*) count from category join film_category on category.category_id= film_category.category_id group by name order by count desc;
-- 10 Pokazać ilość klientów dla każdego miasta i posortować od największej liczby;
select city.city name, count(*) count from city 
join address on address.city_id = city.city_id 
join customer on customer.address_id = address.address_id 
group by name order by count desc;
-- 11 Pokazać ile filmów było w każdym roku;
select film.release_year as year, count(*) from film group by year;
-- 12  Pokazać film który zarobił najwięcej na wynajmie;
select film.title title, 
sum(payment.amount) sum 
from film 
join inventory on inventory.film_id = film.film_id 
join rental on inventory.inventory_id = rental.inventory_id 
join payment on payment.rental_id = rental.rental_id 
group by title order by sum desc limit 1;
--13 Pokazać kategorię która zarobiła najwięcej;
select category.name name,sum(payment.amount) total
from category
join film_category on category.category_id = film_category.category_id
join film on film.film_id = film_category.film_id 
join inventory on inventory.film_id = film.film_id 
join rental on inventory.inventory_id = rental.inventory_id 
join payment on payment.rental_id = rental.rental_id
group by name order by total desc limit 1;
-- 14 Pokazać ilość filmów dla każdego języka;
select language.name name, count(film.film_id) total
from language 
full join film on film.language_id = language.language_id
group by name order by total desc;
-- 15 Pokazać imię i nazwisko aktorów którzy zagrali w różnych kategoriach filmowych;
select actor.first_name, actor.last_name, count(distinct category.category_id) total from actor
join film_actor on film_actor.actor_id = actor.actor_id
join film on film_actor.film_id = film.film_id
join film_category on film_category.film_id = film.film_id
join category on film_category.category_id = category.category_id
group by actor.first_name, actor.last_name order by total;
-- 16 Pokazać imię i nazwisko aktorów którzy zagrali w top 10 najbardziej dochodowych filmach;
select actor.first_name, actor.last_name from actor
join film_actor on film_actor.actor_id = actor.actor_id
join film on film_actor.film_id = film.film_id
where film.film_id in
(select film.film_id as fid 
from film 
join inventory on inventory.film_id = film.film_id 
join rental on inventory.inventory_id = rental.inventory_id 
join payment on payment.rental_id = rental.rental_id 
group by fid order by sum(payment.amount) desc limit 10);
-- 17 Pokazać klientów którzy najczęściej wynajmowali filmy;
select customer.first_name name, customer.last_name lastname, count(rental.rental_id) rental_count from rental
join customer on customer.customer_id = rental.customer_id group by name, lastname order by rental_count desc;
-- 18 Pokazać klientów którzy wydali najwięcej na wynajem filmów;
select customer.first_name name, customer.last_name lastname, sum(payment.amount) amount_count from customer
join payment on payment.customer_id = customer.customer_id
group by name, lastname order by amount_count desc;
-- 19 Pokazać miasta w których najczęściej wypożyczano filmy;
select city.city name, count(rental.rental_id) rental_count from city 
join address on address.city_id = city.city_id 
join customer on customer.address_id = address.address_id 
join rental on rental.customer_id = customer.customer_id
group by name order by rental_count desc;
-- 20 Pokazać roczniki z największą kwotą za wynajem filmów;
select extract(year from payment.payment_date) date, sum(payment.amount) from payment group by date;



















