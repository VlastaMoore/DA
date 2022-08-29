-- Задание 1: Вывести name, class по кораблям, выпущенным после 1920
select name, class
from ships
where launched > 1920

-- Задание 2: Вывести name, class по кораблям, выпущенным после 1920, но не позднее 1942
select name, class
from ships
where launched > 1920 and launched < 1942

-- Задание 3: Какое количество кораблей в каждом классе. Вывести количество и class
select count(ships), ships.class
from ships
join classes c
on ships.class = c.class
group by ships.class

-- Задание 4: Для классов кораблей, калибр орудий которых не менее 16, укажите класс и страну. (таблица classes)
select class, country
from classes 
where bore >= 16

-- Задание 5: Укажите корабли, потопленные в сражениях в Северной Атлантике (таблица Outcomes, North Atlantic). Вывод: ship.
select ship
from outcomes 
where battle = 'North Atlantic' and result = 'sunk' 

-- Задание 6: Вывести название (ship) последнего потопленного корабля
select ship
from outcomes
join battles b
on outcomes.battle = b.name
where date = (select max(date) from battles where result = 'sunk') 
-- Полагаю, что результат пустой, поскольку в таблице battles, присутсвуют значения битвы #Cuba62b, у которой нет значений в других колонках, но она является самой последней битвой
-- Если искать первый потопленный корабль, то все получается =)                                                                    
-- Но поскольку мы знаем, дату, которая у нас ни с чем не агрегируется, можем сделать такой запрос
select ship
from outcomes
join battles b
on outcomes.battle = b.name
where date = (select max(date) from battles where result = 'sunk' and DATE < '1962-10-20') -- Есть еще #Cuba62a, на 5 дней пораньше.

-- Задание 7: Вывести название корабля (ship) и класс (class) последнего потопленного корабля
with last_sunk_ships as (
    select ship
    from outcomes join battles b on outcomes.battle = b.name
    where date = (select max(date) from battles where result = 'sunk' and DATE < '1962-10-20')
   )

select name, ships.class
from ships join classes c on ships.class = c.class
join last_sunk_ships lss on lss.ship = ships.name
-- Подкорректировала после 3 занятия через with. Результат пустой, поскольку в таблице Ships нет искомых кораблей, собственно мы не можем задать им класс
-- Если полагать, что с корабль цел или  поврежден, все работает, но опять же, только с теми кораблями для которых задан класс.
   

-- Задание 8: Вывести все потопленные корабли, у которых калибр орудий не менее 16, и которые потоплены. Вывод: ship, class
select name, ships.class
from ships join classes c on ships.class = c.class
join outcomes on outcomes.ship = ships.name
where result = 'sunk' and bore >= 16
-- К калибру мы можем обратиться только через классы, а не для всех кораблей перечислен класс, поэтому в результате не имеем ничего

-- Задание 9: Вывести все классы кораблей, выпущенные США (таблица classes, country = 'USA'). Вывод: class
select class
from classes
where country = 'USA'

-- Задание 10: Вывести все корабли, выпущенные США (таблица classes & ships, country = 'USA'). Вывод: name, class
select name, c.class
from ships
join classes c 
on ships.class = c.class
where country = 'USA'


select *
from outcomes

select *
from classes

select *
from ships

select *
from battles

