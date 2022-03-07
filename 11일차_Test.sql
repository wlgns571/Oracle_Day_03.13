/*

  아래처럼 출력 되도록 테이블을 생성, 데이터 인서트 후 출력하시오.
  ex) 아이디, 이름, 직책, 상위 아이디
이름   직책                   level
이사장 사장                     1
김부장    부장                  2
서차장        차장              3
장과장           과장           4
이대리              대리        5
최사원                 사원     6
강사원                    사원  6
박과장           과장           4
김대리              대리        5
강사원                 사원     6

*/

create table exT_1 (
    아이디 number(6,0)
  , 이름 varchar2(10)
  , 직책 varchar2(10)
  , 상위아이디 number(6,0)
);

insert into exT_1 (아이디, 이름, 직책, 상위아이디) values(10,'이사장', '사장','');
insert into exT_1 (아이디, 이름, 직책, 상위아이디) values(20,'김부장', '부장',10);
insert into exT_1 (아이디, 이름, 직책, 상위아이디) values(30,'서차장', '차장',20);
insert into exT_1 (아이디, 이름, 직책, 상위아이디) values(40,'장과장', '과장',30);
insert into exT_1 (아이디, 이름, 직책, 상위아이디) values(50,'이대리', '대리',40);
insert into exT_1 (아이디, 이름, 직책, 상위아이디) values(61,'최사원', '사원',50);
insert into exT_1 (아이디, 이름, 직책, 상위아이디) values(62,'강사원', '사원',50);
insert into exT_1 (아이디, 이름, 직책, 상위아이디) values(41,'박과장', '과장',30);
insert into exT_1 (아이디, 이름, 직책, 상위아이디) values(51,'김대리', '대리',41);
insert into exT_1 (아이디, 이름, 직책, 상위아이디) values(63,'강사원', '사원',51);

drop table exT_1;

select *
from exT_1;


select 이름
     , lpad(' ', 3 * (level -1)) || 직책 as 직책
     , level
from exT_1
start with 상위아이디 is null -- 꼭 null값과 숫자열이 아니여도 상관없다.
connect by prior 아이디 = 상위아이디;


/* level 은 오라클에서 실행되는 모든 쿼리 내에서 사용가능 ( connect by절과 함께 )
   level 은 가상으 ㅣ열로 트리 내에서 단계(level)에 있는지 나타내는 정수값
*/

-- select to_char(sysdate, 'YYYY') || lpad(level, 2, '0') as months
select '2013' || lpad(level, 2, '0') as months
from dual
connect by level <= 12; -- connect by절은 임의의 데이터 형성 가능

select period as months
     , sum(loan_jan_amt) as amt
from kor_loan_status
where period like '2013%'
group by period;


-- 임의의 데이터와 일반 데이터와의 조인
select a.months
     , nvl(b.amt, 0) as amt
from (select '2013' || lpad(level, 2, '0') as months
        from dual
        connect by level <= 12) a
   , (select period as months
         , sum(loan_jan_amt) as amt
                from kor_loan_status
                where period like '2013%'
                group by period) b
where a.months = b.months (+)
order by 1;

-- 해당월의 일자를 출력
select level
from dual
connect by level <= (to_date('20210831') - to_date('20210801'));

-- 이번달 20220201 ~ 20220228 출력 하시오.
select last_day(sysdate) -- 현재 월 마지막날 출력
     , to_date(to_char(sysdate,'YYYYMM') || '01' )
     , trunc(sysdate, 'month')
     , to_date(to_char(last_day(sysdate),'YYYYMMDD')) 
        - to_date(to_char(sysdate,'YYYYMM') || '01' ) -- 소수점이 많이 생김
     , trunc(last_day(sysdate) 
        - to_date(to_char(sysdate,'YYYYMM') || '01' )) +1
from dual;


select to_char(sysdate, 'YYYYMM') || lpad(level, 2, '0') as days
from dual
connect by level <= (round(last_day(sysdate)) 
                        - to_date(to_char(sysdate,'YYYYMM') || '01') +1); 
                        
-- 9일차_Test 6번문제의 매출월은 6월부터 12월까지이다.
-- connect by문을 이용하여 1월부터 12월까지 출력되게 하시오.
-- connect문 사용후 총합계를 내려면 밖의 select문에서 sum을 하여야한다.
-- from절 안에 있는 sum은 지운후 decode만 남겨둘수있게 한후
-- 밖의 group by 절에서 rollup을 한다.
select a1.매출월
     , nvl(b1.special_set,0) asspecial_set
     , nvl(b1.pasta,0) as pasta
     , nvl(b1.pizza,0) as pizza
     , nvl(b1.sea_food,0) as sea_food
     , nvl(b1.steak,0) as steak
     , nvl(b1.salad_bar,0) as salad_bar
     , nvl(b1.salad,0) as salad
     , nvl(b1.sandwich,0) as sandwich
     , nvl(b1.wine,0) as wine
     , nvl(b1.juice,0) as juice
from (select '2017' || lpad(level,2,'0') as 매출월
        from dual
        connect by level <= 12) a1
   , (select substr(a.reserv_date, 1, 6) as 매출월
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
        group by substr(a.reserv_date, 1, 6)) b1
