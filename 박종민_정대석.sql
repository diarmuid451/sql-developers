--DDL ( index 실습 idx3 )
-- 시스템에서 사용하는 쿼리가 다음과 같다고 할 때 적절한 emp 테이블에
-- 필요하다고 생각되는 인덱스를 생성 스크립트를 만들어 보세요.

--1번째
--해결 CREATE INDEX idx3_emp_01 ON emp_test (empno, deptno);
EXPLAIN PLAN FOR
SELECT *
FROM emp_test
WHERE empno = :empno;


--2번째
--CREATE INDEX idx3_emp_02 ON emp_test (ename);
EXPLAIN PLAN FOR
SELECT *
FROM emp_test
WHERE ename = :ename;


--3번째
--해결 CREATE INDEX idx3_emp_01 ON emp_test (empno, deptno);
EXPLAIN PLAN FOR
SELECT *
FROM emp_test, dept_test
WHERE emp_test.deptno = dept_test.deptno
AND emp_test.deptno = :deptno
AND emp_test.empno LIKE :empno || '%';


--4번째
EXPLAIN PLAN FOR
SELECT *
FROM emp_test
WHERE sal BETWEEN :st_sal AND :ed_sal
AND deptno = :deptno;


--5번째
EXPLAIN PLAN FOR
SELECT B.*
FROM emp_test A, emp_test B
WHERE A.mgr = B.empno
AND A.deptno = :deptno;


--6번째
EXPLAIN PLAN FOR
SELECT deptno, TO_CHAR(hiredate, 'yyyymm'), COUNT(*) cnt
FROM emp_test
GROUP BY deptno, TO_CHAR(hiredate, 'yyyymm');





SELECT * FROM TABLE(dbms_xplan.display);



DROP INDEX idx3_emp_01;
DROP INDEX idx3_emp_02;
DROP INDEX idx3_emp_03;


CREATE INDEX idx3_emp_01 ON emp_test (empno, mgr, deptno); --1번, 3번, 5번 인덱스
CREATE INDEX idx3_emp_02 ON emp_test (ename); --2번 인덱스
CREATE INDEX idx3_emp_03 ON emp_test (deptno, sal); --4번 인덱스