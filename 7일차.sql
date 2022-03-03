CREATE TABLE 강의내역 (
     강의내역번호 NUMBER(3)
    ,교수번호 NUMBER(3)
    ,과목번호 NUMBER(3)
    ,강의실 VARCHAR2(10)
    ,교시  NUMBER(3)
    ,수강인원 NUMBER(5)
    ,년월 date
);

CREATE TABLE 과목 (
     과목번호 NUMBER(3)
    ,과목이름 VARCHAR2(50)
    ,학점 NUMBER(3)
);

CREATE TABLE 교수 (
     교수번호 NUMBER(3)
    ,교수이름 VARCHAR2(20)
    ,전공 VARCHAR2(50)
    ,학위 VARCHAR2(50)
    ,주소 VARCHAR2(100)
);

CREATE TABLE 수강내역 (
    수강내역번호 NUMBER(3)
    ,학번 NUMBER(10) 
    ,과목번호 NUMBER(3)
    ,강의실 VARCHAR2(10)
    ,교시 NUMBER(3)
    ,취득학점 VARCHAR(10)
    ,년월 DATE 
);

CREATE TABLE 학생 (
     학번 NUMBER(10)
    ,이름 VARCHAR2(50)
    ,주소 VARCHAR2(100)
    ,전공 VARCHAR2(50)
    ,부전공 VARCHAR2(500)
    ,생년월일 DATE
    ,학기 NUMBER(3)
    ,평점 NUMBER
);


COMMIT;

ALTER TABLE 학생 ADD CONSTRAINT PK_학생_학번 PRIMARY KEY (학번);
ALTER TABLE 수강내역 ADD CONSTRAINT PK_수내_수내번 PRIMARY KEY (수강내역번호);
ALTER TABLE 과목 ADD CONSTRAINT PK_과목_과목번호 PRIMARY KEY (과목번호);
ALTER TABLE 교수 ADD CONSTRAINT PK_교수_교수번호 PRIMARY KEY (교수번호);
Alter table 강의내역 add constraint PK_강내번 primary key (강의내역번호);

ALTER TABLE 수강내역 
        ADD CONSTRAINT FK_학생_학번 FOREIGN KEY(학번)
        REFERENCES 학생(학번);
ALTER TABLE 수강내역 
        ADD CONSTRAINT FK_과목_과목번호 FOREIGN KEY(과목번호)
        REFERENCES 과목(과목번호);
ALTER TABLE 강의내역 
        ADD CONSTRAINT FK_교수_교수번호 FOREIGN KEY(교수번호)
        REFERENCES 교수(교수번호);
ALTER TABLE 강의내역 
        ADD CONSTRAINT FK_강과번_과목번호 FOREIGN KEY(과목번호)
        REFERENCES 과목(과목번호);
/*       강의내역, 과목, 교수, 수강내역, 학생 테이블을 만드시고 아래와 같은 제약 조건을 준 뒤 
        (1)'학생' 테이블의 PK 키를  '학번'으로 잡아준다 
        (2)'수강내역' 테이블의 PK 키를 '수강내역번호'로 잡아준다 
        (3)'과목' 테이블의 PK 키를 '과목번호'로 잡아준다 
        (4)'교수' 테이블의 PK 키를 '교수번호'로 잡아준다
        (5)'강의내역'의 PK를 '강의내역번호'로 잡아준다. 
        (6)'학생' 테이블의 PK를 '수강내역' 테이블의 '학번' 컬럼이 참조한다 FK 키 설정
        (7)'과목' 테이블의 PK를 '수강내역' 테이블의 '과목번호' 컬럼이 참조한다 FK 키 설정 
        (8)'교수' 테이블의 PK를 '강의내역' 테이블의 '교수번호' 컬럼이 참조한다 FK 키 설정
        (9)'과목' 테이블의 PK를 '강의내역' 테이블의 '과목번호' 컬럼이 참조한다 FK 키 설정
            각 테이블에 엑셀 데이터를 임포트 

    ex) ALTER TABLE 학생 ADD CONSTRAINT PK_학생_학번 PRIMARY KEY (학번);
        
        ALTER TABLE 수강내역 
        ADD CONSTRAINT FK_학생_학번 FOREIGN KEY(학번)
        REFERENCES 학생(학번); -- 참조하고있는 테이블의 컬럼
        
    1. 테이블 생성
    2. 제약조건 추가
       - 객체 이름은 최대 30byte
       - 객체 이름은 중복될 수 없음
       - 참조하고 있는 컬럼은 pk 제약 조건이 있어야함.
    
    3. 데이터 임포트
       - 참조하고 있는 데이터는 선행적으로 데이터가 삽입되어 있어야함.
*/

-- 동등 조인 = <= 등호를 사용하여 연결
-- 한쪽의 값이 null인 경우엔 join이 되지 않는다.
select a.학번 -- 양쪽에 있는 동일한 하나의 컬럼은 a나 b로 지정해줘야한다.
     , a.이름
     , a.전공
     , a.평점
     , count(b.수강내역번호) 수강건수
from 학생 a
   , 수강내역 b
where a. 학번 = b. 학번 (+) -- (+)는 기호가 있는 테이블에 null값이 있어도 포함을 시키겠다는 뜻. [외부조인]
--and a.이름 = '최숙경'
group by a.학번, a.이름, a.전공, a.평점;

select a.학번 
     , a.이름
     , a.전공
     , a.평점
     , b.수강내역번호
     , c.과목이름
from 학생 a
   , 수강내역 b
   , 과목 c
where a. 학번 = b. 학번
and   b. 과목번호 = c.과목번호
and   a.이름 = '최숙경';

-- '모든 학생'의 수강 학점을 출력하시오.
select a.학번
     , a.이름
     , nvl(sum(c.학점),0) as 학점합계
from 학생 a, 수강내역 b, 과목 c
where a.학번 = b.학번 (+) -- 외부(outer)조인을 했을경우 방향성을 맞춰주어야 한다.
and   b.과목번호 = c.과목번호 (+)
group by a.학번, a.이름
order by 1;