create table customer (
code number ,
amt number,
duedate date);

INSERT INTO customer values (253, 987, '21-DEC-18');
INSERT INTO customer values (101, 100, '21-JAN-19');
INSERT INTO customer values (102, 200, '21-JAN-19');
INSERT INTO customer values (101, 200, '21-DEC-18');

INSERT INTO customer values (102, 300, '20-DEC-18');

INSERT INTO customer values (103, 400, '21-OCT-18');
INSERT INTO customer values (103, 300, '18-OCT-18');
INSERT INTO customer values (101, 399, '18-NOV-18');
INSERT INTO customer values (104, 300, '28-JAN-19');

INSERT INTO customer values (105, 900, '23-DEC-18');
INSERT INTO customer values (105, 300, '18-NOV-18');
INSERT INTO customer values (109, 900, '29-JAN-19');
INSERT INTO customer values (203, 890, '20-OCT-18');

INSERT INTO customer values (290, 345, '18-DEC-18');

SELECT * FROM customer;

SELECT * FROM (SELECT
    Code,
    (CASE WHEN date_diffence BETWEEN 0 AND 30 THEN amt ELSE NULL END) AS "0-30 days",
    (CASE WHEN date_difference BETWEEN 30 AND 60 THEN amt ELSE NULL END) AS "30-60 days",
    (CASE WHEN date_difference BETWEEN 60 AND 90 THEN amt ELSE NULL END) AS "60-90 Days",
    (CASE WHEN date_difference BETWEEN 90 AND 120 THEN amt ELSE NULL END) AS "90-120 Days",
    (CASE WHEN date_difference > 120 THEN amt ELSE 0 END) AS "> 120 Days"
FROM (SELECT CODE, AMT, DUEDATE, ABS((SELECT MIN(duedate) FROM customer) - duedate) as DATE_DIFFERENCE FROM CUSTOMER))
ORDER BY CODE;




