/*
준비 
 (1) create_table 스크립트를 실해하여  테이블 
 (2) 생성후 1~ 5 데이터를 스크립트를 실행한뒤 아래 문제를 작성하시오
     (문제에 대한 출력물은 이미지 참고)
*/
---------------------------------------------------------------------
-----------1번 문제 ---------------------------------------------------
--강남구에 사는 고객의 이름, 전화번호를 출력하시오 

select customer_name
     , phone_number
from address a, customer b
where a.zip_code = b.zip_code
and a.ADDRESS_DETAIL like '강남구';

---------------------------------------------------------------------
----------2번 문제 ---------------------------------------------------
--CUSTOMER에 있는 회원의 직업별 회원의 수를 출력하시오 (직업 NULL은 제외)

select job
     , count(customer_id) as CNT
from customer
where job is not null
group by job
order by CNT desc;
---------------------------------------------------------------------
----------3-1번 문제 ---------------------------------------------------
-- 가장 많이 가입(처음등록)한 요일과 건수를 출력하시오 

select to_char(first_reg_date, 'day') as 요일
     , count(customer_id) as 건수
from customer
where to_char(first_reg_date, 'day') = '금요일'
group by to_char(first_reg_date, 'day');

select *
from (select to_char(first_reg_date, 'day') as 요일
           , count(customer_id) as 건수
             from customer
             where to_char(first_reg_date, 'day') = '금요일'
             group by to_char(first_reg_date, 'day')
     );
---------------------------------------------------------------------
----------3-2번 문제 ---------------------------------------------------
-- 남녀 성비 집계를 출력하시오 

select decode(gender, 'F','여자','M','남자','N','미등록','합계') as GENDER
     , CNT
from(select gender
          , count(*) as CNT
     from (select decode(sex_code, null, 'N', sex_code) as gender
           from customer)
     group by rollup(gender)
);

select case when sex_code = 'F' then '여자'
            when sex_code = 'M' then '남자'
            when sex_code is null and groupid = 0 then '미등록'
          else '합계'
        end as gender
      , cnt
from(select sex_code
          , grouping_id(sex_code) as groupid
          , count(*) as cnt
     from customer
     group by rollup(sex_code)
     );
---------------------------------------------------------------------
--------------------------------------------------------------------
----------4번 문제 ---------------------------------------------------
--월별 예약 취소 건수를 출력하시오 (많은 달 부터 출력)

select to_char(to_date(reserv_date),'MM') as 월
     , count(*) 건수
from reservation
where cancel = 'Y'
group by to_char(to_date(reserv_date),'MM')
order by 2 desc;
---------------------------------------------------------------------
----------5번 문제 ---------------------------------------------------
 -- 전체 상품별 '상품이름', '상품매출' 을 내림차순으로 구하시오 
 
 select product_name as 상품이름
      , sum(sales)   as 상품매출
 from item a, order_info b
 where a.item_id = b.item_id
 group by a.item_id
        , a.product_name
 order by 2 desc;
-----------------------------------------------------------------------------
---------- 6번 문제 ---------------------------------------------------
-- 모든상품의 월별 매출액을 구하시오 
-- 매출월, SPECIAL_SET, PASTA, PIZZA, SEA_FOOD, STEAK, SALAD_BAR, SALAD, SANDWICH, WINE, JUICE

select substr(a.reserv_date, 1, 6) as 매출월
     , sum(decode(b.item_id,'M0001', b.sales, 0)) as special_set
     , sum(decode(b.item_id,'M0002', b.sales, 0)) as pasta
     , sum(decode(b.item_id,'M0003', b.sales, 0)) as pizza
     , sum(decode(b.item_id,'M0004', b.sales, 0)) as sea_food
     , sum(decode(b.item_id,'M0005', b.sales, 0)) as steak
     , sum(decode(b.item_id,'M0006', b.sales, 0)) as salad_bar
     , sum(decode(b.item_id,'M0007', b.sales, 0)) as salad
     , sum(decode(b.item_id,'M0008', b.sales, 0)) as sandwich
     , sum(decode(b.item_id,'M0009', b.sales, 0)) as wine
     , sum(decode(b.item_id,'M0010', b.sales, 0)) as juice
from reservation a
   , order_info b
   where a.reserv_no = b.reserv_no
group by substr(a.reserv_date, 1, 6) 
order by 1;


select substr(b.reserv_no,0,6) as 매출월
     , sum(decode(a.product_name, 'SPECIAL_SET',b.sales,0)) as SPECIAL_SET

     , sum(decode(a.product_name, 'PASTA',b.sales,0)) as PASTA

     , sum(decode(a.product_name, 'PIZZA',b.sales,0)) as PIZZA

     , sum(decode(a.product_name, 'SEA_FOOD',b.sales,0)) as SEA_FOOD

     , sum(decode(a.product_name, 'STEAK',b.sales,0)) as STEAK

     , sum(decode(a.product_name, 'SALAD_BAR',b.sales,0)) as SALAD_BAR

     , sum(decode(a.product_name, 'SALAD',b.sales,0)) as SALAD

     , sum(decode(a.product_name, 'SANDWICH',b.sales,0)) as SANDWICH

     , sum(decode(a.product_name, 'WINE',b.sales,0)) as WINE

     , sum(decode(a.product_name, 'JUICE',b.sales,0)) as JUICE

