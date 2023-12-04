SET SERVEROUTPUT ON;

-- Create the function to fetch exercise metrics based on user ID
CREATE OR REPLACE FUNCTION GET_EXERCISE_METRICS_FUNC(
    p_user_id IN NUMBER
) RETURN SYS_REFCURSOR
IS
    my_cursor SYS_REFCURSOR;
BEGIN
    OPEN my_cursor FOR
    SELECT 
        ed.exercise_id AS exercise_id,
        SUM(em.calories) AS total_calories,
        SUM(em.steps) AS total_steps,
        SUM(em.active_time) AS total_active_time
    FROM exercise_metrics em
    JOIN exercise_details ed ON em.exercise_details_exercise_id = ed.exercise_id
    WHERE ed.user_details_user_id = p_user_id
    GROUP BY ed.exercise_id;

    RETURN my_cursor;
END;
/

-- Prompt for user ID
ACCEPT user_id_prompt NUMBER PROMPT 'Enter User ID: ';

-- Execute the PL/SQL block to fetch exercise metrics based on the user ID
DECLARE
    v_user_id NUMBER := &user_id_prompt;
    v_result SYS_REFCURSOR;
    v_exercise_id NUMBER;
    v_total_calories NUMBER;
    v_total_steps NUMBER;
    v_total_active_time NUMBER;
BEGIN
    v_result := GET_EXERCISE_METRICS_FUNC(v_user_id);

    -- Process the results: Fetch and print exercise metrics
    DBMS_OUTPUT.PUT_LINE('Exercise Metrics for User ID ' || v_user_id || ':');
    LOOP
        FETCH v_result INTO v_exercise_id, v_total_calories, v_total_steps, v_total_active_time;
        EXIT WHEN v_result%NOTFOUND;
        -- Print fetched values
        DBMS_OUTPUT.PUT_LINE('Exercise ID: ' || v_exercise_id || ', Calories: ' || v_total_calories || ', Steps: ' || v_total_steps || ', Active Time: ' || v_total_active_time);
    END LOOP;

    -- Close the cursor
    CLOSE v_result;
END;
/
