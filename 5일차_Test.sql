/*
    2022.02.18 문제
    고객의 출생년도를 활용하여 (customers)테이블
    30대, 40대, 50대를 구분하여 출력하시오 (나머지는 기타)
    ex) trunc, decode, to char 사용

*/

select cust_name
     , cust_year_of_birth
     , to_char(sysdate, 'YYYY') - (cust_year_of_birth) as 나이
     , decode(to_char(sysdate, 'YYYY') - (cust_year_of_birth) 
        - (mod(to_char(sysdate, 'YYYY') 
        - (cust_year_of_birth),10)), '30', '30대', '40', '40대', '50', '50대', '기타') as GENERATION
from customers;
