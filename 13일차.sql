/* window절
   Rows : 로우단위로 범위 지정
   Range : 논리적 단위로 범위 지정
   
   unbounded preceding : 파티션으로 구분된 첫번째 로우가 시작지점
   unbounded following : 파티션으로 구분된 마지막 로우가 끝지점
   current row : 현재 로우
*/
select department_id
     , emp_name
     , hire_date
     , sum(salary) over(partition by department_id
                        order by hire_date
                        rows between unbounded preceding
                        and unbounded following
                        ) as all_salary
     , salary
     , sum(salary) over(partition by department_id
                        order by hire_date
                        rows between unbounded preceding
                        and current row
                        ) as curr_salary
from employees
where department_id in (30,90);

/* 월별 누적금액을 출력하시오
   reservation, order_info 사용
   날짜 : reserv_date, 매출 : sales
*/
select a.월
     , nvl(b.월매출,0) as 월매출
     , nvl(b.누적집계,0) as 누적집계
from   (select '2017' || lpad(level, 2, '0') as 월
        from dual
        connect by level <= 12) a
        
      ,(select c.월
             , c.amt as 월매출
             , sum(amt) over(order by 월
                             rows between unbounded preceding
                             and current row) as 누적집계
        from ( select substr(a.reserv_date,0,6)as 월
                     , sum(b.sales) as amt
               from reservation a
                   , order_info b
               where a.reserv_no = b.reserv_no
               group by substr(a.reserv_date,0,6)
               ) c 
        ) b
where a.월 = b.월 (+)
order by 1
;

select hire_date
     , salary
     , sum(salary) over(order by hire_date
                        rows between 3 preceding and 1 preceding) pre3_1
     , sum(salary) over(order by hire_date
                        rows between 1 following and 3 following) fol1_3
from employees
where department_id in (60,90);

-- range 논리적 범위
select department_id
     , emp_name
     , hire_date
     , salary
     , sum(salary) over(partition by department_id
                        order by hire_date
                        range 365 preceding) as pre365
     , sum(salary) over(partition by department_id
                        order by hire_date
                        range between 365 preceding and unbounded following) as cur365
from employees
where department_id in (30,90);

-- FIRST_VALUE 주어진 그룹에서 첫번째, LAST_VALUE 주어진 그룹에서 마지막, NTH_VALUE n번째
select department_id
     , emp_name
     , hire_date
     , salary
     , first_value(salary) over(partition by department_id 
                                order by hire_date
                                rows between unbounded preceding and current row) as first
     , last_value(salary) over(partition by department_id 
                               order by hire_date
                               rows between unbounded preceding and current row) as last
     , nvl(nth_value(salary,2) over(partition by department_id 
                                    order by hire_date
                                    rows between unbounded preceding and current row),0) as nth
from employees
where department_id in (30,60);

select t1.*
     -- 분석함수는 최대한 인라인뷰 바깥에서 사용.(자원소모 심함)
     -- 전체 비율중의 각 월에 해당하는 매출의 비율계산 ( ratio_to_report() )
     , round(ratio_to_report(t1.amt) over() * 100, 2) || '%' as ratio
from(select substr(period,1,4) as years
         , region
         , sum(loan_jan_amt) as amt
    from kor_loan_status
    where substr(period,1,4) = '2013'
    group by substr(period,1,4)
           , region
    ) t1;
    
/* WITH 
   별칭으로 사용한 select 문이 참조 가능함
   반복되는 서브쿼리면 변수처럼 사용가능
   통계쿼리나 튜닝시 많이 사용
   temp 라는 임시 테이블을 사용해서 장시간 걸리는 쿼리결과를 저장하여 이용 oracle 9 이상 지원
   장점 : 가독성이 좋음
   단점 : 메모리에 부담을 줄 수 있음
*/
with a as ( select employee_id
                 , emp_name
            from employees
)
select *
from a;

-- 학생의 학번과 수강내역건수
select a.학번
     , a.이름
     , count(a.수강내역번호) as 수강내역건수
from(select 학생.학번
          , 학생.이름
          , 학생.학기
          , 수강내역.수강내역번호
          , 수강내역.과목번호
     from 학생
        , 수강내역
     where 학생.학번 = 수강내역.학번 (+)
     ) a
group by a.학번
       , a.이름;
       
with t1 as (
            select 학생.학번
                 , 학생.이름
                 , 학생.학기
                 , 수강내역.수강내역번호
                 , 수강내역.과목번호
            from 학생
               , 수강내역
            where 학생.학번 = 수강내역.학번 (+)
            )
   , t2 as (
            select t1.학번
                 , t1.이름
                 , count(t1.수강내역번호)
            from t1
            group by t1.학번
                   , t1.이름
            )
   , t3 as (
            select a.과목이름
                 , a.과목번호
                 , a.학점
                 , t1.학번
            from 과목 a
               , t1
            where a.과목번호 = t1.과목번호
            )
select *
from t3;

/* 고객별 매출
   상품별 매출
   요일별 매출
   member, cart, prod
*/
with t1 as ( select a.mem_id
                  , a.mem_name
                  , b.cart_qty
                  , c.prod_id
                  , c.prod_name
                  , c.prod_sale
             from member a
                , cart b
                , prod c
             where a.mem_id = b.cart_member
             and   b.cart_prod = c.prod_id
)
   , t2 as ( -- 고객별 집계
            select t1.mem_id
                 , t1.mem_name
                 , sum(t1.cart_qty * t1.prod_sale) as mem_sale
            from t1
            group by t1.mem_id
                   , t1.mem_name
)
   , t3 as ( -- 상품별 집계
            select t1.prod_id
                 , t1.prod_name
                 , sum(t1.cart_qty * t1.prod_sale) as prod_sale
            from t1
            group by t1.prod_id
                   , t1.prod_name
)
select *
from t3;