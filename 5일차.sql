SELECT CASE WHEN cust_gender = 'M' THEN '남자'
            WHEN cust_gender = 'F' THEN '여자'
        END as gender
        ,   DECODE(cust_gender, 'M','남자','F','여자') as 성별
                            -- 조건, 결과1, 조건2, 결과2 ... (간단하게 값을 바꿀경우 사용)
FROM customers;
