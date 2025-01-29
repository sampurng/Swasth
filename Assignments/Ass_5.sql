CREATE TABLE AUTHORS (
AUTHORID NUMBER, 
AUTHORNAME VARCHAR(50), 
NATIONALITY VARCHAR(50)
);

ALTER TABLE AUTHORS
ADD CONSTRAINT AUTHOUR_PK PRIMARY KEY (AUTHORID);

DROP TABLE BOOKS;

CREATE TABLE BOOKS (
BOOKID NUMBER, 
TITLE VARCHAR(100), 
ISBN VARCHAR(20),
PUBLICATIONYEAR NUMBER, 
AUTHORID NUMBER,
FOREIGN KEY (AUTHORID) REFERENCES AUTHORS(AUTHORID)
);

ALTER TABLE BOOKS
ADD CONSTRAINT BOOK_PK PRIMARY KEY (BOOKID);

INSERT INTO AUTHORS VALUES (1, 'J.K. Rowling', 'British');
INSERT INTO AUTHORS VALUES (2, 'George Orwell', 'British');
INSERT INTO AUTHORS VALUES (3, 'Agatha Christie', 'British');
INSERT INTO AUTHORS VALUES (4, 'J.R.R. Tolkien', 'British');
INSERT INTO AUTHORS VALUES (5, 'Harper Lee', 'American');
INSERT INTO AUTHORS VALUES (6, 'F. Scott Fitzgerald', 'American');



INSERT INTO BOOKS VALUES (1, 'HP : Socerers Stone', '978-0439554930', '1997', 1);
INSERT INTO BOOKS VALUES (2, '1984', '978-0451524935', '1949', 2);
INSERT INTO BOOKS VALUES (3, 'Murder ont he Orient Express', '978-0062073495', '1934', 3);
INSERT INTO BOOKS VALUES (4, 'Hobbit', '978-0345334835', '1937', 4);
INSERT INTO BOOKS VALUES (5, 'Mocking Bird', '978-0061120084', '1960', 5);
INSERT INTO BOOKS VALUES (6, 'Great Gatsby', '978-0743273565', '1925', 6);
INSERT INTO BOOKS VALUES (7, 'HP: Chanber of Secrets', '978-0439554930', '1998', 1);
INSERT INTO BOOKS VALUES (9, 'Death on the Nile', '978-DON', '1937', 3);
INSERT INTO BOOKS VALUES (8, 'Animal fARM', '978-ABCasd', '1945', 2);
INSERT INTO BOOKS VALUES (10, 'Great Gatsby', '978-GB', '1954', 4);


--C 

SELECT 
    A.AUTHORNAME, 
    B.TITLE, 
    B.ISBN,
    B.PUBLICATIONYEAR
FROM 
    AUTHORS A
JOIN 
    BOOKS B ON A.AUTHORID = B.AUTHORID
WHERE 
    B.PUBLICATIONYEAR <= 1960
ORDER BY 
    A.AUTHORNAME;
    
    
select * from all_constraints WHERE OWNER = 'ASSIGNMENT_FIVE_IND';
    
-- 2


CREATE TABLE CUSTOMERS (
CUSTOEMR_ID NUMBER PRIMARY KEY, 
F_NAME VARCHAR(50) NOT NULL, 
L_NAME VARCHAR(50) NOT NULL, 
EMAIL VARCHAR(100) NOT NULL, 
PH_NO VARCHAR(20) NOT NULL
);

CREATE TABLE ORDERS (
    ORDER_ID NUMBER PRIMARY KEY, 
    CUSTOMER_ID NUMBER,
    ORDER_DATE DATE NOT NULL, 
    AMOUNT NUMBER(10, 2) NOT NULL,
    FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMERS(CUSTOEMR_ID) 
);


INSERT INTO CUSTOMERS VALUES (1, 'John', 'Doe' , 'jd@em.com' , '111-111-1111');

INSERT INTO CUSTOMERS VALUES (2, 'Jane', 'Smith' , 'js@em.com' , '111-222-1111');
INSERT INTO CUSTOMERS VALUES (3, 'Peter', 'Jones' , 'pj@em.com' , '333-111-1111');
INSERT INTO CUSTOMERS VALUES (4, 'Mary', 'Brown' , 'MB@em.com' , '444-111-4444');
INSERT INTO CUSTOMERS VALUES (5, 'David', 'Williams' , 'dw@em.com' , '111-555-5555');
INSERT INTO CUSTOMERS VALUES (6, 'Susan', 'Miller' , 'SMasd@em.com' , '666-666-1111');


