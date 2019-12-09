drop table dept_test;
drop table emp_test;
commit;
rollback;
select *
from EMP_test;
desc emp_test;
--PRIMARY KEY 제약 : UNIQUE + NOT NULL
--UNIQUE : 해당 컬럼에 동일한 값이 중복 될 수 없다(EX : emp테이블의 empno(사번), dept테이블의 deptno(부서번호))
--해당 컬럼에 NULL값이 들어 갈 수 있다.
--NOT NULL : 데이터 입력시 해당 컬럼에 값이 반드시 들어와야 한다.

--컬럼 레벨의 PRIMARKY KEY 제약 생성
--오라클의 제약조건 이름을 임의로 생성
create table dept_test(
   deptno NUMBER(2) primary key);
    
--오라클 제약 조건의 이름을 임의로 명명
--PRIMARY KEY : pk_테이블명
create table dept_test(
deptno NUMBER(2) CONSTRAINT pk_dept_test PRIMARY KEY);

--pairwise : 쌍의 개념
--상단의 primary key 제약 조건의 경우 하나의 컬럼에 제약 조건을 생성
--여러 컬럼을 복합으로 primary key 제약으로 생성 할 수 있다.
--해당 방법은 위의 두가지 예시 처럼 컬럼 레벨에서는 생성 할 수 없다. > TABLE LEVEL 제약 조건 생성

--기존에 생성한 dept_test 테이블 삭제(drop)
drop table dept_test;

--컬럼 레벨이 아닌, 테이블 레벨의 제약조건 생성
create table dept_test(
    deptno NUMBER(2) primary key,
    dname varchar2(14) not null, loc varchar2(13),
    --deptno, dname 컬럼이 같을 떄 동일한(중복된) 데이터로 인식
    constraint pk_dept_test primary key (deptno, dname));

--부서번호, 부서이름 순서쌍으로 중복 데이터를 검증
--아래 두개의 insert 구문은 부서번호는 같지만 부서명은 다르므로 서로 다른 데이터로 인식 > INSERT 가능
insert into dept_test values (99,'ddit','daejeon'); 
insert into dept_test values (99,'대덕','대전');    

select * from dept_test;
--두번째 INSERT 쿼리와 키값이 중복되므로 에러
insert into dept_test values (99,'대덕','청주');

--dname 컬럼이 null 값이 들어오지 못하도록 not null 제약 조건 생성
create table dept_test(
    deptno NUMBER(2) primary key,
    dname varchar2(14) not null, loc varchar2(13));

--deptno 컬럼이 primary key 제약에 걸리지 않고 loc 컬럼은 nullable이기 때문에 null 값 입력 가능    
insert into dept_test values (99,'ddit',null); 
--deptno 컬럼이 primary key 제약에 걸리지 않고(중복값이 아니기 떄문)
--dname 컬럼의 NOT NULL 조건 위배
insert into dept_test values (98,null,'대전');     


create table dept_test(
    deptno NUMBER(2) primary key,
    --deptno NUMBER(2) constraint pk_dept_test primary key,
    --dname varchar2(14) not null,
    dname varchar2(14) constraint NN_dname NOT NULL,
    loc varchar2(13));
    
create table dept_test(
    deptno NUMBER(2) primary key,
    dname varchar2(14), 
    loc varchar2(13));    
    --constraint pk_dept_test primary key (deptno, dname)
    --constraint NN_dname NOT NULL(dname) : 허용되지 않는다. 
   
--1. 컬럼레벨
--2. 컬럼레벨 제약조건 이름 붙이기
--3. 테이블 레벨
--4. [테이블 수정시 제약조건 적용]

--UNIQUE 제약 조건
--해당 컬럼에 값이 중복되는걸 제한. 단 null값은 허용.
--GLOBAL solution의 경우 국가가 법적 적용 사항이 다르기 때문에 
--pk 제약보다는 unique 제약을 사용하는 편이며, 부족한 제약 조건은 APPLICATION 레벨에서 체크하도록 설계

--컬럼레벨 unique제약 생성    
create table dept_test(
    deptno NUMBER(2) primary key,
    dname varchar2(14) unique, 
    loc varchar2(13));       
    
--두개의 insert 구문을 통해 dname이 같은 값을 입력했기 때문에 dname 컬럼에 적용된 unique제약에 의해
--두번째 쿼리는 실행될 수 없다.
insert into dept_test values (99,'ddit','daejeon');
insert into dept_test values (98,'ddit','대전');


create table dept_test(
    deptno NUMBER(2) primary key,
    dname varchar2(14) constraint idx_U_dept_test_01 unique, 
    loc varchar2(13));       

--FOREIGN KEY 제약조건
--다른 테이블에 존재하는 값만 입력 될 수 있도록 제한
--emp_test.deptno가 dept_test.deptno컬럼을 참조하도록 foreign key 제약 조건 생성
--dept_test 테이블 생성 (deptno 컬럼 primary key 제약)
--dept 테이블과 컬럼이름, 타입 동일하게 생성
create table dept_test(
    deptno NUMBER(2) primary key,
    dname varchar2(14),loc varchar2(13),
    constraint idx_u_dept_test unique(dname, loc));
    
insert into dept_test values (99, 'ddit','daejeon');

desc emp;
--empno, ename, deptno : emp_test
--empno primary key
--deptno dept_test.deptno foreign key
create table emp_test (
    empno NUMBER(4) primary key,
    ename VARCHAR2(10), deptno NUMBER(2) references dept_test (deptno));
    