from item a, order_info b

where a.item_id = b.item_id

group by substr(b.reserv_no,0,6)

order by 1;
----------------------------------------------------------------------------
---------- 7번 문제 ---------------------------------------------------
-- 월별 온라인_전용 상품 매출액을 일요일부터 월요일까지 구분해 출력하시오 
-- 날짜, 상품명, 일요일, 월요일, 화요일, 수요일, 목요일, 금요일, 토요일의 매출을 구하시오 
select substr(reserv_date,1, 6) as 날짜
     , product_name 상품명
     , sum(decode(week, '1', sales, 0)) 일요일
     , sum(decode(week, '2', sales, 0)) 월요일
     , sum(decode(week, '3', sales, 0)) 화요일
     , sum(decode(week, '4', sales, 0)) 수요일
     , sum(decode(week, '5', sales, 0)) 목요일
     , sum(decode(week, '6', sales, 0)) 금요일
     , sum(decode(week, '7', sales, 0)) 토요일
from (select a.reserv_date
           , c.product_name
           , to_char(to_date(a.reserv_date, 'YYYYMMDD'), 'd') as week
           , b.sales
        from reservation a, order_info b, item c 
        where a.reserv_no = b.reserv_no
        and b.item_id = c.item_id
        and b.item_id = 'M0001')
group by substr(reserv_date,1, 6)
       , product_name
order by 1;

select substr(b.reserv_no,0,6) as 날짜
     , a.product_name as 상품명
     , sum(decode(to_char(to_date(substr(b.reserv_no,0,8),'yyyymmdd'),'day'),'일요일',sales,0)) as 일요일

     , sum(decode(to_char(to_date(substr(b.reserv_no,0,8),'yyyymmdd'),'day'),'월요일',sales,0)) as 월요일

     , sum(decode(to_char(to_date(substr(b.reserv_no,0,8),'yyyymmdd'),'day'),'화요일',sales,0)) as 화요일

     , sum(decode(to_char(to_date(substr(b.reserv_no,0,8),'yyyymmdd'),'day'),'수요일',sales,0)) as 수요일

     , sum(decode(to_char(to_date(substr(b.reserv_no,0,8),'yyyymmdd'),'day'),'목요일',sales,0)) as 목요일

     , sum(decode(to_char(to_date(substr(b.reserv_no,0,8),'yyyymmdd'),'day'),'금요일',sales,0)) as 금요일

     , sum(decode(to_char(to_date(substr(b.reserv_no,0,8),'yyyymmdd'),'day'),'토요일',sales,0)) as 토요일

from item a

    ,order_info b

where a.item_id = b.item_id

and a.product_name = 'SPECIAL_SET'

group by substr(b.reserv_no,0,6),
         a.product_name

order by 1;
----------------------------------------------------------------------------
---------- 8번 문제 ----------------------------------------------------
-- 고객수, 남자인원수, 여자인원수, 평균나이, 평균거래기간(월기준)을 구하시오 (성별 NULL 제외)

select count(customer_id) as 고객수
     , sum(decode(sex_code, 'M', 1, 0)) as 남자
     , sum(decode(sex_code, 'F', 1, 0)) as 여자
     , round(avg(months_between(sysdate, to_date(birth,'YYYYMMDD'))/12),1) 평균나이
     , round(avg(months_between(sysdate, first_reg_date)),1) 평균거래기간
from customer
where sex_code is not null
and birth is not null;


select count(customer_id) as 고객수 , b.남자, c.여자, d.평균나이, e.평균거래기간
from customer

    ,(select count(*) as 남자

      from customer

      where sex_code = 'M') b

    ,(select count(*) as 여자

      from customer

      where sex_code = 'F') c

    ,(select round(avg(2021 - substr(birth,0,4)),1) as 평균나이

      from customer

      where sex_code is not null) d

    ,(select round(avg(months_between(sysdate,first_reg_date)),1) as 평균거래기간

      from customer) e

where sex_code is not null

group by b.남자, c.여자, d.평균나이, e.평균거래기간;
----------------------------------------------------------------------------
---------- 9번 문제 ----------------------------------------------------
-- 주소, 해당지역 고객수를 출력하시오(거래내역이 있는 고객)

select t2.address_detail 주소
     , count(t2.address_detail) as 카운트
from ( 
        select distinct A.customer_id, A.zip_code
        from customer a
           , reservation b
           , order_info c
        where a.customer_id = b.customer_id
        and b.reserv_no = c.reserv_no
        ) t1
        , address t2
where t1.zip_code = t2.zip_code
group by t2.address_detail
order by 2 desc;
   
----------------------------------------------------------------------------
