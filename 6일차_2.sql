
 
-- 집합 연산자 UNION ------------------------------------------------------------------------

CREATE TABLE exp_goods_asia (
       country VARCHAR2(10),
       seq     NUMBER,
       goods   VARCHAR2(80));

INSERT INTO exp_goods_asia VALUES ('한국', 1, '원유제외 석유류');
INSERT INTO exp_goods_asia VALUES ('한국', 2, '자동차');
INSERT INTO exp_goods_asia VALUES ('한국', 3, '전자집적회로');
INSERT INTO exp_goods_asia VALUES ('한국', 4, '선박');
INSERT INTO exp_goods_asia VALUES ('한국', 5,  'LCD');
INSERT INTO exp_goods_asia VALUES ('한국', 6,  '자동차부품');
INSERT INTO exp_goods_asia VALUES ('한국', 7,  '휴대전화');
INSERT INTO exp_goods_asia VALUES ('한국', 8,  '환식탄화수소');
INSERT INTO exp_goods_asia VALUES ('한국', 9,  '무선송신기 디스플레이 부속품');
INSERT INTO exp_goods_asia VALUES ('한국', 10,  '철 또는 비합금강');

INSERT INTO exp_goods_asia VALUES ('일본', 1, '자동차');
INSERT INTO exp_goods_asia VALUES ('일본', 2, '자동차부품');
INSERT INTO exp_goods_asia VALUES ('일본', 3, '전자집적회로');
INSERT INTO exp_goods_asia VALUES ('일본', 4, '선박');
INSERT INTO exp_goods_asia VALUES ('일본', 5, '반도체웨이퍼');
INSERT INTO exp_goods_asia VALUES ('일본', 6, '화물차');
INSERT INTO exp_goods_asia VALUES ('일본', 7, '원유제외 석유류');
INSERT INTO exp_goods_asia VALUES ('일본', 8, '건설기계');
INSERT INTO exp_goods_asia VALUES ('일본', 9, '다이오드, 트랜지스터');
INSERT INTO exp_goods_asia VALUES ('일본', 10, '기계류');

COMMIT;

SELECT goods
  FROM exp_goods_asia
 WHERE country = '한국'
 ORDER BY seq;

SELECT goods
  FROM exp_goods_asia
 WHERE country = '일본'
 ORDER BY seq;
 
-- 로우(행)의 중복제거 집합 (union) 
SELECT goods
  FROM exp_goods_asia
 WHERE country = '한국'
UNION 
SELECT goods
  FROM exp_goods_asia
 WHERE country = '일본';

-- 로우(행)의 중복 상관없이 데이터 합치기 (union all)
SELECT goods
  FROM exp_goods_asia
 WHERE country = '한국'
UNION ALL 
SELECT goods
  FROM exp_goods_asia
 WHERE country = '일본';
 
-- 로우(행)의 중복 데이터 출력 (교집합, intersect)
SELECT goods
  FROM exp_goods_asia
 WHERE country = '한국'
INTERSECT
SELECT goods
  FROM exp_goods_asia
 WHERE country = '일본'; 
 
-- 로우(행)의 차집합 
SELECT goods
  FROM exp_goods_asia
 WHERE country = '한국'
MINUS
SELECT goods
  FROM exp_goods_asia
 WHERE country = '일본';  
 
SELECT goods
  FROM exp_goods_asia
 WHERE country = '일본'
MINUS
SELECT goods
  FROM exp_goods_asia
 WHERE country = '한국';   
 
-- union은 컬럼의 개수와 타입이 일치하여야한다.
SELECT goods
  FROM exp_goods_asia
 WHERE country = '한국'
UNION 
SELECT seq, goods
  FROM exp_goods_asia
 WHERE country = '일본'; 
 
 
SELECT seq, goods
  FROM exp_goods_asia
 WHERE country = '한국'
INTERSECT
SELECT seq, goods
  FROM exp_goods_asia
 WHERE country = '일본';  
 
SELECT seq
  FROM exp_goods_asia
 WHERE country = '한국'
UNION
SELECT goods
  FROM exp_goods_asia
 WHERE country = '일본';   
 
 
 SELECT goods
  FROM exp_goods_asia
 WHERE country = '한국'
 ORDER BY goods
UNION
SELECT goods
  FROM exp_goods_asia
 WHERE country = '일본'; 
 
 
 SELECT goods
  FROM exp_goods_asia
 WHERE country = '한국'
UNION
SELECT goods
  FROM exp_goods_asia
 WHERE country = '일본'
  ORDER BY goods; 
  
-- ROLLUP 함수 대신 UNION 사용
SELECT period
     , sum(loan_jan_amt) as 합계
FROM kor_loan_status
where period like '2013%'
group by period
UNION
SELECT '전체'
      , sum(loan_jan_amt) as 합계
FROM kor_loan_status;
