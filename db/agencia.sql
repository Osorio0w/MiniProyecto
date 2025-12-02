-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 02, 2025 at 02:58 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `agencia`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_generar_presupuesto` (IN `p_id_tarifario` INT, IN `p_personas` INT, IN `p_fecha_desde` DATE, IN `p_fecha_hasta` DATE, OUT `p_id_presupuesto` INT, OUT `p_total` DECIMAL(10,2))   BEGIN
    DECLARE v_noches INT;
    DECLARE v_precio DECIMAL(10,2);

    SET v_noches = DATEDIFF(p_fecha_hasta, p_fecha_desde);
    
    IF v_noches = 0 THEN SET v_noches = 1; END IF;

    SELECT precio INTO v_precio 
    FROM tarifarios 
    WHERE id_tarifario = p_id_tarifario;

    SET p_total = (v_precio * v_noches) * p_personas;

    INSERT INTO presupuesto_reservas(id_tarifario, fecha_reserva_desde, fecha_reserva_hasta)
    VALUES (p_id_tarifario, p_fecha_desde, p_fecha_hasta);

    SET p_id_presupuesto = LAST_INSERT_ID();

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `hoteles`
--

CREATE TABLE `hoteles` (
  `id_hotel` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `ubicacion` varchar(200) DEFAULT NULL,
  `rif_hotel` varchar(20) DEFAULT NULL,
  `actualizado_en` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hoteles`
--

INSERT INTO `hoteles` (`id_hotel`, `nombre`, `ubicacion`, `rif_hotel`, `actualizado_en`) VALUES
(1, 'Hotel Sunsol Punta Blanca', 'Punta Blanca, Venezuela', 'J-12345698-9', '2025-11-14 00:44:47'),
(2, 'Hotel Sunsol Ecoland', 'Ecoland, Venezuela', 'J-98765432-1', '2025-11-14 00:44:47'),
(3, 'Hotel Hesperia', 'Caracas, Venezuela', 'J-45678912-3', '2025-11-14 00:44:47'),
(4, 'Hotel Agua Dorada', 'Margarita, Venezuela', 'J-32165497-8', '2025-11-14 00:44:47');

-- --------------------------------------------------------

--
-- Table structure for table `presupuesto_reservas`
--

CREATE TABLE `presupuesto_reservas` (
  `id_presupuesto_reserva` int(11) NOT NULL,
  `id_tarifario` int(11) NOT NULL,
  `fecha_reserva_desde` date NOT NULL,
  `fecha_reserva_hasta` date NOT NULL,
  `cantidad_noches` int(11) DEFAULT NULL,
  `cantidad_dias` int(11) DEFAULT NULL,
  `creacion_registro` timestamp NULL DEFAULT current_timestamp()
) ;

--
-- Dumping data for table `presupuesto_reservas`
--

