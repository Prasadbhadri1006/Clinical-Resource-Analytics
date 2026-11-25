
-- ==================================================
-- PROJECT: Clinical Resource Analytics
-- STEP 1: Create the database
-- =============================================================================================================================================================

CREATE DATABASE IF NOT EXISTS clinical_resource_analytics;

-- Select the database for this project
USE clinical_resource_analytics;

-- Verify the selected database
SELECT DATABASE();


CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    department_type VARCHAR(50),
    is_active TINYINT
);


SHOW TABLES;

-- =============================================================================================================================================================

-- STEP 2: Create the staff table

USE clinical_resource_analytics;

CREATE TABLE IF NOT EXISTS staff (
    staff_id INT PRIMARY KEY,
    staff_code VARCHAR(20),
    full_name VARCHAR(100) NOT NULL,
    role VARCHAR(50),
    designation VARCHAR(100),
    department_id INT,
    phone VARCHAR(20),
    email VARCHAR(100),
    license_number VARCHAR(50),
    status VARCHAR(30),
    date_joined DATE,
    username VARCHAR(100),

    CONSTRAINT fk_staff_department
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);

DESCRIBE staff;



-- =============================================================================================================================================================
-- Create the patients table


USE clinical_resource_analytics;

CREATE TABLE IF NOT EXISTS patients (
    patient_id INT PRIMARY KEY,
    patient_code VARCHAR(20),
    full_name VARCHAR(100) NOT NULL,
    date_of_birth DATE,
    gender VARCHAR(20),
    phone VARCHAR(20),
    email VARCHAR(100),
    blood_group VARCHAR(10),
    weight_kg DECIMAL(5,2),
    height_cm DECIMAL(5,2),
    registration_date DATE
);




-- =============================================================================================================================================================
-- STEP 4: Create the rooms table
-- ==================================================

USE clinical_resource_analytics;

CREATE TABLE IF NOT EXISTS rooms (
    room_id INT PRIMARY KEY,
    room_number VARCHAR(20),
    room_type VARCHAR(50),
    capacity INT,
    status VARCHAR(30),
    department_id INT,

    CONSTRAINT fk_rooms_department
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);


SHOW TABLES;

DESCRIBE rooms;



-- =============================================================================================================================================================
-- STEP 5: Create the procedures table
-- ==================================================

USE clinical_resource_analytics;

CREATE TABLE IF NOT EXISTS procedures (
    procedure_id INT PRIMARY KEY,
    procedure_name VARCHAR(150) NOT NULL,
    description TEXT,
    department_id INT,
    procedure_cost DECIMAL(12,2),

    CONSTRAINT fk_procedures_department
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);


DESCRIBE procedures;



-- =============================================================================================================================================================
-- STEP 6: Create the lab_tests table
-- ==================================================

USE clinical_resource_analytics;

CREATE TABLE IF NOT EXISTS lab_tests (
    lab_test_id INT PRIMARY KEY,
    test_name VARCHAR(150) NOT NULL,
    description TEXT,
    department_id INT,
    test_cost DECIMAL(12,2),

    CONSTRAINT fk_lab_tests_department
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);

SHOW TABLES;



-- =============================================================================================================================================================
-- STEP 7: Create the medicines table
-- ==================================================

USE clinical_resource_analytics;

CREATE TABLE IF NOT EXISTS medicines (
    medicine_id INT PRIMARY KEY,
    medicine_name VARCHAR(150) NOT NULL,
    generic_name VARCHAR(150),
    category VARCHAR(100),
    unit VARCHAR(30),
    price DECIMAL(10,2),
    quantity INT,
    expiry_date DATE,
    reorder_level INT,
    status VARCHAR(30)
);


DESCRIBE medicines;

SHOW TABLES;


ALTER TABLE patients
    ADD COLUMN national_id VARCHAR(50),
    ADD COLUMN address VARCHAR(255),
    ADD COLUMN city VARCHAR(100);
    
ALTER TABLE rooms
    DROP COLUMN capacity,
    ADD COLUMN bed_number VARCHAR(20),
    ADD COLUMN daily_charge DECIMAL(12,2);
    
ALTER TABLE procedures
    CHANGE COLUMN procedure_cost price DECIMAL(12,2),
    ADD COLUMN duration_minutes INT,
    ADD COLUMN status VARCHAR(30);

ALTER TABLE lab_tests
    CHANGE COLUMN lab_test_id test_id INT,
    CHANGE COLUMN description test_type VARCHAR(100),
    CHANGE COLUMN test_cost price DECIMAL(12,2),
    ADD COLUMN status VARCHAR(30);
    
DESCRIBE patients;
DESCRIBE rooms;
DESCRIBE procedures;
DESCRIBE lab_tests;



-- =============================================================================================================================================================
-- STEP 8: Create the appointments table
-- ==================================================

USE clinical_resource_analytics;

CREATE TABLE IF NOT EXISTS appointments (
    appointment_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    department_id INT,
    appointment_date DATE,
    appointment_time TIME,
    appointment_type VARCHAR(50),
    consultation_type VARCHAR(50),
    patient_type VARCHAR(30),
    severity VARCHAR(30),
    reason_for_visit TEXT,
    diagnosis_notes TEXT,
    status VARCHAR(30),
    created_at DATETIME,

    CONSTRAINT fk_appointments_patient
        FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id),

    CONSTRAINT fk_appointments_doctor
        FOREIGN KEY (doctor_id)
        REFERENCES staff(staff_id),

    CONSTRAINT fk_appointments_department
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);


DESCRIBE appointments;




-- =============================================================================================================================================================
-- STEP 9: Create the admissions table
-- ==================================================

USE clinical_resource_analytics;

CREATE TABLE IF NOT EXISTS admissions (
    admission_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    room_id INT,
    appointment_id INT,
    admit_date DATE,
    discharge_date DATE,
    discharge_summary TEXT,
    status VARCHAR(30),

    CONSTRAINT fk_admissions_patient
        FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id),

    CONSTRAINT fk_admissions_doctor
        FOREIGN KEY (doctor_id)
        REFERENCES staff(staff_id),

    CONSTRAINT fk_admissions_room
        FOREIGN KEY (room_id)
        REFERENCES rooms(room_id),

    CONSTRAINT fk_admissions_appointment
        FOREIGN KEY (appointment_id)
        REFERENCES appointments(appointment_id)
);


DESCRIBE admissions;



-- =============================================================================================================================================================
-- STEP 10: Create the vitals table
-- ==================================================

USE clinical_resource_analytics;

CREATE TABLE IF NOT EXISTS vitals (
    vital_id INT PRIMARY KEY,
    patient_id INT,
    appointment_id INT,
    recorded_at DATETIME,
    temperature DECIMAL(4,1),
    systolic_bp INT,
    diastolic_bp INT,
    pulse_rate INT,
    respiratory_rate INT,
    oxygen_saturation DECIMAL(5,2),
    weight_kg DECIMAL(5,2),
    height_cm DECIMAL(5,2),
    notes TEXT,

    CONSTRAINT fk_vitals_patient
        FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id),

    CONSTRAINT fk_vitals_appointment
        FOREIGN KEY (appointment_id)
        REFERENCES appointments(appointment_id)
);


DESCRIBE vitals;


SELECT COUNT(*) AS total_records
FROM vitals;

DROP TABLE vitals;
CREATE TABLE vitals (
    vital_id INT PRIMARY KEY,
    patient_id INT,
    appointment_id INT,
    admission_id INT,
    blood_pressure VARCHAR(20),
    temperature DECIMAL(4,1),
    pulse INT,
    spo2 DECIMAL(5,2),
    weight_kg DECIMAL(5,2),
    recorded_by INT,
    recorded_at DATETIME,

    CONSTRAINT fk_vitals_patient
        FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id),

    CONSTRAINT fk_vitals_appointment
        FOREIGN KEY (appointment_id)
        REFERENCES appointments(appointment_id),

    CONSTRAINT fk_vitals_admission
        FOREIGN KEY (admission_id)
        REFERENCES admissions(admission_id),

    CONSTRAINT fk_vitals_staff
        FOREIGN KEY (recorded_by)
        REFERENCES staff(staff_id)
);

DESCRIBE vitals;


-- ==================================================
-- STEP 12: Create patient_procedures table
-- ==================================================

USE clinical_resource_analytics;

CREATE TABLE IF NOT EXISTS patient_procedures (
    patient_procedure_id INT PRIMARY KEY,
    patient_id INT,
    procedure_id INT,
    doctor_id INT,
    admission_id INT,
    procedure_date DATETIME,
    quantity INT,
    price DECIMAL(12,2),
    status VARCHAR(30),
    notes TEXT,

    CONSTRAINT fk_patient_procedures_patient
        FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id),

    CONSTRAINT fk_patient_procedures_procedure
        FOREIGN KEY (procedure_id)
        REFERENCES procedures(procedure_id),

    CONSTRAINT fk_patient_procedures_doctor
        FOREIGN KEY (doctor_id)
        REFERENCES staff(staff_id),

    CONSTRAINT fk_patient_procedures_admission
        FOREIGN KEY (admission_id)
        REFERENCES admissions(admission_id)
);


DESCRIBE patient_procedures;

SHOW TABLES;



-- =============================================================================================================================================================
-- STEP 13: Create the lab_orders table
-- ==================================================

USE clinical_resource_analytics;

CREATE TABLE IF NOT EXISTS lab_orders (
    lab_order_id INT PRIMARY KEY,
    patient_id INT,
    appointment_id INT,
    doctor_id INT,
    order_date DATETIME,
    status VARCHAR(30),
    total_amount DECIMAL(12,2),

    CONSTRAINT fk_lab_orders_patient
        FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id),

    CONSTRAINT fk_lab_orders_appointment
        FOREIGN KEY (appointment_id)
        REFERENCES appointments(appointment_id),

    CONSTRAINT fk_lab_orders_doctor
        FOREIGN KEY (doctor_id)
        REFERENCES staff(staff_id)
);

DESCRIBE lab_orders;

