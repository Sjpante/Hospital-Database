-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: localhost    Database: hospital_db
-- ------------------------------------------------------
-- Server version	5.5.5-10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `drug`
--

DROP TABLE IF EXISTS `drug`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `drug` (
  `DrugCode` int(11) NOT NULL,
  `DrugName` varchar(50) NOT NULL,
  `RecommendedDailyDose` decimal(6,2) NOT NULL,
  PRIMARY KEY (`DrugCode`),
  UNIQUE KEY `uk_drug_name` (`DrugName`),
  CONSTRAINT `ck_drug_recdose` CHECK (`RecommendedDailyDose` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `medical_consultant`
--

DROP TABLE IF EXISTS `medical_consultant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medical_consultant` (
  `StaffID` int(11) NOT NULL,
  `FirstName` varchar(50) NOT NULL,
  `LastName` varchar(50) NOT NULL,
  `Specialty` varchar(50) NOT NULL,
  `SSN` varchar(15) NOT NULL,
  `Address` varchar(100) DEFAULT NULL,
  `PhoneNumber` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`StaffID`),
  UNIQUE KEY `uk_med_consultant_ssn` (`SSN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `nurse`
--

DROP TABLE IF EXISTS `nurse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nurse` (
  `StaffID` int(11) NOT NULL,
  `FirstName` varchar(50) NOT NULL,
  `LastName` varchar(50) NOT NULL,
  `SSN` varchar(15) NOT NULL,
  `DOB` date NOT NULL,
  `Address` varchar(100) DEFAULT NULL,
  `PhoneNumber` varchar(20) DEFAULT NULL,
  `IsSupervisor` char(1) NOT NULL,
  `WardID` int(11) NOT NULL,
  PRIMARY KEY (`StaffID`),
  UNIQUE KEY `uk_nurse_ssn` (`SSN`),
  KEY `fk_nurse_ward` (`WardID`),
  CONSTRAINT `fk_nurse_ward` FOREIGN KEY (`WardID`) REFERENCES `ward` (`WardID`),
  CONSTRAINT `ck_nurse_supervisor` CHECK (`IsSupervisor` in ('Y','N'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `patient`
--

DROP TABLE IF EXISTS `patient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patient` (
  `PatientID` int(11) NOT NULL,
  `FirstName` varchar(50) NOT NULL,
  `LastName` varchar(50) NOT NULL,
  `SSN` varchar(15) NOT NULL,
  `Address` varchar(100) DEFAULT NULL,
  `PhoneNumber` varchar(20) DEFAULT NULL,
  `AdmissionDate` date NOT NULL,
  `DischargeDate` date DEFAULT NULL,
  `WardID` int(11) NOT NULL,
  `ConsultantID` int(11) NOT NULL,
  PRIMARY KEY (`PatientID`),
  UNIQUE KEY `uk_patient_ssn` (`SSN`),
  KEY `fk_patient_ward` (`WardID`),
  KEY `fk_patient_consultant` (`ConsultantID`),
  CONSTRAINT `fk_patient_consultant` FOREIGN KEY (`ConsultantID`) REFERENCES `medical_consultant` (`StaffID`),
  CONSTRAINT `fk_patient_ward` FOREIGN KEY (`WardID`) REFERENCES `ward` (`WardID`),
  CONSTRAINT `ck_patient_dates` CHECK (`DischargeDate` is null or `DischargeDate` >= `AdmissionDate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `prescription`
--

DROP TABLE IF EXISTS `prescription`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prescription` (
  `PrescriptionID` int(11) NOT NULL,
  `PatientID` int(11) NOT NULL,
  `PrescriptionDate` date NOT NULL,
  PRIMARY KEY (`PrescriptionID`),
  KEY `fk_prescription_patient` (`PatientID`),
  CONSTRAINT `fk_prescription_patient` FOREIGN KEY (`PatientID`) REFERENCES `patient` (`PatientID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `prescription_item`
--

DROP TABLE IF EXISTS `prescription_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prescription_item` (
  `PrescriptionItemID` int(11) NOT NULL,
  `PrescriptionID` int(11) NOT NULL,
  `DrugCode` int(11) NOT NULL,
  `Quantity` int(11) NOT NULL,
  `DailyDose` decimal(6,2) NOT NULL,
  PRIMARY KEY (`PrescriptionItemID`),
  UNIQUE KEY `uk_pi_unique_drug_per_prescription` (`PrescriptionID`,`DrugCode`),
  KEY `fk_pi_drug` (`DrugCode`),
  CONSTRAINT `fk_pi_drug` FOREIGN KEY (`DrugCode`) REFERENCES `drug` (`DrugCode`),
  CONSTRAINT `fk_pi_prescription` FOREIGN KEY (`PrescriptionID`) REFERENCES `prescription` (`PrescriptionID`),
  CONSTRAINT `ck_pi_quantity` CHECK (`Quantity` > 0),
  CONSTRAINT `ck_pi_dailydose` CHECK (`DailyDose` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ward`
--

DROP TABLE IF EXISTS `ward`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ward` (
  `WardID` int(11) NOT NULL,
  `WardNumber` int(11) NOT NULL,
  `WingID` int(11) NOT NULL,
  PRIMARY KEY (`WardID`),
  UNIQUE KEY `uk_ward_number_per_wing` (`WingID`,`WardNumber`),
  CONSTRAINT `fk_ward_wing` FOREIGN KEY (`WingID`) REFERENCES `wing` (`WingID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wing`
--

DROP TABLE IF EXISTS `wing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wing` (
  `WingID` int(11) NOT NULL,
  `WingName` varchar(50) NOT NULL,
  PRIMARY KEY (`WingID`),
  UNIQUE KEY `uk_wing_name` (`WingName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'hospital_db'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-02-02 14:31:31
