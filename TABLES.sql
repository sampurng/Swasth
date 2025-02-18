-- CREATE TABLE NEwTab(ID NUMBER PRIMARY KEY, NAME VARCHAR(20));
-- CREATE SEQUENCE MY_SEQ START WITH 1111 increment by 10; 

-- CREATE TABLE CIasda(ID_a NUMBER PRIMARY KEY, CONSTRAINT ABC FOREIGN KEY (ID_a) REFERENCES NEwTab(ID), NAME VARCHAR(20));


 -- SELECT * FROM USER_CONSTRAINTS;
-- SELECT * FROM USEr_TABLES;
-- SELECT * FRoM USER_SEQUENCES;
 
-- DROP TABLE NEwTab;

PURGE RECYCLEBIN;

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
CREATE SEQUENCE SEQ_USER_ID
  START WITH 2023100001
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;

-- CREATING USER_DETAILS TABLE
CREATE TABLE user_details (
    user_id           NUMBER NOT NULL,
    first_name        VARCHAR2(200 CHAR) NOT NULL,
    last_name         VARCHAR2(200 CHAR),
    email             VARCHAR2(200 CHAR) UNIQUE NOT NULL,
    street_address    VARCHAR2(200 CHAR) NOT NULL,
    city              VARCHAR2(200 CHAR) NOT NULL,
    country           VARCHAR2(200 CHAR) NOT NULL,
    states            VARCHAR2(200 CHAR) NOT NULL,
    zipcode           NUMBER NOT NULL, 
    age               NUMBER NOT NULL, 
    sex               VARCHAR(1) NOT NULL, 
    CONSTRAINT chk_age CHECK(age >13), 
    CONSTRAINT chk_sex CHECK(sex IN ('M', 'F')), 
    CONSTRAINT chk_zipcode CHECK(LENGTH(zipcode) > 4)
);

-- ADDING  CONSTRATINTS TO USER_DETAILS
ALTER TABLE user_details ADD CONSTRAINT user_details_pk PRIMARY KEY ( user_id );


-- CREATING Body Composition AND SEQUENCE -- 20
CREATE SEQUENCE SEQ_BODYCOMM_ID 
    START WITH 2023200001
    INCREMENT BY 1
    NOCYCLE
    NOCACHE;

-----CREATING BODY_COMPOSITION TABLE---------
CREATE TABLE body_composition (
    body_composition_id  NUMBER NOT NULL,
    height               NUMBER NOT NULL,
    weight               NUMBER NOT NULL,
    skeletal_muscle_mass NUMBER,
    fat_mass             NUMBER,
    body_fat             NUMBER,
    body_water           NUMBER,
    user_details_user_id NUMBER NOT NULL, 
    CONSTRAINT chk_negatives_bodyComposiiton CHECK(height > 0 AND weight > 0 AND skeletal_muscle_mass > 0 AND fat_mass > 0 AND body_water > 0 AND body_fat > 3 AND body_fat < 100)
);

-- ADDING  CONSTRATINTS TO BODY_COMPOSITION--------
ALTER TABLE body_composition ADD CONSTRAINT body_composition_pk PRIMARY KEY ( body_composition_id );

-------Foreign Key Constraint--------
ALTER TABLE body_composition
    ADD CONSTRAINT bodyComm_UD_fk FOREIGN KEY ( user_details_user_id )
        REFERENCES user_details ( user_id )
            ON DELETE CASCADE;


-- CREATING  EXERCISE_DEATILS AND SEQUENCE ---CODE IS 30-----
CREATE SEQUENCE SEQ_EXERCISEDETAILS_ID 
    START WITH 2023300001
    INCREMENT BY 1
    NOCYCLE
    NOCACHE;

-----CREATING EXERCISE_DETAILS TABLE---------

CREATE TABLE exercise_details (
    exercise_id          NUMBER NOT NULL,
    type                 VARCHAR2(10 CHAR) NOT NULL,
    from_exercise_time   DATE NOT NULL,
    to_exercise_time     DATE NOT NULL,
    user_details_user_id NUMBER NOT NULL, 
    CONSTRAINT chk_time_diff_exerciseDetails CHECK(to_exercise_time > from_exercise_time)
);

------ ADDING  CONSTRATINTS TO EXERCISE_DETAILS --------
ALTER TABLE exercise_details ADD CONSTRAINT exercise_details_pk PRIMARY KEY ( exercise_id );

------Foreign Key Constraint--------
ALTER TABLE exercise_details
    ADD CONSTRAINT exercise_details_user_details_fk FOREIGN KEY ( user_details_user_id )
        REFERENCES user_details ( user_id )
            ON DELETE CASCADE;
            
            
-- CREATING  EXERCISE_METRICS AND SEQUENCE ---CODE IS 35-----
CREATE SEQUENCE SEQ_EXERCISEMETRICS_ID 
    START WITH 2023350001
    INCREMENT BY 1
    NOCYCLE
    NOCACHE;

-----CREATING EXERCISE_METRICS TABLE---------

CREATE TABLE exercise_metrics (
    interval                     NUMBER NOT NULL,
    calories                     NUMBER NOT NULL,
    steps                        NUMBER,
    active_time                  NUMBER,
    exercise_details_exercise_id NUMBER NOT NULL,
    CONSTRAINT chk_negatives_exerciseMetrics CHECK(steps >= 0 AND calories > 0 AND active_time >= 0),
    CONSTRAINT chk_interval_time CHECK(active_time <= 10)
);

------ ADDING  CONSTRATINTS TO EXERCISE_METRICS --------

ALTER TABLE exercise_metrics ADD CONSTRAINT exercise_metrics_pk PRIMARY KEY ( exercise_details_exercise_id,interval );

------Foreign Key Constraint--------
ALTER TABLE exercise_metrics
    ADD CONSTRAINT exercise_metrics_exercise_details_fk FOREIGN KEY ( exercise_details_exercise_id )
        REFERENCES exercise_details ( exercise_id )
            ON DELETE CASCADE;
            