SHOW TABLES;



-- =============================================================================================================================================================
-- STEP 14: Create the lab_order_items table
-- ==================================================

USE clinical_resource_analytics;

CREATE TABLE IF NOT EXISTS lab_order_items (
    lab_order_item_id INT PRIMARY KEY,
    lab_order_id INT,
    test_id INT,
    result_value VARCHAR(255),
    result_unit VARCHAR(50),
    reference_range VARCHAR(100),
    result_status VARCHAR(30),
    tested_at DATETIME,

    CONSTRAINT fk_lab_items_order
        FOREIGN KEY (lab_order_id)
        REFERENCES lab_orders(lab_order_id),

    CONSTRAINT fk_lab_items_test
        FOREIGN KEY (test_id)
        REFERENCES lab_tests(test_id)
);

DESCRIBE lab_order_items;

SHOW TABLES;


-- =============================================================================================================================================================
-- STEP 15: Create the prescriptions table
-- ==================================================

USE clinical_resource_analytics;

CREATE TABLE IF NOT EXISTS prescriptions (
    prescription_id INT PRIMARY KEY,
    patient_id INT,
    appointment_id INT,
    doctor_id INT,
    prescription_date DATETIME,
    status VARCHAR(30),
    notes TEXT,

    CONSTRAINT fk_prescriptions_patient
        FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id),

    CONSTRAINT fk_prescriptions_appointment
        FOREIGN KEY (appointment_id)
        REFERENCES appointments(appointment_id),

    CONSTRAINT fk_prescriptions_doctor
        FOREIGN KEY (doctor_id)
        REFERENCES staff(staff_id)
);


DESCRIBE prescriptions;


-- =============================================================================================================================================================
-- STEP 16: Create the prescription_items table
-- ==================================================

USE clinical_resource_analytics;

CREATE TABLE IF NOT EXISTS prescription_items (
    prescription_item_id INT PRIMARY KEY,
    prescription_id INT,
    medicine_id INT,
    dosage VARCHAR(100),
    frequency VARCHAR(100),
    duration_days INT,
    quantity INT,
    instructions TEXT,

    CONSTRAINT fk_prescription_items_prescription
        FOREIGN KEY (prescription_id)
        REFERENCES prescriptions(prescription_id),

    CONSTRAINT fk_prescription_items_medicine
        FOREIGN KEY (medicine_id)
        REFERENCES medicines(medicine_id)
);


DESCRIBE prescription_items;


-- =============================================================================================================================================================
-- STEP 17: Create the invoices table
-- ==================================================

USE clinical_resource_analytics;

CREATE TABLE IF NOT EXISTS invoices (
    invoice_id INT PRIMARY KEY,
    patient_id INT,
    admission_id INT,
    invoice_date DATE,
    due_date DATE,
    subtotal DECIMAL(12,2),
    tax_amount DECIMAL(12,2),
    discount_amount DECIMAL(12,2),
    total_amount DECIMAL(12,2),
    payment_status VARCHAR(30),

    CONSTRAINT fk_invoices_patient
        FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id),

    CONSTRAINT fk_invoices_admission
        FOREIGN KEY (admission_id)
        REFERENCES admissions(admission_id)
);

DESCRIBE invoices;



-- =============================================================================================================================================================
--  Create the invoice_items table
-- ==================================================

USE clinical_resource_analytics;

CREATE TABLE IF NOT EXISTS invoice_items (
    invoice_item_id INT PRIMARY KEY,
    invoice_id INT,
    item_type VARCHAR(50),
    item_id INT,
    description VARCHAR(255),
    quantity INT,
    unit_price DECIMAL(12,2),
    amount DECIMAL(12,2),

    CONSTRAINT fk_invoice_items_invoice
        FOREIGN KEY (invoice_id)
        REFERENCES invoices(invoice_id)
);

SHOW TABLES;
select COUNT(*) AS total_tables
from information_schema.tables
where table_schema = 'clinical_resource_analytics'
  and table_type = 'BASE TABLE';
  
select COUNT(*) AS patient_count FROM patients;

select COUNT(*) AS staff_count FROM staff;

select COUNT(*) AS appointment_count FROM appointments;

select COUNT(*) AS admission_count FROM admissions;

select COUNT(*) AS invoice_count FROM invoices;

show tables;
DESCRIBE invoice_items;
SHOW CREATE TABLE invoice_items;


SELECT
    COLUMN_NAME,
    EXTRA
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'clinical_resource_analytics'
  AND TABLE_NAME = 'invoice_items'
  AND COLUMN_NAME = 'invoice_item_id';


select 'departments' AS table_name, COUNT(*) AS total_rows FROM departments
union all select  'staff', COUNT(*) FROM staff
union all select  'patients', COUNT(*) FROM patients
union all select 'rooms', COUNT(*) FROM rooms
union all select  'procedures', COUNT(*) FROM procedures
union all select  'lab_tests', COUNT(*) FROM lab_tests
union all select  'medicines', COUNT(*) FROM medicines
union all select  'appointments', COUNT(*) FROM appointments
union all select  'admissions', COUNT(*) FROM admissions
union all select  'vitals', COUNT(*) FROM vitals
union all select  'lab_orders', COUNT(*) FROM lab_orders
union all select  'lab_order_items', COUNT(*) FROM lab_order_items
union all select  'prescriptions', COUNT(*) FROM prescriptions
union all select  'prescription_items', COUNT(*) FROM prescription_items
union all select 'patient_procedures', COUNT(*) FROM patient_procedures
union all select  'invoices', COUNT(*) FROM invoices
union all select  'invoice_items', COUNT(*) FROM invoice_items;
-- =============================================================================================================================================================

SELECT
    TABLE_NAME,
    COLUMN_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'clinical_resource_analytics'
  AND REFERENCED_TABLE_NAME IS NOT NULL
ORDER BY TABLE_NAME, COLUMN_NAME;

-- =============================================================================================================================================================
ALTER TABLE invoice_items
MODIFY COLUMN invoice_item_id INT NOT NULL AUTO_INCREMENT;

SELECT COLUMN_NAME, EXTRA
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'clinical_resource_analytics'
  AND TABLE_NAME = 'invoice_items'
  AND COLUMN_NAME = 'invoice_item_id';
  
 -- ============================================================================================================================================================= 
  USE clinical_resource_analytics;

select clinical_resource_analytics;

SELECT 'departments' AS table_name, COUNT(*) AS total_rows FROM departments
UNION ALL SELECT 'staff', COUNT(*) FROM staff
UNION ALL SELECT 'patients', COUNT(*) FROM patients
UNION ALL SELECT 'rooms', COUNT(*) FROM rooms
UNION ALL SELECT 'procedures', COUNT(*) FROM procedures
UNION ALL SELECT 'lab_tests', COUNT(*) FROM lab_tests
UNION ALL SELECT 'medicines', COUNT(*) FROM medicines
UNION ALL SELECT 'appointments', COUNT(*) FROM appointments
UNION ALL SELECT 'admissions', COUNT(*) FROM admissions
UNION ALL SELECT 'vitals', COUNT(*) FROM vitals
UNION ALL SELECT 'lab_orders', COUNT(*) FROM lab_orders
UNION ALL SELECT 'lab_order_items', COUNT(*) FROM lab_order_items
UNION ALL SELECT 'prescriptions', COUNT(*) FROM prescriptions
UNION ALL SELECT 'prescription_items', COUNT(*) FROM prescription_items
UNION ALL SELECT 'patient_procedures', COUNT(*) FROM patient_procedures
UNION ALL SELECT 'invoices', COUNT(*) FROM invoices
UNION ALL SELECT 'invoice_items', COUNT(*) FROM invoice_items;
-- =============================================================================================================================================================
DESCRIBE prescription_items;

USE clinical_resource_analytics;
USE clinical_resource_analytics;

ALTER TABLE prescription_items
MODIFY COLUMN duration_days VARCHAR(50);

DESCRIBE prescription_items;

SELECT 'departments' AS table_name, COUNT(*) AS total_rows FROM departments
UNION ALL SELECT 'staff', COUNT(*) FROM staff
UNION ALL SELECT 'patients', COUNT(*) FROM patients
UNION ALL SELECT 'rooms', COUNT(*) FROM rooms
UNION ALL SELECT 'procedures', COUNT(*) FROM procedures
UNION ALL SELECT 'lab_tests', COUNT(*) FROM lab_tests
UNION ALL SELECT 'medicines', COUNT(*) FROM medicines
UNION ALL SELECT 'appointments', COUNT(*) FROM appointments
UNION ALL SELECT 'admissions', COUNT(*) FROM admissions
UNION ALL SELECT 'vitals', COUNT(*) FROM vitals
UNION ALL SELECT 'lab_orders', COUNT(*) FROM lab_orders
UNION ALL SELECT 'lab_order_items', COUNT(*) FROM lab_order_items
UNION ALL SELECT 'prescriptions', COUNT(*) FROM prescriptions
UNION ALL SELECT 'prescription_items', COUNT(*) FROM prescription_items
UNION ALL SELECT 'patient_procedures', COUNT(*) FROM patient_procedures
UNION ALL SELECT 'invoices', COUNT(*) FROM invoices
UNION ALL SELECT 'invoice_items', COUNT(*) FROM invoice_items;


-- =============================================================================================================================================================

USE clinical_resource_analytics;

SELECT 'departments' AS table_name, COUNT(*) AS total_rows FROM departments
UNION ALL SELECT 'staff', COUNT(*) FROM staff
UNION ALL SELECT 'patients', COUNT(*) FROM patients
UNION ALL SELECT 'rooms', COUNT(*) FROM rooms
UNION ALL SELECT 'procedures', COUNT(*) FROM procedures
UNION ALL SELECT 'lab_tests', COUNT(*) FROM lab_tests
UNION ALL SELECT 'medicines', COUNT(*) FROM medicines
UNION ALL SELECT 'appointments', COUNT(*) FROM appointments
UNION ALL SELECT 'admissions', COUNT(*) FROM admissions
UNION ALL SELECT 'vitals', COUNT(*) FROM vitals
UNION ALL SELECT 'lab_orders', COUNT(*) FROM lab_orders
UNION ALL SELECT 'lab_order_items', COUNT(*) FROM lab_order_items
UNION ALL SELECT 'prescriptions', COUNT(*) FROM prescriptions
UNION ALL SELECT 'prescription_items', COUNT(*) FROM prescription_items
UNION ALL SELECT 'patient_procedures', COUNT(*) FROM patient_procedures
UNION ALL SELECT 'invoices', COUNT(*) FROM invoices
UNION ALL SELECT 'invoice_items', COUNT(*) FROM invoice_items;

