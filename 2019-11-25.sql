--row_1 : emp���̺���(empno,ename) ���ľ��� ROWNUM�� 1~10�� �ุ ��ȸ

SELECT empno, ename
FROM emp;
WHERE ROWNUM BETWEEN 1 AND 10;

--row_2 : emp���̺���(empno,ename) ���ľ��� ROWNUM�� 11~14�� �ุ ��ȸ
SELECT ROWNUM, a.*
FROM
(SELECT rn,empno, ename
FROM emp) a
WHERE rn BETWEEN 11 AND 14;

--row_3 emp ���̺��� ename�÷� �������� �������� ���� ������ 11~14��° ���� �����͸� ��ȸ�ϴ� sql�� �ۼ��ϼ���
 SELECT rn, empno, ename
 FROM
   (SELECT ROWNUM rn, a.*
    FROM
        (SELECT empno, ename
        FROM emp
        ORDER BY ename) a)
WHERE rn BETWEEN 11 AND 14

--DUAL ���̺� : sys ������ �ִ� ������ ��� ������ ���̺��̸� �� �ุ �����ϸ� �÷�(dummy)�� �ϳ��� ����('X')

SELECT *
FROM dual;

--SINGLE ROW FUNCTION : ��� �ѹ��� FUNCTION�� ����
--1���� �� INPUT -> 1���� ������ OUTPUT (COLUMN)
--'Hello, World'

SELECT LOWER('Hello, World'), UPPER('Hello, World'), INITCAP('Hello, World')
FROM dual;

--emp���̺��� �� 14���� ������(����)�� ���� (14���� ��)
--�Ʒ������� ����� 14���� ��

SELECT emp.*, LOWER('Hello, World'), UPPER('Hello, World'), INITCAP('Hello, World')
FROM emp;

--�÷��� function ����
SELECT empno, LOWER(ename) low_enm
FROM emp
WHERER ename = UPPER('SMITH'); --���� �̸��� smith�� ����� ��ȸ�Ϸ��� �빮��/�ҹ���?

--���̺� �÷��� �����ص� ������ ����� ���� �� ������ ���̺� �÷� ���ٴ� ������� �����ϴ� ���� �ӵ��鿡�� ����
--�ش� �÷��� �ε����� �����ϴ��� �Լ��� �����ϰԵǸ� ���� �޶����� �Ǿ� �ε����� Ȱ�� �� �� ���� �ȴ�
--���� : FBI(Function Based Index)
SELECT empno, LOWER(ename) low_enm
FROM emp
WHERE LOWER(ename) = 'smith' ; --���� �̸��� smith�� ����� ��ȸ�Ϸ��� �빮��/�ҹ���?

--'HELLO'
--','
--'WORLD'
--HELLO, WORLD (�� 3���� ���ڿ� ����� �̿�, CONCAT �Լ��� ����Ͽ� ���ڿ� ����)
SELECT CONCAT(CONCAT('HELLO', ', '), 'WORLD') c1,
       'HELLO' || ', ' || 'WORLD' c2,
       
       --�����ε����� 1����, �����ε��� ���ڿ����� �����Ѵ�
       SUBSTR('HELLO, WORLD', 1, 5) s1, --SUBSTR(���ڿ�, �����ε���, �����ε���)

       --INSTR : ���ڿ��� Ư�� ���ڿ��� �����ϴ���, ������ ��� ������ �ε����� ����
       INSTR('HELLO, WORLD', 'O') i1, --5, 9
       --'HELLO. WORLD'���ڿ��� 6��° �ε��� ���Ŀ� �����ϴ� 'O'���ڿ��� �ε��� ����
       INSTR('HELLO, WORLD', 'O', 6) i2, --���ڿ��� Ư�� �ε��� ���ĺ��� �˻� �ϵ��� �ɼ� ��

       INSTR('HELLO, WORLD', 'O',  INSTR('HELLO, WORLD', 'O') +1 ) i3,

        --L/RPAD Ư�� ���ڿ��� ����/�����ʿ� ������ ���ڿ� ���̺��� ������ ��ŭ ���ڿ��� ä�� �ִ´�.
        LPAD('HELLO, WORLD', 15, '*') L1,
        RPAD('HELLO, WORLD', 15, '*') R1,
        LPAD('HELLO, WORLD ', 15) L2, --DEFAULT ä�� ���ڴ� �����̴�
        RPAD('HELLO, WORLD', 15)R2,
        --REPLACE(����ڿ�, �˻� ���ڿ�, ������ ���ڿ�)
        --����ڿ����� �˻� ���ڿ��� ������ ���ڿ��� ġȯ
        REPLACE('HELLO, WORLD', 'HELLO', 'hello') rep1,
        
        --���ڿ� ��, ���� ������ ����
        '   HELLO, WORLD   ' before_trim,
        TRIM('   HELLO, WORLD   ') after_trim,
        TRIM('H' FROM 'HELLO, WORLD') after_trim2
FROM dept;

--���� �����Լ�
--ROUND : �ݿø� - ROUND(����, �ݿø� �ڸ�)
--TRUNC : ���� - TRUNC(����, ���� �ڸ�)
--MOD : ������ ���� MOD(������, ����) //MOD(5, 2) : 1


SELECT ROUND(105.54, 1) r1, --�ݿø������ �Ҽ��� ù°�ڸ����� ��������(�Ҽ��� ��°�ڸ����� �ݿø�)
       ROUND(105.55, 1) r2,
       ROUND(105.55, 0) r3, --�Ҽ��� ù°�ڸ����� �ݿø�
       ROUND(105.55, -1) r4 --���� ù��° �ڸ����� �ݿø�
FROM dual;

SELECT TRUNC(105.54, 1) t1, --���� ����� �Ҽ��� ù°�ڸ����� ��������(�Ҽ��� ��°�ڸ����� ����)
       TRUNC(105.55, 1) t2,
       TRUNC(105.55, 0) t3, --�Ҽ��� ù°�ڸ����� ����
       TRUNC(105.55, -1) t4 --���� ù��° �ڸ����� ����
FROM dual;

--MOD(������a, ����b) a/b�� ������ ��c
--MOD(M, 2)�� ��� ���� : 0, 1(C = 0 ~ b-1)
SELECT MOD(5, 2) m1 -- 5/2 : ���� 2, [�������� 1]
FROM dual;

--emp ���̺��� sal �÷��� 1000���� �������� ����� ������ ���� ��ȸ�ϴ� sql �ۼ�
--ename, sal, sal/1000�� ���� ��, sal/1000�� ���� ������

SELECT ename, sal,TRUNC(sal/1000) quo1, MOD(sal, 1000) rem1, TRUNC(sal/1000) *1000 + MOD(sal, 1000) sal2
FROM emp;

--DATE : �����, �ð�, ��, ��
SELECT ename, hiredate, TO_CHAR(hiredate, 'YYYY-MM-DD hh12-mi-ss') hir1   --YYYY/MM/DD
FROM emp;

--SYSDATE : ������ ���� DATE�� �����ϴ� �����Լ�, Ư���� ���ڰ� ����
--DATE ���� DATE + ����N = DATE�� N���� ��ŭ ���Ѵ�
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD hh24:mi:ss') t1
FROM dual;
