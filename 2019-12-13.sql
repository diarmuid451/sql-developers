
--MERGE
--emp테이블에 존재하는 데이터를 emp_test 테이블로 머지
--만약 enpno가 동일한 데이터가 존재하면
--ename update : ename || '_merge'
--만약 enpno가 동일한 데이터가 존재하지 않을 경우
--emp테이블의 empno, ename emp_test 데이터로 insert

--emp 테이블에는 14건의 데이터가 존재
--emp_test 테이블에는 사번이 7788보다 작은 7명의 데이터가 존재
--emp테이블을 이용하여 emp_tes 테이블을 머지하게 되면
--emp테이블에만 존재하는 직원(사번이 7788보다 크거나 같은) 7명은 emp_test로 새롭게 insert가 될 것이고
--emp, emp_test에 사원번호가 동일하게 존재하는 직원(사번이 7788보다 작은) 7명 의 데이터는
--ename컬럼의 ename || '_modify'로 업데이트한다

/* MERGE INTO 테이블명 USING 머지대상 테이블 |VIEW| SUBQUERY ON (테이블 명과 머지대상의 연결관계)
    WHEN MATCHED THEN
        UPDATE...
    WHEN NOT MATCHED THEN
        INSERT... 
*/

MERGE INTO emp_test USING emp ON (emp.empno = emp_test.empno)
WHEN MATCHED THEN
    UPDATE SET ename = ename ||'_mod'
WHEN NOT MATCHED THEN
    INSERT VALUES (emp.empno, emp.ename);

--emp_test 테이블에 사번이 9999인 데이터가 존재하면 ename을 'brown'으로 update
--존재하지 않을 경우 empno, ename VALUES (9999,'brown')으로 insert
--위의 시나리오를 MERGE 구문을 활용하여 한번의 sql로 구현

merge into emp_test using dual on(emp_test.empno = : empno)
when matched then
    update set ename = :ename || '_mod'
when not matched then
    insert values (:empno, :ename);

--만일 merge 구문이 없다면:
--1. empno = 9999인 데이터가 존재하는 확인
--2-1. 1번 사항에서 데이터가 존재하면 update
--2-2. 1번 사항에서 데이터가 존재하지 않으면 insert 


--십습 GROUP_AD1    
select * from 
(select deptno, sum(sal) sal
from emp 
group by deptno

UNION ALL
select null deptno, sum(sal) sal
from emp) order by deptno;

--JOIN 방식으로 >> emp 테이블의 14건의 데이터를 28건으로 생성
--구분자(1 : 14, 2 : 14)를 기준으로 group by
--구분자 1 : 부서번호 기준으로 
--구분자 2 : 전체 기준 
select DECODE(b.rn,1, emp.deptno, 2, null) deptno,
 sum(emp.sal)sal from emp,
(select level rn from dual connect by level <= 2) b
group by DECODE(b.rn,1, emp.deptno, 2, null)
order by deptno;

-- report group by
-- roll up 
-- group by rollup(col1,col2...)
-- group by 절에 기술된 컬럼을 오른쪽에서 부터 지운 결과로
-- SUB group을 생성하여 여러개의 group by절을 하나의 sql에서 실행되도록 한다.
-- group by ROLLUP(job, deptno)
-- group by job, deptno >> group by job >> group by 전체행 
-- 오른쪽에서부터 group by를 진행

--emp테이블을 이용하여 부서번호별, 전체직원별 급여합을 구하는 쿼리를 ROLLUP기능을 기용하여 작성
select deptno, sum(sal) sal
from emp
group by rollup(deptno);

--emp 테이블을 이용하여 job, deptno 별 sal+comm 합계, job별 sal+comm합계, 전체직원의 sal+comm합계
select job, deptno, sum(sal+NVL(comm,0)) sal_sum
from emp
group by rollup(job, deptno)
order by deptno nulls first, sal_sum;
--ROLLUP은 컬럼 순서가 조회 결과에 영향을 미친다.
--group by rollup(job, deptno)
--job, deptno >> job >> 전체

--group by rollup(deptno, job)
--deptno, job >> deptno >> 전체

--실습 GROUP_AD2
select decode(grouping(job),1,'총',job)job, 
    CASE
        when deptno IS NULL AND job is null then '계'
        when deptno IS NULL then '소계'
        else to_char(deptno)
        end deptno, sum(sal+NVL(comm,0)) sal_sum
from emp
group by rollup(job, deptno);

--실습 GROUP_AD3
select deptno, job, sum(sal+NVL(comm,0)) sal
from emp
group by rollup(deptno, job);
--UNION ALL로 치환
select deptno, job, sum(sal+NVL(comm,0)) sal_sum
from emp
group by deptno, job
union all
select deptno, null, sum(sal+NVL(comm,0)) sal_sum
from emp
group by deptno
union all
select null, null, sum(sal+NVL(comm,0)) sal_sum
from emp
order by deptno;



--실습 GROUP_AD4
select dept.DNAME,emp.job, sum(sal+NVL(comm,0)) sal
from emp join dept on (dept.deptno = emp.deptno)
group by rollup(dept.dname,emp.job)
order by dept.dname,emp.job desc nulls first;


--실습 GROUP_AD5
select NVL(dept.dname,'총합') dname,
CASE
    when emp.JOB IS NULL AND dept.dname is null then '계'
    when emp.job IS NULL then '소계'
    else emp.job
    end job,
sum(sal+NVL(comm,0)) sal
from emp join dept on (dept.deptno = emp.deptno)
group by rollup(dept.dname,emp.job)
order by dname,emp.job desc nulls first;























select * from emp_test where empno = 9999 order by empno;
rollback;
commit;