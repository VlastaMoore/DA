
-- 1. Корабли: Для каждого класса определите число кораблей этого класса, потопленных в сражениях. Вывести: класс и число потопленных кораблей.
with count_ships as (
    select name, class
    from ships
    )
    
 select count(ship), class
 from count_ships
 join outcomes out
 on count_ships.name = out.ship
 where result = 'sunk'
 group by class
 
 
 -- 2. Корабли: Для каждого класса определите год, когда был спущен на воду первый корабль этого класса. Если год спуска на воду головного корабля неизвестен, определите минимальный год спуска на воду кораблей этого класса. Вывести: класс, год.
 
 select min(launched), ships.class
 from ships join classes c on ships.class = c.class
 group by ships.class
 
 -- 3. Корабли: Для классов, имеющих потери в виде потопленных кораблей и не менее 3 кораблей в базе данных, вывести имя класса и число потопленных кораблей.

select *
  from (select *, 
             case when count >= 3 then 1 else 0 end as cou                     
                     from (select count(name), class
                     from (select *                   
                     from ships join outcomes out on ships.name = out.ship) a
                     where result = 'sunk'
             group by class ) a1
        ) a2 
 where cou = 1
        

-- 4. Корабли: Найдите названия кораблей, имеющих наибольшее число орудий среди всех кораблей такого же водоизмещения (учесть корабли из таблицы Outcomes).

 -- Оооочень долго мучалась над проблемой -  присвоить название классу по имени корабля, где у нас class is null, в итоге пошла самым простым и очевидным путем:
-- создать другую таблицу. Пыталась через update в процессе самой выборки, но DBeaver меня всячески изругал. 

 create table all_ships as (select *
   from ships right join (
    select ship from outcomes
    union
    select name from ships) a
    on ships.name = a.ship
    )
    
update all_ships set class = ship
where class is null
 
alter table all_ships drop column name
 
 
select distinct on ("displacement") ship, numguns, displacement
from all_ships al join classes c on al.class = c.class
order by displacement, numguns desc

 
-- 5. Компьютерная фирма: Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM и с самым быстрым процессором среди всех ПК, имеющих наименьший объем RAM. Вывести: Maker

with pc_p_m as (select * from pc join product p 
on pc.model = p.model 
where (maker) in (select maker 
                  from (select count(type), maker
                  from (select distinct type, maker
                  from (select model from pc 
                        union
                        select model from printer p) a
                 join product p1 on a.model = p1.model
                        ) b 
       group by maker
                      ) c
  where count = 2) and ram = (select min(ram) from  pc join product p 
  on pc.model = p.model))

select maker from pc_p_m
where speed = (select max(speed) from pc_p_m)



select *
from product p join pc on p.model = pc.model 



select 
from outcomes

select *
from classes

select *
from ships

select *
from battles