-- CREATING  SLEEP_DETAILS AND SEQUENCE   ---CODE IS 40-----
CREATE SEQUENCE SEQ_SLEEPDETAILS_ID 
    START WITH 2023400001
    INCREMENT BY 1
    NOCYCLE
    NOCACHE;

-----CREATING SLEEP_DETAILS TABLE---------
CREATE TABLE sleep_details (
    sleep_id             NUMBER NOT NULL,
    from_sleep_time      DATE NOT NULL,
    to_sleep_time        DATE NOT NULL,
    user_details_user_id NUMBER NOT NULL,
    CONSTRAINT chk_time_diff_SleepDetails CHECK(to_Sleep_time > from_sleep_time)
);

------ ADDING  CONSTRATINTS TO SLEEP_DETAILS --------
ALTER TABLE sleep_details ADD CONSTRAINT sleep_pk PRIMARY KEY ( sleep_id );

------Foreign Key Constraint--------
ALTER TABLE sleep_details
    ADD CONSTRAINT sleep_details_user_details_fk FOREIGN KEY ( user_details_user_id )
        REFERENCES user_details ( user_id )
            ON DELETE CASCADE;

-- CREATING  SLEEP_METRICS AND SEQUENCE   ---CODE IS 45-----
CREATE SEQUENCE SEQ_SLEEPMETRICS_ID 
    START WITH 2023450001
    INCREMENT BY 1
    NOCYCLE
    NOCACHE;

-----CREATING SLEEP_METRICS TABLE---------
CREATE TABLE sleep_metrics (
    sleep_cycle            NUMBER NOT NULL,
    deep_sleep             NUMBER,
    awake                  NUMBER,
    rem                    NUMBER,
    light                  NUMBER,
    sleep_details_sleep_id NUMBER NOT NULL,
    CONSTRAINT chk_negatives_sleepMetrics CHECK(sleep_cycle > 0 AND deep_sleep >=0 AND awake >= 0 AND rem >= 0 AND light >= 0)
);

------ ADDING  CONSTRATINTS TO SLEEP_METRICS --------
-- ALTER TABLE sleep_metrics ADD CONSTRAINT sleep_metrics_pk PRIMARY KEY ( sleep_details_sleep_id, sleep_cycle );
                                                                        
------Foreign Key Constraint--------
ALTER TABLE sleep_metrics
    ADD CONSTRAINT sleep_metrics_sleep_details_fk FOREIGN KEY ( sleep_details_sleep_id )
        REFERENCES sleep_details ( sleep_id )
            ON DELETE CASCADE;
            
-- CREATING  HEALTH_DETAILS AND SEQUENCE   ---CODE IS 50-----
CREATE SEQUENCE SEQ_HEALTHDETAILS_ID 
    START WITH 2023500001
    INCREMENT BY 1
    NOCYCLE
    NOCACHE;

-----CREATING HEALTH_DETAILS TABLE---------
CREATE TABLE health_details (
    time_of_activity             DATE NOT NULL,
    blood_oxygen                 NUMBER,
    heart_rate                   NUMBER NOT NULL,
    ecg                          VARCHAR2(10 CHAR),
    bp_systolic                  NUMBER,
    bp_diastolic                 NUMBER,
    user_details_user_id         NUMBER NOT NULL,
    exercise_details_exercise_id NUMBER,
    sleep_details_sleep_id       NUMBER,
    CONSTRAINT chk_validity_healthDetails CHECK(blood_oxygen > 0 AND blood_oxygen <= 100 AND heart_rate > 10 AND heart_rate < 300 AND bp_systolic > 0 AND bp_diastolic > 0),
    CONSTRAINT chk_sleep_exercise_same_time CHECK(exercise_details_exercise_id IS NULL OR sleep_details_sleep_id IS NULL)
);

------ ADDING  CONSTRATINTS TO HEALTH_DETAILS --------
-- ALTER TABLE health_details ADD CONSTRAINT health_details_pk PRIMARY KEY ( time_of_activity );

------Foreign Key Constraint--------
ALTER TABLE health_details
 ADD CONSTRAINT health_details_user_details_fk FOREIGN KEY ( user_details_user_id )
        REFERENCES user_details ( user_id )
            ON DELETE CASCADE;

            
--Adding Data to the tables
--USER_DETAILS

--USER 1
INSERT INTO user_details (user_id, first_name, last_name, email, street_address, city, country, states, zipcode, age, sex)
VALUES (SEQ_USER_ID.NEXTVAL , 'John', 'Doe', 'john.doe@example.com', '123 Main St', 'BOSTON', 'UNITED STATES', 'MASSECHUSETS', 12345, 30, 'M');

INSERT INTO body_composition (body_composition_id, height, weight, skeletal_muscle_mass, fat_mass, body_fat, body_water, user_details_user_id)
VALUES (SEQ_BODYCOMM_ID.NEXTVAL, 170, 70, 60, 15, 20, 45, SEQ_USER_ID.CURRVAL);

INSERT INTO exercise_details (exercise_id, type, from_exercise_time, to_exercise_time, user_details_user_id)
VALUES (SEQ_EXERCISEDETAILS_ID.NEXTVAL, 'running', TO_DATE('2023-10-01 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-10-01 08:50:00', 'YYYY-MM-DD HH24:MI:SS'), SEQ_USER_ID.CURRVAL);

INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-10-01 08:10:00', 'YYYY-MM-DD HH24:MI:SS'), 98, 120, 'Normal', 130, 90, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-10-01 08:20:00', 'YYYY-MM-DD HH24:MI:SS'), 91, 165, 'Normal', 132, 92, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-10-01 08:30:00', 'YYYY-MM-DD HH24:MI:SS'), 99, 180, 'Normal', 134, 94, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-10-01 08:40:00', 'YYYY-MM-DD HH24:MI:SS'), 90, 170, 'Normal', 136, 96, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-10-01 08:50:00', 'YYYY-MM-DD HH24:MI:SS'), 93, 150, 'Normal', 124, 84, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);

