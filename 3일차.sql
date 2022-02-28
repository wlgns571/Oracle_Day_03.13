-- 데이터 조작어 DML Data Manipulation Language
-- SELECT, INSERT, UPDATE, DELETE ...
-- CRUD 대부분의 소프트웨어가 가지는 기본적인 데이터 처리기능
-- Create, Read, Update, Delete

SELECT *  -- * 는 전체
FROM employees;

SELECT emp_name as en  -- 컬럼과 컬럼의 구분은 콤마(,)로
     , hire_date
     , salary
     , salary * 12 as 연봉   -- as(alias)는 별칭
FROM employees;

-- 검색 조건 WHERE, OR, AND
SELECT emp_name
     , hire_date
     , salary
FROM employees
WHERE department_id = 90
AND salary >= 20000;

-- 정렬 조건 ORDER BY
SELECT emp_name
     , hire_date
     , salary
FROM employees
WHERE department_id = 50
ORDER BY emp_name desc;    -- desc 내림차순 / asc 오름차순 (디폴트 - 사용하지 않았을경우 기본값)
--ORDER BY 1 desc -- emp_name을 사용한것과 동일
--ORDER BY salary desc, emp_name;
--ORDER BY 3 desc, 1 -- 바로 위의 결과와 동일

SELECT *
FROM TB_INFO
--WHERE NM = '김지훈';
ORDER BY NM;

-- INSERT
-- 1. 전체
CREATE TABLE ex3_1 (
    col1 varchar2(10)
    ,col2 number
    ,col3 date
);
INSERT INTO ex3_1 VALUES ('abc', 10, sysdate);
INSERT INTO ex3_1 VALUES ('abc', '100', sysdate);   -- 기본적으로 number타입은 문자형식의 숫자도 받아준다.
INSERT INTO ex3_1 VALUES ('abc', '10d0', sysdate);  -- 오류

-- 2. 특정컬럼에만 입력할때는 컬럼명 작성 필수
INSERT INTO ex3_1 (col3) VALUES (sysdate);

-- 3. 조회결과를 삽입
CREATE TABLE ex3_2 (
    info_no number
    ,nm varchar2(20)
);
INSERT INTO ex3_2
SELECT info_no
       ,nm
FROM TB_INFO;
SELECT *
FROM ex3_2;

-- UPDATE 수정문
UPDATE tb_info
SET hobby = '요리'
    ,pc_no = 'SSSAM'
WHERE nm = '이앞길';

commit; -- 물리적으로 반영시키는 명령어.r
SELECT *
FROM tb_info;