--emp ���̺�, dept ���̺� ����
--4
SELECT *
FROM  dept;

UPDATE dept SET dname = 'MARKET SALES'
WHERE deptno != '30';

SELECT ename, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.deptno=30;

SELECT ename, deptno
FROM emp;

SELECT deptno, dname
FROM dept;


--natural join : ���� ���̺� ���� Ÿ��, �����̸��� �÷�����
--               ���� ���� ���� ��� ����
DESC emp;
DESC dept;

--ANSI SQL
SELECT deptno, a.empno, ename
FROM emp a NATURAL JOIN dept b;

--oracle ����
SELECT a.deptno, empno, ename
FROM emp a, dept b
WHERE a.deptno = b.deptno;

--JOIN USING 
--join �Ϸ����ϴ� ���̺� ������ �̸��� �÷��� �ΰ� �̻��� ��
--join �÷��� �ϳ��� ����ϰ� ���� ��

--ANSI SQL
SELECT *
FROM emp JOIN dept USING (deptno);

--ORACLE SQL
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--ANSI JOIN with ON
--���� �ϰ��� �ϴ� ���̺��� �÷� �̸��� �ٸ� ��
--�����ڰ� ���� ������ ���� ������ ��

SELECT *
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

--oracle
select emp.deptno, empno, ename
from emp, dept
where emp.deptno = dept.deptno;

--SELF JOIN : 
--emp ���̺� ���� �Ҹ��� ���� : ������ ������ ���� ��ȸ
--������ ������ ������ ��ȸ
--�����̸�, �������̸�

--ANSI 

select e.ename, m.ename, w.ename 
from emp e JOIN emp m ON(e.mgr = m.empno);


--ORACLE
--���� �̸�, ������ ����� �̸�, ������ ������� ����� �̸�, ������ �������� �������� ������ �̸�
select e.ename, m.ename, w.ename, k.ename
from emp e, emp m, emp w, emp k
where e.mgr = m.empno
AND m.mgr = w.empno
AND w.mgr = k.empno;          


--���� ���̺��� ANSI JOIN�� �̿��� JOIN
SELECT e.ename, m.ename, w.ename, k.ename
FROM emp e JOIN emp m ON(e.mgr = m.empno)
        JOIN emp w ON(m.mgr = w.empno)
        JOIN emp k ON(w.mgr = k.empno);
              
--������ �̸���, �ش� ������ ������ �̸��� ��ȸ�Ѵ�.
--�� ������ ����� 7369~7698�� ������ ������� ��ȸ
SELECT e.ename, m.ename
FROM emp e, emp m
WHERE e.empno between 7369 and 7698
AND e.mgr = m.empno;

select e.ename, m.ename
from emp e JOIN emp m ON(e.mgr = m.empno)
where e.empno BETWEEN 7369 and 7698;

--NON-EQUI JOIN : ���� ������ =(equal)�� �ƴ� JOIN
-- != , BETWWEN AND

select *
from salgrade;

select empno, ename, sal, salgrade.GRADE  /* �޿� grade */
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
select empno, ename, emp.deptno, dname
from emp, dept
where emp.deptno = dept.deptno AND (emp.deptno = 10 OR emp.deptno = 30)
ORDER BY emp.deptno;

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


