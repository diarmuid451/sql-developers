--실습 PRO_3
create or REPLACE PROCEDURE UPDATEdept_test
(upd_deptno IN dept_test.deptno%TYPE, 
upd_dname IN dept_test.dname%TYPE, 
upd_loc IN dept_test.loc%TYPE)
IS -- 선언부
  
BEGIN --로직
   UPDATE dept_test set dept_test.dname = upd_dname, dept_test.loc = upd_loc
   where dept_test.deptno = upd_deptno;
    commit;
END;
/

exec UPDATEdept_test(99, 'ddit_m','daejeon');


SET SERVEROUTPUT ON;
DECLARE --dept 테이블의 row정보를 담을 수 있는 rowtype 변수 선언
    dept_row dept %rowtype;
BEGIN
    select * into dept_row 
    from  dept where deptno = 10;
    
    DBMS_OUTPUT.PUT_LINE ('dept_row : '||dept_row.dname||','||dept_row.loc);

END;
/

--RECORD TYPE : 개발자가 컬럼을 직접 선언하여 개발에 필요한 TYPE을 생성
DECLARE --부서이름, LOC 정보를 저장할 수 있는 RECORD TYPE 선언
--TYPE 타입이름 IS RECORD( 컬럼1 컬럼타입type, 컬럼2 컬럼2 type);
TYPE dept_row IS RECORD(dname dept.dname %type, loc dept.loc %type); --TYPE 선언 완료, type을 갖고 변수를 생성
rec_row dept_row;
BEGIN
    select dname, loc INTO rec_row
    from dept
    where deptno = 10;
    
    DBMS_OUTPUT.PUT_LINE('dept_row : '||rec_row.dname||','||rec_row.loc);
END;
/

--table type : 여러개의 rowtype을 저장할 수 있는 type
-- col >> row >> table
-- type 테이블타입명 IS TABLE OF ROWTYPE/RECORD INDEX BY 인덱스 타입(BINARY_INTEGER)
-- 인덱스를 숫자 뿐만 아니라 문자열 형태로도 저장 가능하기 때문에 index에 대한 타입을 명시한다.


--dept 테이블의 row를 여럿 저장 할 수 있는 dept_tab TABLE TYPE 선언하여 select * from dept의 결과(여러건)를 변수에 담는다.
DECLARE 
TYPE dept_tab IS TABLE OF dept %ROWTYPE index by BINARY_INTEGER;
v_dept dept_tab;
BEGIN
    --한 row의 값을 변수에 저장 : INTO
    --복수 row의 값을 변수에 저장 : BULK COLLECT INTO
    select *  bulk collect INTO v_dept from dept;
    
    
    FOR i IN 1..v_dept.count LOOP
        DBMS_OUTPUT.PUT_LINE('dept_row : '||v_dept(i).deptno||','||v_dept(i).dname);
    END LOOP;
END;
/


--로직 제어 IF
--IF condition THEN statement
--ELSIF condition THEN statement
--ELSE statement 
--END IF;

--PL/SQL IF 실습
--변수 p(NUMBER)에 2라는 값을 할당하고 IF 구문을 통해 p의 값이 1, 2, 그 밖의 값일 떄 텍스트 출력
DECLARE
    --p NUMBER;  변수 선언
    p NUMBER := 2; --변수 선언과 할당을 동시에
BEGIN
    --p := 2; 변수 할당
    IF p = 1 then
        DBMS_OUTPUT.PUT_LINE('p = 1');
    ELSIF p = 2 then
        DBMS_OUTPUT.PUT_LINE('p = '||p);
    ELSE  
        DBMS_OUTPUT.PUT_LINE('p = ' ||p);
    END IF;
 END;
/

-- FOR LOOP 
-- FOR 인덱스변수 IN [REVERSE] START.. END LOOP
--      반복실행문
-- END LOOP;
--0~5까지 루프 변수를 이용하여 반복문 실행

DECLARE
BEGIN
    FOR i IN 0..5 LOOP
    DBMS_OUTPUT.PUT_LINE('for i = '|| i);
    end LOOP;
END;
/

--1~10 까지의 합을 loop를 이용하여 계산, 결과를 s_val 이라는 변수에 담아 
--dbms_output.put_line 함수를 통해 화면에 출력

DECLARE
    s_val NUMBER := 0;
BEGIN
    FOR i IN 1..100 LOOP
    s_val := s_val + i;
    DBMS_OUTPUT.PUT_LINE('별풍선 누적 갯수 = '||s_val);
    END LOOP;
    
END;
/

DECLARE
    i NUMBER := 1;
BEGIN
    while i <= 5 loop
    DBMS_OUTPUT.PUT_LINE('별풍선 갯수 = '||i);
    i := i+1;
    END LOOP;
END;
/

--LOOP 
--  STATEMENT;
--  EXIT [WHEN CONDITION];
--  END LOOP;
DECLARE
    i number := 1;
BEGIN
    loop
        DBMS_OUTPUT.PUT_LINE('별풍선 갯수 = '||i);
        i := i +1;
        exit when i > 5;
        end loop;
END;
/

--CURSOR
--묵시적(암시적) : 개발자가 별도의 커서명을 기술하지 않은 형태. 
--오라클에서는 자동으로 OPEN, PERFORM, FETCH, CLOSE를 관리한다.
--명시적 : 개발자가 이름을 붙인 커서. 
--개발자가 직접 제어하며 DECLARE, OPEN, FETCH, CLOSE 단계가 존재
-- CURSOR 커서이름 IS -- 커서 선언
--  QUERY;
-- OPEN 커서이름; --커서 열기
-- FETCH 커서이름 INTO 변수1, 변수2... --커서 행 인출
-- CLOSE 커서이름;  --커서 닫기

--부서테이블의 모든 행의 부서이름, 위치 지역 정보를 출력(cursor를 이용)
DECLARE
    CURSOR dept_cursor IS --커서 선언
        select dname, loc
        from dept;
    v_dname dept.dname%TYPE;
    v_loc dept.loc%TYPE;
BEGIN
    OPEN dept_cursor;
    loop
        FETCH dept_cursor into v_dname,v_loc;
       
        exit WHEN dept_cursor %NOTFOUND;        
        DBMS_OUTPUT.PUT_LINE(v_dname ||','||v_loc);
    end loop;
     CLOSE dept_cursor;
END;
/