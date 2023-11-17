-- CREATE TABLE NEwTab(ID NUMBER PRIMARY KEY, NAME VARCHAR(20));
-- CREATE SEQUENCE MY_SEQ START WITH 1111 increment by 10; 

-- CREATE TABLE CIasda(ID_a NUMBER PRIMARY KEY, CONSTRAINT ABC FOREIGN KEY (ID_a) REFERENCES NEwTab(ID), NAME VARCHAR(20));


 -- SELECT * FROM USER_CONSTRAINTS;
-- SELECT * FROM USEr_TABLES;
-- SELECT * FRoM USER_SEQUENCES;
 
-- DROP TABLE NEwTab;

SET SERVEROUTPUT ON
/
DECLARE
    CURSOR CUR_CONSTRAINTS IS SELECT TABLE_NAME, CONSTRAINT_NAME FROM USER_CONSTRAINTS;
    CURSOR CUR_SEQ IS SELECT SEQUENCE_NAME FROM USER_SEQUENCES; 
    CURSOR CUR_TABLES IS SELECT TABLE_NAME FROM USER_TABLES;
    
    V_COUNT_SEQ NUMBER := 0;
    V_COUNT_CONSTRAINTS NUMBER := 0;
    V_COUNT_TABLES NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO V_COUNT_SEQ FROM USER_SEQUENCES; 
    SELECT COUNT(*) INTO V_COUNT_CONSTRAINTS FROM USER_CONSTRAINTS;
    SELECT COUNT(*) INTO V_COUNT_TABLES FROM USER_TABLES;
    
    DBMS_OUTPUT.PUT_LINE('Sequences Present : ' || V_COUNT_SEQ || chr(10) || 'Tables Present :  ' ||  V_COUNT_TABLES || chr(10) || 'Constraints Present : ' || V_COUNT_CONSTRAINTS);
    
    IF V_COUNT_SEQ > 0 THEN
        FOR SEQ IN CUR_SEQ LOOP
            EXECUTE IMMEDIATE ('DROP SEQUENCE ' || SEQ.SEQUENCE_NAME );
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('SEQUENCES DROPPED');
    END IF;
        
    IF V_COUNT_CONSTRAINTS > 0 THEN
        FOR CONS IN CUR_CONSTRAINTS LOOP
            EXECUTE IMMEDIATE('ALTER TABLE ' || CONS.TABLE_NAME || ' DROP CONSTRAINT ' || CONS.CONSTRAINT_NAME);
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('CONSTRATINTS DROPPED');
    END IF;
        
    IF V_COUNT_TABLES > 0 THEN
        FOR TABLESS IN CUR_TABLES LOOP
            EXECUTE IMMEDIATE('DROP TABLE ' || TABLESS.TABLE_NAME);
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('TABLES DROPPED');
    END IF;
END; 
/

-- CREATING FIRST TABLE AND SEQUENCE
CREATE SEQUENCE SEQ_USER_ID ----CODE IS 10------
START WITH 2023100001
INCREMENT BY 1
CACHE 10;

-- CREATING USER_DETAILS TABLE
CREATE TABLE user_details (
    user_id           NUMBER NOT NULL,
    first_name        VARCHAR2(200 CHAR) NOT NULL,
    last_name         VARCHAR2(200 CHAR),
    email             VARCHAR2(200 CHAR) NOT NULL,
    street_address    VARCHAR2(200 CHAR) NOT NULL,
    city              VARCHAR2(200 CHAR) NOT NULL,
    country           VARCHAR2(200 CHAR) NOT NULL,
    states            VARCHAR2(200 CHAR) NOT NULL,
    zipcode           NUMBER NOT NULL, 
    age               NUMBER NOT NULL
);

-- ADDING  CONSTRATINTS TO USER_DETAILS
ALTER TABLE user_details ADD CONSTRAINT user_details_pk PRIMARY KEY ( user_id );


-- CREATING Body Composition AND SEQUENCE
CREATE SEQUENCE SEQ_BODYCOMM_ID ---CODE IS 20-----
START WITH 2023200001
INCREMENT BY 1
CACHE 10;

-----CREATING BODY_COMPOSITION TABLE---------
CREATE TABLE body_composition (
    body_composition_id  NUMBER NOT NULL,
    height               NUMBER NOT NULL,
    weight               NUMBER NOT NULL,
    skeletal_muscle_mass NUMBER,
    fat_mass             NUMBER,
    body_fat             NUMBER,
    body_water           NUMBER,
    user_details_user_id NUMBER NOT NULL
);

