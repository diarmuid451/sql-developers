--ROUND, TRUNC
--(MONTHS_BETWEEN) ADD_MONTHS, NEXT_DAY

--�� : 1, 3, 5, 7, 8, 10, 12 : 31��
-- : 2 --����

--function(date ���� �ǽ� fn3)
--�Ķ���ͷ� yyyymm������ ���ڿ��� ��� �Ͽ�(ex: yyyymm = 201912 
--�ش� ����� �ش��ϴ� ���� ���� ���غ�����


SELECT  :yyyymm  PARAM
        ,TO_CHAR(LAST_DAY(TO_DATE(:yyyymm , 'YYYYMM')) , 'DD')DT
--'201912' -> date Ÿ������ ����
-- �ش� ��¥�� ��������¥�� �̵�
--���� �ʵ常 �����ϱ�
--DATE -> �����÷�(DD)�� ����
--DATE -> ���ڿ�(DD)
--TO_CHAR(DATE, '����')

FROM dual;


--SYSDATE�� YYYY/MM/DD ������ ���ڿ��� ���� (DATE -> CHAR)
--'2019/11/26' ���ڿ� --> DATE
SELECT  TO_CHAR(SYSDATE, 'YYYY/MM/DD') TODAY ,TO_DATE(TO_CHAR(SYSDATE, 'YYYY/MM/DD') ,'YYYY/MM/DD') TODAY_DATE
        -- YYYY-MM-DD HH24:MI:SS ���ڿ��� ����
        ,TO_CHAR(TO_DATE(TO_CHAR(SYSDATE, 'YYYY/MM/DD'), 'YYYY/MM/DD'), 'YYYY-MM-DD HH24:MI:SS') TODAY_DATE_CHAR 
FROM dual;

--EMPNO  NOT NULL NUMBER(4)
--HIREDATE        DATE

DESC emp;
--empno�� 7369�� ���� ���� ��ȸ �ϱ�
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
WHERE empno = 7300 + '69'; -- 69 ->���ڷ� ����

SELECT *
FROM TABLE(dbms_xplan.display);


--
SELECT *
FROM emp
WHERE hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');


SELECT *
FROM emp
WHERE hiredate >= '81/06/01';  


--DATEŸ���� ������ ����ȯ�� ����� ������ ����
--TO_DATE('81/06/01', 'RR/MM/DD'); 
--YY : 1900��� / RR : 50��� �������� �̻��̸� 1900���, ���϶�� 2000���� ǥ��
SELECT  TO_DATE('50/05/05', 'RR/MM/DD')
        ,TO_DATE('49/05/05', 'RR/MM/DD')
        ,TO_DATE('50/05/05', 'YY/MM/DD')
        ,TO_DATE('49/05/05', 'YY/MM/DD')
FROM dual;  

--���� -> ���ڿ�
--���ڿ� -> ����
--���� : 1000000  -> 1,000,000.00(�ѱ�) / 1.000.000,00(����)       
--��¥ ���� : YYYY, MM, DD, HH24, MI, SS
--���� ���� : ���� ǥ��(9), �ڸ������� ���� ǥ��(0), ȭ�����(L), 1000����(,), �Ҽ���(.)
--���� -> ���ڿ� TO_CHAR(����, '����')
--���� ������ ����� ��� ���� �ڸ����� ����� ǥ��
SELECT empno, ename, sal, TO_CHAR(sal, 'L009,999') fm_SAL
FROM emp;


SELECT TO_CHAR(10000000000, '999,999,999,999,999,999') �ѽ��δ�
FROM dual;


--NULL ó�� �Լ� : NVL, NVL2, NULLIF, COALESCE

--NVL(expr1, expr2) : �Լ����� 2��
--expr1�� NULLdlaus expr2�� ��ȯ
--expr1�� NULL�� �ƴϸ� expr1�� ��ȯ
SELECT empno, ename, comm, NVL(comm, -1) nvl_comm
FROM emp;

--NVL2(expr1, expr2, expr3)
--expr1 IS NOT NULL : expr2 ����
--exprl IS NULL : expr3 ����
SELECT  empno, ename, comm, NVL2(comm, 1000, -500) nv2_comm
        ,NVL2(comm, comm, -500) nv2a_comm --NVL�� ������ ���
FROM emp;

--NULLIF(expr1, expr2)
--expr1 = expr2 NULL�� ����
--expr1 != expr2 expr1�� ����
--comm�� null�϶� comm+500 = null -> expr1 = expr2 -> null
SELECT  empno, ename, comm, NULLIF(comm, comm+500) nullif_comm
FROM emp;

--COALESCE(expr1, expr2, expr3...)
--�����߿� ù��°�� �����ϴ� NULL�� �ƴ� exprN�� ����
--expr1 is not null -> exril�� ����
--expr1 is null -> COALESCE(expr2, expr3, expr4...)