-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: mydb
-- ------------------------------------------------------
-- Server version	5.7.24

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
-- Table structure for table `paddles`
--

DROP TABLE IF EXISTS `paddles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `paddles` (
  `paddle_id` int(11) NOT NULL AUTO_INCREMENT,
  `brand_id` int(11) DEFAULT NULL,
  `shape_id` int(11) DEFAULT NULL,
  `core_id` int(11) DEFAULT NULL,
  `model_name` varchar(100) NOT NULL,
  `price` decimal(6,2) NOT NULL,
  `stock_quantity` int(11) DEFAULT '20',
  `release_date` date DEFAULT NULL,
  `weight_oz` decimal(4,2) DEFAULT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `img_url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`paddle_id`),
  KEY `brand_id` (`brand_id`),
  KEY `shape_id` (`shape_id`),
  KEY `core_id` (`core_id`),
  CONSTRAINT `paddles_ibfk_1` FOREIGN KEY (`brand_id`) REFERENCES `brands` (`brand_id`) ON DELETE CASCADE,
  CONSTRAINT `paddles_ibfk_2` FOREIGN KEY (`shape_id`) REFERENCES `paddle_shapes` (`shape_id`) ON DELETE SET NULL,
  CONSTRAINT `paddles_ibfk_3` FOREIGN KEY (`core_id`) REFERENCES `core_materials` (`core_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `paddles`
--

LOCK TABLES `paddles` WRITE;
/*!40000 ALTER TABLE `paddles` DISABLE KEYS */;
INSERT INTO `paddles` VALUES (4,2,4,1,'Vanguard Control Invikta',199.99,15,'2024-01-10',7.90,NULL,'assets/4.jpg'),
(5,2,1,1,'Vanguard Control Epic',199.99,5,'2024-01-10',7.80,NULL,'assets/5.jpg'),
(6,2,8,1,'Power Air Invikta',250.00,4,'2022-08-20',7.90,NULL,'assets/6.jpg'),
(7,3,1,5,'Bantam EX-L',99.99,4,'2019-05-12',7.80,NULL,'assets/7.jpg'),
(8,3,2,1,'Tempest Wave II',129.99,6,'2021-03-15',7.60,NULL,'assets/8.jpg'),
(9,3,2,2,'TS-5 Pro',149.99,9,'2022-11-01',7.70,NULL,'assets/9.jpg'),
(10,4,2,1,'CRBN 1X 16mm',229.99,3,'2023-02-14',8.10,NULL,'assets/10.jpg'),
(11,4,1,2,'CRBN 2X 14mm',229.99,10,'2023-02-14',7.90,NULL,'assets/11.jpg'),
(12,4,4,1,'CRBN 3X 16mm',229.99,11,'2023-04-10',8.00,NULL,'assets/12.jpg'),
(13,5,2,1,'Pursuit Pro EX 6.0',259.99,8,'2023-08-22',8.10,NULL,'assets/13.jpg'),
(14,5,1,2,'Pursuit Pro MX',259.99,2,'2023-08-22',7.90,NULL,'assets/14.jpg'),
(15,5,3,1,'Encore EX 6.0',159.99,14,'2021-07-05',8.00,NULL,'assets/15.jpg'),
(16,6,2,7,'CX14E Ultimate',249.99,12,'2022-09-30',8.00,NULL,'assets/16.jpg'),
(17,6,1,7,'CX14H',199.99,7,'2021-12-01',8.00,NULL,'assets/17.jpg'),
(18,6,2,7,'Pro Power Elongated',279.99,82,'2023-10-15',8.00,NULL,'assets/18.jpg'),
(19,7,4,1,'Double Black Diamond',180.00,22,'2023-01-20',8.10,NULL,'assets/19.jpg'),
(20,7,4,2,'Black Diamond Power',180.00,15,'2023-01-20',8.00,NULL,'assets/20.jpg'),
(21,7,1,1,'Ruby',199.00,5,'2023-11-25',8.20,NULL,'assets/21.jpg'),
(22,8,2,1,'V7 Pro',139.99,10,'2022-10-10',8.10,NULL,'assets/22.jpg'),
(23,8,4,1,'Flash Pro',139.99,9,'2023-03-05',8.00,NULL,'assets/23.jpg'),
(24,8,4,2,'Alchemy 14mm',179.99,12,'2023-09-12',7.90,NULL,'assets/24.jpg'),
(25,9,2,1,'R1 Nova',149.99,6,'2023-05-18',8.00,NULL,'assets/25.jpg'),
(26,9,4,1,'R3 Pulsar',169.99,14,'2023-07-22',8.10,NULL,'assets/26.jpg'),
(27,9,1,2,'EV1.16',159.99,3,'2024-02-01',8.20,NULL,'assets/27.jpg'),
(28,10,1,1,'Vice',199.99,-7,'2022-12-15',8.10,NULL,'assets/28.jpg'),
(29,10,2,1,'Edge 18k',229.99,10,'2023-08-08',8.00,NULL,'assets/29.jpg'),
(30,10,1,2,'Icon V2',159.99,16,'2022-06-25',7.90,NULL,'assets/30.jpg');

/*!40000 ALTER TABLE `paddles` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-07 16:40:06
