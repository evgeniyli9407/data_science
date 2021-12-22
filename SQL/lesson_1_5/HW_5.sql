--������� �1
--�������� ������ � ������� payment � � ������� ������� ������� �������� ����������� ������� �������� ��������:
--������������ ��� ������� �� 1 �� N �� ����
--������������ ������� ��� ������� ����������, ���������� �������� ������ ���� �� ����
--���������� ����������� ������ ����� ���� �������� ��� ������� ����������, ���������� ������ 
--���� ������ �� ���� �������, � ����� �� ����� ������� �� ���������� � �������
--������������ ������� ��� ������� ���������� �� ��������� ������� �� ���������� � ������� 
--���, ����� ������� � ���������� ��������� ����� ���������� �������� ������.
--����� ��������� �� ������ ����� ��������� SQL-������, � ����� ���������� ��� ������� � ����� �������.


select *, row_number() over (order by payment_date) as "��������� ����",
	row_number() over (order by customer_id ,payment_date ) as "��������� �� ������������",
	sum(amount) over (partition by customer_id order by payment_date rows between unbounded preceding and current row) as "����� � ����������� �� �����"  
from payment p 

--������� �2
--� ������� ������� ������� �������� ��� ������� ���������� ��������� ������� � ��������� 
--������� �� ���������� ������ �� ��������� �� ��������� 0.0 � ����������� �� ����.
select c.first_name, c.last_name , p.amount, 
	LAG(amount,1,'0.0') over(partition by c.customer_id order by c.customer_id, p.payment_date) "previous_amount",
	Lead(amount,1,'0.0') over(partition by c.customer_id order by c.customer_id,  p.payment_date) "next_amount"
from payment p
join customer c on p.customer_id = c.customer_id 



--������� �3
--� ������� ������� ������� ����������, �� ������� ������ ��������� ������ ���������� ������ ��� ������ ��������.
select c.first_name, c.last_name , p.amount, 
	LAG(amount,1,'0.0') over(partition by c.customer_id order by c.customer_id, p.payment_date) "previous_amount",
	Lead(amount,1,'0.0') over(partition by c.customer_id order by c.customer_id,  p.payment_date) "next_amount",
	case 
		when (Lead(amount,1,'0.0') over(partition by c.customer_id order by c.customer_id,  p.payment_date) - p.amount) >0 then concat('������ �������� �� ',CAST((Lead(amount,1,'0.0') over(partition by c.customer_id order by c.customer_id,  p.payment_date) - p.amount) AS VARCHAR(15)))
		else concat('������ �������� �� ',CAST(abs((Lead(amount,1,'0.0') over(partition by c.customer_id order by c.customer_id,  p.payment_date) - p.amount)) AS VARCHAR(15)))
		end	
from payment p
join customer c on p.customer_id = c.customer_id 





--������� �4
--� ������� ������� ������� ��� ������� ���������� �������� ������ � ��� ��������� ������ ������.
select *
from (
	select *, row_number() over(partition by p.customer_id order by payment_date desc) as rn
	from payment p 
	join rental r on p.customer_id  = r.customer_id 
) t
where t.rn=1
--======== �������������� ����� ==============

--������� �1
--� ������� ������� ������� �������� ��� ������� ���������� ����� ������ �� ������ 2005 ���� 
--� ����������� ������ �� ������� ���������� � �� ������ ���� ������� (��� ����� �������) 
--� ����������� �� ����.




--������� �2
--20 ������� 2005 ���� � ��������� ��������� �����: ���������� ������� ������ ������� �������
--�������������� ������ �� ��������� ������. � ������� ������� ������� �������� ���� �����������,
--������� � ���� ���������� ����� �������� ������




--������� �3
--��� ������ ������ ���������� � �������� ����� SQL-�������� �����������, ������� �������� ��� �������:
-- 1. ����������, ������������ ���������� ���������� �������
-- 2. ����������, ������������ ������� �� ����� ������� �����
-- 3. ����������, ������� ��������� ��������� �����