INSERT INTO exercise_metrics (interval, calories, steps, active_time, exercise_details_exercise_id)
VALUES (1, 100, 1000, 8, SEQ_EXERCISEDETAILS_ID.CURRVAL);

INSERT INTO exercise_details (exercise_id, type, from_exercise_time, to_exercise_time, user_details_user_id)
VALUES(SEQ_EXERCISEDETAILS_ID.NEXTVAL, 'walking', TO_DATE('2023-10-28 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-10-28 09:50:00', 'YYYY-MM-DD HH24:MI:SS'), SEQ_USER_ID.CURRVAL);

--measuring health details 5 times in half hour of exercise here
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES (TO_DATE('2023-10-28 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), 95, 80, 'Normal', 120, 80, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-10-28 09:10:00', 'YYYY-MM-DD HH24:MI:SS'), 94, 92, 'Normal', 122, 82, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-10-28 09:20:00', 'YYYY-MM-DD HH24:MI:SS'), 96, 130, 'Normal', 118, 78, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-10-28 09:30:00', 'YYYY-MM-DD HH24:MI:SS'), 93, 150, 'Normal', 124, 84, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-10-28 09:40:00', 'YYYY-MM-DD HH24:MI:SS'), 97, 160, 'Normal', 126, 86, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-10-28 09:50:00', 'YYYY-MM-DD HH24:MI:SS'), 99, 100, 'Normal', 120, 68, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);


INSERT INTO exercise_metrics (interval, calories, steps, active_time, exercise_details_exercise_id)
VALUES (1, 80, 800, 5,  SEQ_EXERCISEDETAILS_ID.CURRVAL);

INSERT INTO exercise_details (exercise_id, type, from_exercise_time, to_exercise_time, user_details_user_id)
VALUES(SEQ_EXERCISEDETAILS_ID.NEXTVAL, 'cycling', TO_DATE('2023-11-30 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-11-30 11:30:00', 'YYYY-MM-DD HH24:MI:SS'), SEQ_USER_ID.CURRVAL);

--measuring again for exercise
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-30 10:10:00', 'YYYY-MM-DD HH24:MI:SS'), 99, 76, 'Normal', 128, 88, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-30 10:20:00', 'YYYY-MM-DD HH24:MI:SS'), 98, 120, 'Normal', 130, 90, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-30 10:30:00', 'YYYY-MM-DD HH24:MI:SS'), 91, 165, 'Normal', 132, 92, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-30 10:40:00', 'YYYY-MM-DD HH24:MI:SS'), 99, 180, 'Normal', 134, 94, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-30 10:50:00', 'YYYY-MM-DD HH24:MI:SS'), 90, 170, 'Normal', 136, 96, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-30 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 93, 150, 'Normal', 124, 84, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-30 11:10:00', 'YYYY-MM-DD HH24:MI:SS'), 97, 160, 'Normal', 126, 86, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-30 11:20:00', 'YYYY-MM-DD HH24:MI:SS'), 91, 161, 'Normal', 132, 92, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-30 11:30:00', 'YYYY-MM-DD HH24:MI:SS'), 99, 180, 'Normal', 134, 94, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);


INSERT INTO exercise_metrics (interval, calories, steps, active_time, exercise_details_exercise_id)
VALUES (1, 120, 1200, 5, SEQ_EXERCISEDETAILS_ID.CURRVAL);

INSERT INTO exercise_metrics (interval, calories, steps, active_time, exercise_details_exercise_id)
VALUES (2, 90, 900, 9, SEQ_EXERCISEDETAILS_ID.CURRVAL);

INSERT INTO exercise_metrics (interval, calories, steps, active_time, exercise_details_exercise_id)
VALUES (3, 110, 1100, 10, SEQ_EXERCISEDETAILS_ID.CURRVAL);

INSERT INTO exercise_details (exercise_id, type, from_exercise_time, to_exercise_time, user_details_user_id)
VALUES(SEQ_EXERCISEDETAILS_ID.NEXTVAL, 'swimming', TO_DATE('2023-12-12 11:05:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-12-12 12:10:00', 'YYYY-MM-DD HH24:MI:SS'), SEQ_USER_ID.CURRVAL);

-- Inserting health details for swimming activity
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-12-12 11:05:00', 'YYYY-MM-DD HH24:MI:SS'), 98, 113, 'Normal', 118, 78, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-12-12 11:15:00', 'YYYY-MM-DD HH24:MI:SS'), 97, 107, 'Normal', 120, 80, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-12-12 11:25:00', 'YYYY-MM-DD HH24:MI:SS'), 96, 100, 'Normal', 122, 82, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-12-12 11:35:00', 'YYYY-MM-DD HH24:MI:SS'), 95, 95, 'Normal', 124, 84, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-12-12 11:45:00', 'YYYY-MM-DD HH24:MI:SS'), 100, 90, 'Normal', 126, 86, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-12-12 11:55:00', 'YYYY-MM-DD HH24:MI:SS'), 100, 95, 'Normal', 124, 84, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-12-12 12:10:00', 'YYYY-MM-DD HH24:MI:SS'), 100, 98, 'Normal', 122, 82, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);

-- Exercise metrics for swimming activity (assuming 1 interval is 10 minutes)
INSERT INTO exercise_metrics (interval, calories, steps, active_time, exercise_details_exercise_id)
VALUES (1, 50, 531, 9, SEQ_EXERCISEDETAILS_ID.CURRVAL);

INSERT INTO exercise_metrics (interval, calories, steps, active_time, exercise_details_exercise_id)
VALUES (2, 65, 0, 7, SEQ_EXERCISEDETAILS_ID.CURRVAL);

INSERT INTO exercise_metrics (interval, calories, steps, active_time, exercise_details_exercise_id)
VALUES (3, 80, 0, 10, SEQ_EXERCISEDETAILS_ID.CURRVAL);

