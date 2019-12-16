--실습 idx4
select * from emp where empno = :empno;

select * from dept where deptno = :deptno;

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
























explain plan for
select * from table(dbms_xplan.display);
drop index idx4_emp_01;