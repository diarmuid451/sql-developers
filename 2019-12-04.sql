--1.tax 테이블을 이용해 시도/시군구별 인당 연말정산 신고액 구하기
--2. 신고액이 많은 순서로 랭킹 부여하기
--랭킹 시도 시군구 인당연말정산_신고액

select *
from tax;

update tax set SIGUNGU = TRIM(SIGUNGU);
commit;

select id,sido 시도, sigungu 시군구, ROUND(sal/people,1) 인당_연말정산_신고액 
from tax
order by 4 DESC;

select ROWNUM 순위, a.시도, a.시군구, a.인당_연말정산_신고액
from (select sido 시도, sigungu 시군구, ROUND(sal/people,1) 인당_연말정산_신고액 
from tax
order by 3 DESC) a;

--해당 시도, 시군구별 프랜차이즈별 건수가 필요
select *
from fastfood;

select b.sido 시도, b.sigungu 시군구, NVL(ROUND(a.sum / b.lotte, 1),0) 도시발전지수
from 
(select count(gb) sum, sido, sigungu
from  fastfood
where gb IN( '버거킹','KFC','맥도날드') 
group by sido, sigungu
order by sigungu) a, 
(select count(gb) lotte, sido, sigungu
from  fastfood
where gb = '롯데리아'
group by sido, sigungu) b
where a.sigungu(+) = b.sigungu AND a.sido(+) = b.sido
order by 도시발전지수 DESC;

select *
from
(select ROWNUM 순위, c.시도, c.시군구, c.도시발전지수
from 
(select b.sido 시도, b.sigungu 시군구, NVL(ROUND(a.sum / b.lotte, 1),0) 도시발전지수
from 
(select count(gb) sum, sido, sigungu
from  fastfood
where gb IN( '버거킹','KFC','맥도날드') 
group by sido, sigungu
order by sigungu) a, 
(select count(gb) lotte, sido, sigungu
from  fastfood
where gb = '롯데리아'
group by sido, sigungu) b
where a.sigungu(+) = b.sigungu AND a.sido(+) = b.sido
order by 도시발전지수 DESC) c) x
,(select ROWNUM 순위, a.시도, a.시군구, a.인당_연말정산_신고액
from (select sido 시도, sigungu 시군구, ROUND(sal/people,1) 인당_연말정산_신고액 
from tax
order by 3 DESC) a) y
where x.순위(+) = y.순위
order by 5;


-- 도시발전 지수 시도, 시군구와 연말정산 납입금액의 시도, 시군구가 같은 지역끼리 조인
--정렬순서는 tax 테이블의 id컬럼순으로 정렬
select w.id, q.시도, q.시군구, q.도시발전지수, w.시도, w.시군구, w.인당_연말정산_신고액  
from
(select b.sido 시도, b.sigungu 시군구, NVL(ROUND(a.sum / b.lotte, 1),0) 도시발전지수
from 
(select count(gb) sum, sido, sigungu
from  fastfood
where gb IN( '버거킹','KFC','맥도날드') 
group by sido, sigungu) a, 
(select count(gb) lotte, sido, sigungu
from  fastfood
where gb = '롯데리아'
group by sido, sigungu) b
where a.sigungu(+) = b.sigungu AND a.sido(+) = b.sido
order by 3) q,
(select id,sido 시도, sigungu 시군구, ROUND(sal/people,1) 인당_연말정산_신고액 
from tax) w
where q.시도(+) = w.시도 and q.시군구(+) = w.시군구
order by w.id;


--SMITH가 속한 부서에 속한 직원들은 누가 있을까?
select deptno
from emp
where ename = 'SMITH';

select *
from  emp
where deptno = (select deptno from emp where ename = 'SMITH');

select empno, ename, deptno, (select dname from dept where dept.deptno = emp.deptno) dname
from emp;

--Scalar SubQuery
--select 절에 표현된 서브쿼리
--한 행, 한 COLUMN을 조회해야 한다.
select empno, ename, deptno, (select dname from dept) dname
from emp; --에러

--InLine View
--FROM절에 사용되는 서브쿼리

--SubQuery
--where절에 사용되는 서브쿼리

--십습 sub1
select count(*)
from emp
where sal > (select avg(sal) from emp);

--실습 sub2
select *
from emp
where sal > (select avg(sal) from emp);

--실습 sub3
select *
from emp
where deptno IN (select deptno from emp where ename IN( 'SMITH' ,'WARD')); 

select *
from emp
where deptno = ANY (select deptno from emp where ename IN( 'SMITH','WARD')); 

--SMITH 혹은 WARD보다 급여를 적게 받는 직원 조회
select *
from emp
where sal <=ALL (select sal from emp where ename = 'SMITH' OR ename = 'WARD'); --800,1250 ->800보다 작거나 같은사람


select *
from emp
where sal <= ANY 
(select sal from emp where ename IN( 'SMITH' ,'WARD')); --800,1250

--관리자 역할을 하지 않는 사원 정보 조회
--NOT IN 연산자 사용시 NULL이 데이터에 존재하지 않아야 정상동작 한다.
select *
from emp
where empno NOT IN ( select NVL(mgr,'0') mgr from emp); 

select *
from emp
where empno NOT IN ( select mgr from emp where mgr IS NOT null); 

--multi column subquery (pairwise)
--ALLEN, CLARK의 매너지와 부서번호가 동시에 같은 사원 정보 조회
--(7698, 30),(7839,10)
select *
from emp
where(mgr, deptno) in (select mgr,deptno from emp where empno IN (7499,7782));

--매니저가 7698이거나 7839이면서 소속부서가 10번 이거나 30번인 직원 정보 조회
--(7698, 10),(7698, 30),(7839,10),(7839,30)
select *
from emp
where mgr in (select mgr from emp where empno IN (7499,7782)) 
AND deptno in (select deptno from emp where empno IN (7499,7782));


select(select dname from dept where deptno = emp.deptno) dname, emp.empno, ename from emp;

--비상호 연관 서브쿼리
--메인쿼리의 컬럼을 서브쿼리에서 사용하지 않는 형태의 서브쿼리

--비상호 연관 서브쿼리의 경우 메인쿼리에서 사용하는 테이블, 서브쿼리 조회 순서를
--성능적으로 유리한쪽으로 판단하여 순서를 결정한다.
--메인쿼리의 emp테이블을 먼저 읽을수도 있고, 서브쿼리의 emp테이블을 먼저 읽을 수도 있다.

--비상호 연관 서브쿼리에서 서브쿼리쪽 테이블을 먼저 읽을 때는 서브쿼리가 제공자 역할을 했다고 표현
--비상호 연관 서브쿼리에서 서브쿼리쪽 테이블을 나중에 읽을 때는 서브쿼리가 확인자 역할을 했다고 표현


--직원의 급여 평균보다 높은 급여를 받는 직원 정보 조회
select *
from emp where sal > 
(select avg(sal) from emp);  --직원의 급여 평균;

--상호연관 서브쿼리
--해당직원이 속한 부서의 급여평균보다 높은 급여를 받는 직원 조회
select *
from emp a
where sal > (select avg(sal) from emp where deptno = a.deptno)
order by deptno;