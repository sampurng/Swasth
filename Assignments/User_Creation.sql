CREATE USER assignmentFour IDENTIFIED BY Assignment1four;

GRANT CONNECT to assignmentFour;

GRANT CREATE TABLE TO assignmentFour;

GRANT DELETE TABLE To assignmentFour;

GRANT UNLIMITED TABLESPACE TO assignmentFour;

GRANT CONNECT, RESOURCE TO assignmentFour;

SELECT * FROM user_tables;