where a1.매출월 = b1.매출월(+)
group by rollup a1.매출월
order by 1;



/*
문제 

 모든상품의 월별 매출액을 구하시오 
 매출월, SPECIAL_SET, PASTA, PIZZA, SEA_FOOD, STEAK, SALAD_BAR, SALAD, SANDWICH, WINE, JUICE
 */
;
SELECT SUBSTR(A.reserv_date,1,6) 매출월,  
       SUM(DECODE(B.item_id,'M0001',B.sales,0)) SPECIAL_SET,
       SUM(DECODE(B.item_id,'M0002',B.sales,0)) PASTA,
       SUM(DECODE(B.item_id,'M0003',B.sales,0)) PIZZA,
       SUM(DECODE(B.item_id,'M0004',B.sales,0)) SEA_FOOD,
       SUM(DECODE(B.item_id,'M0005',B.sales,0)) STEAK,
       SUM(DECODE(B.item_id,'M0006',B.sales,0)) SALAD_BAR,
       SUM(DECODE(B.item_id,'M0007',B.sales,0)) SALAD,
       SUM(DECODE(B.item_id,'M0008',B.sales,0)) SANDWICH,
       SUM(DECODE(B.item_id,'M0009',B.sales,0)) WINE,
       SUM(DECODE(B.item_id,'M0010',B.sales,0)) JUICE
FROM reservation A, order_info B
WHERE A.reserv_no = B.reserv_no
GROUP BY SUBSTR(A.reserv_date,1,6)
ORDER BY SUBSTR(A.reserv_date,1,6);


-- 1 ~ 12월 까지의 통계자료로 출력하시오 



/*
문제 
월별 온라인_전용 상품 매출액을 일요일부터 월요일까지 구분해 출력하시오 
날짜, 상품명, 일요일, 월요일, 화요일, 수요일, 목요일, 금요일, 토요일의 매출을 구하시오 
*/

SELECT  SUBSTR(reserv_date,1,6) 날짜,  
          A.product_name 상품명,
          SUM(DECODE(A.WEEK,'1',A.sales,0)) 일요일,
          SUM(DECODE(A.WEEK,'2',A.sales,0)) 월요일,
          SUM(DECODE(A.WEEK,'3',A.sales,0)) 화요일,
          SUM(DECODE(A.WEEK,'4',A.sales,0)) 수요일,
          SUM(DECODE(A.WEEK,'5',A.sales,0)) 목요일,
          SUM(DECODE(A.WEEK,'6',A.sales,0)) 금요일,
          SUM(DECODE(A.WEEK,'7',A.sales,0)) 토요일   
FROM
      (
        SELECT A.reserv_date,
               C.product_name,
               TO_CHAR(TO_DATE(A.reserv_date, 'YYYYMMDD'),'d') WEEK,
               B.sales
        FROM reservation A, order_info B, item C
        WHERE A.reserv_no = B.reserv_no
        AND   B.item_id   = C.item_id
        AND   B.item_id = 'M0001'
      ) A
GROUP BY SUBSTR(reserv_date,1,6), A.product_name
ORDER BY SUBSTR(reserv_date,1,6);

-- > 1 ~ 12월까지 출력하시오 
select a1.매출월
     , nvl(b1.상품명,'SPECIAL_SET') as 상품명
     , nvl(b1.일요일,0) as 일요일
     , nvl(b1.월요일,0) as 월요일
     , nvl(b1.화요일,0) as 화요일
     , nvl(b1.수요일,0) as 수요일
     , nvl(b1.목요일,0) as 목요일
     , nvl(b1.금요일,0) as 금요일
     , nvl(b1.토요일,0) as 토요일
from (select '2017' || lpad(level,2,'0') as 매출월
        from dual
        connect by level <= 12) a1
    , (SELECT  SUBSTR(reserv_date,1,6) 날짜,  
          A.product_name as 상품명,
          SUM(DECODE(A.WEEK,'1',A.sales,0)) 일요일,
          SUM(DECODE(A.WEEK,'2',A.sales,0)) 월요일,
          SUM(DECODE(A.WEEK,'3',A.sales,0)) 화요일,
          SUM(DECODE(A.WEEK,'4',A.sales,0)) 수요일,
          SUM(DECODE(A.WEEK,'5',A.sales,0)) 목요일,
          SUM(DECODE(A.WEEK,'6',A.sales,0)) 금요일,
          SUM(DECODE(A.WEEK,'7',A.sales,0)) 토요일   
        FROM
          (
            SELECT A.reserv_date,
                   C.product_name,
                   TO_CHAR(TO_DATE(A.reserv_date, 'YYYYMMDD'),'d') WEEK,
                   B.sales
            FROM reservation A, order_info B, item C
            WHERE A.reserv_no = B.reserv_no
            AND   B.item_id   = C.item_id
            AND   B.item_id = 'M0001'
          ) A
        GROUP BY SUBSTR(reserv_date,1,6)
               , A.product_name
          )b1
where a1.매출월 = b1.날짜 (+)
order by 1;
