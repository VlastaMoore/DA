--task1  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem
select
case
when grades.grade >= 8 then students.name
when grades.grade < 8 then 'NULL'
end AS name, grades.grade, students.marks
from students
left join grades
on students.marks >= min_mark and students.marks <= max_mark
order by grades.grade DESC, students.name ASC, students.marks ASC;

--task2  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/occupations/problem
select min(Doctor), min(Professor), min(Singer), min(Actor)
from (select
row_number() over (partition by Occupation order by Name) rn, 
case when Occupation = 'Doctor' then Name
end as Doctor,
case when Occupation = 'Professor' then Name
end as Professor,
case when Occupation = 'Singer' then Name
end as Singer,
case when Occupation = 'Actor' then Name
end as Actor
from Occupations
order by Name) a
group by rn
order by rn;

--task3  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-9/problem
select distinct(city) 
from station 
where (city not like 'A%' and city not like 'E%' and city not like 'I%' and city not like 'O%' and city not like 'U%');

--task4  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-10/problem
select distinct(city) 
from station 
where (city not like '%a' and city not like '%e' and city not like '%i' and city not like '%o' and city not like '%u');

--task5  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-11/problem
select distinct(city) 
from station 
where (city not like 'A%' and city not like 'E%' and city not like 'I%' and city not like 'O%' and city not like 'U%')
or (city not like '%a' and city not like '%e' and city not like '%i' and city not like '%o' and city not like '%u');
--task6  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-12/problem
select distinct(city) 
from station 
where (city not like 'A%' and city not like 'E%' and city not like 'I%' and city not like 'O%' and city not like 'U%' 
and city not like '%a' and city not like '%e' and city not like '%i' and city not like '%o' and city not like '%u');
--task7  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/salary-of-employees/problem
select name 
from employee
where salary > 2000 
and months < 10
order by employee_id asc;

--task8  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem
-- дубль
