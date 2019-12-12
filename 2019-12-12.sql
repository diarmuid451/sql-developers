--실습 idx3
--1번째
explain plan for
select *
from emp_test
where empno = :empno;

--2번째
explain plan for
select *
from emp_test
where ename = :ename;

--3번째
explain plan for
select *
from emp_test, dept_test
where emp_test.deptno = dept_test.deptno
AND emp_test.deptno = :deptno
AND emp_test.empno LIKE :empno || '%';

--4번째
explain plan for
select *
from emp_test
where sal between :st_sal and :ed_sal
AND deptno = :deptno;

--5번째
explain plan for
select B.*
from emp_test A, emp_test B
where A.mgr = B.empno
AND A.deptno = :deptno;

--6번쨰
explain plan for
select deptno, TO_CHAR(hiredate, 'yyyymm'),COUNT(*) cnt
from emp_test
group by deptno, TO_CHAR(hiredate, 'yyyymm');

create index idx3_emp_01 on emp_test (empno,mgr,deptno,sal,hiredate); --나머지
create index idx3_emp_02 on emp_test (ename); --2번
create unique index idx3_emp_03 on emp_test (empno); --1번 

select * from table(dbms_xplan.display);
drop index idx3_emp_03;

--별칭 : 테이블, 컬럼을 다른 이름으로 지칭
--[AS] 별칭명
--select empno [AS] eno from emp e

--SYNONYM(동의어)
--오라클 객체를 다른 이름으로 부를 수 있도록 하는 것
--만일 emp 테이블을 e라고 하는 snynonym으로 생성 한다면 다음과 같은 sql을 작성 할 수 있다.
--select * from e;

--CREATE SYNONYM name FOR Object;
--유저 계정에 sysnonym 생성 권한을 부여
grant create synonym to PC01; 
--emp 테이블을 사용하여 synonym e를 생성 
create synonym e for emp;

--emp라는 테이블 명 대신에 e라고 하는 시노님을 사용하여 쿼리를 작성 할 수 있다.
select * from e;

--유저 계정의 fastfood 테이블을 hr 계정에서도 볼 수 있도록 테이블 조회 권한 부여
grant select on fastfood to hr;

select * from fastfood;

--동일한 SQL의 개념에 따르면 아래 SQL들은 다르다
SELECT /* 201911_205 */ * FROM emp;
SELECT /* 201911_205 */* FROM EMP;
SELECt /* 201911_205 */* FROM EMP;

SELECT /* 201911_205 */* FROM EMP WHERE empno = 7369;
SELECT /* 201911_205 */* FROM EMP WHERE empno = 7499;
SELECT /* 201911_205 */* FROM EMP WHERE empno = :empno;

--multiple insert
--emp 테이블의 empno, ename 컬럼으로 emp_test, emp_test2 테이블을 생성
--(CTAS, 데이터도 같이 복사)
create table emp_test as 
select empno, ename 
from emp;

create table emp_test2 as 
select empno, ename 
from emp;

--unconditional insert
--여러 테이블에 데이터를 동시에 입력
insert all into emp_test into emp_test2
select 9999, 'brown' from dual union all
select 9998, 'cony' from dual;

--테이블 별 입력되는 데이터의 컬럼을 제어 가능
insert all into emp_test(empno, ename) values (eno, enm) 
        into emp_test2 (empno) values (eno)
select 9999 eno, 'brown' enm from dual union all
select 9998, 'cony' from dual;

/* case
     when 조건 then  //if
     when 조건 then  //else if
     else           //else 
*/    
--conditional insert
--조건에 따라 테이블에 데이터를 입력
insert all 
        when eno > 9000 then 
            into emp_test (empno, ename) values (eno, enm)
        when eno > 9500 then
            into emp_test (empno, ename) values (eno, enm)
        else 
            into emp_test2 (empno) values (eno)
select 9999 eno, 'brown' enm from dual union all
select 8888, 'cony' from dual;
            
rollback;

insert first
        when eno > 9500 then 
            into emp_test (empno, ename) values (eno, enm)
        when eno > 9000 then
            into emp_test (empno) values (enm)
        else 
            into emp_test2 (empno) values (eno)
select 9000 eno, 'brown' enm from dual union all
select 8888, 'cony' from dual;

select * from emp_test where empno > 9000 union all
select * from emp_test2 where empno > 8000;
rollback;