-- ADDING  CONSTRATINTS TO BODY_COMPOSITION--------
ALTER TABLE body_composition ADD CONSTRAINT body_composition_pk PRIMARY KEY ( body_composition_id );

-------Foreign Key Constraint--------
ALTER TABLE body_composition
    ADD CONSTRAINT bodyComm_UD_fk FOREIGN KEY ( user_details_user_id )
        REFERENCES user_details ( user_id )
            ON DELETE CASCADE;


-- CREATING  EXERCISE_DEATILS AND SEQUENCE
CREATE SEQUENCE SEQ_EXERCISEDETAILS_ID ---CODE IS 30-----
START WITH 2023300001
INCREMENT BY 1
CACHE 10;

-----CREATING EXERCISE_DETAILS TABLE---------

CREATE TABLE exericse_details (
    exercise_id          NUMBER NOT NULL,
    type                 VARCHAR2(10 CHAR) NOT NULL,
    from_exercise_time   DATE NOT NULL,
    to_exercise_time     DATE NOT NULL,
    user_details_user_id NUMBER NOT NULL
);

------ ADDING  CONSTRATINTS TO EXERCISE_DETAILS --------
ALTER TABLE exericse_details ADD CONSTRAINT exericse_details_pk PRIMARY KEY ( exercise_id );

------Foreign Key Constraint--------
ALTER TABLE exericse_details
    ADD CONSTRAINT exericse_details_user_details_fk FOREIGN KEY ( user_details_user_id )
        REFERENCES user_details ( user_id )
            ON DELETE CASCADE;
            
            
-- CREATING  EXERCISE_METRICS AND SEQUENCE
CREATE SEQUENCE SEQ_EXERCISEMETRICS_ID ---CODE IS 35-----
START WITH 2023350001
INCREMENT BY 1
CACHE 10;

-----CREATING EXERCISE_METRICS TABLE---------

CREATE TABLE exercise_metrics (
    interval                     NUMBER NOT NULL,
    calories                     NUMBER NOT NULL,
    steps                        NUMBER,
    "Active Time"                NUMBER,
    exericse_details_exercise_id NUMBER NOT NULL
);

------ ADDING  CONSTRATINTS TO EXERCISE_METRICS --------

ALTER TABLE exercise_metrics ADD CONSTRAINT exercise_metrics_pk PRIMARY KEY ( exericse_details_exercise_id,interval );

------Foreign Key Constraint--------
ALTER TABLE exercise_metrics
    ADD CONSTRAINT exercise_metrics_exericse_details_fk FOREIGN KEY ( exericse_details_exercise_id )
        REFERENCES exericse_details ( exercise_id )
            ON DELETE CASCADE;
            
-- CREATING  SLEEP_DETAILS AND SEQUENCE   
CREATE SEQUENCE SEQ_SLEEPDETAILS_ID ---CODE IS 40-----
START WITH 2023400001
INCREMENT BY 1
CACHE 10;

-----CREATING SLEEP_DETAILS TABLE---------
CREATE TABLE sleep_details (
    sleep_id             NUMBER NOT NULL,
    from_sleep_time      DATE NOT NULL,
    to_sleep_time        DATE NOT NULL,
    user_details_user_id NUMBER NOT NULL
);

------ ADDING  CONSTRATINTS TO SLEEP_DETAILS --------
ALTER TABLE sleep_details ADD CONSTRAINT sleep_pk PRIMARY KEY ( sleep_id );

------Foreign Key Constraint--------
ALTER TABLE sleep_details
    ADD CONSTRAINT sleep_details_user_details_fk FOREIGN KEY ( user_details_user_id )
        REFERENCES user_details ( user_id )
            ON DELETE CASCADE;

-- CREATING  SLEEP_METRICS AND SEQUENCE   
CREATE SEQUENCE SEQ_SLEEPMETRICS_ID ---CODE IS 45-----
START WITH 2023450001
INCREMENT BY 1
CACHE 10;

-----CREATING SLEEP_METRICS TABLE---------
CREATE TABLE sleep_metrics (
    sleep_cycle            NUMBER NOT NULL,
    deep_sleep             NUMBER,
    awake                  NUMBER,
    rem                    NUMBER,
    light                  NUMBER,
    sleep_details_sleep_id NUMBER NOT NULL
);

