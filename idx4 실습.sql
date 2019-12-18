--실습 idx4
explain plan for
select * from emp_test where empno = :empno;

explain plan for
select * from dept_test where deptno = :deptno;

explain plan for
select * from emp_test,dept_test 
where emp_test.deptno = dept_test.deptno
AND emp_test.deptno = :deptno
and emp_test.deptno like :deptno || '%';

explain plan for
select * from emp_test where sal between :st_sal and :ed_sal
and deptno = :deptno;

explain plan for
select * from emp_test, dept_test
where emp_test.deptno = dept_test.deptno
and emp_test.deptno = :deptno
and dept_test.loc = :loc;



CREATE INDEX idx4_emp_01 ON emp_test(empno, deptno);
CREATE INDEX idx4_emp_02 ON dept_test(deptno,loc);
CREATE INDEX idx4_emp_03 ON emp_test(sal,deptno);

DROP INDEX idx4_emp_01;
DROP INDEX idx4_emp_02;
DROP INDEX idx4_emp_03;


select * from table(dbms_xplan.display);