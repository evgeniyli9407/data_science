--======== �������� ����� ==============

--������� �1
--�������� ���������� �������� ������� �� ������� �������.
select  distinct city 
from public.city c




--������� �2
--����������� ������ �� ����������� �������, ����� ������ ������� ������ �� ������,
--�������� ������� ���������� �� �L� � ������������� �� �a�, � �������� �� �������� ��������.
select  distinct city 
from public.city c
where city not like '% %' and city like 'L%a' 




--������� �3
--�������� �� ������� �������� �� ������ ������� ���������� �� ��������, ������� ����������� 
--� ���������� � 17 ���� 2005 ���� �� 19 ���� 2005 ���� ������������, 
--� ��������� ������� ��������� 1.00.
--������� ����� ������������� �� ���� �������.
select *
from payment p 
where payment_date between '2005-06-17' and '2005-06-20'
and amount >1.00
order by payment_date desc 



--������� �4
-- �������� ���������� � 10-�� ��������� �������� �� ������ �������.
select * FROM payment 
ORDER BY payment_date desc 
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;




--������� �5
--�������� ��������� ���������� �� �����������:
--  1. ������� � ��� (� ����� ������� ����� ������)
--  2. ����������� �����
--  3. ����� �������� ���� email
--  4. ���� ���������� ���������� ������ � ���������� (��� �������)
--������ ������� ������� ������������ �� ������� �����.
select first_name ||' ' || last_name   as "��� � �������",
		email as "����������� �����",
		character_length(email) as "����a �������� ���� email",
		last_update::date as "���� ���������� ���������� ������ � ����������"
from customer c 




--������� �6
--�������� ����� �������� ������ �������� �����������, ����� ������� KELLY ��� WILLIE.
--��� ����� � ������� � ����� �� �������� �������� ������ ���� ���������� � ������ �������.
select * from customer c 
where last_name ilike 'kelly' or last_name ilike 'willie'




--======== �������������� ����� ==============

--������� �1
--�������� ����� �������� ���������� � �������, � ������� ������� "R" 
--� ��������� ������ ������� �� 0.00 �� 3.00 ������������, 
--� ����� ������ c ��������� "PG-13" � ���������� ������ ������ ��� ������ 4.00.
select *
from film f 
where rating ='R' and rental_rate between 0.00 and 3.01
union all 
select *
from film f2 
where rating ='PG-13' and rental_rate >=4.00




--������� �2
--�������� ���������� � ��� ������� � ����� ������� ��������� ������.
select film_id , title , release_year , language_id , rental_duration , rental_rate , replacement_cost , rating , last_update , character_length(description) as "desc_length_film"
from film f 
order by Desc_length_film desc 
OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY;



 --substring(email from 1 for strpos(email,'@')-1) as "������� �� @" ||
--������� �3
-- �������� Email ������� ����������, �������� �������� Email �� 2 ��������� �������:
--� ������ ������� ������ ���� ��������, ��������� �� @, 
--�� ������ ������� ������ ���� ��������, ��������� ����� @.
-- select substring(email from strpos(email,'@')+1 for character_length(customer.email) - character_length(substring(email from 1 for strpos(email,'@')-1))) as "POSLE"
-- from customer
--c.customer_id , c.email , substring(email from 1 for strpos(email,'@')-1) as "before @", substring(email from strpos(email,'@')+1 for character_length(c.email) - character_length(substring(email from 1 for strpos(email,'@')-1))) as "after @ "
select c.customer_id , c.email , substring(email from 1 for strpos(email,'@')-1) as "before @", substring(email from strpos(email,'@')+1 for character_length(c.email) - character_length(substring(email from 1 for strpos(email,'@')-1))) as "after @ "
from customer c
order by c.customer_id 


--������� �4
--����������� ������ �� ����������� �������, �������������� �������� � ����� ��������: 
--������ ����� ������ ���� ���������, ��������� ���������.
select c.customer_id , c.email , (upper (substring(email from 1 for 1)) || substring(email from 2 for strpos(email,'@')-1)) as "before @",
upper(left(substring(email from strpos(email,'@')+1 for character_length(c.email) - character_length(substring(email from 1 for strpos(email,'@')-1))), 1)) || substring(email from strpos(email,'@')+2 for character_length(c.email) - character_length(substring(email from 1 for strpos(email,'@')-1))) as "after @ "
from customer c
order by c.customer_id 