------ ADDING  CONSTRATINTS TO SLEEP_METRICS --------
ALTER TABLE sleep_metrics ADD CONSTRAINT sleep_metrics_pk PRIMARY KEY ( sleep_details_sleep_id,
                                                                        sleep_cycle );
                                                                        
------Foreign Key Constraint--------
ALTER TABLE sleep_metrics
    ADD CONSTRAINT sleep_metrics_sleep_details_fk FOREIGN KEY ( sleep_details_sleep_id )
        REFERENCES sleep_details ( sleep_id )
            ON DELETE CASCADE;
            
-- CREATING  HEALTH_DETAILS AND SEQUENCE   
CREATE SEQUENCE SEQ_HEALTHDETAILS_ID ---CODE IS 50-----
START WITH 2023500001
INCREMENT BY 1
CACHE 10;

-----CREATING HEALTH_DETAILS TABLE---------
CREATE TABLE health_details (
    time_of_activity             DATE NOT NULL,
    blood_oxygen                 NUMBER,
    heart_rate                   NUMBER NOT NULL,
    ecg                          VARCHAR2(10 CHAR),
    bp_systolic                  NUMBER,
    bp_diastolic                 NUMBER,
    user_details_user_id         NUMBER NOT NULL,
    exericse_details_exercise_id NUMBER NOT NULL,
    sleep_details_sleep_id       NUMBER NOT NULL
);

------ ADDING  CONSTRATINTS TO HEALTH_DETAILS --------
ALTER TABLE health_details ADD CONSTRAINT health_details_pk PRIMARY KEY ( time_of_activity );

------Foreign Key Constraint--------
ALTER TABLE health_details
 ADD CONSTRAINT health_details_user_details_fk FOREIGN KEY ( user_details_user_id )
        REFERENCES user_details ( user_id )
            ON DELETE CASCADE;
            
--Adding Data to the tables
--USER_DETAILS

INSERT INTO user_details (user_id, first_name, last_name, email, street_address, city, country, states, zipcode, age)
VALUES (1, 'John', 'Doe', 'john.doe@example.com', '123 Main St', 'BOSTON', 'UNITED STATES', 'MASSECHUSETS', 12345, 30);
INSERT INTO user_details (user_id, first_name, last_name, email, street_address, city, country, states, zipcode, age)
VALUES(2, 'Alice', 'Smith', 'alice.smith@example.com', '456 Elm St', 'New York City', 'USA', 'New York', 23456, 25);
INSERT INTO user_details (user_id, first_name, last_name, email, street_address, city, country, states, zipcode, age)
VALUES(3, 'Michael', 'Johnson', 'michael.johnson@example.com', '789 Oak St', 'Toronto', 'Canada', 'Ontario', 34567, 35);
INSERT INTO user_details (user_id, first_name, last_name, email, street_address, city, country, states, zipcode, age)
VALUES(4, 'Emily', 'Brown', 'emily.brown@example.com', '101 Pine St', 'Sydney', 'Australia', 'New South Wales', 45678, 28);
INSERT INTO user_details (user_id, first_name, last_name, email, street_address, city, country, states, zipcode, age)
VALUES(5, 'Daniel', 'Williams', 'daniel.williams@example.com', '246 Maple St', 'Paris', 'France', 'Île-de-France', 56789, 32);
INSERT INTO user_details (user_id, first_name, last_name, email, street_address, city, country, states, zipcode, age)
VALUES(6, 'Olivia', 'Garcia', 'olivia.garcia@example.com', '369 Cedar St', 'Berlin', 'Germany', 'Berlin', 67890, 27);
INSERT INTO user_details (user_id, first_name, last_name, email, street_address, city, country, states, zipcode, age)
VALUES(7, 'William', 'Martinez', 'william.martinez@example.com', '505 Walnut St', 'Tokyo', 'Japan', 'Tokyo', 78901, 33);
INSERT INTO user_details (user_id, first_name, last_name, email, street_address, city, country, states, zipcode, age)
VALUES(8, 'Sophia', 'Robinson', 'sophia.robinson@example.com', '808 Birch St', 'Sao Paulo', 'Brazil', 'São Paulo', 89012, 29);
INSERT INTO user_details (user_id, first_name, last_name, email, street_address, city, country, states, zipcode, age)
VALUES(9, 'James', 'Lee', 'james.lee@example.com', '999 Oak St', 'Mumbai', 'India', 'Maharashtra', 90123, 31);
INSERT INTO user_details (user_id, first_name, last_name, email, street_address, city, country, states, zipcode, age)
VALUES(10, 'Emma', 'Lopez', 'emma.lopez@example.com', '777 Pine St', 'Cape Town', 'South Africa', 'Western Cape', 12345, 26);

