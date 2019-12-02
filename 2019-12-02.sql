
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
--(row 9 -France, Denmark, Belgium 3�� ������ ���ϴ� locations ������ ������)
--������ 5���߿� �ټ��� location ������ ���� �ִ� ������ �����Ѵ�
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


--OUTER JOIN : ���� ���ῡ ���� �ϴ��� ������ �Ǵ� ���̺��� ����Ʈ�� �������� �ϴ� ����
--LEFT OUTER JOIN : ���̺�1 LEFT OUTER JOIN ���̺�2
--���̺�1�� ���̺�2�� ������ �� ���ο� �����ϴ��� ���̺�1���� �����ʹ� ��ȸ�� �ǵ��� �Ѵ�.
--���ο� ������ �࿡�� ���̺�2�� �÷����� �������� �����Ƿ� NULL�� ǥ�õȴ�.

select e.empno, e.ename, m.empno, m.ename
from emp e LEFT OUTER JOIN emp m  ON(e.mgr = m.empno);

select e.empno, e.ename, m.empno, m.ename
from emp e JOIN emp m  ON(e.mgr = m.empno);

--ANSI SQL
--���� LEFT OUTER JOIN �Ŵ��� ON (����)
select e.empno, e.ename, m.empno, m.ename, m.deptno
from emp e LEFT OUTER JOIN emp m  ON(e.mgr = m.empno AND m.deptno = 10);

select e.empno, e.ename, m.empno, m.ename, m.deptno
from emp e LEFT OUTER JOIN emp m  ON(e.mgr = m.empno)
where m.deptno = 10;


--ORACLE OUTER JOIN SYNTAX
--�Ϲ� ���ΰ� �������� �÷��� (+) ǥ��
--(+)ǥ�� : �����Ͱ� �������� �ʴµ� ���;� �ϴ� ���̺��� �÷�
--ORACLE OUTER
--WHERE ����.�Ŵ�����ȣ  = �Ŵ���.������ȣ(+) - �Ŵ����� �����Ͱ� �������� ����

select e.empno, e.ename, m.empno, m.ename
from emp e, emp m  
where e.mgr = m.empno(+);

--�Ŵ��� �μ���ȣ ����
--ANSI SQL WHERE ���� ����� ���� --> OUTER JOIN�� ������� ���� ��Ȳ
--OUTER JOIN�� ����Ǿ�� �ϴ� ��� �÷��� (+)�� �پ�� �ȴ�.
select e.empno, e.ename, m.empno, m.ename
from emp e, emp m  
where e.mgr = m.empno(+)
AND m.deptno = 10;

select e.empno, e.ename, m.empno, m.ename
from emp e, emp m  
where e.mgr = m.empno(+)
AND m.deptno(+)  = 10;

--emp ���̺��� 14���� ������ �ְ� 14���� 10, 20, 30�μ��߿� �� �μ��� ���Ѵ�.
--������ dept���̺��� 10, 20, 30, 40�� �μ��� ����

--�μ���ȣ, �μ���, �ش� �μ��� ���� �������� �������� ������ �ۼ�


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


--���⼺�� ����

select e.empno, e.ename, m.empno, m.ename
from emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno);

select e.empno, e.ename, m.empno, m.ename
from emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno)
order by e.empno;

--FULL OUTER : LEFT OUTER + RIGHT OUTER - �ߺ������ʹ� �� �Ǹ� �����
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