INSERT INTO `presupuesto_reservas` (`id_presupuesto_reserva`, `id_tarifario`, `fecha_reserva_desde`, `fecha_reserva_hasta`, `cantidad_noches`, `cantidad_dias`, `creacion_registro`) VALUES
(1, 2, '2025-02-10', '2025-02-15', 5, 6, '2025-10-30 23:57:59'),
(2, 25, '2025-05-12', '2025-05-17', 5, 6, '2025-10-30 23:57:59'),
(3, 51, '2025-08-20', '2025-08-25', 5, 6, '2025-10-30 23:57:59'),
(4, 88, '2025-11-20', '2025-11-24', 4, 5, '2025-10-30 23:57:59'),
(5, 18, '2025-11-18', '2025-11-22', 4, 5, '2025-10-30 23:57:59'),
(6, 94, '2025-12-24', '2025-12-29', 5, 6, '2025-10-31 00:28:28'),
(7, 94, '2025-12-24', '2025-12-29', 5, 6, '2025-10-31 00:28:31'),
(8, 1, '2025-02-01', '2025-02-05', 3, 4, '2025-11-14 00:49:18'),
(9, 3, '2025-03-01', '2025-03-05', 4, 5, '2025-11-30 18:18:42'),
(10, 15, '2025-11-03', '2025-11-04', 1, 2, '2025-12-01 03:57:10'),
(12, 24, '2025-12-03', '2025-12-05', 2, 3, '2025-12-01 04:05:03'),
(13, 1, '2025-12-03', '2025-12-04', 1, 2, '2025-12-01 04:24:13'),
(14, 1, '2025-12-03', '2025-12-04', 1, 2, '2025-12-01 04:29:29'),
(15, 1, '2025-12-01', '2025-12-03', 2, 3, '2025-12-01 04:35:27'),
(16, 21, '2025-12-02', '2025-12-04', 2, 3, '2025-12-01 04:43:51'),
(17, 70, '2025-12-03', '2025-12-06', 3, 4, '2025-12-01 05:23:57'),
(18, 48, '2025-12-02', '2025-12-31', 29, 30, '2025-12-01 05:27:21'),
(19, 22, '2025-12-01', '2025-12-02', 1, 2, '2025-12-02 00:04:13'),
(20, 45, '2025-12-01', '2025-12-08', 7, 8, '2025-12-02 00:07:43');

--
-- Triggers `presupuesto_reservas`
--
DELIMITER $$
CREATE TRIGGER `calcular_duracion_presupuesto` BEFORE INSERT ON `presupuesto_reservas` FOR EACH ROW BEGIN
    SET NEW.cantidad_noches = DATEDIFF(NEW.fecha_reserva_hasta, NEW.fecha_reserva_desde);
    SET NEW.cantidad_dias = DATEDIFF(NEW.fecha_reserva_hasta, NEW.fecha_reserva_desde) + 1;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `reservas`
--

