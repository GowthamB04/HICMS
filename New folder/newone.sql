-- newone.sql
-- Canonical-ordered initialization + seed for `health_db` (based on health_db_initialization.sql)

SET FOREIGN_KEY_CHECKS = 0;

CREATE DATABASE IF NOT EXISTS health_db;
USE health_db;

-- ============================================
-- TABLE: users
-- ============================================
CREATE TABLE IF NOT EXISTS users (
    user_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    date_of_birth DATE NOT NULL,
    address VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL,
    account_status VARCHAR(20) NOT NULL,
    bank_account_number VARCHAR(20),
    ifsc_code VARCHAR(20),
    bank_name VARCHAR(100),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    last_login DATETIME,
    INDEX idx_username (username),
    INDEX idx_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- TABLE: insurance_policies
-- ============================================
CREATE TABLE IF NOT EXISTS insurance_policies (
    policy_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    policy_number VARCHAR(50) UNIQUE NOT NULL,
    policy_name VARCHAR(100) NOT NULL,
    policy_type VARCHAR(50) NOT NULL,
    coverage_amount DOUBLE NOT NULL,
    premium_amount DOUBLE NOT NULL,
    benefits TEXT,
    policy_status VARCHAR(20) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_policy_number (policy_number),
    INDEX idx_policy_status (policy_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- TABLE: user_policies
-- ============================================
CREATE TABLE IF NOT EXISTS user_policies (
    user_policy_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    policy_id BIGINT NOT NULL,
    purchased_date DATE NOT NULL,
    expiry_date DATE NOT NULL,
    policy_active_status VARCHAR(20) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (policy_id) REFERENCES insurance_policies(policy_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_policy_id (policy_id),
    UNIQUE KEY unique_user_policy (user_id, policy_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- TABLE: hospitals
-- ============================================
CREATE TABLE IF NOT EXISTS hospitals (
    hospital_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    hospital_name VARCHAR(100) NOT NULL,
    hospital_type VARCHAR(50) NOT NULL,
    address VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    INDEX idx_hospital_name (hospital_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- TABLE: doctors
-- ============================================
CREATE TABLE IF NOT EXISTS doctors (
    doctor_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    doctor_name VARCHAR(100) NOT NULL,
    specialization VARCHAR(50) NOT NULL,
    qualification VARCHAR(50) NOT NULL,
    experience_years INT NOT NULL,
    hospital_id BIGINT NOT NULL,
    FOREIGN KEY (hospital_id) REFERENCES hospitals(hospital_id) ON DELETE CASCADE,
    INDEX idx_hospital_id (hospital_id),
    INDEX idx_specialization (specialization)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- TABLE: treatments
-- ============================================
CREATE TABLE IF NOT EXISTS treatments (
    treatment_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    diagnosis VARCHAR(100) NOT NULL,
    treatment_description TEXT NOT NULL,
    treatment_amount DOUBLE NOT NULL,
    treatment_date DATE NOT NULL,
    user_id BIGINT NOT NULL,
    doctor_id BIGINT NULL,
    hospital_id BIGINT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE CASCADE,
    FOREIGN KEY (hospital_id) REFERENCES hospitals(hospital_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_doctor_id (doctor_id),
    INDEX idx_hospital_id (hospital_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- TABLE: claims
-- ============================================
CREATE TABLE IF NOT EXISTS claims (
    claim_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    claim_number VARCHAR(50) UNIQUE NOT NULL,
    claim_amount DOUBLE NOT NULL,
    approved_amount DOUBLE DEFAULT 0,
    claim_status VARCHAR(20) NOT NULL,
    approver_comment TEXT,
    rejection_reason TEXT,
    recommendation_status VARCHAR(20),
    recommendation_reason TEXT,
    recommendation_score INT,
    claim_date DATE NOT NULL,
    approved_date DATE,
    rejected_date DATE,
    user_id BIGINT NOT NULL,
    treatment_id BIGINT NOT NULL,
    policy_id BIGINT NOT NULL,
    assigned_approver_id BIGINT,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (treatment_id) REFERENCES treatments(treatment_id) ON DELETE CASCADE,
    FOREIGN KEY (policy_id) REFERENCES insurance_policies(policy_id) ON DELETE CASCADE,
    FOREIGN KEY (assigned_approver_id) REFERENCES users(user_id),
    INDEX idx_claim_number (claim_number),
    INDEX idx_user_id (user_id),
    INDEX idx_claim_status (claim_status),
    INDEX idx_approver_id (assigned_approver_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- TABLE: documents
-- ============================================
CREATE TABLE IF NOT EXISTS documents (
    document_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    document_name VARCHAR(100) NOT NULL,
    document_type VARCHAR(50) NOT NULL,
    document_path VARCHAR(255) NOT NULL,
    uploaded_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    claim_id BIGINT NOT NULL,
    FOREIGN KEY (claim_id) REFERENCES claims(claim_id) ON DELETE CASCADE,
    INDEX idx_claim_id (claim_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- TABLE: payments
-- ============================================
CREATE TABLE IF NOT EXISTS payments (
    payment_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    payment_amount DOUBLE NOT NULL,
    payment_date DATE NOT NULL,
    payment_mode VARCHAR(50) NOT NULL,
    transaction_id VARCHAR(50),
    payment_status VARCHAR(20) NOT NULL,
    company_account_number VARCHAR(20) NOT NULL,
    company_bank_name VARCHAR(100) NOT NULL,
    claim_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    FOREIGN KEY (claim_id) REFERENCES claims(claim_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_claim_id (claim_id),
    INDEX idx_user_id (user_id),
    UNIQUE KEY unique_claim_payment (claim_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- SEED DATA (explicit IDs to keep FK consistency)
-- ============================================

-- USERS (15): 1 admin, 2 approvers, 12 policyholders
INSERT INTO users (user_id, username, password, full_name, email, phone_number, date_of_birth, address, role, account_status, bank_account_number, ifsc_code, bank_name, created_at) VALUES
(1,'administrator','$2a$12$GqS4yfRrKjOZ.Sts3Ydd7.ngD.XUO.gX4xvfYXVhGMiX7/j7XGNrm','Admin User','admin@hicms.com','9876543210','1980-08-15','123 Admin Office Street, New York','ADMIN','ACTIVE',NULL,NULL,NULL,NOW()),
(2,'Approver_01','approverpass','John Approver','approver01@hicms.com','9876543211','1975-05-20','456 Approver Lane, Boston','APPROVER','ACTIVE',NULL,NULL,NULL,NOW()),
(3,'Approver_02','approverpass','Sarah Approver','approver02@hicms.com','9876543212','1978-03-10','789 Reviewer Road, Chicago','APPROVER','ACTIVE',NULL,NULL,NULL,NOW()),
(4,'Draven23','userpass','Draven','draven23@example.com','9000000011','1990-02-23','Addr1','POLICYHOLDER','ACTIVE','1111222233334444','IFSC0001','BankA','2025-01-01'),
(5,'Gowtham40','userpass','Gowtham','gowtham40@example.com','9000000012','1988-07-22','Addr2','POLICYHOLDER','ACTIVE','2222333344445555','IFSC0002','BankB','2025-01-02'),
(6,'angel67','userpass','Angel','angel67@example.com','9000000013','1993-06-17','Addr3','POLICYHOLDER','ACTIVE','3333444455556666','IFSC0003','BankC','2025-01-03'),
(7,'banu12','userpass','Banu','banu12@example.com','9000000014','1991-09-12','Addr4','POLICYHOLDER','ACTIVE','4444555566667777','IFSC0004','BankD','2025-01-04'),
(8,'Sivaranjeni89','userpass','Sivaranjeni','sivaranjeni89@example.com','9000000015','1989-08-28','Addr5','POLICYHOLDER','ACTIVE','5555666677778888','IFSC0005','BankE','2025-01-05'),
(9,'Rajesh17','userpass','Rajesh Kumar','rajesh17@example.com','9000000016','1990-01-17','Addr6','POLICYHOLDER','ACTIVE','6666777788889999','IFSC0006','BankF','2025-01-06'),
(10,'Priya92','userpass','Priya Singh','priya92@example.com','9000000017','1992-02-20','Addr7','POLICYHOLDER','ACTIVE','7777888899990000','IFSC0007','BankG','2025-01-07'),
(11,'Amit88','userpass','Amit Patel','amit88@example.com','9000000018','1988-03-25','Addr8','POLICYHOLDER','ACTIVE','8888999900001111','IFSC0008','BankH','2025-01-08'),
(12,'Neha91','userpass','Neha Gupta','neha91@example.com','9000000019','1991-04-30','Addr9','POLICYHOLDER','ACTIVE','9999000011112222','IFSC0009','BankI','2025-01-09'),
(13,'Manisha86','userpass','Manisha Iyer','manisha86@example.com','9000000020','1986-10-11','Addr10','POLICYHOLDER','ACTIVE','1010101010101010','IFSC0010','BankJ','2025-01-10'),
(14,'Sanjay90','userpass','Sanjay Reddy','sanjay90@example.com','9000000021','1990-11-16','Addr11','POLICYHOLDER','ACTIVE','1212121212121212','IFSC0011','BankK','2025-01-11'),
(15,'Ritika94','userpass','Ritika Chopra','ritika94@example.com','9000000022','1994-12-22','Addr12','POLICYHOLDER','ACTIVE','1313131313131313','IFSC0012','BankL','2025-01-12');

-- ============================================
-- POLICIES (15)
-- ============================================
INSERT INTO insurance_policies (policy_id, policy_number, policy_name, policy_type, coverage_amount, premium_amount, benefits, policy_status, start_date, end_date, created_at, updated_at) VALUES
(1,'POL001','Gold Health Plus','Individual',500000,15000,'Covers hospitalization, surgeries, medications','ACTIVE','2025-03-15','2027-11-20',NOW(),NOW()),
(2,'POL002','Silver Health Basic','Individual',300000,10000,'Basic coverage for hospitalization','ACTIVE','2025-07-01','2027-12-15',NOW(),NOW()),
(3,'POL003','Platinum Health Premium','Family',1000000,30000,'Full coverage for family hospitalization and surgery','ACTIVE','2025-01-05','2026-12-31',NOW(),NOW()),
(4,'POL004','Bronze Health Entry','Individual',200000,5000,'Emergency hospitalization coverage','ACTIVE','2026-04-10','2027-09-30',NOW(),NOW()),
(5,'POL005','Diamond Family Care','Family',1500000,40000,'Premium family health coverage with dental','INACTIVE','2023-06-01','2024-05-31',NOW(),NOW()),
(6,'P-1006','Inactive Plan C','Family',100000,8000,'Old family plan','INACTIVE','2018-01-01','2019-12-31',NOW(),NOW()),
(7,'P-1007','Active Plan D','Individual',60000,5500,'Standard','ACTIVE','2025-01-01','2027-12-31',NOW(),NOW()),
(8,'P-1008','Inactive Plan D','Individual',45000,4000,'Legacy','INACTIVE','2017-01-01','2018-12-31',NOW(),NOW()),
(9,'P-1009','Active Plan E','Individual',70000,6500,'Premium','ACTIVE','2025-01-01','2027-12-31',NOW(),NOW()),
(10,'P-1010','Inactive Plan E','Individual',35000,3200,'Legacy E','INACTIVE','2016-01-01','2017-12-31',NOW(),NOW()),
(11,'P-1011','Active Plan F','Individual',50000,4500,'Single policy F','ACTIVE','2025-01-01','2027-12-31',NOW(),NOW()),
(12,'P-1012','Active Plan G','Individual',55000,4800,'Single policy G','ACTIVE','2025-01-01','2027-12-31',NOW(),NOW()),
(13,'P-1013','Active Plan H','Individual',60000,5200,'Single policy H','ACTIVE','2025-01-01','2027-12-31',NOW(),NOW()),
(14,'P-1014','Active Plan I','Individual',65000,5600,'Single policy I','ACTIVE','2025-01-01','2027-12-31',NOW(),NOW()),
(15,'P-1015','Active Plan J','Individual',70000,6000,'Single policy J','ACTIVE','2025-01-01','2027-12-31',NOW(),NOW());

-- ============================================
-- USER_POLICIES (assignments)
-- ============================================
INSERT INTO user_policies (user_policy_id, user_id, policy_id, purchased_date, expiry_date, policy_active_status) VALUES
(1,4,1,'2025-01-05','2027-12-31','ACTIVE'),
(2,4,2,'2019-06-01','2020-05-31','INACTIVE'),
(3,5,3,'2025-02-01','2027-12-31','ACTIVE'),
(4,5,4,'2018-03-01','2019-02-28','INACTIVE'),
(5,6,5,'2025-03-01','2027-12-31','ACTIVE'),
(6,6,6,'2017-04-01','2018-03-31','INACTIVE'),
(7,7,7,'2025-01-10','2027-12-31','ACTIVE'),
(8,7,8,'2016-05-01','2017-04-30','INACTIVE'),
(9,8,9,'2025-06-01','2027-12-31','ACTIVE'),
(10,8,10,'2015-07-01','2016-06-30','INACTIVE'),
(11,9,11,'2025-01-15','2027-12-31','ACTIVE'),
(12,10,12,'2025-02-20','2027-12-31','ACTIVE'),
(13,11,13,'2025-03-05','2027-12-31','ACTIVE'),
(14,12,14,'2025-04-10','2027-12-31','ACTIVE'),
(15,13,15,'2025-05-12','2027-12-31','ACTIVE');

-- ============================================
-- HOSPITALS
-- ============================================
INSERT INTO hospitals (hospital_id, hospital_name, hospital_type, address, phone_number) VALUES
(1,'Apollo Hospitals','Private','100 Health Street, Mumbai','9111111111'),
(2,'Fortis Healthcare','Private','200 Medical Plaza, Delhi','9122222222'),
(3,'Max Healthcare','Private','300 Care Avenue, Bangalore','9133333333'),
(4,'Government Medical College','Government','400 Public Hospital Road, Pune','9144444444'),
(5,'Medanta - The Medicity','Private','500 Clinical Lane, Gurgaon','9155555555');

-- ============================================
-- DOCTORS
-- ============================================
INSERT INTO doctors (doctor_id, doctor_name, specialization, qualification, experience_years, hospital_id) VALUES
(1,'Dr. Rajesh Kumar','Cardiology','MD',15,1),
(2,'Dr. Priya Sharma','Orthopedics','MBBS',10,1),
(3,'Dr. Amit Singh','Neurology','MD',12,2),
(4,'Dr. Neha Gupta','Gastroenterology','MD',8,2),
(5,'Dr. Vikram Patel','Oncology','MD',18,3),
(6,'Dr. Anjali Verma','Pediatrics','MBBS',7,3),
(7,'Dr. Sanjay Kumar','Orthopedics','MBBS',14,4),
(8,'Dr. Divya Naidu','General Medicine','MBBS',9,5),
(9,'Dr. Karthik Menon','Surgery','MS',16,5),
(10,'Dr. Seema Singh','Cardiology','MD',20,1);

-- ============================================
-- TREATMENTS (20)
-- ============================================
INSERT INTO treatments (treatment_id, diagnosis, treatment_description, treatment_amount, treatment_date, user_id, doctor_id, hospital_id) VALUES
(1,'Appendectomy','Appendix removal',8000,'2025-01-10',4,1,1),
(2,'Consultation','Follow-up',500,'2025-02-12',4,1,1),
(3,'Knee Injury','Knee surgery',45000,'2025-03-05',5,2,1),
(4,'Physiotherapy','Post surgery',2000,'2025-03-20',5,2,1),
(5,'Dermatology','Skin treatment',7000,'2025-01-25',6,3,2),
(6,'Prescription','Medication and tests',300,'2025-02-10',6,3,2),
(7,'ENT','Ear surgery',5000,'2025-02-15',7,4,2),
(8,'Checkup','Routine',250,'2025-03-01',7,4,2),
(9,'Vaccination','Child vaccine',200,'2025-04-10',8,6,3),
(10,'Minor Surgery','Outpatient',1500,'2025-04-20',8,6,3),
(11,'Cardiology','ECG and meds',5000,'2025-05-01',9,1,1),
(12,'Orthopedics','Joint therapy',12000,'2025-05-10',9,2,1),
(13,'Neurology','MRI and consultation',2500,'2025-05-15',10,3,2),
(14,'Gastric','Endoscopy',2500,'2025-05-20',10,4,2),
(15,'Oncology','Chemo session',10000,'2025-06-01',11,5,3),
(16,'Followup','Post chemo',500,'2025-06-10',11,5,3),
(17,'Orthopedic','Fracture repair',120000,'2025-06-15',12,7,4),
(18,'Consult','General consult',300,'2025-06-20',12,8,5),
(19,'Surgery','Appendix',80000,'2025-07-01',13,9,5),
(20,'Cardiac','Bypass related',400000,'2025-07-10',13,10,1);

-- ============================================
-- CLAIMS (20) with statuses per spec
-- 50% SETTLED (10), 30% PENDING (6), 20% REJECTED (4)
-- ============================================
INSERT INTO claims (claim_id, claim_number, claim_amount, approved_amount, claim_status, approver_comment, rejection_reason, recommendation_status, recommendation_reason, recommendation_score, claim_date, approved_date, rejected_date, user_id, treatment_id, policy_id, assigned_approver_id) VALUES
(1,'CL-1781094831001',8000,8000,'APPROVED',NULL,NULL,'APPROVE','Auto',100,'2025-01-12','2025-01-15',NULL,4,1,1,2),
(2,'CL-1781094831002',500,500,'APPROVED',NULL,NULL,'APPROVE','Auto',100,'2025-02-15','2025-02-20',NULL,4,2,1,2),
(3,'CL-1781094831003',45000,45000,'APPROVED',NULL,NULL,'APPROVE','Auto',100,'2025-03-10','2025-03-15',NULL,5,3,3,3),
(4,'CL-1781094831004',2000,2000,'APPROVED',NULL,NULL,'APPROVE','Auto',100,'2025-03-22','2025-03-25',NULL,5,4,3,3),
(5,'CL-1781094831005',7000,7000,'APPROVED',NULL,NULL,'APPROVE','Auto',100,'2025-01-28','2025-02-02',NULL,6,5,5,2),
(6,'CL-1781094831006',300,300,'APPROVED',NULL,NULL,'APPROVE','Auto',100,'2025-02-12','2025-02-14',NULL,6,6,5,2),
(7,'CL-1781094831007',5000,5000,'APPROVED',NULL,NULL,'APPROVE','Auto',100,'2025-02-17','2025-02-20',NULL,7,7,7,3),
(8,'CL-1781094831008',250,250,'APPROVED',NULL,NULL,'APPROVE','Auto',100,'2025-03-02','2025-03-04',NULL,7,8,7,3),
(9,'CL-1781094831009',200,200,'APPROVED',NULL,NULL,'APPROVE','Auto',100,'2025-06-12','2025-06-15',NULL,8,9,9,2),
(10,'CL-1781094831010',1500,1500,'APPROVED',NULL,NULL,'APPROVE','Auto',100,'2025-04-22','2025-04-25',NULL,8,10,9,2),
(11,'CL-1781094831011',5000,NULL,'PENDING',NULL,NULL,'PENDING','Under review',NULL,'2025-05-03',NULL,NULL,9,11,11,2),
(12,'CL-1781094831012',12000,NULL,'PENDING',NULL,NULL,'PENDING','Under review',NULL,'2025-05-12',NULL,NULL,9,12,11,3),
(13,'CL-1781094831013',2500,NULL,'PENDING',NULL,NULL,'PENDING','Under review',NULL,'2025-05-16',NULL,NULL,10,13,12,3),
(14,'CL-1781094831014',2500,NULL,'PENDING',NULL,NULL,'PENDING','Under review',NULL,'2025-05-21',NULL,NULL,10,14,12,2),
(15,'CL-1781094831015',10000,NULL,'PENDING',NULL,NULL,'PENDING','Under review',NULL,'2025-06-03',NULL,NULL,11,15,13,3),
(16,'CL-1781094831016',500,NULL,'PENDING',NULL,NULL,'PENDING','Under review',NULL,'2025-06-11',NULL,NULL,11,16,13,3),
(17,'CL-1781094831017',120000,0,'REJECTED',NULL,'Not covered','REJECT','No cover',10,'2025-06-20',NULL,'2025-06-25',12,17,14,2),
(18,'CL-1781094831018',300,0,'REJECTED',NULL,'No documents','REJECT','Missing docs',5,'2025-06-22',NULL,'2025-06-28',12,18,14,2),
(19,'CL-1781094831019',80000,0,'REJECTED',NULL,'Exceeds limit','REJECT','Limit exceeded',2,'2025-07-02',NULL,'2025-07-06',13,19,15,3),
(20,'CL-1781094831020',400000,0,'REJECTED',NULL,'Policy mismatch','REJECT','Policy mismatch',1,'2025-07-12',NULL,'2025-07-16',13,20,15,3);

-- ============================================
-- PAYMENTS
-- Payments removed from seed: claims previously marked SETTLED
-- have been reverted to APPROVED above. Create payments via
-- the application or run a separate migration when settling claims.
-- ============================================

-- ============================================
-- DOCUMENTS: 4 per claim (80 rows)
-- ============================================
INSERT INTO documents (document_id, document_name, document_type, document_path, uploaded_date, claim_id) VALUES
(1,'MedicalBill_CLM001.pdf','Medical Bill','/documents/claims/CLM001/MedicalBill.pdf',NOW(),1),
(2,'Prescription_CLM001.pdf','Prescription','/documents/claims/CLM001/Prescription.pdf',NOW(),1),
(3,'TreatmentBill_CLM001.pdf','Treatment Bill','/documents/claims/CLM001/TreatmentBill.pdf',NOW(),1),
(4,'HospitalBill_CLM001.pdf','Hospital Bill','/documents/claims/CLM001/HospitalBill.pdf',NOW(),1),
(5,'MedicalBill_CLM002.pdf','Medical Bill','/documents/claims/CLM002/MedicalBill.pdf',NOW(),2),
(6,'Prescription_CLM002.pdf','Prescription','/documents/claims/CLM002/Prescription.pdf',NOW(),2),
(7,'TreatmentBill_CLM002.pdf','Treatment Bill','/documents/claims/CLM002/TreatmentBill.pdf',NOW(),2),
(8,'HospitalBill_CLM002.pdf','Hospital Bill','/documents/claims/CLM002/HospitalBill.pdf',NOW(),2),
(9,'MedicalBill_CLM003.pdf','Medical Bill','/documents/claims/CLM003/MedicalBill.pdf',NOW(),3),
(10,'Prescription_CLM003.pdf','Prescription','/documents/claims/CLM003/Prescription.pdf',NOW(),3),
(11,'TreatmentBill_CLM003.pdf','Treatment Bill','/documents/claims/CLM003/TreatmentBill.pdf',NOW(),3),
(12,'HospitalBill_CLM003.pdf','Hospital Bill','/documents/claims/CLM003/HospitalBill.pdf',NOW(),3),
(13,'MedicalBill_CLM004.pdf','Medical Bill','/documents/claims/CLM004/MedicalBill.pdf',NOW(),4),
(14,'Prescription_CLM004.pdf','Prescription','/documents/claims/CLM004/Prescription.pdf',NOW(),4),
(15,'TreatmentBill_CLM004.pdf','Treatment Bill','/documents/claims/CLM004/TreatmentBill.pdf',NOW(),4),
(16,'HospitalBill_CLM004.pdf','Hospital Bill','/documents/claims/CLM004/HospitalBill.pdf',NOW(),4),
(17,'MedicalBill_CLM005.pdf','Medical Bill','/documents/claims/CLM005/MedicalBill.pdf',NOW(),5),
(18,'Prescription_CLM005.pdf','Prescription','/documents/claims/CLM005/Prescription.pdf',NOW(),5),
(19,'TreatmentBill_CLM005.pdf','Treatment Bill','/documents/claims/CLM005/TreatmentBill.pdf',NOW(),5),
(20,'HospitalBill_CLM005.pdf','Hospital Bill','/documents/claims/CLM005/HospitalBill.pdf',NOW(),5),
(21,'MedicalBill_CLM006.pdf','Medical Bill','/documents/claims/CLM006/MedicalBill.pdf',NOW(),6),
(22,'Prescription_CLM006.pdf','Prescription','/documents/claims/CLM006/Prescription.pdf',NOW(),6),
(23,'TreatmentBill_CLM006.pdf','Treatment Bill','/documents/claims/CLM006/TreatmentBill.pdf',NOW(),6),
(24,'HospitalBill_CLM006.pdf','Hospital Bill','/documents/claims/CLM006/HospitalBill.pdf',NOW(),6),
(25,'MedicalBill_CLM007.pdf','Medical Bill','/documents/claims/CLM007/MedicalBill.pdf',NOW(),7),
(26,'Prescription_CLM007.pdf','Prescription','/documents/claims/CLM007/Prescription.pdf',NOW(),7),
(27,'TreatmentBill_CLM007.pdf','Treatment Bill','/documents/claims/CLM007/TreatmentBill.pdf',NOW(),7),
(28,'HospitalBill_CLM007.pdf','Hospital Bill','/documents/claims/CLM007/HospitalBill.pdf',NOW(),7),
(29,'MedicalBill_CLM008.pdf','Medical Bill','/documents/claims/CLM008/MedicalBill.pdf',NOW(),8),
(30,'Prescription_CLM008.pdf','Prescription','/documents/claims/CLM008/Prescription.pdf',NOW(),8),
(31,'TreatmentBill_CLM008.pdf','Treatment Bill','/documents/claims/CLM008/TreatmentBill.pdf',NOW(),8),
(32,'HospitalBill_CLM008.pdf','Hospital Bill','/documents/claims/CLM008/HospitalBill.pdf',NOW(),8),
(33,'MedicalBill_CLM009.pdf','Medical Bill','/documents/claims/CLM009/MedicalBill.pdf',NOW(),9),
(34,'Prescription_CLM009.pdf','Prescription','/documents/claims/CLM009/Prescription.pdf',NOW(),9),
(35,'TreatmentBill_CLM009.pdf','Treatment Bill','/documents/claims/CLM009/TreatmentBill.pdf',NOW(),9),
(36,'HospitalBill_CLM009.pdf','Hospital Bill','/documents/claims/CLM009/HospitalBill.pdf',NOW(),9),
(37,'MedicalBill_CLM010.pdf','Medical Bill','/documents/claims/CLM010/MedicalBill.pdf',NOW(),10),
(38,'Prescription_CLM010.pdf','Prescription','/documents/claims/CLM010/Prescription.pdf',NOW(),10),
(39,'TreatmentBill_CLM010.pdf','Treatment Bill','/documents/claims/CLM010/TreatmentBill.pdf',NOW(),10),
(40,'HospitalBill_CLM010.pdf','Hospital Bill','/documents/claims/CLM010/HospitalBill.pdf',NOW(),10),
(41,'MedicalBill_CLM011.pdf','Medical Bill','/documents/claims/CLM011/MedicalBill.pdf',NOW(),11),
(42,'Prescription_CLM011.pdf','Prescription','/documents/claims/CLM011/Prescription.pdf',NOW(),11),
(43,'TreatmentBill_CLM011.pdf','Treatment Bill','/documents/claims/CLM011/TreatmentBill.pdf',NOW(),11),
(44,'HospitalBill_CLM011.pdf','Hospital Bill','/documents/claims/CLM011/HospitalBill.pdf',NOW(),11),
(45,'MedicalBill_CLM012.pdf','Medical Bill','/documents/claims/CLM012/MedicalBill.pdf',NOW(),12),
(46,'Prescription_CLM012.pdf','Prescription','/documents/claims/CLM012/Prescription.pdf',NOW(),12),
(47,'TreatmentBill_CLM012.pdf','Treatment Bill','/documents/claims/CLM012/TreatmentBill.pdf',NOW(),12),
(48,'HospitalBill_CLM012.pdf','Hospital Bill','/documents/claims/CLM012/HospitalBill.pdf',NOW(),12),
(49,'MedicalBill_CLM013.pdf','Medical Bill','/documents/claims/CLM013/MedicalBill.pdf',NOW(),13),
(50,'Prescription_CLM013.pdf','Prescription','/documents/claims/CLM013/Prescription.pdf',NOW(),13),
(51,'TreatmentBill_CLM013.pdf','Treatment Bill','/documents/claims/CLM013/TreatmentBill.pdf',NOW(),13),
(52,'HospitalBill_CLM013.pdf','Hospital Bill','/documents/claims/CLM013/HospitalBill.pdf',NOW(),13),
(53,'MedicalBill_CLM014.pdf','Medical Bill','/documents/claims/CLM014/MedicalBill.pdf',NOW(),14),
(54,'Prescription_CLM014.pdf','Prescription','/documents/claims/CLM014/Prescription.pdf',NOW(),14),
(55,'TreatmentBill_CLM014.pdf','Treatment Bill','/documents/claims/CLM014/TreatmentBill.pdf',NOW(),14),
(56,'HospitalBill_CLM014.pdf','Hospital Bill','/documents/claims/CLM014/HospitalBill.pdf',NOW(),14),
(57,'MedicalBill_CLM015.pdf','Medical Bill','/documents/claims/CLM015/MedicalBill.pdf',NOW(),15),
(58,'Prescription_CLM015.pdf','Prescription','/documents/claims/CLM015/Prescription.pdf',NOW(),15),
(59,'TreatmentBill_CLM015.pdf','Treatment Bill','/documents/claims/CLM015/TreatmentBill.pdf',NOW(),15),
(60,'HospitalBill_CLM015.pdf','Hospital Bill','/documents/claims/CLM015/HospitalBill.pdf',NOW(),15),
(61,'MedicalBill_CLM016.pdf','Medical Bill','/documents/claims/CLM016/MedicalBill.pdf',NOW(),16),
(62,'Prescription_CLM016.pdf','Prescription','/documents/claims/CLM016/Prescription.pdf',NOW(),16),
(63,'TreatmentBill_CLM016.pdf','Treatment Bill','/documents/claims/CLM016/TreatmentBill.pdf',NOW(),16),
(64,'HospitalBill_CLM016.pdf','Hospital Bill','/documents/claims/CLM016/HospitalBill.pdf',NOW(),16),
(65,'MedicalBill_CLM017.pdf','Medical Bill','/documents/claims/CLM017/MedicalBill.pdf',NOW(),17),
(66,'Prescription_CLM017.pdf','Prescription','/documents/claims/CLM017/Prescription.pdf',NOW(),17),
(67,'TreatmentBill_CLM017.pdf','Treatment Bill','/documents/claims/CLM017/TreatmentBill.pdf',NOW(),17),
(68,'HospitalBill_CLM017.pdf','Hospital Bill','/documents/claims/CLM017/HospitalBill.pdf',NOW(),17),
(69,'MedicalBill_CLM018.pdf','Medical Bill','/documents/claims/CLM018/MedicalBill.pdf',NOW(),18),
(70,'Prescription_CLM018.pdf','Prescription','/documents/claims/CLM018/Prescription.pdf',NOW(),18),
(71,'TreatmentBill_CLM018.pdf','Treatment Bill','/documents/claims/CLM018/TreatmentBill.pdf',NOW(),18),
(72,'HospitalBill_CLM018.pdf','Hospital Bill','/documents/claims/CLM018/HospitalBill.pdf',NOW(),18),
(73,'MedicalBill_CLM019.pdf','Medical Bill','/documents/claims/CLM019/MedicalBill.pdf',NOW(),19),
(74,'Prescription_CLM019.pdf','Prescription','/documents/claims/CLM019/Prescription.pdf',NOW(),19),
(75,'TreatmentBill_CLM019.pdf','Treatment Bill','/documents/claims/CLM019/TreatmentBill.pdf',NOW(),19),
(76,'HospitalBill_CLM019.pdf','Hospital Bill','/documents/claims/CLM019/HospitalBill.pdf',NOW(),19),
(77,'MedicalBill_CLM020.pdf','Medical Bill','/documents/claims/CLM020/MedicalBill.pdf',NOW(),20),
(78,'Prescription_CLM020.pdf','Prescription','/documents/claims/CLM020/Prescription.pdf',NOW(),20),
(79,'TreatmentBill_CLM020.pdf','Treatment Bill','/documents/claims/CLM020/TreatmentBill.pdf',NOW(),20),
(80,'HospitalBill_CLM020.pdf','Hospital Bill','/documents/claims/CLM020/HospitalBill.pdf',NOW(),20);

SET FOREIGN_KEY_CHECKS = 1;

-- Verify counts (optional)
SELECT COUNT(*) AS users_count FROM users;
SELECT COUNT(*) AS policies_count FROM insurance_policies;
SELECT COUNT(*) AS user_policies_count FROM user_policies;
SELECT COUNT(*) AS hospitals_count FROM hospitals;
SELECT COUNT(*) AS doctors_count FROM doctors;
SELECT COUNT(*) AS treatments_count FROM treatments;
SELECT COUNT(*) AS claims_count FROM claims;
SELECT COUNT(*) AS documents_count FROM documents;
SELECT COUNT(*) AS payments_count FROM payments;
