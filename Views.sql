
-- Health Progress View --
CREATE OR REPLACE VIEW health_progress_view AS 
SELECT 
    user_details.user_id, 
    user_details.age, 
    body_composition.height, 
    body_composition.weight, 
    body_composition.skeletal_muscle_mass, 
    body_composition.fat_mass,
    body_composition.body_fat,
    body_composition.body_water, 
    CASE
        WHEN user_details.sex = 'M' THEN ROUND((10*body_composition.weight + 6.35*body_composition.height - 5*user_details.age) + 5, 2)
        WHEN user_details.sex = 'F' THEN ROUND((10*body_composition.weight + 6.35*body_composition.height - 5*user_details.age) - 161, 2)
    END 
    as BMR, 
    ROUND(body_composition.weight/( body_composition.height/100 * body_composition.height/100), 2) as BMI
FROM user_details LEFT JOIN body_composition ON user_details.user_id = body_composition.user_details_user_id;

-- Exercise View --
CREATE OR REPLACE VIEW exercise_view AS
SELECT 
    exercise_group.exercise_id, 
    exercise_group.avg_blood_oxygen,
    exercise_group.avg_heart_rate,
    exercise_group.avg_bp_sys,
    exercise_group.avg_bp_dias,
    abs(exercise_details.from_exercise_time -  exercise_details.to_exercise_time) as exercise_duration
    FROM (
        SELECT 
            exercise_details_exercise_id as exercise_id, 
            ROUND(AVG(HEART_RATE),2) as avg_heart_rate, 
            ROUND(AVG(BLOOD_OXYGEN),2) as avg_blood_oxygen, 
            ROUND(AVG(BP_SYSTOLIC), 2) as avg_bp_sys, 
            ROUND(AVG(BP_DIASTOLIC),2) as avg_bp_dias 
        FROM HEALTH_DETAILS 
        GROUP BY health_details.exercise_details_exercise_id
        ORDER BY exercise_id) exercise_group 
    LEFT JOIN exercise_details ON exercise_group.exercise_id = exercise_details.exercise_id;    
    
-- Activities View for 100,000 steps per month sorted by suer with rank
CREATE OR REPLACE VIEW activities_view AS 
SELECT 
activities_group.total_steps, 
activities_group.user_id, 
activities_group.rank, activities_group.month_name, 
activities_group.total_steps/10000 as Progress 
FROM (SELECT 
    sum(exercise_metrics.steps) as total_steps, 
    exercise_details.user_details_user_id as User_ID, 
    dense_rank() over(order by sum(exercise_metrics.steps) desc) as Rank, 
    TO_CHAR(SYSDATE, 'MON') as MONTH_NAME FROM exercise_details
LEFT JOIN exercise_metrics on exercise_details.exercise_id = exercise_metrics.exercise_details_exercise_id 
GROUP BY exercise_details.user_details_user_id) activities_group
ORDER BY activities_group.rank;

-- Sleep View 
CREATE OR REPLACE VIEW sleep_view AS 
SELECT * FROM  
(
    SELECT 
    SUM(REM) as rem_time,
    SUM(DEEP_SLEEP) as deep_time, 
    SUM(LIGHT) as light_time, 
    SUM(AWAKE) as awake_time, 
    sleep_details.sleep_id as sleep_id1
    FROM sleep_details left join sleep_metrics on sleep_id1 = sleep_metrics.sleep_details_sleep_id
    GRoUP BY sleep_details.sleep_id
) sleep_group 
LEFT JOIN 
(
    SELECT 
    ROUND(AVG(heart_rate), 2) as avg_hr, 
    ROUND(avg(blood_oxygen), 2) as avg_bo, 
    ROUND(avg(BP_SYSTOLIC), 2) as avg_bps, 
    ROUND(avg(BP_DIASTOLIC), 2)as avg_bpd, 
    health_details.user_details_user_id as user_id,
    health_details.sleep_details_SLEEP_ID as sleep_id2
    FROM health_details 
    GROUP BY health_details.sleep_details_SLEEP_ID, health_details.user_details_user_id
) sleep_health on sleep_health.sleep_id2 = sleep_group.sleep_id1;


-- User master view
CREATE OR REPLACE VIEW user_overview AS
SELECT 
    user_details.user_id, 
    user_details.first_name, 
    user_details.last_name,
    user_details.email,
    exercise_details.exercise_id,
    exercise_details.type,
    exercise_details.from_exercise_time,
    exercise_details.to_exercise_time,
    exercise_metrics.interval, 
    exercise_metrics.calories, 
    exercise_metrics.steps, 
    exercise_metrics.active_time, 
    sleep_details.sleep_id, 
    sleep_details.from_sleep_time, 
    sleep_details.to_sleep_time, 
    sleep_metrics.sleep_cycle, 
    sleep_metrics.deep_sleep, 
    sleep_metrics.awake, 
    sleep_metrics.rem, 
    sleep_metrics.light, 
    health_details.time_of_activity, 
    health_details.blood_oxygen, 
    health_details.ecg, 
    health_details.bp_systolic, 
    health_details.bp_diastolic
FROM user_details 
    JOIN exercise_details ON user_details.user_id = exercise_details.user_details_user_id 
    JOIN exercise_metrics on exercise_details.exercise_id = exercise_metrics.exercise_details_exercise_id
    JOIN sleep_details ON user_details.user_Id = sleep_details.user_details_user_id
    JOIN sleep_metrics ON sleep_details.sleep_id = sleep_metrics.sleep_details_sleep_id
    JOIN health_details ON health_details.user_details_user_id = user_details.user_id;