INSERT INTO CUSTOMERS VALUES (7, 'Micheal', 'TEller' , 'MT@em.com' , '777-777-7777');
INSERT INTO CUSTOMERS VALUES (8, 'karen', 'Anderson' , 'KASASD@em.com' , '888-888-1111');
INSERT INTO CUSTOMERS VALUES (9, 'Mark', 'Thomas' , 'MTasdasdawqe@em.com' , '999-111-9999');
INSERT INTO CUSTOMERS VALUES (10, 'Elizabeth', 'Wilson' , 'EWWWWWW@em.com' , '101-101-1010');


SELECT * FROM CUSTOMERS;


INSERT INTO ORDERS VALUES (1, 1, TO_DATE('2023-10-04', 'YYYY-MM-DD'), 100);
INSERT INTO ORDERS VALUES (2, 2, TO_DATE('2023-10-05', 'YYYY-MM-DD'), 50);
INSERT INTO ORDERS VALUES (3, 3, TO_DATE('2023-10-06', 'YYYY-MM-DD'), 120);
INSERT INTO ORDERS VALUES (4, 4, TO_DATE('2023-10-07', 'YYYY-MM-DD'), 75);
INSERT INTO ORDERS VALUES (5, 5, TO_DATE('2023-10-08', 'YYYY-MM-DD'), 80);
INSERT INTO ORDERS VALUES (6, 6, TO_DATE('2023-10-08', 'YYYY-MM-DD'), 150);
INSERT INTO ORDERS VALUES (7, 7, TO_DATE('2023-10-10', 'YYYY-MM-DD'), 200);
INSERT INTO ORDERS VALUES (8, 8, TO_DATE('2023-10-11', 'YYYY-MM-DD'), 110);
INSERT INTO ORDERS VALUES (9, 9, TO_DATE('2023-10-12', 'YYYY-MM-DD'), 60);
INSERT INTO ORDERS VALUES (10, 10, TO_DATE('2023-10-13', 'YYYY-MM-DD'), 90);


SELECt * FROM ORDERS;


SELECT * FROM (SELECT 
    C.F_NAME, 
    C.L_NAME, 
    C.CUSTOEMR_ID, 
    SUM(O.AMOUNT)
FROM CUSTOMERS C LEFT JOIN ORDERS O 
ON O.CUSTOMER_ID = C.CUSTOEMR_ID 
GROUP BY C.CUSTOEMR_ID
HAVING O.ORDER_DATE > SYSDATE - 30) A;

SELECT
    C.CUSTOEMR_ID,
    C.F_NAME || ' ' || C.L_NAME AS CUSTOMER_NAME,
    O.ORDER_ID AS LAST__ORDER__DID,
    O.ORDER_DATE AS LAST_ORDER_DATE,
    AVG(A.AMOUNT) AS AVG_AMOUNT
FROM
    CUSTOMERS C
JOIN
    ORDERS O ON C.CUSTOEMR_ID = O.CUSTOMER_ID
JOIN
    (SELECT
        CUSTOMER_ID,
        MAX(ORDER_DATE) AS MAX_ORDER_DATE
     FROM
        ORDERS
     WHERE
        ORDER_DATE > SYSDATE - 30
     GROUP BY
        CUSTOMER_ID
    ) R ON O.CUSTOMER_ID = R.CUSTOMER_ID AND O.ORDER_DATE = R.MAX_ORDER_DATE
JOIN
    (SELECT
        CUSTOMER_ID,
        ORDER_DATE,
        AMOUNT
     FROM
        ORDERS
     WHERE
        ORDER_DATE > SYSDATE - 30
    ) A ON O.CUSTOMER_ID = A.CUSTOMER_ID AND A.ORDER_DATE > SYSDATE - 30
GROUP BY
    C.CUSTOEMR_ID, C.F_NAME, C.L_NAME, O.ORDER_ID, O.ORDER_DATE
ORDER BY
    C.CUSTOEMR_ID;






