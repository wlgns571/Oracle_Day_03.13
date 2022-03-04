--grant create view to java; -- 자바에 권한 부여 (system[메인]에서)

create or replace view emp_dept as
select a.employee_id
     , a.emp_name
     , a.department_id
     , b.department_name
from employees a
   , departments b
where a.department_id = b.department_id;

select *
from emp_dept;
-- java 에서 study 계정에게 조회권한 부여
grant select on emp_dept to study;
-- study 계정에서 조회
select *
from java.emp_dept;

-- view 삭제
drop view emp_dept;

/* 시노님
   synonym은 동의어란 뜻으로 객체 이름에 동의어를 만드는 것
   public 모든 사용자 접근가능
   private 특정 사용자만 접근가능
*/
--grant create synonym to java;
create or replace synonym syn_channel
for channels;

select *
from syn_channel;

-- java 에서 study 계정에게 조회권한 부여
grant select on syn_channel to study;

-- study 계정에서 조회
select *
from java.syn_channel;

-- system 계정에서 생성해줘야함.
create or replace public synonym syn
for java.channels;

-- public을 사용했기에 전체 계정에서 조회가능 
select *
from syn;

/* 시퀀스 sequence는 자동 순번을 반환
   nextval, currentval
*/
create sequence my_seq1
increment by 1  -- 증가 숫자
start with   1  -- 시작 숫자
minvalue     1  -- 최소값
maxvalue    100 -- 최대값
nocycle         -- 최대값 도달시 생성 중지 (cycle이면 다시 1~100까지 돈다)
nocache;        -- 미리 값 할당하지 않음

select my_seq1.nextval -- 증가
from dual;

select my_seq1.currval -- 현재의 시퀀스 값
from dual;

create table ex10_1(
    seq number
  , update_dt timestamp default systimestamp
);

insert into ex10_1 (seq) values(my_seq1.nextval);

select *
from ex10_1;

-- 최소 1, 최대 99999999, 1000부터 2씩 증가하는
-- 시퀀스를 만드시오. 이름은 order_seq

create sequence order_seq1
increment by   2  -- 증가 숫자
start with   1000  -- 시작 숫자
minvalue       1  -- 최소값
maxvalue    99999999 -- 최대값
nocycle         -- 최대값 도달시 생성 중지 (cycle이면 다시 1~100까지 돈다)
nocache;        -- 미리 값 할당하지 않음

create table ex10_2(
    seq number
  , update_dt timestamp default systimestamp
);

insert into ex10_2 (seq) values(order_seq1.nextval);

delete ex10_2;
commit;

select nvl(max(seq),0) + 1
from ex10_2;

insert into ex10_2 (seq) 
values((select nvl(max(seq),0) + 1
            from ex10_2)
        );
select *
from ex10_2;