INSERT INTO exercise_metrics (interval, calories, steps, active_time, exercise_details_exercise_id)
VALUES (4, 95, 801, 5, SEQ_EXERCISEDETAILS_ID.CURRVAL);

INSERT INTO sleep_details (sleep_id, from_sleep_time, to_sleep_time, user_details_user_id)
VALUES (SEQ_SLEEPDETAILS_ID.NEXTVAL, TO_DATE('2023-11-01 22:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-11-02 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), SEQ_USER_ID.CURRVAL);

INSERT INTO sleep_metrics (sleep_cycle, deep_sleep, awake, rem, light, sleep_details_sleep_id)
VALUES (1, 15, 10, 20, 5, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO sleep_metrics (sleep_cycle, deep_sleep, awake, rem, light, sleep_details_sleep_id)
VALUES (2, 8, 12, 18, 2, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO sleep_metrics (sleep_cycle, deep_sleep, awake, rem, light, sleep_details_sleep_id)
VALUES (3, 10, 8, 25, 7, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO sleep_metrics (sleep_cycle, deep_sleep, awake, rem, light, sleep_details_sleep_id)
VALUES (4, 5, 15, 20, 8, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO sleep_metrics (sleep_cycle, deep_sleep, awake, rem, light, sleep_details_sleep_id)
VALUES (5, 12, 10, 18, 9, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO sleep_metrics (sleep_cycle, deep_sleep, awake, rem, light, sleep_details_sleep_id)
VALUES (6, 7, 8, 15, 8, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO sleep_metrics (sleep_cycle, deep_sleep, awake, rem, light, sleep_details_sleep_id)
VALUES (7, 9, 12, 18, 10, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO sleep_metrics (sleep_cycle, deep_sleep, awake, rem, light, sleep_details_sleep_id)
VALUES (8, 15, 10, 8, 9, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO sleep_metrics (sleep_cycle, deep_sleep, awake, rem, light, sleep_details_sleep_id)
VALUES (9, 6, 9, 25, 7, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO sleep_metrics (sleep_cycle, deep_sleep, awake, rem, light, sleep_details_sleep_id)
VALUES (10, 14, 13, 8, 8, SEQ_SLEEPDETAILS_ID.CURRVAL);

--adding health metrics when user is sleeping

INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-01 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 99, 62, 'Normal', 128, 88, SEQ_USER_ID.CURRVAL, null, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-01 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 95, 63, 'Normal', 130, 90, SEQ_USER_ID.CURRVAL, null, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-02 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 94, 76, 'Normal', 132, 92, SEQ_USER_ID.CURRVAL, null, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-02 01:00:00', 'YYYY-MM-DD HH24:MI:SS'), 99, 46, 'Normal', 134, 94, SEQ_USER_ID.CURRVAL, null, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-02 02:00:00', 'YYYY-MM-DD HH24:MI:SS'), 99, 55, 'Normal', 136, 96, SEQ_USER_ID.CURRVAL, null, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-02 03:00:00', 'YYYY-MM-DD HH24:MI:SS'), 100, 49, 'Normal', 124, 84, SEQ_USER_ID.CURRVAL, null, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-02 04:00:00', 'YYYY-MM-DD HH24:MI:SS'), 98, 50, 'Normal', 126, 86, SEQ_USER_ID.CURRVAL, null, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-02 05:00:00', 'YYYY-MM-DD HH24:MI:SS'), 99, 53, 'Normal', 130, 92, SEQ_USER_ID.CURRVAL, null, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-02 06:00:00', 'YYYY-MM-DD HH24:MI:SS'), 99, 57, 'Normal', 134, 94, SEQ_USER_ID.CURRVAL, null, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-02 07:00:00', 'YYYY-MM-DD HH24:MI:SS'), 99, 60, 'Normal', 125, 94, SEQ_USER_ID.CURRVAL, null, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-01 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), 99, 65, 'Normal', 120, 94, SEQ_USER_ID.CURRVAL, null, SEQ_SLEEPDETAILS_ID.CURRVAL);


--USER 2 
INSERT INTO user_details (user_id, first_name, last_name, email, street_address, city, country, states, zipcode, age, sex)
VALUES (SEQ_USER_ID.NEXTVAL , 'Annie', 'Frank', 'annie.frank@example.com', '74 St Richard', 'NEW YORK', 'UNITED STATES', 'NEW YORK', 21245, 25, 'F');


INSERT INTO body_composition (body_composition_id, height, weight, skeletal_muscle_mass, fat_mass, body_fat, body_water, user_details_user_id)
VALUES (SEQ_BODYCOMM_ID.NEXTVAL, 156, 65, 60, 19, 15, 50, SEQ_USER_ID.CURRVAL);

INSERT INTO exercise_details (exercise_id, type, from_exercise_time, to_exercise_time, user_details_user_id)
VALUES (SEQ_EXERCISEDETAILS_ID.NEXTVAL, 'swimming', TO_DATE('2023-10-02 06:10:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-10-02 07:00:00', 'YYYY-MM-DD HH24:MI:SS'), SEQ_USER_ID.CURRVAL);

INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-10-02 06:10:00', 'YYYY-MM-DD HH24:MI:SS'), 95, 119, 'Normal', 125, 95, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-10-01 06:20:00', 'YYYY-MM-DD HH24:MI:SS'), 91, 165, 'Normal', 132, 92, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-10-01 06:30:00', 'YYYY-MM-DD HH24:MI:SS'), 99, 170, 'Normal', 135, 96, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-10-01 06:40:00', 'YYYY-MM-DD HH24:MI:SS'), 93, 165, 'Normal', 129, 84, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-10-01 06:50:00', 'YYYY-MM-DD HH24:MI:SS'), 92, 150, 'Normal', 130, 96, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-10-01 07:00:00', 'YYYY-MM-DD HH24:MI:SS'), 92, 170, 'Normal', 130, 96, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);


INSERT INTO exercise_metrics (interval, calories, steps, active_time, exercise_details_exercise_id)
VALUES (1, 110, 1200, 10, SEQ_EXERCISEDETAILS_ID.CURRVAL);

INSERT INTO exercise_details (exercise_id, type, from_exercise_time, to_exercise_time, user_details_user_id)
VALUES(SEQ_EXERCISEDETAILS_ID.NEXTVAL, 'running', TO_DATE('2023-10-3 07:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-10-03 07:30:00', 'YYYY-MM-DD HH24:MI:SS'), SEQ_USER_ID.CURRVAL);

--measuring health details 5 times in half hour of exercise here
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES (TO_DATE('2023-10-03 07:05:23', 'YYYY-MM-DD HH24:MI:SS'), 95, 80, 'Normal', 120, 80, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-10-03 07:10:10', 'YYYY-MM-DD HH24:MI:SS'), 94, 92, 'Normal', 122, 82, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-10-03 07:15:11', 'YYYY-MM-DD HH24:MI:SS'), 96, 130, 'Normal', 118, 78, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-10-03 07:20:23', 'YYYY-MM-DD HH24:MI:SS'), 93, 150, 'Normal', 124, 84, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-10-03 07:25:35', 'YYYY-MM-DD HH24:MI:SS'), 97, 160, 'Normal', 126, 86, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-10-03 07:30:44', 'YYYY-MM-DD HH24:MI:SS'), 99, 100, 'Normal', 120, 68, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);


INSERT INTO exercise_metrics (interval, calories, steps, active_time, exercise_details_exercise_id)
VALUES (1, 85, 850, 6,  SEQ_EXERCISEDETAILS_ID.CURRVAL);

INSERT INTO exercise_details (exercise_id, type, from_exercise_time, to_exercise_time, user_details_user_id)
VALUES(SEQ_EXERCISEDETAILS_ID.NEXTVAL, 'cycling', TO_DATE('2023-11-29 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-11-29 09:30:00', 'YYYY-MM-DD HH24:MI:SS'), SEQ_USER_ID.CURRVAL);

--measuring again for exercise
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-29 09:10:00', 'YYYY-MM-DD HH24:MI:SS'), 99, 78, 'Normal', 128, 88, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-29 09:20:00', 'YYYY-MM-DD HH24:MI:SS'), 92, 119, 'Normal', 130, 90, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-29 09:30:00', 'YYYY-MM-DD HH24:MI:SS'), 92, 166, 'Normal', 132, 92, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-29 09:40:00', 'YYYY-MM-DD HH24:MI:SS'), 98, 178, 'Normal', 134, 94, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-29 09:50:00', 'YYYY-MM-DD HH24:MI:SS'), 89, 180, 'Normal', 136, 96, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-29 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), 92, 156, 'Normal', 124, 84, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-29 09:10:23', 'YYYY-MM-DD HH24:MI:SS'), 95, 165, 'Normal', 126, 86, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-30 09:20:37', 'YYYY-MM-DD HH24:MI:SS'), 91, 161, 'Normal', 132, 92, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-30 09:30:41', 'YYYY-MM-DD HH24:MI:SS'), 99, 180, 'Normal', 134, 94, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);


