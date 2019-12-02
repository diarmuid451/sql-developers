
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
--(row 9 -France, Denmark, Belgium 3개 국가에 속하는 locations 정보는 미존재)
--나머지 5개중에 다수의 location 정보를 갖고 있는 국가가 존재한다
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
e.FIRST_NAME || ' ' || e.LAST_NAME name
from countries c, regions r, locations l, departments d, EMPLOYEES e
where r.REGION_ID = c.REGION_ID AND c.COUNTRY_ID = l.country_id 
    AND l.LOCATION_ID = d.LOCATION_ID AND d.DEPARTMENT_ID = e.department_id ANd r.REGION_ID = 1
ORDER BY l.location_id;

--join12
select e.EMPLOYEE_ID, CONCAT(e.FIRST_NAME,e.LAST_NAME) name, e.job_id, j.JOB_TITLE
from employees e JOIN jobs j ON(e.job_id = j.job_id);

--join13
select *
from jobs;

select mgr.employee_id mng_id, mgr.FIRST_NAME || mgr.last_name mgr_name, e.EMPLOYEE_ID, 
e.FIRST_NAME || e.LAST_NAME name, j.job_id, j.job_title
from jobs j, employees e, employees mgr
where j.job_id = e.job_id AND e.manager_id = mgr.employee_id;


--OUTER JOIN : 조인 연결에 실패 하더라도 기준이 되는 테이블의 데이트는 나오도록 하는 조인
--LEFT OUTER JOIN : 테이블1 LEFT OUTER JOIN 테이블2
--테이블1과 테이블2를 조인할 때 조인에 실패하더라도 테이블1쪽의 데이터는 조회가 되도록 한다.
--조인에 실패한 행에서 테이블2의 컬럼값은 존재하지 않으므로 NULL로 표시된다.

select e.empno, e.ename, m.empno, m.ename
from emp e LEFT OUTER JOIN emp m  ON(e.mgr = m.empno);

select e.empno, e.ename, m.empno, m.ename
from emp e JOIN emp m  ON(e.mgr = m.empno);

--ANSI SQL
--직원 LEFT OUTER JOIN 매니저 ON (조건)
select e.empno, e.ename, m.empno, m.ename, m.deptno
from emp e LEFT OUTER JOIN emp m  ON(e.mgr = m.empno AND m.deptno = 10);

select e.empno, e.ename, m.empno, m.ename, m.deptno
from emp e LEFT OUTER JOIN emp m  ON(e.mgr = m.empno)
where m.deptno = 10;


--ORACLE OUTER JOIN SYNTAX
--일반 조인과 차이점은 컬럼명에 (+) 표시
--(+)표시 : 데이터가 존재하지 않는데 나와야 하는 테이블의 컬럼
--ORACLE OUTER
--WHERE 직원.매니저번호  = 매니저.직원번호(+) - 매니저쪽 데이터가 존재하지 않음

select e.empno, e.ename, m.empno, m.ename
from emp e, emp m  
where e.mgr = m.empno(+);

--매니저 부서번호 제한
--ANSI SQL WHERE 절에 기술한 형태 --> OUTER JOIN이 적용되지 않은 상황
--OUTER JOIN이 적용되어야 하는 모든 컬럼에 (+)가 붙어야 된다.
select e.empno, e.ename, m.empno, m.ename
from emp e, emp m  
where e.mgr = m.empno(+)
AND m.deptno = 10;

select e.empno, e.ename, m.empno, m.ename
from emp e, emp m  
where e.mgr = m.empno(+)
AND m.deptno(+)  = 10;

--emp 테이블에는 14명의 직원이 있고 14명은 10, 20, 30부서중에 한 부서에 속한다.
--하지만 dept테이블에는 10, 20, 30, 40번 부서가 존재

--부서번호, 부서명, 해당 부서에 속한 직원수가 나오도록 쿼리를 작성


select d.deptno, d.dname, count(e.deptno) cnt
from emp e, dept d
where d.deptno = e.deptno(+)
group by d.deptno, d.dname
order by d.deptno;

select d.deptno, d.dname, count(e.deptno) cnt
from dept d LEFT OUTER JOIN emp e ON(e.deptno = d.deptno)   
group by d.deptno, d.dname
order by d.deptno; 

SELECT dept.deptno, dept.dname, NVL(emp_cnt.cnt, 0) cnt
FROM dept, (SELECT deptno, COUNT(*) cnt FROM emp GROUP BY deptno) emp_cnt
WHERE dept.deptno = emp_cnt.deptno(+);

SELECT dept.deptno, dept.dname, NVL(emp_cnt.cnt, 0) cnt
FROM dept LEFT OUTER JOIN (SELECT deptno, COUNT(*) cnt FROM emp GROUP BY deptno) emp_cnt
ON dept.deptno = emp_cnt.deptno;


--방향성을 따짐

select e.empno, e.ename, m.empno, m.ename
from emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno);

select e.empno, e.ename, m.empno, m.ename
from emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno)
order by e.empno;

--FULL OUTER : LEFT OUTER + RIGHT OUTER - 중복데이터는 한 건만 남기기
select e.empno, e.ename, m.empno, m.ename
from emp e FULL OUTER JOIN emp m ON (e.mgr = m.empno)
order by e.empno;


--outerjoin 1
select *
from buyprod;

select TO_CHAR(b.buy_date, 'YY/MM/DD') BUY_DATE,b.buy_prod, b.BUY_QTY
from buyprod b
WHERE b.buy_date = '2005-01-25';

select a.BUY_DATE, a.buy_prod, p.prod_id, p.prod_name, a.BUY_QTY
from (select TO_CHAR(b.buy_date, 'YY/MM/DD') BUY_DATE,b.buy_prod, b.BUY_QTY
from buyprod b
WHERE b.buy_date = '2005-01-25') a RIGHT OUTER JOIN prod p ON ( a.buy_prod = p.prod_id);

select b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
from buyprod b RIGHT OUTER JOIN prod p ON(b.buy_prod = p.prod_id AND b.buy_date = '2005-01-25');




--outerjoin 2
select NVL(a.BUY_DATE,'05/01/25'), a.buy_prod, p.prod_id, p.prod_name, a.BUY_QTY
from (select TO_CHAR(b.buy_date, 'YY/MM/DD') BUY_DATE,b.buy_prod, b.BUY_QTY
from buyprod b
WHERE b.buy_date = '2005-01-25') a RIGHT OUTER JOIN prod p ON ( a.buy_prod = p.prod_id);


--outerjoin 3
select NVL(a.BUY_DATE,'05/01/25'), a.buy_prod, p.prod_id, p.prod_name, NVL(a.BUY_QTY,0)
from (select TO_CHAR(b.buy_date, 'YY/MM/DD') BUY_DATE,b.buy_prod, b.BUY_QTY
from buyprod b
WHERE b.buy_date = '2005-01-25') a RIGHT OUTER JOIN prod p ON ( a.buy_prod = p.prod_id);


--outerjoin 4
select *
from cycle;

select *
from product;


select p.pid,   p.PNM, NVL(c.CID, 1) cid, NVL(c.DAY, 0) day, NVL(c.CNT,0) cnt
from product p LEFT OUTER JOIN cycle c ON(p.pid = c.PID AND c.cid =1);

--outerjoin 5
select p.pid,   p.PNM, NVL(c.CID, 1) cid, NVL(c.DAY, 0) day, NVL(c.CNT,0) cnt
from product p LEFT OUTER JOIN cycle c ON(p.pid = c.PID AND c.cid =1);