--dept_test 테이블에 존재하는 deptno로 값을 입력
insert into emp_test values(9999,'brown',99);
--dept_test 테이블에 존재하지 않는 deptno로 값을 입력
insert into emp_test values(9998,'sally',98);

--테이블 레벨 foreign key
create table emp_test (
    empno NUMBER(4) primary key,
    ename VARCHAR2(10), deptno NUMBER(2), constraint kf_dept_test foreign key(deptno) references dept_test(deptno));
    

delete dept_test
where deptno = 99;
--부서정보를 지우려면 지우려고하는 부서번호를 참조하는 직원정보를 삭제 또는 deptno 컬럼을 null 처리
--emp >> dept

create table emp_test (
    empno NUMBER(4) primary key,
    ename VARCHAR2(10), deptno NUMBER(2), 
    constraint kf_dept_test foreign key(deptno) references dept_test(deptno)on delete cascade);
 --ON DELETE CASCADE 옵션에 따라 dept데이터를 삭제할 경우 
 --해당 데이터를 참조하고 있는 emp테이블의 사원 데이터도 삭제된다.
 
 create table emp_test (
    empno NUMBER(4) primary key,
    ename VARCHAR2(10), deptno NUMBER(2), 
    constraint kf_dept_test foreign key(deptno) references dept_test(deptno)on delete set null);
--on delete set null 옵션에 따라 dept데이터를 삭제할 경우 해당 데이터를 참조하고 있는 emp테이블의 deptno 컬럼을 null로 변경

--check 제약 조건
--컬럼에 들어가는 값을 검증할 때
--EX : 급여 컬럼에는 값이 0보다 큰 값만 들어가도록 체크/성별 컬럼에는 남/녀 혹은 M/F 값만 들어가도록 제한
--emp_test 테이블 컬럼
--empno NUMBER(4),ename VARCHAR2(10), sal NUMBER(7,2), emp_gb VARCHAR2(2) - 직원구분(01:정규직, 02:인턴)
create table emp_test(
empno NUMBER(4) primary key,
ename varchar2(10), sal number(7,2) check(sal >0), emp_gb varchar(2) check (emp_gb IN('01','02')));

--emp_test 데이터 입력
--sal컬럼 check 제약 조건(sal >0)에 의해서 음수 값은 입력 될 수 없다.
insert into emp_test values(9999,'brown',-1,'01');
--위배 되지 않으므로 정상 입력
insert into emp_test values(9999,'brown',1000,'01');
--emp_gb check 조건에 위배
insert into emp_test values(9998,'sally',1000,'03');
--emp_gb check 조건에 맞게 수정
insert into emp_test values(9998,'sally',1000,'02');

--check 제약 조건이 걸린 이름 생성
--table level check 제약조건
create table emp_test(
empno NUMBER(4) primary key,
ename varchar2(10), sal number(7,2) ,
emp_gb varchar(2),
constraint no_ename check (ename is not null),
constraint c_sal check(sal >0),
constraint c_emp_gb check (emp_gb IN('01','02')));

--테이블 생성 : create table 테이블명(컬럼 컬럼타입...);

--기존 테이블을 활용해서 테이블 생성하기
--create table 테이블 명( 컬럼1, 컬럼2, 컬럼3...) as (CTAs)
--select col1m col2...
--from 다른 테이블명
--where 조건

--emp테이블의 데이터를 포함해서 emp_test 테이블을 생성
create table emp_test as 
select *
from emp;

--emp테이블의 데이터를 포함해서 emp_test 테이블을 컬럼명을 변경하여 생성
create table emp_test(c1,c2,c3,c4,c5,c6,c7,c8) as
select * from emp;

--데이터는 제외하고 테이블의 형체(컬럼 구성)만 복사하여 테이블 생성
create table emp_test AS
select *
from emp where 1=2;

--empno, ename, deptno 컬럼으로 emp_test생성
create table emp_test as
select empno, ename, deptno
from emp
where 1=2;

--emp_test 테이블에 신규컬럼 추가
--ALTER TABLE 테이블명 ADD (컬럼명 컬럼 타입 [default value]);
alter table emp_test add (HP varchar2(20) default '010');

--기존 컬럼 수정
--ALTER 
--hp 컬럼의 타입을 varchar2(20) >> varchar2(30)
ALTEr table emp_test MODIFY (hp varchar2(30));

--현재 emp_test 테이블에 데이터가 없기 때문에 컬럼 타입을 변경하는 것이 가능하다.
--hp 컬럼의 타입을 varchar2(30) >> number
alter table emp_test modify (hp number);

--컬럼명 변경
--해당 컬럼이 PK, UNIQUE, NOT NULL, CHECK제약 조건시 기술한 컬럼명에 대해서도 자동적으로 변경
--hp >> hp_n
--alter table 테이블 명 rename column 기존 컬럼명 to 변경 컬럼명;
alter table emp_test rename column hp to hp_n;

--컬럼 삭제
--ATLER TALBE 테이블명 DROP (컬럼명);
--alter talbe 테이블명 drop column 컬럼명
alter table emp_test drop column hp;

--제약 조건 추가
--alter table 테이블명 add 테이블 레벨 제약조건 스크립트
--emp_test테이블의 empno컬럼을 pk제약조건 추가
alter table emp_test add constraint pk_emp_test primary key(empno);

--제약 조건 삭제
--alter table 테이블명 drop constraint 제약조건이름;
--emp_test 테이블의 primary key 제약조건인 pk_emp_test 제약 삭제
alter table emp_test drop constraint pk_emp_test;

--테이블 컬럼, 타입 변경은 제한적이나마 변경 가능
--테이블의 컬럼 순서를 변경하는것은 불가능하다
