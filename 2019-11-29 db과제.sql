--join8

select *
from countries;

select * 
from regions;

select *
from locations;

select regions.region_id, regions.REGION_NAME, countries.COUNTRY_NAME
from countries  JOIN regions ON(regions.region_id = countries.region_id)
where regions.REGION_ID = 1;

--join9
select regions.REGION_ID, regions.REGION_NAME, countries.COUNTRY_NAME, locations.CITY
from countries JOIN regions ON(REGIONS.REGION_ID = countries.region_id) 
                JOIN locations ON(countries.COUNTRY_ID = locations.country_id)
where regions.REGION_ID = 1;

--join10
select r.REGION_ID, r.REGION_NAME, c.COUNTRY_NAME, l.CITY, d.DEPARTMENT_NAME
from countries c, regions r, locations l, departments d
where r.REGION_ID = c.REGION_ID AND c.COUNTRY_ID = l.country_id 
    AND l.LOCATION_ID = d.LOCATION_ID AND r.REGION_ID = 1;


--join11
select *
from employees;

select r.REGION_ID, r.REGION_NAME, c.COUNTRY_NAME, l.CITY, d.DEPARTMENT_NAME, 
CONCAT(e.FIRST_NAME,e.LAST_NAME) name
from countries c, regions r, locations l, departments d, EMPLOYEES e
where r.REGION_ID = c.REGION_ID AND c.COUNTRY_ID = l.country_id 
    AND l.LOCATION_ID = d.LOCATION_ID AND d.DEPARTMENT_ID = e.department_id ANd r.REGION_ID = 1
ORDER BY l.location_id;

--join12
select e.EMPLOYEE_ID, CONCAT(e.FIRST_NAME,e.LAST_NAME) name, e.job_id, j.JOB_TITLE
from employees e JOIN jobs j ON(e.job_id = j.job_id);

--join13
select *
from EMPLOYEES;

