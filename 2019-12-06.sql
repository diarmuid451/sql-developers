rollback;
commit;

select *
from  emp;

select *
from dept;

--dept 테이블에 부서번호 99, 부서명 ddit, 위치 daejeon
insert into dept values (99,'ddit','daejeon');

--UPDATE : 테이블에 저장된 컬럼의 값을 변경
--UPDATE 테이블명 SET 컬렴명1 = 값1, 컬럼명2 = 값2...
--[where row 조회 조건]

--부서번호가 99번인 부서의 부서명을 대덕IT, 지역을 영민빌딩으로 변경
UPDATE dept SET dname = '대덕IT', loc = '영민빌딩'
where deptno = 99;

--업데이트전에 업데이트 하려고하는 테이블을 where절에 기술한 조건으로 select를 하여 업데이트 대상 row를 확인(실수 방지)
select *
from  dept
where deptno = 99;

select *
from dept;

--다음 쿼리를 실행하면 where절에 row 제한 조건이 없기 때문에 dept 테이블의 모든 행에 대해 부서명, 위치 정보를 수정한다.
update dept set dname = '대덕IT', loc = '영민빌딩';

--서브쿼리를 이용한 UPDATE
--emp 테이블에 신규 데이터 입력 - 사원번호 9999, 사원이름 brown, 업무 null
INSERT INTO emp( empno,ename) values (9999,'brown');
SELECT
    *
FROM emp where empno = 9999;

--사원번호가 9999인 사원의 소속 부서와 담당업무를 SMITH사원의 부서, 업무로 업데이트
UPDATE emp SET job = (select job from emp where ename = 'SMITH'), deptno = (select deptno from emp where ename = 'SMITH') 
where empno = 9999;

--DELETE : 조건에 해당하는 "ROW" 를 삭제
--따라서 컬럼의 값을 삭제(NULL)하기 위해서는 UPDATE

--DELETE 테이블명 WHERE 조건
--UPDATE와 마찬가지로 DELETE실행 전에 해당 테이블의 WHERE조건과 동일한 SELECT를 실행, 삭제할 ROW를 먼저 확인
--WHERE절이 없을 경우 테이블에 존재하는 모든 데이터를 삭제;


--emp테이블에 존재하는 사원번호 9999인 사원을 삭제
delete emp where empno = 9999;

delete emp where empno IN(select empno  from emp where mgr = 7698); 

--읽기 일관성(Isolation Level)
--DB문이 다른 사용자에게 어떻게 영향을 미치는지 정의한 레벨(0-3)

--ISOLATION LEVEL 2 : 선행 트랙잭션에서 읽은 데이터(FOR UPDATE)를 수정, 삭제하지 못함
UPDATE dept SET dname = 'ddit'
where deptno = 99;

--BOSTON 40
select *
from dept where deptno = 40 FOR UPDATE;
--다른 트랜잭션에서 수정을 못하기 때문에 현 트랙잭션에서 해당 ROW는 항상 동일한 결과값을 조회 할 수 있다.
--하지만 후행 트랙잭션에서 신규 데이터 입력 후 commit을 하면 현 트랜잭션에서 조회가 된다. > 유령 읽기(Phantom Read)

--ISOLATION LEVEL 3 : Serializable Read
--트랜잭션의 데이터 조회 기준이 트랜잭션 시작 시점으로 맞춰진다. 
--즉 후행 트랜잭션에서 데ㅣㅇ터를 신규 입력, 수정 삭제 후 COMMIT을 하더라도 선행 트랜잭션에서는 해당 테이터를 보지 않는다.

--트랜잭션 레벨 수정(ISOLATION LEVEL 변경) READ COMMITTED > SERIALIZABLE

--DDL : TABLE 생성
--CREATE TABLE [사용자명.]테이블명(
        --컬럼명N 컬럼타입N);

--ranger_no NUMBER(레인저 번호),ranger_nm VARCHAR2(50)(레인저 이름),reg_dt DATE(레인저 등록일자)
--테이블 생성 DDL : Data Defination Language(데이터 정의어)
--DDL은 자동 커밋되기 때문에 rollback이 없다. > 
create table ranger(reanger_no NUMBER, ranger_nm VARCHAR2(50),reg_dt DATE DEFAULT sysdate);

select *
from user_tables
where table_name = 'RANGER'; --오라클에서는 객체 생성시 소문자로 생성하더라도 내부적으로 대문자로 관리

insert into ranger values(1, 'brown',sysdate); 

select *
from ranger; --데이터가 조회되는 것을 확인

rollback; --DML문은 DDL과 다르게 rollback 가능 > rollback했기 때문에 DML문이 취소 되었다.

--DATE 타입에서 필드 추출하기
--EXTRACT (필드명 FROM 컬럼/expression)
select TO_CHAR(sysdate, 'yyyy') yyyy, to_char(sysdate, 'mm') mm, EXTRACT(year from sysdate) yyyy, extract(month from sysdate) mm
from dual;

create table dept_test(
deptno NUMBER(2) primary KEY, dname varchar2(14), loc varchar2(13));

drop table dept_test;

desc dept_test;

select *
from  dept_test;
--dept_test 테이블의 deptno 컬럼에 primary key 제약 조건이 있기 때문에 deptno가 동일한 데이터를 입력하거나 수정할 수 없다.
insert into dept_test values (99,'ddit','daejeon'); --최초 데이터이므로 입력 성공
insert into dept_test values (99,'대덕','대전'); --deptno가 99번인 데이터가 있으므로 primary key 제약 조건 위반
--ORA-00001 unique constraint 제약 위배(제약명 SYS_C007091)
--제약명이 어떤 제약 조건인지 판단하기 힘드므로 유지보수를 용이하기 위해서 이름을 붙여주는 편이 좋다.

create table dept_test(
deptno NUMBER(2) CONSTRAINT pk_dept_test primary KEY, dname varchar2(14), loc varchar2(13)); --삭제 후 이름 추가해서 재생성
--primary key : pk_테이블명
drop table dept_test;

insert into dept_test values (99,'ddit','daejeon'); --최초 데이터이므로 입력 성공
insert into dept_test values (99,'대덕','대전'); --deptno가 99번인 데이터가 있으므로 primary key 제약 조건 위반

