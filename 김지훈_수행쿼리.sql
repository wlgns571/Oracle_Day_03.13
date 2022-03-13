-- 문제 1. 다음과 같은 구조의 테이블스페이스를 생성하시오
-- 최초 테이블 스페이스 생성
create tablespace TS_STUDY
datafile '/u01/app/oracle/oradata/XE/ts_study.dbf'
size 100m autoextend on next 5m;

-- 문제 2.다음 계정을 생성하시오
-- (기존에 java2가 존재하는 경우 삭제 : DROP USER java2 CASCADE )
create user java2 identified by oracle
default tablespace TS_STUDY
temporary tablespace temp;

-- 문제 3. 문제 2에서 생성한 계정 java2 계정이 DBMS에 접속하고 일반적인 작업을 하기 위한
-- 권한(Privileges) 또는 롤(Role)을 부여하시오
-- ROLE : CONNECT, RESOURCE
grant connect, resource to java2; 

-- 문제 4. 다음과 같은 구조의 테이블을 생성하세요 (Comment 는 생성하지 않아도 됨)
create table EX_MEM (
    MEM_ID varchar2(10) not null
  , MEM_NAME varchar2 (20) not null
  , MEM_JOB varchar2 (30)
  , MEM_MILEAGE number(8,2) default 0
  , MEM_REG_DATE date default sysdate
  , CONSTRAINT PK_EX_MEM PRIMARY KEY(MEM_ID) -- 제약조건 이름 설정
);

comment on table EX_MEM is '임시회원테이블';
comment on column EX_MEM.MEM_ID is '아이디';
comment on column EX_MEM.MEM_NAME is '회원명';
comment on column EX_MEM.MEM_JOB is '직업';
comment on column EX_MEM.MEM_MILEAGE is '마일리지';
comment on column EX_MEM.MEM_REG_DATE is '등록일';

-- 문제 5. 문제 4에서 생성한 EX_MEM 테이블의 테스트를 진행하던 중 
-- 회원명 정보가 잘려서 들어가는 일이 발생하였다. 
-- 이에 회원명 컬럼의 사이즈를 20에서 50으로 변경하시오.

-- 타입수정
alter table ex_mem modify mem_name varchar2(50);

-- 문제 6. 1000부터 시작하여 9999까지 순환하는 SEQ_CODE 시퀀스를 생성하시오

create sequence SEQ_CODE
increment by   1  -- 증가 숫자
start with   1000  -- 시작 숫자
minvalue       1  -- 최소값
maxvalue     9999 -- 최대값
cycle         -- 최대값 도달시 순환 (nocycle이면 중지)
nocache;

-- 문제 7. EX_MEM 테이블에 다음 내용을 입력하는 입력 구문을 작성하시오

insert into EX_MEM (MEM_ID,MEM_NAME,MEM_REG_DATE) values ('hong','홍길동',sysdate);
-- mem_id와 mem_name이 not null 이기에 null값이 들어가면 안되어, 값을 한번에 넣어준다.

-- 문제 8. 회원테이블(member)에서 아이디, 회원명, 직업, 마일리지를 
-- 조회하여 EX_MEM 테이블에 입력하시오
-- (단, 회원테이블에서 취미가 독서, 등산, 바둑 으로 제한한다)

insert into ex_mem (mem_id,mem_name,mem_job,mem_mileage)
select mem_id
     , mem_name
     , mem_job
     , mem_mileage
from member
where mem_like in ('독서', '등산', '바둑');

-- 문제 9. EX_MEM 테이블에서 사원명이 ‘김’ 로 시작하는 사원을 삭제하시오

delete from ex_mem
where mem_name like '김%';

-- 문제 10. 회원테이블(member)에서 직업이 주부이고 마일리지가 1,000 에서 3,000인 회원정보를
-- 조회하시오. (출력형식은 아래와 같으며, 정렬은 마일리지 내림차순으로 한다. )

select mem_id
     , mem_name
     , mem_job
     , mem_mileage
from ex_mem
where mem_mileage between 1000 and 3000
order by 4 desc;

-- 문제 11. 아래의 쿼리를 논리연산자(OR)로 변경하시오.

SELECT PROD_ID
     , PROD_NAME
     , PROD_SALE
FROM PROD
where PROD_SALE = 23000 or PROD_SALE = 26000 or PROD_SALE = 33000;

-- 문제 12. 회원테이블에서 직업별 회원수, 최고마일리지, 평균마일리지를 구하는 쿼리를 작성하시오
-- ( 단, 조건은 회원수가 3명 이상으로 한다. 집계 마일리지는 천단위 구분표시 )
select *
from (
        select mem_job
             , count(mem_job) as mem_cnt
             , max(mem_mileage) as max_mlg
             , to_char(round(avg(mem_mileage),0),'99,999') as avg_mlg
        from member
        group by mem_job
)
where mem_cnt >= 3
order by 2;

-- 문제 13. 2005년 7월 28일의 장바구니테이블과 회원테이블을 조인하는 쿼리를 작성하시오
-- 일자는 장바구니번호(cart_no)로 구분
-- 동등조인(equi-join)으로 작성한다.

select a.mem_id
     , a.mem_name
     , a.mem_job
     , b.cart_prod
     , b.cart_qty
from member a
   , cart b
where a.mem_id = b.cart_member
and substr(b.cart_no,0,8) = '20050728';

-- 문제 14. 문제 13의 동일한 쿼리를 ANSI 조인으로 작성하시오

select a.mem_id
     , a.mem_name
     , a.mem_job
     , b.cart_prod
     , b.cart_qty
from member a
inner join cart b
on ( a.mem_id = b.cart_member )
where substr(b.cart_no,0,8) = '20050728';

-- 문제 15. 분석함수 RANK를 사용하여 직업별 마일리지 내림차순으로 순위를 조회하시오

select mem_id
     , mem_name
     , mem_job
     , mem_mileage
     , rank() over (partition by mem_job
                    order by mem_mileage desc) as mem_rank
from member;