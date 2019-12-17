-- WITH
-- WITH 블록이름 AS (서브쿼리) select * from 블록이름

-- deptno, avg(sal) avg_sal
-- 해당 부서의 귭여평균이 전체 직원의 급여 평균보다 높은 부서에 한해 조회
select deptno, avg(sal) avg_sal
from emp 
group by deptno
HAVING avg(sal) > (select avg(sal) from emp);

-- with 절을 사용하여 위의 쿼리를 작성
WITH dept_sal_avg AS 
(select deptno, avg(sal) avg_sal
from emp 
group by deptno),
emp_sal_avg AS(
select avg(sal) avg_sal from emp)
select * from dept_sal_avg where avg_sal >(select avg_sal from emp_sal_avg);

/*WITH test as(
select 1, 'test' from dual union all
select 2, 'test2' from dual union all
select 3, 'test3' from dual) select * from test;    */

-- 계층쿼리
-- 달력만들기
-- CONNECT BY LEVEL <= N (테이블의 ROW 건수를 N만큼 반복한다.)
-- CONNECT BY LEVEL 절을 사용한 쿼리에서는 select 절에서 level이라는 특수 컬럼을 사용할 수 있다.
-- 계층을 표현하는 특수 컬럼으로 1부터 증가하며 ROWNUM과 유사하나 START WITH, CONNECT BY 절에서 차이점을 배운다.

select level from dual
connect by level <= 10;

--과제 완성
select  /*일요일이면 날짜, 월요일이면 날짜....토요일이면 날짜 */
        /*dt,d,*/--dt -(d-1),
        MAX(DECODE(d,1,dt,dt-(d-1))) sun ,MAX(DECODE(d,2,dt,dt-(d-2))) mon ,MAX(DECODE(d,3,dt,dt-(d-3))) tue ,
        MAX(DECODE(d,4,dt,dt -(d-4))) wed, MAX(DECODE(d,5,dt,dt -(d-5))) thu ,MAX(DECODE(d,6,dt,dt-(d-6))) fri ,
        MAX(DECODE(d,7,dt,dt-(d-7))) sat
from (select TO_DATE(:yyyymm,'YYYYMM')+(LEVEL-1) dt,
        TO_CHAR(TO_DATE(:yyyymm,'YYYYMM')+(LEVEL-1), 'D') d,
        TO_CHAR(TO_DATE(:yyyymm,'YYYYMM')+(LEVEL), 'IW') iw
from dual
connect by level <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm,'yyyymm')),'dd'))
group by dt -(d-1)
order by dt -(d-1);


select  /*일요일이면 날짜, 월요일이면 날짜....토요일이면 날짜 */
        /*dt,d,*/
        MAX(DECODE(d,1,dt)) sun ,MAX(DECODE(d,2,dt)) mon ,MAX(DECODE(d,3,dt)) tue ,MAX(DECODE(d,4,dt)) wed,
        MAX(DECODE(d,5,dt)) thu ,MAX(DECODE(d,6,dt)) fri ,MAX(DECODE(d,7,dt)) sat
from (select TO_DATE(:yyyymm,'YYYYMM')+(LEVEL-1) dt,
        TO_CHAR(TO_DATE(:yyyymm,'YYYYMM')+(LEVEL-1), 'D') d,
        TO_CHAR(TO_DATE(:yyyymm,'YYYYMM')+(LEVEL), 'IW') iw
from dual
connect by level <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm,'yyyymm')),'dd'))
group by iw
order by sat;


select  /*일요일이면 날짜, 월요일이면 날짜....토요일이면 날짜 */
        /*dt,d,*/iw,
        MAX(DECODE(d,1,dt)) sun ,MAX(DECODE(d,2,dt)) mon ,MAX(DECODE(d,3,dt)) tue ,MAX(DECODE(d,4,dt)) wed,
        MAX(DECODE(d,5,dt)) thu ,MAX(DECODE(d,6,dt)) fri ,MAX(DECODE(d,7,dt)) sat
from (select TO_DATE(:yyyymm,'YYYYMM')+(LEVEL-1) dt,
        TO_CHAR(TO_DATE(:yyyymm,'YYYYMM')+(LEVEL+7), 'D') d,
        TO_CHAR(TO_DATE(:yyyymm,'YYYYMM')+(LEVEL), 'IW') iw
from dual
connect by level <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm,'yyyymm')),'dd'))
group by iw
order by iw;


create table sales as 
select to_date('2019-01-03', 'yyyy-MM-dd') dt, 500 sales from dual union all
select to_date('2019-01-15', 'yyyy-MM-dd') dt, 700 sales from dual union all
select to_date('2019-02-17', 'yyyy-MM-dd') dt, 300 sales from dual union all
select to_date('2019-02-28', 'yyyy-MM-dd') dt, 1000 sales from dual union all
select to_date('2019-04-05', 'yyyy-MM-dd') dt, 300 sales from dual union all
select to_date('2019-04-20', 'yyyy-MM-dd') dt, 900 sales from dual union all
select to_date('2019-05-11', 'yyyy-MM-dd') dt, 150 sales from dual union all
select to_date('2019-05-30', 'yyyy-MM-dd') dt, 100 sales from dual union all
select to_date('2019-06-22', 'yyyy-MM-dd') dt, 1400 sales from dual union all
select to_date('2019-06-27', 'yyyy-MM-dd') dt, 1300 sales from dual;

select 
NVL(min(decode(mm,'01', sum_sales)),0) JAN,
NVL(min(decode(mm,'02', sum_sales)),0) FEB,
NVL(min(decode(mm,'03', sum_sales)),0) MAR,
NVL(min(decode(mm,'04', sum_sales)),0) APR,
NVL(min(decode(mm,'05', sum_sales)),0) MAY,
NVL(min(decode(mm,'06', sum_sales)),0) JUN
from 
(select TO_CHAR(dt,'MM') mm, sum(sales) sum_sales
from sales
group by TO_CHAR(dt,'MM'));

select * from --박종민씨 작품
(select sum(sales) JAN from sales where dt like '%-01-%'),
(select sum(sales) FEB from sales where dt like '%-02-%'),
(select NVL(sum(sales),0) MAR from sales where dt like '%-03-%'),
(select sum(sales) APR from sales where dt like '%-04-%'),
(select sum(sales) MAY from sales where dt like '%-05-%'),
(select sum(sales) JUN from sales where dt like '%-06-%');

select dept_h.*,level
from DEPT_H
start with deptcd = 'dept0' --시작점은 deptcd = 'dept0' >>xx회사(최상위 조직)
connect by prior deptcd = p_deptcd;
/*
        dept0(xx회사) 
            dept0_00(디자인부)
                dept0_00_0(디자인팀)
            dept0_01(정보기획부)
                dept0_01_0(기획팀)
                    dept0_00_0_0(기획파트)
            dept0_02(정보시스템부)
                dept0_02_0(개발1팀)
                dept0_02_1(개발2팀)    */
                    