DROP DATABASE IF EXISTS practice;
CREATE DATABASE practice; 
USE practice;

/*QUESTION 1 #############################################*/
drop table if exists tournament;

create table tournament(
id int not null,
team char(25) not null
);

insert into tournament
(id, team)
values(1,'India'),
(2,'Pakistan'),
(3,'Bangladesh'),
(4,'Srilanka');

select t1.team as country1, t2.team as country2
from tournament t1
join tournament t2
on t2.id>t1.id;
/*
create table tour_combo
as
select t1.team as team1, t2.team as team2
from tournament t1
join tournament t2
on t2.id>t1.id;
*/

/*QUESTION 2 #############################################*/
drop table if exists tour_combo;

create table tour_combo(
team1 char(25) not null,
team2 char(25) not null,
winner char(25) not null
);

insert into tour_combo
(team1, team2, winner)
values('India', 'Pakistan', 'India'),
('India', 'Srilanka', 'India'),
('Srilanka', 'India', 'India'),
('Pakistan', 'Srilanka', 'Srilanka'),
('Pakistan', 'England', 'Pakistan'),
('Srilanka', 'England', 'Srilanka');

select * from tour_combo;
/*
select tt.team, count(*) as no_of_matches_played
from
(select team1 as team
from tour_combo
union all
select team2 from tour_combo) tt
group by tt.team;
*/

select 
tc.country as team, 
count(tc.country),
sum(case when tc.country=tc.winner then 1 else 0 end) as won,
sum(case when tc.country<>tc.winner then 1 else 0 end) as lost
from
(select team1 as country, winner from tour_combo
union all
select team2 as country, winner from tour_combo) tc
group by tc.country;

/*QUESTION 3 #############################################*/
drop table if exists phone_log;

create table phone_log
(
source_phone_number int not null,
destination_phone_number int not null,
call_start_datetime datetime not null
);

insert into phone_log
(source_phone_number, destination_phone_number, call_start_datetime)
values
(1234, 4567, '2015-07-01 10:00:00'),
(1234, 2345, '2015-07-01 11:00:00'),
(1234, 3456, '2015-07-01 12:00:00'),
(1234, 3456, '2015-07-01 13:00:00'),
(1234, 4567, '2015-07-01 15:00:00'),
(1222, 7890, '2015-07-01 10:00:00'),
(1222, 7680, '2015-07-01 12:00:00'),
(1222, 2345, '2015-07-01 13:00:00');

select * from phone_log;

SELECT DISTINCT
SOURCE_PHONE_NUMBER,
if(nullif(
	(SELECT DESTINATION_PHONE_NUMBER
	FROM phone_log a
	WHERE a.SOURCE_PHONE_NUMBER = pl.SOURCE_PHONE_NUMBER
	AND a.CALL_START_DATETIME = (SELECT max(CALL_START_DATETIME)
								FROM phone_log b
								WHERE b.SOURCE_PHONE_NUMBER = pl.SOURCE_PHONE_NUMBER)),
	(SELECT DESTINATION_PHONE_NUMBER
	FROM phone_log a
	WHERE a.SOURCE_PHONE_NUMBER = pl.SOURCE_PHONE_NUMBER
	AND a.CALL_START_DATETIME = (SELECT min(CALL_START_DATETIME)
								FROM phone_log b
								WHERE b.SOURCE_PHONE_NUMBER = pl.SOURCE_PHONE_NUMBER))),'N','Y') AS flag
FROM phone_log pl;


/*QUESTION 4 #############################################*/
drop table if exists book_lang;

create table book_lang(
book_name char(25),
language char(25)
);
insert into book_lang(book_name, language)
values
('A', 'EN'),
('A', 'FR'),
('A', 'JP'),
('B', 'EN'),
('B', 'JP'),
('B', 'CN'),
('C', 'EN');

select * from book_lang;

select book_name
from (select book_name, count(language) as no_of_lang
from book_lang
group by book_name) tt
where tt.no_of_lang>(select count(distinct language)/2 from book_lang);


/*QUESTION 5 #############################################*/
drop table if exists orders;

create table orders(
order_day date,
customer_id int,
order_price int);

insert into orders(order_day, customer_id, order_price)
values
('2016-01-01', 1245845, 10),
('2016-01-29', 1245845, 57),
('2016-02-16', 1245845, 89),
('2016-02-28', 1245845, 102),
('2016-04-05', 1245845, 210),
('2016-01-02', 1242302, 95),
('2016-01-30', 1242302, 150),
('2016-02-17', 1242302, 96),
('2016-02-29', 1242302, 230),
('2016-04-06', 1242302, 340);

select * from orders;

select t.customer_id
from orders t
group by t.customer_id
having group_concat(order_price order by order_price) = group_concat(order_price order by order_day);



