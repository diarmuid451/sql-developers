--ROUND, TRUNC
--(MONTHS_BETWEEN) ADD_MONTHS, NEXT_DAY

--월 : 1, 3, 5, 7, 8, 10, 12 : 31일
-- : 2 --윤년

--function(date 종합 실습 fn3)
--파라미터로 yyyymm형식의 문자열을 사용 하여(ex: yyyymm = 201912 
--해당 년월에 해당하는 일자 수를 구해보세요


SELECT  :yyyymm  PARAM
        ,TO_CHAR(LAST_DAY(TO_DATE(:yyyymm , 'YYYYMM')) , 'DD')DT
--'201912' -> date 타입으로 변경
-- 해당 날짜의 마지막날짜로 이동
--일자 필드만 추출하기
--DATE -> 일자컬럼(DD)만 추출
--DATE -> 문자열(DD)
--TO_CHAR(DATE, '포맷')

FROM dual;


--SYSDATE를 YYYY/MM/DD 포맷의 문자열로 변경 (DATE -> CHAR)
--'2019/11/26' 문자열 --> DATE
SELECT  TO_CHAR(SYSDATE, 'YYYY/MM/DD') TODAY ,TO_DATE(TO_CHAR(SYSDATE, 'YYYY/MM/DD') ,'YYYY/MM/DD') TODAY_DATE
        -- YYYY-MM-DD HH24:MI:SS 문자열로 변경
        ,TO_CHAR(TO_DATE(TO_CHAR(SYSDATE, 'YYYY/MM/DD'), 'YYYY/MM/DD'), 'YYYY-MM-DD HH24:MI:SS') TODAY_DATE_CHAR 
FROM dual;

--EMPNO  NOT NULL NUMBER(4)
--HIREDATE        DATE

DESC emp;
--empno가 7369인 직원 정보 조회 하기
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = '7369';

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 3956160932
 
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     3 |   261 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     3 |   261 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("EMPNO"=7369)
 

SELECT *
FROM emp
WHERE TO_CHAR(empno) = '7369';

SELECT *
FROM TABLE(dbms_xplan.display);



SELECT *
FROM emp
WHERE empno = 7300 + '69'; -- 69 ->숫자로 변경

SELECT *
FROM TABLE(dbms_xplan.display);


--
SELECT *
FROM emp
WHERE hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');


SELECT *
FROM emp
WHERE hiredate >= '81/06/01';  


--DATE타입의 묵시적 형변환은 사용을 권하지 않음
--TO_DATE('81/06/01', 'RR/MM/DD'); 
--YY : 1900년대 / RR : 50년대 기준으로 이상이면 1900년대, 이하라면 2000년대로 표기
SELECT  TO_DATE('50/05/05', 'RR/MM/DD')
        ,TO_DATE('49/05/05', 'RR/MM/DD')
        ,TO_DATE('50/05/05', 'YY/MM/DD')
        ,TO_DATE('49/05/05', 'YY/MM/DD')
FROM dual;  

--숫자 -> 문자열
--문자열 -> 숫자
--숫자 : 1000000  -> 1,000,000.00(한국) / 1.000.000,00(독일)       
--날짜 포맷 : YYYY, MM, DD, HH24, MI, SS
--숫자 포맷 : 숫자 표현(9), 자리맞춤을 위한 표시(0), 화폐단위(L), 1000단위(,), 소수점(.)
--숫자 -> 문자열 TO_CHAR(숫자, '포맷')
--숫자 포맷이 길어질 경우 숫자 자리수를 충분히 표현
SELECT empno, ename, sal, TO_CHAR(sal, 'L009,999') fm_SAL
FROM emp;


SELECT TO_CHAR(10000000000, '999,999,999,999,999,999') 뿌스로다
FROM dual;


--NULL 처리 함수 : NVL, NVL2, NULLIF, COALESCE

--NVL(expr1, expr2) : 함수인자 2개
--expr1이 NULLdlaus expr2를 반환
--expr1이 NULL이 아니면 expr1을 반환
SELECT empno, ename, comm, NVL(comm, -1) nvl_comm
FROM emp;

--NVL2(expr1, expr2, expr3)
--expr1 IS NOT NULL : expr2 리턴
--exprl IS NULL : expr3 리턴
SELECT  empno, ename, comm, NVL2(comm, 1000, -500) nv2_comm
        ,NVL2(comm, comm, -500) nv2a_comm --NVL과 동일한 결과
FROM emp;

--NULLIF(expr1, expr2)
--expr1 = expr2 NULL을 리턴
--expr1 != expr2 expr1을 리턴
--comm이 null일때 comm+500 = null -> expr1 = expr2 -> null
SELECT  empno, ename, comm, NULLIF(comm, comm+500) nullif_comm
FROM emp;

--COALESCE(expr1, expr2, expr3...)
--인자중에 첫번째로 등장하는 NULL이 아닌 exprN을 리턴
--expr1 is not null -> exril을 리턴
--expr1 is null -> COALESCE(expr2, expr3, expr4...)