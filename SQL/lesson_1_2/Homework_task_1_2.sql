--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Выведите уникальные названия городов из таблицы городов.
select  distinct city 
from public.city c




--ЗАДАНИЕ №2
--Доработайте запрос из предыдущего задания, чтобы запрос выводил только те города,
--названия которых начинаются на “L” и заканчиваются на “a”, и названия не содержат пробелов.
select  distinct city 
from public.city c
where city not like '% %' and city like 'L%a' 




--ЗАДАНИЕ №3
--Получите из таблицы платежей за прокат фильмов информацию по платежам, которые выполнялись 
--в промежуток с 17 июня 2005 года по 19 июня 2005 года включительно, 
--и стоимость которых превышает 1.00.
--Платежи нужно отсортировать по дате платежа.
select *
from payment p 
where payment_date between '2005-06-17' and '2005-06-20'
and amount >1.00
order by payment_date desc 



--ЗАДАНИЕ №4
-- Выведите информацию о 10-ти последних платежах за прокат фильмов.
select * FROM payment 
ORDER BY payment_date desc 
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;




--ЗАДАНИЕ №5
--Выведите следующую информацию по покупателям:
--  1. Фамилия и имя (в одной колонке через пробел)
--  2. Электронная почта
--  3. Длину значения поля email
--  4. Дату последнего обновления записи о покупателе (без времени)
--Каждой колонке задайте наименование на русском языке.
select first_name ||' ' || last_name   as "Имя и Фамилия",
		email as "Электронная почта",
		character_length(email) as "Длинa значения поля email",
		last_update::date as "Дата последнего обновления записи о покупателе"
from customer c 




--ЗАДАНИЕ №6
--Выведите одним запросом только активных покупателей, имена которых KELLY или WILLIE.
--Все буквы в фамилии и имени из верхнего регистра должны быть переведены в нижний регистр.
select * from customer c 
where last_name ilike 'kelly' or last_name ilike 'willie'




--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Выведите одним запросом информацию о фильмах, у которых рейтинг "R" 
--и стоимость аренды указана от 0.00 до 3.00 включительно, 
--а также фильмы c рейтингом "PG-13" и стоимостью аренды больше или равной 4.00.
select *
from film f 
where rating ='R' and rental_rate between 0.00 and 3.01
union all 
select *
from film f2 
where rating ='PG-13' and rental_rate >=4.00




--ЗАДАНИЕ №2
--Получите информацию о трёх фильмах с самым длинным описанием фильма.
select film_id , title , release_year , language_id , rental_duration , rental_rate , replacement_cost , rating , last_update , character_length(description) as "desc_length_film"
from film f 
order by Desc_length_film desc 
OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY;



 --substring(email from 1 for strpos(email,'@')-1) as "Колонка ДО @" ||
--ЗАДАНИЕ №3
-- Выведите Email каждого покупателя, разделив значение Email на 2 отдельных колонки:
--в первой колонке должно быть значение, указанное до @, 
--во второй колонке должно быть значение, указанное после @.
-- select substring(email from strpos(email,'@')+1 for character_length(customer.email) - character_length(substring(email from 1 for strpos(email,'@')-1))) as "POSLE"
-- from customer
--c.customer_id , c.email , substring(email from 1 for strpos(email,'@')-1) as "before @", substring(email from strpos(email,'@')+1 for character_length(c.email) - character_length(substring(email from 1 for strpos(email,'@')-1))) as "after @ "
select c.customer_id , c.email , substring(email from 1 for strpos(email,'@')-1) as "before @", substring(email from strpos(email,'@')+1 for character_length(c.email) - character_length(substring(email from 1 for strpos(email,'@')-1))) as "after @ "
from customer c
order by c.customer_id 


--ЗАДАНИЕ №4
--Доработайте запрос из предыдущего задания, скорректируйте значения в новых колонках: 
--первая буква должна быть заглавной, остальные строчными.
select c.customer_id , c.email , (upper (substring(email from 1 for 1)) || substring(email from 2 for strpos(email,'@')-1)) as "before @",
upper(left(substring(email from strpos(email,'@')+1 for character_length(c.email) - character_length(substring(email from 1 for strpos(email,'@')-1))), 1)) || substring(email from strpos(email,'@')+2 for character_length(c.email) - character_length(substring(email from 1 for strpos(email,'@')-1))) as "after @ "
from customer c
order by c.customer_id 