--body composition table
INSERT INTO body_composition (body_composition_id, height, weight, skeletal_muscle_mass, fat_mass, body_fat, body_water, user_details_user_id)
VALUES (1, 170, 70, 60, 15, 20, 45, 1);
INSERT INTO body_composition (body_composition_id, height, weight, skeletal_muscle_mass, fat_mass, body_fat, body_water, user_details_user_id)
VALUES (2, 165, 65, 55, 18, 25, 42, 2);
INSERT INTO body_composition (body_composition_id, height, weight, skeletal_muscle_mass, fat_mass, body_fat, body_water, user_details_user_id)
VALUES (3, 180, 80, 65, 20, 22, 47, 3);
INSERT INTO body_composition (body_composition_id, height, weight, skeletal_muscle_mass, fat_mass, body_fat, body_water, user_details_user_id)
VALUES (4, 160, 55, 50, 12, 18, 50, 4);
INSERT INTO body_composition (body_composition_id, height, weight, skeletal_muscle_mass, fat_mass, body_fat, body_water, user_details_user_id)
VALUES (5, 175, 75, 62, 17, 23, 44, 5);
INSERT INTO body_composition (body_composition_id, height, weight, skeletal_muscle_mass, fat_mass, body_fat, body_water, user_details_user_id)
VALUES (6, 172, 68, 58, 16, 21, 46, 6);
INSERT INTO body_composition (body_composition_id, height, weight, skeletal_muscle_mass, fat_mass, body_fat, body_water, user_details_user_id)
VALUES (7, 168, 72, 63, 19, 24, 43, 7);
INSERT INTO body_composition (body_composition_id, height, weight, skeletal_muscle_mass, fat_mass, body_fat, body_water, user_details_user_id)
VALUES (8, 185, 85, 70, 22, 28, 48, 8);
INSERT INTO body_composition (body_composition_id, height, weight, skeletal_muscle_mass, fat_mass, body_fat, body_water, user_details_user_id)
VALUES (9, 155, 50, 48, 11, 15, 52, 9);
INSERT INTO body_composition (body_composition_id, height, weight, skeletal_muscle_mass, fat_mass, body_fat, body_water, user_details_user_id)
VALUES (10, 178, 77, 66, 18, 26, 41, 10);

--Excercise Details Table

INSERT INTO exericse_details (exercise_id, type, from_exercise_time, to_exercise_time, user_details_user_id)
VALUES (1, 'running', TO_DATE('2023-10-01 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-10-01 08:30:00', 'YYYY-MM-DD HH24:MI:SS'), 1);
INSERT INTO exericse_details (exercise_id, type, from_exercise_time, to_exercise_time, user_details_user_id)
VALUES(2, 'walking', TO_DATE('2023-10-01 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-10-01 09:30:00', 'YYYY-MM-DD HH24:MI:SS'), 2);
INSERT INTO exericse_details (exercise_id, type, from_exercise_time, to_exercise_time, user_details_user_id)
VALUES(3, 'cycling', TO_DATE('2023-10-01 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-10-01 10:30:00', 'YYYY-MM-DD HH24:MI:SS'), 3);
INSERT INTO exericse_details (exercise_id, type, from_exercise_time, to_exercise_time, user_details_user_id)
VALUES(4, 'swimming', TO_DATE('2023-10-01 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-10-01 11:30:00', 'YYYY-MM-DD HH24:MI:SS'), 4);
INSERT INTO exericse_details (exercise_id, type, from_exercise_time, to_exercise_time, user_details_user_id)
VALUES(5, 'running', TO_DATE('2023-10-01 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-10-01 12:30:00', 'YYYY-MM-DD HH24:MI:SS'), 5);
INSERT INTO exericse_details (exercise_id, type, from_exercise_time, to_exercise_time, user_details_user_id)
VALUES(6, 'walking', TO_DATE('2023-10-01 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-10-01 13:30:00', 'YYYY-MM-DD HH24:MI:SS'), 6);
INSERT INTO exericse_details (exercise_id, type, from_exercise_time, to_exercise_time, user_details_user_id)
VALUES(7, 'cycling', TO_DATE('2023-10-01 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-10-01 14:30:00', 'YYYY-MM-DD HH24:MI:SS'), 7);
INSERT INTO exericse_details (exercise_id, type, from_exercise_time, to_exercise_time, user_details_user_id)
VALUES(8, 'swimming', TO_DATE('2023-10-01 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-10-01 15:30:00', 'YYYY-MM-DD HH24:MI:SS'), 8);
INSERT INTO exericse_details (exercise_id, type, from_exercise_time, to_exercise_time, user_details_user_id)
VALUES(9, 'running', TO_DATE('2023-10-01 16:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-10-01 16:30:00', 'YYYY-MM-DD HH24:MI:SS'), 9);
INSERT INTO exericse_details (exercise_id, type, from_exercise_time, to_exercise_time, user_details_user_id)
VALUES(10, 'walking', TO_DATE('2023-10-01 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-10-01 17:30:00', 'YYYY-MM-DD HH24:MI:SS'), 10);
 
