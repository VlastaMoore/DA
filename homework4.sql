--task1 (lesson5)
-- Компьютерная фирма: Сделать view (pages_all_products), в которой будет постраничная разбивка всех продуктов (не более двух продуктов на одной странице). Вывод: все данные из laptop, номер страницы, список всех страниц

sample:
1 1
2 1
1 2
2 2
1 3
2 3


select *, 
case when rn % 2 = 0 then rn / 2 else rn / 2 + 1 end  as page_num, 
case when rn % 2 = 0 then 2 else 1 end as position
from (
  select *, row_number(*) over (order by price desc) as rn
  from laptop 
) a

--task2 (lesson5)
-- Компьютерная фирма: Сделать view (distribution_by_type), в рамках которого будет процентное соотношение всех товаров по типу устройства. Вывод: производитель, тип, процент (%)

create view distribution_by_type as
with a_p as (select count(type), maker, type from ( select * from
(select price, model  from pc
union all
select price, model  from printer
union all
select price, model  from laptop) al
join product p on al.model = p.model) ab
group by maker, type 
order by maker) 

select count, maker, type as typpe,
cast (count as dec(5,3)) / (select max(rn) from (select *, row_number(*) over () as rn
  from(select * from (select price, model  from pc
                      union all
                      select price, model  from printer
                      union all
                      select price, model  from laptop) al
       join product p on al.model = p.model) c ) d ) * 100 as percent
from a_p


--task3 (lesson5)
-- Компьютерная фирма: Сделать на базе предыдущенр view график - круговую диаграмму. Пример https://plotly.com/python/histograms/

import psycopg2
import pandas as pd

from IPython.display import HTML
import plotly.express as px
from matplotlib import pyplot as plt

DB_HOST = '178.170.196.15'
DB_USER = 'student0'
DB_USER_PASSWORD = 'student21_password'
DB_NAME = 'sql_ex_for_student21'

conn = psycopg2.connect(host=DB_HOST, user=DB_USER, password=DB_USER_PASSWORD, dbname=DB_NAME)

request = """
with a_p as (select count(type), maker, type from ( select * from
(select price, model  from pc
union all
select price, model  from printer
union all
select price, model  from laptop) al
join product p on al.model = p.model) ab
group by maker, type 
order by maker) 

select count, maker, type as typpe,
cast (count as dec(5,3)) / (select max(rn) from (select *, row_number(*) over () as rn
  from(select * from (select price, model  from pc
union all
select price, model  from printer
union all
select price, model  from laptop) al
join product p on al.model = p.model) c ) d ) * 100 as percent
from a_p
"""

df = pd.read_sql_query(request, conn)
df['t_and_m'] = df['typpe'].astype(str) + "_" + df['maker'].astype(str).str.zfill(1)
explode = (0, 0.05, 0.05, 0, 0.1, 0.30, 0.15, 0.15, 0.15)
fig, ax = plt.subplots()
ax.pie(df.percent.to_list(), labels=df.t_and_m.to_list(), autopct='%1.1f%%', shadow=True, explode=explode, wedgeprops={'lw':1, 'ls':'--','edgecolor':"k"}, rotatelabels=True)
ax.axis("equal")

--task4 (lesson5)
-- Корабли: Сделать копию таблицы ships (ships_two_words), но название корабля должно состоять из двух слов
 
create table ships_two_words as
 select name
 from ships
 where name like '% %'
 
--task5 (lesson5)
-- Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL) и название начинается с буквы "S"

with all_ships as( 
    select ship from outcomes
    union
    select name from ships)
    
 select ship, class
 from ships right join all_ships 
 on ships.name = all_ships.ship
 where class is null and ship like 'S%'

--task6 (lesson5)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'C' и тpи самых дорогих (через оконные функции). Вывести model
-- поскольку maker = 'C' не производит принтеры, запрос пуст (если поменять производителя все ок )
 
 select model,
 case when maker = 'A' and price > (select avg(price) from (select price from printer p
 join product p1 on p.model = p1.model where maker = 'C') d) then 1 else 0 end as more_then_avgC
 from (select *,
     row_number() over (order by price desc) rn
     from (select price, maker, p.model 
           from printer p
           join product p1 on p.model = p1.model) a ) b
where rn = 1 or rn = 2 or rn = 3 
 

 
 
 