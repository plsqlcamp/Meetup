--
--Exemplo Simples
--
select first_name, 
       salary, 
       sum(salary) over( ) soma
from hr.employees e
where e.department_id = 90
order by first_name;
--Exemplo Simples Incrementado
select first_name, 
       salary, 
       sum(salary) 
          over( 
             order by first_name 
             rows between 1 preceding 
                      and 1 following ) soma
from hr.employees e
where e.department_id = 90
order by first_name;

--
--Adicionando um ranqueamento
--
SELECT department_id, 
       first_name, 
       salary, 
       rank() over(PARTITION BY department_id ORDER BY salary DESC) salary_rank, 
       dense_rank() over(PARTITION BY department_id ORDER BY salary DESC) salary_dense_rank, 
       row_number() over(PARTITION BY department_id ORDER BY salary DESC) salary_row_number 
FROM   hr.employees 
WHERE  department_id = 50 
and salary between 3500 and 4000;
--Descobrindo a posição de um registro em um ranque
SELECT rank(3550) WITHIN GROUP(ORDER BY salary DESC) salary_rank, 
       dense_rank(3550) WITHIN GROUP( ORDER BY salary DESC) salary_dense_rank  
FROM   hr.employees  
WHERE  department_id = 50  
and salary between 3500 and 4000;

--
--Lista agregada
--
SELECT DISTINCT e.department_id,  
                listagg(e.first_name, '; ' ) within GROUP(ORDER BY e.first_name) over(PARTITION BY e.department_id) employees 
FROM   hr.employees e  
ORDER  BY e.department_id;
--Lista agregada incrementada
SELECT distinct event_id, 
       listagg(athlete_game_id || '(' || medal || ')', '; ')  
       within GROUP(ORDER BY athlete_game_id)  
       over(PARTITION BY event_id) 
FROM   olym.olym_medals 
where event_id = 317 
ORDER  BY 2 DESC
--Lista agregada incrementada ++
SELECT distinct event_id, 
       listagg(athlete_game_id || '(' || medal || ')', '; ' ON OVERFLOW TRUNCATE '...' WITHOUT COUNT)   
       within GROUP(ORDER BY athlete_game_id)   
       over(PARTITION BY event_id)Medals 
FROM   olym.olym_medals 
where event_id = 317 
ORDER  BY 2 DESC
--Desfazer um Listagg
SELECT regexp_substr(medals, '[^;]+', 1, LEVEL) Medal 
FROM   ( 
--
SELECT distinct event_id,  
       listagg(athlete_game_id || '(' || medal || ')', '; ' ON OVERFLOW TRUNCATE '...' WITHOUT COUNT)    
       within GROUP(ORDER BY athlete_game_id)    
       over(PARTITION BY event_id)Medals  
FROM   olym.olym_medals  
where event_id = 317  
ORDER  BY 2 DESC 
 --        
        ) 
CONNECT BY regexp_substr(medals, '[^;]+', 1, LEVEL) IS NOT NULL
--
--Acessar registros anteriores e/ou posteriores
--
SELECT department_id, 
       salary, 
       COUNT(*) qtd_employees, 
       lag(salary, 1, 0)      over(PARTITION BY department_id ORDER BY department_id, salary)           as prev_salary, 
       lead(salary, 1, 0)     over(PARTITION BY department_id ORDER BY department_id, salary)           as next_salary, 
       (lead(salary, 1, null) over(PARTITION BY department_id ORDER BY department_id, salary) - salary) as next_sal_dif 
FROM   hr.employees 
GROUP  BY department_id, 
          salary 
ORDER  BY department_id, 
          salary ;
--
--Acumular valores
--
WITH orders_data AS 
 (SELECT c.customer_id, 
         c.cust_first_name || ' ' || c.cust_last_name cust_full_name, 
         o.order_total, 
         SUM(o.order_total) over(PARTITION BY c.customer_id ORDER BY c.customer_id, o.order_date) accumulated_customer, 
         SUM(o.order_total) over(ORDER BY c.customer_id, o.order_date) accumulated_total, 
          
         COUNT(o.order_total) over(PARTITION BY c.customer_id ORDER BY c.customer_id, o.order_date) qtd_customer, 
         COUNT(o.order_total) over(ORDER BY c.customer_id, o.order_date) qtd_total 
  FROM   oe.customers c, 
         oe.orders    o 
  WHERE  o.customer_id = c.customer_id 
  ORDER  BY c.customer_id, 
            o.order_date) 
SELECT * 
FROM   orders_data 
WHERE  accumulated_total <= 250000 
AND    qtd_total <= 5 ;