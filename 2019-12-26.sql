--EXCEPTION
--에러 발생시 프로그램을 종료시키지 않고 해당 예외에 대해 다른 로직을 실행 시킬 수 있게 처리
--예외가 발생했는데 예외처리가 없는 경우 : PL/SQL 블록이 에러와 함께 종료 된다.
--여러건의 SELECT 결과가 존재하는 상황에서 스칼라 변수에 값을 넣는 상황

set SERVEROUTPUT on;
--emp 테이블에서 사원 이름을 조회
DECLARE
    --사원 이름을 저장할 수 있는 변수
    v_ename emp.ename%type;
BEGIN
    --14건의 select 결과가 나오는 sql >> 스칼라 변수에 저장이 불가능하다.
    select ename INTO v_ename from emp;
EXCEPTION
    /*when TOO_MANY_ROWS then
    DBMS_OUTPUT.PUT_LINE('여러건의 select 결과가 존재'); */
    when OTHERS then
    dbms_output.put_line('WHEN OTHERS');
END;
/

--사용자 정의 예외
--오라클에서 사전에 정의한 예외 이외에도 개발자가 해당 사이트에서 비지니스 로직으로 정의한 예외를 생성, 사용 가능
--예를 들어 select 결과가 없는 상황에서 오라클에서는 NO_DATA_FOUND 예외를 던지면 
--해당 예외를 잡아 개발자가 정의한 NO_EMP 예외로 재정의 하여 예외를 던질 수 있다.

DECLARE
    --emp 테이블 조회 결과가 없을때 사용할 사용자 정의 예외
    --예외명 EXCEPTION
    no_emp EXCEPTION;
    v_ename emp.ename%type;
BEGIN
    --NO_DATA_FOUND
    BEGIN
        select ename into v_ename 
        from emp where empno = 7000;
    EXCEPTION
        when NO_DATA_FOUND then
            RAISE no_emp; --java에서의 throw new NOEmpException();
    END;
EXCEPTION 
    when no_emp then
    dbms_output.put_line('NO_EMP');
END;
/

--사번을 입력받아서 해당 직원의 이름을 리턴하는 함수
--getEmpName(7369) >> SMITH
create or replace function getEmpName(p_empno emp.empno%type)
return varchar2
IS      v_ename emp.ename%type;
BEGIN 
    select ename into v_ename
    from emp where empno = p_empno;
    RETURN v_ename;
END;
/

select getEmpName(7369) from dual;


--실습 function1
create or replace function getdeptname(p_deptno DEPT.DEPTNO%type)
return varchar2
IS v_dname dept.dname%type;
BEGIN
    select dname into v_dname
    from dept where p_deptno = deptno;
    RETURN v_dname;
END;
/

--cache : 20
--데이터 분포도 :
--deptno (중복 발생 가능) : 분포도가 좋지 못하다.
--empno (중복 없음) : 분포도가 좋다.

--emp 테이블의 데이터가 100만건인 경우 : 100건중에서 deptno의 종류는 4건(10~40)
select  getdeptname(deptno),    --4가지
        getempname(empno)       --row 수만큼 데이터가 존재
from emp;

--실습 function2

desc dept_h;
create or replace function indent(p_deptnm dept_h.deptnm%type,v_lv NUMBER)
return varchar2
IS v_deptnm DEPT_H.DEPTNM%TYPE;
BEGIN
    select lpad(' ',(v_lv-1)*4,' ') || p_deptnm into v_deptnm
    from dual;
    return v_deptnm;
END;
/



select deptcd, lpad(' ',(level-1)*4,' ')|| deptnm deptnm
from dept_h
start with P_deptcd IS NULL
connect by prior deptcd = p_deptcd;

select deptcd, indent(deptnm,level) deptnm
from dept_h
start with P_deptcd IS NULL
connect by prior deptcd = p_deptcd;

CREATE OR REPLACE PACKAGE names as
function getEmpname(p_empno emp.empno%type) return VARCHAR2;
function getdeptname(p_deptno DEPT.DEPTNO%TYPE) return VARCHAR2;
function indent (p_deptnm dept_h.deptnm%type,v_lv NUMBER) return varchar2;
END names;
/

create or replace PACKAGE BODY names AS
function getEmpname(p_empno emp.empno%type) return VARCHAR2 
IS
v_ename emp.ename%type;
BEGIN
    select ename into v_ename 
    from emp where empno = p_empno;
    RETURN v_ename;
    END;
FUNCTION getdeptname(p_deptno dept.deptno%type) return VARCHAR2 
IS
v_dname dept.dname%type;
BEGIN
    select dname into v_dname 
    from dept where deptno = p_deptno;
    RETURN v_dname;
    END;
function indent(p_deptnm dept_h.deptnm%type,v_lv NUMBER)
return varchar2
IS v_deptnm DEPT_H.DEPTNM%TYPE;
BEGIN
    select lpad(' ',(v_lv-1)*4,' ') || p_deptnm into v_deptnm
    from dual;
    return v_deptnm;
END;    
END;
/

select NAMES.GETEMPNAME(empno), NAMES.GETDEPTNAME(deptno) 
from emp;

--실습 pak1
select NAMES.INDENT(deptnm,level) deptnm from dept_h
start with P_deptcd IS NULL
connect by prior deptcd = p_deptcd;

--실습 pak2







--users 테이블의 비밀번호 컬럼이 변경됐을 때 기존에 사용하던 비밀번호 컬럼 이력을 관리하기 위한 테이블
CREATE TABLE users_history(
userid VARCHAR2(20), pass VARCHAR2(100), mod_dt DATE);

select * from users_history;
