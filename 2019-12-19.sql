--실습 h_9(과제)
select SEQ, lpad(' ', (level-1)*4) || TITLE as TITLE
from board_test 
start with parent_seq IS NULL
connect by prior seq = parent_seq
order siblings by nvl(parent_seq,seq) desc;

--실습 h_9(과제)
select SEQ, lpad(' ', (level-1)*4) || TITLE as TITLE
from board_test 
start with parent_seq IS NULL
connect by prior seq = parent_seq
order by connect_by_root(seq) desc, seq asc;

--실습 ana0
select x.ename, x.sal, x.deptno, y.rn
from 
(select ename, sal, deptno, rownum j_rn from 
(select ename, sal, deptno from emp order by deptno, sal desc)) x,
(select rn, rownum j_rn from 
(select b.*, a.rn from (select rownum rn from dual connect by level <= (select count(*) from emp)) a,
(select deptno, count(*) cnt from emp group by deptno) b where b.cnt >= a.rn order by deptno,rn)) y
where x.j_rn = y.j_rn;


--window 함수
select ename, sal, deptno, RANK() OVER (PARTITION BY deptno ORDER BY sal) as SAL_RANK,
dense_rank() over(partition by DEPTNO order by SAL) as SAL_DENSE_RANK,
row_number() over(partition by DEPTNO order by SAL) as SAL_ROW_NUMBER
from emp;

--실습 ana1
select EMPNO, ename, sal, deptno, RANK() OVER (ORDER BY sal desc,empno) as SAL_RANK,
dense_rank() over(order by SAL desc,empno) SAL_DENSE_RANK,
row_number() over(order by SAL desc,empno) ROW_NUMBER
from emp;

--실습 no_ana2
select emp.empno, emp.ename, emp.deptno, cn.cnt
from emp,(select deptno, count(*) cnt
from emp
group by deptno) cn
where emp.deptno = cn.deptno
order by deptno;

--사원번호, 사원이름, 부서번호, 부서의 직원수
select empno, ename, deptno, count(*) over (partition by deptno) as cnt
from emp;

--실습 ana2
select empno, ename, sal,deptno, round(avg(sal) over(partition by deptno),2) as avg
from emp;

--실습 ana3 ,4
select empno, ename, sal, deptno, MAX(sal) over (partition by deptno) MAX_SAL, 
MIN(sal) over (PARTITION by deptno) MIN_SAL
from emp;

--전체사원을 대상으로 급여순위가 자신보다 한 단계 낮은 사람의 급여
--(급여가 같을경우 입사일자가 빠른 사람이 높은 순위)
select empno, ename, hiredate, sal, 
decode(lead(sal) over (order by sal desc,hiredate),null,'급여가 적은 사람 나야 나',
lead(sal) over (order by sal desc,hiredate)) lead_sal
from emp;

--실습 ana5
select empno, ename, hiredate, sal, lag(sal) over (order by sal desc,hiredate) as lag_sal,
decode(lag(sal) over (order by sal desc,hiredate),null,'급여가 높은 사람 나야 나!',lag(sal) over (order by sal desc,hiredate)) as lag
from emp;

--실습 ana6
select empno, ename, hiredate, job,sal, 
decode(lag(sal) over (partition by job order by sal desc,hiredate),null,'Σπάρτα!'
,lag(sal) over (partition by job order by sal desc,hiredate)) as lag_sal
from emp;

--실습 no_ana3
select a.empno, a.ename, a.sal1,sum(sal2) as c_sum
from
(select empno,ename,rownum as rn1, sal1
from (select empno, ename,sal as sal1
from emp
order by sal)) a,
(select rownum as rn2, sal as sal2
from (select sal
from emp
order by sal)) b
where a.rn1 >= b.rn2
group by a.empno, a.ename, a.sal1
order by c_sum;
