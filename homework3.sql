--task13 (lesson3)
--Компьютерная фирма: Вывести список всех продуктов и производителя с указанием типа продукта (pc, printer, laptop). Вывести: model, maker, type

with all_products as 
   (select model,price
    from pc   
    union all 
    select model,price from printer   
    union all 
    select model,price from laptop)

select all_products.model, maker, type
from all_products join product 
on all_products.model = product.model


--task14 (lesson3)
--Компьютерная фирма: При выводе всех значений из таблицы printer дополнительно вывести для тех, у кого цена вышей средней PC - "1", у остальных - "0"

select *,
case when price > (select avg(price) from pc) then 1
else 0
end flag
from printer

--task15 (lesson3)
--Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL)
 
with all_ships as( 
    select ship from outcomes
    union
    select name from ships)
    
 select ship, class
 from ships right join all_ships 
 on ships.name = all_ships.ship
 where class is null
  

 --task16 (lesson3)
--Корабли: Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду.
 
 with only_year as
 (select date_part('year', date) as date, name
 from battles)
 
 select name 
 from only_year 
 where (date) not in (select launched from ships)

--task17 (lesson3)
--Корабли: Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.
 
 select battle
 from ships join outcomes out
 on ships.name = out.ship
 where class = 'Kongo'

--task1  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_300) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше > 300. Во view три колонки: model, price, flag

create view all_products_flag_300 as 
with all_products  as 
(select model,price
from pc   
union all 
select model,price from printer   
union all 
select model,price from laptop)

select model, price,
 case when price > 300 then 1  
 else 0 
 end flag 
from all_products 

--task2  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_avg_price) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше cредней . Во view три колонки: model, price, flag

create view all_products_flag_avg_price as 
with all_products  as 
(select model,price
from pc   
union all 
select model,price from printer   
union all 
select model,price from laptop)

select model, price,
 case when price > (select avg(price) from all_products) then 1  
 else 0 
 end flag 
from all_products 

--task3  (lesson4)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model
with d_c_avg as(
    select avg(price) as price
    from product p join printer p1 
    on p.model = p1.model
    where maker = 'D' or maker = 'C')
    
 select p.model
 from product p join printer p1 
 on p.model = p1.model
 where maker = 'A' and price > (select price from d_c_avg)

--task4 (lesson4)
-- Компьютерная фирма: Вывести все товары производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model
-- дубль 

 --task5 (lesson4)
-- Компьютерная фирма: Какая средняя цена среди уникальных продуктов производителя = 'A' (printer & laptop & pc)

 with all_products  as 
  (select model,price
   from pc p  
   union 
   select model,price from printer p2  
   union
   select model,price from laptop)
   
select avg(price)
 from product p join all_products 
 on p.model = all_products.model
 where maker = 'A'
 
--task6 (lesson4)
-- Компьютерная фирма: Сделать view с количеством товаров (название count_products_by_makers) по каждому производителю. Во view: maker, count
 
 create view count_products_by_makers as 
with all_products  as 
   (select model,price
    from pc   
    union all
    select model,price from printer   
    union all
    select model,price from laptop)

select count(all_products.model), maker
from all_products join product p
on all_products.model = p.model
group by maker
 

--task7 (lesson4)
-- По предыдущему view (count_products_by_makers) сделать график в colab (X: maker, y: count)

request = """
with all_products  as 
   (select model,price
    from pc   
    union all
    select model,price from printer   
    union all
    select model,price from laptop)

select count(all_products.model), maker
from all_products join product p
on all_products.model = p.model
group by maker
"""
df = pd.read_sql_query(request, conn)
fig = px.bar(x=df.maker.to_list(), y=df['count'].to_list(), labels={'x':'maker', 'y':'count'})
fig.show()

--task8 (lesson4)
-- Компьютерная фирма: Сделать копию таблицы printer (название printer_updated) и удалить из нее все принтеры производителя 'D'

create table printer_updated as table printer;

delete from printer_updated
where model  in (select p.model
from printer_updated pu join product p on pu.model = p.model
where maker = 'D')

--task9 (lesson4)
-- Компьютерная фирма: Сделать на базе таблицы (printer_updated) view с дополнительной колонкой производителя (название printer_updated_with_makers)
create view printer_updated_with_makers as 
select pu.*, p.maker
from printer_updated pu join product p on pu.model = p.model

--task10 (lesson4)
-- Корабли: Сделать view c количеством потопленных кораблей и классом корабля (название sunk_ships_by_classes). Во view: count, class (если значения класса нет/IS NULL, то заменить на 0)

create view sunk_ships_by_classes as
select count(c.ship), class as classs
from (select b.*, out.result from (select ship, coalesce(class, '0') as class
   from ships right join (
    select ship from outcomes
    union
    select name from ships) a
    on ships.name = a.ship) b join outcomes out on b.ship = out.ship
    ) c 
    where result = 'sunk' 
    group by class

--task11 (lesson4)
-- Корабли: По предыдущему view (sunk_ships_by_classes) сделать график в colab (X: class, Y: count)
-- как я поняла, python распознает class в "x=df.class.to_list()" не как названиее колонки(кавычки не помогли), а как призыв к действию, поэтому в запросе немного подкорректировала название    
    request = """
select count(c.ship), class as classs
from (select b.*, out.result from (select ship, coalesce(class, '0') as class
   from ships right join (
    select ship from outcomes
    union
    select name from ships) a
    on ships.name = a.ship) b join outcomes out on b.ship = out.ship
    ) c 
    where result = 'sunk' 
    group by class
"""
df = pd.read_sql_query(request, conn)
fig = px.bar(x=df.classs.to_list(), y=df['count'].to_list(), labels={'x':'class', 'y':'count'})
fig.show()

--task12 (lesson4)
-- Корабли: Сделать копию таблицы classes (название classes_with_flag) и добавить в нее flag: если количество орудий больше или равно 9 - то 1, иначе 0

create table classes_with_flag as table classes;

select *,
case when numGuns >= 9 then 1
else 0
end flag
from classes_with_flag

--task13 (lesson4)
-- Корабли: Сделать график в colab по таблице classes с количеством классов по странам (X: country, Y: count)

request = """
select count(class), country
from classes 
group by country
"""
df = pd.read_sql_query(request, conn)
fig = px.bar(x=df.country.to_list(), y=df['count'].to_list(), labels={'x':'country', 'y':'count'})
fig.show()

--task14 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название начинается с буквы "O" или "M".
with all_ships as(
     select name from ships
     union
     select ship from outcomes)
     
 select count(name)
 from all_ships
 where name like 'O%' or name like 'M%'

 --task15 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название состоит из двух слов.
 with all_ships as(
     select name from ships
     union
     select ship from outcomes)
     
 select count(name)
 from all_ships
 where name like '% %'

--task16 (lesson4)
-- Корабли: Построить график с количеством запущенных на воду кораблей и годом запуска (X: year, Y: count)
 
 request = """
select count(name), launched as year
 from ships 
 group by launched
"""
df = pd.read_sql_query(request, conn)
fig = px.bar(x=df.year.to_list(), y=df['count'].to_list(), labels={'x':'year', 'y':'count'})
fig.show()