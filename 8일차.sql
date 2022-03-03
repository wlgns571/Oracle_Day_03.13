/*

    서브쿼리 sub query
    SQL문장안에 보조로 사용되는 또다른 select 문 형태에 따라
    
    1. 일반 서브쿼리 (select 절) : 스칼라서브쿼리라고도 함.
    2. 인라인 뷰    (from 절)
    3. 중첩 쿼리    (where 절)

*/

select a.emp_name
     , b.department_name
from employees a
   , departments b
where a.department_id = b.department_id;

-- 일반 서브쿼리 (스칼라 서브쿼리)
--  조회 대상건이 1건만 조회 되어야함(하나가 하나에 매핑이 되어야한다)
--  메인 쿼리의 모든 행이 검색을 하기 때문에
--  대상 테이블의 건수가 적어야함.
--  건수가 많으면 성능에 부하가 걸림. (간단한 코드성 테이블에 사용하는것이 좋음)
select a.emp_name
--     , a.department_id
     , (select department_name 
        from departments 
        where department_id = a. department_id) as nm
--     , a.job_id
     , (select job_title
        from jobs
        where job_id = a.job_id ) as job_nm
from employees a;

-- 인라인 뷰 ( from 절 ) : select 결과를 테이블처럼 사용

select*
from(
        select rownum as rnum
             , a.*
        from employees a
                
    ) t1 --<-- 하나의 테이블처럼
where t1.rnum between 1 and 10;

-- 게시판 페이징 처리 쿼리
select*
from ( select rownum as rnum
            , b.*
       from (
                select a.*
                from employees a
                order by emp_name
            )b
     )
where rnum between 1 and 10;

-- where에 오는 중첩쿼리

-- 직원 평균 급여이상을 받는 직원의 수
select count(*)
from employees
where salary >= (select avg(salary) -- 값 그자체를 찾는 select문
                 from employees);
        
        
-- 세미조인 (exists) 존재하는지 체크 
-- not exists는 존재하지 않는지 체크
select *
from 학생 a
where exists ( select * -- exists 안쪽 select문은 조회 되지 않음
               from 수강내역
               where 학번 = a.학번);
               
select *
from 학생 a
where a.학번 in ( select 학번 -- in은 select안의 결과로 조회
                  from 수강내역);

-- 카타시안 조인 ( 조인이 제대로 되지않으면 중복이 일어남 )
select *
from 학생
   , 수강내역; -- 학생과 수강내역이 제대로 조인되지않음

select *
from 학생
   , 수강내역
   , 과목
where 학생.학번 = 수강내역.학번; -- 과목이 제대로 조인되지않음

-- 일반 동등조인
select *
from 학생
   , 수강내역
   , 과목
where 학생.학번 = 수강내역.학번
and 수강내역.과목번호 = 과목.과목번호;
-- 안시 조인 (ANSI join) [from 절에서 join 해결을 본다]
select *
from 학생
inner join 수강내역
on (학생.학번 = 수강내역.학번)
inner join 과목
on (수강내역.과목번호 = 과목.과목번호); -- join 할 수록 inner구문이 늘어난다.

-- 외부조인 outer join
select *
from 학생
   , 수강내역
   , 과목 
where 학생.학번 = 수강내역.학번 (+)
and 수강내역.과목번호 = 과목.과목번호 (+);
-- ANSI 외부조인 LEFT, RIGHT
select *
from 학생
left outer join 수강내역
on (학생.학번 = 수강내역.학번)
left join 과목
on (수강내역.과목번호 = 과목.과목번호);

select 학번
     , 학생.이름
from 학생
inner join 수강내역
using (학번); -- 컬럼명이 동일할때

-- full outer join
create table test_a (emp_id number);
create table test_b (emp_id number);

insert into test_a values (10);
insert into test_a values (20);
insert into test_a values (40);
insert into test_b values (10);
insert into test_b values (20);
insert into test_b values (30);

select *
from test_a a
   , test_b b
where a.emp_id(+) = b.emp_id (+); -- 둘다 outerjoin을 사용 x [문법오류]

select *
from test_a a
full outer join test_b b
on (a.emp_id = b.emp_id); -- ansi는 전부 null값 포함 가능

select count(*)
     , emp_name
from employees
where salary >= (select avg(salary) -- 값 그자체를 찾는 select문
                 from employees)
group by emp_name
union
select count(*)
     , '총 합'
from employees
where salary >= (select avg(salary) -- 값 그자체를 찾는 select문
                 from employees);