-- 집계함수
SELECT COUNT (*)                      -- null 포함
     , COUNT (department_id)          -- default all
     , COUNT (ALL department_id)      -- 중복 포함
     , COUNT (DISTINCT department_id) -- 중복 제거
FROM employees;

SELECT SUM(salary) -- 합계
     , AVG(salary) -- 평균
     , MIN(salary) -- 최소
     , MAX(salary) -- 최대값
FROM employees;

-- 50번 부서의 평균 급여와 직원수를 구하시오.

SELECT ROUND(AVG (salary),2) as 평균
     , COUNT(*) -- PK가 아닌경우 널값이 존재하기에 사용하지 않는것이 좋다.
     , COUNT(employee_id) as 직원수
FROM employees
WHERE department_id = 50;

-- GROUP BY 절
-- 집계함수를 제외한 컬럼은 무조건 group by절 안에 들어가야한다.
SELECT department_id
     , ROUND(AVG(salary),2) as 부서월급평균
     , COUNT(employee_id) as 직원수
FROM employees
WHERE department_id is not null
GROUP BY department_id -- 그룹집계 대상 ( ex: 부서별 집계 )
ORDER BY 1;

SELECT department_id
     , job_id
     , ROUND(AVG(salary),2) as 부서월급평균
     , COUNT(employee_id) as 직원수
FROM employees
WHERE department_id is not null
GROUP BY department_id , job_id-- 그룹집계 대상 ( ex: 부서별 집계를 먼저 하고 다시 직업아이디를 집계 )
ORDER BY 1;

-- 2013년도의 지역별 총대출잔액을 조회하시오
-- kor_loan_status 테이블 활용
select round(sum(loan_jan_amt),0) as 총대출잔액
       , region as 지역
from kor_loan_status
where substr(period,1,4) = 2013
-- where period like '2013%'
group by region
order by 1;

-- '서울', '대전', '부산'의
-- 년도별, 지역별, 대출잔액합계를 구하시오
select substr(period,1,4) as 년도
     , region 
     , sum(loan_jan_amt) as 대출잔액합계
from kor_loan_status
where region in ('서울', '대전', '부산')
group by substr(period,1,4), region
order by 1;

select country_region
     , country_subregion
     , country_name
from countries
group by country_region
       , country_subregion
       , country_name
order by 1;

-- 고용년도별 총급여, 사원수를 출력하시오.
-- employees 테이블은 hire_date 활용
desc employees; -- 데이터 타입 조회

select to_char(hire_date,'YYYY') as 고용년도회
       -- hire_date는 날짜 데이터 타입이기에 연도만 문자열로 빼낸다.
     , round(avg(salary),2) as 급여평균
     , count(*) as 직원수
from employees
group by to_char(hire_date,'YYYY')
having count(*) >= 10 -- 집계결과에 조건이 필요할때
order by 직원수;
-- FROM -> WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER ( 실행순서 )

-- 직원이 10명 이상인 부서만 출력하시오. (employees)
select department_id as 부서명
     , count(*) as 직원수
from employees
where department_id is not null
group by department_id
having count(*) >= 10
order by 직원수;

/*
 ROLLUP (expr1, expr2...) 말아 올린다.
 expr로 명시한 표현식을 기준으로 집계한 결과를 출력함
 표현식 수가 n개이면 n + 1 레벨까지 집계
*/
SELECT period
     , gubun
     , decode(grouping_id (period, gubun),1,'소계',3,'총합',gubun) -- 그룹해서 null값에 이름 부여
     , sum(loan_jan_amt) as 합계
FROM kor_loan_status
where period like '2013%'
group by rollup(period, gubun);

-- NULL 관련 함수
-- NVL(해당 값, 0) -> null값을 0으로 처리하겠다.
select emp_name
     , salary
     , NVL(commission_pct,0) as commision_pct
     , salary * NVL(commission_pct,0)
from employees;