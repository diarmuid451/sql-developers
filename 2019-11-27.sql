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
--�ǰ����� ����� ��ȸ ����
--1. ���س⵵�� ¦��/ Ȧ�� ����


--1. TO_CHAR(SYSDATE, 'yyyy'
--> ���س⵵ ���� (0 : ¦����, 1: Ȧ����)
SELECT TO_CHAR(SYSDATE, 'yyyy')+1, MOD(TO_CHAR(SYSDATE, 'YYYY')+1, 2)
FROM dual;

--2.
-- �߰�����: ���⵵ �ǰ����� ����ڸ� ��ȸ�ϴ� ������ �ۼ��غ�����
--2020�⵵
SELECT empno, ename, hiredate,
        CASE
                WHEN MOD(TO_CHAR(hiredate, 'YYYY'),2) =
                     MOD(TO_CHAR(SYSDATE, 'YYYY'),2) THEN '�ǰ����� �����'
                WHEN MOD(TO_CHAR(hiredate, 'YYYY'),2) =
                     MOD(TO_CHAR(SYSDATE, 'YYYY')+1,2) THEN '���⵵ �ǰ����� �����'
                ELSE '�ǰ����� ������'
        END contact_to_doctor
FROM emp;

--cond3,
SELECT a.userid, a.usernm, a.alias, a.yyyy,        
        CASE
            WHEN MOD(a.yyyy, 2) = MOD(a.this_yyyy,2) THEN '�ǰ����� �����' 
            ELSE '�ǰ����� ������' 
        END CONTACTODOCTOR
FROM 
(SELECT userid, usernm, ALIAS, TO_CHAR(reg_dt ,'YYYY') yyyy, TO_CHAR(SYSDATE, 'YYYY') this_yyyy FROM users) a;

--GROUP FUNCTION
--Ư�� �÷��̳�, ǥ���� �������� �������� ���� �� ���� ����� ����
--COUNT-�Ǽ�, SUM-�հ�, AVG-���, MAX-�ִ밪, MIN-�ּҰ�
--��ü ������ ������� (14���� -> 1��)
DESC emp;
SELECT MAX(sal) max_sal --���� ���� �޿�
        ,MIN(sal) min_sal --���� ���� �޿�
        ,ROUND(AVG(sal), 2) avg_sal -- �� ������ �޿� ���
        ,SUM(sal) sum_sal --�� ������ �޿� �հ�
        ,COUNT(sal) count_sal --�޿� �Ǽ�(null�� �ƴ� ���̸� 1��)
        ,COUNT(mgr) count_mgr --������ ������ �Ǽ�(KING�� ��� MGR�� ����)
        ,COUNT(*) count_row--Ư�� �÷��� �Ǽ��� �ƴ϶� ���� ������ �˰� ������
FROM emp;


--�μ���ȣ�� �׷��Լ� ����
SELECT deptno
        ,MAX(sal) max_sal --�μ����� ���� ���� �޿�
        ,MIN(sal) min_sal --�μ��������� ���� �޿�
        ,ROUND(AVG(sal), 2) avg_sal --�μ� ������ �޿� ���
        ,SUM(sal) sum_sal --�μ� ������ �޿� �հ�
        ,COUNT(sal) count_sal --�μ� �޿� �Ǽ�(null�� �ƴ� ���̸� 1��)
        ,COUNT(mgr) count_mgr --�μ� ������ ������ �Ǽ�(KING�� ��� MGR�� ����)
        ,COUNT(*) count_row--�μ��� ������ ��
FROM emp
GROUP BY deptno, ename;

--SELECT ������ GRUOP BY ���� ���� �÷��� ���� �� ����
--�������� �������� �ʴ�
SELECT deptno, ename
        ,MAX(sal) max_sal --�μ����� ���� ���� �޿�
        ,MIN(sal) min_sal --�μ��������� ���� �޿�
        ,ROUND(AVG(sal), 2) avg_sal --�μ� ������ �޿� ���
        ,SUM(sal) sum_sal --�μ� ������ �޿� �հ�
        ,COUNT(sal) count_sal --�μ� �޿� �Ǽ�(null�� �ƴ� ���̸� 1��)
        ,COUNT(mgr) count_mgr --�μ� ������ ������ �Ǽ�(KING�� ��� MGR�� ����)
        ,COUNT(*) count_row--�μ��� ������ ��
FROM emp
GROUP BY deptno, ename;

--�׷��Լ������� NULL �÷��� ��꿡�� ���ܵȴ�.
--emp���̺��� comm�÷��� null�� �ƴ� �����ʹ� 4���� ����, 9���� null
SELECT  COUNT(comm) count_comm  --NULL�� �ƴ� ���� ����
        ,SUM(comm) sum_comm --NULL���� ����, 300+500+1400+0 = 2200
        ,SUM(sal + comm) tot_sal_sum
        ,SUM(sal + NVL(comm, 0)) tot_sal_sum1
FROM emp;


--WHERE ������ GROUP �Լ��� ǥ�� �� �� ����
--1.�μ��� �ִ� �޿� ���ϱ�
--2.�μ��� �ִ� �޿� ���� 3000�� �Ѵ� �ุ ���ϱ�
--deptno, �ִ�޿�
SELECT deptno, MAX(sal) m_sal
FROM emp
WHERE MAX(sal) > 3000  --ORA-00934: WHERE������ GROUP�Լ��� �� �� ����
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
--1. ���̺� ��������(�÷� �߰�)
--2. �߰��� �÷��� ���� UPdate
--dname �÷��� emp ���̺� �߰�
DESC emp;
select * from emp;
DESC dept;

--�÷��߰�(dname, VARCHAR2(14)

ALTER TABLE emp ADD (dname VARCHAR2(14));

UPDATE emp SET dname = CASE
                        WHEN deptno = 10 THEN 'ACCOUNTING'
                        WHEN deptno = 20 THEN 'RESEARCH'
                        WHEN deptno = 30 THEN 'SALES'
                    END
where dname is null;
COMMIT;

--SLAES --> MARKET SALES
--�� 6���� ������ ������ �ʿ��ϴ�
-- ���� �ߺ��� �ִ� ����(�� ������)
UPDATE emp SET dname = 'MARKET SALES'
WHERE dname = 'SALES';

--emp ���̺�, dept ���̺� ����
SELECT ename, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;