-- 계층형 쿼리 사용

select department_id
     , parent_id
     , lpad(' ', 3 * (level -1)) || department_name
     , level
from departments
start with parent_id is null                -- 시작 지점
connect by prior department_id = parent_id; -- 계층형이 어떤식으로 연결 되는지

insert into departments (department_id
                      , department_name
                      , parent_id)
values ((select nvl(max(department_id),0) +10
         from departments )
         ,'빅데이터 팀'
         , 230
         );
         

select a.employee_id
     , lpad(' ', 3 * (level -1)) || a.emp_name as nm
     , level
     , b.department_name
     , a.department_id
     , connect_by_root department_name as root_name
     , sys_connect_by_path(department_name, '|') as path -- 본인의 계층으로 오기까지의 레벨을 보여줌
     , connect_by_isleaf as leaf -- 마지막 노드 1, 자식이 있으면 0
from employees a
   , departments b
where a.department_id = b.department_id
--and a.department_id = 30
start with a.manager_id is null
connect by prior a.employee_id = a.manager_id
and a.department_id = 30   -- 최상위 루트 검색 (30번은 아니지만) / 실행순서 확인필수.
order siblings by department_name; -- 계층형 쿼리에 정렬을 넣으려면 siblings 키워드로 조회 가능.