-- =============================================================================================================================================================
-- Oueries
-- Display all patient records
SELECT *
FROM patients;

-- SQL Query 2: Filter patients by gender in your Clinical Resource Analytics project.
SELECT *
FROM patients
WHERE gender = 'Female';

-- SQL Query 4: Filter patients by city
SELECT patient_id, full_name, city, phone
FROM patients
WHERE city = 'Bengaluru';


-- SQL Query 5: Count the total number of patients
SELECT COUNT(*) AS total_patients
FROM patients;

-- SQL Query 6: Count patients by gender
SELECT
    gender,
    COUNT(*) AS total_patients
FROM patients
GROUP BY gender;

-- SQL Query 6: Counting patients by gender
SELECT
    city,
    COUNT(*) AS total_patients
FROM patients
GROUP BY city
ORDER BY total_patients DESC;

-- SQL Query 8: Calculate the average patient age
SELECT
    ROUND(
        AVG(TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE())),
        1
    ) AS average_patient_age
FROM patients
WHERE date_of_birth IS NOT NULL;

-- SQL Query 9: Find the youngest and oldest patients
SELECT
    MIN(TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE())) AS youngest_patient_age,
    MAX(TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE())) AS oldest_patient_age
FROM patients
WHERE date_of_birth IS NOT NULL;

-- SQL Query 10 — Appointments by Status

SELECT
    status,
    COUNT(*) AS total_appointments
FROM appointments
GROUP BY status
ORDER BY total_appointments DESC;
-- =============================================================================================================================================================

-- 1. Basic SQL queries
-- Display all patients
SELECT * FROM patients;
-- Filter patients by gender
SELECT patient_id, full_name, gender, city
FROM patients
WHERE gender = 'Female';

-- Sort patients alphabetically
SELECT patient_id, patient_code, full_name, gender, city
FROM patients
ORDER BY full_name ASC;

-- Filter patients by city
SELECT patient_id, full_name, city, phone
FROM patients
WHERE city = 'Chennai';

-- Count total patients
SELECT COUNT(*) AS total_patients
FROM patients;

--  Count patients by gender
SELECT gender, COUNT(*) AS total_patients
FROM patients
GROUP BY gender;

-- Count patients by city
SELECT city, COUNT(*) AS total_patients
FROM patients
GROUP BY city
ORDER BY total_patients DESC;

-- Aggregate functions
SELECT ROUND(
    AVG(TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE())), 1
) AS average_patient_age
FROM patients
WHERE date_of_birth IS NOT NULL;

-- Find youngest and oldest patient ages
SELECT
    MIN(TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE())) AS youngest_age,
    MAX(TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE())) AS oldest_age
FROM patients
WHERE date_of_birth IS NOT NULL;

-- Count appointments by status
SELECT status, COUNT(*) AS total_appointments
FROM appointments
GROUP BY status
ORDER BY total_appointments DESC;

-- Calculate total invoice revenue
SELECT
    COUNT(*) AS total_invoices,
    SUM(total_amount) AS total_invoice_amount,
    AVG(total_amount) AS average_invoice_amount,
    MIN(total_amount) AS minimum_invoice_amount,
    MAX(total_amount) AS maximum_invoice_amount
FROM invoices;
-- =============================================================================================================================================================
-- JOIN operations
-- INNER JOIN — appointments with patient names and doctors
SELECT
    a.appointment_id,
    p.full_name AS patient_name,
    s.full_name AS doctor_name,
    a.appointment_date,
    a.status
FROM appointments a
INNER JOIN patients p
    ON a.patient_id = p.patient_id
INNER JOIN staff s
    ON a.doctor_id = s.staff_id;
    
-- LEFT JOIN — all patients and their appointments
SELECT
    p.patient_id,
    p.full_name,
    a.appointment_id,
    a.appointment_date,
    a.status
FROM patients p
LEFT JOIN appointments a
    ON p.patient_id = a.patient_id
ORDER BY p.patient_id;

-- RIGHT JOIN — all departments and matching staff
SELECT
    d.department_name,
    s.staff_id,
    s.full_name AS staff_name
FROM staff s
RIGHT JOIN departments d
    ON s.department_id = d.department_id;
    
-- Multiple JOINs — patient invoices
SELECT
    i.invoice_id,
    p.full_name AS patient_name,
    i.invoice_date,
    i.total_amount,
    i.payment_status
FROM invoices i
INNER JOIN patients p
    ON i.patient_id = p.patient_id
ORDER BY i.total_amount DESC;

-- Patient admissions with room details
SELECT
    a.admission_id,
    p.full_name AS patient_name,
    r.room_number,
    r.room_type,
    a.admit_date,
    a.discharge_date,
    a.status
FROM admissions a
JOIN patients p
    ON a.patient_id = p.patient_id
JOIN rooms r
    ON a.room_id = r.room_id;
    
-- Laboratory orders with test details
SELECT
    lo.lab_order_id,
    p.full_name AS patient_name,
    lt.test_name,
    loi.result_value,
    loi.result_status,
    loi.tested_at
FROM lab_orders lo
JOIN patients p
    ON lo.patient_id = p.patient_id
JOIN lab_order_items loi
    ON lo.lab_order_id = loi.lab_order_id
JOIN lab_tests lt
    ON loi.test_id = lt.test_id;
    
--  Prescriptions with medicine details
SELECT
    p.full_name AS patient_name,
    pr.prescription_id,
    m.medicine_name,
    pi.dosage,
    pi.frequency,
    pi.duration_days,
    pi.quantity
FROM prescriptions pr
JOIN patients p
    ON pr.patient_id = p.patient_id
JOIN prescription_items pi
    ON pr.prescription_id = pi.prescription_id
JOIN medicines m
    ON pi.medicine_id = m.medicine_id;
    
-- Department-wise appointment count
SELECT
    d.department_name,
    COUNT(a.appointment_id) AS total_appointments
FROM departments d
LEFT JOIN appointments a
    ON d.department_id = a.department_id
GROUP BY d.department_id, d.department_name
ORDER BY total_appointments DESC;

-- Which patients have the highest-value invoices?

SELECT
    i.invoice_id,
    p.full_name AS patient_name,
    i.invoice_date,
    i.total_amount,
    i.payment_status
FROM invoices i
INNER JOIN patients p
    ON i.patient_id = p.patient_id
ORDER BY i.total_amount DESC;

 
-- Which patients are admitted to each room, and what is the current admission status?

SELECT
    a.admission_id,
    p.full_name AS patient_name,
    r.room_number,
    r.room_type,
    r.daily_charge,
    a.admit_date,
    a.discharge_date,
    a.status AS admission_status
FROM admissions a
INNER JOIN patients p
    ON a.patient_id = p.patient_id
INNER JOIN rooms r
    ON a.room_id = r.room_id
ORDER BY a.admit_date DESC;


-- Which medicines are prescribed to patients, and what dosage and quantity have been recorded?

SELECT
    p.patient_id,
    p.full_name AS patient_name,
    pr.prescription_id,
    m.medicine_name,
    pi.dosage,
    pi.frequency,
    pi.duration_days,
    pi.quantity
FROM prescriptions pr
INNER JOIN patients p
    ON pr.patient_id = p.patient_id
INNER JOIN prescription_items pi
    ON pr.prescription_id = pi.prescription_id
INNER JOIN medicines m
    ON pi.medicine_id = m.medicine_id
ORDER BY pr.prescription_date DESC;


-- Which doctors handle the highest number of appointments?

SELECT
    s.staff_id,
    s.full_name AS doctor_name,
    s.designation,
    COUNT(a.appointment_id) AS total_appointments
FROM staff s
INNER JOIN appointments a
    ON s.staff_id = a.doctor_id
GROUP BY
    s.staff_id,
    s.full_name,
    s.designation
ORDER BY total_appointments DESC;


-- Which types of laboratory tests have the highest workload?

SELECT
    lt.test_type,
    COUNT(loi.lab_order_item_id) AS total_tests,
    COUNT(DISTINCT loi.lab_order_id) AS total_lab_orders
FROM lab_tests lt
INNER JOIN lab_order_items loi
    ON lt.test_id = loi.test_id
GROUP BY lt.test_type
ORDER BY total_tests DESC;


-- How much invoice revenue is associated with each department?



SELECT
    d.department_name,
    COUNT(DISTINCT i.invoice_id) AS total_invoices,
    SUM(i.total_amount) AS total_invoice_amount,
    ROUND(AVG(i.total_amount), 2) AS average_invoice_amount
FROM invoices i
INNER JOIN admissions a
    ON i.admission_id = a.admission_id
INNER JOIN rooms r
    ON a.room_id = r.room_id
INNER JOIN departments d
    ON r.department_id = d.department_id
GROUP BY
    d.department_id,
    d.department_name
ORDER BY total_invoice_amount DESC;

-- Which patients have been admitted to the hospital, and how long did they stay?

SELECT
    p.patient_id,
    p.full_name AS patient_name,
    a.admission_id,
    a.admit_date,
    a.discharge_date,
    a.status AS admission_status,
    CASE
        WHEN a.discharge_date IS NOT NULL
        THEN DATEDIFF(a.discharge_date, a.admit_date)
        ELSE DATEDIFF(CURDATE(), a.admit_date)
    END AS length_of_stay_days
FROM patients p
INNER JOIN admissions a
    ON p.patient_id = a.patient_id
ORDER BY length_of_stay_days DESC;

