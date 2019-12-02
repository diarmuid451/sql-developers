--https://lovelysujeong.tistory.com
--/entry/oracle-scott-%EA%B3%84%EC%A0%95-%EC%97%B0%EC%8A%B5-%EB%AC%B8%EC%A0%9C

select *
from emp;

select *
from dept;

--Oracle : scott 계정 연습 문제
--1) EMP와 DEPT TABLE을 JOIN하여 부서 번호, 부서명, 이름, 급여를 출력하라.

select d.DEPTNO, d.DNAME, e.ename, e.sal
from emp e, dept d
where E.DEPTNO = D.DEPTNO;

--2) 이름이 'ALLEN'인 사원의 부서명을 출력하라.

select d.DNAME
from emp e, dept d
where E.DEPTNO = D.DEPTNO AND e.ENAME = 'ALLEN';

--3) DEPT Table에 있는 모든 부서를 출력하고, EMP Table에 있는 DATA와 JOIN하여 
--   모든 사원의 이름, 부서번호, 부서명, 급여를 출력하라.

select  e.ename, d.DNAME,d.DEPTNO, e.sal
from emp e, dept d
where E.DEPTNO(+) = D.DEPTNO;

--4) EMP Table에 있는 EMPNO와 MGR을 이용하여 서로의 관계를 다음과 같이 출력하라.
--SMITH의 매니저는 FORD이다.

SELECT e.ename ||'의 매니저는'||mgr.ename||'이다.' manager
FROM emp e, emp mgr
where e.mgr = mgr.empno ANd e.ename = 'SMITH';

--5)'ALLEN'의 직무와 같은 사람의 이름, 부서명, 급여, 직무를 출력하라.

SELECT e.ename, d.dname, e.sal, e.job
FROM emp e, dept d
where e.deptno = d.deptno AND e.job = (select job from emp where emp.ename = 'ALLEN');

--6)'JONES'가 속해있는 부서의 모든 사람의 사원번호, 이름, 입사일, 급여를 출력하라.

SELECT empno, ename, hiredate, SAL
FROM emp 
where deptno = (select DEPTNO from emp where ename = 'JONES');

--7)전체 사원의 평균임금보다 많은 사원의 사원번호, 이름, 부서명, 입사일, 지역, 급여를 출력하라.
SELECT e. empno, e.ENAME, d.dname, e.HIREDATE, d.LOC, e.SAL
FROM emp e, dept d
where e.deptno = d.deptno AND sal > (select AVG(SAL) from emp);

--8)10번 부서의 사람들중에서 20번 부서의 사원과 같은 업무를 하는 사원의 
--사원번호, 이름, 부서명, 입사일, 지역을 출력하라.
select e.deptno, e.ename, d.DNAME, e.HIREDATE, d.LOC 
from emp e, dept d 
where e.deptno = d.deptno AND e.deptno = 10 
AND e.job IN (select job from emp where deptno = 20);

--9)10번 부서 중에서 30번 부서에는 없는 임무를 하는 사원의 
--사원번호, 이름, 부서명, 입사일, 지역을 출력하라.
select e.deptno, e.ename, d.DNAME, e.HIREDATE, d.LOC 
from emp e, dept d 
where e.deptno = d.deptno AND e.deptno = 10 
AND e.job NOT IN (select job from emp where deptno = 30);

--10)10번 부서와 같은 일을 하는 사원의 
--사원번호, 이름, 부서명, 지역, 급여를 급여가 많은 순으로 출력하라.
select e.deptno, e.ename, d.DNAME, d.LOC, e.sal 
from emp e, dept d 
where e.deptno = d.deptno AND e.deptno != 10
AND e.job IN (select job from emp where deptno = 10)
ORDER BY e.sal DESC;