--Exercise Metrics Table
INSERT INTO exercise_metrics (interval, calories, steps, "Active Time", exericse_details_exercise_id)
VALUES (1, 100, 1000, 20, 1);
INSERT INTO exercise_metrics (interval, calories, steps, "Active Time", exericse_details_exercise_id)
VALUES (2, 80, 800, 15, 2);
INSERT INTO exercise_metrics (interval, calories, steps, "Active Time", exericse_details_exercise_id)
VALUES (3, 120, 1200, 25, 3);
INSERT INTO exercise_metrics (interval, calories, steps, "Active Time", exericse_details_exercise_id)
VALUES (4, 90, 900, 18, 4);
INSERT INTO exercise_metrics (interval, calories, steps, "Active Time", exericse_details_exercise_id)
VALUES (5, 110, 1100, 22, 5);
INSERT INTO exercise_metrics (interval, calories, steps, "Active Time", exericse_details_exercise_id)
VALUES (6, 85, 850, 16, 6);
INSERT INTO exercise_metrics (interval, calories, steps, "Active Time", exericse_details_exercise_id)
VALUES (7, 125, 1250, 26, 7);
INSERT INTO exercise_metrics (interval, calories, steps, "Active Time", exericse_details_exercise_id)
VALUES (8, 95, 950, 19, 8);
INSERT INTO exercise_metrics (interval, calories, steps, "Active Time", exericse_details_exercise_id)
VALUES (9, 115, 1150, 23, 9);
INSERT INTO exercise_metrics (interval, calories, steps, "Active Time", exericse_details_exercise_id)
VALUES (10, 88, 880, 17, 10);

