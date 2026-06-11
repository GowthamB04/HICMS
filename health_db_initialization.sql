CREATE DATABASE  IF NOT EXISTS `health_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `health_db`;
-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: localhost    Database: health_db
-- ------------------------------------------------------
-- Server version	8.0.44

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `claims`
--

DROP TABLE IF EXISTS `claims`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `claims` (
  `claim_id` bigint NOT NULL AUTO_INCREMENT,
  `claim_number` varchar(50) NOT NULL,
  `claim_amount` double NOT NULL,
  `approved_amount` double DEFAULT '0',
  `claim_status` varchar(20) NOT NULL,
  `approver_comment` text,
  `rejection_reason` text,
  `recommendation_status` varchar(20) DEFAULT NULL,
  `recommendation_reason` text,
  `recommendation_score` int DEFAULT NULL,
  `claim_date` date NOT NULL,
  `approved_date` date DEFAULT NULL,
  `rejected_date` date DEFAULT NULL,
  `user_id` bigint NOT NULL,
  `treatment_id` bigint NOT NULL,
  `policy_id` bigint NOT NULL,
  `assigned_approver_id` bigint DEFAULT NULL,
  PRIMARY KEY (`claim_id`),
  UNIQUE KEY `claim_number` (`claim_number`),
  KEY `treatment_id` (`treatment_id`),
  KEY `policy_id` (`policy_id`),
  KEY `idx_claim_number` (`claim_number`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_claim_status` (`claim_status`),
  KEY `idx_approver_id` (`assigned_approver_id`),
  CONSTRAINT `claims_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `claims_ibfk_2` FOREIGN KEY (`treatment_id`) REFERENCES `treatments` (`treatment_id`) ON DELETE CASCADE,
  CONSTRAINT `claims_ibfk_3` FOREIGN KEY (`policy_id`) REFERENCES `insurance_policies` (`policy_id`) ON DELETE CASCADE,
  CONSTRAINT `claims_ibfk_4` FOREIGN KEY (`assigned_approver_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `claims`
--

