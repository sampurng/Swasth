CREATE TABLE bricks (
  brick_id INTEGER,
  color VARCHAR2(40),
  shape VARCHAR2(40),
  weight INTEGER
);

-- ALTER TABLE BRICKS DROP CONSTRAINT MAKE_BRICK_ID_PK;

ALTER TABLE BRICKS ADD CONSTRAINT MAKE_BRICK_ID_PK PRIMARY KEY (brick_id);

CREATE SEQUENCE brick_PK START WITH 1;

INSERT INTO BRICKS VALUES (brick_PK.NEXTVAL, 'blue', 'cube', 1);
INSERT INTO BRICKS VALUES (brick_PK.NEXTVAL, 'blue', 'pyramid', 2);
INSERT INTO BRICKS VALUES (brick_PK.NEXTVAL, 'red', 'cube', 1);
INSERT INTO BRICKS VALUES (brick_PK.NEXTVAL, 'red', 'cube', 2);

INSERT INTO BRICKS VALUES (brick_PK.NEXTVAL, 'red', 'pyramid', 3);
INSERT INTO BRICKS VALUES (brick_PK.NEXTVAL, 'green', 'pyramid', 1);


SELECT * FROM BRICKS;

WITH bdd AS (
  SELECT brick_id, color, shape, weight, ROW_NUMBER() OVER (ORDER BY brick_id) AS ROW_NUM, SUM(weight) OVER (ORDER BY brick_id) AS RUNNING_WEIGHT FROM bricks
)
SELECT
  bd.brick_id,
  bd.color,
  bd.shape,
  bd.weight,
  bd.ROW_NUM AS RUNNING_TOTAL,
  bd.RUNNING_WEIGHT,
  ROUND(bd.RUNNING_WEIGHT / bd.ROW_NUM, 2) AS RUNNING_AVERAGE_WEIGHT
FROM bdd bd;


SELECT 
    BRICK_ID, 
    COLOR, 
    SHAPE, 
    WEIGHT, 
    LAG(SHAPE, 1, NULL) over (ORDER BY BRICK_ID) as PREV_SHAPE, 
    LEAD(SHAPE, 1, NULL) OVER (ORDER BY BRICK_ID) as NEXT_SHAPE  
FROM BRICKS; 


Commit;


--- Q3 from here


-- 3A
drop table bricks;
drop table colors;

create table bricks (
  brick_id integer,
  color   varchar2(10)
);

create table colors (
  color_name           varchar2(10),
  minimum_bricks_needed integer
);

insert into colors values ( 'blue', 2 );
insert into colors values ( 'green', 3 );
insert into colors values ( 'red', 2 );
insert into colors values ( 'orange', 1);
insert into colors values ( 'yellow', 1 );
insert into colors values ( 'purple', 1 );

insert into bricks values ( 1, 'blue' );
insert into bricks values ( 2, 'blue' );
insert into bricks values ( 3, 'blue' );
insert into bricks values ( 4, 'green' );
insert into bricks values ( 5, 'green' );
insert into bricks values ( 6, 'red' );
insert into bricks values ( 7, 'red' );
insert into bricks values ( 8, 'red' );
insert into bricks values ( 9, null );

SELECT * FRoM BRICKS;
SELECT * FROM colors;

commit;


-- 3B
SELECT c.COLOR_NAME, MIN(b.BRICK_ID) AS MIN_BRICK_ID
FROM COLORS c
LEFT JOIN BRICKS b
ON c.COLOR_NAME = b.COLOR
GROUP BY c.COLOR_NAME
ORDER By MIN_BRICK_ID;

--3C
SELECT COLOR, COUNT(BRICK_ID) FROM BRICKS GROUP By COLOR HAVING COUNT(BRICK_ID) > ( 
    SELECT 
        SUM(NUMBEr_OF_BRICKS) / COUNT(NUMBEr_OF_BRICKS) as Average 
        FROM 
        ( 
            SELECT 
                COLOR, 
                COUNT(BRICK_ID) as number_of_bricks 
                FROM BRICKS 
                GROUP BY COLOR
        )
    ); 