-- Which medicines are available, and which department is associated with each medicine's laboratory or hospital service category?

SELECT
    m.medicine_id,
    m.medicine_name,
    m.quantity AS available_stock,
    m.reorder_level,
    COUNT(pi.prescription_item_id) AS prescription_count
FROM medicines m
LEFT JOIN prescription_items pi
    ON m.medicine_id = pi.medicine_id
GROUP BY
    m.medicine_id,
    m.medicine_name,
    m.quantity,
    m.reorder_level
ORDER BY prescription_count DESC;


-- What are the recorded vital signs for each patient, and when were they measured?

SELECT
    p.patient_id,
    p.full_name AS patient_name,
    v.blood_pressure,
    v.temperature,
    v.pulse,
    v.spo2,
    v.recorded_at,
    s.full_name AS recorded_by_staff
FROM patients p
INNER JOIN vitals v
    ON p.patient_id = v.patient_id
LEFT JOIN staff s
    ON v.recorded_by = s.staff_id
ORDER BY v.recorded_at DESC;


-- How much has been invoiced for each patient, and how many invoices do

SELECT
    p.patient_id,
    p.full_name AS patient_name,
    COUNT(i.invoice_id) AS total_invoices,
    SUM(i.total_amount) AS total_invoice_amount,
    ROUND(AVG(i.total_amount), 2) AS average_invoice_amount
FROM patients p
INNER JOIN invoices i
    ON p.patient_id = i.patient_id
GROUP BY
    p.patient_id,
    p.full_name
ORDER BY total_invoice_amount DESC;


-- How many appointments does each department handle, and how many unique patients visit each department?

SELECT
    d.department_name,
    COUNT(a.appointment_id) AS total_appointments,
    COUNT(DISTINCT a.patient_id) AS unique_patients
FROM departments d
LEFT JOIN appointments a
    ON d.department_id = a.department_id
GROUP BY
    d.department_id,
    d.department_name
ORDER BY total_appointments DESC;


-- How many appointments are completed, pending, or in other statuses within each department?

SELECT
    d.department_name,
    a.status AS appointment_status,
    COUNT(a.appointment_id) AS total_appointments
FROM departments d
LEFT JOIN appointments a
    ON d.department_id = a.department_id
GROUP BY
    d.department_id,
    d.department_name,
    a.status
ORDER BY
    d.department_name,
    total_appointments DESC;



-- What is the total invoice value for each payment status?

SELECT
    payment_status,
    COUNT(*) AS total_invoices,
    SUM(total_amount) AS total_invoice_amount,
    ROUND(AVG(total_amount), 2) AS average_invoice_amount
FROM invoices
GROUP BY payment_status
ORDER BY total_invoice_amount DESC; 



-- Which hospital departments have more than 20 appointments?

SELECT
    d.department_name,
    COUNT(a.appointment_id) AS total_appointments
FROM departments d
INNER JOIN appointments a
    ON d.department_id = a.department_id
GROUP BY
    d.department_id,
    d.department_name
HAVING COUNT(a.appointment_id) > 20

ORDER BY total_appointments DESC;


-- How does the hospital's appointment volume change from month to month?

SELECT
    YEAR(appointment_date) AS appointment_year,
    MONTH(appointment_date) AS appointment_month,
    COUNT(*) AS total_appointments
FROM appointments
GROUP BY
    YEAR(appointment_date),
    MONTH(appointment_date)
ORDER BY
    appointment_year,
    appointment_month;


-- Which patients have visited the hospital most frequently?

SELECT
    p.patient_id,
    p.full_name AS patient_name,
    COUNT(a.appointment_id) AS total_appointments
FROM patients p
INNER JOIN appointments a
    ON p.patient_id = a.patient_id
GROUP BY
    p.patient_id,
    p.full_name
ORDER BY total_appointments DESC
LIMIT 10;


-- Average Invoice Amount by Payment Status
-- How does the average invoice value differ across payment statuses?

SELECT
    payment_status,
    COUNT(*) AS total_invoices,
    ROUND(AVG(total_amount), 2) AS average_invoice_amount,
    SUM(total_amount) AS total_invoice_amount
FROM invoices
GROUP BY payment_status
ORDER BY average_invoice_amount DESC;


-- How does the average invoice value differ across payment statuses?

SELECT
    payment_status,
    COUNT(*) AS total_invoices,
    ROUND(AVG(total_amount), 2) AS average_invoice_amount,
    SUM(total_amount) AS total_invoice_amount
FROM invoices
GROUP BY payment_status
ORDER BY average_invoice_amount DESC;

-- =============================================================================================================================================================
-- Agreegations
-- How many admissions are currently admitted versus discharged?

SELECT
    status AS admission_status,
    COUNT(*) AS total_admissions
FROM admissions
GROUP BY status
ORDER BY total_admissions DESC;


-- What is the average length of stay for discharged patients?

SELECT
    ROUND(AVG(DATEDIFF(discharge_date, admit_date)), 2)
        AS average_stay_days,
    MIN(DATEDIFF(discharge_date, admit_date))
        AS minimum_stay_days,
    MAX(DATEDIFF(discharge_date, admit_date))
        AS maximum_stay_days
FROM admissions
WHERE discharge_date IS NOT NULL
  AND admit_date IS NOT NULL;


-- Identify how many laboratory test items are in each result status to understand pending work and completed testing.
SELECT
    result_status,
    COUNT(*) AS total_test_items
FROM lab_order_items
GROUP BY result_status
ORDER BY total_test_items DESC;


-- Medicine Inventory and Stock Value Analysis
-- Identify which medicine categories have the highest stock value and how much inventory is available.
SELECT
    category,
    SUM(quantity) AS total_units_in_stock,
    ROUND(SUM(quantity * price), 2) AS estimated_stock_value,
    ROUND(AVG(price), 2) AS average_medicine_price
FROM medicines
GROUP BY category
ORDER BY estimated_stock_value DESC;


-- Low-Stock Medicine Analysis
-- Identify medicines whose available stock is at or below their reorder level so the hospital can plan replenishment.
SELECT
    medicine_id,
    medicine_name,
    category,
    quantity AS available_stock,
    reorder_level,
    status
FROM medicines
WHERE quantity <= reorder_level
ORDER BY quantity ASC;


-- Department-Wise Staff Strength
-- Understand how staff members are distributed across hospital departments.
SELECT
    d.department_id,
    d.department_name,
    COUNT(s.staff_id) AS total_staff
FROM departments d
LEFT JOIN staff s
    ON d.department_id = s.department_id
GROUP BY
    d.department_id,
    d.department_name
ORDER BY total_staff DESC;

-- =============================================================================================================================================================
-- Subqueries.
-- 1.Patients Who Have Never Had an Appointment
-- Identify registered patients who have no appointment records in the hospital database.
SELECT
    patient_id,
    full_name,
    phone,
    registration_date
FROM patients
WHERE patient_id NOT IN (
    SELECT patient_id
    FROM appointments
    WHERE patient_id IS NOT NULL
)
ORDER BY full_name;

-- Patients Who Have Never Had an Appointment
-- Identify registered patients who have no appointment records in the hospital database.
SELECT
    patient_id,
    full_name,
    phone,
    registration_date
FROM patients
WHERE patient_id NOT IN (
    SELECT patient_id
    FROM appointments
    WHERE patient_id IS NOT NULL
)
ORDER BY full_name;

-- Doctors Whose Appointment Count Is Above the Average
-- Identify doctors who handle more appointments than the average doctor in your hospital database.
SELECT
    s.staff_id AS doctor_id,
    s.full_name AS doctor_name,
    COUNT(a.appointment_id) AS total_appointments
FROM staff s
JOIN appointments a
    ON s.staff_id = a.doctor_id
GROUP BY
    s.staff_id,
    s.full_name
HAVING COUNT(a.appointment_id) > (
    SELECT AVG(appointment_count)
    FROM (
        SELECT
            doctor_id,
            COUNT(*) AS appointment_count
        FROM appointments
        WHERE doctor_id IS NOT NULL
        GROUP BY doctor_id
    ) AS doctor_summary
)
ORDER BY total_appointments DESC;

-- Patients Who Have Been Admitted to the Hospital
-- Retrieve patients who have at least one hospital admission using a subquery.
SELECT
    patient_id,
    full_name,
    city,
    registration_date
FROM patients
WHERE patient_id IN (
    SELECT patient_id
    FROM admissions
    WHERE patient_id IS NOT NULL
)
ORDER BY full_name;

-- Medicines Priced Above the Average Medicine Price
-- Identify medicines priced higher than the average price across the hospital’s medicine inventory.
SELECT
    medicine_id,
    medicine_name,
    category,
    price
FROM medicines
WHERE price > (
    SELECT AVG(price)
    FROM medicines
)
ORDER BY price DESC;

-- Find Departments With Above-Average Appointment Volume
SELECT
    d.department_id,
    d.department_name,
    COUNT(a.appointment_id) AS total_appointments
FROM departments d
LEFT JOIN appointments a
    ON d.department_id = a.department_id
GROUP BY
    d.department_id,
    d.department_name
HAVING COUNT(a.appointment_id) > (
    SELECT AVG(department_appointments)
    FROM (
        SELECT
            d2.department_id,
            COUNT(a2.appointment_id) AS department_appointments
        FROM departments d2
        LEFT JOIN appointments a2
            ON d2.department_id = a2.department_id
        GROUP BY d2.department_id
    ) AS department_summary
)
ORDER BY total_appointments DESC;


-- =============================================================================================================================================================
-- CTE
-- Calculate appointment volume for each department and display departments with the highest workload first.
WITH DepartmentAppointments AS (
    SELECT
        d.department_id,
        d.department_name,
        COUNT(a.appointment_id) AS total_appointments
    FROM departments d
    LEFT JOIN appointments a
        ON d.department_id = a.department_id
    GROUP BY
        d.department_id,
        d.department_name
)
SELECT
    department_id,
    department_name,
    total_appointments
FROM DepartmentAppointments
ORDER BY total_appointments DESC;


