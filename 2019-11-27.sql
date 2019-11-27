--con1
--CASE
--  WHEN condition THEN return1
--END
--DECODE(col|expr, search1, return1, search2, return2... default)
SELECT empno, ename
        ,CASE
            WHEN deptno = 10 THEN 'ACCOUNTING'
            WHEN deptno = 20 THEN 'RESERARCH'
            WHEN deptno = 30 THEN 'SALES'
            WHEN deptno = 40 THEN 'OPERATIONS'
            ELSE 'DDIT'
        END dname
        , DECODE(deptno, 10, 'ACCOUNTING', 
                        20, 'RESERARCH',
                        30, 'SALES',
                        40, 'OPERATIONS', 'DDIT') dname2
FROM emp;

--cond2
--건강검진 대상자 조회 쿼리
--1. 올해년도가 짝수/ 홀수 인지


--1. TO_CHAR(SYSDATE, 'yyyy'
--> 올해년도 구분 (0 : 짝수년, 1: 홀수년)
SELECT TO_CHAR(SYSDATE, 'yyyy')+1, MOD(TO_CHAR(SYSDATE, 'YYYY')+1, 2)
FROM dual;

--2.
-- 추가문제: 내년도 건강검진 대상자를 조회하는 쿼르를 작성해보세요
--2020년도
SELECT empno, ename, hiredate,
        CASE
                WHEN MOD(TO_CHAR(hiredate, 'YYYY'),2) =
                     MOD(TO_CHAR(SYSDATE, 'YYYY'),2) THEN '건강검진 대상자'
                WHEN MOD(TO_CHAR(hiredate, 'YYYY'),2) =
                     MOD(TO_CHAR(SYSDATE, 'YYYY')+1,2) THEN '내년도 건강검진 대상자'
                ELSE '건강검진 비대상자'
        END contact_to_doctor
FROM emp;

--cond3,
SELECT a.userid, a.usernm, a.alias, a.yyyy,        
        CASE
            WHEN MOD(a.yyyy, 2) = MOD(a.this_yyyy,2) THEN '건강검진 대상자' 
            ELSE '건강검진 비대상자' 
        END CONTACTODOCTOR
FROM 
(SELECT userid, usernm, ALIAS, TO_CHAR(reg_dt ,'YYYY') yyyy, TO_CHAR(SYSDATE, 'YYYY') this_yyyy FROM users) a;

--GROUP FUNCTION
--특정 컬럼이나, 표현을 기준으로 여러행의 값을 한 행의 결과로 생성
--COUNT-건수, SUM-합계, AVG-평균, MAX-최대값, MIN-최소값
--전체 직원을 대상으로 (14건의 -> 1건)
DESC emp;
SELECT MAX(sal) max_sal --가장 높은 급여
        ,MIN(sal) min_sal --가장 낮은 급여
        ,ROUND(AVG(sal), 2) avg_sal -- 전 직원의 급여 평균
        ,SUM(sal) sum_sal --전 직원의 급여 합계
        ,COUNT(sal) count_sal --급여 건수(null이 아닌 값이면 1건)
        ,COUNT(mgr) count_mgr --직원의 관리자 건수(KING의 경우 MGR가 없다)
        ,COUNT(*) count_row--특정 컬럼의 건수가 아니라 행의 개수를 알고 싶을때
FROM emp;


--부서번호별 그룹함수 적용
SELECT deptno
        ,MAX(sal) max_sal --부서에서 가장 높은 급여
        ,MIN(sal) min_sal --부서에서가장 낮은 급여
        ,ROUND(AVG(sal), 2) avg_sal --부서 직원의 급여 평균
        ,SUM(sal) sum_sal --부서 직원의 급여 합계
        ,COUNT(sal) count_sal --부서 급여 건수(null이 아닌 값이면 1건)
        ,COUNT(mgr) count_mgr --부서 직원의 관리자 건수(KING의 경우 MGR가 없다)
        ,COUNT(*) count_row--부서의 조직원 수
FROM emp
GROUP BY deptno, ename;

--SELECT 절에는 GRUOP BY 절에 없는 컬럼이 나올 수 없다
--논리적으로 성립되지 않는
SELECT deptno, ename
        ,MAX(sal) max_sal --부서에서 가장 높은 급여
        ,MIN(sal) min_sal --부서에서가장 낮은 급여
        ,ROUND(AVG(sal), 2) avg_sal --부서 직원의 급여 평균
        ,SUM(sal) sum_sal --부서 직원의 급여 합계
        ,COUNT(sal) count_sal --부서 급여 건수(null이 아닌 값이면 1건)
        ,COUNT(mgr) count_mgr --부서 직원의 관리자 건수(KING의 경우 MGR가 없다)
        ,COUNT(*) count_row--부서의 조직원 수
FROM emp
GROUP BY deptno, ename;

--그룹함수에서는 NULL 컬럼은 계산에서 제외된다.
--emp테이블에서 comm컬럼이 null이 아닌 데이터는 4건이 존재, 9건은 null
SELECT  COUNT(comm) count_comm  --NULL이 아닌 값의 개수
        ,SUM(comm) sum_comm --NULL값을 제외, 300+500+1400+0 = 2200
        ,SUM(sal + comm) tot_sal_sum
        ,SUM(sal + NVL(comm, 0)) tot_sal_sum1
FROM emp;


--WHERE 절에는 GROUP 함수를 표현 할 수 없다
--1.부서별 최대 급여 구하기
--2.부서별 최대 급여 값이 3000이 넘는 행만 구하기
--deptno, 최대급여
SELECT deptno, MAX(sal) m_sal
FROM emp
WHERE MAX(sal) > 3000  --ORA-00934: WHERE절에는 GROUP함수가 올 수 없다
GROUP BY deptno;


SELECT deptno, MAX(sal) m_sal
FROM emp
GROUP BY deptno
HAVING MAX(sal) > 3000; 

--grp1
SELECT MAX(sal) max_sal , MIN(sal) min_sal , ROUND(AVG(sal),2) avg_sal , SUM(sal) sum_sal,
        COUNT(sal) count_sal, COUNT(mgr) count_mgr, COUNT(*) count_all
FROM emp;

--grp2
SELECT  deptno, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal, SUM(sal) sum_sal,
        COUNT(sal) count_sal, COUNT(mgr) count_mgr, COUNT(*) count_all
FROM emp
GROUP BY deptno;

--grp3

SELECT  DECODE(deptno, 10,'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES') dname, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal, SUM(sal) sum_sal,
        COUNT(sal) count_sal, COUNT(mgr) count_mgr, COUNT(*) count_all
FROM emp
GROUP BY deptno
ORDER BY deptno;
                
--grp4
SELECT TO_CHAR(hiredate, 'YYYYMM') hire_yyyymm, COUNT(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYYMM');


SELECT TO_CHAR(hiredate, 'YYYY') hire_yyyymm, COUNT(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYY');

SELECT hire_yyyy, COUNT(*) cnt
FROM (SELECT TO_CHAR(hiredate, 'YYYY') hire_yyyy
FROM emp)
GROUP BY hire_yyyy;

--grp6
DESC dept;
SELECT COUNT(*), COUNT(deptno), COUNT(loc)
FROM dept;

--grp7
SELECT COUNT(deptno) cnt
FROM (SELECT deptno
FROM emp
GROUP BY deptno) a;


SELECT COUNT(COUNT(*)) cnt
FROM emp
GROUP BY deptno;

SELECT COUNT(DISTINCT deptno)
FROM emp;

--JOIN
--1. 테이블 구조변경(컬럼 추가)
--2. 추가된 컬럼에 값을 UPdate
--dname 컬럼을 emp 테이블에 추가
DESC emp;
select * from emp;
DESC dept;

--컬럼추가(dname, VARCHAR2(14)

ALTER TABLE emp ADD (dname VARCHAR2(14));

UPDATE emp SET dname = CASE
                        WHEN deptno = 10 THEN 'ACCOUNTING'
                        WHEN deptno = 20 THEN 'RESEARCH'
                        WHEN deptno = 30 THEN 'SALES'
                    END
where dname is null;
COMMIT;

--SLAES --> MARKET SALES
--총 6건의 데이터 변경이 필요하다
-- 값의 중복이 있는 형태(반 정규형)
UPDATE emp SET dname = 'MARKET SALES'
WHERE dname = 'SALES';

--emp 테이블, dept 테이블 조인
SELECT ename, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;