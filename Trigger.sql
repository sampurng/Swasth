-- Trigger 1: Generate a trigger when max_steps i.e 10,000 steps per day is reached
SET SERVEROUTPUT ON
/
CREATE OR REPLACE TRIGGER max_steps_trigger
AFTER INSERT ON exercise_metrics
FOR EACH ROW
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
    sum(steps) > 10000;    
BEGIN
    FOR USERS_COMPLETED_DAILY_CHALLENGE IN CUR_TOTAL_STEPS_PER_USER_PER_DAY LOOP
        DBMS_OUTPUT.PUT_LINE('User ' || USERS_COMPLETED_DAILY_CHALLENGE.USER_DETAILS_USER_ID || ' has completed their daily steps ('||USERS_COMPLETED_DAILY_CHALLENGE.total_steps|| ') challenge for Day : ' || USERS_COMPLETED_DAILY_CHALLENGE.to_exercise_time);
    END LOOP;
END;
/


-- INSERT INTO exercise_metrics (interval, calories, steps, active_time, exercise_details_exercise_id)
-- VALUES (11, 100, 20000, 20, 2023300009);

-- Trigger 2: Generate a trigger when max_calories i.e 1000 calories per day is reached
CREATE OR REPLACE TRIGGER max_calorie_trigger
AFTER INSERT ON exercise_metrics
FOR EACH ROW
DECLARE
    CURSOR CUR_TOTAL_CALORIES_PER_USER_PER_DAY IS 
    SELECT 
        SUM(calories) as total_calories,
        to_exercise_time,
        sum(active_time) as total_active_time,
        user_details_user_id
    FROM 
        exercise_metrics LEFT JOIN exercise_details 
        ON exercise_metrics.exercise_details_exercise_id = exercise_details.exercise_id
    GROUP BY 
        to_exercise_time,
        user_details_user_id
    HAVING
        SUM(calories) >= 1000;    
BEGIN
    FOR USERS_COMPLETED_DAILY_CALORIES IN CUR_TOTAL_CALORIES_PER_USER_PER_DAY LOOP
        DBMS_OUTPUT.PUT_LINE('User ' || USERS_COMPLETED_DAILY_CALORIES.USER_DETAILS_USER_ID || ' has reached their daily calorie limit (' || USERS_COMPLETED_DAILY_CALORIES.total_calories || ' calories) for Day : ' || USERS_COMPLETED_DAILY_CALORIES.to_exercise_time);
        -- Your additional actions or procedure calls can be added here
    END LOOP;
END;
/


-- Trigger 3: Generate a trigger when heart_rate is less than 54 and more than 200
CREATE OR REPLACE TRIGGER heart_rate_trigger
BEFORE INSERT ON health_details
FOR EACH ROW
DECLARE
    CURSOR CUR_OUT_OF_RANGE_HEART_RATE IS 
    SELECT 
        heart_rate,
        user_details_user_id
    FROM 
        health_details
    WHERE 
        heart_rate < 54 OR heart_rate > 200;    
BEGIN
    FOR USERS_OUT_OF_RANGE_HEART_RATE IN CUR_OUT_OF_RANGE_HEART_RATE LOOP
        DBMS_OUTPUT.PUT_LINE('User ' || USERS_OUT_OF_RANGE_HEART_RATE.USER_DETAILS_USER_ID || ' has an out-of-range heart rate (' || USERS_OUT_OF_RANGE_HEART_RATE.heart_rate || ')');
        -- Your additional actions or procedure calls can be added here
    END LOOP;
END;
/
