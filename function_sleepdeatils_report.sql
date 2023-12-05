SET SERVEROUTPUT ON;

CREATE OR REPLACE FUNCTION calculate_sleep_metrics_average(p_sleep_id IN NUMBER) RETURN VARCHAR2 IS
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
END;
/

--ACCEPT sleep_details_sleep_id NUMBER PROMPT 'Enter Sleep Details ID: '

CREATE OR REPLACE PROCEDURE CALL_SLEEP(sleep_details_sleep_id NUMBER)
AS
    v_result VARCHAR2(200);
BEGIN
    v_result := calculate_sleep_metrics_average(sleep_details_sleep_id);
    DBMS_OUTPUT.PUT_LINE('For user  with sleep id (' || sleep_details_sleep_id || ') The report for their sleep is : ');
    IF INSTR(v_result, 'Sleep ID is invalid') > 0 THEN
        DBMS_OUTPUT.PUT_LINE(v_result);
    ELSE
        DBMS_OUTPUT.PUT_LINE(v_result);
    END IF;
END;
/
