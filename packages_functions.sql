CREATE OR REPLACE PACKAGE health_metrics_pkg AS

    FUNCTION GET_EXERCISE_METRICS_FUNC(p_user_id IN NUMBER) RETURN SYS_REFCURSOR;
    
    FUNCTION generate_health_report(p_user_id IN NUMBER) RETURN VARCHAR2;
    
    FUNCTION calculate_sleep_metrics_average(p_sleep_id IN NUMBER) RETURN VARCHAR2;

END health_metrics_pkg;
/

CREATE OR REPLACE PACKAGE BODY health_metrics_pkg AS

    FUNCTION GET_EXERCISE_METRICS_FUNC(p_user_id IN NUMBER) RETURN SYS_REFCURSOR IS
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
    END GET_EXERCISE_METRICS_FUNC;

    FUNCTION generate_health_report(p_user_id IN NUMBER) RETURN VARCHAR2 IS
        v_avg_blood_pressure VARCHAR2(200);
        v_avg_heart_rate     VARCHAR2(50);
        v_user_count         NUMBER;
    BEGIN
        -- Check if the user ID exists in the table
        SELECT COUNT(*)
        INTO v_user_count
        FROM health_details
        WHERE user_details_user_id = p_user_id;

        IF v_user_count > 0 THEN
            -- Calculate average blood pressure (systolic and diastolic)
            SELECT 'Average Blood Pressure: ' || TO_CHAR(AVG(bp_systolic), '999.99') || ' / ' || TO_CHAR(AVG(bp_diastolic), '999.99')
            INTO v_avg_blood_pressure
            FROM health_details
            WHERE user_details_user_id = p_user_id;

            -- Calculate average heart rate
            SELECT 'Average Heart Rate: ' || TO_CHAR(AVG(heart_rate), '999.99')
            INTO v_avg_heart_rate
            FROM health_details
            WHERE user_details_user_id = p_user_id;

            RETURN v_avg_blood_pressure || CHR(10) || v_avg_heart_rate;
        ELSE
            RETURN 'Invalid User ID';
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'An error occurred';
    END generate_health_report;

    FUNCTION calculate_sleep_metrics_average(p_sleep_id IN NUMBER) RETURN VARCHAR2 IS
        v_avg_deep_sleep   NUMBER;
        v_avg_awake        NUMBER;
        v_avg_rem          NUMBER;
        v_avg_light        NUMBER;
        v_sleep_count      NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_sleep_count
        FROM sleep_view
        WHERE sleep_id = p_sleep_id;

        IF v_sleep_count > 0 THEN
            SELECT deep_time, awake_time, rem_time, light_time
            INTO v_avg_deep_sleep, v_avg_awake, v_avg_rem, v_avg_light
            FROM sleep_view 
            WHERE sleep_view.sleep_id = p_sleep_id;

            RETURN 'Average Deep Sleep: ' || TO_CHAR(v_avg_deep_sleep, '999.99') ||
                   CHR(10) || 'Average Awake: ' || TO_CHAR(v_avg_awake, '999.99') ||
                   CHR(10) || 'Average REM: ' || TO_CHAR(v_avg_rem, '999.99') ||
                   CHR(10) || 'Average Light: ' || TO_CHAR(v_avg_light, '999.99');
        ELSE
            RETURN 'Sleep ID is invalid';
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'An error occurred';
    END calculate_sleep_metrics_average;

END health_metrics_pkg;
/
SET SERVEROUTPUT ON;

-- Call GET_EXERCISE_METRICS_FUNC
ACCEPT user_id_prompt NUMBER PROMPT 'Enter User ID: ';

DECLARE
    v_user_id NUMBER := &user_id_prompt;
    v_exercise_result SYS_REFCURSOR;
    v_exercise_id NUMBER;
    v_total_calories NUMBER;
    v_total_steps NUMBER;
    v_total_active_time NUMBER;
BEGIN
    v_exercise_result := health_metrics_pkg.GET_EXERCISE_METRICS_FUNC(v_user_id);

    IF v_exercise_result IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('Exercise Metrics for User ID ' || v_user_id || ':');
        LOOP
            FETCH v_exercise_result INTO v_exercise_id, v_total_calories, v_total_steps, v_total_active_time;
            EXIT WHEN v_exercise_result%NOTFOUND;
            -- Print fetched values
            DBMS_OUTPUT.PUT_LINE('Exercise ID: ' || v_exercise_id || ', Total Calories: ' || v_total_calories || ', Total Steps: ' || v_total_steps || ', Total Active Time: ' || v_total_active_time);
        END LOOP;

        -- Close the cursor
        CLOSE v_exercise_result;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Error retrieving exercise metrics.');
    END IF;
END;
/

-- Call generate_health_report
ACCEPT user_id_prompt NUMBER PROMPT 'Enter User ID: ';

DECLARE
    v_user_id NUMBER := &user_id_prompt;
    v_health_result VARCHAR2(200);
BEGIN
    v_health_result := health_metrics_pkg.generate_health_report(v_user_id);
    DBMS_OUTPUT.PUT_LINE('Health Report for User ID ' || v_user_id || ':');
    DBMS_OUTPUT.PUT_LINE(v_health_result);
END;
/

-- Call calculate_sleep_metrics_average
ACCEPT sleep_id_prompt NUMBER PROMPT 'Enter Sleep ID: ';

DECLARE
    v_sleep_id NUMBER := &sleep_id_prompt;
    v_sleep_result VARCHAR2(200);
BEGIN
    v_sleep_result := health_metrics_pkg.calculate_sleep_metrics_average(v_sleep_id);
    DBMS_OUTPUT.PUT_LINE('Sleep Metrics for Sleep ID ' || v_sleep_id || ':');
    DBMS_OUTPUT.PUT_LINE(v_sleep_result);
END;
/

-- Call calculate_sleep_metrics_average
ACCEPT sleep_id_prompt NUMBER PROMPT 'Enter Sleep ID: ';

DECLARE
    v_sleep_id NUMBER := &sleep_id_prompt;
    v_sleep_result VARCHAR2(200);
BEGIN
    v_sleep_result := health_metrics_pkg.calculate_sleep_metrics_average(v_sleep_id);
    DBMS_OUTPUT.PUT_LINE('Sleep Metrics for Sleep ID ' || v_sleep_id || ':');
    DBMS_OUTPUT.PUT_LINE(v_sleep_result);
END;
/

