--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1  (lesson7)
-- sqlite3: Сделать тестовый проект с БД (sqlite3, project name: task1_7). В таблицу table1 записать 1000 строк с случайными значениями (3 колонки, тип int) от 0 до 1000.
-- Далее построить гистаграмму распределения этих трех колонко
import sqlite3
import pandas as pd
import psycopg2

conn_sqlite = sqlite3.connect('table1')  
DB_HOST = '178.170.196.15'
DB_USER = 'student21'
DB_USER_PASSWORD = 'student21_password'
DB_NAME = 'sql_ex_for_student21'

conn = psycopg2.connect(host=DB_HOST, user=DB_USER, password=DB_USER_PASSWORD, dbname=DB_NAME)
cur = conn.cursor()

request = """CREATE TABLE IF NOT EXISTS table1(
                                          col1 int,
                                          col2 int,
                                          col3 int);
            """
cur.execute(request)
conn.commit()

try:
    cur.execute("INSERT INTO table1 (col1, col2, col3) select random()*1000, random()*1000, random()*1000 from generate_series(0, 999)")
except Exception: 
  pass
conn.commit()

import matplotlib.pyplot as plt 
import seaborn as sns 

sqlite_select_query = """SELECT * from table1"""
cur.execute(sqlite_select_query)
tb = cur.fetchall()
df = pd.DataFrame(tb, columns =["col1", "col2","col3"])
features = ['col1', 'col2', 'col3']
df[features].hist(figsize=(10, 4), bins=60);


--task2  (lesson7)
-- oracle: https://leetcode.com/problems/duplicate-emails/
select email
from Person
group by email
having count(email) > = 2

--task3  (lesson7)
-- oracle: https://leetcode.com/problems/employees-earning-more-than-their-managers/

select name as employee from employee e
where e.salary > (select salary from employee where id = e.managerId)

--task4  (lesson7)
-- oracle: https://leetcode.com/problems/rank-scores/
select score,
dense_rank() over (order by score desc) rank
from Scores

--task5  (lesson7)
-- oracle: https://leetcode.com/problems/combine-two-tables/
select firstName, lastName, city, state
from Person p
left join Address ad on p.personId = ad.personId