-- Trigger 1: Generate a trigger when max_steps i.e 10,000 steps per day is reached
SET SERVEROUTPUT ON
/
CREATE OR REPLACE TRIGGER max_steps_trigger
AFTER INSERT ON exercise_metrics
DECLARE
    CURSOR CUR_TOTAL_STEPS_PER_USER_PER_DAY IS 
    SELECT * from daily_goals_view WHERE total_steps > 10000 AND total_calories > 700 AND total_active_time > 100;
BEGIN
    FOR USERS_COMPLETED_DAILY_CHALLENGE IN CUR_TOTAL_STEPS_PER_USER_PER_DAY LOOP
        DBMS_OUTPUT.PUT_LINE('User ' || USERS_COMPLETED_DAILY_CHALLENGE.USER_DETAILS_USER_ID || ' has completed their daily steps ('||USERS_COMPLETED_DAILY_CHALLENGE.total_steps|| ') challenge for Day : ' || USERS_COMPLETED_DAILY_CHALLENGE.to_exercise_time);
    END LOOP;
END;
/

--SELECT * from daily_goals_view WHERE total_steps > 10000 OR total_calories > 700 OR total_active_time > 100;

--INSERT INTO exercise_metrics (interval, calories, steps, active_time, exercise_details_exercise_id)
--VALUES (24, 1000, 12310, 10, 2023300002);

-- drop trigger max_steps_trigger;
-- drop trigger MAX_CALORIES_TRIGGER; 
-- drop trigger heart_rate_trigger;

-- ALTER TRIGGER max_calorie_trigger DISABLE;

-- select * from user_errors where type = 'TRIGGER' and name = 'NEWALERT';


-- Trigger 2 : Abnormal Health trigger
/
CREATE OR REPLACE TRIGGER heart_rate_trigger 
AFTER INSERT ON health_details
DECLARE
    CURSOR abnormal_heart_rate IS SELECT heart_rate, user_details_user_id FROM health_details WHERE heart_rate > 210 OR heart_rate < 47;
    CURSOR abnormal_blood_oxygen IS SELECT blood_oxygen, user_details_user_id FROM health_details WHERE blood_oxygen < 90;
    CURSOR abnormal_BP IS SELECT bp_systolic, bp_diastolic, user_details_user_id FROM health_details WHERE bp_systolic < 100 OR bp_diastolic <60; 
BEGIN
    FOR ahr IN abnormal_heart_rate LOOP
        DBMS_OUTPUT.PUT_LINE('Heart rate : ' || ahr.heart_rate || ' is abnomal for user : ' || ahr.user_details_user_id);
    END LOOP;
    
    FOR abo IN abnormal_blood_oxygen LOOP
        DBMS_OUTPUT.PUT_LINE('Blood Oxygen : ' || abo.blood_oxygen || ' is abnomal for user : ' || abo.user_details_user_id);
    END LOOP;
    
    FOR abp IN abnormal_BP LOOP
        DBMS_OUTPUT.PUT_LINE('BP : ' || abp.bp_systolic || ' / ' || abp.bp_diastolic || ' is abnomal for user : ' || abp.user_details_user_id);
    END LOOP;
END;
/

-- select * from health_details;

INSERT INTO health_details (time_of_activity, blood_oxygen, heart_rate, ecg, bp_systolic, bp_diastolic, user_details_user_id, exercise_details_exercise_id, sleep_details_sleep_id)
VALUES(TO_DATE('2023-10-04 09:09:00', 'YYYY-MM-DD HH24:MI:SS'), 97, 211, 'Normal', 125, 95, 2023100003, 2023300009, null);



 