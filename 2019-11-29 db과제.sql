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

