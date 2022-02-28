-- 표현식 CASE문
SELECT employee_id
     , salary
     , CASE WHEN salary > 15000 THEN 'A등급'
            WHEN salary > 5000 AND salary <=15000 THEN 'B등급'
            WHEN salary <= 5000 THEN 'C등급'
        ELSE '나머지'
        END as salary_grade -- as는 테이블의 이름을 설정해서 안으로 데이터를 넣어준다.
FROM employees;

-- 문자 연산자 ||
-- 문자와 데이터를 붙여주는 역할 ( 많이 쓰임 )
SELECT employee_id
     , emp_name
     , '사번:' || employee_id || ' 이름:' || emp_name as doc
FROM employees;

-- 수식 연산자
SELECT emp_name
     , salary      as 월급
     , round(salary / 30,2) as 일당
     , salary * 12 as 연봉
FROM employees;

-- 논리 연산자
SELECT * FROM employees WHERE salary > 15000;  -- 초과
SELECT * FROM employees WHERE salary < 3000;   -- 미만
SELECT * FROM employees WHERE salary >= 15000; -- 이상
SELECT * FROM employees WHERE salary <= 3000;  -- 이하
SELECT * FROM employees WHERE department_id != 50; -- 아닌(not)
SELECT * FROM employees WHERE department_id <> 50; -- 아닌
SELECT * FROM employees WHERE department_id ^= 50; -- 아닌

--NULL (null 여부는 연산자를 사용하면 비교하지 못함)
SELECT *
FROM departments
WHERE parent_id is not null; -- null이 아닌 (null 검색시엔 is 사용)

-- ROWNUM : 의사컬럼_테이블에는 없지만 있는것 처럼 사용
-- 페이징 처리시 많이 사용
-- BETWEEN a AND b : a ~ b 사이 값인 로우 검색
SELECT *
FROM (
        SELECT rownum as rnum
             , emp_name
             , employee_id
        FROM employees
      )
WHERE rnum BETWEEN 1 AND 10;

SELECT rownum as rnum
     , emp_name
     , employee_id
FROM employees
ORDER BY emp_name desc;

-- IN 조건식
SELECT employee_id
     , salary
FROM employees
--WHERE salary IN (2000, 3000, 4000);  -- OR과 같음
WHERE salary NOT IN (2000, 3000, 4000);  -- OR과 같음

-- LIKE 조건식 **
SELECT emp_name
FROM employees
--WHERE emp_name LIKE 'A%';
--WHERE emp_name LIKE '%n';
WHERE emp_name LIKE '%Smith%';

CREATE TABLE ex4_1 (
    names varchar2(30)
);
INSERT INTO ex4_1 VALUES ('홍길');
INSERT INTO ex4_1 VALUES ('홍길동');
INSERT INTO ex4_1 VALUES ('홍길용');
INSERT INTO ex4_1 VALUES ('홍길용동');
SELECT * FROM ex4_1
WHERE names LIKE '_길_'; -- 길이까지 맞출때에는 언더바('_') 사용

-- 함수 : 오라클에서 함수는 무조건 리턴값이 1개 있어야함.
-- 문자 함수 : INITCAP, LOWER, UPPER
SELECT emp_name
     , INITCAP(emp_name) -- 앞글자, 대문자
     , INITCAP('lee ap')
     , LOWER(emp_name)   -- 소문자
     , UPPER(emp_name)   -- 대문자
FROM employees;

SELECT *
FROM employees
WHERE lower(emp_name) LIKE '%'||lower('david')||'%'
OR lower(emp_name) LIKE '%'||lower('KinG')||'%';

-- SUBSTR(char, pos, len) 문자열
-- 자를 문자열인 char의 pos번째부터 len길이 만큼 자른뒤 반환
-- pos값으로 0이 오면 디폴트 값인 1 즉, 첫번재 문자를 의미함
-- 음수가 오면 char 문자열 맨 끝에서 시작한 상대적 위치를 의미
-- len 값이 생략되면 pos 번째 부터 나머지 모든 문자 반환.
SELECT SUBSTR('ABCD EFG',1,4)
     , SUBSTR('ABCD EFG',-4,3)
     , SUBSTR('ABCD EFG',-4,1)
     , SUBSTR('ABCD EFG',5)
FROM DUAL; -- dual은 임의 테이블 (테스트용)

-- INSTR 문자열 인덱스값 반환
SELECT INSTR('ABC AB ABD AB','AB') as instr1
     , INSTR('ABC AB ABD AB','AB', 1, 2) as instr2
     , INSTR('ABC AB ABD AB','AB', 1, 3) as instr3
     , INSTR('ABC AB ABD AB','AB', 1, 4) as instr4
     , INSTR('ABC AB ABD AB','AB', 1, 5) as instr5
           -- 대상 문자열, 찾는 문자열, 시작위치, n번째
FROM dual;
-- REPLACE 치환
SELECT REPLACE ('나는 너를 모르는데 너는 나를 알겠는가?','나','너')
FROM dual;

-- 유저 생성 study/study
    create user study identified by study;
-- 권한 부여 resource, connect
    grant connect, resource to study;
