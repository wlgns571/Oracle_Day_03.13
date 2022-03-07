-- 분석함수
select count(employee_id) over()
     , round(avg(salary) over(),2) as 평균급여 
     , emp_name
from employees;

select *
from( 
        select rownum as rnum
             , count(*) over() as 전체건수
             , a.*
        from (
                select emp_name
                     , email
                     , salary
                from employees
                order by emp_name
        )a
    )
where rnum between 1 and 10;

SELECT emp_name
    , email
    , salary
FROM employees
ORDER BY emp_name;



SELECT *    
FROM ( SELECT rownum as rnum
            , count(*) over() as 전체건수
            , a.*
           from( select emp_name
                        , email
                        , salary
                        from employees
                        order by emp_name  
                ) a  
      )
WHERe rnum between 1 and 10;

--RANK()          "순위반환" 동일 값이 있을 경운 1 2 2 4 <- 중복 건너 뜀 
--DENSE_RANK()    "순위반환" 동일 값이 있어도 건너뛰지 않음 1 2 2 3

SELECT emp_name
    , department_id
    , salary
    , RANK() OVER (PARTITION BY department_id
                    ORDER BY salary desc) as 부서별급여순위
    , DENSE_RANK() OVER (PARTITION BY department_id
                    ORDER BY salary desc) as 부서별급여순위2               
    , RANK() OVER (ORDER BY salary desc) as 전체급여순위
FROM employees;                   
--WHERE department_id = 50;


-- 학생의 전공별 평점기준으로 순위를 출력하시오. DENSE_RANK 사용
select 이름
     , 전공
     , 평점
     , dense_rank() over (partition by 전공
                        order by 평점 desc) as 순위
     , dense_rank() over (order by 평점 desc) as 전체순위
from 학생
order by 2;

-- 전체순위 1 ~ 3등만 출력하시오.
select 이름
     , 전공
     , 평점
     , 순위
     , 전체순위
from (select 이름
           , 전공
           , 평점
           , dense_rank() over (partition by 전공
                                order by 평점 desc) as 순위
           , dense_rank() over (order by 평점 desc) as 전체순위
       from 학생)
where 전체순위 between 1 and 3;
-- where 전체순위 <= 3;

/*
 NTILE(expr) 파티션별로 expr에 명시된 값 만큼 분할한 결과 반환
 NTILE(3) 1 ~ 3 수를 반환 분할하는 수를 버킷(주머니) 수라고 함.
*/

select department_id
     , emp_name
     , salary
     , count(*) over(partition by department_id) as cnt
     , Ntile(3) over(partition by department_id
                     order by salary) as ntiles
from employees
where department_id in(30, 60);

-- 부서별 급여를 4분위로 나누었을때 1분위에 속하는 직원만 출력하시오.
select *
from(select department_id
             , emp_name
             , salary
             , Ntile(4) over(partition by department_id
                             order by salary) as 분위
     from employees)
where 분위 = 1;

-- width_bucket(테이블, min, max, 나누기()) 구간으로 나누어줌. [함수] 분석함수 아님.
select department_id
     , emp_name
     , salary
     , Ntile(4) over(partition by department_id
                     order by salary) as 분위
     , width_bucket(salary, 1000, 10000, 4) as width
     -- 1000 ~ 3250, 3250 ~ 5500 ...
from employees
where department_id in (30, 60);

/* LAG  선행로우 값 반환
   LEAD 후행로우 값 반환
*/
select emp_name
     , salary
     , department_id
     , lag(emp_name, 1, '가장높음') over(partition by department_id
                                        order by salary desc) as lag_name
     , lead(emp_name, 1, '가장낮음') over(partition by department_id
                                        order by salary desc) as lead_name
from employees
where department_id = 30;

-- 학생의 '전공별' '평점'을 기준으로 한단계 위(점수 높은)의 학생이름과 평점 차이를 출력하시오.
select 이름
     , 전공
     , 평점
     , 한단계위학생
     , 한단계위평점 - 평점 as 차이
from (select 이름
         , 전공
         , round(평점,2) as 평점
         , lag(이름, 1, '1등') over(partition by 전공
                                   order by 평점 desc) as 한단계위학생
         , lag(round(평점,2), 1, round(평점,2)) over (partition by 전공
                                   order by 평점 desc) as 한단계위평점
         , lead(round(평점,2), 1, round(평점,2)) over (partition by 전공
                                   order by 평점 desc) as 한단계아래평점
        
      from 학생);

-- 2013년도 대출금이 많은 5개 지역의 정보를 출력하시오.
-- kor_loan_status
select *
from(   
        select substr(period,0,4) as 년도
             , region as 지역
             , sum(loan_jan_amt) as 대출합산금액
             , dense_rank() over (partition by substr(period,0,4)
                                  order by sum(loan_jan_amt) desc) as 순위
        from kor_loan_status
        where substr(period,0,4) = '2013'
        group by substr(period,0,4)
               , region)
where 순위 <= 5;

-- 강사님 코드 
select *
from (
        select substr(period,0,4) as years
             , region
             , sum(loan_jan_amt) as amt
             , rank() over(order by sum(loan_jan_amt) desc) as ranks
        from kor_loan_status
        where substr(period,0,4) = '2013'
        group by substr(period,0,4)
               , region
      )
where ranks <= 5;