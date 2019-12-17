--실습 idx4
explain plan for
select * from emp_test where empno = :empno;


select * from dept_test where deptno = :deptno;

explain plan for
select * from emp,dept 
where emp.deptno = dept.deptno
AND emp.deptno = :deptno
and emp.deptno like :deptno || '%';

select * from emp where sal between :st_sal and :ed_sal
and deptno = :deptno;

select * from emp, dept
where emp.deptno = dept.deptno
and emp.deptno = :deptno
and dept.loc = :loc;



CREATE INDEX idx4_emp_01 ON emp(empno, deptno);
CREATE INDEX idx4_emp_02 ON dept(deptno);
CREATE INDEX idx4_emp_03 ON emp(empno, mgr, deptno);

DROP INDEX idx4_emp_01;
DROP INDEX idx4_emp_02;
DROP INDEX idx4_emp_03;


select * from table(dbms_xplan.display);