--실습 sub4
INSERT INTO dept VALUES (99,'ddit','daejeon');
commit;

select *
from dept where deptno NOT IN (select deptno from emp);

--실습 sub5

select *
from product where pid NOT IN (select pid from cycle where cid =1);

--실습 sub6
--(cid = 2인 고객이 애음하는 제품)중 cid = 1인 고객이 애음하는 제품의 애음정보를 조회

select * from cycle where cid = 1 
AND pid IN (select pid from cycle where cid = 2);

--실습 sub7
select *
from  cycle where cid = 1;


select cm.cid, cm.CNM, c.pid, p.pnm, c.DAY, c.CNT
from customer cm, cycle c,product p 
where cm.cid = c.cid AND c.pid = p.pid AND cm.CID = 1
AND c.pid IN(select pid from cycle where cid =2 );

--EXISTS 연산자
--조건을 만족하는 서브쿼리의 결과값이 존재하는지 체크
select *
from  emp a where EXISTS(select 'x' from emp b where b.empno = a.mgr);

--실습 sub8
select *
from emp where mgr IS NOT NULL;  --테이블 1번 읽음

select *
from emp e, emp m
where e.mgr = m.empno;  --테이블 2번 읽음

--실습 sub9
select *
from cycle;

select *
from product where exists(select 'x' from cycle where cycle.cid = 1 and product.pid = cycle.pid);

--실습 sub10
select *
from product where NOT exists(select 'x' from cycle where cycle.cid = 1 and product.pid = cycle.pid);


--집합연산
--UNION : 합집합, 두 집합의 중복건은 제거한다.
--담당업무가 SALESMAN인 직원의 직원번호, 직원 이름 조회
select empno, ename
from emp
where job = 'SALESMAN'

UNION

select empno, ename
from emp
where job = 'SALESMAN'; -- 위아래 결과가 동일하기 때문에 합집합 연산을 하게 될경우 중복되는 데이터는 한번만 표현

select empno, ename
from emp
where job = 'SALESMAN'

UNION

select empno, ename
from emp
where job = 'CLERK';

--UNION ALL : 합집합 연산시 중복값을 제거하지 않는다. 위아래 결과를 합치기만 한다.
select empno, ename
from emp
where job = 'SALESMAN'

UNION ALL

select empno, ename
from emp
where job = 'SALESMAN';

--집합연산시 집합셋의 컬럼이 동일 해야한다.
select empno, ename, ''
from emp
where job = 'SALESMAN'

UNION

select empno, ename, job
from emp
where job = 'SALESMAN';

--INTERSECT : 교집합
--두 집합간 공통적인 데이터만 조회

select empno, ename
from emp
where job IN('SALESMAN','CLERK')

INTERSECT

select empno, ename
from emp
where job IN 'SALESMAN';

--MINUS : 차집합
--위, 아래 집합의 교집합을 위 집합에서 제거한 집합을 조회, 다른 연산자와 다르게 집합의 선언 순서가 결과에 영향을 준다.
select empno, ename
from emp
where job IN('SALESMAN','CLERK')

MINUS

select empno, ename
from emp
where job IN ('SALESMAN');

 
select empno, ename
from emp 
where job = 'SALESMAN'

UNION 

select empno, ename
from emp
where job = 'SALESMAN'
order by ename;


select m.ename, s.ename
from emp m LEFT OUTER JOIN emp s ON(m.mgr = s.empno)

UNION

select m.ename, s.ename
from emp m RIGHT OUTER JOIN emp s ON(m.mgr = s.empno)

INTERSECT

select m.ename, s.ename
from emp m FULL OUTER JOIN emp s ON(m.mgr = s.empno);


--DML
--INSERT : 테이블에 새로운 데이터를 입력

select *
from dept;

DELETE dept
where deptno = 99;
commit; 
--INSERT 시 컬럼을 나열한 경우 나열한 컬럼에 맞춰 입력할 값을 동일한 순서로 기술한다.
--INSERT INTO 테이블명(컬럼1, 컬럼2...)
            --VALUES(값1, 값2...)
--dept 테이블에 99번 부서번호, ddit 조직명, daejeon 지역명을 갖는 데이터 입력
select * from dept;

ROLLBACK;

INSERT INTO dept (deptno, dname, loc)
            values (99, 'ddit', 'daejeon');



--컬럼을 기술할 경우 테이블의 컬럼 정의 순서와 다르게 나열해도 상관이 없다
--dept 테이블의 컬럼 순서 : deptno, dname, location
INSERT INTO dept (loc, deptno, dname)
            values ('daejeon', 99,'ddit');

--컬럼을 기술하지 않는 경우 : 테이블의 컬럼 정의 순서에 맞춰 값을 기술한다.
DESC dept;
INSERT INTO dept values (99, 'ddit', 'daejeon');


--날짜 값 입력하기
--1. SYSDATE
--2. 사용자로부터 받은 문자열을 DATE 타입으로 변경하여 입력
DESC emp;
select * from emp;

INSERT INTO emp VALUES (9998, 'sally','SALES',NULL,SYSDATE,500,NULL,NULL);

--2019년 12월 2일 입사
INSERT INTO emp values (9997, 'james','RANGER',NULL,TO_DATE('2019-12-02','yyyy-mm-dd'), 500,NULL,NULL);

--여러건의 데이터를 한번에 입력
--SELECT 결과를 테이블에 입력할 수 있다.
--UNION 활용하여 INSERT도 가능
INSERT INTO emp 
select 9998,'SALLY','SALESMAN',NULL,SYSDATE,500,NULL,NULL
from dual
UNION ALL
select 9997,'JAMES','CLERK',NULL,TO_DATE('2019-12-02','yyyy-mm-dd'), 500,NULL,NULL
from dual;

rollback;