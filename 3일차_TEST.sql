-- 문제
/*
  다음과 같은 구조의 테이블을 생성해 보자.
- 테이블 :  ORDERS
- 컬럼  :   ORDER_ID    NUMBER(12,0)
           ORDER_DATE   DATE
           ORDER_MODE  VARCHAR2(8 BYTE)
           CUSTOMER_ID NUMBER(6,0)
           ORDER_STATUS NUMBER(2,0)
           ORDER_TOTAL NUMBER(8,2)
           SALES_REP_ID NUMBER(6,0)
           PROMOTION_ID NUMBER(6,0)
- 제약사항 : 기본키는 ORDER_ID  
            ORDER_MODE에는 'direct', 'online'만 입력가능
            ORDER_TOTAL의 디폴트 값은 0
*/

CREATE TABLE ORDERS (
    ORDER_ID NUMBER(12, 0) Primary key
    ,ORDER_DATE   DATE
    ,ORDER_MODE  VARCHAR2(8 BYTE) check (ORDER_MODE in ('direct', 'online'))
    ,CUSTOMER_ID NUMBER(6,0)
    ,ORDER_STATUS NUMBER(2,0)
    ,ORDER_TOTAL NUMBER(8,2) default 0
    ,SALES_REP_ID NUMBER(6,0)
    ,PROMOTION_ID NUMBER(6,0)
);

SELECT *
FROM ORDERS;
