
SET search_path TO "bookings"

--Задание № 1.

--Выведите название самолетов, которые имеют менее 50 посадочных мест.

select a.model,s.aircraft_code 
from aircrafts a 
join seats s on a.aircraft_code =s.aircraft_code 
group by s.aircraft_code,a.model 
having count(s.seat_no) < 50
order by s.aircraft_code

--Задание № 2.

--Выведите процентное изменение ежемесячной суммы бронирования билетов, округленной до сотых.

with recursive recrsv as (
	select min(date_trunc('month', book_date)) beg_of_mnth 
	from bookings
		union
	select beg_of_mnth+interval '1 MONTH' 
		as beg_of_mnth from recrsv
	where beg_of_mnth < (select max(date_trunc('month', book_date))
	from bookings))
select beg_of_mnth::date as "месяц бронир-я", coalesce(lft_j_sum.ttl_amount_month, 0) as "этот месяц",
lag(coalesce(lft_j_sum.ttl_amount_month, 0), 1, 0.) over (order by beg_of_mnth) as "прошлый месяц",
(case lag(coalesce(lft_j_sum.ttl_amount_month, 0), 1, 0.) over (order by beg_of_mnth)
					when 0 then 0.0
					else round(100.0*(coalesce(lft_j_sum.ttl_amount_month, 0) -
					lag(coalesce(lft_j_sum.ttl_amount_month, 0), 1, 0.) over (order by beg_of_mnth))
					/lag(coalesce(lft_j_sum.ttl_amount_month, 0), 1, 0.) over (order by beg_of_mnth),2)
					end) as "Изм.мес.сум.брон-я, %"
from recrsv
left join (
	select date_trunc('month', book_date) as month_id , sum(total_amount) as ttl_amount_month
	from bookings 
	group by date_trunc('month', book_date)) lft_j_sum on beg_of_mnth = month_id
order by beg_of_mnth

--Задание № 3.

--Выведите названия самолетов не имеющих бизнес - класс. Решение должно быть через функцию array_agg.

select a.model
from aircrafts a 
join seats s on a.aircraft_code =s.aircraft_code
group by s.aircraft_code,a.model
having array_position(array_agg(s.fare_conditions),'Business') IS null

--Задание № 4.

-- Вывести накопительный итог количества мест в самолетах по каждому
--аэропорту на каждый день, учитывая только те самолеты, которые летали
--пустыми и только те дни, где из одного аэропорта таких самолетов вылетало
--более одного.
--В результате должны быть код аэропорта, дата, количество пустых мест в
--самолете и накопительный итог.

select slct.dep_a as "код аэропорта", slct.dateofdep::date as "дата вылета",slct.seats as "кол-во пуст.мест",
sum(slct.seats) over (partition by slct.dep_a,slct.dateofdep::date order by slct.dateofdep) as "накоп.итог пуст.мест"
from       
	(select f.departure_airport as dep_a,f.actual_departure as dateofdep,f.flight_id,
	(select count(seat_no) FROM seats s 
	where s.aircraft_code=f.aircraft_code
	group by s.aircraft_code ) as seats,	 
	count(f.flight_id) over (partition by f.departure_airport,f.actual_departure::date) as flights_in_one_aport_aday
	 	from 
		flights f
		left join boarding_passes bp on f.flight_id=bp.flight_id
		where bp.flight_id is null and f.status in ('Arrived','Departed')
		) slct
where slct.flights_in_one_aport_aday >1
order by 1,2


--Задание № 5.

-- Найдите процентное соотношение перелетов по маршрутам от общего количества перелетов.
-- Выведите в результат названия аэропортов и процентное отношение.
-- Решение должно быть через оконную функцию.
        
select d.dep_name as "Аэропорт отправления",d.arr_name  as "Аэропорт прибытия",(route_cnt/cnt_all::numeric)*100 as "Проц. соотн-е маршрутов" from
(select a.airport_name as dep_name, b.airport_name as arr_name,f.flight_id,
count(f.flight_id) over (partition by concat(f.departure_airport,'-',f.arrival_airport)) as route_cnt,
count(*) over() as cnt_all
			from flights f
			join airports a on f.departure_airport = a.airport_code 
			join airports b on f.arrival_airport = b.airport_code) d
group by 1,2,3
order by 3 desc

--Задание № 6.

-- Выведите количество пассажиров по каждому коду сотового оператора, если учесть, что код оператора - это три символа после +7

select SUBSTRING(contact_data ->>'phone', 3, 3) as phone_code,
count(SUBSTRING(contact_data ->>'phone', 3, 3)) as "кол-во пассажиров по коду опер."
from tickets
group by phone_code
order by phone_code

--Задание № 7.

-- Классифицируйте финансовые обороты (сумма стоимости перелетов) по
--маршрутам:
-- До 50 млн - low
-- От 50 млн включительно до 150 млн - middle
-- От 150 млн включительно - high
-- Выведите в результат количество маршрутов в каждом полученном классе

			
select count(cnt_class) as "Кол-во маршрутов",cnt_class as "Класс" from 			
		(select concat(departure_airport,'-',arrival_airport) as route_name,sum(tf.amount),
				case when sum(tf.amount) < 50000000 then 'low'
			 	 	 when sum(tf.amount) >= 50000000 and sum(tf.amount) < 150000000 then 'middle'
			 	     when sum(tf.amount) >= 150000000 then 'high' 
				end as cnt_class	
				from flights f
			join ticket_flights tf on tf.flight_id =f.flight_id 
				group by route_name
				order by sum desc) g
group by cnt_class
order by count(cnt_class)

--Задание № 8.

-- Вычислите медиану стоимости перелетов, медиану размера бронирования и
--отношение медианы бронирования к медиане стоимости перелетов, округленной
--до сотых

select prcntl_amount as "медиана стоим.перелетов" , prcntl_tot_amount as "медиана р.бронирования",
round((prcntl_tot_amount::numeric/prcntl_amount::numeric),2) as "отношение медиан"
from 
	(select 
		(select percentile_cont(0.5) WITHIN GROUP (ORDER BY amount) FROM ticket_flights) as prcntl_amount,
		(select percentile_cont(0.5) WITHIN GROUP (ORDER BY total_amount) FROM bookings) as prcntl_tot_amount
     ) slct

--Задание № 9.

-- Найдите значение минимальной стоимости полета 1 км для пассажиров. То
--есть нужно найти расстояние между аэропортами и с учетом стоимости
--перелетов получить искомый результат
--  Для поиска расстояния между двумя точками на поверхности Земли
--используется модуль earthdistance.
--  Для работы модуля earthdistance необходимо предварительно установить
--модуль cube.
--  Установка модулей происходит через команду: create extension
--название_модуля.

create extension cube
create extension earthdistance

select round((1000.0*slct.min_amount/earth_distance(ll_to_earth(slct.a_lat::numeric, slct.a_lon::numeric), ll_to_earth(slct.b_lat::numeric, slct.b_lon::numeric))::numeric),2) as "Мин.стоим.1км"
from
	(select f.flight_no as first_id,min(tf.amount) as min_amount,
			a.latitude as a_lat, a.longitude as a_lon,b.latitude as b_lat, b.longitude as b_lon
				from flights f
				join airports a on f.departure_airport = a.airport_code 
				join airports b on f.arrival_airport = b.airport_code
				join ticket_flights tf on f.flight_id =tf.flight_id
	group by 1,3,4,5,6) slct
order by 1
limit 1     
     