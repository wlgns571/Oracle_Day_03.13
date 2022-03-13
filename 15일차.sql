 -- 최초 실행구문 
SET SERVEROUTPUT ON
/*익명블록 ( 이름이 없는 PL/SQL )*/
DECLARE
 -- 선언부
 vi_num Number;
BEGIN
 -- 실행부
 vi_num := 100;    -- 변수 값 할당
 -- 프린트
 DBMS_OUTPUT.PUT_LINE('출력: ' || vi_num);
END;
 -- 결과 값만 보려면 [보기 -> DBMS 출력]
 
DECLARE
 -- 선언부
 -- constant는 상수 선언
 -- 상수는 값을 변경 할 수 없으므로 실행부에서 값을 변경할 경우 오류 발생
 -- 선언부에서 무조건 값을 할당 해야함.
 vi_num CONSTANT Number := 2;
BEGIN
 -- 프린트
 DBMS_OUTPUT.PUT_LINE('출력: ' || vi_num);
END;

-- DML 문 사용
DECLARE
 -- 하나의 변수에는 하나의 값만 들어간다.
 vs_emp_name VARCHAR2(80);
 vs_dep_name VARCHAR2(80);
BEGIN
 SELECT a.emp_name, b.department_name
 INTO vs_emp_name, vs_dep_name
 FROM employees a
    , departments b
 WHERE a.department_id = b.department_id
 -- 조건을 지우게 되면 값이 많아지기에 오류가 발생한다.
 AND   a.employee_id = 100;
 DBMS_OUTPUT.PUT_LINE(vs_emp_name || '-' || vs_dep_name);
END;

-- 상수 : 값'최숙경' 을 선언하고
-- 해당 상수로 학번을 조회하여 출력하시오
DECLARE
 -- 상수 선언 및 값 할당
 vs_stu_name constant 학생.이름%type := '최숙경';
 vs_stu_num 학생.학번%type;
BEGIN
 -- 학번 조회
 -- 출력
 select 학번
 into vs_stu_num
 from 학생
 where 이름 = '최숙경';
 DBMS_OUTPUT.PUT_LINE(vs_stu_name || ':' || vs_stu_num);
END;

DECLARE
 -- 상수 선언 및 값 할당
 -- :(콜론)좌측은 값 바인딩 (:nm) 뒤에 붙는 이름은 상관이 없다.
 vs_stu_name constant 학생.이름%type := :nm;
 vs_stu_num 학생.학번%type;
BEGIN
 -- 학번 조회
 -- 출력
 select 학번
 into vs_stu_num
 from 학생
 where 이름 = vs_stu_name;
 DBMS_OUTPUT.PUT_LINE(vs_stu_name || ':' || vs_stu_num);
END;

-- 변수가 필요없을때
-- declare 선언 하지 않아도 된다.
BEGIN
 DBMS_OUTPUT.PUT_LINE('3 * 3 = ' || 3 * 3);
 DBMS_OUTPUT.PUT_LINE('3 * 4 = ' || 3 * 4);
END;

-- IF문
DECLARE
 vn_num number := :params;
BEGIN
 IF vn_num <= 10 THEN
    DBMS_OUTPUT.PUT_LINE('10 보다 작음');
 ELSIF vn_num < 100 THEN
    DBMS_OUTPUT.PUT_LINE('100 보다 작음');
 ELSE
    DBMS_OUTPUT.PUT_LINE('100 보다 큼');
 END IF;
END;

-- LOOP 문 (반복문)
DECLARE
 vn_base number := 3;
 vn_cnt  number := 1;
BEGIN
 LOOP
  DBMS_OUTPUT.PUT_LINE(vn_base || '*' || vn_cnt || '=' || vn_base * vn_cnt);
  vn_cnt := vn_cnt + 1;
  EXIT WHEN vn_cnt > 9; -- 루프종료 (무한루프에 빠지지않게 필수로 작성)
 END LOOP;
END;

DECLARE
 vn_base number := 2;
 vn_cnt  number := 1;
BEGIN
 LOOP
 DBMS_OUTPUT.PUT_LINE(vn_base || ' 단');
   loop
    DBMS_OUTPUT.PUT_LINE(vn_base || '*' || vn_cnt || '=' || vn_base * vn_cnt);
    vn_cnt := vn_cnt + 1;
    exit when vn_cnt > 9;
   end loop;
   vn_cnt := 1;
   vn_base := vn_base + 1;
  EXIT WHEN vn_base > 9;
 END LOOP;
 DBMS_OUTPUT.PUT_LINE('종료');
