-- =====================================================
-- Healthcare Analytics using SQL
-- GUVI Zen Class Mini Project
-- =====================================================

CREATE DATABASE healthcare_db;
USE healthcare_db;

-- =====================================================
-- TASK 1
-- Retrieve all completed appointments with patient and
-- doctor details.
-- =====================================================

SELECT
    p.name AS patient_name,
    d.name AS doctor_name,
    d.specialization,
    a.appointment_date
FROM appointments a
INNER JOIN patients p
    ON a.patient_id = p.patient_id
INNER JOIN doctors d
    ON a.doctor_id = d.doctor_id
WHERE a.status = 'Completed'
ORDER BY a.appointment_date DESC;

-- =====================================================
-- TASK 2
-- Find patients who never had an appointment.
-- =====================================================

SELECT
    p.name,
    p.contact_number,
    p.address
FROM patients p
LEFT JOIN appointments a
    ON p.patient_id = a.patient_id
WHERE a.patient_id IS NULL;

-- =====================================================
-- TASK 3
-- Count diagnoses handled by each doctor.
-- =====================================================

SELECT
    d.name,
    d.specialization,
    COUNT(di.diagnosis_id) AS total_diagnoses
FROM doctors d
LEFT JOIN diagnoses di
    ON d.doctor_id = di.doctor_id
GROUP BY d.doctor_id,
         d.name,
         d.specialization
ORDER BY total_diagnoses DESC;

-- =====================================================
-- TASK 4
-- Find unmatched records between appointments
-- and diagnoses.
-- =====================================================

SELECT
    a.patient_id,
    a.doctor_id,
    a.appointment_date,
    di.diagnosis
FROM appointments a
LEFT JOIN diagnoses di
    ON a.patient_id = di.patient_id
    AND a.doctor_id = di.doctor_id

UNION

SELECT
    a.patient_id,
    a.doctor_id,
    a.appointment_date,
    di.diagnosis
FROM appointments a
RIGHT JOIN diagnoses di
    ON a.patient_id = di.patient_id
    AND a.doctor_id = di.doctor_id;

-- =====================================================
-- TASK 5
-- Rank patients based on visit frequency
-- for each doctor.
-- =====================================================

SELECT
    doctor_id,
    patient_id,
    COUNT(*) AS total_visits,

    RANK() OVER (
        PARTITION BY doctor_id
        ORDER BY COUNT(*) DESC
    ) AS patient_rank

FROM appointments

GROUP BY
    doctor_id,
    patient_id;

-- =====================================================
-- TASK 6
-- Categorize patients into age groups.
-- =====================================================

SELECT

    CASE
        WHEN age BETWEEN 18 AND 30 THEN '18-30'
        WHEN age BETWEEN 31 AND 50 THEN '31-50'
        ELSE '51+'
    END AS age_group,

    COUNT(*) AS total_patients

FROM patients

GROUP BY age_group;

-- =====================================================
-- TASK 7
-- Find patients whose contact number ends with 1234.
-- =====================================================

SELECT
    UPPER(name) AS patient_name,
    contact_number
FROM patients
WHERE contact_number LIKE '%1234';

-- =====================================================
-- TASK 8
-- Find patients prescribed only Insulin.
-- =====================================================

SELECT DISTINCT
    d.patient_id

FROM diagnoses d

JOIN medications m
    ON d.diagnosis_id = m.diagnosis_id

WHERE m.medication_name = 'Insulin';

-- =====================================================
-- TASK 9
-- Average medication duration by diagnosis.
-- =====================================================

SELECT
    diagnosis_id,

    AVG(
        ABS(
            DATEDIFF(end_date, start_date)
        )
    ) AS avg_duration_days

FROM medications

GROUP BY diagnosis_id

ORDER BY avg_duration_days DESC;

-- =====================================================
-- TASK 10
-- Doctor treating the highest number
-- of unique patients.
-- =====================================================

SELECT
    d.name,
    d.specialization,

    COUNT(
        DISTINCT a.patient_id
    ) AS total_patients

FROM doctors d

JOIN appointments a
    ON d.doctor_id = a.doctor_id

GROUP BY
    d.doctor_id,
    d.name,
    d.specialization

ORDER BY total_patients DESC

LIMIT 1;

-- =====================================================
-- END OF PROJECT
-- =====================================================