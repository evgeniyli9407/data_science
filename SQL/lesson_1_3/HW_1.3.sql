--=============== ������ 3. ������ SQL =======================================
--= �������, ��� ���������� ���������� ������ ���������� � ������� ����� PUBLIC===========
SET search_path TO public;

--======== �������� ����� ==============

--������� �1
--�������� ��� ������� ���������� ��� ����� ����������, 
--����� � ������ ����������.
select c.customer_id, a.address, ct.city, cntr.country 
from customer c 
 join address a on a.address_id =c.address_id 
 join city ct on ct.city_id = a.city_id 
 join country cntr on cntr.country_id = ct.country_id 



--������� �2
--� ������� SQL-������� ���������� ��� ������� �������� ���������� ��� �����������.
select s.store_id, count(c.customer_id) 
from store s 
join customer c on s.store_id = c.store_id 
group by s.store_id 


--����������� ������ � �������� ������ �� ��������, 
--� ������� ���������� ����������� ������ 300-��.
--��� ������� ����������� ���������� �� ��������������� ������� 
--� �������������� ������� ���������.
select s.store_id, count(c.customer_id) 
from store s 
join customer c on s.store_id = c.store_id 
group by s.store_id
having count(c.customer_id)>300 




-- ����������� ������, ������� � ���� ���������� � ������ ��������, 
--� ����� ������� � ��� ��������, ������� �������� � ���� ��������. 

select concat(st.first_name,' ', st.last_name ) as "��� ��������", ct.city ,count(c.customer_id) 
from store s 
join customer c on s.store_id = c.store_id 
join address a on a.address_id = s.address_id 
join city ct on a.city_id =ct.city_id 
join staff st on st.store_id = s.store_id 
group by s.store_id, ct.city , "��� ��������"
having count(c.customer_id)>300 



--������� �3
--�������� ���-5 �����������, 
--������� ����� � ������ �� �� ����� ���������� ���������� �������
select c.customer_id ,concat( c.first_name, ' ', c.last_name)as "������� � ��� ����������",  count(c.customer_id) as "���������� ������� ��������"
from customer c 
left join rental r on c.customer_id = r.customer_id 
group by c.customer_id
order by "���������� ������� ��������" desc
limit 5




--������� �4
--���������� ��� ������� ���������� 4 ������������� ����������:
--  1. ���������� �������, ������� �� ���� � ������
--  2. ����� ��������� �������� �� ������ ���� ������� (�������� ��������� �� ������ �����)
--  3. ����������� �������� ������� �� ������ ������
--  4. ������������ �������� ������� �� ������ ������
select c.customer_id , count(r.rental_id), round( sum(p.amount)),min(p.amount),  max(p.amount)
from customer c
join rental r ON r.customer_id = c.customer_id 
join payment p on r.rental_id = p.rental_id 
group by c.customer_id





--������� �5
--��������� ������ �� ������� ������� ��������� ����� �������� ������������ ���� ������� ����� �������,
 --����� � ���������� �� ���� ��� � ����������� ���������� �������. 
 --��� ������� ���������� ������������ ��������� ������������.
select c.city , c2.city 
from city c cross join city c2 
where c != c2



--������� �6
--��������� ������ �� ������� rental � ���� ������ ������ � ������ (���� rental_date)
--� ���� �������� ������ (���� return_date), 
--��������� ��� ������� ���������� ������� ���������� ����, �� ������� ���������� ���������� ������.
select concat(c.first_name, ' ', c.last_name ) as "������� � ��� ����������" ,date_trunc('day',  avg(r.return_date - r.rental_date)) as "AVG ���� ��������"
from rental r 
join customer c on r.customer_id  = c.customer_id 
group by r.customer_id, "������� � ��� ����������"
 




--======== �������������� ����� ==============

--������� �1
--���������� ��� ������� ������ ������� ��� ��� ����� � ������ � �������� ����� ��������� ������ ������ �� �� �����.
select f.film_id,f.title ,count(f.film_id) as "���������� �����", t.sum
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

--������� �2
--����������� ������ �� ����������� ������� � �������� � ������� ������� ������, ������� �� ���� �� ����� � ������. (�� ������)
select f.film_id,f.title ,count(f.film_id) as "���������� �����", t.sum
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



--������� �3
--���������� ���������� ������, ����������� ������ ���������. �������� ����������� ������� "������".
--���� ���������� ������ ��������� 7300, �� �������� � ������� ����� "��", ����� ������ ���� �������� "���".
select s.staff_id, concat(s.first_name, ' ', s.last_name) as "��� � ������� ��������", count(s.staff_id) as "���������� ������", 
	case 
		when count(s.staff_id) > 7300 then '��' 
		else '���'
	end
from payment p 
join staff s on s.staff_id  = p.staff_id 
group by s.staff_id 





