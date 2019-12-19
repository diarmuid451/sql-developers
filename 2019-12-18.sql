--과제 완성
select  /*일요일이면 날짜, 월요일이면 날짜....토요일이면 날짜 */
        /*dt,d,*/--dt -(d-1),
        MAX(DECODE(d,1,dt)) sun ,MAX(DECODE(d,2,dt)) mon ,MAX(DECODE(d,3,dt)) tue ,
        MAX(DECODE(d,4,dt)) wed, MAX(DECODE(d,5,dt)) thu ,MAX(DECODE(d,6,dt)) fri ,
        MAX(DECODE(d,7,dt)) sat
from (select to_date(:yyyymm, 'yyyymm') - (to_char(to_date(:yyyymm, 'yyyymm'), 'd') -1)+(LEVEL-1) dt,
        TO_CHAR(to_date(:yyyymm, 'yyyymm') - (to_char(to_date(:yyyymm, 'yyyymm'), 'd') -1)+(LEVEL-1), 'D') d,
        TO_CHAR(to_date(:yyyymm, 'yyyymm') - (to_char(to_date(:yyyymm, 'yyyymm'), 'd') -1)+(LEVEL), 'IW') iw
from dual
connect by level <= (select ldt - fdt +1 from
(select  to_date(:yyyymm, 'yyyymm') - (to_char(to_date(:yyyymm, 'yyyymm'), 'd') -1) fdt,
        last_day(to_date(:yyyymm, 'yyyymm')) dt,
        last_day(to_date(:yyyymm, 'yyyymm')) +7-to_char(last_day(to_date(:yyyymm, 'yyyymm')),'d') ldt
from dual)))
group by dt -(d-1)
order by dt -(d-1);

--201910 : 35, 첫 주의 일요일: 20190929, 마지막 날짜 : 20191102
--일(1) 월(2) 화(3)....금(6) 토(7)
select ldt - fdt +1 from
(select  to_date(:yyyymm, 'yyyymm') - (to_char(to_date(:yyyymm, 'yyyymm'), 'd') -1) fdt,
        last_day(to_date(:yyyymm, 'yyyymm')) dt,
        last_day(to_date(:yyyymm, 'yyyymm')) +7-to_char(last_day(to_date(:yyyymm, 'yyyymm')),'d') ldt
from dual);




/*
        dept0(xx회사) 
            dept0_00(디자인부)
                dept0_00_0(디자인팀)
            dept0_01(정보기획부)
                dept0_01_0(기획팀)
                    dept0_00_0_0(기획파트)
            dept0_02(정보시스템부)
                dept0_02_0(개발1팀)
                dept0_02_1(개발2팀)    */


select lpad('XX회사',15,'*'),
        lpad('XX회사',15)
from dual;
--         XX회사


--실습 h_1
select level,deptcd,lpad(' ', (level-1)*3) || deptnm deptnm,p_deptcd
from DEPT_H
start with deptcd = 'dept0' --시작점은 deptcd = 'dept0' >>xx회사(최상위 조직)
connect by prior deptcd = p_deptcd;

--실습 h-2
select level,deptcd,lpad(' ', (level-1)*3) || deptnm deptnm,p_deptcd
from DEPT_H
start with deptcd = 'dept0_02' 
connect by prior deptcd = p_deptcd;

--실습 h_3
select deptcd,lpad(' ', (level-1)*3) || deptnm deptnm,p_deptcd
from DEPT_H
start with deptcd = 'dept0_00_0' 
connect by deptcd = prior p_deptcd AND prior deptnm Like '디자인%';
--AND col = prior col2 : 연결조건이 여러개 일 수 도 있다.

--실습 h_4
select lpad(' ', (level-1)*4) || S_ID AS S_ID, VALUE
from h_sum
start with S_ID = '0'
connect by PS_ID = prior S_ID;
                
--실습 h_5
select lpad(' ', (level-1)*4) || ORG_CD AS ORG_CD,NO_EMP
from no_emp
start with org_cd = 'XX회사'
connect by parent_org_cd = prior org_cd;

-- pruning branch - 가지 치기
-- 계층 쿼리의 실행 순서
-- FROM >> START WITH ~CONNECT BY >> WHERE
-- 조건을 connect by 절에 기술할 경우 : 조건에 따라 다음 row로 연결이 안되고 종료
-- 조건을 where절에 기술한 경우 : START WITH ~CONNECT BY 절에 의해 계층이 나온 결과에 
-- where 절에 기술한 결과 값에 해당하는 데이터만 조회

select level,deptcd,lpad(' ', (level-1)*4) || deptnm as deptnm,p_deptcd
from DEPT_H
start with p_deptcd IS NULL
connect by prior deptcd = p_deptcd and deptnm !='정보기획부';

-- where 절에 deptnm !='정보기획부' 조건을 기술한 경우
-- 계층쿼리를 실행하고 나서 최종 결과에 where 절 조건을 적용
select level,deptcd,lpad(' ', (level-1)*4) || deptnm as deptnm,p_deptcd
from DEPT_H
where deptnm !='정보기획부'
start with p_deptcd IS NULL
connect by prior deptcd = p_deptcd; 

-- 계층 쿼리에서 사용 가능한 특수 함수
-- CONNECT_BY_ROOT(col) 가장 최상위 row의 col 정보 값 조회
-- SYS_CONNECT_BY_PATH(col, 구분자) : 최상위 row에서 현재 로우까지 col값을 구분자로 연결해준 문자열
-- leaf node : 1, node : 0
select deptcd,lpad(' ', (level-1)*4) || deptnm as deptnm,
        CONNECT_BY_ROOT(deptnm) as c_root,
        ltrim(sys_connect_by_path(DEPTNM,'-'),'-') as sys_path,
        connect_by_isleaf as isleaf
from DEPT_H
start with p_deptcd IS NULL
connect by prior deptcd = p_deptcd; 

--실습 h_6
select SEQ, lpad(' ', (level-1)*4) || TITLE as TITLE
from board_test 
start with parent_seq IS NULL
connect by prior seq = parent_seq;

--실습 h_7
select SEQ, lpad(' ', (level-1)*4) || TITLE as TITLE
from board_test 
start with parent_seq IS NULL
connect by prior seq = parent_seq
order by seq desc;

--실습 h_8
select SEQ, lpad(' ', (level-1)*4) || TITLE as TITLE
from board_test 
start with parent_seq IS NULL
connect by prior seq = parent_seq
order siblings by seq desc;

--실습 h_9(과제)
select SEQ, lpad(' ', (level-1)*4) || TITLE as TITLE
from board_test 
start with parent_seq IS NULL
connect by prior seq = parent_seq
order siblings by nvl(parent_seq,seq) desc;
 
 
--실습 h_8
select SEQ, lpad(' ', (level-1)*4) || TITLE as TITLE, 
case when parent_seq is null then seq else 0 end,
case when parent_seq is not null then seq else 0 end o2
from board_test 
start with parent_seq IS NULL
connect by prior seq = parent_seq
order siblings by case when parent_seq is null then seq else 0 end desc;