--task1  (lesson8)
-- oracle: https://leetcode.com/problems/department-top-three-salaries/

with a as (
select DepartmentId, Name, Salary, dense_rank() over (partition by DepartmentId order by Salary desc) as rank
from Employee)

select d.Name as "Department", a.Name as "Employee", a.Salary as "Salary"
from a 
join Department d on a.DepartmentId = d.Id
where a.rank < 4

--task2  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/17

select fm.member_name, fm.status, 
sum(p.amount*p.unit_price) as costs 
from Payments p
left join FamilyMembers fm 
on fm.member_id = p.family_member
where year(p.date) = '2005'
group by p.family_member

--task3  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/13
select name from Passenger
group by name
having count(name) > 1

--task4  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38
select COUNT(first_name) as count
from Student
where first_name LIKE 'Anna'

--task5  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/35
select COUNT(classroom) as count
from Schedule
where DATE(date) = '2019-09-02' 

--task6  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38
-- дубль
--task7  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/32
select FLOOR(AVG(TIMESTAMPDIFF(year, birthday, CURDATE()))) as age
from FamilyMembers

--task8  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/27
with types as(select * from GoodTypes gt join Goods g
on gt.good_type_id = g.type
)

select t.good_type_name, SUM(p.unit_price*p.amount) as costs
from types t join Payments p
on t.good_id = p.good
where YEAR(date) = '2005'
group by t.good_type_name

--task9  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/37
select MIN(TIMESTAMPDIFF(year, birthday, CURDATE())) as year
from Student

--task10  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/44
with age_stud as (select class, student, birthday, s.id 
from Student s join Student_in_class sc 
on s.id = sc.student)

select MAX(TIMESTAMPDIFF(year, birthday, CURDATE())) as max_year
from age_stud a1 join Class c on a1.class = c.id
where c.name LIKE '10%'

--task11 (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/20
with types as(select * from GoodTypes gt join Goods g
on gt.good_type_id = g.type
join Payments p on g.good_id = p.good
)

select status, member_name, (amount*unit_price) as costs
from types t join FamilyMembers fm
on t.family_member = fm.member_id
where good_type_name = 'entertainment'

--task12  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/55
with trips as(select company , count(Trip.id) as count 
FROM Trip
group by company)


delete from Company
where name in (select name from trips t join Company c on t.company = c.id
where count = (select min(count) from trips t join Company c on t.company = c.id))

--task13  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/45
with room as (select count(id) as count, classroom
from Schedule
group by classroom)

select classroom
from room
where count = (select max(count) from room)

--task14  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/43
with prepod as (select last_name, name
from Teacher t join Schedule sh on t.id = sh.teacher
join Subject s on sh.subject = s.id)

select last_name
from prepod
where name = 'Physical Culture'
order by last_name

--task15  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/63
select CONCAT_WS('.', last_name, left(first_name,1), left(middle_name,1))as name
from Student
order by last_name, first_name, middle_name 
--выдает все равно как неверный ответ, не понимаю как еще отсортировать, пробовала просто по фамилии, и фамилия+имя