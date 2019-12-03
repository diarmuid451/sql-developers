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


--���ù�������
select *
from fastfood
order by gb;

--���ù��������� ���� ������ ����
--���ù������� = (����ŷ���� + KFC���� + �Ƶ����� ����) / �Ե����� ����
--���� / �õ� / �ñ��� / ���ù�������(�Ҽ��� ���� �ڸ����� �ݿø�)
-- ��) 1/ ����Ư����/ ���ʱ� / 7.5
--     2/  ����Ư����/ ������ / 7.2
select *
from fastfood;

--�ش� �õ�, �ñ����� ��������� �Ǽ��� �ʿ�

--����ŷ, KFC, �Ƶ����� ������ ��
select count(gb) sum, sido, sigungu 
from  fastfood
where gb IN( '����ŷ','KFC','�Ƶ�����') 
group by sido, sigungu
order by sigungu;

--�Ե����� ����
select count(gb) lotte, sido, sigungu
from  fastfood
where gb = '�Ե�����'
group by sido, sigungu
order by sigungu;

--���ù������� ���
select b.sido �õ�, b.sigungu �ñ���, NVL(ROUND(a.sum / b.lotte, 1),0) ���ù�������
from 
(select count(gb) sum, sido, sigungu
from  fastfood
where gb IN( '����ŷ','KFC','�Ƶ�����') 
group by sido, sigungu
order by sigungu) a, 
(select count(gb) lotte, sido, sigungu
from  fastfood
where gb = '�Ե�����'
group by sido, sigungu) b
where a.sigungu(+) = b.sigungu AND a.sido(+) = b.sido
order by ���ù������� DESC;

--���� �ο�(����)
select ROWNUM ����, c.�õ�, c.�ñ���, c.���ù�������
from 
(select b.sido �õ�, b.sigungu �ñ���, NVL(ROUND(a.sum / b.lotte, 1),0) ���ù�������
from 
(select count(gb) sum, sido, sigungu
from  fastfood
where gb IN( '����ŷ','KFC','�Ƶ�����') 
group by sido, sigungu
order by sigungu) a, 
(select count(gb) lotte, sido, sigungu
from  fastfood
where gb = '�Ե�����'
group by sido, sigungu) b
where a.sigungu(+) = b.sigungu AND a.sido(+) = b.sido
order by ���ù������� DESC) c;

--����������
select count(gb) sum, sido, sigungu
from  fastfood
where gb IN( '����ŷ','KFC','�Ƶ�����') AND sido = '����������'
group by sido, sigungu
order by sigungu;

select count(gb) lotte, sido, sigungu
from  fastfood
where gb = '�Ե�����' AND sido = '����������'
group by sido, sigungu 
order by sigungu;

select b.sido �õ�, b.sigungu �ñ���, ROUND(a.sum / b.lotte,1) ���ù�������
from 
(select count(gb) sum, sido, sigungu
from  fastfood
where gb IN( '����ŷ','KFC','�Ƶ�����') AND sido = '����������'
group by sido, sigungu
order by sigungu) a, 
(select count(gb) lotte, sido, sigungu
from  fastfood
where gb = '�Ե�����' AND sido = '����������'
group by sido, sigungu 
order by sigungu) b
where a.sigungu = b.sigungu
order by ���ù������� DESC;

select *
from tax
order by sal DESC;