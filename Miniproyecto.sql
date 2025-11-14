/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.11.13-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: 127.0.0.1    Database: miniproyecto_correcciones
-- ------------------------------------------------------
-- Server version	10.11.13-MariaDB-0ubuntu0.24.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `hoteles`
--

DROP TABLE IF EXISTS `hoteles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hoteles` (
  `id_hotel` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `ubicacion` varchar(200) DEFAULT NULL,
  `rif_hotel` varchar(20) DEFAULT NULL,
  `actualizado_en` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_hotel`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hoteles`
--

LOCK TABLES `hoteles` WRITE;
/*!40000 ALTER TABLE `hoteles` DISABLE KEYS */;
INSERT INTO `hoteles` VALUES
(1,'Hotel Sunsol Punta Blanca','Punta Blanca, Venezuela','J-12345698-9','2025-11-14 00:44:47'),
(2,'Hotel Sunsol Ecoland','Ecoland, Venezuela','J-98765432-1','2025-11-14 00:44:47'),
(3,'Hotel Hesperia','Caracas, Venezuela','J-45678912-3','2025-11-14 00:44:47'),
(4,'Hotel Agua Dorada','Margarita, Venezuela','J-32165497-8','2025-11-14 00:44:47');
/*!40000 ALTER TABLE `hoteles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `presupuesto_reservas`
--

DROP TABLE IF EXISTS `presupuesto_reservas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `presupuesto_reservas` (
  `id_presupuesto_reserva` int(11) NOT NULL AUTO_INCREMENT,
  `id_tarifario` int(11) NOT NULL,
  `fecha_reserva_desde` date NOT NULL,
  `fecha_reserva_hasta` date NOT NULL,
  `cantidad_noches` int(11) DEFAULT NULL,
  `cantidad_dias` int(11) DEFAULT NULL,
  `creacion_registro` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_presupuesto_reserva`),
  KEY `fk_presupuesto_tarifario` (`id_tarifario`),
  KEY `idx_presupuesto_fechas` (`fecha_reserva_desde`,`fecha_reserva_hasta`),
  CONSTRAINT `fk_presupuesto_tarifario` FOREIGN KEY (`id_tarifario`) REFERENCES `tarifarios` (`id_tarifario`),
  CONSTRAINT `chk_fechas_validas` CHECK (`fecha_reserva_hasta` > `fecha_reserva_desde`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `presupuesto_reservas`
--

LOCK TABLES `presupuesto_reservas` WRITE;
/*!40000 ALTER TABLE `presupuesto_reservas` DISABLE KEYS */;
INSERT INTO `presupuesto_reservas` VALUES
(1,2,'2025-02-10','2025-02-15',5,6,'2025-10-30 23:57:59'),
(2,25,'2025-05-12','2025-05-17',5,6,'2025-10-30 23:57:59'),
(3,51,'2025-08-20','2025-08-25',5,6,'2025-10-30 23:57:59'),
(4,88,'2025-11-20','2025-11-24',4,5,'2025-10-30 23:57:59'),
(5,18,'2025-11-18','2025-11-22',4,5,'2025-10-30 23:57:59'),
(6,94,'2025-12-24','2025-12-29',5,6,'2025-10-31 00:28:28'),
(7,94,'2025-12-24','2025-12-29',5,6,'2025-10-31 00:28:31'),
(8,1,'2025-02-01','2025-02-05',3,4,'2025-11-14 00:49:18');
/*!40000 ALTER TABLE `presupuesto_reservas` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`osorio`@`localhost`*/ /*!50003 TRIGGER calcular_duracion_presupuesto
BEFORE INSERT ON presupuesto_reservas
FOR EACH ROW
BEGIN
    SET NEW.cantidad_noches = DATEDIFF(NEW.fecha_reserva_hasta, NEW.fecha_reserva_desde)- 1;
    SET NEW.cantidad_dias = DATEDIFF(NEW.fecha_reserva_hasta, NEW.fecha_reserva_desde);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `reservas`
--

DROP TABLE IF EXISTS `reservas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `reservas` (
  `id_reserva` int(11) NOT NULL AUTO_INCREMENT,
  `id_turista` int(11) NOT NULL,
  `id_presupuesto_reserva` int(11) NOT NULL,
  `codigo_reserva` varchar(20) NOT NULL,
  `monto_pagar` decimal(10,2) NOT NULL,
  `creacion_registro` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_reserva`),
  UNIQUE KEY `codigo_reserva` (`codigo_reserva`),
  KEY `fk_reservas_turista` (`id_turista`),
  KEY `fk_reservas_presupuesto` (`id_presupuesto_reserva`),
  KEY `idx_reservas_codigo` (`codigo_reserva`),
  CONSTRAINT `fk_reservas_presupuesto` FOREIGN KEY (`id_presupuesto_reserva`) REFERENCES `presupuesto_reservas` (`id_presupuesto_reserva`),
  CONSTRAINT `fk_reservas_turista` FOREIGN KEY (`id_turista`) REFERENCES `turistas` (`id_turista`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reservas`
--

LOCK TABLES `reservas` WRITE;
/*!40000 ALTER TABLE `reservas` DISABLE KEYS */;
INSERT INTO `reservas` VALUES
(1,1,1,'RES001',300.00,'2025-10-30 23:58:10'),
(2,2,2,'RES002',375.00,'2025-10-30 23:58:10'),
(3,3,3,'RES003',475.00,'2025-10-30 23:58:10'),
(4,4,4,'RES004',420.00,'2025-10-30 23:58:10'),
(5,1,5,'RES005',240.00,'2025-10-30 23:58:10'),
(6,1,7,'RES006',410.00,'2025-10-31 00:29:37');
/*!40000 ALTER TABLE `reservas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tarifarios`
--

DROP TABLE IF EXISTS `tarifarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tarifarios` (
  `id_tarifario` int(11) NOT NULL AUTO_INCREMENT,
  `id_hotel` int(11) NOT NULL,
  `id_tipo_habitacion` int(11) NOT NULL,
  `fecha_desde` date NOT NULL,
  `fecha_hasta` date NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `actualizado_en` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_tarifario`),
  KEY `fk_tarifarios_hotel` (`id_hotel`),
  KEY `fk_tarifarios_tipo_habitacion` (`id_tipo_habitacion`),
  KEY `idx_tarifarios_fechas` (`fecha_desde`,`fecha_hasta`),
  CONSTRAINT `fk_tarifarios_hotel` FOREIGN KEY (`id_hotel`) REFERENCES `hoteles` (`id_hotel`),
  CONSTRAINT `fk_tarifarios_tipo_habitacion` FOREIGN KEY (`id_tipo_habitacion`) REFERENCES `tipo_habitaciones` (`id_tipo_habitacion`),
  CONSTRAINT `chk_fechas_tarifarios` CHECK (`fecha_hasta` >= `fecha_desde`)
) ENGINE=InnoDB AUTO_INCREMENT=97 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tarifarios`
--

LOCK TABLES `tarifarios` WRITE;
/*!40000 ALTER TABLE `tarifarios` DISABLE KEYS */;
INSERT INTO `tarifarios` VALUES
(1,1,1,'2025-01-01','2025-03-31',65.00,'2025-11-14 00:44:47'),
(2,1,2,'2025-01-01','2025-03-31',60.00,'2025-11-14 00:44:47'),
(3,1,3,'2025-01-01','2025-03-31',120.00,'2025-11-14 00:44:47'),
(4,1,4,'2025-01-01','2025-03-31',111.00,'2025-11-14 00:44:47'),
(5,1,1,'2025-04-01','2025-06-30',60.00,'2025-11-14 00:44:47'),
(6,1,2,'2025-04-01','2025-06-30',57.00,'2025-11-14 00:44:47'),
(7,1,3,'2025-04-01','2025-06-30',110.00,'2025-11-14 00:44:47'),
(8,1,4,'2025-04-01','2025-06-30',125.00,'2025-11-14 00:44:47'),
(9,1,1,'2025-07-01','2025-09-30',70.00,'2025-11-14 00:44:47'),
(10,1,2,'2025-07-01','2025-09-30',67.00,'2025-11-14 00:44:47'),
(11,1,3,'2025-07-01','2025-09-30',105.00,'2025-11-14 00:44:47'),
(12,1,4,'2025-07-01','2025-09-30',130.00,'2025-11-14 00:44:47'),
(13,1,1,'2025-10-01','2025-11-15',55.00,'2025-11-14 00:44:47'),
(14,1,2,'2025-10-01','2025-11-15',50.00,'2025-11-14 00:44:47'),
(15,1,3,'2025-10-01','2025-11-15',120.00,'2025-11-14 00:44:47'),
(16,1,4,'2025-10-01','2025-11-15',115.00,'2025-11-14 00:44:47'),
(17,1,1,'2025-11-16','2025-11-28',65.00,'2025-11-14 00:44:47'),
(18,1,2,'2025-11-16','2025-11-28',60.00,'2025-11-14 00:44:47'),
(19,1,3,'2025-11-16','2025-11-28',115.00,'2025-11-14 00:44:47'),
(20,1,4,'2025-11-16','2025-11-28',100.00,'2025-11-14 00:44:47'),
(21,1,1,'2025-11-29','2025-12-31',75.00,'2025-11-14 00:44:47'),
(22,1,2,'2025-11-29','2025-12-31',73.00,'2025-11-14 00:44:47'),
(23,1,3,'2025-11-29','2025-12-31',130.00,'2025-11-14 00:44:47'),
(24,1,4,'2025-11-29','2025-12-31',135.00,'2025-11-14 00:44:47'),
(25,2,1,'2025-01-01','2025-03-31',75.00,'2025-11-14 00:44:47'),
(26,2,2,'2025-01-01','2025-03-31',70.00,'2025-11-14 00:44:47'),
(27,2,3,'2025-01-01','2025-03-31',130.00,'2025-11-14 00:44:47'),
(28,2,4,'2025-01-01','2025-03-31',120.00,'2025-11-14 00:44:47'),
(29,2,1,'2025-04-01','2025-06-30',70.00,'2025-11-14 00:44:47'),
(30,2,2,'2025-04-01','2025-06-30',67.00,'2025-11-14 00:44:47'),
(31,2,3,'2025-04-01','2025-06-30',120.00,'2025-11-14 00:44:47'),
(32,2,4,'2025-04-01','2025-06-30',115.00,'2025-11-14 00:44:47'),
(33,2,1,'2025-07-01','2025-09-30',80.00,'2025-11-14 00:44:47'),
(34,2,2,'2025-07-01','2025-09-30',77.00,'2025-11-14 00:44:47'),
(35,2,3,'2025-07-01','2025-09-30',110.00,'2025-11-14 00:44:47'),
(36,2,4,'2025-07-01','2025-09-30',135.00,'2025-11-14 00:44:47'),
(37,2,1,'2025-10-01','2025-11-15',65.00,'2025-11-14 00:44:47'),
(38,2,2,'2025-10-01','2025-11-15',60.00,'2025-11-14 00:44:47'),
(39,2,3,'2025-10-01','2025-11-15',115.00,'2025-11-14 00:44:47'),
(40,2,4,'2025-10-01','2025-11-15',125.00,'2025-11-14 00:44:47'),
(41,2,1,'2025-11-16','2025-11-28',75.00,'2025-11-14 00:44:47'),
(42,2,2,'2025-11-16','2025-11-28',70.00,'2025-11-14 00:44:47'),
(43,2,3,'2025-11-16','2025-11-28',120.00,'2025-11-14 00:44:47'),
(44,2,4,'2025-11-16','2025-11-28',120.00,'2025-11-14 00:44:47'),
(45,2,1,'2025-11-29','2025-12-31',85.00,'2025-11-14 00:44:47'),
(46,2,2,'2025-11-29','2025-12-31',83.00,'2025-11-14 00:44:47'),
(47,2,3,'2025-11-29','2025-12-31',110.00,'2025-11-14 00:44:47'),
(48,2,4,'2025-11-29','2025-12-31',145.00,'2025-11-14 00:44:47'),
(49,3,1,'2025-01-01','2025-03-31',55.00,'2025-11-14 00:44:47'),
(50,3,2,'2025-01-01','2025-03-31',65.00,'2025-11-14 00:44:47'),
(51,3,3,'2025-01-01','2025-03-31',95.00,'2025-11-14 00:44:47'),
(52,3,4,'2025-01-01','2025-03-31',98.00,'2025-11-14 00:44:47'),
(53,3,1,'2025-04-01','2025-06-30',65.00,'2025-11-14 00:44:47'),
(54,3,2,'2025-04-01','2025-06-30',60.00,'2025-11-14 00:44:47'),
(55,3,3,'2025-04-01','2025-06-30',80.00,'2025-11-14 00:44:47'),
(56,3,4,'2025-04-01','2025-06-30',100.00,'2025-11-14 00:44:47'),
(57,3,1,'2025-07-01','2025-09-30',70.00,'2025-11-14 00:44:47'),
(58,3,2,'2025-07-01','2025-09-30',68.00,'2025-11-14 00:44:47'),
(59,3,3,'2025-07-01','2025-09-30',75.00,'2025-11-14 00:44:47'),
(60,3,4,'2025-07-01','2025-09-30',95.00,'2025-11-14 00:44:47'),
(61,3,1,'2025-10-01','2025-11-15',45.00,'2025-11-14 00:44:47'),
(62,3,2,'2025-10-01','2025-11-15',55.00,'2025-11-14 00:44:47'),
(63,3,3,'2025-10-01','2025-11-15',85.00,'2025-11-14 00:44:47'),
(64,3,4,'2025-10-01','2025-11-15',105.00,'2025-11-14 00:44:47'),
(65,3,1,'2025-11-16','2025-11-28',55.00,'2025-11-14 00:44:47'),
(66,3,2,'2025-11-16','2025-11-28',62.00,'2025-11-14 00:44:47'),
(67,3,3,'2025-11-16','2025-11-28',83.00,'2025-11-14 00:44:47'),
(68,3,4,'2025-11-16','2025-11-28',93.00,'2025-11-14 00:44:47'),
(69,3,1,'2025-11-29','2025-12-31',70.00,'2025-11-14 00:44:47'),
(70,3,2,'2025-11-29','2025-12-31',72.00,'2025-11-14 00:44:47'),
(71,3,3,'2025-11-29','2025-12-31',100.00,'2025-11-14 00:44:47'),
(72,3,4,'2025-11-29','2025-12-31',115.00,'2025-11-14 00:44:47'),
(73,4,1,'2025-01-01','2025-03-31',60.00,'2025-11-14 00:44:47'),
(74,4,2,'2025-01-01','2025-03-31',75.00,'2025-11-14 00:44:47'),
(75,4,3,'2025-01-01','2025-03-31',105.00,'2025-11-14 00:44:47'),
(76,4,4,'2025-01-01','2025-03-31',98.00,'2025-11-14 00:44:47'),
(77,4,1,'2025-04-01','2025-06-30',62.00,'2025-11-14 00:44:47'),
(78,4,2,'2025-04-01','2025-06-30',70.00,'2025-11-14 00:44:47'),
(79,4,3,'2025-04-01','2025-06-30',90.00,'2025-11-14 00:44:47'),
(80,4,4,'2025-04-01','2025-06-30',100.00,'2025-11-14 00:44:47'),
(81,4,1,'2025-07-01','2025-09-30',69.00,'2025-11-14 00:44:47'),
(82,4,2,'2025-07-01','2025-09-30',78.00,'2025-11-14 00:44:47'),
(83,4,3,'2025-07-01','2025-09-30',85.00,'2025-11-14 00:44:47'),
(84,4,4,'2025-07-01','2025-09-30',95.00,'2025-11-14 00:44:47'),
(85,4,1,'2025-10-01','2025-11-15',55.00,'2025-11-14 00:44:47'),
(86,4,2,'2025-10-01','2025-11-15',65.00,'2025-11-14 00:44:47'),
(87,4,3,'2025-10-01','2025-11-15',95.00,'2025-11-14 00:44:47'),
(88,4,4,'2025-10-01','2025-11-15',105.00,'2025-11-14 00:44:47'),
(89,4,1,'2025-11-16','2025-11-28',70.00,'2025-11-14 00:44:47'),
(90,4,2,'2025-11-16','2025-11-28',72.00,'2025-11-14 00:44:47'),
(91,4,3,'2025-11-16','2025-11-28',93.00,'2025-11-14 00:44:47'),
(92,4,4,'2025-11-16','2025-11-28',93.00,'2025-11-14 00:44:47'),
(93,4,1,'2025-11-29','2025-12-31',78.00,'2025-11-14 00:44:47'),
(94,4,2,'2025-11-29','2025-12-31',82.00,'2025-11-14 00:44:47'),
(95,4,3,'2025-11-29','2025-12-31',110.00,'2025-11-14 00:44:47'),
(96,4,4,'2025-11-29','2025-12-31',115.00,'2025-11-14 00:44:47');
/*!40000 ALTER TABLE `tarifarios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipo_habitaciones`
--

DROP TABLE IF EXISTS `tipo_habitaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipo_habitaciones` (
  `id_tipo_habitacion` int(11) NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(50) NOT NULL,
  `cantidad_personas` int(11) NOT NULL,
  PRIMARY KEY (`id_tipo_habitacion`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipo_habitaciones`
--

LOCK TABLES `tipo_habitaciones` WRITE;
/*!40000 ALTER TABLE `tipo_habitaciones` DISABLE KEYS */;
INSERT INTO `tipo_habitaciones` VALUES
(1,'Habitacion tipo 1',1),
(2,'Habitacion tipo 2',2),
(3,'Habitacion tipo 3',3),
(4,'Habitacion tipo 4',4);
/*!40000 ALTER TABLE `tipo_habitaciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `turistas`
--

DROP TABLE IF EXISTS `turistas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `turistas` (
  `id_turista` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `apellido` varchar(50) NOT NULL,
  `telefono` varchar(15) DEFAULT NULL,
  `ubicacion` varchar(200) DEFAULT NULL,
  `correo` varchar(100) DEFAULT NULL,
  `actualizado_en` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_turista`),
  KEY `idx_turistas_email` (`correo`),
  CONSTRAINT `chk_email_valido` CHECK (`correo` like '%@%.%')
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `turistas`
--

LOCK TABLES `turistas` WRITE;
/*!40000 ALTER TABLE `turistas` DISABLE KEYS */;
INSERT INTO `turistas` VALUES
(1,'María','González','+584141234567','Caracas','maria.gonzalez@email.com','2025-11-14 00:44:47'),
(2,'Carlos','López','+584148765432','Valencia','carlos.lopez@email.com','2025-11-14 00:44:47'),
(3,'Ana','Martínez','+584147896541','Maracaibo','ana.martinez@email.com','2025-11-14 00:44:47'),
(4,'Pedro','Ramírez','+584143215678','Barquisimeto','pedro.ramirez@email.com','2025-11-14 00:44:47');
/*!40000 ALTER TABLE `turistas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `vista_reservas_detalladas`
--

DROP TABLE IF EXISTS `vista_reservas_detalladas`;
/*!50001 DROP VIEW IF EXISTS `vista_reservas_detalladas`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `vista_reservas_detalladas` AS SELECT
 1 AS `codigo_reserva`,
  1 AS `turista`,
  1 AS `hotel`,
  1 AS `tipo_habitacion`,
  1 AS `fecha_reserva_desde`,
  1 AS `fecha_reserva_hasta`,
  1 AS `cantidad_noches`,
  1 AS `monto_pagar`,
  1 AS `precio_por_noche`,
  1 AS `creacion_registro` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `vista_tarifas_por_hotel`
--

DROP TABLE IF EXISTS `vista_tarifas_por_hotel`;
/*!50001 DROP VIEW IF EXISTS `vista_tarifas_por_hotel`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `vista_tarifas_por_hotel` AS SELECT
 1 AS `hotel`,
  1 AS `total_tarifas`,
  1 AS `precio_minimo`,
  1 AS `precio_maximo`,
  1 AS `precio_promedio` */;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `vista_reservas_detalladas`
--

/*!50001 DROP VIEW IF EXISTS `vista_reservas_detalladas`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`osorio`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vista_reservas_detalladas` AS select `r`.`codigo_reserva` AS `codigo_reserva`,concat(`t`.`nombre`,' ',`t`.`apellido`) AS `turista`,`h`.`nombre` AS `hotel`,`th`.`descripcion` AS `tipo_habitacion`,`pr`.`fecha_reserva_desde` AS `fecha_reserva_desde`,`pr`.`fecha_reserva_hasta` AS `fecha_reserva_hasta`,`pr`.`cantidad_noches` AS `cantidad_noches`,`r`.`monto_pagar` AS `monto_pagar`,`tar`.`precio` AS `precio_por_noche`,`r`.`creacion_registro` AS `creacion_registro` from (((((`reservas` `r` join `turistas` `t` on(`r`.`id_turista` = `t`.`id_turista`)) join `presupuesto_reservas` `pr` on(`r`.`id_presupuesto_reserva` = `pr`.`id_presupuesto_reserva`)) join `tarifarios` `tar` on(`pr`.`id_tarifario` = `tar`.`id_tarifario`)) join `hoteles` `h` on(`tar`.`id_hotel` = `h`.`id_hotel`)) join `tipo_habitaciones` `th` on(`tar`.`id_tipo_habitacion` = `th`.`id_tipo_habitacion`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vista_tarifas_por_hotel`
--

/*!50001 DROP VIEW IF EXISTS `vista_tarifas_por_hotel`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`osorio`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vista_tarifas_por_hotel` AS select `h`.`nombre` AS `hotel`,count(`t`.`id_tarifario`) AS `total_tarifas`,min(`t`.`precio`) AS `precio_minimo`,max(`t`.`precio`) AS `precio_maximo`,avg(`t`.`precio`) AS `precio_promedio` from (`hoteles` `h` left join `tarifarios` `t` on(`h`.`id_hotel` = `t`.`id_hotel`)) group by `h`.`id_hotel`,`h`.`nombre` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-11-13 20:55:21
