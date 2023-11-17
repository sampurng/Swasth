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