INSERT INTO exercise_metrics (interval, calories, steps, active_time, exercise_details_exercise_id)
VALUES (1, 119, 1198, 5, SEQ_EXERCISEDETAILS_ID.CURRVAL);

INSERT INTO exercise_metrics (interval, calories, steps, active_time, exercise_details_exercise_id)
VALUES (2, 92, 992, 5, SEQ_EXERCISEDETAILS_ID.CURRVAL);

INSERT INTO exercise_metrics (interval, calories, steps, active_time, exercise_details_exercise_id)
VALUES (3, 109, 1109, 10, SEQ_EXERCISEDETAILS_ID.CURRVAL);

INSERT INTO exercise_details (exercise_id, type, from_exercise_time, to_exercise_time, user_details_user_id)
VALUES (SEQ_EXERCISEDETAILS_ID.NEXTVAL, 'walking', TO_DATE('2023-10-02 06:10:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-10-02 07:00:00', 'YYYY-MM-DD HH24:MI:SS'), SEQ_USER_ID.CURRVAL);

INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-10-02 06:10:00', 'YYYY-MM-DD HH24:MI:SS'), 95, 119, 'Normal', 125, 95, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);

INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-10-02 06:20:00', 'YYYY-MM-DD HH24:MI:SS'), 93, 130, 'Normal', 125, 95, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);

INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-10-02 06:30:00', 'YYYY-MM-DD HH24:MI:SS'), 91, 140, 'Normal', 125, 95, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);

INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-10-02 06:40:00', 'YYYY-MM-DD HH24:MI:SS'), 88, 150, 'Normal', 125, 95, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);

INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-10-02 06:50:00', 'YYYY-MM-DD HH24:MI:SS'), 88, 150, 'Normal', 125, 95, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);

INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-10-02 07:00:00', 'YYYY-MM-DD HH24:MI:SS'), 88, 150, 'Normal', 125, 95, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);

-- Insert the corresponding exercise metrics
INSERT INTO exercise_metrics (interval, calories, steps, active_time, exercise_details_exercise_id)
VALUES (1, 59, 900, 2, SEQ_EXERCISEDETAILS_ID.CURRVAL);

INSERT INTO exercise_metrics (interval, calories, steps, active_time, exercise_details_exercise_id)
VALUES (2, 75, 1200, 8, SEQ_EXERCISEDETAILS_ID.CURRVAL);

INSERT INTO exercise_metrics (interval, calories, steps, active_time, exercise_details_exercise_id)
VALUES (3, 88, 800, 9, SEQ_EXERCISEDETAILS_ID.CURRVAL);

INSERT INTO exercise_metrics (interval, calories, steps, active_time, exercise_details_exercise_id)
VALUES (4, 90, 878, 10, SEQ_EXERCISEDETAILS_ID.CURRVAL);

