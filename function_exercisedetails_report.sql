SET SERVEROUTPUT ON;

CREATE OR REPLACE FUNCTION GET_EXERCISE_METRICS_FUNC(
    p_user_id IN NUMBER
) RETURN SYS_REFCURSOR
IS
    my_cursor SYS_REFCURSOR;
    v_user_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_user_count
    FROM exercise_details
    WHERE user_details_user_id = p_user_id;

    IF v_user_count > 0 THEN
        OPEN my_cursor FOR
        SELECT
            exercise_id,
            total_calories, 
            total_steps, 
            total_active_time
        FROM daily_goals_view 
        WHERE user_details_user_id = p_user_id 
        AND exercise_id IS NOT NULL;
        RETURN my_cursor;
    ELSE
        DBMS_OUTPUT.PUT_LINE('User ID is not valid or does not exist');
        RETURN NULL;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred');
        RETURN NULL;
END;
/

ACCEPT user_id_prompt NUMBER PROMPT 'Enter User ID: ';

DECLARE
    v_user_id NUMBER := &user_id_prompt;
    v_result SYS_REFCURSOR;
    v_exercise_id NUMBER;
    v_total_calories NUMBER;
    v_total_steps NUMBER;
    v_total_active_time NUMBER;
BEGIN
    v_result := GET_EXERCISE_METRICS_FUNC(v_user_id);

    IF v_result IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('Exercise Metrics for User ID ' || v_user_id || ':');
        LOOP
            FETCH v_result INTO v_exercise_id, v_total_calories, v_total_steps, v_total_active_time;
            EXIT WHEN v_result%NOTFOUND;
            -- Print fetched values
            DBMS_OUTPUT.PUT_LINE('Exercise ID: ' || v_exercise_id || ', Average heart Rate: ' || v_total_calories || ', Steps: ' || v_total_steps || ', Active Time: ' || v_total_active_time);
        END LOOP;

        -- Close the cursor
        CLOSE v_result;
    END IF;
END;
/
