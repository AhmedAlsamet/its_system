CREATE DATABASE  IF NOT EXISTS `its_db` /*!40100 DEFAULT CHARACTER SET utf8mb3 */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `its_db`;
-- MySQL dump 10.13  Distrib 8.0.33, for Win64 (x86_64)
--
-- Host: localhost    Database: its_db
-- ------------------------------------------------------
-- Server version	8.0.33

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
-- Table structure for table `municipalities`
--

DROP TABLE IF EXISTS `municipalities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `municipalities` (
  `MUN_ID` int NOT NULL AUTO_INCREMENT,
  `MUN_NAME` varchar(100) DEFAULT NULL,
  `MUN_NAME_EN` varchar(100) DEFAULT NULL,
  `CTY_ID` int DEFAULT NULL,
  `MUN_CREATED_DATE` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `MUN_UPDATED_DATE` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`MUN_ID`),
  KEY `county_cities_idx` (`CTY_ID`),
  CONSTRAINT `county_cities` FOREIGN KEY (`CTY_ID`) REFERENCES `cities` (`CTY_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `institutions`
--

DROP TABLE IF EXISTS `institutions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `institutions` (
  `INST_ID` int NOT NULL AUTO_INCREMENT,
  `INST_NAME` varchar(100) DEFAULT NULL,
  `INST_NAME_EN` varchar(100) DEFAULT NULL,
  `INST_MAIN_ID` int DEFAULT 0,
  `CTY_ID` int DEFAULT NULL,
  `MUN_ID` int DEFAULT NULL,
  `INST_PHONE` varchar(10) DEFAULT NULL,
  `INST_PHONE2` varchar(10) DEFAULT NULL,
  `INST_E_MAIL` varchar(50) DEFAULT NULL,
  `INST_ADDRESS` varchar(100) DEFAULT NULL,
  `INST_LONGITUDE` varchar(100) DEFAULT NULL,
  `INST_LATITUDE` varchar(100) DEFAULT NULL,
  `INST_UNIQUE_KEY` varchar(100) DEFAULT NULL,
  `INST_STATE` varchar(50) DEFAULT NULL,
  `INST_DESCRIPTION` varchar(1000) DEFAULT NULL,
  `INST_CREATED_DATE` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `INST_UPDATED_DATE` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`INST_ID`),
  UNIQUE KEY `INST_CODE_UNIQUE` (`INST_UNIQUE_KEY`),
  KEY `institution_municipality_idx` (`MUN_ID`),
  CONSTRAINT `institution_city` FOREIGN KEY (`CTY_ID`) REFERENCES `cities` (`CTY_ID`),
  CONSTRAINT `institution_municipality` FOREIGN KEY (`MUN_ID`) REFERENCES `municipalities` (`MUN_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cities`
--

DROP TABLE IF EXISTS `cities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cities` (
  `CTY_ID` int NOT NULL AUTO_INCREMENT,
  `CTY_NAME` varchar(100) DEFAULT NULL,
  `CTY_NAME_EN` varchar(100) DEFAULT NULL,
  `CTY_CREATED_DATE` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `CTY_UPDATED_DATE` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`CTY_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `notfication_reserverds`
--

DROP TABLE IF EXISTS `notfication_reserverds`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notfication_reserverds` (
  `LAST_NOT_ID` int DEFAULT NULL,
  `NOT_STATE` int DEFAULT NULL COMMENT 'state descripe what if the user has read the notification or just recive them',
  `INST_ID` int DEFAULT NULL COMMENT 'if the value is 0 tha means this notification for all institutions',
  `USR_ID` int DEFAULT NULL COMMENT 'the same of INST_ID',
  KEY `not_fk2_idx` (`LAST_NOT_ID`),
  CONSTRAINT `not_fk2` FOREIGN KEY (`LAST_NOT_ID`) REFERENCES `notifications` (`NOT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `notfication_reservers`
--

