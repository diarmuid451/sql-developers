--사원번호, 사원이름, 부서번호, 급여, 부서원의 전체 급여합
select empno, ename, deptno, sal, 
sum(sal) over(order by sal 
rows between UNBOUNDED PRECEDING and CURRENT ROW) c_sum, --가장 처음부터 현재형까지
sum(sal) over(order by sal 
rows UNBOUNDED PRECEDING) cc_sum, --c_sum 문법에서 살짝 변형
sum(sal) over(order by sal 
rows between 1 PRECEDING and CURRENT ROW) cn_sum--바로 이전행이랑 현재행까지의 합
from emp;

--십습 ana7
select empno, ename, deptno, sal, 
sum(sal) over(PARTITION by DEPTNO order by sal desc,empno rows UNBOUNDED PRECEDING) as c_sum
from emp;

--ROWS vs RANGE vs NO WINDOWING
select empno, ename, deptno, sal,
sum(sal) over (order by sal rows UNBOUNDED PRECEDING) rows_sum,
sum(sal) over (order by sal range UNBOUNDED PRECEDING) range_sum,
sum(sal) over (order by sal ) c_sum
from emp;

select empno, ename, deptno, sal, sum(sal) over() as sum,
round(RATIO_TO_REPORT(sal) OVER (),2) AS rr,
round(PERCENT_RANK() over(PARTITION by deptno order by sal),2) as pr_sum,
round(cume_dist() over (PARTITION by deptno order by sal),2) as cd_sum,
NTILE(5) OVER (ORDER BY sal DESC) as title
from emp
order by deptno;

-- PL/SQL
-- PL/SQL 기본 구조
-- DECLARE : 선언부, 변수를 선언하는 부분
-- BEGIN : PL/SQL의 로직이 들어가는 부분
-- EXCEPTION : 예외처리 부분

--DBMS_OUTPUT.PUT_LINE 함수가 출력하는 결과를 화면에 보여주도록 활성화
SET SERVEROUTPUT ON; 
DECLARE --선언부
    --java 식 : 타입 변수명;
    --PL/SQL 식 : 변수명 타입;
    --V_DNAME VARCHAR2(14);
    --V_LOC VARCHAR2(13);
    V_DNAME dept.dname%TYPE;
    V_LOC dept.loc%TYPE;
BEGIN
    --DEPT 테이블에서 10번 부서의 부서 이름, LOC 정보를 조회
    SELECT DNAME, LOC
    INTO V_DNAME,V_LOC
    FROM DEPT
    WHERE DEPTNO = 10;
   
    DBMS_OUTPUT.PUT_LINE(V_DNAME || V_LOC);
END;
/   
--PL/SQL 블록을 실행

SET SERVEROUTPUT ON; 
create or replace PROCEDURE printdept
(p_deptno IN dept.deptno%TYPE)
is
--선언부(선택)
    DNAME dept.dname%TYPE;
    LOC dept.loc%TYPE;

--실행부
BEGIN
    SELECT DNAME, LOC
    INTO DNAME,LOC
    FROM DEPT
    WHERE DEPTNO = p_deptno;

--예외처리부(선택)

    DBMS_OUTPUT.PUT_LINE(DNAME || ' ' || LOC);
END;
/   
--PL/SQL 블록을 실행
exec printdept(30);


--실습 pro_1
create or REPLACE PROCEDURE printemp
(p_empno IN emp.empno%TYPE)
IS
    ename emp.ename %TYPE;
    dname dept.dname %TYPE;
BEGIN
    select emp.ename, dept.dname into ename, dname
    from emp, dept
    where emp.deptno = dept.deptno and emp.empno = p_empno;
    
    DBMS_OUTPUT.PUT_LINE(ename || ' ' || dname );
END;
/

exec printemp(7698);    

--실습 pro_2
create or REPLACE PROCEDURE registdept_test
(reg_deptno IN dept_test.deptno%TYPE, 
reg_dname IN dept_test.dname%TYPE, 
reg_loc IN dept_test.loc%TYPE)
IS
    deptno dept_test.deptno %TYPE;
    dname dept_test.dname %TYPE;
    loc dept_test.loc %TYPE;
BEGIN
   INSERT INTO dept_test values(reg_deptno, reg_dname,reg_loc);
    commit;
END;
/
exec registdept_test(99, 'ddit','daejeon');


select * from dept_test;
delete from dept_test where deptno > 90;