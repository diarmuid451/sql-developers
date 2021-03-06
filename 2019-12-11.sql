--INDEX만 조회하여 사용자의 요구사항에 만족하는 데이터를 만들어 낼 수 있는 경우
--emp 테이블의 모든 컬럼을 조회
explain plan for
select *
from emp
where empno = 7782;

select * from table(dbms_xplan.display);

--emp 테이블의 empno컬럼을 조회
explain plan for
select empno
from emp
where empno = 7782;

select * from table(dbms_xplan.display); --INDEX UNIQUE SCAN

--기존인덱스 제거(pk_emp 제약 조건 삭제 >>unique 제약 삭제 >>pk_emp 인덱스 삭제)
--INDEX 종류(컬럼 중복 여부)
--UNIQUE INDEX : 인덱스 컬럼의 값이 종복될 수 없는 인덱스(ex : emp.empno, dept.deptno)
--NON-UNIQUE INDEX : 인덱스 컬럼의 값이 중복될 수 있는 인덱스 >> default
alter table emp drop constraint pk_emp;

--create unique index idx_n_emp_01 on emp(empno);
create index idx_n_emp_01 on emp(empno);

--UNIQUE >> NON-UNIQUE 인덱스로 변경됨
explain plan for
select *
from emp
where empno = 7782;


select * from table(dbms_xplan.display); --INDEX RANGE SCAN
insert into emp (empno,ename) values (7782,'brown');
insert into emp (empno,ename) values (7782,'nimo');
insert into dept values (99,'ddit2','daejeon');
insert into dept values (98,'ddit','seoul');

select *
from user_constraints
where table_name = 'EMP';

--dept 테이블에는 pk_dept
--pk_dept : deptno
select *
from dept;

--emp 테이블에 job 컬럼으로 non-unique 인덱스 생성
--인덱스명 : idx_n_emp_02
create index idx_n_emp_02 on emp (job);

select job, rowid
from emp
order by job;

--emp 테이블에는 인덱스가 2개 존재 (1.empno  2. job)
--하나의 인덱스로 여러개의 쿼리를 커버할 수 있는 하는게 실력
select *
from emp
where empno = '7369';

select *
from emp
where job = 'MANAGER';

--idx_n_emp_02 인덱스
explain plan for
select *
from emp
where job = 'MANAGER' AND ename like 'C%';

--idx_n_emp_03 인덱스
--emp 테이블의 job, ename컬럼으로 non-unique 인덱스 생성
create index idx_n_emp_03 on emp(job, ename);

explain plan for
select *
from emp
where job = 'MANAGER' AND ename like 'C%';

explain plan for
select *
from emp
where job = 'MANAGER' AND ename like '%C%';

--idx_n_emp_04 인덱스
--ename, job 컬럼으로 emp 테이블에 non-unique 인덱스 생성
--컬럼 순서도 인덱스 읽기 속도에 영향
create index idx_n_emp_04 on emp(ename, job);

select ename, job, rowid
from emp
where ename = 'brown'
order by ename;

explain plan for
select *
from emp
where  job = 'MANAGER' AND ename LIKE '%C%';

--JOIN 쿼리에서의 인덱스
--emp 테이블은 empno컬럼으로 PRIMARY KEY 제약조건이 존재
alter table emp add constraint pk_emp primary key (empno);
--dept 테이블은 deptno컬럼으로 PRIMARY KEY 제약조건이 존재
explain plan for
select ename, dname, LOC
from emp, dept
where emp.deptno = dept.deptno
AND emp.empno = 7788;


--실습idx1
create table dept_test as 
select *
from dept where 1=1;

create unique index idx_u_dt_01 on dept_test(deptno); --dept컬럼 기준 unique 인덱스
create index idx_n_dt_02 on dept_test(dname); --dname 컬럼 기준 non-unique 인덱스
create index idx_n_dt_03 on dept_test(deptno, dname); --deptno, dname 컬럼 기준 non-unique 인덱스

--실습 idx2
drop index idx_u_dt_01;
drop index idx_n_dt_02;
drop index idx_n_dt_03;


delete emp where ename = 'brown';
commit;
rollback;                                                                                                                                                     
select * from table(dbms_xplan.display); 