DROP TABLE IF EXISTS `notfication_reservers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notfication_reservers` (
  `NOT_ID` int DEFAULT NULL,
  `INST_ID` int DEFAULT NULL COMMENT 'if the value is 0 tha means this notification for all institutions',
  `USR_ID` int DEFAULT NULL COMMENT 'the same of INST_ID',
  `NOT_TYPE` varchar(20) DEFAULT NULL COMMENT 'if the notifaction for all user this column determine the type of users or if the notification for host this column determine if this message send to his or her famely',
  KEY `not_fk_idx` (`NOT_ID`),
  CONSTRAINT `not_fk` FOREIGN KEY (`NOT_ID`) REFERENCES `notifications` (`NOT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `NOT_ID` int NOT NULL AUTO_INCREMENT,
  `NOT_TITLE` varchar(100) DEFAULT NULL,
  `NOT_TITLE_EN` varchar(100) DEFAULT NULL,
  `NOT_DETAILS` varchar(1000) DEFAULT NULL,
  `NOT_DETAILS_EN` varchar(1000) DEFAULT NULL,
  `NOT_TYPE` varchar(10) DEFAULT NULL,
  `NOT_UPDATED_DATE` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `NOT_CREATED_DATE` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `USR_ID` int DEFAULT NULL,
  `INST_ID` int DEFAULT NULL,
  PRIMARY KEY (`NOT_ID`),
  KEY `user_created_idx` (`USR_ID`),
  KEY `compound_not_idx` (`INST_ID`),
  CONSTRAINT `compound_not` FOREIGN KEY (`INST_ID`) REFERENCES `institutions` (`INST_ID`),
  CONSTRAINT `usr_creat_not` FOREIGN KEY (`USR_ID`) REFERENCES `users` (`USR_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `policies`
--

DROP TABLE IF EXISTS `policies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `policies` (
  `POL_ID` int NOT NULL AUTO_INCREMENT,
  `POL_NAME` varchar(100) DEFAULT NULL,
  `POL_NAME_EN` varchar(100) DEFAULT NULL,
  `POL_CREATED_DATE` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `POL_UPDATED_DATE` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`POL_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `qr_styles`
--

DROP TABLE IF EXISTS `qr_styles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qr_styles` (
  `QRS_ID` int NOT NULL AUTO_INCREMENT,
  `INST_ID` int DEFAULT NULL,
  `QRS_STYLE` varchar(20) DEFAULT NULL,
  `QRS_COLOR` decimal(18,0) DEFAULT NULL,
  `QRS_IS_ROUNDED` tinyint(1) DEFAULT '0',
  `QRS_IMAGE_PATH` varchar(1000) DEFAULT NULL,
  `QRS_IMAGE_POSITION` varchar(20) DEFAULT NULL,
  `QRS_IS_DEFAULT` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`QRS_ID`),
  KEY `com_qr_design_idx` (`INST_ID`),
  CONSTRAINT `com_qr_design` FOREIGN KEY (`INST_ID`) REFERENCES `institutions` (`INST_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `service_groups`
--

DROP TABLE IF EXISTS `service_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_groups` (
  `SRVG_ID` int NOT NULL AUTO_INCREMENT,
  `SRVG_NAME` varchar(100) DEFAULT NULL,
  `SRVG_NAME_EN` varchar(100) DEFAULT NULL,
  `SRVG_CREATED_DATE` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `SRVG_UPDATED_DATE` timestamp NULL DEFAULT NULL,
  `INST_ID` int DEFAULT NULL,
  PRIMARY KEY (`SRVG_ID`),
  KEY `com_serv_group_idx` (`INST_ID`),
  CONSTRAINT `com_serv_group` FOREIGN KEY (`INST_ID`) REFERENCES `institutions` (`INST_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `services`
--

DROP TABLE IF EXISTS `services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `services` (
  `SRV_ID` int NOT NULL AUTO_INCREMENT,
  `SRV_NAME` varchar(100) DEFAULT NULL,
  `SRV_NAME_EN` varchar(100) DEFAULT NULL,
  `SRV_STATE` int NOT NULL default 1 COMMENT 'if service is active in cureent institution and sub institution 1 but if the service is active only in sub institution 2 otherwise 0',
  `SRV_DESCRIPTION` varchar(1000) DEFAULT NULL,
  `SRV_PRICE` float DEFAULT NULL,
  `SRV_TIME` int DEFAULT 1,
  `SRV_CREATED_DATE` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `SRV_UPDATED_DATE` timestamp NULL DEFAULT NULL,
  `SRVG_ID` int DEFAULT NULL,
  `INST_ID` int DEFAULT NULL,
  PRIMARY KEY (`SRV_ID`),
  KEY `serv_group_idx` (`SRVG_ID`),
  KEY `inst_serv_idx` (`INST_ID`),
  CONSTRAINT `serv_group` FOREIGN KEY (`SRVG_ID`) REFERENCES `service_groups` (`SRVG_ID`),
  CONSTRAINT `inst_serv` FOREIGN KEY (`INST_ID`) REFERENCES `institutions` (`INST_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `service_places`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_places` (
  `SRVP_ID` int NOT NULL AUTO_INCREMENT,
  `INST_ID` int DEFAULT NULL,
  `SRV_ID` int DEFAULT NULL,
  `SRVP_CREATED_DATE` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `SRVP_UPDATED_DATE` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`SRVP_ID`),
  KEY `inst_serv_idx` (`SRV_ID`),
  KEY `inst_serv_place_idx` (`INST_ID`),
  CONSTRAINT `inst_serv_place_groups` FOREIGN KEY (`INST_ID`) REFERENCES `institutions` (`INST_ID`),
  CONSTRAINT `inst_serv_groups` FOREIGN KEY (`SRV_ID`) REFERENCES `services` (`SRV_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;


DROP TABLE IF EXISTS `service_guides`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_guides` (
  `SG_ID` int NOT NULL AUTO_INCREMENT,
  `SG_NAME` varchar(100) DEFAULT NULL,
  `SG_NAME_EN` varchar(100) DEFAULT NULL,
  `SG_FILE_PATH` varchar(256) DEFAULT NULL,
  `SRV_ID` int DEFAULT NULL,
  `SG_IS_MAIN`  tinyint(1) DEFAULT '0',
  `SG_CREATED_DATE` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `SG_UPDATED_DATE` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`SG_ID`),
  KEY `serv_guid_idx` (`SRV_ID`),
  CONSTRAINT `serv_guid` FOREIGN KEY (`SRV_ID`) REFERENCES `services` (`SRV_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;


DROP TABLE IF EXISTS `service_forms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_forms` (
  `SRVF_ID` int NOT NULL AUTO_INCREMENT,
  `SRVF_NAME` varchar(100) DEFAULT NULL,
  `SRVF_NAME_EN` varchar(100) DEFAULT NULL,
  `SRVF_DESCRIPTION` varchar(1000) DEFAULT NULL,
  `SRV_ID` int DEFAULT NULL,
  `SRVF_ORDER`  int DEFAULT 0,
  `SRVF_IS_CANCEL`  tinyint(1) DEFAULT '0',
  `SRVF_CREATED_DATE` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `SRVF_UPDATED_DATE` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`SRVF_ID`),
  KEY `serv_form_idx` (`SRV_ID`),
  CONSTRAINT `serv_form` FOREIGN KEY (`SRV_ID`) REFERENCES `services` (`SRV_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;


DROP TABLE IF EXISTS `form_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `form_fields` (
  `FRMF_ID` int NOT NULL AUTO_INCREMENT,
  `FRMF_NAME` varchar(100) DEFAULT NULL,
  `FRMF_NAME_EN` varchar(100) DEFAULT NULL,
  `FRMF_TYPE` varchar(15) DEFAULT NULL,
  `SRVF_ID` int DEFAULT NULL,
  `FRMF_ORDER`  int DEFAULT 0,
  `FRMF_IS_NULL`  tinyint(1) DEFAULT '1',
  `FRMF_IS_CANCEL`  tinyint(1) DEFAULT '0',
  `FRMF_CREATED_DATE` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `FRMF_UPDATED_DATE` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`FRMF_ID`),
  KEY `serv_form_field_idx` (`SRVF_ID`),
  CONSTRAINT `serv_form_field` FOREIGN KEY (`SRVF_ID`) REFERENCES `service_forms` (`SRVF_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `form_field_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `form_field_details` (
  `FRMFD_ID` int NOT NULL AUTO_INCREMENT,
  `FRMFD_NAME` varchar(100) DEFAULT NULL,
  `FRMFD_NAME_EN` varchar(100) DEFAULT NULL,
  `FRMFD_CREATED_DATE` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `FRMFD_UPDATED_DATE` timestamp NULL DEFAULT NULL,
  `FRMF_ID` int NOT NULL,
  PRIMARY KEY (`FRMFD_ID`),
  KEY `form_field_details_idx` (`FRMF_ID`),
  CONSTRAINT `form_field_details` FOREIGN KEY (`FRMF_ID`) REFERENCES `form_fields` (`FRMF_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `settings` (
  `SET_ID` int NOT NULL DEFAULT '0',
  `SET_TYPE` varchar(45) DEFAULT NULL,
  `SET_CODE` varchar(45) DEFAULT NULL,
  `SET_VALUE` varchar(1000) DEFAULT NULL,
  `INST_ID` int NOT NULL DEFAULT '1' COMMENT 'for super admins it will be 0',
  PRIMARY KEY (`SET_ID`,`INST_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;



DROP TABLE IF EXISTS `complaint_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `complaint_types` (
  `COMT_ID` int NOT NULL AUTO_INCREMENT,
  `COMT_NAME` varchar(100) DEFAULT NULL,
  `COMT_NAME_EN` varchar(100) DEFAULT NULL,
  `COMT_CREATED_DATE` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `COMT_UPDATED_DATE` timestamp NULL DEFAULT NULL,
  `INST_ID` int NOT NULL,
  PRIMARY KEY (`COMT_ID`),
  KEY `complaint_types_idx` (`INST_ID`),
  CONSTRAINT `complaint_type` FOREIGN KEY (`INST_ID`) REFERENCES `institutions` (`INST_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `USR_ID` int NOT NULL AUTO_INCREMENT,
  `USR_NUMBER` int DEFAULT NULL,
  `USR_NAME` varchar(100) DEFAULT NULL,
  `USR_NAME_EN` varchar(100) DEFAULT NULL,
  `USR_IMG_PATH` varchar(500) DEFAULT NULL,
  `USR_PASSWORD` varchar(100) DEFAULT NULL,
  `USR_TYPE` varchar(15) DEFAULT NULL,
  `USR_STATE` varchar(10) DEFAULT '0',
  `USR_UNIQUE_KEY` varchar(50) DEFAULT NULL,
  `USR_E_MAIL` varchar(100) DEFAULT NULL,
  `USR_PHONE` varchar(20) DEFAULT NULL,
  `USR_REGISTER_DATE` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `USR_LAST_CONNECTED` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `INST_ID` int DEFAULT NULL,
  `USR_CREATED_DATE` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `USR_UPDATED_DATE` timestamp NULL DEFAULT NULL,
  `USR_GENDER` tinyint(1) DEFAULT '1',
  `USR_AGE` int DEFAULT NULL,
  `USR_ADDRESS1` varchar(500) DEFAULT NULL,
  `USR_ADDRESS2` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`USR_ID`),
  UNIQUE KEY `USR_UNIQUE_KEY_UNIQUE` (`USR_UNIQUE_KEY`),
  UNIQUE KEY `USR_PHONE_UNIQUE` (`USR_PHONE`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `ORD_ID` int NOT NULL AUTO_INCREMENT,
  `ORD_NUMBER` int DEFAULT NULL,
  `USR_ID` int DEFAULT NULL,
  `ORD_REGISTER_AT` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `ORD_NOTE` varchar(1000) DEFAULT NULL,
  `SRV_ID` int DEFAULT NULL,
  `ORD_STATE` varchar(10) DEFAULT NULL,
  `SRVP_ID` int DEFAULT NULL,
  `INST_ID` int DEFAULT NULL,
  `PAYMENT_NUMBER` int DEFAULT NULL,
  PRIMARY KEY (`ORD_ID`),
  KEY `usr_create_order_idx` (`USR_ID`),
  KEY `for_inst_idx` (`INST_ID`),
  KEY `order_serve_idx` (`SRV_ID`),
  KEY `service_place_idx` (`SRVP_ID`),
  CONSTRAINT `for_inst` FOREIGN KEY (`INST_ID`) REFERENCES `institutions` (`INST_ID`),
  CONSTRAINT `order_serve` FOREIGN KEY (`SRV_ID`) REFERENCES `services` (`SRV_ID`),
  CONSTRAINT `service_place` FOREIGN KEY (`SRVP_ID`) REFERENCES `service_places` (`SRVP_ID`),
  CONSTRAINT `usr_regestered` FOREIGN KEY (`USR_ID`) REFERENCES `users` (`USR_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `orders_details`
--

DROP TABLE IF EXISTS `order_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_details` (
  `ORD_ID` int DEFAULT NULL,
  `FRMF_ID` int DEFAULT NULL,
  `FRMF_TYPE` varchar(15) DEFAULT NULL,
  `FRMF_VALUE` varchar(1000) DEFAULT NULL,
  KEY `order_detail_idx` (`ORD_ID`),
  KEY `form_field_idx` (`FRMF_ID`),
  CONSTRAINT `order_detail` FOREIGN KEY (`ORD_ID`) REFERENCES `orders` (`ORD_ID`),
  CONSTRAINT `form_field_detail` FOREIGN KEY (`FRMF_ID`) REFERENCES `form_fields` (`FRMF_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;
CREATE TABLE `order_results` (
  `ORDR_ID` int NOT NULL AUTO_INCREMENT,
  `ORDR_CREATED_DATE` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `ORDR_UPDATED_DATE` timestamp NULL DEFAULT NULL,
  `ORDR_VALUE` varchar(100) DEFAULT NULL,
  `ORDR_VALUE_EN` varchar(100) DEFAULT NULL,
  `ORDR_TYPE` varchar(15) DEFAULT NULL,
  `ORD_ID` int DEFAULT NULL,
  PRIMARY KEY (`ORDR_ID`),
  KEY `ord_results_idx` (`ORD_ID`),
  CONSTRAINT `ord_results` FOREIGN KEY (`ORD_ID`) REFERENCES `orders` (`ORD_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-04-11 20:32:22