INSERT INTO exercise_metrics (interval, calories, steps, active_time, exercise_details_exercise_id)
VALUES (5, 100, 989, 7, SEQ_EXERCISEDETAILS_ID.CURRVAL);

INSERT INTO sleep_details (sleep_id, from_sleep_time, to_sleep_time, user_details_user_id)
VALUES (SEQ_SLEEPDETAILS_ID.NEXTVAL, TO_DATE('2023-11-03 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-11-04 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), SEQ_USER_ID.CURRVAL);

INSERT INTO sleep_metrics (sleep_cycle, deep_sleep, awake, rem, light, sleep_details_sleep_id)
VALUES (1, 13, 09, 19, 4, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO sleep_metrics (sleep_cycle, deep_sleep, awake, rem, light, sleep_details_sleep_id)
VALUES (2, 7, 14, 15, 3, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO sleep_metrics (sleep_cycle, deep_sleep, awake, rem, light, sleep_details_sleep_id)
VALUES (3, 11, 8, 24, 2, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO sleep_metrics (sleep_cycle, deep_sleep, awake, rem, light, sleep_details_sleep_id)
VALUES (5, 6, 16, 18, 9, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO sleep_metrics (sleep_cycle, deep_sleep, awake, rem, light, sleep_details_sleep_id)
VALUES (5, 12, 10, 18, 8, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO sleep_metrics (sleep_cycle, deep_sleep, awake, rem, light, sleep_details_sleep_id)
VALUES (6, 7, 8, 15, 7, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO sleep_metrics (sleep_cycle, deep_sleep, awake, rem, light, sleep_details_sleep_id)
VALUES (7, 9, 12, 18, 8, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO sleep_metrics (sleep_cycle, deep_sleep, awake, rem, light, sleep_details_sleep_id)
VALUES (8, 14, 10, 9, 9, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO sleep_metrics (sleep_cycle, deep_sleep, awake, rem, light, sleep_details_sleep_id)
VALUES (9, 6, 8, 22, 10, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO sleep_metrics (sleep_cycle, deep_sleep, awake, rem, light, sleep_details_sleep_id)
VALUES (10, 11, 13,87, 10, SEQ_SLEEPDETAILS_ID.CURRVAL);

--adding health metrics when user is sleeping

INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-03 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 99, 62, 'Normal', 128, 88, SEQ_USER_ID.CURRVAL, null, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-03 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 95, 63, 'Normal', 130, 90, SEQ_USER_ID.CURRVAL, null, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-04 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 94, 76, 'Normal', 132, 92, SEQ_USER_ID.CURRVAL, null, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-04 01:00:00', 'YYYY-MM-DD HH24:MI:SS'), 99, 46, 'Normal', 134, 94, SEQ_USER_ID.CURRVAL, null, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-04 02:00:00', 'YYYY-MM-DD HH24:MI:SS'), 99, 55, 'Normal', 136, 96, SEQ_USER_ID.CURRVAL, null, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-04 03:00:00', 'YYYY-MM-DD HH24:MI:SS'), 100, 49, 'Normal', 124, 84, SEQ_USER_ID.CURRVAL, null, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-04 04:00:00', 'YYYY-MM-DD HH24:MI:SS'), 98, 50, 'Normal', 126, 86, SEQ_USER_ID.CURRVAL, null, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-04 05:00:00', 'YYYY-MM-DD HH24:MI:SS'), 99, 53, 'Normal', 130, 92, SEQ_USER_ID.CURRVAL, null, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-04 06:00:00', 'YYYY-MM-DD HH24:MI:SS'), 99, 57, 'Normal', 134, 94, SEQ_USER_ID.CURRVAL, null, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-04 07:00:00', 'YYYY-MM-DD HH24:MI:SS'), 99, 60, 'Normal', 125, 94, SEQ_USER_ID.CURRVAL, null, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-02 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), 99, 65, 'Normal', 120, 94, SEQ_USER_ID.CURRVAL, null, SEQ_SLEEPDETAILS_ID.CURRVAL);


--#########################    USER 3    ###########################

INSERT INTO user_details (user_id, first_name, last_name, email, street_address, city, country, states, zipcode, age, sex)
VALUES (SEQ_USER_ID.NEXTVAL , 'Matthew', 'Perry', 'matthew.perry@example.com', '78 St Petter', 'BURLINGTON', 'UNITED STATES', 'VERMONT', 31245, 23, 'M');


INSERT INTO body_composition (body_composition_id, height, weight, skeletal_muscle_mass, fat_mass, body_fat, body_water, user_details_user_id)
VALUES (SEQ_BODYCOMM_ID.NEXTVAL, 169, 80, 70, 21, 14, 45, SEQ_USER_ID.CURRVAL);

INSERT INTO exercise_details (exercise_id, type, from_exercise_time, to_exercise_time, user_details_user_id)
VALUES (SEQ_EXERCISEDETAILS_ID.NEXTVAL, 'running', TO_DATE('2023-10-04 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-10-04 09:30:00', 'YYYY-MM-DD HH24:MI:SS'), SEQ_USER_ID.CURRVAL);

INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-10-04 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), 95, 119, 'Normal', 125, 95, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-10-04 09:10:00', 'YYYY-MM-DD HH24:MI:SS'), 91, 165, 'Normal', 132, 92, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-10-04 09:15:00', 'YYYY-MM-DD HH24:MI:SS'), 99, 170, 'Normal', 135, 96, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-10-04 09:20:00', 'YYYY-MM-DD HH24:MI:SS'), 93, 165, 'Normal', 129, 84, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-10-04 09:25:00', 'YYYY-MM-DD HH24:MI:SS'), 92, 150, 'Normal', 130, 96, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);

INSERT INTO exercise_metrics (interval, calories, steps, active_time, exercise_details_exercise_id)
VALUES (1, 115, 1300, 8, SEQ_EXERCISEDETAILS_ID.CURRVAL);

INSERT INTO exercise_details (exercise_id, type, from_exercise_time, to_exercise_time, user_details_user_id)
VALUES(SEQ_EXERCISEDETAILS_ID.NEXTVAL, 'running', TO_DATE('2023-10-3 07:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-10-03 07:30:00', 'YYYY-MM-DD HH24:MI:SS'), SEQ_USER_ID.CURRVAL);

--measuring health details 5 times in half hour of exercise here
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES (TO_DATE('2023-10-03 07:05:13', 'YYYY-MM-DD HH24:MI:SS'), 95, 80, 'Normal', 120, 80, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-10-03 07:10:16', 'YYYY-MM-DD HH24:MI:SS'), 94, 92, 'Normal', 122, 82, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-10-03 07:15:23', 'YYYY-MM-DD HH24:MI:SS'), 96, 130, 'Normal', 118, 78, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-10-03 07:20:57', 'YYYY-MM-DD HH24:MI:SS'), 93, 150, 'Normal', 124, 84, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-10-03 07:25:11', 'YYYY-MM-DD HH24:MI:SS'), 97, 160, 'Normal', 126, 86, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-10-03 07:30:12', 'YYYY-MM-DD HH24:MI:SS'), 99, 100, 'Normal', 120, 68, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);


INSERT INTO exercise_metrics (interval, calories, steps, active_time, exercise_details_exercise_id)
VALUES (1, 89, 900, 10,  SEQ_EXERCISEDETAILS_ID.CURRVAL);

INSERT INTO exercise_details (exercise_id, type, from_exercise_time, to_exercise_time, user_details_user_id)
VALUES(SEQ_EXERCISEDETAILS_ID.NEXTVAL, 'swimming', TO_DATE('2023-11-30 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-11-30 08:30:00', 'YYYY-MM-DD HH24:MI:SS'), SEQ_USER_ID.CURRVAL);

--measuring again for exercise
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-30 08:10:00', 'YYYY-MM-DD HH24:MI:SS'), 99, 78, 'Normal', 128, 88, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-30 08:20:00', 'YYYY-MM-DD HH24:MI:SS'), 92, 119, 'Normal', 130, 90, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-30 08:30:00', 'YYYY-MM-DD HH24:MI:SS'), 92, 166, 'Normal', 132, 92, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-30 08:40:00', 'YYYY-MM-DD HH24:MI:SS'), 98, 178, 'Normal', 134, 94, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-30 08:50:00', 'YYYY-MM-DD HH24:MI:SS'), 89, 180, 'Normal', 136, 96, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-30 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), 92, 156, 'Normal', 124, 84, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-30 08:10:00', 'YYYY-MM-DD HH24:MI:SS'), 95, 165, 'Normal', 126, 86, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-30 08:20:00', 'YYYY-MM-DD HH24:MI:SS'), 91, 161, 'Normal', 132, 92, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-30 08:30:00', 'YYYY-MM-DD HH24:MI:SS'), 99, 180, 'Normal', 134, 94, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);


