-- Trigger 1: Generate a trigger when max_steps i.e 10,000 steps per day is reached
CREATE OR REPLACE TRIGGER max_steps_trigger
AFTER INSERT ON exercise_metrics
FOR EACH ROW
DECLARE
    total_steps NUMBER;
BEGIN
    SELECT SUM(steps)
    INTO total_steps
    FROM exercise_metrics em
    WHERE em.user_details_user_id = :NEW.user_details_user_id
      AND TRUNC(em.from_exercise_time) = TRUNC(SYSDATE);

    IF total_steps >= 10000 THEN
        -- Your action when max steps are reached goes here
        DBMS_OUTPUT.PUT_LINE('Max steps reached for the day!');
        -- You can add more actions or call a procedure here
    END IF;
END;
/

-- Trigger 2: Generate a trigger when max_calories i.e 1000 calories per day is reached
CREATE OR REPLACE TRIGGER max_calories_trigger
AFTER INSERT ON exercise_metrics
FOR EACH ROW
DECLARE
    total_calories NUMBER;
BEGIN
    SELECT SUM(calories)
    INTO total_calories
    FROM exercise_metrics em
    WHERE em.user_details_user_id = :NEW.user_details_user_id
      AND TRUNC(em.from_exercise_time) = TRUNC(SYSDATE);

    IF total_calories >= 1000 THEN
        -- Your action when max calories are reached goes here
        DBMS_OUTPUT.PUT_LINE('Max calories reached for the day!');
        -- You can add more actions or call a procedure here
    END IF;
END;
/

-- Trigger 3: Generate a trigger when heart_rate is less than 54 and more than 200
CREATE OR REPLACE TRIGGER heart_rate_trigger
BEFORE INSERT ON health_details
FOR EACH ROW
DECLARE
    heart_rate_value NUMBER;
BEGIN
    heart_rate_value := :NEW.heart_rate;

    IF heart_rate_value < 54 OR heart_rate_value > 200 THEN
        -- Your action when heart rate is out of range goes here
        DBMS_OUTPUT.PUT_LINE('Heart rate out of range!');
        -- You can add more actions or call a procedure here
    END IF;
END;
/

