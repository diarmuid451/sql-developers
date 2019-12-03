--outerjoin 2
select NVL(a.BUY_DATE,'05/01/25'), a.buy_prod, p.prod_id, p.prod_name, a.BUY_QTY
from (select TO_CHAR(b.buy_date, 'YY/MM/DD') BUY_DATE,b.buy_prod, b.BUY_QTY
from buyprod b
WHERE b.buy_date = '2005-01-25') a RIGHT OUTER JOIN prod p ON ( a.buy_prod = p.prod_id);


--outerjoin 3
select NVL(a.BUY_DATE,'05/01/25'), a.buy_prod, p.prod_id, p.prod_name, NVL(a.BUY_QTY,0)
from (select TO_CHAR(b.buy_date, 'YY/MM/DD') BUY_DATE,b.buy_prod, b.BUY_QTY
from buyprod b
WHERE b.buy_date = '2005-01-25') a RIGHT OUTER JOIN prod p ON ( a.buy_prod = p.prod_id);


--outerjoin 4
select *
from cycle;

select *
from product;


select p.pid,   p.PNM, NVL(c.CID, 1) cid, NVL(c.DAY, 0) day, NVL(c.CNT,0) cnt
from product p LEFT OUTER JOIN cycle c ON(p.pid = c.PID AND c.cid =1);

select p.pid,   p.PNM, NVL(c.CID, 1) cid, NVL(c.DAY, 0) day, NVL(c.CNT,0) cnt
from product p, cycle c
where p.pid = c.PID(+) AND c.cid(+) =1;

--outerjoin 5
select *
from customer;

select p.pid,   p.PNM, NVL(c.CID, 1) cid, NVL(customer.CNM,(select cnm from customer where customer.cid = 1)) cnm, NVL(c.DAY, 0) day, NVL(c.CNT,0) cnt
from product p LEFT OUTER JOIN cycle c ON(p.pid = c.PID AND c.cid =1)
                LEFT OUTER JOIN customer ON(c.cid = customer.cid);
                
select a.pid, a.pnm, a.cid, NVL(customer.CNM,(select cnm from customer where customer.cid = 1)) cnm, a.day, a.cnt
from (select p.pid,   p.PNM, NVL(c.CID, 1) cid, NVL(c.DAY, 0) day, NVL(c.CNT,0) cnt
from product p, cycle c
where p.pid = c.PID(+) AND c.cid(+) =1) a, customer
where a.cid = customer.cid;

--crossjoin1
select customer.CID,customer.CNM,product.pid, product.PNM
from customer, product;


--도시발전지수
select *
from fastfood
order by gb;

--도시발전지수가 높은 순으로 나열
--도시발전지수 = (버거킹개수 + KFC개수 + 맥도날드 개수) / 롯데리아 개수
--순위 / 시도 / 시군구 / 도시발전지수(소수점 둘재 자리에서 반올림)
-- 예) 1/ 서울특별시/ 서초구 / 7.5
--     2/  서울특별시/ 강남구 / 7.2
select *
from fastfood;

--해당 시도, 시군구별 프랜차이즈별 건수가 필요

--버거킹, KFC, 맥도날드 개수의 합
select count(gb) sum, sido, sigungu 
from  fastfood
where gb IN( '버거킹','KFC','맥도날드') 
group by sido, sigungu
order by sigungu;

--롯데리아 개수
select count(gb) lotte, sido, sigungu
from  fastfood
where gb = '롯데리아'
group by sido, sigungu
order by sigungu;

--도시발전지수 계산
select b.sido 시도, b.sigungu 시군구, NVL(ROUND(a.sum / b.lotte, 1),0) 도시발전지수
from 
(select count(gb) sum, sido, sigungu
from  fastfood
where gb IN( '버거킹','KFC','맥도날드') 
group by sido, sigungu
order by sigungu) a, 
(select count(gb) lotte, sido, sigungu
from  fastfood
where gb = '롯데리아'
group by sido, sigungu) b
where a.sigungu(+) = b.sigungu AND a.sido(+) = b.sido
order by 도시발전지수 DESC;

--순위 부여(최종)
select ROWNUM 순위, c.시도, c.시군구, c.도시발전지수
from 
(select b.sido 시도, b.sigungu 시군구, NVL(ROUND(a.sum / b.lotte, 1),0) 도시발전지수
from 
(select count(gb) sum, sido, sigungu
from  fastfood
where gb IN( '버거킹','KFC','맥도날드') 
group by sido, sigungu
order by sigungu) a, 
(select count(gb) lotte, sido, sigungu
from  fastfood
where gb = '롯데리아'
group by sido, sigungu) b
where a.sigungu(+) = b.sigungu AND a.sido(+) = b.sido
order by 도시발전지수 DESC) c;

--대전광역시
select count(gb) sum, sido, sigungu
from  fastfood
where gb IN( '버거킹','KFC','맥도날드') AND sido = '대전광역시'
group by sido, sigungu
order by sigungu;

select count(gb) lotte, sido, sigungu
from  fastfood
where gb = '롯데리아' AND sido = '대전광역시'
group by sido, sigungu 
order by sigungu;

select b.sido 시도, b.sigungu 시군구, ROUND(a.sum / b.lotte,1) 도시발전지수
from 
(select count(gb) sum, sido, sigungu
from  fastfood
where gb IN( '버거킹','KFC','맥도날드') AND sido = '대전광역시'
group by sido, sigungu
order by sigungu) a, 
(select count(gb) lotte, sido, sigungu
from  fastfood
where gb = '롯데리아' AND sido = '대전광역시'
group by sido, sigungu 
order by sigungu) b
where a.sigungu = b.sigungu
order by 도시발전지수 DESC;

select *
from tax
order by sal DESC;