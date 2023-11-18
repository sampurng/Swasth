
-- Health Progress View --
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
SELECT * From exercise_metrics;
SELECT * from health_details;

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
            ROUND(AVG(BP_DIASTOLIC),2) as avg_bp_dias, 
        FROM HEALTH_DETAILS 
        GROUP BY health_details.exercise_details_exercise_id
        ORDER BY exercise_id) exercise_group 
    LEFT JOIN exercise_details ON exercise_group.exercise_id = exercise_details.exercise_id;