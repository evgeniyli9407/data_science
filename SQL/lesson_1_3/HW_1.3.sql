--=============== МОДУЛЬ 3. ОСНОВЫ SQL =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO public;

--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Выведите для каждого покупателя его адрес проживания, 
--город и страну проживания.
select c.customer_id, a.address, ct.city, cntr.country 
from customer c 
 join address a on a.address_id =c.address_id 
 join city ct on ct.city_id = a.city_id 
 join country cntr on cntr.country_id = ct.country_id 



--ЗАДАНИЕ №2
--С помощью SQL-запроса посчитайте для каждого магазина количество его покупателей.
select s.store_id, count(c.customer_id) 
from store s 
join customer c on s.store_id = c.store_id 
group by s.store_id 


--Доработайте запрос и выведите только те магазины, 
--у которых количество покупателей больше 300-от.
--Для решения используйте фильтрацию по сгруппированным строкам 
--с использованием функции агрегации.
select s.store_id, count(c.customer_id) 
from store s 
join customer c on s.store_id = c.store_id 
group by s.store_id
having count(c.customer_id)>300 




-- Доработайте запрос, добавив в него информацию о городе магазина, 
--а также фамилию и имя продавца, который работает в этом магазине. 

select concat(st.first_name,' ', st.last_name ) as "ФИО продавца", ct.city ,count(c.customer_id) 
from store s 
join customer c on s.store_id = c.store_id 
join address a on a.address_id = s.address_id 
join city ct on a.city_id =ct.city_id 
join staff st on st.store_id = s.store_id 
group by s.store_id, ct.city , "ФИО продавца"
having count(c.customer_id)>300 



--ЗАДАНИЕ №3
--Выведите ТОП-5 покупателей, 
--которые взяли в аренду за всё время наибольшее количество фильмов
select c.customer_id ,concat( c.first_name, ' ', c.last_name)as "Фамилия и имя покупателя",  count(c.customer_id) as "Количество фильмов напрокат"
from customer c 
left join rental r on c.customer_id = r.customer_id 
group by c.customer_id
order by "Количество фильмов напрокат" desc
limit 5




--ЗАДАНИЕ №4
--Посчитайте для каждого покупателя 4 аналитических показателя:
--  1. количество фильмов, которые он взял в аренду
--  2. общую стоимость платежей за аренду всех фильмов (значение округлите до целого числа)
--  3. минимальное значение платежа за аренду фильма
--  4. максимальное значение платежа за аренду фильма
select c.customer_id , count(r.rental_id), round( sum(p.amount)),min(p.amount),  max(p.amount)
from customer c
join rental r ON r.customer_id = c.customer_id 
join payment p on r.rental_id = p.rental_id 
group by c.customer_id





--ЗАДАНИЕ №5
--Используя данные из таблицы городов составьте одним запросом всевозможные пары городов таким образом,
 --чтобы в результате не было пар с одинаковыми названиями городов. 
 --Для решения необходимо использовать декартово произведение.
select c.city , c2.city 
from city c cross join city c2 
where c != c2



--ЗАДАНИЕ №6
--Используя данные из таблицы rental о дате выдачи фильма в аренду (поле rental_date)
--и дате возврата фильма (поле return_date), 
--вычислите для каждого покупателя среднее количество дней, за которые покупатель возвращает фильмы.
select concat(c.first_name, ' ', c.last_name ) as "Фамилия и имя покупателя" ,date_trunc('day',  avg(r.return_date - r.rental_date)) as "AVG дней возврата"
from rental r 
join customer c on r.customer_id  = c.customer_id 
group by r.customer_id, "Фамилия и имя покупателя"
 




--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Посчитайте для каждого фильма сколько раз его брали в аренду и значение общей стоимости аренды фильма за всё время.
select f.film_id,f.title ,count(f.film_id) as "Количество аренд", t.sum
from film f 
join inventory i on i.film_id = f.film_id 
join rental r on r.inventory_id = i.inventory_id
join (select i.film_id ,sum(amount) 
	from payment p 
	join rental r on p.rental_id  = r.rental_id
	join inventory i on i.inventory_id  = r.inventory_id 
	group by i.film_id  
) t on t.film_id = f.film_id 
group by f.film_id, t.sum 

--ЗАДАНИЕ №2
--Доработайте запрос из предыдущего задания и выведите с помощью запроса фильмы, которые ни разу не брали в аренду. (Не сделал)
select f.film_id,f.title ,count(f.film_id) as "Количество аренд", t.sum
from film f 
join inventory i on i.film_id = f.film_id 
join rental r on r.inventory_id = i.inventory_id
join (select i.film_id ,sum(amount) 
	from payment p 
	join rental r on p.rental_id  = r.rental_id
	join inventory i on i.inventory_id  = r.inventory_id 
	group by i.film_id  
) t on t.film_id = f.film_id 
group by f.film_id, t.sum 



--ЗАДАНИЕ №3
--Посчитайте количество продаж, выполненных каждым продавцом. Добавьте вычисляемую колонку "Премия".
--Если количество продаж превышает 7300, то значение в колонке будет "Да", иначе должно быть значение "Нет".
select s.staff_id, concat(s.first_name, ' ', s.last_name) as "Имя и фамилия продавца", count(s.staff_id) as "Количество продаж", 
	case 
		when count(s.staff_id) > 7300 then 'ДА' 
		else 'Нет'
	end
from payment p 
join staff s on s.staff_id  = p.staff_id 
group by s.staff_id 





