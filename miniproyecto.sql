/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.11.13-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: Miniproyecto
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
  `ubicacion` varchar(100) NOT NULL,
  `RIF_hotel` varchar(20) NOT NULL,
  PRIMARY KEY (`id_hotel`),
  UNIQUE KEY `RIF_hotel` (`RIF_hotel`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hoteles`
--

LOCK TABLES `hoteles` WRITE;
/*!40000 ALTER TABLE `hoteles` DISABLE KEYS */;
INSERT INTO `hoteles` VALUES
(1,'Hotel Sunsol Punta Blanca','Punta Blanca','J-12345678-9'),
(2,'Hotel Sunsol Ecoland','Ecoland','J-98765432-1'),
(3,'Hotel Hesperia','Centro Ciudad','J-45678912-3'),
(4,'Hotel Agua Dorada','Zona Turística','J-32165497-8');
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
  KEY `fk_presupuesto_reservas_tarifario` (`id_tarifario`),
  CONSTRAINT `fk_presupuesto_reservas_tarifario` FOREIGN KEY (`id_tarifario`) REFERENCES `tarifarios` (`id_tarifario`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `presupuesto_reservas`
--

LOCK TABLES `presupuesto_reservas` WRITE;
/*!40000 ALTER TABLE `presupuesto_reservas` DISABLE KEYS */;
INSERT INTO `presupuesto_reservas` VALUES
(4,1,'2025-02-15','2025-02-20',5,6,'2025-10-29 02:36:04'),
(5,2,'2025-05-10','2025-05-15',5,6,'2025-10-29 02:36:04'),
(6,3,'2025-08-01','2025-08-07',6,7,'2025-10-29 02:36:04'),
(7,1,'2025-02-15','2025-02-20',5,6,'2025-10-29 02:37:18'),
(8,2,'2025-05-10','2025-05-15',5,6,'2025-10-29 02:37:18'),
(9,3,'2025-08-01','2025-08-07',6,7,'2025-10-29 02:37:18'),
(10,1,'2025-02-15','2025-02-20',5,6,'2025-10-29 02:40:28'),
(11,2,'2025-05-10','2025-05-15',5,6,'2025-10-29 02:40:28'),
(12,3,'2025-08-01','2025-08-07',6,7,'2025-10-29 02:40:28');
/*!40000 ALTER TABLE `presupuesto_reservas` ENABLE KEYS */;
UNLOCK TABLES;

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
  CONSTRAINT `fk_reservas_presupuesto` FOREIGN KEY (`id_presupuesto_reserva`) REFERENCES `presupuesto_reservas` (`id_presupuesto_reserva`),
  CONSTRAINT `fk_reservas_turista` FOREIGN KEY (`id_turista`) REFERENCES `turistas` (`id_turista`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reservas`
--

LOCK TABLES `reservas` WRITE;
/*!40000 ALTER TABLE `reservas` DISABLE KEYS */;
INSERT INTO `reservas` VALUES
(13,1,8,'RES001',325.00,'2025-10-29 02:40:28'),
(14,2,9,'RES002',300.00,'2025-10-29 02:40:28'),
(15,3,10,'RES003',720.00,'2025-10-29 02:40:28');
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
  PRIMARY KEY (`id_tarifario`),
  KEY `fk_tarifarios_hotel` (`id_hotel`),
  KEY `fk_tarifarios_tipo_habitacion` (`id_tipo_habitacion`),
  CONSTRAINT `fk_tarifarios_hotel` FOREIGN KEY (`id_hotel`) REFERENCES `hoteles` (`id_hotel`),
  CONSTRAINT `fk_tarifarios_tipo_habitacion` FOREIGN KEY (`id_tipo_habitacion`) REFERENCES `tipo_habitaciones` (`id_tipo_habitacion`)
) ENGINE=InnoDB AUTO_INCREMENT=105 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tarifarios`
--

LOCK TABLES `tarifarios` WRITE;
/*!40000 ALTER TABLE `tarifarios` DISABLE KEYS */;
INSERT INTO `tarifarios` VALUES
(1,1,1,'2025-01-01','2025-03-31',65.00),
(2,1,2,'2025-01-01','2025-03-31',60.00),
(3,1,3,'2025-01-01','2025-03-31',120.00),
(4,1,4,'2025-01-01','2025-03-31',111.00),
(5,1,1,'2025-04-01','2025-06-30',60.00),
(6,1,2,'2025-04-01','2025-06-30',57.00),
(7,1,3,'2025-04-01','2025-06-30',110.00),
(8,1,4,'2025-04-01','2025-06-30',125.00),
(9,1,1,'2025-01-01','2025-03-31',65.00),
(10,1,2,'2025-01-01','2025-03-31',60.00),
(11,1,3,'2025-01-01','2025-03-31',120.00),
(12,1,4,'2025-01-01','2025-03-31',111.00),
(13,1,1,'2025-04-01','2025-06-30',60.00),
(14,1,2,'2025-04-01','2025-06-30',57.00),
(15,1,3,'2025-04-01','2025-06-30',110.00),
(16,1,4,'2025-04-01','2025-06-30',125.00),
(17,1,1,'2025-07-01','2025-09-30',70.00),
(18,1,2,'2025-07-01','2025-09-30',67.00),
(19,1,3,'2025-07-01','2025-09-30',105.00),
(20,1,4,'2025-07-01','2025-09-30',130.00),
(21,1,1,'2025-10-01','2025-11-15',55.00),
(22,1,2,'2025-10-01','2025-11-15',50.00),
(23,1,3,'2025-10-01','2025-11-15',120.00),
(24,1,4,'2025-10-01','2025-11-15',115.00),
(25,1,1,'2025-11-16','2025-11-28',65.00),
(26,1,2,'2025-11-16','2025-11-28',60.00),
(27,1,3,'2025-11-16','2025-11-28',115.00),
(28,1,4,'2025-11-16','2025-11-28',100.00),
(29,1,1,'2025-11-29','2025-12-31',75.00),
(30,1,2,'2025-11-29','2025-12-31',73.00),
(31,1,3,'2025-11-29','2025-12-31',130.00),
(32,1,4,'2025-11-29','2025-12-31',135.00),
(33,2,1,'2025-01-01','2025-03-31',75.00),
(34,2,2,'2025-01-01','2025-03-31',70.00),
(35,2,3,'2025-01-01','2025-03-31',130.00),
(36,2,4,'2025-01-01','2025-03-31',120.00),
(37,2,1,'2025-04-01','2025-06-30',70.00),
(38,2,2,'2025-04-01','2025-06-30',67.00),
(39,2,3,'2025-04-01','2025-06-30',120.00),
(40,2,4,'2025-04-01','2025-06-30',115.00),
(41,2,1,'2025-07-01','2025-09-30',80.00),
(42,2,2,'2025-07-01','2025-09-30',77.00),
(43,2,3,'2025-07-01','2025-09-30',110.00),
(44,2,4,'2025-07-01','2025-09-30',135.00),
(45,2,1,'2025-10-01','2025-11-15',65.00),
(46,2,2,'2025-10-01','2025-11-15',60.00),
(47,2,3,'2025-10-01','2025-11-15',115.00),
(48,2,4,'2025-10-01','2025-11-15',125.00),
(49,2,1,'2025-11-16','2025-11-28',75.00),
(50,2,2,'2025-11-16','2025-11-28',70.00),
(51,2,3,'2025-11-16','2025-11-28',120.00),
(52,2,4,'2025-11-16','2025-11-28',120.00),
(53,2,1,'2025-11-29','2025-12-31',85.00),
(54,2,2,'2025-11-29','2025-12-31',83.00),
(55,2,3,'2025-11-29','2025-12-31',110.00),
(56,2,4,'2025-11-29','2025-12-31',145.00),
(57,3,1,'2025-01-01','2025-03-31',55.00),
(58,3,2,'2025-01-01','2025-03-31',65.00),
(59,3,3,'2025-01-01','2025-03-31',95.00),
(60,3,4,'2025-01-01','2025-03-31',98.00),
(61,3,1,'2025-04-01','2025-06-30',65.00),
(62,3,2,'2025-04-01','2025-06-30',60.00),
(63,3,3,'2025-04-01','2025-06-30',80.00),
(64,3,4,'2025-04-01','2025-06-30',100.00),
(65,3,1,'2025-07-01','2025-09-30',70.00),
(66,3,2,'2025-07-01','2025-09-30',68.00),
(67,3,3,'2025-07-01','2025-09-30',75.00),
(68,3,4,'2025-07-01','2025-09-30',95.00),
(69,3,1,'2025-10-01','2025-11-15',45.00),
(70,3,2,'2025-10-01','2025-11-15',55.00),
(71,3,3,'2025-10-01','2025-11-15',85.00),
(72,3,4,'2025-10-01','2025-11-15',105.00),
(73,3,1,'2025-11-16','2025-11-28',55.00),
(74,3,2,'2025-11-16','2025-11-28',62.00),
(75,3,3,'2025-11-16','2025-11-28',83.00),
(76,3,4,'2025-11-16','2025-11-28',93.00),
(77,3,1,'2025-11-29','2025-12-31',70.00),
(78,3,2,'2025-11-29','2025-12-31',72.00),
(79,3,3,'2025-11-29','2025-12-31',100.00),
(80,3,4,'2025-11-29','2025-12-31',115.00),
(81,4,1,'2025-01-01','2025-03-31',60.00),
(82,4,2,'2025-01-01','2025-03-31',75.00),
(83,4,3,'2025-01-01','2025-03-31',105.00),
(84,4,4,'2025-01-01','2025-03-31',98.00),
(85,4,1,'2025-04-01','2025-06-30',62.00),
(86,4,2,'2025-04-01','2025-06-30',70.00),
(87,4,3,'2025-04-01','2025-06-30',90.00),
(88,4,4,'2025-04-01','2025-06-30',100.00),
(89,4,1,'2025-07-01','2025-09-30',69.00),
(90,4,2,'2025-07-01','2025-09-30',78.00),
(91,4,3,'2025-07-01','2025-09-30',85.00),
(92,4,4,'2025-07-01','2025-09-30',95.00),
(93,4,1,'2025-10-01','2025-11-15',55.00),
(94,4,2,'2025-10-01','2025-11-15',65.00),
(95,4,3,'2025-10-01','2025-11-15',95.00),
(96,4,4,'2025-10-01','2025-11-15',105.00),
(97,4,1,'2025-11-16','2025-11-28',70.00),
(98,4,2,'2025-11-16','2025-11-28',72.00),
(99,4,3,'2025-11-16','2025-11-28',93.00),
(100,4,4,'2025-11-16','2025-11-28',93.00),
(101,4,1,'2025-11-29','2025-12-31',78.00),
(102,4,2,'2025-11-29','2025-12-31',82.00),
(103,4,3,'2025-11-29','2025-12-31',110.00),
(104,4,4,'2025-11-29','2025-12-31',115.00);
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
  PRIMARY KEY (`id_tipo_habitacion`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipo_habitaciones`
--

LOCK TABLES `tipo_habitaciones` WRITE;
/*!40000 ALTER TABLE `tipo_habitaciones` DISABLE KEYS */;
INSERT INTO `tipo_habitaciones` VALUES
(1,'Habitación 1 persona'),
(2,'Habitación 2 personas'),
(3,'Habitación 3 personas'),
(4,'Habitación 4 personas');
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
  `ubicacion` varchar(100) DEFAULT NULL,
  `correo` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_turista`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `turistas`
--

LOCK TABLES `turistas` WRITE;
/*!40000 ALTER TABLE `turistas` DISABLE KEYS */;
INSERT INTO `turistas` VALUES
(1,'María','González','584123456789','Caracas','maria.gonzalez@email.com'),
(2,'Carlos','Rodríguez','584147852369','Valencia','carlos.rodriguez@email.com'),
(3,'Ana','Pérez','584169874123','Maracaibo','ana.perez@email.com'),
(4,'Luis','Martínez','584135792468','Barquisimeto','luis.martinez@email.com');
/*!40000 ALTER TABLE `turistas` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-10-28 22:48:48
