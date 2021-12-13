--=============== ������ 4. ���������� � SQL =======================================
--= �������, ��� ���������� ���������� ������ ���������� � ������� ����� PUBLIC===========
SET search_path TO public;

--======== �������� ����� ==============

--������� �1
--���� ������: ���� ����������� � �������� ����, �� ������� ����� ����� � ��������� � --���� �������, �������� ������ ���� �� �������� � ������ �������� � ������� �������� --� ���� ����� �����, ���� ����������� � ���������� �������, �� ������� ����� ����� � --� ��� ������� �������.

--������������� ���� ������, ���������� ��� �����������:
--� ���� (����������, ����������� � �. �.);
--� ���������� (�������, ���������� � �. �.);
--� ������ (������, �������� � �. �.).
--��� ������� �� �������: ����-���������� � ����������-������, ��������� ������ �� ������. ������ ������� �� ������� � film_actor.
--���������� � ��������-������������:
--� ������� ����������� ��������� ������.
--� �������������� �������� ������ ������������� ���������������;
--� ������������ ��������� �� ������ ��������� null-��������, �� ������ ����������� --��������� � ��������� ���������.
--���������� � �������� �� �������:
--� ������� ����������� ��������� � ������� ������.

--� �������� ������ �� ������� �������� ������� �������� ������ � ������� �� --���������� � ������ ������� �� 5 ����� � �������.
 
--�������� ������� �����
create table languages(
language_id SERIAL  primary key not null,
lang_name  varchar(50) not null unique
)



--�������� ������ � ������� �����
insert into languages (lang_name)
values('English'),
('French'),
('Russian'),
('Croatian'),
('Czhech');


--�������� ������� ����������
create table nationalities(
nation_id SERIAL  primary key not null,
nation_name  varchar(50) not null unique
)


--�������� ������ � ������� ����������
insert into nationalities (nation_name)
values('anglo-saxons'),
('French_ppl'),
('Russians'),
('Croats'),
('Czhechs');


--�������� ������� ������
create table countries(
country_id SERIAL  primary key not null,
country_name varchar(50) not null unique
)


--�������� ������ � ������� ������
insert into countries (country_name)
values('Great_Britain'),
('France'),
('Russia'),
('Croatia'),
('Czhech_republic');

drop table country 


drop table language 

drop table nations

--�������� ������ ������� �� �������
CREATE TABLE nat_lang 
(
  nation_id INT NOT NULL,
  language_id INT NOT NULL,
  primary key (nation_id, language_id),
  FOREIGN KEY (nation_id) 
        REFERENCES nationalities(nation_id),
  FOREIGN KEY (language_id) 
        REFERENCES languages(language_id)
)

--�������� ������ � ������� �� �������
insert into nat_lang (nation_id, language_id)
values(1,1),
(2,2),
(3,3),
(4,4),
(5,5);


--�������� ������ ������� �� �������
CREATE TABLE nat_count 
(
  nation_id INT NOT NULL,
  country_id INT NOT NULL,
  primary key (nation_id, country_id),
  FOREIGN KEY (nation_id) 
        REFERENCES nationalities(nation_id),
  FOREIGN KEY (country_id) 
        REFERENCES countries(country_id)
)


--�������� ������ � ������� �� �������

insert into nat_count (nation_id, country_id)
values(1,1),
(2,2),
(3,3),
(4,4),
(5,5);

--======== �������������� ����� ==============


--������� �1 
--�������� ����� ������� film_new �� ���������� ������:
--�   	film_name - �������� ������ - ��� ������ varchar(255) � ����������� not null
--�   	film_year - ��� ������� ������ - ��� ������ integer, �������, ��� �������� ������ ���� ������ 0
--�   	film_rental_rate - ��������� ������ ������ - ��� ������ numeric(4,2), �������� �� ��������� 0.99
--�   	film_duration - ������������ ������ � ������� - ��� ������ integer, ����������� not null � �������, ��� �������� ������ ���� ������ 0
--���� ��������� � �������� ����, �� ����� ��������� ������� ������� ������������ ����� �����.



--������� �2 
--��������� ������� film_new ������� � ������� SQL-�������, ��� �������� ������������� ������� ������:
--�       film_name - array['The Shawshank Redemption', 'The Green Mile', 'Back to the Future', 'Forrest Gump', 'Schindlers List']
--�       film_year - array[1994, 1999, 1985, 1994, 1993]
--�       film_rental_rate - array[2.99, 0.99, 1.99, 2.99, 3.99]
--�   	  film_duration - array[142, 189, 116, 142, 195]



--������� �3
--�������� ��������� ������ ������� � ������� film_new � ������ ����������, 
--��� ��������� ������ ���� ������� ��������� �� 1.41



--������� �4
--����� � ��������� "Back to the Future" ��� ���� � ������, 
--������� ������ � ���� ������� �� ������� film_new



--������� �5
--�������� � ������� film_new ������ � ����� ������ ����� ������



--������� �6
--�������� SQL-������, ������� ������� ��� ������� �� ������� film_new, 
--� ����� ����� ����������� ������� "������������ ������ � �����", ���������� �� �������



--������� �7 
--������� ������� film_new