--SLEEP DETAILS TABLE
INSERT INTO sleep_details (sleep_id, from_sleep_time, to_sleep_time, user_details_user_id)
VALUES (1, TO_DATE('2023-11-01 22:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-11-01 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 1);
INSERT INTO sleep_details (sleep_id, from_sleep_time, to_sleep_time, user_details_user_id)
VALUES(2, TO_DATE('2023-11-02 23:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-11-03 00:30:00', 'YYYY-MM-DD HH24:MI:SS'), 2);
INSERT INTO sleep_details (sleep_id, from_sleep_time, to_sleep_time, user_details_user_id)
VALUES(3, TO_DATE('2023-11-03 22:45:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-11-03 23:45:00', 'YYYY-MM-DD HH24:MI:SS'), 3);
INSERT INTO sleep_details (sleep_id, from_sleep_time, to_sleep_time, user_details_user_id)
VALUES(4, TO_DATE('2023-11-04 23:15:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-11-05 00:15:00', 'YYYY-MM-DD HH24:MI:SS'), 4);
INSERT INTO sleep_details (sleep_id, from_sleep_time, to_sleep_time, user_details_user_id)
VALUES(5, TO_DATE('2023-11-05 22:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-11-05 23:30:00', 'YYYY-MM-DD HH24:MI:SS'), 5);
INSERT INTO sleep_details (sleep_id, from_sleep_time, to_sleep_time, user_details_user_id)
VALUES(6, TO_DATE('2023-11-06 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-11-07 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 6);
INSERT INTO sleep_details (sleep_id, from_sleep_time, to_sleep_time, user_details_user_id)
VALUES(7, TO_DATE('2023-11-07 22:15:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-11-07 23:15:00', 'YYYY-MM-DD HH24:MI:SS'), 7);
INSERT INTO sleep_details (sleep_id, from_sleep_time, to_sleep_time, user_details_user_id)
VALUES(8, TO_DATE('2023-11-08 23:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-11-09 00:30:00', 'YYYY-MM-DD HH24:MI:SS'), 8);
INSERT INTO sleep_details (sleep_id, from_sleep_time, to_sleep_time, user_details_user_id)
VALUES(9, TO_DATE('2023-11-09 22:45:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-11-09 23:45:00', 'YYYY-MM-DD HH24:MI:SS'), 9);
INSERT INTO sleep_details (sleep_id, from_sleep_time, to_sleep_time, user_details_user_id)
VALUES(10, TO_DATE('2023-11-10 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-11-11 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 10);

--Sleep Metrics Table

INSERT INTO sleep_metrics (sleep_cycle, deep_sleep, awake, rem, light, sleep_details_sleep_id)
VALUES (1, 45, 20, 15, 80, 1);
INSERT INTO sleep_metrics (sleep_cycle, deep_sleep, awake, rem, light, sleep_details_sleep_id)
VALUES (2, 50, 25, 10, 85, 2);
INSERT INTO sleep_metrics (sleep_cycle, deep_sleep, awake, rem, light, sleep_details_sleep_id)
VALUES (3, 40, 30, 20, 75, 3);
INSERT INTO sleep_metrics (sleep_cycle, deep_sleep, awake, rem, light, sleep_details_sleep_id)
VALUES (4, 55, 15, 15, 90, 4);
INSERT INTO sleep_metrics (sleep_cycle, deep_sleep, awake, rem, light, sleep_details_sleep_id)
VALUES (5, 60, 10, 20, 80, 5);
INSERT INTO sleep_metrics (sleep_cycle, deep_sleep, awake, rem, light, sleep_details_sleep_id)
VALUES (6, 35, 25, 20, 70, 6);
INSERT INTO sleep_metrics (sleep_cycle, deep_sleep, awake, rem, light, sleep_details_sleep_id)
VALUES (7, 70, 5, 15, 80, 7);
INSERT INTO sleep_metrics (sleep_cycle, deep_sleep, awake, rem, light, sleep_details_sleep_id)
VALUES (8, 30, 35, 15, 70, 8);
INSERT INTO sleep_metrics (sleep_cycle, deep_sleep, awake, rem, light, sleep_details_sleep_id)
VALUES (9, 50, 20, 20, 85, 9);
INSERT INTO sleep_metrics (sleep_cycle, deep_sleep, awake, rem, light, sleep_details_sleep_id)
VALUES (10, 65, 10, 25, 90, 10);

--Health Details Table
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exericse_details_exercise_id, sleep_details_sleep_id)
VALUES (TO_DATE('2023-11-01 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), 95, 70, 'Normal', 120, 80, 1, 1, 1);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exericse_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-02 08:30:00', 'YYYY-MM-DD HH24:MI:SS'), 94, 72, 'Normal', 122, 82, 2, 2, 2);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exericse_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-03 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), 96, 68, 'Normal', 118, 78, 3, 3, 3);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exericse_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-04 09:30:00', 'YYYY-MM-DD HH24:MI:SS'), 93, 75, 'Normal', 124, 84, 4, 4, 4);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exericse_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-05 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 97, 73, 'Normal', 126, 86, 5, 5, 5);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exericse_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-06 10:30:00', 'YYYY-MM-DD HH24:MI:SS'), 92, 76, 'Normal', 128, 88, 6, 6, 6);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exericse_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-07 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 98, 72, 'Normal', 130, 90, 7, 7, 7);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exericse_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-08 11:30:00', 'YYYY-MM-DD HH24:MI:SS'), 91, 78, 'Normal', 132, 92, 8, 8, 8);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exericse_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-09 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 99, 75, 'Normal', 134, 94, 9, 9, 9);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exericse_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-10 12:30:00', 'YYYY-MM-DD HH24:MI:SS'), 90, 80, 'Normal', 136, 96, 10, 10, 10);

