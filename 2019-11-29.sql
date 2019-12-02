--join0_3
--사원번호, 사원이름, 급여, 부서번호, 부서이름
--사원번호, 사원이름, 급여 : emp
--부서번호 : emp, dept
--부서이름 : dept

select emp.empno, emp.ename, emp.sal, emp.deptno, dept.dname --유지-보수 면에서 테이블명을 달아주는게 좋다.
from emp JOIN dept ON (emp.deptno = dept.deptno)
where emp.sal > 2500 AND empno > 7600
ORDER BY emp.deptno;

select empno, ename,sal, emp.deptno, dname
from emp, dept
where emp.deptno = dept.deptno AND sal > 2500 AND empno > 7600
ORDER BY emp.deptno;

--join0_4
select empno, ename, sal, emp.deptno, dname
from emp JOIN dept ON (emp.deptno = dept.deptno)
where emp.sal > 2500 AND empno > 7600 AND dname = 'RESEARCH'
ORDER BY emp.deptno;

select empno, ename,sal, emp.deptno, dname
from emp, dept
where emp.deptno = dept.deptno AND sal > 2500 AND empno > 7600 AND dname = 'RESEARCH'
ORDER BY emp.deptno;

--join1
select lprod_gu, lprod_nm, prod_id, prod_name
from prod, lprod
where lprod_gu = prod_lgu;

select lprod_gu, lprod_nm, prod_id, prod_name
from prod JOIN lprod ON (lprod_gu = prod_lgu);

--join2
select buyer_id, buyer_name, prod_id, prod_name
from prod, buyer    
where buyer_lgu = prod_lgu
ORDER BY buyer_id;

select buyer_id, buyer_name, prod_id, prod_name
from prod JOIN buyer ON (buyer_lgu = prod_lgu)
ORDER BY buyer_id;

--join3
select *
from cart;

select *
from member;

select *
from prod;


select member.mem_id, member.mem_name, prod.prod_id, prod.prod_name, cart.cart_qty
from MEMBER, cart, PROD
where member.mem_id = cart.CART_MEMBER AND cart.CART_PROD = PROD.PROD_ID
ORDER BY cart.CART_NO;


--join4
select *
from customer;

select customer.cid, customer.cnm, cycle.pid, cycle.day, cycle.cnt
from CUSTOMER, cycle
where customer.cid = cycle.cid AND customer.cid != 3;


--join5
select customer.cid, customer.cnm, cycle.pid, product.pnm, cycle.day, cycle.cnt
from CUSTOMER, cycle, product
where customer.cid = cycle.cid AND cycle.pid = product.pid AND customer.cid != 3;

--join6
select customer.cid, customer.cnm, cycle.pid, product.pnm,sum(cycle.cnt) cnt
from CUSTOMER, product, cycle
where cycle.cid = CUSTOMER.CID AND product.pid = cycle.PID
group by customer.cid, customer.cnm, cycle.pid, product.pnm
order by customer.cid;

SELECT customer.cid, customer.CNM, a.pid, product.PNM, a.cnt    
FROM (select cid, pid, sum(cnt) cnt
from cycle
group by cid, pid) a JOIN customer ON(a.cid = customer.cid) JOIN product ON(a.pid = product.pid)
;

--join 7
select pid, sum(cnt)
from cycle
group by pid;

select product.pid, product.pnm, a.b
from product, (select pid, sum(cnt) b
from cycle
group by pid) a
where product.pid = a.pid;