INSERT INTO exercise_metrics (interval, calories, steps, active_time, exercise_details_exercise_id)
VALUES (1, 129, 1201, 10, SEQ_EXERCISEDETAILS_ID.CURRVAL);

INSERT INTO exercise_metrics (interval, calories, steps, active_time, exercise_details_exercise_id)
VALUES (2, 100, 1001, 9, SEQ_EXERCISEDETAILS_ID.CURRVAL);

INSERT INTO exercise_metrics (interval, calories, steps, active_time, exercise_details_exercise_id)
VALUES (3, 109, 1109, 8, SEQ_EXERCISEDETAILS_ID.CURRVAL);

-- Another Exercise
INSERT INTO exercise_details (exercise_id, type, from_exercise_time, to_exercise_time, user_details_user_id)
VALUES(SEQ_EXERCISEDETAILS_ID.NEXTVAL, 'swimming', TO_DATE('2023-11-27 11:13:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-11-27 12:26:00', 'YYYY-MM-DD HH24:MI:SS'), SEQ_USER_ID.CURRVAL);

INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-27 11:18:00', 'YYYY-MM-DD HH24:MI:SS'), 97, 80, 'Normal', 127, 91, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-27 11:23:00', 'YYYY-MM-DD HH24:MI:SS'), 98, 83, 'Normal', 126, 92, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-27 11:28:00', 'YYYY-MM-DD HH24:MI:SS'), 99, 90, 'Normal', 126, 83, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-27 11:33:00', 'YYYY-MM-DD HH24:MI:SS'), 99, 89, 'Normal', 126, 83, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-27 11:38:00', 'YYYY-MM-DD HH24:MI:SS'), 99, 120, 'Normal', 126, 83, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-27 11:43:00', 'YYYY-MM-DD HH24:MI:SS'), 98, 125, 'Normal', 127, 81, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-27 11:48:00', 'YYYY-MM-DD HH24:MI:SS'), 100, 130, 'Normal', 121, 81, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-27 11:53:00', 'YYYY-MM-DD HH24:MI:SS'), 100, 156, 'Normal', 121, 81, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-27 12:03:00', 'YYYY-MM-DD HH24:MI:SS'), 99, 171, 'Normal', 121, 80, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-27 12:08:00', 'YYYY-MM-DD HH24:MI:SS'), 99, 172, 'Normal', 120, 79, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-27 12:13:00', 'YYYY-MM-DD HH24:MI:SS'), 100, 181, 'Normal', 120, 81, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-27 12:18:00', 'YYYY-MM-DD HH24:MI:SS'), 100, 183, 'Normal', 120, 75, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-27 12:23:00', 'YYYY-MM-DD HH24:MI:SS'), 100, 160, 'Normal', 118, 79, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, null);

