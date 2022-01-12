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
-- �����: � ������ �������� ����� ������� ���, �� ���� �� ����� � ������� ��������, �� ����
with cte_ as (
    select   
        city,
        f.flight_id,
        fare_conditions, 
        amount
    from ticket_flights tf   
    join flights as f using(flight_id)
    join airports as ad on f.arrival_airport = ad.airport_code 
    order by city, fare_conditions asc
    )
select  
    city as "������ �������",
     max(CASE WHEN fare_conditions = 'Economy' THEN amount ELSE NULL END) as Max_Economy,
     min(CASE WHEN fare_conditions = 'Business' THEN amount ELSE NULL END) as Min_Business 
from cte_
group by city,fare_conditions 
having max(CASE WHEN fare_conditions = 'Economy' THEN amount ELSE NULL END) >= min(CASE WHEN fare_conditions = 'Business' THEN amount ELSE NULL END)
--having max(amount) filter (where fare_conditions = 'Economy') > min(amount) filter(where fare_conditions = 'Business') 
order by city asc 



--8	����� ������ �������� ��� ������ ������?	- ��������� ������������ � ����������� FROM
--- �������������� ��������� ������������� (���� �������� �����������, �� ��� �������������)
--- �������� EXCEPT

select a.city, b.city 
from airports a cross join airports b 
where a.city <> b.city
except 
select a.city, b.city 
from airports a 
inner join flights f on a.airport_name=f.departure_airport 
inner join airports b on b.airport_name=f.arrival_airport

--9	��������� ���������� ����� �����������, ���������� ������� �������, �������� � ���������� ������������ ���������� ���������  � ���������, ������������� ��� ����� *	
-- �������� RADIANS ��� ������������� sind/cosd
--- CASE 
