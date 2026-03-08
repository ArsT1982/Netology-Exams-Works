set search_path to public;
----------------------------Задание №1
--1. Используя сервис https://supabase.com/ нужно поднять облачную базу данных PostgreSQL.
----------------------------Задание №2
--https://supabase.com/dashboard/project/bladaxwzhlnpxmjwbdqg

--organization:sansevsemen@gmail.com`s Org
--name_prj:EX_SQLP-36
--pass:QMGLxaKkHUnvWABJ

--settings--


--mode:transaction
--ref_id:bladaxwzhlnpxmjwbdqg
--host:aws-0-eu-central-1.pooler.supabase.com
--dbname:postgres
--port:6543
--user:postgres.bladaxwzhlnpxmjwbdqg

--user:netocourier.bladaxwzhlnpxmjwbdqg
--pass:NetoSQL2022


CREATE ROLE netocourier with LOGIN;
ALTER ROLE netocourier WITH PASSWORD 'NetoSQL2022';
GRANT CONNECT ON DATABASE postgres TO netocourier;

GRANT USAGE ON SCHEMA public TO netocourier;
GRANT USAGE ON SCHEMA information_schema TO netocourier;
GRANT USAGE ON SCHEMA pg_catalog TO netocourier; 
GRANT ALL ON SCHEMA public TO netocourier;

GRANT USAGE ON SCHEMA extensions TO netocourier;
GRANT USAGE ON SCHEMA extensions TO postgres;


GRANT postgres TO netocourier;
GRANT ALL ON ALL TABLES IN SCHEMA public TO netocourier;
GRANT ALL ON ALL TABLES IN SCHEMA information_schema TO netocourier;
GRANT ALL ON ALL TABLES IN SCHEMA pg_catalog TO netocourier;


REVOKE REFERENCES, TRIGGER, truncate,DELETE,UPDATE,INSERT ON ALL tables IN SCHEMA information_schema FROM netocourier;
REVOKE REFERENCES, TRIGGER, truncate,DELETE,UPDATE,INSERT ON ALL tables IN SCHEMA pg_catalog FROM netocourier;


------------------------------- Задание №4 
select * from pg_available_extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp"
select * from pg_extension;

CREATE EXTENSION tsm_system_rows



------------------------------- Задание №5

CREATE TYPE "enum"  AS ENUM ('В очереди', 'Выполняется', 'Выполнено', 'Отменен');

------------------------------- Задание №3

--DROP TABLE public."user" CASCADE;

CREATE TABLE "user" (--сотрудники
id uuid not null,
last_name varchar (50) not null, --фамилия сотрудника
first_name varchar (50) not null, --имя сотрудника
dismissed boolean not null default false, --уволен или нет, значение по умолчанию "нет"
CONSTRAINT user_id_pkey PRIMARY KEY (id)
);


--DROP TABLE public.account CASCADE;

CREATE TABLE account (
id uuid not null,
name varchar (100) not null, --название контрагента
CONSTRAINT account_id_pkey PRIMARY KEY (id)
);

--DROP TABLE public.contact CASCADE;

create table contact( --список контактов контрагентов
id uuid not null,
last_name varchar (50) not null,--фамилия контакта
first_name varchar (50) not null, --имя контакта
account_id uuid not null,  --id контрагента
CONSTRAINT contact_id_pkey PRIMARY KEY (id),
CONSTRAINT cnt_account_id_fkey FOREIGN KEY (account_id) references public.account(id) ON DELETE CASCADE
);

CREATE INDEX contact_account_id_index ON public.contact(account_id);

SELECT user
--DROP TABLE public.courier CASCADE

CREATE TABLE courier (
id uuid not null,
from_place varchar(100) not null, --откуда
where_place varchar(100) not null, --куда
name varchar(100) not null, --название документа
account_id uuid not null, --id контрагента
contact_id uuid not null, --id контакта 
description text null, --описание
user_id uuid not null, --id сотрудника отправителя
status "enum" not null default 'В очереди', -- статусы 'В очереди', 'Выполняется', 'Выполнено', 'Отменен'. По умолчанию 'В очереди'
created_date date not null default now(),--дата создания заявки, значение по умолчанию now()
CONSTRAINT courier_pkey PRIMARY KEY (id),
CONSTRAINT account_id_fkey FOREIGN KEY (account_id) references public.account(id) ON DELETE CASCADE,
CONSTRAINT contact_id_fkey FOREIGN KEY (contact_id) references public.contact(id) ON DELETE CASCADE,
CONSTRAINT user_id_fkey FOREIGN KEY (user_id) references public."user"(id) ON DELETE CASCADE
);

CREATE INDEX courier_account_id_index ON public.courier(account_id);
CREATE INDEX courier_contact_id_index ON public.courier(contact_id);
CREATE INDEX courier_user_id_index ON public.courier(user_id);


/*
SELECT 
pge.extname,
pge.extversion,
pn.nspname AS schema
FROM pg_extension pge 
JOIN pg_catalog.pg_namespace pn ON pge.extnamespace = pn."oid" ;
*/

--select extensions.uuid_generate_v4();

/*

INSERT INTO public."user"
(id,last_name, first_name, dismissed)
VALUES(extensions.uuid_generate_v4(), 's', 'a', false);

INSERT INTO public.courier
(id, from_place, where_place, "name", account_id, contact_id, description, user_id, "status", created_date)
VALUES(extensions.uuid_generate_v4(), 'from', 'to', 'orderlist', extensions.uuid_generate_v4(), extensions.uuid_generate_v4(), 'very important document', extensions.uuid_generate_v4(), 'В очереди'::enum, now());

INSERT INTO public.contact
(id, last_name, first_name, account_id)
VALUES(extensions.uuid_generate_v4(), 'a', 'g', extensions.uuid_generate_v4());

INSERT INTO public.account
(id, "name")
VALUES(extensions.uuid_generate_v4(), 'ROGA & KOPYTA');



--6

----ПОДГОТОВКА----

select repeat(substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя',1,(random()*33)::integer),(random()*10)::integer);

select repeat(substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя',1,(random()*33+1)::integer),(random()*10)::integer);
select substring(repeat(substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя',1,(random()*33+1)::integer),(random()*10)::integer),1,25);

select substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя',1,((random()*33)+1)::integer)

select random()  --от нуля включительно до 1 не включительно
select (random()::integer)::boolean
--select (random()*1)::integer

--SELECT SUBSTRING((repeat(substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя',1,((random()*33)+1::integer),(random()*10)::integer)), 1, 2);
select substring(repeat(substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя',1,((random()*33)+1)::integer),(random()*5)::integer)),1,25;


select now() - interval '1 day'*round((random()+1)*90) as timesamp;  --генерация даты и времени 

---генерация статусов через enum_range("enum")
select (enum_range(null::"enum"))
select (enum_range(null::"enum"))[((random()*3)+1)::integer] --работает
select (enum_range(null::"enum"))[0]


--- по 10000 записей insert as data 2 минуты

select customer_id
from customer c
order by random()
limit 1



CREATE TABLE transactions (
  id           SERIAL PRIMARY KEY,
  amount       NUMERIC(15,2),
  ending_time  TIMESTAMP
);
 
INSERT INTO transactions (amount, ending_time)
  SELECT
    (round(CAST(random() * 100000 AS NUMERIC), 2)),
    now() - random() * CAST('1 day' AS INTERVAL)
FROM generate_series(1, 10000);

--Попробуем взять сэмпл записей размером 0.1% от исходной таблицы (100 записей):
SELECT id, amount, ending_time FROM transactions 
TABLESAMPLE BERNOULLI(0.1) limit 1
 
Total query runtime: 213 ms.
157 rows retrieved.

create temp table tbl_filtered as select id from table where age < 20;
select id from tbl_filtered tablesample bernoulli(10) limit 30;
*/


--DROP FUNCTION IF EXISTS  insert_test_data()
--DROP PROCEDURE IF EXISTS insert_test_data()

/*CREATE PROCEDURE p1() AS $$
BEGIN
FOR i IN 1..10
LOOP 
INSERT INTO table_b(val)
VALUES (i);
IF i%2 = 0 
THEN COMMIT; 
ELSE 
ROLLBACK;
END IF;
END LOOP;
END;
$$ LANGUAGE plpgsql*/

------------------------------- Задание №6


CREATE or replace PROCEDURE insert_test_data(value integer) AS $$ 
BEGIN
FOR i IN 1..value*1
	LOOP 
		INSERT INTO public."user"
		(id,last_name, first_name, dismissed)
		VALUES(extensions.uuid_generate_v4(),
		substring(repeat(substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя',1,(random()*33+1)::integer),(random()*2+1)::integer),1,50),
		substring(repeat(substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя',1,(random()*33+1)::integer),(random()*2+1)::integer),1,50),
		(random()::integer)::boolean);
	END LOOP;

FOR s IN 1..value*1
	LOOP 
		INSERT INTO public.account
		(id, "name")
		VALUES(extensions.uuid_generate_v4(),
		substring(repeat(substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя',1,(random()*33+1)::integer),(random()*3+1)::integer),1,100));
	END LOOP;

FOR f IN 1..value*2
	LOOP 
		INSERT INTO public.contact
		(id, last_name, first_name, account_id)
		VALUES(extensions.uuid_generate_v4(),
		substring(repeat(substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя',1,(random()*33+1)::integer),(random()*2+1)::integer),1,50),
		substring(repeat(substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя',1,(random()*33+1)::integer),(random()*2+1)::integer),1,50),
		(SELECT a.id FROM public.account a TABLESAMPLE SYSTEM_ROWS(99) order by random() limit 1));
		END LOOP;
	
FOR d IN 1..value*5	
	LOOP		
		INSERT INTO public.courier
		(id, from_place, where_place, "name", account_id, contact_id, description, user_id, "status", created_date)
		VALUES(extensions.uuid_generate_v4(),
		substring(repeat(substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя',1,(random()*33+1)::integer),(random()*3+1)::integer),1,100),
		substring(repeat(substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя',1,(random()*33+1)::integer),(random()*3+1)::integer),1,100),
		substring(repeat(substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя',1,(random()*33+1)::integer),(random()*3+1)::integer),1,100),
		(SELECT a.id FROM public.account a TABLESAMPLE SYSTEM_ROWS(99) order by random() limit 1),
		(select c.id FROM public.contact c TABLESAMPLE SYSTEM_ROWS(99) order by random() limit 1),
		substring(repeat(substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя',1,(random()*33+1)::integer),(random()*7+1)::integer),1,200),	 
		(select u.id FROM public."user" u  TABLESAMPLE SYSTEM_ROWS(99) order by random() limit 1),
		(enum_range(null::"enum"))[(random()*3+1)::integer],
		(now() - (interval '1 day')*(round(random()*100+1)))::timestamp);
	end LOOP;
	END;
$$ LANGUAGE plpgsql


select a.id from public.account a TABLESAMPLE BERNOULLI(10) order by random() limit 1
SELECT a.id FROM public.account a TABLESAMPLE SYSTEM_ROWS(1)

--select user
call insert_test_data(10000)


(select id from account TABLESAMPLE system(10.0) order by random() limit 1)
SELECT id, "name"
FROM public.account;


call erase_test_data()

select distinct account_id from courier c 
select distinct contact_id from courier c 
select distinct user_id from courier c 

select distinct id from contact c 
select distinct id from account a  
select distinct id from "user" u 

/*
select distinct 


--select * from "user"
select char_length(last_name) as "max" from "user" order by max desc
select char_length(first_name) as "max" from "user" order by max desc

select char_length(last_name) as "max" from "user" order by max
select char_length(first_name) as "max" from "user" order by max

--select * from account
select char_length("name") as "max" from account order by max desc
select char_length("name") as "max" from account order by max

--select * from contact

select char_length("last_name") as "max" from contact order by max desc
select char_length("first_name") as "max" from contact order by max desc

select char_length("last_name") as "max" from contact order by max
select char_length("first_name") as "max" from contact order by max

--select * from courier
select char_length("from_place") as "max" from courier order by max desc
select char_length("where_place") as "max" from courier order by max desc
select char_length("name") as "max" from courier order by max desc
select char_length("description") as "max" from courier order by max desc

select char_length("from_place") as "max" from courier order by max
select char_length("where_place") as "max" from courier order by max
select char_length("name") as "max" from courier order by max
select char_length("description") as "max" from courier order by max
*/


-------------------------------ЗАДАНИЕ № 7

CREATE or replace PROCEDURE erase_test_data() AS $$ 
begin
DELETE from public.courier;
DELETE from public.contact;
DELETE from public."user";
DELETE from public.account;
END;
$$ LANGUAGE plpgsql

call erase_test_data()


-------------ЗАДАНИЕ № 8

/*
8. На бэкенде реализована функция по добавлению новой записи о заявке на курьера:
function add($params) --добавление новой заявки
    {
        $pdo = Di::pdo();
        $from = $params["from"]; 
        $where = $params["where"]; 
        $name = $params["name"]; 
        $account_id = $params["account_id"]; 
        $contact_id = $params["contact_id"]; 
        $description = $params["description"]; 
        $user_id = $params["user_id"]; 
        $stmt = $pdo->prepare('CALL add_courier (?, ?, ?, ?, ?, ?, ?)');
        $stmt->bindParam(1, $from); --from_place
        $stmt->bindParam(2, $where); --where_place
        $stmt->bindParam(3, $name); --name
        $stmt->bindParam(4, $account_id); --account_id
        $stmt->bindParam(5, $contact_id); --contact_id
        $stmt->bindParam(6, $description); --description
        $stmt->bindParam(7, $user_id); --user_id
        $stmt->execute();
    }
Нужно реализовать процедуру add_courier(from_place, where_place, name, account_id, contact_id, description, user_id), 
которая принимает на вход вышеуказанные аргументы и вносит данные в таблицу courier
Важно! Последовательность значений должна быть строго соблюдена, иначе приложение работать не будет.
*/


--CALL add_courier (?, ?, ?, ?, ?, ?, ?)
--add_courier(from_place, where_place, name, account_id, contact_id, description, user_id)

CREATE or replace PROCEDURE add_courier(from_place varchar, where_place varchar, "name" varchar, account_id uuid, contact_id uuid, description text, user_id uuid) AS $$
begin
INSERT INTO public.courier
		(from_place, where_place, "name", account_id, contact_id, description, user_id,id)
		VALUES(from_place, where_place, "name", account_id, contact_id, description, user_id,extensions.uuid_generate_v4());
END;
$$ LANGUAGE plpgsql


----TEST!!!------------------------------------------------------
CREATE or replace PROCEDURE test_add_courier() AS $$ 
declare account_test uuid;
declare contact_test uuid;
declare user_test uuid;
begin
account_test=(select id from account a limit 1);
contact_test=(select id from contact c limit 1);
user_test=(select id from "user" cnt limit 1);
CALL add_courier('тест туда2', 'тест назад2', 'очен1 вадный документ',
account_test,contact_test,'текст',user_test);
END;
$$ LANGUAGE plpgsql

call test_add_courier()

select * from courier where from_place like 'тест туда2'

--------------------------------------------------------------------------------


--------------------ЗАДАНИЕ № 9------------

/*
9. На бэкенде реализована функция по получению записей о заявках на курьера: 
static function get() --получение списка заявок
    {
        $pdo = Di::pdo();
        $stmt = $pdo->prepare('SELECT * FROM get_courier()');
        $stmt->execute();
        $data = $stmt->fetchAll();
        return $data;
    }
Нужно реализовать функцию get_courier(), которая возвращает таблицу согласно следующей структуры:
id --идентификатор заявки
from_place --откуда
where_place --куда
name --название документа
account_id --идентификатор контрагента
account --название контрагента
contact_id --идентификатор контакта
contact --фамилия и имя контакта через пробел
description --описание
user_id --идентификатор сотрудника
user --фамилия и имя сотрудника через пробел
status --статус заявки
created_date --дата создания заявки
Сортировка результата должна быть сперва по статусу, затем по дате от большего к меньшему.
Важно! Если названия столбцов возвращаемой функцией таблицы будут отличаться от указанных выше, то приложение работать не будет.
*/

CREATE OR REPLACE FUNCTION get_courier() RETURNS TABLE(
		id uuid,--идентификатор заявки
		from_place varchar, --откуда
		where_place varchar, --куда
		"name" varchar, --название документа
		account_id uuid, --идентификатор контрагента
		account varchar,--название контрагента
		contact_id  uuid,--идентификатор контакта
		contact varchar,--фамилия и имя контакта через пробел
		description text,--описание
		user_id uuid, --идентификатор сотрудника
		"user" varchar,--фамилия и имя сотрудника через пробел
		status enum, --статус заявки
		created_date date --дата создания заявки
	)  AS $$
    BEGIN
        RETURN QUERY 
        select c.id,
		c.from_place,
		c.where_place,
		c.name,
		c.account_id,
		a.name,
		c.contact_id,
		concat(c2.last_name, ' ', c2.first_name)::varchar,
		c.description,
		c.user_id,
		concat(u.last_name,' ',u.first_name)::varchar,
		c.status,
		c.created_date
		from 
		courier c 
		left join account a on c.account_id =a.id 
		left join contact c2 on c.contact_id =c2.id 
		left join "user" u on c.user_id =u.id 
		order by c.status,created_date desc;
    END;
$$ LANGUAGE plpgsql;



select * from get_courier()

------------------ЗАДАНИЕ № 10

10. На бэкенде реализована функция по изменению статуса заявки.
function change_status($params) --изменение статуса заявки
    {
        $pdo = Di::pdo();
        $status = $params["new_status"];
        $id = $params["id"];
        $stmt = $pdo->prepare('CALL change_status(?, ?)');
        $stmt->bindParam(1, $status); --новый статус
        $stmt->bindParam(2, $id); --идентификатор заявки
        $stmt->execute();
    }
Нужно реализовать процедуру change_status(status, id), 
которая будет изменять статус заявки. 
На вход процедура принимает 
новое значение статуса и
значение идентификатора заявки.

--drop procedure change_status(_status,_id)

CREATE or replace PROCEDURE change_status(_status "enum",_id uuid) AS $$
BEGIN
UPDATE courier 
SET status = _status 
WHERE id = _id;
END;
$$ LANGUAGE plpgsql;

CALL change_status('Выполнено', '2487b240-1777-433f-afb3-7e975150ec8d');


select * from courier c  where id = '2487b240-1777-433f-afb3-7e975150ec8d'


------------------ЗАДАНИЕ № 11
11. На бэкенде реализована функция получения списка сотрудников компании.
static function get_users() --получение списка пользователей
    {
        $pdo = Di::pdo();
        $stmt = $pdo->prepare('SELECT * FROM get_users()');
        $stmt->execute();
        $data = $stmt->fetchAll();
        $result = [];
        foreach ($data as $v) {
            $result[] = $v['user'];
        }
        return $result;
    }
Нужно реализовать функцию get_users(), которая возвращает таблицу согласно следующей структуры:
user --фамилия и имя сотрудника через пробел 
Сотрудник должен быть действующим! Сортировка должна быть по фамилии сотрудника.


CREATE OR REPLACE FUNCTION get_users() RETURNS TABLE(
		"user" varchar
	)  AS $$
    BEGIN
        RETURN QUERY 
            select a."user" from 
(select concat(last_name,' ',first_name)::varchar "user",
last_name,
dismissed from public."user" 
where dismissed = false
order by 2) a;
    END;
$$ LANGUAGE plpgsql;

select * from get_users()

------------------ЗАДАНИЕ № 12


12. На бэкенде реализована функция получения списка контрагентов.
static function get_accounts() --получение списка контрагентов
    {
        $pdo = Di::pdo();
        $stmt = $pdo->prepare('SELECT * FROM get_accounts()');
        $stmt->execute();
        $data = $stmt->fetchAll();
        $result = [];
        foreach ($data as $v) {
            $result[] = $v['account'];
        }
        return $result;
    }
Нужно реализовать функцию get_accounts(), которая возвращает таблицу согласно следующей структуры:
account --название контрагента 
Сортировка должна быть по названию контрагента.

CREATE OR REPLACE FUNCTION get_accounts() RETURNS TABLE(
		account varchar
	)  AS $$
    BEGIN
        RETURN QUERY 
            select "name" from public.account order by 1;
    END;
$$ LANGUAGE plpgsql;

select * from get_accounts()

----------------ЗАДАНИЕ 13

/*
13. На бэкенде реализована функция получения списка контактов.
function get_contacts($params) --получение списка контактов
    {
        $pdo = Di::pdo();
        $account_id = $params["account_id"]; 
        $stmt = $pdo->prepare('SELECT * FROM get_contacts(?)');
        $stmt->bindParam(1, $account_id); --идентификатор контрагента
        $stmt->execute();
        $data = $stmt->fetchAll();
        $result = [];
        foreach ($data as $v) {
            $result[] = $v['contact'];
        }
        return $result;
    }
Нужно реализовать функцию get_contacts(account_id), которая принимает на вход идентификатор контрагента и возвращает таблицу с контактами переданного контрагента согласно следующей структуры:
contact --фамилия и имя контакта через пробел 
Сортировка должна быть по фамилии контакта. Если в функцию вместо идентификатора контрагента передан null, нужно вернуть строку 'Выберите контрагента'.

*/

--drop function get_contacts(account_id uuid)


CREATE OR REPLACE FUNCTION get_contacts(uuid) RETURNS TABLE(
		contact varchar
	)  AS $$
	begin 
      if $1 is null then
		return QUERY 
         select ('Выберите контрагента')::varchar;
	 else	 
	   RETURN QUERY 
           select a.contact::varchar from 
		(select concat(last_name,' ',first_name)::varchar as contact,
		last_name,account_id from public.contact
		where account_id = $1
		order by 2) a;
	end if;
END;
$$ LANGUAGE plpgsql;


select * from get_contacts('ea084833-5f49-413d-8660-235f2c761ebb')
select * from get_contacts(null)

create or replace function foo4(uuid) returns table (contact varchar) as $$
begin
	  RETURN QUERY 
SELECT CASE 
       WHEN $1 is null -- always false
       THEN (SELECT 'YES'::varchar)
       ELSE (SELECT 'NO'::varchar)
        END;
end;
$$ language plpgsql


CREATE OR REPLACE FUNCTION get_contacts(uuid) RETURNS TABLE(
		contact varchar
	)  AS $$
	begin 
  RETURN QUERY 
SELECT CASE 
       WHEN $1 is null 
       THEN (SELECT 'Выберите контрагента'::varchar)
       END;
  SELECT CASE    
       ELSE (select ("contact2")::varchar from 
		(select concat(last_name,' ',first_name) as "contact2",
		last_name,account_id from public.contact
		where account_id = $1
		order by 2) a)
        END;
     end;
$$ LANGUAGE plpgsql;

select * from get_contacts('44f4a81a-d7ab-405e-b0c2-eb0903a38677')
select * from get_contacts(null::uuid)

CREATE OR REPLACE FUNCTION my_function(uuid) RETURNS TABLE(
		contact varchar
	)  AS $$
	begin 
    IF $1 is null THEN
        RETURN QUERY
        SELECT 'ok'::varchar;
    ELSIF $1 is not null THEN 
         RETURN QUERY
        SELECT (select ("contact2")::varchar from 
		(select concat(last_name,' ',first_name) as "contact2",
		last_name,account_id from public.contact
		where account_id = $1
		order by 2) a);
    END IF;
     end;
$$ LANGUAGE plpgsql;

-- exemplary use:

SELECT * FROM my_function(null::uuid);
SELECT * FROM my_function('44f4a81a-d7ab-405e-b0c2-eb0903a38677'::uuid);




select concat(last_name,' ',first_name) as contact,
		last_name,account_id from public.contact
		where account_id = '44f4a81a-d7ab-405e-b0c2-eb0903a38677'
		order by 2
--select 'Выберите контрагента'

select "contact"::varchar from 
(select concat(last_name,' ',first_name) as "contact",
last_name,account_id from public.contact
where account_id = '44f4a81a-d7ab-405e-b0c2-eb0903a38677'
order by 2) a

select concat(last_name,' ',first_name) as contact,
		last_name,account_id from public.contact
		where account_id = ('44f4a81a-d7ab-405e-b0c2-eb0903a38677')::uuid
		order by 2

public.contact 
where dismissed = false
order by 2) a

select * from get_contacts()

create or replace function foo(start_date date, end_date date) returns numeric as $$
declare res_amount numeric = 0;
begin
	if start_date is null or end_date is null 
		then raise exception 'Одна из дат отсутствует';
	elsif end_date < start_date
		then raise exception 'дата окончания % меньше даты начала %', end_date, start_date;
	end if;
	select sum(amount)
	from payment 
	where payment_date::date between start_date and end_date into res_amount;
	return res_amount;
end;
$$ language plpgsql

CREATE OR REPLACE FUNCTION public.test_get_contacts(test int4)
 RETURNS TABLE(contact character varying)
 LANGUAGE plpgsql
AS $function$
	begin 
       if test = 1 then
	   return QUERY 
            execute 'select (''Выберите контрагента 1'')::Varchar';
	   else 
	   RETURN QUERY 
            EXECUTE 'select (contact)::varchar from 
		(select concat(last_name,'' '',first_name) as contact,
		last_name,account_id from public.contact
		where account_id = ''44f4a81a-d7ab-405e-b0c2-eb0903a38677''
		order by 2) a';
		end if;
END;
$function$
;
--drop function test_get_contacts2(account uuid)

CREATE OR REPLACE FUNCTION public.test_get_contacts2(uuid)
 RETURNS TABLE(contact character varying)
 LANGUAGE plpgsql
AS $function$
	begin 
       if $1 is null then
	   return QUERY 
            execute 'select (''Выберите контрагента'')::Varchar';
	   else 
	   RETURN QUERY 
            EXECUTE 'select (contacts)::varchar from 
		(select concat(last_name,'' '',first_name) as contacts,
		last_name,account_id from public.contact
		where contact.account_id = $1
		order by 2) a';
		end if;
END;
$function
;

select * from test_get_contacts2('44f4a81a-d7ab-405e-b0c2-eb0903a38677')





create or replace function test_get_contacts3(uuid) returns table (contact varchar) as $$
--declare i record;
begin
	if $1 is null 
		then raise exception 'Одна из дат отсутствует';
	elsif end_date < start_date
		then raise exception 'дата окончания % меньше даты начала %', end_date, start_date;
	end if;
	select sum(amount)
	from payment 
	where payment_date::date between start_date and end_date into res_amount;
	return res_amount;
end;
$$ language plpgsql


create or replace function foo1(uuid) returns table (contact varchar) as $$
begin
	  RETURN QUERY 
            select (contacts)::varchar from 
					(select concat(last_name,' ',first_name) as contacts,
					last_name,account_id from public.contact
					where contact.account_id = $1
					order by 2) a
				union all 
				select 'выбери контакт'
					
					;
	end;
$$ language plpgsql

create or replace function foo4(uuid) returns table (contact varchar) as $$
begin
	  RETURN QUERY 
SELECT CASE 
       WHEN $1 is null -- always false
       THEN (SELECT 'YES'::varchar)
       ELSE (SELECT 'NO'::varchar)
        END;
end;
$$ language plpgsql


select * from foo4('44f4a81a-d7ab-405e-b0c2-eb0903a38677')
select * from foo4(null::uuid)

create or replace function foo2(int) returns table (contact varchar) as $$
begin
	  RETURN QUERY
			select * from (
	  		case 10
				when 10 then select '10'
				when 11 then select '11'
				when 20 then select '20'
				else
			end case) a
	end;
$$ language plpgsql

SELECT
    name,
    CASE WHEN SUM(CASE WHEN playerout = 'out' THEN 1 ELSE 0 END) = 0
        THEN NULL
        ELSE
            SUM(runs)/SUM(CASE WHEN playerout = 'out' THEN 1 ELSE 0 END)
    END AS runs_divided_by_dismissals
FROM players
GROUP BY name;

select * from foo4('44f4a81a-d7ab-405e-b0c2-eb0903a38677')
select * from foo4(null::uuid)

			select (contacts)::varchar from 
					(select concat(last_name,' ',first_name) as contacts,
					last_name,account_id from public.contact
					where contact.account_id = '44f4a81a-d7ab-405e-b0c2-eb0903a38677'
					order by 2) a
				union all 
				SELECT CASE 
				       WHEN 1<2 
				       THEN (SELECT 'Выберите контрагента'::varchar)
				       END;
					
					

--drop function test_get_contacts2(account uuid)

select * from test_get_contacts2('44f4a81a-d7ab-405e-b0c2-eb0903a38677')

-----------------ЗАДАНИЕ № 14

14. На бэкенде реализована функция по получению статистики о заявках на курьера: 
static function get_stat() --получение статистики
    {
        $pdo = Di::pdo();
        $stmt = $pdo->prepare('SELECT * FROM courier_statistic');
        $stmt->execute();
        $data = $stmt->fetchAll();
        return $data;
    }
Нужно реализовать представление courier_statistic, со следующей структурой:
account_id --идентификатор контрагента
account --название контрагента
count_courier --количество заказов на курьера для каждого контрагента
count_complete --количество завершенных заказов для каждого контрагента
count_canceled --количество отмененных заказов для каждого контрагента
percent_relative_prev_month -- процентное изменение количества заказов текущего месяца к предыдущему месяцу для каждого контрагента, если получаете деление на 0, то в результат вывести 0.
count_where_place --количество мест доставки для каждого контрагента
count_contact --количество контактов по контрагенту, которым доставляются документы в текущий момент времени
cansel_user_array --массив с идентификаторами сотрудников, по которым были заказы со статусом "Отменен" для каждого контрагента

CREATE VIEW comedies AS
    SELECT *
    FROM films
    WHERE kind = 'Comedy';

 CREATE VIEW courier_statistic AS


SELECT c.account_id,a."name",count(c.account_id) FROM 
public.courier c 
left join public.account a on c.account_id = a.id  
group by c.account_id,a."name" 


account_id,
account,
count_courier --количество заказов на курьера для каждого контрагента
count_complete --количество завершенных заказов для каждого контрагента
count_canceled --количество отмененных заказов для каждого контрагента
percent_relative_prev_month -- процентное изменение количества заказов текущего месяца к предыдущему месяцу для каждого контрагента, если получаете деление на 0, то в результат вывести 0.
count_where_place --количество мест доставки для каждого контрагента
count_contact --количество контактов по контрагенту, которым доставляются документы в текущий момент времени
cansel_user_array --массив с идентификаторами сотрудников, по которым были заказы со статусом "Отменен" для каждого контрагента






with recursive recrsv as (
	select min(date_trunc('month', created_date)) beg_of_mnth 
	from public.courier c 
		union
	select beg_of_mnth+interval '1 MONTH' 
		as beg_of_mnth from recrsv
	where beg_of_mnth < (select max(date_trunc('month', created_date))
	from public.courier))
select beg_of_mnth::date as "месяц"

from recrsv

left join public.account a on c.account_id = a.id  
group by c.account_id,a."name" 


	
select beg_of_mnth::date as "месяц бронир-я",

coalesce(lft_j_sum.ttl_amount_month, 0) as "этот месяц",

lag(coalesce(lft_j_sum.ttl_amount_month, 0), 1, 0.) over (order by beg_of_mnth) as "прошлый месяц",

(case lag(coalesce(lft_j_sum.ttl_amount_month, 0), 1, 0.) over (order by beg_of_mnth)
					when 0 then 0.0
					else round(100.0*(coalesce(lft_j_sum.ttl_amount_month, 0) -
					lag(coalesce(lft_j_sum.ttl_amount_month, 0), 1, 0.) over (order by beg_of_mnth))
					/lag(coalesce(lft_j_sum.ttl_amount_month, 0), 1, 0.) over (order by beg_of_mnth),2)
					end) 
					
					as "Изм.мес.сум.брон-я, %"
					
					
from recrsv
left join (
	select date_trunc('month', book_date) as month_id , sum(total_amount) as ttl_amount_month
	from bookings 
	group by date_trunc('month', book_date)) lft_j_sum on beg_of_mnth = month_id
order by beg_of_mnth

select date_trunc('month', created_date) as month_id , count(account_id) as zak_count_per_acnt
	from courier c  
	group by date_trunc('month', book_date

	
	
SELECT c.account_id,a."name",count(c.account_id) FROM --кол-во всех по к
public.courier c 
left join public.account a on c.account_id = a.id  
group by c.account_id,a."name"	

SELECT c.account_id,a."name",count(c.account_id) FROM  --колвот отмен по к
public.courier c 
left join public.account a on c.account_id = a.id  
where c.status = 'Отменен'
group by c.account_id,a."name"	

SELECT c.account_id,a."name",count(c.account_id) FROM  --кол-во выполне по к
public.courier c 
left join public.account a on c.account_id = a.id  
where c.status = 'Выполнено'
group by c.account_id,a."name",c.status	


SELECT c.account_id,count(c.where_place) FROM  --кол-во мест по к
public.courier c 
group by c.account_id,c.where_place

SELECT c.account_id,count(c.contact_id) FROM  --кол-во контактов по к
public.courier c 
where c.status = 'Выполняется'
group by c.account_id,c.contact_id

SELECT c.account_id,ARRAY_AGG(u.id) FROM    --id сотр с отменен
public.courier c
left join "user" u on c.user_id = u.id 
where c.status = 'Отменен'
group by c.account_id;

SELECT c.account_id,a."name",count(c.account_id),date_trunc('month', created_date)::date FROM --кол-во всех тек. месяц
public.courier c 
left join public.account a on c.account_id = a.id
where date_trunc('month', created_date) = date_trunc('month', now())
group by c.account_id,a."name",date_trunc('month', created_date)::date	

SELECT c.account_id,a."name",count(c.account_id),date_trunc('month', created_date)::date FROM --кол-во всех пред. месяц
public.courier c 
left join public.account a on c.account_id = a.id
 where (created_date >= date_trunc('month',now() - interval '1 month')
   and created_date <  date_trunc('month',now()))
group by c.account_id,a."name",date_trunc('month', created_date)::date	

select a.model,s.aircraft_code 
from aircrafts a 
join seats s on a.aircraft_code =s.aircraft_code 
group by s.aircraft_code,a.model 
having count(s.seat_no) < 50
order by s.aircraft_code

left join count(c.account_id) FROM 
public.courier c
where status = 'Выполнено'

select * from courier_statistic

select * from courier c 
where c.account_id = '9630f7bc-1ce2-4285-8441-984bc82c9e7e'
order by c.created_date 



create or replace view courier_statistic 
AS
with data0 as
(
    SELECT c.account_id as acc_id,a."name" as acc_name,count(c.account_id) as cnt_all,count(c.where_place) as cnt_place FROM --кол-во всех по к
	public.courier c 
	left join public.account a on c.account_id = a.id  
	group by c.account_id,a."name"
), 
data1 as
(
    SELECT c.account_id as acc_id,count(c.account_id) as cnt_reject FROM  --колвот отмен по к
	public.courier c  
	where c.status = 'Отменен'
	group by c.account_id	
), 
data2 as
(
    SELECT c.account_id as acc_id,count(c.account_id) as cnt_done FROM  --кол-во выполне по к
	public.courier c  
	where c.status = 'Выполнено'
	group by c.account_id
), 
data4 as
(
    SELECT c.account_id as acc_id,count(distinct c.contact_id) as cnt_contact FROM  --количество контактов по контрагенту, которым доставляются документы в текущий момент времени
	public.courier c 
	where c.status = 'Выполняется' 
	group by c.account_id
), 
data5 as
(
    SELECT c.account_id as acc_id,ARRAY_AGG(u.id) as cansel_us_arr FROM    --id сотр с отменен
	public.courier c
	left join "user" u on c.user_id = u.id 
	where c.status = 'Отменен'
	group by c.account_id

), 
data6 as
(
    SELECT c.account_id as acc_id,count(c.account_id) as perc_this_month,
    date_trunc('month', created_date)::date  FROM --кол-во всех тек. месяц
	public.courier c 
	where date_trunc('month', created_date) = date_trunc('month', now())
	group by c.account_id,date_trunc('month', created_date)::date	
), 
data7 as
(
    SELECT c.account_id as acc_id,count(c.account_id) as perc_last_month,
    date_trunc('month', created_date)::date   FROM --кол-во всех пред. месяц
public.courier c 
 where (created_date >= date_trunc('month',now() - interval '1 month')
   and created_date <  date_trunc('month',now()))
group by c.account_id,date_trunc('month', created_date)::date	
)
select slct.acc_id as account_id,
slct.acc_name as account,
slct.cnt_all as count_courier, 
slct.cnt_done as count_complete,
slct.cnt_reject as count_canceled,
(case slct.perc_last_month when 0 then 0.0
else round(100.0*((slct.perc_this_month-slct.perc_last_month)/slct.perc_last_month),1) end) as percent_relative_prev_month,
slct.cnt_place as count_where_place,
slct.cnt_contact as count_contact,
--slct.cansel_us_arr as cansel_user_array,
(case coalesce(array_length(slct.cansel_us_arr::uuid[], 1), 0) when 0 then '{}'
else slct.cansel_us_arr end) as cansel_user_array
from
(select data0.acc_id,
	   data0.acc_name,
	   data0.cnt_all,
	   data0.cnt_place,
	   coalesce(data1.cnt_reject,0) as cnt_reject,
	   coalesce(data2.cnt_done,0) as cnt_done,
	   coalesce(data4.cnt_contact,0) as cnt_contact,
	            data5.cansel_us_arr as cansel_us_arr,	   		   
	   coalesce(data6.perc_this_month,0)::numeric as perc_this_month,
	   coalesce(data7.perc_last_month,0)::numeric as perc_last_month	  
from data0
left join   data1 on data0.acc_id = data1.acc_id
left join   data2 on data1.acc_id = data2.acc_id
left join   data4 on data2.acc_id = data4.acc_id
left join   data5 on data4.acc_id = data5.acc_id
left join   data6 on data5.acc_id = data6.acc_id
left join   data7 on data6.acc_id = data7.acc_id) slct
group by 1,2,3,4,5,6,7,8,9


select * from courier_statistic

DROP VIEW IF EXISTS courier_statistic
--Данные вычисляются по формуле: ((V2-V1)/V1) × 100. Где V1 – старое значение, а V2 – новое.

select user 

select * from courier c 
where account_id = '05e7bcfd-8934-45c2-a03d-2d1250e6f60d'

select * from courier c 
where account_id = '55674a73-6e85-4b08-aaeb-243911d883db'



select * from courier c 
where account_id = '55609e22-b1bb-4053-9b6d-12e9bf9e899c'


SELECT c.account_id as acc_id,count(c.contact_id) as cnt_contact FROM  --количество контактов по контрагенту, которым доставляются документы в текущий момент времени
	public.courier c 
	where c.status = 'Выполняется' and account_id = '55674a73-6e85-4b08-aaeb-243911d883db' 
	group by c.account_id,c.contact_id

SELECT c.account_id as acc_id,count(c.account_id) as cnt_contact FROM  --количество контактов по контрагенту, которым доставляются документы в текущий момент времени
	public.courier c 
	where c.status = 'Выполняется' and account_id = '55674a73-6e85-4b08-aaeb-243911d883db' 
	group by c.account_id
	distinct(c.contact_id),
	

SELECT c.account_id as acc_id,count(distinct c.contact_id) as cnt_contact FROM  --количество контактов по контрагенту, которым доставляются документы в текущий момент времени
	public.courier c 
	where c.status = 'Выполняется' and account_id = '55674a73-6e85-4b08-aaeb-243911d883db' 
	group by c.account_id
	
	
SELECT c.account_id as acc_id,count(c.account_id) as cnt_done FROM  --кол-во выполне по к
	public.courier c  
	where c.status = 'Выполнено' and account_id = '55674a73-6e85-4b08-aaeb-243911d883db' 
	group by c.account_id	
	
