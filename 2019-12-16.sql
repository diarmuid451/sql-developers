-- GROUPING SETS(col1, col2) (다음과 결과가 동일)
-- 개발자가 group by의 기준을 직접 명시한다.
-- ROLLUP과는 달리 방향성을 갖지 않는다.
-- GROUPING SETS(col1, col2) = (col2,col1)

/*  GROUP BY col1
    UNION ALL
    GROUP BY col2   */
-- emp 테이블에서 직원의 job(업무)별 급여(sal)+ 상여(comm)합, deptno(부서)별 급여(sal)+ 상여(comm)합 구하기
-- 기존 방식(GROUP FUNCTION) : 2번의 SQL 작성 필요(UNION / UNION ALL)

select job,null deptno, sum(sal + NVL(comm,0)) sal_comm_sum
from emp
group by job
union all
select '',deptno, sum(sal + NVL(comm,0)) sal_comm_sum
from emp
group by deptno;

select job, deptno, sum(sal + nvl(comm,0)) sal
from emp
group by grouping sets (job, deptno);

-- job, deptno를 그룹으로 한 sal + comm합
-- mgr를 그룹으로 한 sal_comm합
/*  group by job, deptno
    union all
    group by mgr    */
-- grouping sets((job, deptno),mgr)
select job, deptno, mgr, sum(sal+ nvl(comm,0))sal_comm_sum,grouping(job),grouping(deptno),grouping(mgr)
from emp
group by grouping sets ((job, deptno),mgr);

-- CUBE (col1,col2...)
-- 나열된 컬럼의 모든 가능한 조합으로 group by subset을 만든다.
-- 나열된 컬럼이 n일 경우 가능한 조합의 수는  2^n 개
-- n의 수에 따라 가능한 조합이 급격하게 늘어나기 때문에 활용도가 낮음

--job, dpetno를 이용하여 cube 적용
select job, deptno, sum(sal+ nvl(comm,0)) sal_comm_sum
from emp
group by cube(deptno, job)
order by job nulls last;
-- job  deptno
-- 1,   1       : group by job, deptno
-- 1,   0       : group by job
-- 0,   1       : group by deptno
-- 0,   0       : group by all

select job, deptno, mgr, sum(sal+nvl(comm,0)) sal
from emp
group by job, rollup(deptno), cube(mgr)
order by job, deptno nulls last, mgr nulls last;

select job, deptno, mgr, sum(sal+nvl(comm,0)) sal
from emp
group by job, rollup(job, deptno),cube(mgr);

--실습 sub_a1

alter table dept_test add(empcnt number);
update dept_test set empcnt = (select count(*) from emp where emp.deptno = dept_test.deptno);

--실습 sub_a2
insert into dept_test values (99, 'it1', 'daejeon','');
insert into dept_test values (98, 'it2', 'daejeon','');
delete dept_test where deptno NOT IN (select emp.deptno from emp) ;

--실습 sub_a3
update emp_test set sal = sal+200 
where sal < (select round(avg(sal),2) from emp where deptno = emp_test.deptno); 
select deptno, round(avg(sal),2) from emp group by deptno;

--merge 구문을 이용한 업데이트
select * from emp;
select * from emp_test;
select deptno, avg(sal) from emp_test group by deptno;
merge into emp_test a
using (select deptno, avg(sal) avg_sal from emp_test group by deptno) b
on (a.deptno = b.deptno)
when matched then
    update set sal = sal + 200 where a.sal < b.avg_sal;
    
select deptno, avg(sal) from emp_test group by deptno;

-- +)case 구문 이용한 방법
merge into emp_test a
using (select deptno, avg(sal) avg_sal from emp_test group by deptno) b
on (a.deptno = b.deptno)
when matched then
    update set sal = case when a.sal< b.avg_sal then sal +200
                        else sal end;