-- Monthly Appointment Trends
-- Analyze monthly appointment volume to understand how demand for hospital services changes over time.
WITH MonthlyAppointments AS (
    SELECT
        DATE_FORMAT(appointment_date, '%Y-%m') AS appointment_month,
        COUNT(*) AS total_appointments
    FROM appointments
    GROUP BY DATE_FORMAT(appointment_date, '%Y-%m')
)
SELECT
    appointment_month,
    total_appointments
FROM MonthlyAppointments
ORDER BY appointment_month;

-- Patient-Wise Total Billing Analysis
-- Calculate each patient’s total billing and rank patients by their total invoice amount.
WITH PatientBilling AS (
    SELECT
        p.patient_id,
        p.full_name,
        COUNT(i.invoice_id) AS total_invoices,
        SUM(i.total_amount) AS total_billing
    FROM patients p
    INNER JOIN invoices i
        ON p.patient_id = i.patient_id
    GROUP BY
        p.patient_id,
        p.full_name
)
SELECT
    patient_id,
    full_name,
    total_invoices,
    ROUND(total_billing, 2) AS total_billing
FROM PatientBilling
ORDER BY total_billing DESC;

-- Doctor-Wise Appointment Workload
-- Calculate how many appointments each doctor handles and identify doctors with at least 10 appointments.
WITH DoctorWorkload AS (
    SELECT
        s.staff_id AS doctor_id,
        s.full_name AS doctor_name,
        COUNT(a.appointment_id) AS total_appointments
    FROM staff s
    INNER JOIN appointments a
        ON s.staff_id = a.doctor_id
    GROUP BY
        s.staff_id,
        s.full_name
)
SELECT
    doctor_id,
    doctor_name,
    total_appointments
FROM DoctorWorkload
WHERE total_appointments >= 10
ORDER BY total_appointments DESC;

-- Laboratory Test Workload by Status
-- Summarize laboratory test items by result status and calculate the total recorded test amount for each status.
WITH LabStatusSummary AS (
    SELECT
        result_status,
        COUNT(*) AS total_test_items,
        COUNT(result_value) AS tests_with_results
    FROM lab_order_items
    GROUP BY result_status
)
SELECT
    result_status,
    total_test_items,
    tests_with_results
FROM LabStatusSummary
ORDER BY total_test_items DESC;

-- Hospital Room Occupancy Analysis
-- Analyze room availability and occupancy by room type to help hospital management plan bed capacity.
WITH RoomSummary AS (
    SELECT
        room_type,
        COUNT(*) AS total_rooms,
        SUM(
            CASE
                WHEN status = 'Occupied' THEN 1
                ELSE 0
            END
        ) AS occupied_rooms,
        SUM(
            CASE
                WHEN status = 'Available' THEN 1
                ELSE 0
            END
        ) AS available_rooms
    FROM rooms
    GROUP BY room_type
)
SELECT
    room_type,
    total_rooms,
    occupied_rooms,
    available_rooms
FROM RoomSummary
ORDER BY occupied_rooms DESC;

-- =============================================================================================================================================================
-- Window Functions
-- Rank Doctors by Appointment Count
-- Rank doctors based on the number of appointments they handle.
WITH DoctorWorkload AS (
    SELECT
        s.staff_id AS doctor_id,
        s.full_name AS doctor_name,
        COUNT(a.appointment_id) AS total_appointments
    FROM staff s
    INNER JOIN appointments a
        ON s.staff_id = a.doctor_id
    GROUP BY
        s.staff_id,
        s.full_name
)
SELECT
    doctor_id,
    doctor_name,
    total_appointments,
    RANK() OVER (
        ORDER BY total_appointments DESC
    ) AS workload_rank
FROM DoctorWorkload
ORDER BY workload_rank;

-- Rank Patients by Total Billing
-- Identify patients with the highest total invoice amounts and rank them for billing analysis.
WITH PatientBilling AS (
    SELECT
        p.patient_id,
        p.full_name,
        SUM(i.total_amount) AS total_billing
    FROM patients p
    INNER JOIN invoices i
        ON p.patient_id = i.patient_id
    GROUP BY
        p.patient_id,
        p.full_name
)
SELECT
    patient_id,
    full_name,
    ROUND(total_billing, 2) AS total_billing,
    DENSE_RANK() OVER (
        ORDER BY total_billing DESC
    ) AS billing_rank
FROM PatientBilling
ORDER BY billing_rank;


-- Rank Medicines by Price Within Each Category
-- Identify the most expensive medicines in each category to support pharmacy purchasing and inventory analysis.
SELECT
    medicine_id,
    medicine_name,
    category,
    price,
    RANK() OVER (
        PARTITION BY category
        ORDER BY price DESC
    ) AS price_rank
FROM medicines
ORDER BY
    category,
    price_rank;
    
    
-- Calculate a Running Total of Monthly Hospital Revenue
-- Track cumulative invoice revenue month by month to understand how billed revenue grows over time.
WITH MonthlyRevenue AS (
    SELECT
        DATE_FORMAT(invoice_date, '%Y-%m') AS invoice_month,
        SUM(total_amount) AS monthly_revenue
    FROM invoices
    GROUP BY DATE_FORMAT(invoice_date, '%Y-%m')
)
SELECT
    invoice_month,
    ROUND(monthly_revenue, 2) AS monthly_revenue,
    ROUND(
        SUM(monthly_revenue) OVER (
            ORDER BY invoice_month
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ),
        2
    ) AS cumulative_revenue
FROM MonthlyRevenue
ORDER BY invoice_month;

-- Compare Each Department’s Appointment Count With the Previous Department
-- Compare appointment volumes across departments to identify differences in service demand.
WITH DepartmentAppointments AS (
    SELECT
        d.department_id,
        d.department_name,
        COUNT(a.appointment_id) AS total_appointments
    FROM departments d
    LEFT JOIN appointments a
        ON d.department_id = a.department_id
    GROUP BY
        d.department_id,
        d.department_name
)
SELECT
    department_id,
    department_name,
    total_appointments,
    LAG(total_appointments) OVER (
        ORDER BY total_appointments DESC
    ) AS previous_department_appointments
FROM DepartmentAppointments
ORDER BY total_appointments DESC;


-- Find the Latest Vital Record for Each Patient
-- Identify each patient’s most recently recorded vital signs for hospital monitoring and reporting.
WITH RankedVitals AS (
    SELECT
        patient_id,
        vital_id,
        blood_pressure,
        temperature,
        pulse,
        spo2,
        recorded_at,
        ROW_NUMBER() OVER (
            PARTITION BY patient_id
            ORDER BY recorded_at DESC, vital_id DESC
        ) AS row_num
    FROM vitals
)
SELECT
    patient_id,
    vital_id,
    blood_pressure,
    temperature,
    pulse,
    spo2,
    recorded_at
FROM RankedVitals
WHERE row_num = 1
ORDER BY patient_id;


-- =============================================================================================================================================================

-- SQL Views.
-- Create a Patient Appointment Summary View
-- Create a reusable SQL view that combines patient details with their appointment information for reporting.
CREATE VIEW vw_patient_appointment_summary AS
SELECT
    p.patient_id,
    p.full_name,
    p.city,
    a.appointment_id,
    a.appointment_date,
    a.appointment_time,
    a.status AS appointment_status,
    a.reason_for_visit
FROM patients p
INNER JOIN appointments a
    ON p.patient_id = a.patient_id;
    
    
SELECT *
FROM vw_patient_appointment_summary
LIMIT 10;

-- Create a Department-Wise Appointment Summary View
-- Create a reusable view showing appointment volume for each hospital department.
CREATE VIEW vw_department_appointment_summary AS
SELECT
    d.department_id,
    d.department_name,
    COUNT(a.appointment_id) AS total_appointments
FROM departments d
LEFT JOIN appointments a
    ON d.department_id = a.department_id
GROUP BY
    d.department_id,
    d.department_name;
    
SELECT *
FROM vw_department_appointment_summary
ORDER BY total_appointments DESC;


-- Create a Patient Billing Summary View
-- Create a reusable view showing each patient’s invoice count and total billed amount.
CREATE VIEW vw_patient_billing_summary AS
SELECT
    p.patient_id,
    p.full_name,
    COUNT(i.invoice_id) AS total_invoices,
    SUM(i.total_amount) AS total_billing
FROM patients p
INNER JOIN invoices i
    ON p.patient_id = i.patient_id
GROUP BY
    p.patient_id,
    p.full_name;
    
SELECT *
FROM vw_patient_billing_summary
ORDER BY total_billing DESC;

-- Create a Doctor Appointment Workload View
-- Create a reusable view showing each doctor’s appointment count.
CREATE VIEW vw_doctor_appointment_workload AS
SELECT
    s.staff_id AS doctor_id,
    s.full_name AS doctor_name,
    COUNT(a.appointment_id) AS total_appointments
FROM staff s
INNER JOIN appointments a
    ON s.staff_id = a.doctor_id
GROUP BY
    s.staff_id,
    s.full_name;
    
SELECT *
FROM vw_doctor_appointment_workload
ORDER BY total_appointments DESC;


-- Create a Laboratory Test Status View
-- Create a reusable view to monitor laboratory test items and whether their results have been recorded.
CREATE VIEW vw_lab_test_status_summary AS
SELECT
    result_status,
    COUNT(*) AS total_test_items,
    COUNT(result_value) AS tests_with_results
FROM lab_order_items
GROUP BY result_status;	

SELECT *
FROM vw_lab_test_status_summary
ORDER BY total_test_items DESC;

-- Create a Hospital Admission Summary View
-- Create a reusable view showing patient admission details, doctor information, room details, and admission status.
CREATE VIEW vw_hospital_admission_summary AS
SELECT
    a.admission_id,
    p.patient_id,
    p.full_name AS patient_name,
    s.full_name AS doctor_name,
    r.room_number,
    r.room_type,
    a.admit_date,
    a.discharge_date,
    a.status AS admission_status