LOCK TABLES `claims` WRITE;
/*!40000 ALTER TABLE `claims` DISABLE KEYS */;
INSERT INTO `claims` VALUES (1,'CL-1780911024191',1500,1500,'APPROVED','Prescription logs clear',NULL,'APPROVE','Auto matching asset',100,'2024-07-18','2024-07-20',NULL,4,1,1,2),(2,'CL-1780911024192',500,500,'APPROVED','Pre-cleared routine consultation',NULL,'APPROVE','Auto matching asset',100,'2024-08-16','2024-08-19',NULL,4,2,1,2),(3,'CL-1780911024193',11800,11800,'APPROVED','Indoor billing match exact logs',NULL,'APPROVE','Auto matching asset',95,'2024-10-20','2024-10-24',NULL,5,3,2,3),(4,'CL-1780911024194',800,800,'SETTLED','Disbursed fully via digital link',NULL,'APPROVE','Auto matching asset',100,'2024-10-26','2024-10-29',NULL,5,4,2,3),(5,'CL-1780911024195',109908.45,109908.45,'SETTLED','Surgical invoice processing cleared',NULL,'APPROVE','Auto matching asset',100,'2025-05-12','2025-05-14',NULL,6,5,3,2),(6,'CL-1780911024196',2500,2500,'SETTLED','Post-op out-of-pocket tracker complete',NULL,'APPROVE','Auto matching asset',100,'2025-05-19','2025-05-22',NULL,6,6,3,2),(7,'CL-1780911024197',75567.32,75567.32,'SETTLED','Inpatient core processing executed',NULL,'APPROVE','Auto matching asset',90,'2025-03-22','2025-03-25',NULL,7,7,4,3),(8,'CL-1780911024198',6200,0,'REJECTED',NULL,'Treatment diagnostic window expired','REJECT','No matching rule set',15,'2025-05-03',NULL,'2025-05-06',8,8,1,2),(9,'CL-1780911024199',4500,0,'REJECTED',NULL,'Discharge summary document missing','REJECT','Documentation trace broken',5,'2025-05-12',NULL,'2025-05-16',8,9,1,3),(10,'CL-1780911024200',3000,0,'PENDING',NULL,NULL,'PENDING','Awaiting secondary specialist confirmation',60,'2025-05-16',NULL,NULL,9,10,2,3),(11,'CL-1780911024201',2500,0,'PENDING',NULL,NULL,'PENDING','Under audit process verification',55,'2025-05-21',NULL,NULL,9,11,2,2),(12,'CL-1780911024202',12000,0,'PENDING',NULL,NULL,'PENDING','High aggregate volume balance inspection',70,'2025-06-18',NULL,NULL,4,12,1,3);
/*!40000 ALTER TABLE `claims` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `doctors`
--

DROP TABLE IF EXISTS `doctors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `doctors` (
  `doctor_id` bigint NOT NULL AUTO_INCREMENT,
  `doctor_name` varchar(100) NOT NULL,
  `specialization` varchar(50) NOT NULL,
  `qualification` varchar(50) NOT NULL,
  `experience_years` int NOT NULL,
  `hospital_id` bigint NOT NULL,
  PRIMARY KEY (`doctor_id`),
  KEY `idx_hospital_id` (`hospital_id`),
  KEY `idx_specialization` (`specialization`),
  CONSTRAINT `doctors_ibfk_1` FOREIGN KEY (`hospital_id`) REFERENCES `hospitals` (`hospital_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doctors`
--

LOCK TABLES `doctors` WRITE;
/*!40000 ALTER TABLE `doctors` DISABLE KEYS */;
INSERT INTO `doctors` VALUES (1,'Dr. Sanjeev Saxena','General Medicine','MBBS, S.M.O.',22,4),(2,'Dr. Rajeshkumar Soni','Consultant Physician','DNB (General Medicine), MBBS',12,2),(3,'Prof. R. R. Kairy','Surgery','MS',25,3),(4,'Dr. Safi Zaman','Consultant','MBBS',6,3),(5,'Dr. Amit Singh','Neurology','MD',12,1),(6,'Dr. Neha Gupta','Gastroenterology','MD',8,1);
/*!40000 ALTER TABLE `doctors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `documents`
--

DROP TABLE IF EXISTS `documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documents` (
  `document_id` bigint NOT NULL AUTO_INCREMENT,
  `document_name` varchar(100) NOT NULL,
  `document_type` varchar(50) NOT NULL,
  `document_path` longtext NOT NULL,
  `uploaded_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `claim_id` bigint NOT NULL,
  PRIMARY KEY (`document_id`),
  KEY `idx_claim_id` (`claim_id`),
  CONSTRAINT `documents_ibfk_1` FOREIGN KEY (`claim_id`) REFERENCES `claims` (`claim_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `documents`
--

LOCK TABLES `documents` WRITE;
/*!40000 ALTER TABLE `documents` DISABLE KEYS */;
INSERT INTO `documents` VALUES (1,'MedicalBill_CLM001.png','Medical Bill','/documents/claims/CLM001/MedicalBill.png','2026-06-10 22:32:29',1),(2,'Prescription_CLM001.png','Prescription','/documents/claims/CLM001/Prescription.png','2026-06-10 22:32:29',1),(3,'TreatmentBill_CLM001.png','Treatment Bill','/documents/claims/CLM001/TreatmentBill.png','2026-06-10 22:32:29',1),(4,'HospitalBill_CLM001.png','Hospital Bill','/documents/claims/CLM001/HospitalBill.png','2026-06-10 22:32:29',1),(5,'MedicalBill_CLM002.png','Medical Bill','/documents/claims/CLM002/MedicalBill.png','2026-06-10 22:32:29',2),(6,'Prescription_CLM002.png','Prescription','/documents/claims/CLM002/Prescription.png','2026-06-10 22:32:29',2),(7,'TreatmentBill_CLM002.png','Treatment Bill','/documents/claims/CLM002/TreatmentBill.png','2026-06-10 22:32:29',2),(8,'HospitalBill_CLM002.png','Hospital Bill','/documents/claims/CLM002/HospitalBill.png','2026-06-10 22:32:29',2),(9,'MedicalBill_CLM003.png','Medical Bill','/documents/claims/CLM003/MedicalBill.png','2026-06-10 22:32:29',3),(10,'Prescription_CLM003.png','Prescription','/documents/claims/CLM003/Prescription.png','2026-06-10 22:32:29',3),(11,'TreatmentBill_CLM003.png','Treatment Bill','/documents/claims/CLM003/TreatmentBill.png','2026-06-10 22:32:29',3),(12,'HospitalBill_CLM003.png','Hospital Bill','/documents/claims/CLM003/HospitalBill.png','2026-06-10 22:32:29',3),(13,'MedicalBill_CLM004.png','Medical Bill','/documents/claims/CLM004/MedicalBill.png','2026-06-10 22:32:29',4),(14,'Prescription_CLM004.png','Prescription','/documents/claims/CLM004/Prescription.png','2026-06-10 22:32:29',4),(15,'TreatmentBill_CLM004.png','Treatment Bill','/documents/claims/CLM004/TreatmentBill.png','2026-06-10 22:32:29',4),(16,'HospitalBill_CLM004.png','Hospital Bill','/documents/claims/CLM004/HospitalBill.png','2026-06-10 22:32:29',4),(17,'MedicalBill_CLM005.png','Medical Bill','/documents/claims/CLM005/MedicalBill.png','2026-06-10 22:32:29',5),(18,'Prescription_CLM005.png','Prescription','/documents/claims/CLM005/Prescription.png','2026-06-10 22:32:29',5),(19,'TreatmentBill_CLM005.png','Treatment Bill','/documents/claims/CLM005/TreatmentBill.png','2026-06-10 22:32:29',5),(20,'HospitalBill_CLM005.png','Hospital Bill','/documents/claims/CLM005/HospitalBill.png','2026-06-10 22:32:29',5),(21,'MedicalBill_CLM006.png','Medical Bill','/documents/claims/CLM006/MedicalBill.png','2026-06-10 22:32:29',6),(22,'Prescription_CLM006.png','Prescription','/documents/claims/CLM006/Prescription.png','2026-06-10 22:32:29',6),(23,'TreatmentBill_CLM006.png','Treatment Bill','/documents/claims/CLM006/TreatmentBill.png','2026-06-10 22:32:29',6),(24,'HospitalBill_CLM006.png','Hospital Bill','/documents/claims/CLM006/HospitalBill.png','2026-06-10 22:32:29',6),(25,'MedicalBill_CLM007.png','Medical Bill','/documents/claims/CLM007/MedicalBill.png','2026-06-10 22:32:29',7),(26,'Prescription_CLM007.png','Prescription','/documents/claims/CLM007/Prescription.png','2026-06-10 22:32:29',7),(27,'TreatmentBill_CLM007.png','Treatment Bill','/documents/claims/CLM007/TreatmentBill.png','2026-06-10 22:32:29',7),(28,'HospitalBill_CLM007.png','Hospital Bill','/documents/claims/CLM007/HospitalBill.png','2026-06-10 22:32:29',7),(29,'MedicalBill_CLM008.png','Medical Bill','/documents/claims/CLM008/MedicalBill.png','2026-06-10 22:32:29',8),(30,'Prescription_CLM008.png','Prescription','/documents/claims/CLM008/Prescription.png','2026-06-10 22:32:29',8),(31,'TreatmentBill_CLM008.png','Treatment Bill','/documents/claims/CLM008/TreatmentBill.png','2026-06-10 22:32:29',8),(32,'HospitalBill_CLM008.png','Hospital Bill','/documents/claims/CLM008/HospitalBill.png','2026-06-10 22:32:29',8),(33,'MedicalBill_CLM009.png','Medical Bill','/documents/claims/CLM009/MedicalBill.png','2026-06-10 22:32:29',9),(34,'Prescription_CLM009.png','Prescription','/documents/claims/CLM009/Prescription.png','2026-06-10 22:32:29',9),(35,'TreatmentBill_CLM009.png','Treatment Bill','/documents/claims/CLM009/TreatmentBill.png','2026-06-10 22:32:29',9),(36,'HospitalBill_CLM009.png','Hospital Bill','/documents/claims/CLM009/HospitalBill.png','2026-06-10 22:32:29',9),(37,'MedicalBill_CLM010.png','Medical Bill','/documents/claims/CLM010/MedicalBill.png','2026-06-10 22:32:29',10),(38,'Prescription_CLM010.png','Prescription','/documents/claims/CLM010/Prescription.png','2026-06-10 22:32:29',10),(39,'TreatmentBill_CLM010.png','Treatment Bill','/documents/claims/CLM010/TreatmentBill.png','2026-06-10 22:32:29',10),(40,'HospitalBill_CLM010.png','Hospital Bill','/documents/claims/CLM010/HospitalBill.png','2026-06-10 22:32:29',10),(41,'MedicalBill_CLM011.png','Medical Bill','/documents/claims/CLM011/MedicalBill.png','2026-06-10 22:32:29',11),(42,'Prescription_CLM011.png','Prescription','/documents/claims/CLM011/Prescription.png','2026-06-10 22:32:29',11),(43,'TreatmentBill_CLM011.png','Treatment Bill','/documents/claims/CLM011/TreatmentBill.png','2026-06-10 22:32:29',11),(44,'HospitalBill_CLM011.png','Hospital Bill','/documents/claims/CLM011/HospitalBill.png','2026-06-10 22:32:29',11),(45,'MedicalBill_CLM012.png','Medical Bill','/documents/claims/CLM012/MedicalBill.png','2026-06-10 22:32:29',12),(46,'Prescription_CLM012.png','Prescription','/documents/claims/CLM012/Prescription.png','2026-06-10 22:32:29',12),(47,'TreatmentBill_CLM012.png','Treatment Bill','/documents/claims/CLM012/TreatmentBill.png','2026-06-10 22:32:29',12),(48,'HospitalBill_CLM012.png','Hospital Bill','/documents/claims/CLM012/HospitalBill.png','2026-06-10 22:32:29',12);
/*!40000 ALTER TABLE `documents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hospitals`
--

DROP TABLE IF EXISTS `hospitals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hospitals` (
  `hospital_id` bigint NOT NULL AUTO_INCREMENT,
  `hospital_name` varchar(100) NOT NULL,
  `hospital_type` varchar(50) NOT NULL,
  `address` varchar(255) NOT NULL,
  `phone_number` varchar(20) NOT NULL,
  PRIMARY KEY (`hospital_id`),
  KEY `idx_hospital_name` (`hospital_name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hospitals`
--

LOCK TABLES `hospitals` WRITE;
/*!40000 ALTER TABLE `hospitals` DISABLE KEYS */;
INSERT INTO `hospitals` VALUES (1,'Apollo Hospitals','Private','100 Health Street, New Delhi','9111111111'),(2,'Grace Nursing Home','Private','D-02 SH, Chhani Jakatnaka, Vadodara','9122222222'),(3,'Green Life Hospital Limited','Private','Plot 34, Clinical Area, Mumbai','9133333333'),(4,'Maharao Bhim Singh Hospital','Government','1-J-26, Vigyan Nagar, Kota','9144444444');
/*!40000 ALTER TABLE `hospitals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `insurance_policies`
--

DROP TABLE IF EXISTS `insurance_policies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `insurance_policies` (
  `policy_id` bigint NOT NULL AUTO_INCREMENT,
  `policy_number` varchar(50) NOT NULL,
  `policy_name` varchar(100) NOT NULL,
  `policy_type` varchar(50) NOT NULL,
  `coverage_amount` double NOT NULL,
  `premium_amount` double NOT NULL,
  `benefits` text,
  `policy_status` varchar(20) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`policy_id`),
  UNIQUE KEY `policy_number` (`policy_number`),
  KEY `idx_policy_number` (`policy_number`),
  KEY `idx_policy_status` (`policy_status`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `insurance_policies`
--

LOCK TABLES `insurance_policies` WRITE;
/*!40000 ALTER TABLE `insurance_policies` DISABLE KEYS */;
INSERT INTO `insurance_policies` VALUES (1,'POL001','Gold Health Plus','Individual',500000,15000,'Covers hospitalization, surgeries, medications','ACTIVE','2025-03-15','2027-11-20','2026-06-10 22:32:29','2026-06-10 22:32:29'),(2,'POL002','Silver Health Basic','Individual',300000,10000,'Basic coverage for hospitalization','ACTIVE','2025-07-01','2027-12-15','2026-06-10 22:32:29','2026-06-10 22:32:29'),(3,'POL003','Platinum Health Premium','Family',1000000,30000,'Full coverage for family hospitalization and surgery','ACTIVE','2025-01-05','2026-12-31','2026-06-10 22:32:29','2026-06-10 22:32:29'),(4,'POL004','Bronze Health Entry','Individual',200000,5000,'Emergency hospitalization coverage','ACTIVE','2026-04-10','2027-09-30','2026-06-10 22:32:29','2026-06-10 22:32:29'),(5,'POL005','Diamond Family Care','Family',1500000,40000,'Premium family health coverage with dental','INACTIVE','2023-06-01','2024-05-31','2026-06-10 22:32:29','2026-06-10 22:32:29'),(6,'POL006','Gold Health Plus','Individual',450000,14000,'Legacy personal health tracker coverage','INACTIVE','2022-01-01','2023-12-31','2026-06-10 22:32:29','2026-06-10 22:32:29'),(7,'POL007','Silver Health Basic','Individual',250000,9000,'Legacy essential standard medical health','INACTIVE','2021-05-01','2022-04-30','2026-06-10 22:32:29','2026-06-10 22:32:29');
/*!40000 ALTER TABLE `insurance_policies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `payment_id` bigint NOT NULL AUTO_INCREMENT,
  `payment_amount` double NOT NULL,
  `payment_date` date NOT NULL,
  `payment_mode` varchar(50) NOT NULL,
  `transaction_id` varchar(50) DEFAULT NULL,
  `payment_status` varchar(20) NOT NULL,
  `company_account_number` varchar(20) NOT NULL,
  `company_bank_name` varchar(100) NOT NULL,
  `claim_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`payment_id`),
  UNIQUE KEY `unique_claim_payment` (`claim_id`),
  KEY `idx_claim_id` (`claim_id`),
  KEY `idx_user_id` (`user_id`),
  CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`claim_id`) REFERENCES `claims` (`claim_id`) ON DELETE CASCADE,
  CONSTRAINT `payments_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
INSERT INTO `payments` VALUES (1,800,'2024-10-30','ONLINE PAYMENT','TXN20240011','COMPLETED','999988887777','HealthCare Central Bank',4,5),(2,109908.45,'2025-05-15','ONLINE PAYMENT','TXN20250022','COMPLETED','999988887777','HealthCare Central Bank',5,6),(3,2500,'2025-05-23','ONLINE PAYMENT','TXN20250023','COMPLETED','999988887777','HealthCare Central Bank',6,6),(4,75567.32,'2025-03-26','ONLINE PAYMENT','TXN20250044','COMPLETED','999988887777','HealthCare Central Bank',7,7),(5,1500,'2026-06-10','Automatic','AUTO-0de054c8-bbbf-4e07-a1a2-8d8bf968a355','PENDING','INSURANCE-HQ-001','Health Insurance Co.',1,4),(6,500,'2026-06-10','Automatic','AUTO-c882f101-328d-4a99-b82e-4b9aff934061','PENDING','INSURANCE-HQ-001','Health Insurance Co.',2,4),(7,11800,'2026-06-10','Automatic','AUTO-3574f87a-0457-4862-a004-98acad6f2adb','PENDING','INSURANCE-HQ-001','Health Insurance Co.',3,5);
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `treatments`
--

DROP TABLE IF EXISTS `treatments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `treatments` (
  `treatment_id` bigint NOT NULL AUTO_INCREMENT,
  `diagnosis` varchar(100) NOT NULL,
  `treatment_description` text NOT NULL,
  `treatment_amount` double NOT NULL,
  `treatment_date` date NOT NULL,
  `user_id` bigint NOT NULL,
  `doctor_id` bigint DEFAULT NULL,
  `hospital_id` bigint DEFAULT NULL,
  PRIMARY KEY (`treatment_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_doctor_id` (`doctor_id`),
  KEY `idx_hospital_id` (`hospital_id`),
  CONSTRAINT `treatments_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `treatments_ibfk_2` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`doctor_id`) ON DELETE CASCADE,
  CONSTRAINT `treatments_ibfk_3` FOREIGN KEY (`hospital_id`) REFERENCES `hospitals` (`hospital_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `treatments`
--

LOCK TABLES `treatments` WRITE;
/*!40000 ALTER TABLE `treatments` DISABLE KEYS */;
INSERT INTO `treatments` VALUES (1,'Anxiety / Gastric','Observation, Capsule Rozavel, Tablet Ambulax prescriptions',1500,'2024-07-17',4,1,4),(2,'General Checkup','Routine post-gastric diagnostic follow-up',500,'2024-08-15',4,1,4),(3,'Indoor Hospitalization','Bed Charge, Nursing and Doctor Visit Charges',11800,'2024-10-14',5,2,2),(4,'Follow-up Consultation','Post discharge physical assessment review',800,'2024-10-25',5,2,2),(5,'Implant Removal Surgery','Surgeon fee, Anesthetist and Theatre Charge services',109908.45,'2025-05-11',6,3,3),(6,'Post-Op Dressing','Minor clinical management and service charges',2500,'2025-05-18',6,4,3),(7,'Inpatient Emergency Care','Emergency Room Rent, Pharmacy and Consumables bill',75567.32,'2025-03-20',7,5,1),(8,'Cardiology Assessment','ECG diagnostics and critical monitoring records',6200,'2025-05-01',8,5,1),(9,'Orthopedics Evaluation','Joint mobility assessment and scan checks',4500,'2025-05-10',8,2,2),(10,'Neurology Consultation','Chronic migraine diagnosis review',3000,'2025-05-15',9,5,1),(11,'Gastroenterology Check','Acidity and upper tract evaluation',2500,'2025-05-20',9,6,1),(12,'General Medical Diagnosis','General observation clinic services billing',1200,'2025-06-15',4,1,4);
/*!40000 ALTER TABLE `treatments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_policies`
--

DROP TABLE IF EXISTS `user_policies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_policies` (
  `user_policy_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `policy_id` bigint NOT NULL,
  `purchased_date` date NOT NULL,
  `expiry_date` date NOT NULL,
  `policy_active_status` varchar(20) NOT NULL,
  PRIMARY KEY (`user_policy_id`),
  UNIQUE KEY `unique_user_policy` (`user_id`,`policy_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_policy_id` (`policy_id`),
  CONSTRAINT `user_policies_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `user_policies_ibfk_2` FOREIGN KEY (`policy_id`) REFERENCES `insurance_policies` (`policy_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_policies`
--

LOCK TABLES `user_policies` WRITE;
/*!40000 ALTER TABLE `user_policies` DISABLE KEYS */;
INSERT INTO `user_policies` VALUES (1,4,1,'2025-01-05','2027-12-31','ACTIVE'),(2,5,2,'2025-02-01','2027-12-31','ACTIVE'),(3,6,3,'2025-03-01','2027-12-31','ACTIVE'),(4,7,4,'2026-04-12','2027-09-30','ACTIVE'),(5,8,1,'2025-06-01','2027-12-31','ACTIVE'),(6,9,2,'2025-01-15','2027-12-31','ACTIVE'),(7,4,3,'2025-01-10','2026-12-31','ACTIVE'),(8,5,1,'2025-03-20','2027-11-20','ACTIVE');
/*!40000 ALTER TABLE `user_policies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` bigint NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone_number` varchar(20) NOT NULL,
  `date_of_birth` date NOT NULL,
  `address` varchar(255) NOT NULL,
  `role` varchar(20) NOT NULL,
  `account_status` varchar(20) NOT NULL,
  `bank_account_number` varchar(20) DEFAULT NULL,
  `ifsc_code` varchar(20) DEFAULT NULL,
  `bank_name` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `last_login` datetime DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`),
  KEY `idx_username` (`username`),
  KEY `idx_role` (`role`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'administrator','$2a$12$GqS4yfRrKjOZ.Sts3Ydd7.ngD.XUO.gX4xvfYXVhGMiX7/j7XGNrm','Admin User','admin@hicms.com','9876543210','1980-08-15','123 Admin Office Street, New York','ADMIN','ACTIVE',NULL,NULL,NULL,'2026-06-10 22:32:29','2026-06-11 08:48:14'),(2,'Approver_01','$2a$12$viuDFjbKz11rZ1tTBqMWUuVtNbQ1hLObnynBWu8nLT1a74MVPjtg6','John Approver','approver01@hicms.com','9876543211','1975-05-20','456 Approver Lane, Boston','APPROVER','ACTIVE',NULL,NULL,NULL,'2026-06-10 22:32:29','2026-06-11 08:55:31'),(3,'Approver_02','$2a$12$viuDFjbKz11rZ1tTBqMWUuVtNbQ1hLObnynBWu8nLT1a74MVPjtg6','Sarah Approver','approver02@hicms.com','9876543212','1978-03-10','789 Reviewer Road, Chicago','APPROVER','ACTIVE',NULL,NULL,NULL,'2026-06-10 22:32:29',NULL),(4,'Draven23','$2a$12$obGqua4OaHHulnyRbb/7KOgUIQ0rg9QvHhW67pWp.XwTy5SKLM5SC','Draven','draven23@email.com','9000000011','1990-02-23','Addr1','POLICYHOLDER','ACTIVE','1111222233334444','IFSC0001','BankA','2025-01-01 00:00:00','2026-06-11 08:58:48'),(5,'Gowtham40','$2a$12$obGqua4OaHHulnyRbb/7KOgUIQ0rg9QvHhW67pWp.XwTy5SKLM5SC','Gowtham','gowtham40@email.com','9000000012','1988-07-22','Addr2','POLICYHOLDER','ACTIVE','2222333344445555','IFSC0002','BankB','2025-01-02 00:00:00','2026-06-11 08:59:10'),(6,'angel67','$2a$12$obGqua4OaHHulnyRbb/7KOgUIQ0rg9QvHhW67pWp.XwTy5SKLM5SC','Angel','angel67@email.com','9000000013','1993-06-17','Addr3','POLICYHOLDER','ACTIVE','3333444455556666','IFSC0003','BankC','2025-01-03 00:00:00',NULL),(7,'banu12','$2a$12$obGqua4OaHHulnyRbb/7KOgUIQ0rg9QvHhW67pWp.XwTy5SKLM5SC','Banu','banu12@email.com','9000000014','1991-09-12','Addr4','POLICYHOLDER','ACTIVE','4444555566667777','IFSC0004','BankD','2025-01-04 00:00:00',NULL),(8,'Sivaranjeni89','$2a$12$obGqua4OaHHulnyRbb/7KOgUIQ0rg9QvHhW67pWp.XwTy5SKLM5SC','Sivaranjeni','sivaranjeni89@email.com','9000000015','1989-08-28','Addr5','POLICYHOLDER','ACTIVE','5555666677778888','IFSC0005','BankE','2025-01-05 00:00:00',NULL),(9,'Rajesh17','$2a$12$obGqua4OaHHulnyRbb/7KOgUIQ0rg9QvHhW67pWp.XwTy5SKLM5SC','Rajesh Kumar','rajesh17@email.com','9000000016','1990-01-17','Addr6','POLICYHOLDER','ACTIVE','6666777788889999','IFSC0006','BankF','2025-01-06 00:00:00',NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-11  9:01:36
