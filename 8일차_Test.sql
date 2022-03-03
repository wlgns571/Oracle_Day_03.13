-- 스칼라 서브쿼리를 사용하여 수강 과목명을 출력하시오.   
select 이름
     , 과목번호
     , (select 과목이름
        from 과목
        where 수강내역.과목번호 = 과목.과목번호 ) as 과목명
from 학생
   , 수강내역
where 학생.학번 = 수강내역.학번;

-- 평점평균 이상인 학생만 조회하시오.
select 이름
     , 평점
from 학생
where 평점 >= (select avg(평점)
              from 학생);
              
-- 수강이력이 가장 많은 학생의 정보를 출력하시오.
-- 중첩쿼리 활용 (where)
select *
from 학생
where 학번 = ( select 학번
                from( select 학번
                           , count(학번)
                      from 수강내역
                      group by 학번
                      order by 2 desc)
                where rownum = 1);
                
-- job_history 가 있는 부서의 부서 id, name을 출력하시오.
-- exists 활용, departments, job_history 테이블 활용

select a.department_id
     , a.department_name
from departments a
where exists ( select *
               from job_history
               where department_id = a.department_id);
               
               
               
               
               
/*
   sales, customers, countries 테이블 활용
   
   관련컬럼 : sales_month, amount_sold, country_name
   
   2000년 이탈리아 평균 매출액 (연평균) 보다 큰 월평균 매출액을 구하시오.
   
   ex) 검색조건 2000년 매출
       이탈리아
       1.연평균, 2.월평균, 3.비교
*/
select substr(sales_month,5,6)
     , avg(amount_sold)
from sales 
where avg(amount_sold) > (select substr(sales_month,1,4)
                     , avg(amount_sold)
                from sales a
                   , customers b
                   , countries c
                where a.cust_id = b.cust_id
                and b.country_id = c.country_id
                and a.sales_month like '2000%'
                and c.country_name like 'Italy'
                group by substr(sales_month,1,4))
group by substr(sales_month,5,6);




