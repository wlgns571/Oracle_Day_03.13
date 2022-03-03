/*

 sales 테이블에서 '년도별', 상품 '매출액(amount_sold)'을
 일요일부터 월요일까지 구분해 출력하시오.
 날짜(sales_date), 일요일, 월요일, 화요일, 수요일, 목요일, 금요일, 토요일, 년총합의
 매출을 구하시오.

*/

select to_char(sales_date,'YYYY') as 년도
--     , to_char(sales_date,'D') as 요일
     , to_char(sum(decode(to_char(sales_date,'D'),'1',amount_sold,0)),'99,999,999,99') as 일요일
--     , to_char(sum(decode(to_char(sales_date,'D'),'2',amount_sold,0)),'99,999,999,99') as 월요일
--     , to_char(sum(decode(to_char(sales_date,'D'),'3',amount_sold,0)),'99,999,999,99') as 화요일
--     , to_char(sum(decode(to_char(sales_date,'D'),'4',amount_sold,0)),'99,999,999,99') as 수요일
--     , to_char(sum(decode(to_char(sales_date,'D'),'5',amount_sold,0)),'99,999,999,99') as 목요일
--     , to_char(sum(decode(to_char(sales_date,'D'),'6',amount_sold,0)),'99,999,999,99') as 금요일
--     , to_char(sum(decode(to_char(sales_date,'D'),'7',amount_sold,0)),'99,999,999,99') as 토요일
--     , sum(amount_sold)
from sales
group by to_char(sales_date,'YYYY')
--       , to_char(sales_date,'D')
order by 1;

select *
from member;

select *
from cart;
-- 모든 고객의 상품구매 수를 출력하시오.

select a.mem_id
     , a.mem_name
     , nvl(sum(b.cart_qty),0) as 상품구매건수
from member a, cart b
where a.mem_id = b.cart_member (+)
group by a.mem_id -- 그룹핑을 해줄때 동명이인이 있을수 있으니 필수로 넣어준다.
       , a.mem_name
order by 상품구매건수 desc; -- desc(내림차순), asc(오름차순)
-- order by 3 desc;

-- 고객별 구매상품명, 구매건수, 상품별구매금액을 출력하시오.

select *
from prod;

select a.mem_name
     , c.prod_name
     , nvl(sum(b.cart_qty),0) as 상품구매건수
     , c.prod_sale * nvl(sum(b.cart_qty),0) as 상품별구매금액
from member a, cart b, prod c
where a.mem_id = b.cart_member (+)
and   b.cart_prod = c.prod_id (+)
group by a.mem_id
       , b.cart_prod
       , a.mem_name
       , c.prod_name
       , c.prod_sale
order by 1,2;