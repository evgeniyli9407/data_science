--1	� ����� ������� ������ ������ ���������?	
select city 
from airports a 
group by city
having count(distinct a.airport_code)>1 
--2	� ����� ���������� ���� �����, ����������� ��������� � ������������ ���������� ��������?	- ���������

select distinct (f.departure_airport) 
from flights f 
where f.aircraft_code =
	(select a.aircraft_code 
	from aircrafts a
	where a."range" = (select max("range")from aircrafts a2)
	)
 
--3	������� 10 ������ � ������������ �������� �������� ������	- �������� LIMIT
select *
from (select *, 
		case
		when f.scheduled_departure < f.actual_departure then concat('�������� �� ', (f.actual_departure - f.scheduled_departure))
		--when f.scheduled_departure is null or f.actual_departure is null then '��� ������ ����������'
		else null
		end as delay
	from flights f 
	) t
where t.delay is not null
order by delay desc
limit 10

--4	���� �� �����, �� ������� �� ���� �������� ���������� ������?	- ������ ��� JOIN
select *
from tickets t 
left join boarding_passes bp using(ticket_no)
where bp.ticket_no is null


--5	������� ���������� ��������� ���� ��� ������� �����, �� % ��������� � ������ ���������� ���� � ��������.
--�������� ������� � ������������� ������ - ��������� ���������� ���������� ���������� ���������� �� ������� ��������� �� ������ ����. 
--�.�. � ���� ������� ������ ���������� ������������� ����� - ������� ������� ��� �������� �� ������� ��������� �� ���� ��� ����� ������ ������ � ������� ���.	- ������� �������
--- ���������� ���/� cte (�� �������!)

select t1.flight_id, aircraft_code, placed_seats, count(s.seat_no)-placed_seats as "empty_seats", ((count(s.seat_no)-placed_seats)::numeric)/(count(s.seat_no)::numeric)*100 as "% ������ ����"
from 
	(select f.aircraft_code ,flight_id, count(bp.seat_no) as "placed_seats" 
	from flights f 
	join boarding_passes bp using(flight_id)
	group by flight_id
	order by flight_id) t1
join seats s using(aircraft_code)
group by aircraft_code, t1.flight_id, aircraft_code, placed_seats
order by flight_id

--6	������� ���������� ����������� ��������� �� ����� ��������� �� ������ ����������.	- ��������� ��� ����
-- �������� ROUND
select t.aircraft_code as "��� ��������",round(t.prcnt,2) as "% �� ������ ���������� �������"
from(select f.aircraft_code, (count(*) over(partition by f.aircraft_code)::numeric)/(count(*)over()::numeric)*100 as "prcnt"
	from flights f 
	join aircrafts a on a.aircraft_code = f.aircraft_code) t
group by t.aircraft_code, t.prcnt

--7	���� �� ������, � ������� �����  ��������� ������ - ������� �������, ��� ������-������� � ������ ��������?	- CTE
-- �����: � ������ �������� ����� ������� ���
with c1 as (
	select f.flight_id,a.city,tf.fare_conditions, min(tf.amount), max(tf.amount)
	from flights f 
	left join airports a on a.airport_code =f.arrival_airport 
	left join ticket_flights tf on tf.flight_id =f.flight_id 
	group by 3,2,1
	having tf.fare_conditions is not null 
	order by f.flight_id 	
), 
cte_1 as (
	select c1.flight_id as "flight_id_x", c1.city as "city_x",c1.fare_conditions as "fare_conditions_x", c1.min as "min_x"
	from c1
	where c1.fare_conditions = 'Business'
), cte_2 as (
	select c1.flight_id as "flight_id_y", c1.city as "city_y",c1.fare_conditions as "fare_conditions_y", c1.max as "max_y"
	from c1
	where c1.fare_conditions = 'Economy'
)
select "max_y", "min_x","city_y"
from cte_2
inner join cte_1 on "flight_id_x" = "flight_id_y"
where "max_y">"min_x"



--8	����� ������ �������� ��� ������ ������?	- ��������� ������������ � ����������� FROM
--- �������������� ��������� ������������� (���� �������� �����������, �� ��� �������������)
--- �������� EXCEPT

select a.city, b.city 
from airports a 
cross join airports b 
where a.city != b.city
except 
select r.departure_city, r.arrival_city 
from routes r 
--9	��������� ���������� ����� �����������, ���������� ������� �������, �������� � ���������� ������������ ���������� ���������  � ���������, ������������� ��� ����� *	
-- �������� RADIANS ��� ������������� sind/cosd
--- CASE 
