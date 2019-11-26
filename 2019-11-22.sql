--where 9
SELECT *
FROM emp
WHERE DEPTNO NOT IN (10)
AND hiredate >= TO_DATE ('19810601','YYYYMMDD');

--where 10
SELECT *
FROM emp
WHERE DEPTNO IN (20 , 30)
AND hiredate > TO_DATE ('19810601','YYYYMMDD');

--where 11
SELECT *
FROM emp
WHERE JOB = ('SALESMAN')
AND hiredate > TO_DATE ('19810601','YYYYMMDD');

--where 12

SELECT *
FROM emp
WHERE JOB = 'SALESMAN'
OR EMPNO LIKE '78%';

--where 13
SELECT *
FROM emp
WHERE JOB = 'SALESMAN'
OR EMPNO BETWEEN 7800 AND 7899;

--desc emp;  유형 (열) <괄호 안은 열을 뜻함

--연산자 우선순위 (AND > OR)
--직원 이름이 SMITH 이거나, 직원이름이 ALLEN이면서 역활이 SALESMAN인 직원
SELECT *
FROM emp
WHERE ename = 'SMITH'
OR enmae = 'ALLEN'
AND job = 'SALESMAN';

SELECT *
FROM emp
WHERE ename = 'SMITH'
OR (enmae = 'ALLEN'AND job = 'SALESMAN');

--직원 이름이 SMIITH이거나 ALLEN 이면서 역활이 SALESMAN인 사람

SELECT *
FROM emp
WHERE (ename = 'SMITH' OR ename = 'ALLEN')
AND job = 'SALESMAN';

desc emp;

--where 14
--job이 SALESMAN 이거나 사원번호가 78로 시작하면서, 입사일자가 1981년 6월 1일 이후
SELECT *
FROM emp
WHERE (job = 'SALESMAN' OR empno BETWEEN 7800 AND 7899)
AND hiredate >= TO_DATE ('19810601', 'YYYYMMDD');

ORDER BY ename 

-- 오름차순 : ASC(표기 안할경우 기본값)
-- 내림차순 : DESC(내람차순시 반드시 표기)

/*
    SELECT col1.col2
    FORM 테이블명
    WHERE col1 = '값'
    ORDER BY 정렬기준 컬럼1[asc / desc] , 정렬기준 컬럼2 ......[ASC / DESC]
*/    
-- 사원(emp) 테이블에서 직원의 정보를 직원 이름(ename) 으로 오름차순 정렬
SELECT *
FROM emp
ORDER BY ename;

SELECT *
FROM emp
ORDER BY ename ASC;

-- 사원(emp) 테이블에서 직원의 정보를 직원 이름(ename) 으로 내림차순 정렬
SELECT *
FROM emp
ORDER BY ename DESC;

-- 사원(emp) 테이블에서 직원의 정보를 부서번호로 오름차순 정렬하고
-- 부서번호가 같을 떄는 sal 내림차순 정렬
-- 급여(SAL)가 같을때는 일므으로 오름차순 정렬 한다
SELECT  *
FROM emp
ORDER BY deptno ASC, sal DESC, ename;

--정렬 컬럼을 ALLAS로 표현
SELECT deptno, sal, ename nm
FROM emp
ORDER BY nm; 

--조회하는 컬럼의 위치 인데스로 표현 가능
SELECT deptno, sal, ename nm
FROM emp
ORDER BY 3; --1,2,3 등 위치 지정 가능 그러나 추천하지는 않음 컬럼 변경이있을경우 의도치 않을 변수가 생김

--oderby 1
--dept 테이블의 모든 정보를 부서이름으로 오름차순정렬
SELECT *
FROM dept
ORDER BY dname;

--oderby2
--emp 테이블에서 상여정보가 있는 사람들만 조회
--상여를 많이 받는 사람이 먼저 조회되도록 (내림차순)
--상여가 같은 경우 사번으로 오름차순

SELECT *
FROM emp
WHERE comm IS NOT NULL
AND comm != 0
ORDER BY comm desc, empno;

--oderby3
--emp 테이블에서 관리자가 있는 직원만 조회하고 MGR NULL이 아닌 데이터
--직군(job)순으로 오름차순 정렬
--직군이 같을 경우 사원번호가 큰사람이 먼저 조회되도록 (내림차순)
SELECT *
FROM emp
WHERE MGR IS NOT NULL
ORDER BY job, empno desc;

--oderby4
--emp 테이블에서 부서번호가 10번 혹은 30번 부서에 속하는 사람들
--급여가 1500이 넘는 사람만 조회
--이름으로 내림차순(DESC)

SELECT *
FROM emp
WHERE deptno IN (10, 30)
AND sal > 1500
ORDER BY ename desc;

-- ROWNUM
SELECT ROWNUM, empno, ename
FROM emp;

SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM = 2; -- ROWNUM = equal 비교는 1만 가능

SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM <= 2; --  <= (<) ROWNUM을 1부터 순차적으로 조회하는 경우는 가능

SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 1 AND 20;

--SELECT 절과 ORDER BY 구문의 실행순서
--SELECT --> ROWNUM --> ORDER BY
SELECT ROWNUM, empno, ename
FROM emp
ORDER BY ename;

--IMLINE VIEW를 통해 정렬 먼저 실행하고, 해당 결과에 ROWNUM을 적용
-- *표현하고, 다른컬럼 혹은 표현식을 썼을 경우
-- * 앞에 테이블 명이나, 테이블 별칭을 적용
SELECT ROWNUM, a.*
FROM (SELECT empno,ename
FROM emp
ORDER BY ename) a;

--row1
SELECT ROWNUM RN, empno, ename
FROM emp
WHERE ROWNUM <=10;

--row2 (ROWNUM이 11~14인데이터)
--ROWNUM BETWEEN 11 AND 14

SELECT a.* 
FROM
    (SELECT ROWNUM RN, empno, ename
     FROM emp) a
WHERE RN BETWEEN 11 AND 20;

--row3
--emp 테이블에서 ename으로 정렬한 결과의 11번째 행과 14번째 행만조회 하는
--쿼리를 작성해보세요 (empno, ename 컬럼과 행번호만 조회)

SELECT a.* 
FROM
    (SELECT ROWNUM RN, ename, empno
     FROM emp) a
WHERE RN = 11
OR RN = 14;

--row 4
--emp 테이블의 사원 정보를 이름컬럼으로 오름차순 적용 했을 때
--11~14번쨰 행을 다음과 같이 조회하는 쿼리를 작성해보세요
SELECT *
FROM
(SELECT ROWNUM RN,a.*
FROM
    (SELECT empno, ename
    FROM emp
    ORDER BY ename)a)
WHERE RN BETWEEN 11 AND 14;

SELECT ROWNUM
FROM emp;
