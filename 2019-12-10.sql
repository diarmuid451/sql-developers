--제약조건 활성화 / 비활성화
--ALTER TABLE 테이블명 ENABLE OR DISABLE CONSTRAINT 제약조건명

select *
from USER_constraints
where table_name = 'DEPT_TEST';

alter table dept_test disable constraint sys_c007112;
alter table dept_test disable constraint idx_u_dept_test;

select * from dept_test;
insert into dept_test values (99, 'ddit','daejeon');
insert into dept_test values (99, 'DDIT','DaeJeon');

--dept_test 테이블의 primary key 제약조건 활성화
--이미 위에서 실행한 두개의 INSERT 구문에 의해 같은 부서번호를 가지는 
--데이터가 존재하기 때문에 pk 조건 활성화가 안됨
--활성화 하려면 중복데이터를 삭제
alter table dept_test enable constraint sys_c007112;

--부서번호가 pk
select deptno, count(*)
from dept_test
group by deptno
having count(*) >= 2;

--table_name,constraint_name, column_name
--position 정렬 (ASC)
select * from user_constraints 
where table_name = 'BUYER';

select * from user_cons_columns
where table_name = 'BUYER';

--주석(comments)
--COMMENT ON TABLE 테이블명 IS '주석';
--COMMENT ON COLUMN 테이블명.컬럼명 IS '주석';
select * from user_tab_comments;

select * from user_col_comments
where table_name = 'DEPT';

comment on column dept.deptno is '부서번호';
comment on column dept.dname is '부서명';
comment on column dept.loc is '부서위치지역';

--실습 comment1
select * from user_tab_comments;
select * from user_col_comments;

select a.table_name, a.table_type, a.comments tab_comment,b.column_name,b.comments col_comment
from user_tab_comments a,user_col_comments b
where a.table_name IN ('CUSTOMER','PRODUCT','CYCLE','DAILY') AND a.table_name = b.table_name
group by a.table_name, a.table_type , a.comments ,b.column_name , b.comments
order by table_name;

--VIEW : QUERY이다 / 테이블이 아니다.
--테이블처럼 데이터가 물리적으로 존재하는 것이 아니다. 논리적 데이터 셋 = QUERY

--VIEW 생성
--CREATE OR REPLACE VIEW 뷰이름 [(컬럼별칭1, 컬럼별칭2...)] AS
--SUBQUERY

--emp테이블에서 sal, comm컬럼을 제외한 나머지 6개 컬럼만 조회가 되는 view, v_emp이름으로 생성

create or replace view v_emp as
select empno, ename, job, mgr, hiredate, deptno
from emp;

select * from v_emp;

--SYSTEM 계정에서 작업
--VIEW 생성 권한을 유저 계정에 부여
GRANT CREATE VIEW TO PC01;

--INLINE VIEW
select * from (select empno, ename, job, mgr, hiredate, deptno
from emp);

--emp테이블을 수정하면 view에 영향이 있을까?
--KING의 부서번호가 현재 10번, emp테이블의 KING의 부서번호를 30으로 수정
--v_emp 테이블에서 KING의 부서번호를 관찰

select *
from emp;

--update emp set deptno = 30 where ename = 'KING';

create or replace view v_emp_dept as
select emp.empno, emp.ename, dept.DEPTNO, dept.dname
from emp , dept where emp.deptno = dept.deptno;

select * from v_emp_dept;


--emp테이블에서 KING데이터 삭제
--delete emp where ename = 'KING';

--INLINE VIEW
select *
from (select emp.empno, emp.ename, dept.DEPTNO, dept.dname
from emp , dept where emp.deptno = dept.deptno);

--emp테이블의 empno컬럼을 eno로 변경
ALTER TABLE emp rename column empno to eno;
ALTER TABLE emp rename column eno to empno;

--veiw 삭제
--v_emp 삭제
drop view v_emp;

--부서별 직원의 급여 합계
create or replace view v_emp_sal as
SELECT deptno, sum(sal) sum_sal
FROM EMP 
group by deptno;


select * from (SELECT deptno, sum(sal) sum_sal 
FROM EMP group by deptno) where deptno = 20;

select ROWNUM,deptno, sum_sal from v_emp_sal;

--SEQUENCE
--오라클 객체로 중복되지 않는 정수 값을 리턴해주는 객체
--CREATE SEQUENCE 시퀀스명 [옵션...] //갱신이 안됨

CREATE sequence seq_board;

--시퀀스 사용방법 : 시퀀스명.nextval
select SEQ_BOARD.NEXTVAL
from dual;  --rollback 되지 않고 그대로 진행

select to_char(sysdate, 'yyyymmdd') ||'-'||seq_board.nextval
from dual;

select rowid, rownum, emp.* from emp;

--emp 테이블 empno 컬럼으로 primary key 제약 생성 : pk_emp
--dept 테이블 deptno 컬럼으로 primary key 제약 생성 : pk_dept
--emp 테이블의 deptno 컬럼이 dept 테이블의 deptno 컬럼을 참조하도록 foreign key 제약 추가 : fk_dept_deptno

alter table emp add CONSTRAINT pk_emp primary key (empno);
alter table dept add constraint pk_dept primary key (deptno);
alter table emp add constraint fk_dept_deptno FOREIGN key (deptno) references dept (deptno);

--emp_test 테이블에는 인덱스가 없는 상태
--원하는 데이터를 찾기 위해서는 테이블의 데이터를 모두 읽어봐야 한다.
explain plan for
select * from emp_test
where empno = 7369;

--실행계획을 통해 7369 사번을 갖는 직원 정보를 조회 하기 위해 테이블의 모든 데이터를 읽어 본 다음에
--사번이 7369인 데이터만 선택하여 사용자에게 반환 >>13건의 데이터는 불필요하게 조회 후 버림
select * from table(dbms_xplan.display);


--
explain plan for
select * from emp
where empno = 7369;

select * from table(dbms_xplan.display);
--실행계획을 통해 분석을 하면 empno가 7369인 직원을 index를 통해 매우 빠르게 접근 후
--같이 저장 되어 있는 rowid 값을 통해 table에 접근
--talbe에서 읽은 데이터는 7369사번 데이터 한 건만 조회하고 나머지에 대해서는 읽지 않고 처리
--즉 14>>1 과 1>>1의 차이

explain plan for
select * from emp
where rowid = 'AAAE53AAFAAAAEWAAD';

commit;
rollback;