--https://lovelysujeong.tistory.com
--/entry/oracle-scott-%EA%B3%84%EC%A0%95-%EC%97%B0%EC%8A%B5-%EB%AC%B8%EC%A0%9C

select *
from emp;

select *
from dept;

--Oracle : scott ���� ���� ����
--1) EMP�� DEPT TABLE�� JOIN�Ͽ� �μ� ��ȣ, �μ���, �̸�, �޿��� ����϶�.

select d.DEPTNO, d.DNAME, e.ename, e.sal
from emp e, dept d
where E.DEPTNO = D.DEPTNO;

--2) �̸��� 'ALLEN'�� ����� �μ����� ����϶�.

select d.DNAME
from emp e, dept d
where E.DEPTNO = D.DEPTNO AND e.ENAME = 'ALLEN';

--3) DEPT Table�� �ִ� ��� �μ��� ����ϰ�, EMP Table�� �ִ� DATA�� JOIN�Ͽ� 
--   ��� ����� �̸�, �μ���ȣ, �μ���, �޿��� ����϶�.

select  e.ename, d.DNAME,d.DEPTNO, e.sal
from emp e, dept d
where E.DEPTNO(+) = D.DEPTNO;

--4) EMP Table�� �ִ� EMPNO�� MGR�� �̿��Ͽ� ������ ���踦 ������ ���� ����϶�.
--SMITH�� �Ŵ����� FORD�̴�.

SELECT e.ename ||'�� �Ŵ�����'||mgr.ename||'�̴�.' manager
FROM emp e, emp mgr
where e.mgr = mgr.empno ANd e.ename = 'SMITH';

--5)'ALLEN'�� ������ ���� ����� �̸�, �μ���, �޿�, ������ ����϶�.

SELECT e.ename, d.dname, e.sal, e.job
FROM emp e, dept d
where e.deptno = d.deptno AND e.job = (select job from emp where emp.ename = 'ALLEN');

--6)'JONES'�� �����ִ� �μ��� ��� ����� �����ȣ, �̸�, �Ի���, �޿��� ����϶�.

SELECT empno, ename, hiredate, SAL
FROM emp 
where deptno = (select DEPTNO from emp where ename = 'JONES');

--7)��ü ����� ����ӱݺ��� ���� ����� �����ȣ, �̸�, �μ���, �Ի���, ����, �޿��� ����϶�.
SELECT e. empno, e.ENAME, d.dname, e.HIREDATE, d.LOC, e.SAL
FROM emp e, dept d
where e.deptno = d.deptno AND sal > (select AVG(SAL) from emp);

--8)10�� �μ��� ������߿��� 20�� �μ��� ����� ���� ������ �ϴ� ����� 
--�����ȣ, �̸�, �μ���, �Ի���, ������ ����϶�.
select e.deptno, e.ename, d.DNAME, e.HIREDATE, d.LOC 
from emp e, dept d 
where e.deptno = d.deptno AND e.deptno = 10 
AND e.job IN (select job from emp where deptno = 20);

--9)10�� �μ� �߿��� 30�� �μ����� ���� �ӹ��� �ϴ� ����� 
--�����ȣ, �̸�, �μ���, �Ի���, ������ ����϶�.
select e.deptno, e.ename, d.DNAME, e.HIREDATE, d.LOC 
from emp e, dept d 
where e.deptno = d.deptno AND e.deptno = 10 
AND e.job NOT IN (select job from emp where deptno = 30);

--10)10�� �μ��� ���� ���� �ϴ� ����� 
--�����ȣ, �̸�, �μ���, ����, �޿��� �޿��� ���� ������ ����϶�.
select e.deptno, e.ename, d.DNAME, d.LOC, e.sal 
from emp e, dept d 
where e.deptno = d.deptno AND e.deptno != 10
AND e.job IN (select job from emp where deptno = 10)
ORDER BY e.sal DESC;