INSERT INTO exercise_metrics (interval, calories, steps, active_time, exercise_details_exercise_id)
VALUES (1, 40, 0, 7, SEQ_EXERCISEDETAILS_ID.CURRVAL);
INSERT INTO exercise_metrics (interval, calories, steps, active_time, exercise_details_exercise_id)
VALUES (2, 70, 0, 8, SEQ_EXERCISEDETAILS_ID.CURRVAL);
INSERT INTO exercise_metrics (interval, calories, steps, active_time, exercise_details_exercise_id)
VALUES (3, 92, 0, 9, SEQ_EXERCISEDETAILS_ID.CURRVAL);
INSERT INTO exercise_metrics (interval, calories, steps, active_time, exercise_details_exercise_id)
VALUES (4, 91, 0, 10, SEQ_EXERCISEDETAILS_ID.CURRVAL);
INSERT INTO exercise_metrics (interval, calories, steps, active_time, exercise_details_exercise_id)
VALUES (5, 88, 0, 10, SEQ_EXERCISEDETAILS_ID.CURRVAL);
INSERT INTO exercise_metrics (interval, calories, steps, active_time, exercise_details_exercise_id)
VALUES (6, 80, 0, 8, SEQ_EXERCISEDETAILS_ID.CURRVAL);
INSERT INTO exercise_metrics (interval, calories, steps, active_time, exercise_details_exercise_id)
VALUES (7, 75, 0, 7, SEQ_EXERCISEDETAILS_ID.CURRVAL);




INSERT INTO sleep_details (sleep_id, from_sleep_time, to_sleep_time, user_details_user_id)
VALUES (SEQ_SLEEPDETAILS_ID.NEXTVAL, TO_DATE('2023-11-03 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-11-04 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), SEQ_USER_ID.CURRVAL);


INSERT INTO sleep_metrics (sleep_cycle, deep_sleep, awake, rem, light, sleep_details_sleep_id)
VALUES (1, 13, 09, 19, 9, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO sleep_metrics (sleep_cycle, deep_sleep, awake, rem, light, sleep_details_sleep_id)
VALUES (2, 7, 14, 15, 8, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO sleep_metrics (sleep_cycle, deep_sleep, awake, rem, light, sleep_details_sleep_id)
VALUES (3, 11, 8, 24, 10, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO sleep_metrics (sleep_cycle, deep_sleep, awake, rem, light, sleep_details_sleep_id)
VALUES (5, 6, 16, 18, 7, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO sleep_metrics (sleep_cycle, deep_sleep, awake, rem, light, sleep_details_sleep_id)
VALUES (5, 12, 10, 18, 1, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO sleep_metrics (sleep_cycle, deep_sleep, awake, rem, light, sleep_details_sleep_id)
VALUES (6, 7, 8, 15, 3, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO sleep_metrics (sleep_cycle, deep_sleep, awake, rem, light, sleep_details_sleep_id)
VALUES (7, 9, 12, 18, 2, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO sleep_metrics (sleep_cycle, deep_sleep, awake, rem, light, sleep_details_sleep_id)
VALUES (8, 14, 10, 9, 7, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO sleep_metrics (sleep_cycle, deep_sleep, awake, rem, light, sleep_details_sleep_id)
VALUES (9, 6, 8, 22, 8, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO sleep_metrics (sleep_cycle, deep_sleep, awake, rem, light, sleep_details_sleep_id)
VALUES (10, 11, 13,87, 9, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO sleep_metrics (sleep_cycle, deep_sleep, awake, rem, light, sleep_details_sleep_id)
VALUES (11, 11, 13,87, 9, SEQ_SLEEPDETAILS_ID.CURRVAL);


-- adding health metrics when user is sleeping
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-03 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 99, 62, 'Normal', 128, 88, SEQ_USER_ID.CURRVAL, null, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-03 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 95, 63, 'Normal', 130, 90, SEQ_USER_ID.CURRVAL, null, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-04 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 94, 76, 'Normal', 132, 92, SEQ_USER_ID.CURRVAL, null, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-04 01:00:00', 'YYYY-MM-DD HH24:MI:SS'), 99, 46, 'Normal', 134, 94, SEQ_USER_ID.CURRVAL, null, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-04 02:00:00', 'YYYY-MM-DD HH24:MI:SS'), 99, 55, 'Normal', 136, 96, SEQ_USER_ID.CURRVAL, null, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-04 03:00:00', 'YYYY-MM-DD HH24:MI:SS'), 100, 49, 'Normal', 124, 84, SEQ_USER_ID.CURRVAL, null, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-04 04:00:00', 'YYYY-MM-DD HH24:MI:SS'), 98, 50, 'Normal', 126, 86, SEQ_USER_ID.CURRVAL, null, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-04 05:00:00', 'YYYY-MM-DD HH24:MI:SS'), 99, 53, 'Normal', 130, 92, SEQ_USER_ID.CURRVAL, null, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-04 06:00:00', 'YYYY-MM-DD HH24:MI:SS'), 99, 57, 'Normal', 134, 94, SEQ_USER_ID.CURRVAL, null, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-04 07:00:00', 'YYYY-MM-DD HH24:MI:SS'), 99, 60, 'Normal', 125, 94, SEQ_USER_ID.CURRVAL, null, SEQ_SLEEPDETAILS_ID.CURRVAL);
INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-11-02 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), 99, 65, 'Normal', 120, 94, SEQ_USER_ID.CURRVAL, null, SEQ_SLEEPDETAILS_ID.CURRVAL);

-- INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
-- VALUES(TO_DATE('2023-11-02 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), 99, 65, 'Normal', 120, 94, SEQ_USER_ID.CURRVAL, SEQ_EXERCISEDETAILS_ID.CURRVAL, SEQ_SLEEPDETAILS_ID.CURRVAL);



CREATE INDEX health_details_index ON health_details(user_details_user_id);

---
SELECT * FROM USER_DETAILS;

SELECT * FROM BODY_COMPOSITION;


SELECT * FROM exercise_details;
SELECT * FROm exercise_metrics;
select * from health_details;
SELECT * FROM sleep_details;

