--ЗАДАНИЕ №1
--Сделайте запрос к таблице payment и с помощью оконных функций добавьте вычисляемые колонки согласно условиям:
--Пронумеруйте все платежи от 1 до N по дате
--Пронумеруйте платежи для каждого покупателя, сортировка платежей должна быть по дате
--Посчитайте нарастающим итогом сумму всех платежей для каждого покупателя, сортировка должна 
--быть сперва по дате платежа, а затем по сумме платежа от наименьшей к большей
--Пронумеруйте платежи для каждого покупателя по стоимости платежа от наибольших к меньшим 
--так, чтобы платежи с одинаковым значением имели одинаковое значение номера.
--Можно составить на каждый пункт отдельный SQL-запрос, а можно объединить все колонки в одном запросе.


select *, row_number() over (order by payment_date) as "Нумерация всех",
	row_number() over (order by customer_id ,payment_date ) as "Нумерация по пользователю",
	sum(amount) over (partition by customer_id order by payment_date rows between unbounded preceding and current row) as "Сумма с нарастающим по юзеру"  
from payment p 

--ЗАДАНИЕ №2
--С помощью оконной функции выведите для каждого покупателя стоимость платежа и стоимость 
--платежа из предыдущей строки со значением по умолчанию 0.0 с сортировкой по дате.
select c.first_name, c.last_name , p.amount, 
	LAG(amount,1,'0.0') over(partition by c.customer_id order by c.customer_id, p.payment_date) "previous_amount",
	Lead(amount,1,'0.0') over(partition by c.customer_id order by c.customer_id,  p.payment_date) "next_amount"
from payment p
join customer c on p.customer_id = c.customer_id 



--ЗАДАНИЕ №3
--С помощью оконной функции определите, на сколько каждый следующий платеж покупателя больше или меньше текущего.
select c.first_name, c.last_name , p.amount, 
	LAG(amount,1,'0.0') over(partition by c.customer_id order by c.customer_id, p.payment_date) "previous_amount",
	Lead(amount,1,'0.0') over(partition by c.customer_id order by c.customer_id,  p.payment_date) "next_amount",
	case 
		when (Lead(amount,1,'0.0') over(partition by c.customer_id order by c.customer_id,  p.payment_date) - p.amount) >0 then concat('Больше текущего на ',CAST((Lead(amount,1,'0.0') over(partition by c.customer_id order by c.customer_id,  p.payment_date) - p.amount) AS VARCHAR(15)))
		else concat('Меньше текущего на ',CAST(abs((Lead(amount,1,'0.0') over(partition by c.customer_id order by c.customer_id,  p.payment_date) - p.amount)) AS VARCHAR(15)))
		end	
from payment p
join customer c on p.customer_id = c.customer_id 





--ЗАДАНИЕ №4
--С помощью оконной функции для каждого покупателя выведите данные о его последней оплате аренды.
select *
from (
	select *, row_number() over(partition by p.customer_id order by payment_date desc) as rn
	from payment p 
	join rental r on p.customer_id  = r.customer_id 
) t
where t.rn=1
--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--С помощью оконной функции выведите для каждого сотрудника сумму продаж за август 2005 года 
--с нарастающим итогом по каждому сотруднику и по каждой дате продажи (без учёта времени) 
--с сортировкой по дате.




--ЗАДАНИЕ №2
--20 августа 2005 года в магазинах проходила акция: покупатель каждого сотого платежа получал
--дополнительную скидку на следующую аренду. С помощью оконной функции выведите всех покупателей,
--которые в день проведения акции получили скидку




--ЗАДАНИЕ №3
--Для каждой страны определите и выведите одним SQL-запросом покупателей, которые попадают под условия:
-- 1. покупатель, арендовавший наибольшее количество фильмов
-- 2. покупатель, арендовавший фильмов на самую большую сумму
-- 3. покупатель, который последним арендовал фильм