--DDL ( index �ǽ� idx3 )
-- �ý��ۿ��� ����ϴ� ������ ������ ���ٰ� �� �� ������ emp ���̺�
-- �ʿ��ϴٰ� �����Ǵ� �ε����� ���� ��ũ��Ʈ�� ����� ������.

--1��°
--�ذ� CREATE INDEX idx3_emp_01 ON emp_test (empno, deptno);
EXPLAIN PLAN FOR
SELECT *
FROM emp_test
WHERE empno = :empno;


--2��°
--CREATE INDEX idx3_emp_02 ON emp_test (ename);
EXPLAIN PLAN FOR
SELECT *
FROM emp_test
WHERE ename = :ename;


--3��°
--�ذ� CREATE INDEX idx3_emp_01 ON emp_test (empno, deptno);
EXPLAIN PLAN FOR
SELECT *
FROM emp_test, dept_test
WHERE emp_test.deptno = dept_test.deptno
AND emp_test.deptno = :deptno
AND emp_test.empno LIKE :empno || '%';


--4��°
EXPLAIN PLAN FOR
SELECT *
FROM emp_test
WHERE sal BETWEEN :st_sal AND :ed_sal
AND deptno = :deptno;


--5��°
EXPLAIN PLAN FOR
SELECT B.*
FROM emp_test A, emp_test B
WHERE A.mgr = B.empno
AND A.deptno = :deptno;


--6��°
EXPLAIN PLAN FOR
SELECT deptno, TO_CHAR(hiredate, 'yyyymm'), COUNT(*) cnt
FROM emp_test
GROUP BY deptno, TO_CHAR(hiredate, 'yyyymm');





SELECT * FROM TABLE(dbms_xplan.display);



DROP INDEX idx3_emp_01;
DROP INDEX idx3_emp_02;
DROP INDEX idx3_emp_03;


CREATE INDEX idx3_emp_01 ON emp_test (empno, mgr, deptno); --1��, 3��, 5�� �ε���
CREATE INDEX idx3_emp_02 ON emp_test (ename); --2�� �ε���
CREATE INDEX idx3_emp_03 ON emp_test (deptno, sal); --4�� �ε���