CREATE TABLE `reservas` (
  `id_reserva` int(11) NOT NULL,
  `id_turista` int(11) NOT NULL,
  `id_presupuesto_reserva` int(11) NOT NULL,
  `codigo_reserva` varchar(20) DEFAULT NULL,
  `monto_pagar` decimal(10,2) NOT NULL,
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp(),
  `actualizado_en` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `reservas`
--

INSERT INTO `reservas` (`id_reserva`, `id_turista`, `id_presupuesto_reserva`, `codigo_reserva`, `monto_pagar`, `creado_en`, `actualizado_en`) VALUES
(1, 1, 1, 'RES001', 300.00, '2025-11-30 17:20:58', '2025-11-30 17:20:58'),
(2, 2, 2, 'RES002', 375.00, '2025-11-30 17:20:58', '2025-11-30 17:20:58'),
(3, 3, 3, 'RES003', 475.00, '2025-11-30 17:20:58', '2025-11-30 17:20:58'),
(4, 4, 4, 'RES004', 420.00, '2025-11-30 17:20:58', '2025-11-30 17:20:58'),
(5, 1, 5, 'RES005', 240.00, '2025-11-30 17:20:58', '2025-11-30 17:20:58'),
(6, 1, 7, 'RES006', 410.00, '2025-11-30 17:20:58', '2025-11-30 17:20:58'),
(7, 22, 15, 'RES007', 130.00, '2025-12-01 04:35:27', '2025-12-01 04:35:27'),
(8, 2, 16, 'RES008', 150.00, '2025-12-01 04:43:51', '2025-12-01 04:43:51'),
(9, 9, 17, 'RES009', 240.00, '2025-12-01 05:23:57', '2025-12-01 05:23:57'),
(10, 22, 18, 'RES010', 21820.00, '2025-12-01 05:27:21', '2025-12-01 05:27:21'),
(11, 18, 19, 'RES011', 73.00, '2025-12-02 00:04:13', '2025-12-02 00:04:13'),
(12, 18, 20, 'RES012', 695.00, '2025-12-02 00:07:43', '2025-12-02 00:07:43');

--
-- Triggers `reservas`
--
DELIMITER $$
CREATE TRIGGER `tg_codigo_reserva` BEFORE INSERT ON `reservas` FOR EACH ROW BEGIN
    DECLARE next_id INT;
    
    SELECT IFNULL(MAX(id_reserva), 0) + 1 INTO next_id FROM reservas;
    
    SET NEW.codigo_reserva = CONCAT('RES', LPAD(next_id, 3, '0'));
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tarifarios`
--

CREATE TABLE `tarifarios` (
  `id_tarifario` int(11) NOT NULL,
  `id_hotel` int(11) NOT NULL,
  `id_tipo_habitacion` int(11) NOT NULL,
  `fecha_desde` date NOT NULL,
  `fecha_hasta` date NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `actualizado_en` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp()
) ;

--
-- Dumping data for table `tarifarios`
--

INSERT INTO `tarifarios` (`id_tarifario`, `id_hotel`, `id_tipo_habitacion`, `fecha_desde`, `fecha_hasta`, `precio`, `actualizado_en`, `creado_en`) VALUES
(1, 1, 1, '2025-01-01', '2025-03-31', 65.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(2, 1, 2, '2025-01-01', '2025-03-31', 60.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(3, 1, 3, '2025-01-01', '2025-03-31', 120.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(4, 1, 4, '2025-01-01', '2025-03-31', 111.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(5, 1, 1, '2025-04-01', '2025-06-30', 60.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(6, 1, 2, '2025-04-01', '2025-06-30', 57.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(7, 1, 3, '2025-04-01', '2025-06-30', 110.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(8, 1, 4, '2025-04-01', '2025-06-30', 125.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(9, 1, 1, '2025-07-01', '2025-09-30', 70.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(10, 1, 2, '2025-07-01', '2025-09-30', 67.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(11, 1, 3, '2025-07-01', '2025-09-30', 105.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(12, 1, 4, '2025-07-01', '2025-09-30', 130.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(13, 1, 1, '2025-10-01', '2025-11-15', 55.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(14, 1, 2, '2025-10-01', '2025-11-15', 50.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(15, 1, 3, '2025-10-01', '2025-11-15', 120.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(16, 1, 4, '2025-10-01', '2025-11-15', 115.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(17, 1, 1, '2025-11-16', '2025-11-28', 65.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(18, 1, 2, '2025-11-16', '2025-11-28', 60.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(19, 1, 3, '2025-11-16', '2025-11-28', 115.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(20, 1, 4, '2025-11-16', '2025-11-28', 100.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(21, 1, 1, '2025-11-29', '2025-12-31', 75.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(22, 1, 2, '2025-11-29', '2025-12-31', 73.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(23, 1, 3, '2025-11-29', '2025-12-31', 130.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(24, 1, 4, '2025-11-29', '2025-12-31', 135.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(25, 2, 1, '2025-01-01', '2025-03-31', 75.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(26, 2, 2, '2025-01-01', '2025-03-31', 70.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(27, 2, 3, '2025-01-01', '2025-03-31', 130.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(28, 2, 4, '2025-01-01', '2025-03-31', 120.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(29, 2, 1, '2025-04-01', '2025-06-30', 70.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(30, 2, 2, '2025-04-01', '2025-06-30', 67.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(31, 2, 3, '2025-04-01', '2025-06-30', 120.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(32, 2, 4, '2025-04-01', '2025-06-30', 115.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(33, 2, 1, '2025-07-01', '2025-09-30', 80.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(34, 2, 2, '2025-07-01', '2025-09-30', 77.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(35, 2, 3, '2025-07-01', '2025-09-30', 110.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(36, 2, 4, '2025-07-01', '2025-09-30', 135.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(37, 2, 1, '2025-10-01', '2025-11-15', 65.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(38, 2, 2, '2025-10-01', '2025-11-15', 60.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(39, 2, 3, '2025-10-01', '2025-11-15', 115.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(40, 2, 4, '2025-10-01', '2025-11-15', 125.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(41, 2, 1, '2025-11-16', '2025-11-28', 75.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(42, 2, 2, '2025-11-16', '2025-11-28', 70.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(43, 2, 3, '2025-11-16', '2025-11-28', 120.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(44, 2, 4, '2025-11-16', '2025-11-28', 120.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(45, 2, 1, '2025-11-29', '2025-12-31', 85.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(46, 2, 2, '2025-11-29', '2025-12-31', 83.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(47, 2, 3, '2025-11-29', '2025-12-31', 110.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(48, 2, 4, '2025-11-29', '2025-12-31', 145.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(49, 3, 1, '2025-01-01', '2025-03-31', 55.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(50, 3, 2, '2025-01-01', '2025-03-31', 65.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(51, 3, 3, '2025-01-01', '2025-03-31', 95.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(52, 3, 4, '2025-01-01', '2025-03-31', 98.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(53, 3, 1, '2025-04-01', '2025-06-30', 65.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(54, 3, 2, '2025-04-01', '2025-06-30', 60.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(55, 3, 3, '2025-04-01', '2025-06-30', 80.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(56, 3, 4, '2025-04-01', '2025-06-30', 100.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(57, 3, 1, '2025-07-01', '2025-09-30', 70.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(58, 3, 2, '2025-07-01', '2025-09-30', 68.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(59, 3, 3, '2025-07-01', '2025-09-30', 75.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(60, 3, 4, '2025-07-01', '2025-09-30', 95.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(61, 3, 1, '2025-10-01', '2025-11-15', 45.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(62, 3, 2, '2025-10-01', '2025-11-15', 55.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(63, 3, 3, '2025-10-01', '2025-11-15', 85.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(64, 3, 4, '2025-10-01', '2025-11-15', 105.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(65, 3, 1, '2025-11-16', '2025-11-28', 55.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(66, 3, 2, '2025-11-16', '2025-11-28', 62.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(67, 3, 3, '2025-11-16', '2025-11-28', 83.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(68, 3, 4, '2025-11-16', '2025-11-28', 93.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(69, 3, 1, '2025-11-29', '2025-12-31', 70.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(70, 3, 2, '2025-11-29', '2025-12-31', 72.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(71, 3, 3, '2025-11-29', '2025-12-31', 100.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(72, 3, 4, '2025-11-29', '2025-12-31', 115.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(73, 4, 1, '2025-01-01', '2025-03-31', 60.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(74, 4, 2, '2025-01-01', '2025-03-31', 75.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(75, 4, 3, '2025-01-01', '2025-03-31', 105.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(76, 4, 4, '2025-01-01', '2025-03-31', 98.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(77, 4, 1, '2025-04-01', '2025-06-30', 62.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(78, 4, 2, '2025-04-01', '2025-06-30', 70.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(79, 4, 3, '2025-04-01', '2025-06-30', 90.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(80, 4, 4, '2025-04-01', '2025-06-30', 100.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(81, 4, 1, '2025-07-01', '2025-09-30', 69.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(82, 4, 2, '2025-07-01', '2025-09-30', 78.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(83, 4, 3, '2025-07-01', '2025-09-30', 85.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(84, 4, 4, '2025-07-01', '2025-09-30', 95.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(85, 4, 1, '2025-10-01', '2025-11-15', 55.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(86, 4, 2, '2025-10-01', '2025-11-15', 65.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(87, 4, 3, '2025-10-01', '2025-11-15', 95.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(88, 4, 4, '2025-10-01', '2025-11-15', 105.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(89, 4, 1, '2025-11-16', '2025-11-28', 70.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(90, 4, 2, '2025-11-16', '2025-11-28', 72.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(91, 4, 3, '2025-11-16', '2025-11-28', 93.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(92, 4, 4, '2025-11-16', '2025-11-28', 93.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(93, 4, 1, '2025-11-29', '2025-12-31', 78.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(94, 4, 2, '2025-11-29', '2025-12-31', 82.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(95, 4, 3, '2025-11-29', '2025-12-31', 110.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20'),
(96, 4, 4, '2025-11-29', '2025-12-31', 115.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20');

-- --------------------------------------------------------

--
-- Table structure for table `tipo_documentos`
--

CREATE TABLE `tipo_documentos` (
  `id_tipo_documento` int(11) NOT NULL,
  `codigo` varchar(10) NOT NULL,
  `descripcion` varchar(50) NOT NULL,
  `pais` varchar(50) DEFAULT 'Venezuela'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tipo_documentos`
--

INSERT INTO `tipo_documentos` (`id_tipo_documento`, `codigo`, `descripcion`, `pais`) VALUES
(1, 'V', 'Cédula de Identidad', 'Venezuela'),
(2, 'E', 'Cédula de Extranjería', 'Varios'),
(3, 'P', 'Pasaporte', 'Varios'),
(4, 'J', 'RIF Jurídico', 'Venezuela'),
(5, 'G', 'RIF Gobierno', 'Venezuela');

-- --------------------------------------------------------

--
-- Table structure for table `tipo_habitaciones`
--

CREATE TABLE `tipo_habitaciones` (
  `id_tipo_habitacion` int(11) NOT NULL,
  `descripcion` varchar(50) NOT NULL,
  `cantidad_personas` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tipo_habitaciones`
--

INSERT INTO `tipo_habitaciones` (`id_tipo_habitacion`, `descripcion`, `cantidad_personas`) VALUES
(1, 'Habitacion tipo 1', 1),
(2, 'Habitacion tipo 2', 2),
(3, 'Habitacion tipo 3', 3),
(4, 'Habitacion tipo 4', 4);

-- --------------------------------------------------------

--
-- Table structure for table `turistas`
--

CREATE TABLE `turistas` (
  `id_turista` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `apellido` varchar(50) NOT NULL,
  `telefono` varchar(15) DEFAULT NULL,
  `ubicacion` varchar(200) DEFAULT NULL,
  `correo` varchar(100) DEFAULT NULL,
  `actualizado_en` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp(),
  `id_tipo_documento` int(11) NOT NULL,
  `numero_documento` varchar(20) NOT NULL,
  `activo` tinyint(1) DEFAULT 1
) ;

--
-- Dumping data for table `turistas`
--

INSERT INTO `turistas` (`id_turista`, `nombre`, `apellido`, `telefono`, `ubicacion`, `correo`, `actualizado_en`, `creado_en`, `id_tipo_documento`, `numero_documento`, `activo`) VALUES
(1, 'María', 'González', '+584141234568', 'Caracas', 'maria.gonzalez@email.com', '2025-11-30 19:07:32', '2025-11-30 17:21:55', 1, '30919870', 1),
(2, 'Carlos', 'López', '+584148765432', 'Valencia', 'carlos.lopez@email.com', '2025-11-30 19:07:32', '2025-11-30 17:21:55', 1, '30919871', 1),
(3, 'Ana', 'Martínez', '+584147896541', 'Maracaibo', 'ana.martinez@email.com', '2025-11-30 19:07:32', '2025-11-30 17:21:55', 1, '30919872', 1),
(4, 'Pedro', 'Ramírez', '+584143215678', 'Barquisimeto', 'pedro.ramirez@email.com', '2025-11-30 19:07:32', '2025-11-30 17:21:55', 1, '30919873', 1),
(5, 'Laura', 'Pérez', '+584147896325', 'Caracas', 'laura.perez@email.com', '2025-11-30 19:08:40', '2025-11-30 19:08:40', 1, 'V-12345678', 1),
(7, 'Gino', 'Cova', '0412342562', 'La Asuncions', 'Gino@gmail.cova', '2025-12-01 02:11:34', '2025-12-01 01:19:31', 1, '31571886', 0),
(8, 'Ana', 'Pérez', '0414-1111111', 'Caracas', 'ana.perez@gmail.com', '2025-12-01 02:37:45', '2025-12-01 02:37:45', 1, '11111111', 1),
(9, 'Luis', 'Rodríguez', '0412-2222222', 'Valencia', 'luis.rod@hotmail.com', '2025-12-01 02:37:45', '2025-12-01 02:37:45', 1, '12222222', 1),
(10, 'Carmen', 'Díaz', '0416-3333333', 'Maracaibo', 'carmen.d@yahoo.com', '2025-12-01 02:37:45', '2025-12-01 02:37:45', 1, '13333333', 1),
(11, 'Pedro', 'Morales', '0424-4444444', 'Barquisimeto', 'pedro.m@outlook.com', '2025-12-01 02:37:45', '2025-12-01 02:37:45', 1, '14444444', 1),
(12, 'Sofía', 'Vergara', '0414-5555555', 'Mérida', 'sofia.v@gmail.com', '2025-12-01 02:37:45', '2025-12-01 02:37:45', 1, '15555555', 1),
(13, 'Miguel', 'Cabrera', '0412-6666666', 'Maracay', 'miguel.c@beisbol.com', '2025-12-01 02:37:45', '2025-12-01 02:37:45', 1, '16666666', 1),
(14, 'Elena', 'Gómez', '0416-7777777', 'Porlamar', 'elena.g@gmail.com', '2025-12-01 02:37:45', '2025-12-01 02:37:45', 1, '17777777', 1),
(15, 'Ricardo', 'Montaner', '0424-8888888', 'Maracaibo', 'ricardo.m@musica.com', '2025-12-01 02:37:45', '2025-12-01 02:37:45', 1, '18888888', 1),
(16, 'Valentina', 'Quintero', '0414-9999999', 'Caracas', 'valentina.q@viajes.com', '2025-12-01 02:37:45', '2025-12-01 02:37:45', 1, '19999999', 1),
(17, 'Simón', 'Díaz', '0412-0000001', 'Apure', 'simon.d@llano.com', '2025-12-01 02:37:45', '2025-12-01 02:37:45', 1, '20000001', 1),
(18, 'Andrés', 'Galarraga', '0416-0000002', 'Caracas', 'gato.g@deporte.com', '2025-12-01 02:37:45', '2025-12-01 02:37:45', 1, '20000002', 1),
(19, 'Maite', 'Delgado', '0424-0000003', 'Barcelona', 'maite.d@show.com', '2025-12-01 02:37:45', '2025-12-01 02:37:45', 1, '20000003', 1),
(20, 'Edgar', 'Ramírez', '0414-0000004', 'San Cristóbal', 'edgar.r@cine.com', '2025-12-01 02:37:45', '2025-12-01 02:37:45', 1, '20000004', 1),
(21, 'Gaby', 'Espino', '0412-0000005', 'Caracas', 'gaby.e@novela.com', '2025-12-01 02:37:45', '2025-12-01 02:37:45', 1, '20000005', 1),
(22, 'Chyno', 'Miranda', '0416-0000006', 'La Guaira', 'chyno.m@musica.com', '2025-12-01 02:37:45', '2025-12-01 02:37:45', 1, '20000006', 1);

-- --------------------------------------------------------

--
-- Table structure for table `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL,
  `usuario` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `nombre_completo` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `usuario`, `password`, `nombre_completo`) VALUES
(2, 'admin', '$2y$10$3DmGmGuOl.KYE5dYR0qVsuPlxsKU25kS8jfKwcF8teIPa4OxaSb26', 'Gerente General');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `hoteles`
--
ALTER TABLE `hoteles`
  ADD PRIMARY KEY (`id_hotel`);

--
-- Indexes for table `presupuesto_reservas`
--
ALTER TABLE `presupuesto_reservas`
  ADD PRIMARY KEY (`id_presupuesto_reserva`),
  ADD KEY `fk_presupuesto_tarifario` (`id_tarifario`),
  ADD KEY `idx_presupuesto_fechas` (`fecha_reserva_desde`,`fecha_reserva_hasta`);

--
-- Indexes for table `reservas`
--
ALTER TABLE `reservas`
  ADD PRIMARY KEY (`id_reserva`),
  ADD UNIQUE KEY `codigo_reserva` (`codigo_reserva`),
  ADD KEY `fk_reservas_turista` (`id_turista`),
  ADD KEY `fk_reservas_presupuesto` (`id_presupuesto_reserva`),
  ADD KEY `idx_reservas_codigo` (`codigo_reserva`);

--
-- Indexes for table `tarifarios`
--
ALTER TABLE `tarifarios`
  ADD PRIMARY KEY (`id_tarifario`),
  ADD KEY `fk_tarifarios_hotel` (`id_hotel`),
  ADD KEY `fk_tarifarios_tipo_habitacion` (`id_tipo_habitacion`),
  ADD KEY `idx_tarifarios_fechas` (`fecha_desde`,`fecha_hasta`);

--
-- Indexes for table `tipo_documentos`
--
ALTER TABLE `tipo_documentos`
  ADD PRIMARY KEY (`id_tipo_documento`),
  ADD UNIQUE KEY `codigo` (`codigo`);

--
-- Indexes for table `tipo_habitaciones`
--
ALTER TABLE `tipo_habitaciones`
  ADD PRIMARY KEY (`id_tipo_habitacion`);

--
-- Indexes for table `turistas`
--
ALTER TABLE `turistas`
  ADD PRIMARY KEY (`id_turista`),
  ADD UNIQUE KEY `uk_turista_documento` (`id_tipo_documento`,`numero_documento`),
  ADD KEY `idx_turistas_email` (`correo`);

--
-- Indexes for table `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `usuario` (`usuario`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `hoteles`
--
ALTER TABLE `hoteles`
  MODIFY `id_hotel` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `presupuesto_reservas`
--
ALTER TABLE `presupuesto_reservas`
  MODIFY `id_presupuesto_reserva` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `reservas`
--
ALTER TABLE `reservas`
  MODIFY `id_reserva` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `tarifarios`
--
ALTER TABLE `tarifarios`
  MODIFY `id_tarifario` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tipo_documentos`
--
ALTER TABLE `tipo_documentos`
  MODIFY `id_tipo_documento` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `tipo_habitaciones`
--
ALTER TABLE `tipo_habitaciones`
  MODIFY `id_tipo_habitacion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `turistas`
--
ALTER TABLE `turistas`
  MODIFY `id_turista` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `presupuesto_reservas`
--
ALTER TABLE `presupuesto_reservas`
  ADD CONSTRAINT `fk_presupuesto_tarifario` FOREIGN KEY (`id_tarifario`) REFERENCES `tarifarios` (`id_tarifario`);

--
-- Constraints for table `reservas`
--
ALTER TABLE `reservas`
  ADD CONSTRAINT `fk_reservas_presupuesto` FOREIGN KEY (`id_presupuesto_reserva`) REFERENCES `presupuesto_reservas` (`id_presupuesto_reserva`),
  ADD CONSTRAINT `fk_reservas_turista` FOREIGN KEY (`id_turista`) REFERENCES `turistas` (`id_turista`);

--
-- Constraints for table `tarifarios`
--
ALTER TABLE `tarifarios`
  ADD CONSTRAINT `fk_tarifarios_hotel` FOREIGN KEY (`id_hotel`) REFERENCES `hoteles` (`id_hotel`),
  ADD CONSTRAINT `fk_tarifarios_tipo_habitacion` FOREIGN KEY (`id_tipo_habitacion`) REFERENCES `tipo_habitaciones` (`id_tipo_habitacion`);

--
-- Constraints for table `turistas`
--
ALTER TABLE `turistas`
  ADD CONSTRAINT `fk_turista_tipo_documento` FOREIGN KEY (`id_tipo_documento`) REFERENCES `tipo_documentos` (`id_tipo_documento`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