FROM admissions a
INNER JOIN patients p
    ON a.patient_id = p.patient_id
LEFT JOIN staff s
    ON a.doctor_id = s.staff_id
LEFT JOIN rooms r
    ON a.room_id = r.room_id;
    
SELECT *
FROM vw_hospital_admission_summary
ORDER BY admit_date DESC;

-- =============================================================================================================================================================
-- Stored Procedures.
-- Retrieve Patient Details by ID
-- Create a reusable procedure that retrieves a patient’s details using their patient ID.
DELIMITER //

CREATE PROCEDURE GetPatientByID(
    IN p_patient_id INT
)
BEGIN
    SELECT
        patient_id,
        full_name,
        gender,
        phone,
        city,
        registration_date
    FROM patients
    WHERE patient_id = p_patient_id;
END //

DELIMITER ;

CALL GetPatientByID(151);

SELECT
    patient_id,
    full_name
FROM patients
LIMIT 10;

CALL GetPatientByID(1);

-- Retrieve Appointment History for a Patient
-- Create a stored procedure to retrieve a patient's appointment history, including the doctor, department, appointment date, and status.
DELIMITER //

CREATE PROCEDURE GetPatientAppointments(
    IN p_patient_id INT
)
BEGIN
    SELECT
        a.appointment_id,
        p.full_name AS patient_name,
        s.full_name AS doctor_name,
        d.department_name,
        a.appointment_date,
        a.appointment_time,
        a.status AS appointment_status
    FROM appointments a
    JOIN patients p
        ON a.patient_id = p.patient_id
    LEFT JOIN staff s
        ON a.doctor_id = s.staff_id
    LEFT JOIN departments d
        ON a.department_id = d.department_id
    WHERE a.patient_id = p_patient_id
    ORDER BY a.appointment_date DESC;
END //

DELIMITER ;

CALL GetPatientAppointments(1);


-- Create a stored procedure to retrieve admission details for a specific patient, including their assigned doctor, room, admission date, and discharge status.
DELIMITER //

CREATE PROCEDURE GetPatientAdmissions(
    IN p_patient_id INT
)
BEGIN
    SELECT
        a.admission_id,
        p.full_name AS patient_name,
        s.full_name AS doctor_name,
        r.room_number,
        r.room_type,
        a.admit_date,
        a.discharge_date,
        a.status AS admission_status
    FROM admissions a
    INNER JOIN patients p
        ON a.patient_id = p.patient_id
    LEFT JOIN staff s
        ON a.doctor_id = s.staff_id
    LEFT JOIN rooms r
        ON a.room_id = r.room_id
    WHERE a.patient_id = p_patient_id
    ORDER BY a.admit_date DESC;
END //

DELIMITER ;

CALL GetPatientAdmissions(1);



-- Retrieve Invoice Details by Payment Status
DELIMITER //

CREATE PROCEDURE GetInvoicesByStatus(
    IN p_payment_status VARCHAR(50)
)
BEGIN
    SELECT
        invoice_id,
        patient_id,
        admission_id,
        invoice_date,
        due_date,
        subtotal,
        tax_amount,
        discount_amount,
        total_amount,
        payment_status
    FROM invoices
    WHERE payment_status = p_payment_status
    ORDER BY invoice_date DESC;
END //

DELIMITER ;

SELECT DISTINCT payment_status
FROM invoices;

CALL GetInvoicesByStatus('Paid');


-- Retrieve Low-Stock Medicines
-- Create a stored procedure to identify medicines whose available quantity is at or below their reorder level.
DELIMITER //

CREATE PROCEDURE GetLowStockMedicines()
BEGIN
    SELECT
        medicine_id,
        medicine_name,
        category,
        quantity AS available_stock,
        reorder_level,
        status
    FROM medicines
    WHERE quantity <= reorder_level
    ORDER BY quantity ASC;
END //

DELIMITER ;

CALL GetLowStockMedicines();



-- Functons
-- Calculate Patient Age
-- Create a reusable function that calculates a patient's age from their date of birth.
DELIMITER //

CREATE FUNCTION CalculatePatientAge(
    p_date_of_birth DATE
)
RETURNS INT
DETERMINISTIC
NO SQL
BEGIN
    RETURN TIMESTAMPDIFF(
        YEAR,
        p_date_of_birth,
        CURDATE()
    );
END //

DELIMITER ;


SELECT
    patient_id,
    full_name,
    date_of_birth,
    CalculatePatientAge(date_of_birth) AS patient_age
FROM patients
LIMIT 10;

-- Calculate Patient Length of Stay
-- Create a reusable function to calculate how many days a patient stayed in the hospital.
DELIMITER //

CREATE FUNCTION CalculateLengthOfStay(
    p_admit_date DATE,
    p_discharge_date DATE
)
RETURNS INT
DETERMINISTIC
NO SQL
BEGIN
    RETURN DATEDIFF(
        p_discharge_date,
        p_admit_date
    );
END //

DELIMITER ;

SELECT
    admission_id,
    patient_id,
    admit_date,
    discharge_date,
    CalculateLengthOfStay(
        admit_date,
        discharge_date
    ) AS length_of_stay_days
FROM admissions
WHERE discharge_date IS NOT NULL
ORDER BY length_of_stay_days DESC;


-- Calculate the Total Amount of an Invoice
-- Create a reusable function to calculate an invoice amount after applying a discount and adding tax.
DELIMITER //

