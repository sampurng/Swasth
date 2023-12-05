CREATE OR REPLACE FUNCTION generate_health_report(p_user_id IN NUMBER) RETURN VARCHAR2 IS
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
END;
/
--ACCEPT user_id_prompt NUMBER PROMPT 'Enter User ID: '

CREATE OR REPLACE PROCEDURE CALL_HEALTH(user_id_prompt NUMBER) 
AS
    v_result VARCHAR2(200);
BEGIN
    v_result := generate_health_report(user_id_prompt);
    DBMS_OUTPUT.PUT_LINE(v_result);
END;
/



