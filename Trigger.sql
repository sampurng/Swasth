-- Trigger 1: Generate a trigger when max_steps i.e 10,000 steps per day is reached
SET SERVEROUTPUT ON
/
CREATE OR REPLACE TRIGGER max_steps_trigger
AFTER INSERT ON exercise_metrics
DECLARE
    CURSOR CUR_TOTAL_STEPS_PER_USER_PER_DAY IS 
    SELECT 
        sum(steps) as total_steps,
        to_exercise_time,
        sum(calories) as total_calories,
        sum(active_time) as total_active_time,
        user_details_user_id
    FROM 
        exercise_metrics LEFT JOIN exercise_details 
        ON exercise_metrics.exercise_details_exercise_id = exercise_details.exercise_id
    GROUP BY 
        to_exercise_time,
        user_details_user_id
    HAVING
        sum(steps) > 1000;    
BEGIN
    FOR USERS_COMPLETED_DAILY_CHALLENGE IN CUR_TOTAL_STEPS_PER_USER_PER_DAY LOOP
        DBMS_OUTPUT.PUT_LINE('User ' || USERS_COMPLETED_DAILY_CHALLENGE.USER_DETAILS_USER_ID || ' has completed their daily steps ('||USERS_COMPLETED_DAILY_CHALLENGE.total_steps|| ') challenge for Day : ' || USERS_COMPLETED_DAILY_CHALLENGE.to_exercise_time);
    END LOOP;
END;
/


INSERT INTO exercise_metrics (interval, calories, steps, active_time, exercise_details_exercise_id)
VALUES (12, 100, 145, 20, 2023300002);

-- drop trigger max_steps_trigger;
-- drop trigger MAX_CALORIES_TRIGGER; 
-- drop trigger heart_rate_trigger;

-- ALTER TRIGGER max_calorie_trigger DISABLE;

-- select * from user_errors where type = 'TRIGGER' and name = 'NEWALERT';


-- Trigger 2 : MAximum calorie tr
