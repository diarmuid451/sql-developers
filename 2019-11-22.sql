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

--desc emp;  ���� (��) <��ȣ ���� ���� ����

--������ �켱���� (AND > OR)
--���� �̸��� SMITH �̰ų�, �����̸��� ALLEN�̸鼭 ��Ȱ�� SALESMAN�� ����
SELECT *
FROM emp
WHERE ename = 'SMITH'
OR enmae = 'ALLEN'
AND job = 'SALESMAN';

SELECT *
FROM emp
WHERE ename = 'SMITH'
OR (enmae = 'ALLEN'AND job = 'SALESMAN');

--���� �̸��� SMIITH�̰ų� ALLEN �̸鼭 ��Ȱ�� SALESMAN�� ���

SELECT *
FROM emp
WHERE (ename = 'SMITH' OR ename = 'ALLEN')
AND job = 'SALESMAN';

desc emp;

--where 14
--job�� SALESMAN �̰ų� �����ȣ�� 78�� �����ϸ鼭, �Ի����ڰ� 1981�� 6�� 1�� ����
SELECT *
FROM emp
WHERE (job = 'SALESMAN' OR empno BETWEEN 7800 AND 7899)
AND hiredate >= TO_DATE ('19810601', 'YYYYMMDD');

ORDER BY ename 

-- �������� : ASC(ǥ�� ���Ұ�� �⺻��)
-- �������� : DESC(���������� �ݵ�� ǥ��)

/*
    SELECT col1.col2
    FORM ���̺��
    WHERE col1 = '��'
    ORDER BY ���ı��� �÷�1[asc / desc] , ���ı��� �÷�2 ......[ASC / DESC]
*/    
-- ���(emp) ���̺��� ������ ������ ���� �̸�(ename) ���� �������� ����
SELECT *
FROM emp
ORDER BY ename;

SELECT *
FROM emp
ORDER BY ename ASC;

-- ���(emp) ���̺��� ������ ������ ���� �̸�(ename) ���� �������� ����
SELECT *
FROM emp
ORDER BY ename DESC;

-- ���(emp) ���̺��� ������ ������ �μ���ȣ�� �������� �����ϰ�
-- �μ���ȣ�� ���� ���� sal �������� ����
-- �޿�(SAL)�� �������� �Ϲ����� �������� ���� �Ѵ�
SELECT  *
FROM emp
ORDER BY deptno ASC, sal DESC, ename;

--���� �÷��� ALLAS�� ǥ��
SELECT deptno, sal, ename nm
FROM emp
ORDER BY nm; 

--��ȸ�ϴ� �÷��� ��ġ �ε����� ǥ�� ����
SELECT deptno, sal, ename nm
FROM emp
ORDER BY 3; --1,2,3 �� ��ġ ���� ���� �׷��� ��õ������ ���� �÷� ������������� �ǵ�ġ ���� ������ ����

--oderby 1
--dept ���̺��� ��� ������ �μ��̸����� ������������
SELECT *
FROM dept
ORDER BY dname;

--oderby2
--emp ���̺��� �������� �ִ� ����鸸 ��ȸ
--�󿩸� ���� �޴� ����� ���� ��ȸ�ǵ��� (��������)
--�󿩰� ���� ��� ������� ��������

SELECT *
FROM emp
WHERE comm IS NOT NULL
AND comm != 0
ORDER BY comm desc, empno;

--oderby3
--emp ���̺��� �����ڰ� �ִ� ������ ��ȸ�ϰ� MGR NULL�� �ƴ� ������
--����(job)������ �������� ����
--������ ���� ��� �����ȣ�� ū����� ���� ��ȸ�ǵ��� (��������)
SELECT *
FROM emp
WHERE MGR IS NOT NULL
ORDER BY job, empno desc;

--oderby4
--emp ���̺��� �μ���ȣ�� 10�� Ȥ�� 30�� �μ��� ���ϴ� �����
--�޿��� 1500�� �Ѵ� ����� ��ȸ
--�̸����� ��������(DESC)

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
WHERE ROWNUM = 2; -- ROWNUM = equal �񱳴� 1�� ����

SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM <= 2; --  <= (<) ROWNUM�� 1���� ���������� ��ȸ�ϴ� ���� ����

SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 1 AND 20;

--SELECT ���� ORDER BY ������ �������
--SELECT --> ROWNUM --> ORDER BY
SELECT ROWNUM, empno, ename
FROM emp
ORDER BY ename;

--IMLINE VIEW�� ���� ���� ���� �����ϰ�, �ش� ����� ROWNUM�� ����
-- *ǥ���ϰ�, �ٸ��÷� Ȥ�� ǥ������ ���� ���
-- * �տ� ���̺� ���̳�, ���̺� ��Ī�� ����
SELECT ROWNUM, a.*
FROM (SELECT empno,ename
FROM emp
ORDER BY ename) a;

--row1
SELECT ROWNUM RN, empno, ename
FROM emp
WHERE ROWNUM <=10;

--row2 (ROWNUM�� 11~14�ε�����)
--ROWNUM BETWEEN 11 AND 14

SELECT a.* 
FROM
    (SELECT ROWNUM RN, empno, ename
     FROM emp) a
WHERE RN BETWEEN 11 AND 20;

--row3
--emp ���̺��� ename���� ������ ����� 11��° ��� 14��° �ุ��ȸ �ϴ�
--������ �ۼ��غ����� (empno, ename �÷��� ���ȣ�� ��ȸ)

SELECT a.* 
FROM
    (SELECT ROWNUM RN, ename, empno
     FROM emp) a
WHERE RN = 11
OR RN = 14;

--row 4
--emp ���̺��� ��� ������ �̸��÷����� �������� ���� ���� ��
--11~14���� ���� ������ ���� ��ȸ�ϴ� ������ �ۼ��غ�����
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
