--for loop에서 명시적 커서 사용하기
--부서 테이블의 모든 행의 부서이름, 위치 지역 정보를 출력 (CURSOR를 이용)
set SERVEROUTPUT on;
DECLARE
    CURSOR dept_cursor IS --커서 선언
        select dname, loc
        from dept;
    v_dname dept.dname%TYPE;
    v_loc dept.loc%TYPE;
BEGIN
   FOR record_row IN dept_cursor LOOP
   DBMS_OUTPUT.PUT_LINE (record_row.dname || ',' || record_row.loc);
   END LOOP;
END;
/


DECLARE
    CURSOR dept_cursor(p_deptno dept.deptno%type) IS --커서 선언
        select dname, loc
        from dept
        where deptno = p_deptno;
    v_dname dept.dname%TYPE;
    v_loc dept.loc%TYPE;
BEGIN
   FOR record_row IN dept_cursor(:p_deptno) LOOP
   DBMS_OUTPUT.PUT_LINE (record_row.dname || ',' || record_row.loc);
   END LOOP;
END;
/


--for loop 인라인 커서

DECLARE     
    v_dname dept.dname%TYPE;
    v_loc dept.loc%TYPE;
BEGIN
   FOR record_row IN (select dname, loc
        from dept) LOOP
   
   DBMS_OUTPUT.PUT_LINE (record_row.dname || ',' || record_row.loc);
   END LOOP;
END;
/



select * from dt;

--실습 PRO_3
create or replace Procedure avgdt 
is 
type avg_tab is table of dt%rowtype index by binary_integer;
avg_dt avg_tab;
v_sum NUMBER := 0;
BEGIN
    select * bulk collect into avg_dt from dt;
    
    for i in 2..avg_dt.count loop
    v_sum := avg_dt(i-1).dt - avg_dt(i).dt + v_sum; 
    end loop;
    DBMS_OUTPUT.put_line(v_sum / (avg_dt.count-1));
END;
/

exec avgdt;

--1. rownum 
--2. 분석함수
--3. (최종값 - 최초값) / 총 컬럼 수 -1
select avg(sum_avg) as avg_dt from
(select lead(dt) over(order by dt) - dt as sum_avg
from dt);

select (max(dt) - min(dt))/ (count(*)-1) as cnt from dt;


--실습 PRO_4
select cycle.cid, cycle.pid, cal.dt, cycle.cnt from cycle,
(select TO_CHAR(TO_DATE(:v_yyyymm,'YYYYMM') + (level-1),'YYYYMMDD') as dt,
        TO_CHAR(TO_DATE(:v_yyyymm,'YYYYMM') + (level-1), 'd') as day
from dual 
connect by level <= TO_CHAR(LAST_DAY(TO_DATE(:v_yyyymm,'YYYYMM')), 'dd')) cal
where cycle.day = cal.day
order by dt,cid;

select * from daily;
desc cycle;
desc daily;

CREATE OR REPLACE PROCEDURE create_daily_sales(p_yyyymm IN VARCHAR2)
IS 
    type cal_row_type IS RECORD(dt VARCHAR2(8), day NUMBER);
    type cal_tab IS TABLE OF cal_row_type INDEX BY BINARY_INTEGER;
    v_cal_tab cal_tab;
BEGIN
    --생성하기전에 해당년월에 해당하는 일실적 데이터를 삭제한다
    DELETE daily 
    where dt like p_yyyymm || '%';
    
    --달력정보를 table 변수에 저장한다.
    --반복적인 sql 실행을 방지하기 위해 한번만 실행하여 변수에 저장
    select TO_CHAR(TO_DATE(p_yyyymm,'YYYYMM') + (level-1),'YYYYMMDD') as dt,
        TO_CHAR(TO_DATE(p_yyyymm,'YYYYMM') + (level-1), 'd') as day
    BULK COLLECT INTO v_cal_tab
    from dual 
    connect by level <= TO_CHAR(LAST_DAY(TO_DATE(p_yyyymm,'YYYYMM')), 'dd');
    
    
    
    --애음주기 정보를 읽는다.
    FOR daily IN (select * from cycle) LOOP --12월 일자달력 : cycle row 건수만큼 반복
        
        FOR i IN 1..v_cal_tab.count LOOP
            IF daily.day = v_cal_tab(i).day then
                --cid, pid, 일자, 수량
                INSERT INTO daily VALUES (daily.cid, daily.pid,v_cal_tab(i).dt , daily.cnt);
            END IF;
        END loop;
        DBMS_OUTPUT.PUT_LINE(daily.cid||', '||daily.pid||', '||daily.DAY||', '||daily.cnt);
    END LOOP;
    commit;
END;
/

exec create_daily_sales('201912');

select TO_CHAR(TO_DATE('201911','YYYYMM') + (level-1),'YYYYMMDD') as dt,
        TO_CHAR(TO_DATE('201911','YYYYMM') + (level-1), 'd') as day
from dual 
connect by level <= TO_CHAR(LAST_DAY(TO_DATE('201911','YYYYMM')), 'dd');
