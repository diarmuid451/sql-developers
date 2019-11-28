select emp.deptno, empno, ename
from emp, dept
where emp.deptno = dept.deptno;

--SELF JOIN : 
--emp 테이블간 조인 할만한 사항 : 직원의 관리자 정보 조회
--직원의 관리자 정보를 조회
--직원이름, 관리자이름

--ANSI 

select e.ename, m.ename, w.ename 
from emp e JOIN emp m ON(e.mgr = m.empno);


--ORACLE
--직원 이름, 직원의 상급자 이름, 직원의 상급자의 상급자 이름, 직원의 관리자의 관리자의 관리자 이름
select e.ename, m.ename, w.ename, k.ename
from emp e, emp m, emp w, emp k
where e.mgr = m.empno
AND m.mgr = w.empno
AND w.mgr = k.empno;          


--여러 테이블을 ANSI JOIN을 이용한 JOIN
SELECT e.ename, m.ename, w.ename, k.ename
FROM emp e JOIN emp m ON(e.mgr = m.empno)
        JOIN emp w ON(m.mgr = w.empno)
        JOIN emp k ON(w.mgr = k.empno);
              
--직원의 이름과, 해당 직원의 관리자 이름을 조회한다.
--단 직원의 사번이 7369~7698인 직원을 대상으로 조회
SELECT e.ename, m.ename
FROM emp e, emp m
WHERE e.empno between 7369 and 7698
AND e.mgr = m.empno;

select e.ename, m.ename
from emp e JOIN emp m ON(e.mgr = m.empno)
where e.empno BETWEEN 7369 and 7698;

--NON-EQUI JOIN : 조인 조건이 =(equal)이 아닌 JOIN
-- != , BETWWEN AND

select *
from salgrade;

select empno, ename, sal, salgrade.GRADE  /* 급여 grade */
from emp, salgrade
where emp.sal BETWEEN salgrade.losal AND salgrade.hisal;

select empno, ename, sal, grade
from emp JOIN salgrade ON emp.sal
BETWEEN salgrade.losal AND salgrade.hisal;

--join0
select *
from emp;
select *
from dept;

select empno, ename, emp.deptno, dname
from emp, dept
where emp.deptno = dept.deptno
ORDER BY emp.deptno;

select empno, ename, emp.deptno, dname
from emp JOIN dept ON (emp.deptno = dept.deptno)
ORDER BY emp.deptno;


--join0_1
select a.empno, a.ename, a.deptno, a.dname
from 
(select empno, ename, emp.deptno, dname
from emp, dept
where emp.deptno = dept.deptno
ORDER BY emp.deptno)a 
where a.deptno = 10 OR a.deptno = 30;

select empno, ename, emp.deptno, dname
from emp JOIN dept ON (emp.deptno = dept.deptno)
where emp.deptno = 10 OR emp.deptno = 30 
ORDER BY emp.deptno;

--join0_2
select empno, ename, sal, emp.deptno, dname
from emp JOIN dept ON (emp.deptno = dept.deptno)
where emp.sal > 2500 
ORDER BY emp.deptno;

select empno, ename,sal, emp.deptno, dname
from emp, dept
where emp.deptno = dept.deptno AND sal > 2500
ORDER BY emp.deptno;


--join0_3
select empno, ename, sal, emp.deptno, dname
from emp JOIN dept ON (emp.deptno = dept.deptno)
where emp.sal > 2500 AND empno > 7600
ORDER BY emp.deptno;

select empno, ename,sal, emp.deptno, dname
from emp, dept
where emp.deptno = dept.deptno AND sal > 2500 AND empno > 7600
ORDER BY emp.deptno;

--join0_4
select empno, ename, sal, emp.deptno, dname
from emp JOIN dept ON (emp.deptno = dept.deptno)
where emp.sal > 2500 AND empno > 7600 AND dname = 'RESEARCH'
ORDER BY emp.deptno;

select empno, ename,sal, emp.deptno, dname
from emp, dept
where emp.deptno = dept.deptno AND sal > 2500 AND empno > 7600 AND dname = 'RESEARCH'
ORDER BY emp.deptno;