CREATE FUNCTION CalculateInvoiceTotal(
    p_subtotal DECIMAL(10,2),
    p_tax_amount DECIMAL(10,2),
    p_discount_amount DECIMAL(10,2)
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
NO SQL
BEGIN
    RETURN p_subtotal + p_tax_amount - p_discount_amount;
END //

DELIMITER ;

SELECT
    invoice_id,
    subtotal,
    tax_amount,
    discount_amount,
    total_amount,
    CalculateInvoiceTotal(
        subtotal,
        tax_amount,
        discount_amount
    ) AS calculated_total
FROM invoices
LIMIT 10;

-- Calculate Medicine Stock Value
-- Create a reusable function to calculate the total stock value of a medicine based on its unit price and available quantity.
DELIMITER //

CREATE FUNCTION CalculateMedicineStockValue(
    p_price DECIMAL(10,2),
    p_quantity INT
)
RETURNS DECIMAL(12,2)
DETERMINISTIC
NO SQL
BEGIN
    RETURN p_price * p_quantity;
END //

DELIMITER ;

SELECT 
    medicine_id,
    medicine_name,
    category,
    price,
    quantity,
    CALCULATEMEDICINESTOCKVALUE(price, quantity) AS stock_value
FROM
    medicines
ORDER BY stock_value DESC;


-- Calculate the Patient's Age Group
-- Create a reusable function that categorizes patients into age groups for hospital demographic analysis.
DELIMITER //

CREATE FUNCTION GetPatientAgeGroup(
    p_date_of_birth DATE
)
RETURNS VARCHAR(20)
DETERMINISTIC
NO SQL
BEGIN
    DECLARE patient_age INT;

    SET patient_age = TIMESTAMPDIFF(
        YEAR,
        p_date_of_birth,
        CURDATE()
    );

    RETURN CASE
        WHEN patient_age < 18 THEN 'Child'
        WHEN patient_age < 40 THEN 'Young Adult'
        WHEN patient_age < 60 THEN 'Middle-Aged'
        ELSE 'Senior'
    END;
END //

DELIMITER ;


SELECT
    patient_id,
    full_name,
    date_of_birth,
    GetPatientAgeGroup(date_of_birth) AS age_group
FROM patients
ORDER BY age_group, full_name;


-- Calculate Appointment Waiting Days
-- Create a reusable function to calculate the number of days between an appointment date and today. This helps analyze upcoming appointments and appointment scheduling timelines.
DELIMITER //

CREATE FUNCTION CalculateAppointmentDays(
    p_appointment_date DATE
)
RETURNS INT
DETERMINISTIC
NO SQL
BEGIN
    RETURN DATEDIFF(
        p_appointment_date,
        CURDATE()
    );
END //

DELIMITER ;


SELECT
    appointment_id,
    patient_id,
    appointment_date,
    CalculateAppointmentDays(
        appointment_date
    ) AS days_from_today
FROM appointments
ORDER BY appointment_date;

-- =============================================================================================================================================================
-- Transactions
-- Start a transaction
START TRANSACTION;

-- Update a patient's details temporarily
SELECT patient_id, full_name, city
FROM patients
LIMIT 5;

UPDATE patients
SET city = 'Test City'
WHERE patient_id = YOUR_ID;

SELECT patient_id, full_name, city
FROM patients
LIMIT 5;

UPDATE patients
SET city = 'Test City'
WHERE patient_id = 1;

SELECT patient_id, full_name, city
FROM patients
WHERE patient_id = 1;

ROLLBACK;



-- COMMIT — Save Changes Permanently
-- Goal: Learn how to save changes to a database permanently using COMMIT.
-- Start a transaction
START TRANSACTION;
-- Update a patient's city
UPDATE patients
SET city = 'Test City'
WHERE patient_id = 1;
-- Verify the change'
SELECT patient_id, full_name, city
FROM patients
WHERE patient_id = 1;

COMMIT;


-- Using ROLLBACK to Undo Unwanted Changes
-- Learn how to undo part of a transaction without cancelling every change made during that transaction.
START TRANSACTION;

-- Check a patient's original city
SELECT patient_id, full_name, city
FROM patients
WHERE patient_id = 1;

-- Make a temporary change
UPDATE patients
SET city = 'Temporary City'
WHERE patient_id = 1;

ROLLBACK;
SELECT patient_id, full_name, city
FROM patients
WHERE patient_id = 1;

-- Using SAVEPOINT in a Transaction
START TRANSACTION;
UPDATE patients
SET city = 'Test City 1'
WHERE patient_id = 1;

SAVEPOINT first_update;

UPDATE patients
SET city = 'Test City 2'
WHERE patient_id = 1;

ROLLBACK TO SAVEPOINT first_update;
SELECT patient_id, full_name, city
FROM patients
WHERE patient_id = 1;

ROLLBACK;

-- Check for Duplicate Patient Records
SELECT
    national_id,
    COUNT(*) AS duplicate_count
FROM patients
WHERE national_id IS NOT NULL
GROUP BY national_id
HAVING COUNT(*) > 1;


-- Identify Patients with Missing Data
-- Find patient records where important information, such as name, date of birth, or gender, is missing
SELECT
    patient_id,
    full_name,
    date_of_birth,
    gender,
    phone,
    city
FROM patients
WHERE full_name IS NULL
   OR date_of_birth IS NULL
   OR gender IS NULL
   OR phone IS NULL
   OR city IS NULL;
   

-- Identify Patients with Missing Data
-- Find patient records where important information, such as name, date of birth, or gender, is missing.
SELECT
    patient_id,
    full_name,
    date_of_birth,
    gender,
    phone,
    city
FROM patients
WHERE full_name IS NULL
   OR date_of_birth IS NULL
   OR gender IS NULL
   OR phone IS NULL
   OR city IS NULL;
   
   
   -- Identify Duplicate Appointments
   -- Check whether the same patient has multiple appointments recorded at the same date and time.
   SELECT
    patient_id,
    appointment_date,
    appointment_time,
    COUNT(*) AS appointment_count
FROM appointments
GROUP BY
    patient_id,
    appointment_date,
    appointment_time
HAVING COUNT(*) > 1;

-- Find Appointments Without Valid Patient Records
-- Check whether any appointment references a patient_id that does not exist in the patients table.
SELECT
    a.appointment_id,
    a.patient_id,
    a.appointment_date,
    a.status
FROM appointments AS a
LEFT JOIN patients AS p
    ON a.patient_id = p.patient_id
WHERE p.patient_id IS NULL;

-- Check for Invalid Foreign Key References in Admissions
-- Verify that every admission is linked to an existing patient record.
SELECT
    a.admission_id,
    a.patient_id,
    a.admit_date,
    a.status
FROM admissions AS a
LEFT JOIN patients AS p
    ON a.patient_id = p.patient_id
WHERE p.patient_id IS NULL;


-- Validate Lab Orders Against Patients
-- Check whether every lab order is linked to an existing patient.
SELECT
    lo.lab_order_id,
    lo.patient_id,
    lo.order_date,
    lo.status
FROM lab_orders AS lo
LEFT JOIN patients AS p
    ON lo.patient_id = p.patient_id
WHERE p.patient_id IS NULL;


-- Validate Lab Order Items
-- Check whether every lab order item is linked to an existing lab order
SELECT
    loi.lab_order_item_id,
    loi.lab_order_id,
    loi.test_id,
    loi.result_status
FROM lab_order_items AS loi
LEFT JOIN lab_orders AS lo
    ON loi.lab_order_id = lo.lab_order_id
WHERE lo.lab_order_id IS NULL;



-- Validate Prescription Records Against Patients
-- Check whether every prescription is linked to an existing patient record.
SELECT
    pr.prescription_id,
    pr.patient_id,
    pr.prescription_date,
    pr.status
FROM prescriptions AS pr
LEFT JOIN patients AS p
    ON pr.patient_id = p.patient_id
WHERE p.patient_id IS NULL;


-- Validate Prescription Items Against Prescriptions
-- Check whether every prescription item is linked to an existing prescription.
SELECT
    pi.prescription_item_id,
    pi.prescription_id,
    pi.medicine_id,
    pi.dosage
FROM prescription_items AS pi
LEFT JOIN prescriptions AS pr
    ON pi.prescription_id = pr.prescription_id
WHERE pr.prescription_id IS NULL;


-- Validate Prescription Items Against Medicines
-- Check whether every prescription item references an existing medicine in the medicines table.
SELECT 
    pi.prescription_item_id,
    pi.prescription_id,
    pi.medicine_id,
    pi.dosage
FROM
    prescription_items AS pi
        LEFT JOIN
    medicines AS m ON pi.medicine_id = m.medicine_id
WHERE
    m.medicine_id IS NULL;



-- Validate Patient Procedures Against the Procedures Table
-- Check whether every patient procedure references an existing procedure in the procedures table.
SELECT
    pp.patient_procedure_id,
    pp.patient_id,
    pp.procedure_id,
    pp.procedure_date,
    pp.status
FROM patient_procedures AS pp
LEFT JOIN procedures AS p
    ON pp.procedure_id = p.procedure_id
WHERE p.procedure_id IS NULL;

-- =============================================================================================================================================================
-- Indexes and Query Optimization
-- Learn how to check which indexes already exist on a table.
SHOW INDEX FROM appointments;

SHOW INDEX FROM patients;


-- Create an index on the appointment_date column to help MySQL locate appointments by date more efficiently.
CREATE INDEX idx_appointments_date
ON appointments (appointment_date);

SHOW INDEX FROM appointments;

-- Test
SELECT
    appointment_id,
    patient_id,
    appointment_date,
    status
FROM appointments
WHERE appointment_date = '2026-10-01';

-- Create an index using two columns to help MySQL optimize queries that filter appointments by both department and date.
CREATE INDEX idx_appointments_dept_date
ON appointments (department_id, appointment_date);

SHOW INDEX FROM appointments;

SELECT
    appointment_id,
    patient_id,
    department_id,
    appointment_date,
    status
FROM appointments
WHERE department_id = 1
  AND appointment_date = '2026-10-01';
  
  
  -- Understand Query Performance Using EXPLAIN
  -- Learn how MySQL executes a query and whether it uses an index.
  EXPLAIN
SELECT
    appointment_id,
    patient_id,
    appointment_date,
    status
FROM appointments
WHERE appointment_date = '2026-10-01';

-- Compare how MySQL accesses data when filtering by an indexed column versus a column without a dedicated index.
EXPLAIN
SELECT *
FROM appointments
WHERE appointment_date = '2026-10-01';

EXPLAIN
SELECT *
FROM appointments
WHERE reason_for_visit = 'Fever';

--  Create an Index on patient_id
-- Improve the efficiency of queries that search for patients using their IDs in the appointments table.
CREATE INDEX idx_appointments_patient
ON appointments (patient_id);

SHOW INDEX FROM appointments;
EXPLAIN
SELECT
    appointment_id,
    patient_id,
    appointment_date,
    status
FROM appointments
WHERE patient_id = 10;

-- =============================================================================================================================================================
-- SQL Triggers
-- Create Your First Trigger
-- Automatically record a message whenever a new patient is added to the patients table.
CREATE TABLE patient_audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    action_type VARCHAR(50),
    action_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //

CREATE TRIGGER after_patient_insert
AFTER INSERT ON patients
FOR EACH ROW
BEGIN
    INSERT INTO patient_audit (
        patient_id,
        action_type
    )
    VALUES (
        NEW.patient_id,
        'Patient Registered'
    );
END //

DELIMITER ;

SHOW TRIGGERS;

-- Create an AFTER UPDATE Trigger
-- Automatically record changes when a patient's information is updated.
DELIMITER //

CREATE TRIGGER after_patient_update
AFTER UPDATE ON patients
FOR EACH ROW
BEGIN
    INSERT INTO patient_audit (
        patient_id,
        action_type
    )
    VALUES (
        NEW.patient_id,
        'Patient Updated'
    );
END //

DELIMITER ;
SHOW TRIGGERS;


-- Create a BEFORE INSERT Trigger
-- Prevent a patient record from being inserted if the patient's name is missing or empty.
DELIMITER //

CREATE TRIGGER before_patient_insert
BEFORE INSERT ON patients
FOR EACH ROW
BEGIN
    IF NEW.full_name IS NULL OR TRIM(NEW.full_name) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Patient name cannot be empty';
    END IF;
END //

DELIMITER ;

SHOW TRIGGERS;


-- Create a BEFORE UPDATE Trigger
-- Prevent a patient's name from being changed to NULL, an empty string, or spaces when updating a record.
DELIMITER //

CREATE TRIGGER before_patient_update
BEFORE UPDATE ON patients
FOR EACH ROW
BEGIN
    IF NEW.full_name IS NULL OR TRIM(NEW.full_name) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Patient name cannot be empty';
    END IF;
END //

DELIMITER ;

SHOW TRIGGERS;


-- Create a BEFORE INSERT Trigger to Validate Medicine Prices
-- Prevent a new medicine record from being inserted if its price is zero or negative.
DELIMITER //

CREATE TRIGGER before_medicine_insert
BEFORE INSERT ON medicines
FOR EACH ROW
BEGIN
    IF NEW.price <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Medicine price must be greater than zero';
    END IF;
END //

DELIMITER ;

SHOW TRIGGERS;

-- =============================================================================================================================================================
-- Temporary Tables
-- Create a temporary table to store appointment details for analysis without creating a permanent table.
CREATE TEMPORARY TABLE temp_appointments AS
SELECT
    appointment_id,
    patient_id,
    department_id,
    appointment_date,
    status
FROM appointments;

SELECT *
FROM temp_appointments;

-- =============================================================================================================================================================
-- Filter Data into a Temporary Table
-- Create a temporary table containing only completed appointments for analysis.
CREATE TEMPORARY TABLE temp_completed_appointments AS
SELECT
    appointment_id,
    patient_id,
    department_id,
    appointment_date,
    status
FROM appointments
WHERE status = 'Completed';

SELECT *
FROM temp_completed_appointments;

SELECT *
FROM temp_completed_appointments;

SELECT DISTINCT status
FROM appointments;

-- Calculate Department-Wise Appointment Counts
-- Create a temporary table containing the number of appointments for each department.
CREATE TEMPORARY TABLE temp_department_appointments AS
SELECT
    department_id,
    COUNT(*) AS total_appointments
FROM appointments
GROUP BY department_id;

SELECT *
FROM temp_department_appointments
ORDER BY total_appointments DESC;

-- =============================================================================================================================================================
-- Advanced CASE Statements
-- Classify patients into age groups using the SQL CASE statement.


-- Classify Invoices by Amount
-- Categorize invoices into different billing levels using a CASE statement.
SELECT
    invoice_id,
    patient_id,
    total_amount,
    CASE
        WHEN total_amount < 1000 THEN 'Low Bill'
        WHEN total_amount < 5000 THEN 'Medium Bill'
        WHEN total_amount < 10000 THEN 'High Bill'
        ELSE 'Very High Bill'
    END AS billing_category
FROM invoices
ORDER BY total_amount DESC;


-- Classify Appointments by Severity
-- Categorize appointments based on their severity level using a CASE statement.
SELECT
    appointment_id,
    patient_id,
    severity,
    CASE
        WHEN severity = 'High' THEN 'Priority'
        WHEN severity = 'Medium' THEN 'Moderate Priority'
        WHEN severity = 'Low' THEN 'Routine'
        ELSE 'Not Specified'
    END AS severity_category
FROM appointments
ORDER BY appointment_id;

SELECT DISTINCT severity
FROM appointments;

-- Classify Appointments by Status
-- Use a CASE statement to categorize appointments based on their current status.
SELECT
    appointment_id,
    patient_id,
    appointment_date,
    status,
    CASE
        WHEN LOWER(status) = 'completed' THEN 'Finished'
        WHEN LOWER(status) = 'cancelled' THEN 'Cancelled'
        WHEN LOWER(status) = 'scheduled' THEN 'Upcoming'
        WHEN LOWER(status) = 'pending' THEN 'Awaiting Confirmation'
        ELSE 'Other Status'
    END AS appointment_category
FROM appointments
ORDER BY appointment_date;


-- Advanced Hospital Analytics Queries
-- Identify the Top 10 Patients by Total Billing Amount
USE clinical_resource_analytics;

SELECT
    p.patient_id,
    p.full_name,
    SUM(i.total_amount) AS total_billing_amount
FROM patients p
INNER JOIN invoices i
    ON p.patient_id = i.patient_id
GROUP BY
    p.patient_id,
    p.full_name
ORDER BY total_billing_amount DESC
LIMIT 10;

-- Department-Wise Appointment Analysis
SELECT
    d.department_id,
    d.department_name,
    COUNT(a.appointment_id) AS total_appointments
FROM departments d
INNER JOIN appointments a
    ON d.department_id = a.department_id
GROUP BY
    d.department_id,
    d.department_name
ORDER BY total_appointments DESC;

-- Monthly Hospital Revenue Analysis
SELECT
    YEAR(invoice_date) AS invoice_year,
    MONTH(invoice_date) AS invoice_month,
    MONTHNAME(invoice_date) AS month_name,
    SUM(total_amount) AS total_revenue
FROM invoices
WHERE invoice_date IS NOT NULL
GROUP BY
    YEAR(invoice_date),
    MONTH(invoice_date),
    MONTHNAME(invoice_date)
ORDER BY
    invoice_year,
    invoice_month;
    
    
    -- Analyze Admission Status
    SELECT
    status,
    COUNT(*) AS total_admissions
FROM admissions
GROUP BY status
ORDER BY total_admissions DESC;

-- Identify Patients with Multiple Appointments
SELECT
    p.patient_id,
    p.full_name,
    COUNT(a.appointment_id) AS total_appointments
FROM patients p
INNER JOIN appointments a
    ON p.patient_id = a.patient_id
GROUP BY
    p.patient_id,
    p.full_name
HAVING COUNT(a.appointment_id) > 3
ORDER BY total_appointments DESC;

-- Identify Missing Values in the Patients Table
SELECT
    COUNT(*) AS total_patients,
    SUM(CASE WHEN full_name IS NULL OR TRIM(full_name) = '' THEN 1 ELSE 0 END) AS missing_names,
    SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS missing_dob,
    SUM(CASE WHEN gender IS NULL OR TRIM(gender) = '' THEN 1 ELSE 0 END) AS missing_gender,
    SUM(CASE WHEN phone IS NULL OR TRIM(phone) = '' THEN 1 ELSE 0 END) AS missing_phone,
    SUM(CASE WHEN email IS NULL OR TRIM(email) = '' THEN 1 ELSE 0 END) AS missing_email
FROM patients;


-- Identify Duplicate Patient Records
SELECT
    patient_code,
    COUNT(*) AS duplicate_count
FROM patients
WHERE patient_code IS NOT NULL
GROUP BY patient_code
HAVING COUNT(*) > 1;

-- Find Appointments with Missing Patient IDs
SELECT
    appointment_id,
    patient_id,
    appointment_date,
    status
FROM appointments
WHERE patient_id IS NULL;


SHOW TABLES;

SELECT 'departments' AS table_name, COUNT(*) AS total_rows FROM departments
UNION ALL
SELECT 'staff', COUNT(*) FROM staff
UNION ALL
SELECT 'patients', COUNT(*) FROM patients
UNION ALL
SELECT 'rooms', COUNT(*) FROM rooms
UNION ALL
SELECT 'procedures', COUNT(*) FROM procedures
UNION ALL
SELECT 'lab_tests', COUNT(*) FROM lab_tests
UNION ALL
SELECT 'medicines', COUNT(*) FROM medicines
UNION ALL
SELECT 'appointments', COUNT(*) FROM appointments
UNION ALL
SELECT 'admissions', COUNT(*) FROM admissions
UNION ALL
SELECT 'vitals', COUNT(*) FROM vitals
UNION ALL
SELECT 'lab_orders', COUNT(*) FROM lab_orders
UNION ALL
SELECT 'lab_order_items', COUNT(*) FROM lab_order_items
UNION ALL
SELECT 'prescriptions', COUNT(*) FROM prescriptions
UNION ALL
SELECT 'prescription_items', COUNT(*) FROM prescription_items
UNION ALL
SELECT 'patient_procedures', COUNT(*) FROM patient_procedures
UNION ALL
SELECT 'invoices', COUNT(*) FROM invoices
UNION ALL
SELECT 'invoice_items', COUNT(*) FROM invoice_items;


-- Verifying Primary Keys
USE clinical_resource_analytics;

SELECT
    TABLE_NAME,
    COLUMN_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'clinical_resource_analytics'
  AND REFERENCED_TABLE_NAME IS NOT NULL
ORDER BY TABLE_NAME, COLUMN_NAME;


SELECT
    TABLE_NAME,
    COLUMN_NAME AS primary_key_column,
    CONSTRAINT_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'clinical_resource_analytics'
  AND CONSTRAINT_NAME = 'PRIMARY'
ORDER BY TABLE_NAME;

-- Data Quality Validation
SELECT
    patient_code,
    COUNT(*) AS duplicate_count
FROM patients
WHERE patient_code IS NOT NULL
GROUP BY patient_code
HAVING COUNT(*) > 1;

SELECT
    COUNT(*) AS total_patients,
    SUM(CASE
        WHEN full_name IS NULL OR TRIM(full_name) = ''
        THEN 1 ELSE 0
    END) AS missing_names,
    SUM(CASE
        WHEN date_of_birth IS NULL
        THEN 1 ELSE 0
    END) AS missing_dob,
    SUM(CASE
        WHEN phone IS NULL OR TRIM(phone) = ''
        THEN 1 ELSE 0
    END) AS missing_phone,
    SUM(CASE
        WHEN email IS NULL OR TRIM(email) = ''
        THEN 1 ELSE 0
    END) AS missing_email
FROM patients;


SELECT
    a.appointment_id,
    a.patient_id,
    a.appointment_date
FROM appointments a
LEFT JOIN patients p
    ON a.patient_id = p.patient_id
WHERE a.patient_id IS NOT NULL
  AND p.patient_id IS NULL;
  
  -- Verifying
  SELECT
    TABLE_NAME
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_SCHEMA = 'clinical_resource_analytics';

-- Verify Stored Procedures
SELECT
    ROUTINE_NAME,
    ROUTINE_TYPE
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_SCHEMA = 'clinical_resource_analytics'
  AND ROUTINE_TYPE = 'PROCEDURE'
ORDER BY ROUTINE_NAME;


-- Verify SQL Functions
SELECT
    ROUTINE_NAME,
    ROUTINE_TYPE
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_SCHEMA = 'clinical_resource_analytics'
  AND ROUTINE_TYPE = 'FUNCTION'
ORDER BY ROUTINE_NAME;


-- Verify triggers
SELECT
    TRIGGER_NAME,
    EVENT_MANIPULATION,
    EVENT_OBJECT_TABLE,
    ACTION_TIMING
FROM INFORMATION_SCHEMA.TRIGGERS
WHERE TRIGGER_SCHEMA = 'clinical_resource_analytics'
ORDER BY EVENT_OBJECT_TABLE, TRIGGER_NAME;
-- =============================================================================================================================================================

-- Check indexes.
SELECT
    TABLE_NAME,
    INDEX_NAME,
    COLUMN_NAME,
    NON_UNIQUE
FROM INFORMATION_SCHEMA.STATISTICS
WHERE TABLE_SCHEMA = 'clinical_resource_analytics'
ORDER BY TABLE_NAME, INDEX_NAME, SEQ_IN_INDEX;
-- =============================================================================================================================================================
-- Check Indexes
SELECT
    TABLE_NAME,
    INDEX_NAME,
    COLUMN_NAME,
    NON_UNIQUE
FROM INFORMATION_SCHEMA.STATISTICS
WHERE TABLE_SCHEMA = 'clinical_resource_analytics'
ORDER BY TABLE_NAME, INDEX_NAME, SEQ_IN_INDEX;

-- Verify SQL Views
USE clinical_resource_analytics;

SELECT * FROM vw_department_appointment_summary;

-- =============================================================================================================================================================
-- Verify the Patient Appointment Summary View
SELECT *
FROM vw_patient_appointment_summary;


SELECT *
FROM vw_hospital_admission_summary;


SELECT *
FROM vw_doctor_appointment_workload;


SELECT *
FROM vw_lab_test_status_summary;

SELECT *
FROM vw_patient_billing_summary;

CALL GetPatientByID(1);

show tables;

-- =============================================================================================================================================================