END;

-- 강사님 답
DECLARE
 i number := 2;
 j number;
BEGIN
 LOOP
 DBMS_OUTPUT.PUT_LINE(i || ' 단');
 j := 1;
   loop
    DBMS_OUTPUT.PUT_LINE(i || '*' || j || '=' || i * j);
    j := j + 1;
    exit when j > 9;
   end loop;
   i := i + 1;
  EXIT WHEN i > 9;
 END LOOP;
 DBMS_OUTPUT.PUT_LINE('종료');
END;

-- WHILE 반복문
DECLARE 
 i number := 2;
 j number := 1;
BEGIN
 WHILE j <= 9 -- 해당 조건이 true이면 반복
 LOOP
  DBMS_OUTPUT.PUT_LINE(i || '*' || j || '=' || i * j);
  j := j + 1;
 END LOOP; -- LOOP 탈출 조건이 없어도 상관없음 ( 때에따라 탈출조건(exit when) 사용 가능 )
END;

-- FOR 문
DECLARE
 i number := 2;
BEGIN
 -- j는 자동증가 ex) 1 ~ 9까지
 -- for문 에서는 따로 변수 선언 하지 않아도 됨.
 FOR j IN 1..9
 LOOP
  DBMS_OUTPUT.PUT_LINE(i || ' * ' || j || '=' || i * j);
 END LOOP;
END;

-- 변수 선언 없이 구구단 2단 ~ 9단 까지 출력하시오.
DECLARE
BEGIN
 FOR i IN 2..9
 loop
 DBMS_OUTPUT.PUT_LINE(i || ' 단');
     FOR j IN 1..9
      loop
       DBMS_OUTPUT.PUT_LINE(i || ' * ' || j || ' = ' || i * j);
      end loop;
 end loop;
END;

-- 입력받은 수 만큼 * 을 찍는 익명블록을 작성하시오
-- 5 입력 *****
-- 10 입력 ***********

DECLARE
 vn_input number := :params;
 vs_star varchar2(4000);
BEGIN
 for i IN 1..vn_input
     loop
       vs_star := vs_star || '*';
     end loop;
 DBMS_OUTPUT.PUT_LINE('입력받은 개수: ' || vn_input || '개');
 DBMS_OUTPUT.PUT_LINE('');
 DBMS_OUTPUT.PUT_LINE(vs_star);
END;

BEGIN
 for i IN REVERSE 1..9 -- <-- 방향으로 감소함
     loop
     CONTINUE WHEN i = 5; -- 입력받은 값만 건너뛰고 루프 진행 
        DBMS_OUTPUT.PUT_LINE(i);
     end loop;
END;

/**/
select my_mod(4,2) -- my_mod 위에 Ctrl + 클릭 하면 해당 함수를 보여준다.
from dual;

-- OR REPLACE를 사용하면 내용이 덮어씌워진다.
CREATE OR REPLACE FUNCTION my_mod(num1 number, num2 number)
 RETURN number -- 반환 타입
IS
 vn_remainder number := 0; -- 반환 나머지
 vn_quotient number := 0;
BEGIN
 vn_quotient := FLOOR(num1 / num2);
 vn_remainder := num1 - (num2 * vn_quotient);
 RETURN vn_remainder;
END;

-- 학번을 입력받아 수강 건수를 리턴하는 함수를 작성하시오
-- 함수명 : fn_score
-- 입력값 : 학번 (number)
-- 리턴값 : 수강건수 (number)
create or replace function fn_score(num1 number)
 return number
IS
 vn_학번 number := 0;
 vn_수강건수 number := 0;
BEGIN
     select b.학번, count(*)
     into vn_학번, vn_수강건수
     from 학생 a, 수강내역 b
     where a.학번 = b.학번
     and a.학번 = num1
     group by a.이름
            , b.학번;
 return vn_수강건수;
END;

-- 강사님 풀이
create or replace function fn_score(hak number)
 return number
is
vn_cnt number;
begin
 select count(b.수강내역번호)
     into vn_cnt
     from 학생 a, 수강내역 b
     where a.학번 = b.학번 (+)
     and a.학번 = hak;
 return vn_cnt;
end;

select fn_score(1997131542)
from dual;

select 이름
     , nvl(fn_score(학번),0) as 수강건수
from 학생;