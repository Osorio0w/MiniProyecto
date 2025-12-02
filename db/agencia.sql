-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 02, 2025 at 07:04 AM
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
  `actualizado_en` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `activo` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hoteles`
--

INSERT INTO `hoteles` (`id_hotel`, `nombre`, `ubicacion`, `rif_hotel`, `actualizado_en`, `activo`) VALUES
(1, 'Hotel Sunsol Punta Blanca', 'Punta Blanca, Venezuela', 'J-12345698-9', '2025-11-14 00:44:47', 1),
(2, 'Hotel Sunsol Ecoland', 'Ecoland, Venezuela', 'J-98765432-1', '2025-11-14 00:44:47', 1),
(3, 'Hotel Hesperia', 'Caracas, Venezuela', 'J-45678912-3', '2025-11-14 00:44:47', 1),
(4, 'Hotel Agua Dorada', 'Margarita, Venezuela', 'J-32165497-8', '2025-11-14 00:44:47', 1);

-- --------------------------------------------------------

--
-- Table structure for table `metodos_pago`
--

CREATE TABLE `metodos_pago` (
  `id_metodo_pago` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `metodos_pago`
--

INSERT INTO `metodos_pago` (`id_metodo_pago`, `nombre`) VALUES
(1, 'Efectivo ($)'),
(2, 'Zelle'),
(3, 'Pago Móvil'),
(4, 'Transferencia'),
(5, 'Punto de Venta'),
(6, 'No Especificado');

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
(20, 45, '2025-12-01', '2025-12-08', 7, 8, '2025-12-02 00:07:43'),
(21, 22, '2025-11-30', '2025-12-03', 3, 4, '2025-12-02 03:48:46'),
(22, 22, '2025-12-06', '2025-12-07', 1, 2, '2025-12-02 04:24:54'),
(23, 22, '2025-12-05', '2025-12-06', 1, 2, '2025-12-02 04:56:31');

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
  `id_metodo_pago` int(11) NOT NULL DEFAULT 1,
  `referencia_pago` varchar(50) DEFAULT NULL,
  `codigo_reserva` varchar(20) DEFAULT NULL,
  `monto_pagar` decimal(10,2) NOT NULL,
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp(),
  `actualizado_en` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `reservas`
--

INSERT INTO `reservas` (`id_reserva`, `id_turista`, `id_presupuesto_reserva`, `id_metodo_pago`, `referencia_pago`, `codigo_reserva`, `monto_pagar`, `creado_en`, `actualizado_en`) VALUES
(1, 1, 1, 6, 'N/A', 'RES001', 300.00, '2025-11-30 17:20:58', '2025-12-02 03:56:27'),
(2, 2, 2, 6, 'N/A', 'RES002', 375.00, '2025-11-30 17:20:58', '2025-12-02 03:56:27'),
(3, 3, 3, 6, 'N/A', 'RES003', 475.00, '2025-11-30 17:20:58', '2025-12-02 03:56:27'),
(4, 4, 4, 6, 'N/A', 'RES004', 420.00, '2025-11-30 17:20:58', '2025-12-02 03:56:27'),
(5, 1, 5, 6, 'N/A', 'RES005', 240.00, '2025-11-30 17:20:58', '2025-12-02 03:56:27'),
(6, 1, 7, 6, 'N/A', 'RES006', 410.00, '2025-11-30 17:20:58', '2025-12-02 03:56:27'),
(7, 22, 15, 6, 'N/A', 'RES007', 130.00, '2025-12-01 04:35:27', '2025-12-02 03:56:27'),
(8, 2, 16, 6, 'N/A', 'RES008', 150.00, '2025-12-01 04:43:51', '2025-12-02 03:56:27'),
(9, 9, 17, 6, 'N/A', 'RES009', 240.00, '2025-12-01 05:23:57', '2025-12-02 03:56:27'),
(10, 22, 18, 6, 'N/A', 'RES010', 21820.00, '2025-12-01 05:27:21', '2025-12-02 03:56:27'),
(11, 18, 19, 6, 'N/A', 'RES011', 73.00, '2025-12-02 00:04:13', '2025-12-02 03:56:27'),
(12, 18, 20, 6, 'N/A', 'RES012', 695.00, '2025-12-02 00:07:43', '2025-12-02 03:56:27'),
(13, 8, 21, 3, '0827', 'RES013', 319.00, '2025-12-02 03:48:46', '2025-12-02 03:48:46'),
(14, 3, 22, 1, '', 'RES014', 123.00, '2025-12-02 04:24:54', '2025-12-02 04:24:54'),
(15, 3, 23, 3, '5551', 'RES015', 173.00, '2025-12-02 04:56:31', '2025-12-02 04:56:31');

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
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp(),
  `activo` tinyint(1) DEFAULT 1
) ;

--
-- Dumping data for table `tarifarios`
--

INSERT INTO `tarifarios` (`id_tarifario`, `id_hotel`, `id_tipo_habitacion`, `fecha_desde`, `fecha_hasta`, `precio`, `actualizado_en`, `creado_en`, `activo`) VALUES
(1, 1, 1, '2025-01-01', '2025-03-31', 65.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(2, 1, 2, '2025-01-01', '2025-03-31', 60.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(3, 1, 3, '2025-01-01', '2025-03-31', 120.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(4, 1, 4, '2025-01-01', '2025-03-31', 111.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(5, 1, 1, '2025-04-01', '2025-06-30', 60.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(6, 1, 2, '2025-04-01', '2025-06-30', 57.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(7, 1, 3, '2025-04-01', '2025-06-30', 110.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(8, 1, 4, '2025-04-01', '2025-06-30', 125.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(9, 1, 1, '2025-07-01', '2025-09-30', 70.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(10, 1, 2, '2025-07-01', '2025-09-30', 67.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(11, 1, 3, '2025-07-01', '2025-09-30', 105.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(12, 1, 4, '2025-07-01', '2025-09-30', 130.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(13, 1, 1, '2025-10-01', '2025-11-15', 55.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(14, 1, 2, '2025-10-01', '2025-11-15', 50.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(15, 1, 3, '2025-10-01', '2025-11-15', 120.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(16, 1, 4, '2025-10-01', '2025-11-15', 115.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(17, 1, 1, '2025-11-16', '2025-11-28', 65.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(18, 1, 2, '2025-11-16', '2025-11-28', 60.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(19, 1, 3, '2025-11-16', '2025-11-28', 115.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(20, 1, 4, '2025-11-16', '2025-11-28', 100.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(21, 1, 1, '2025-11-29', '2025-12-31', 75.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(22, 1, 2, '2025-11-29', '2025-12-31', 73.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(23, 1, 3, '2025-11-29', '2025-12-31', 130.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(24, 1, 4, '2025-11-29', '2025-12-31', 135.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(25, 2, 1, '2025-01-01', '2025-03-31', 75.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(26, 2, 2, '2025-01-01', '2025-03-31', 70.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(27, 2, 3, '2025-01-01', '2025-03-31', 130.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(28, 2, 4, '2025-01-01', '2025-03-31', 120.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(29, 2, 1, '2025-04-01', '2025-06-30', 70.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(30, 2, 2, '2025-04-01', '2025-06-30', 67.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(31, 2, 3, '2025-04-01', '2025-06-30', 120.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(32, 2, 4, '2025-04-01', '2025-06-30', 115.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(33, 2, 1, '2025-07-01', '2025-09-30', 80.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(34, 2, 2, '2025-07-01', '2025-09-30', 77.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(35, 2, 3, '2025-07-01', '2025-09-30', 110.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(36, 2, 4, '2025-07-01', '2025-09-30', 135.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(37, 2, 1, '2025-10-01', '2025-11-15', 65.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(38, 2, 2, '2025-10-01', '2025-11-15', 60.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(39, 2, 3, '2025-10-01', '2025-11-15', 115.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(40, 2, 4, '2025-10-01', '2025-11-15', 125.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(41, 2, 1, '2025-11-16', '2025-11-28', 75.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(42, 2, 2, '2025-11-16', '2025-11-28', 70.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(43, 2, 3, '2025-11-16', '2025-11-28', 120.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(44, 2, 4, '2025-11-16', '2025-11-28', 120.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(45, 2, 1, '2025-11-29', '2025-12-31', 85.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(46, 2, 2, '2025-11-29', '2025-12-31', 83.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(47, 2, 3, '2025-11-29', '2025-12-31', 110.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(48, 2, 4, '2025-11-29', '2025-12-31', 145.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(49, 3, 1, '2025-01-01', '2025-03-31', 55.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(50, 3, 2, '2025-01-01', '2025-03-31', 65.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(51, 3, 3, '2025-01-01', '2025-03-31', 95.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(52, 3, 4, '2025-01-01', '2025-03-31', 98.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(53, 3, 1, '2025-04-01', '2025-06-30', 65.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(54, 3, 2, '2025-04-01', '2025-06-30', 60.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(55, 3, 3, '2025-04-01', '2025-06-30', 80.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(56, 3, 4, '2025-04-01', '2025-06-30', 100.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(57, 3, 1, '2025-07-01', '2025-09-30', 70.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(58, 3, 2, '2025-07-01', '2025-09-30', 68.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(59, 3, 3, '2025-07-01', '2025-09-30', 75.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(60, 3, 4, '2025-07-01', '2025-09-30', 95.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(61, 3, 1, '2025-10-01', '2025-11-15', 45.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(62, 3, 2, '2025-10-01', '2025-11-15', 55.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(63, 3, 3, '2025-10-01', '2025-11-15', 85.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(64, 3, 4, '2025-10-01', '2025-11-15', 105.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(65, 3, 1, '2025-11-16', '2025-11-28', 55.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(66, 3, 2, '2025-11-16', '2025-11-28', 62.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(67, 3, 3, '2025-11-16', '2025-11-28', 83.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(68, 3, 4, '2025-11-16', '2025-11-28', 93.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(69, 3, 1, '2025-11-29', '2025-12-31', 70.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(70, 3, 2, '2025-11-29', '2025-12-31', 72.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(71, 3, 3, '2025-11-29', '2025-12-31', 100.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(72, 3, 4, '2025-11-29', '2025-12-31', 115.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(73, 4, 1, '2025-01-01', '2025-03-31', 60.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(74, 4, 2, '2025-01-01', '2025-03-31', 75.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(75, 4, 3, '2025-01-01', '2025-03-31', 105.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(76, 4, 4, '2025-01-01', '2025-03-31', 98.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(77, 4, 1, '2025-04-01', '2025-06-30', 62.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(78, 4, 2, '2025-04-01', '2025-06-30', 70.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(79, 4, 3, '2025-04-01', '2025-06-30', 90.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(80, 4, 4, '2025-04-01', '2025-06-30', 100.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(81, 4, 1, '2025-07-01', '2025-09-30', 69.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(82, 4, 2, '2025-07-01', '2025-09-30', 78.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(83, 4, 3, '2025-07-01', '2025-09-30', 85.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(84, 4, 4, '2025-07-01', '2025-09-30', 95.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(85, 4, 1, '2025-10-01', '2025-11-15', 55.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(86, 4, 2, '2025-10-01', '2025-11-15', 65.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(87, 4, 3, '2025-10-01', '2025-11-15', 95.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(88, 4, 4, '2025-10-01', '2025-11-15', 105.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(89, 4, 1, '2025-11-16', '2025-11-28', 70.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(90, 4, 2, '2025-11-16', '2025-11-28', 72.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(91, 4, 3, '2025-11-16', '2025-11-28', 93.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(92, 4, 4, '2025-11-16', '2025-11-28', 93.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(93, 4, 1, '2025-11-29', '2025-12-31', 78.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(94, 4, 2, '2025-11-29', '2025-12-31', 82.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(95, 4, 3, '2025-11-29', '2025-12-31', 110.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1),
(96, 4, 4, '2025-11-29', '2025-12-31', 115.00, '2025-11-14 00:44:47', '2025-11-30 17:22:20', 1);

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
  `cantidad_personas` int(11) NOT NULL,
  `activo` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tipo_habitaciones`
--

INSERT INTO `tipo_habitaciones` (`id_tipo_habitacion`, `descripcion`, `cantidad_personas`, `activo`) VALUES
(1, 'Habitacion tipo 1', 1, 1),
(2, 'Habitacion tipo 2', 2, 1),
(3, 'Habitacion tipo 3', 3, 1),
(4, 'Habitacion tipo 4', 4, 1);

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
(7, 'Gino', 'Cova', '+58412342562', 'La Asuncions', 'Gino@gmail.cova', '2025-12-02 05:49:31', '2025-12-01 01:19:31', 1, '31571886', 0),
(8, 'Ana', 'Pérez', '+584141111111', 'Caracas', 'ana.perez@gmail.com', '2025-12-02 05:49:31', '2025-12-01 02:37:45', 1, '11111111', 1),
(9, 'Luis', 'Rodríguez', '+584122222222', 'Valencia', 'luis.rod@hotmail.com', '2025-12-02 05:49:31', '2025-12-01 02:37:45', 1, '12222222', 1),
(10, 'Carmen', 'Díaz', '+584163333333', 'Maracaibo', 'carmen.d@yahoo.com', '2025-12-02 05:49:31', '2025-12-01 02:37:45', 1, '13333333', 1),
(11, 'Pedro', 'Morales', '+584244444444', 'Barquisimeto', 'pedro.m@outlook.com', '2025-12-02 05:49:31', '2025-12-01 02:37:45', 1, '14444444', 1),
(12, 'Sofía', 'Vergara', '+584145555555', 'Mérida', 'sofia.v@gmail.com', '2025-12-02 05:49:31', '2025-12-01 02:37:45', 1, '15555555', 1),
(13, 'Miguel', 'Cabrera', '+584126662666', 'Maracay', 'miguel.c@beisbol.com', '2025-12-02 05:52:38', '2025-12-01 02:37:45', 1, '16666666', 1),
(14, 'Elena', 'Gómez', '+584167777777', 'Porlamar', 'elena.g@gmail.com', '2025-12-02 05:49:31', '2025-12-01 02:37:45', 1, '17777777', 1),
(15, 'Ricardo', 'Montaner', '+584248888888', 'Maracaibo', 'ricardo.m@musica.com', '2025-12-02 05:49:31', '2025-12-01 02:37:45', 1, '18888888', 1),
(16, 'Valentina', 'Quintero', '+584149999999', 'Caracas', 'valentina.q@viajes.com', '2025-12-02 05:49:31', '2025-12-01 02:37:45', 1, '19999999', 1),
(17, 'Simón', 'Díaz', '+584120000001', 'Apure', 'simon.d@llano.com', '2025-12-02 05:49:31', '2025-12-01 02:37:45', 1, '20000001', 1),
(18, 'Andrés', 'Galarraga', '+584160000002', 'Caracas', 'gato.g@deporte.com', '2025-12-02 05:49:31', '2025-12-01 02:37:45', 1, '20000002', 1),
(19, 'Maite', 'Delgado', '+584240000003', 'Barcelona', 'maite.d@show.com', '2025-12-02 05:49:31', '2025-12-01 02:37:45', 1, '20000003', 1),
(20, 'Edgar', 'Ramírez', '+584140000004', 'San Cristóbal', 'edgar.r@cine.com', '2025-12-02 05:49:31', '2025-12-01 02:37:45', 1, '20000004', 1),
(21, 'Gaby', 'Espino', '+584120000005', 'Caracas', 'gaby.e@novela.com', '2025-12-02 05:49:31', '2025-12-01 02:37:45', 1, '20000005', 1),
(22, 'Chyno', 'Miranda', '+344160003006', 'La Guaira', 'chyno.m@musica.com', '2025-12-02 05:51:44', '2025-12-01 02:37:45', 1, '20000006', 1),
(29, 'Victor', 'Lugo', '+58412562412', 'La Asuncions', 'Victo@gmail.com', '2025-12-02 05:54:00', '2025-12-02 05:54:00', 1, '31252412521', 1);

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

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_agenda_llegadas`
-- (See below for the actual view)
--
CREATE TABLE `v_agenda_llegadas` (
`codigo_reserva` varchar(20)
,`cliente` varchar(101)
,`telefono` varchar(15)
,`hotel` varchar(100)
,`fecha_llegada` date
,`dias_faltantes` int(7)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_demanda_habitaciones`
-- (See below for the actual view)
--
CREATE TABLE `v_demanda_habitaciones` (
`tipo_habitacion` varchar(50)
,`veces_reservada` bigint(21)
,`dinero_generado` decimal(32,2)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_finanzas_diarias`
-- (See below for the actual view)
--
CREATE TABLE `v_finanzas_diarias` (
`fecha_venta` date
,`cantidad_ventas` bigint(21)
,`total_ingresos` decimal(32,2)
,`ticket_promedio` decimal(11,2)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_reservas_detallada`
-- (See below for the actual view)
--
CREATE TABLE `v_reservas_detallada` (
`id_reserva` int(11)
,`codigo_reserva` varchar(20)
,`monto_pagar` decimal(10,2)
,`creado_en` timestamp
,`referencia_pago` varchar(50)
,`id_turista` int(11)
,`cliente_nombre` varchar(50)
,`cliente_apellido` varchar(50)
,`cliente_completo` varchar(101)
,`cliente_doc` varchar(20)
,`cliente_tel` varchar(15)
,`cliente_email` varchar(100)
,`hotel_nombre` varchar(100)
,`hotel_ubicacion` varchar(200)
,`habitacion_tipo` varchar(50)
,`check_in` date
,`check_out` date
,`noches` int(7)
,`metodo_pago` varchar(50)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_stats_clientes`
-- (See below for the actual view)
--
CREATE TABLE `v_stats_clientes` (
`nombre` varchar(50)
,`apellido` varchar(50)
,`ubicacion` varchar(200)
,`viajes` bigint(21)
,`gastado` decimal(32,2)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_stats_hoteles`
-- (See below for the actual view)
--
CREATE TABLE `v_stats_hoteles` (
`hotel` varchar(100)
,`ventas` bigint(21)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_tarifas_activas`
-- (See below for the actual view)
--
CREATE TABLE `v_tarifas_activas` (
`id_tarifario` int(11)
,`id_hotel` int(11)
,`precio` decimal(10,2)
,`fecha_desde` date
,`fecha_hasta` date
,`hotel_nombre` varchar(100)
,`hotel_ubicacion` varchar(200)
,`habitacion_tipo` varchar(50)
,`capacidad` int(11)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_turistas_completo`
-- (See below for the actual view)
--
CREATE TABLE `v_turistas_completo` (
`id_turista` int(11)
,`nombre` varchar(50)
,`apellido` varchar(50)
,`telefono` varchar(15)
,`ubicacion` varchar(200)
,`correo` varchar(100)
,`actualizado_en` timestamp
,`creado_en` timestamp
,`id_tipo_documento` int(11)
,`numero_documento` varchar(20)
,`activo` tinyint(1)
,`tipo_doc_codigo` varchar(10)
,`tipo_doc_desc` varchar(50)
);

-- --------------------------------------------------------

--
-- Structure for view `v_agenda_llegadas`
--
DROP TABLE IF EXISTS `v_agenda_llegadas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_agenda_llegadas`  AS SELECT `r`.`codigo_reserva` AS `codigo_reserva`, concat(`t`.`nombre`,' ',`t`.`apellido`) AS `cliente`, `t`.`telefono` AS `telefono`, `h`.`nombre` AS `hotel`, `pr`.`fecha_reserva_desde` AS `fecha_llegada`, to_days(`pr`.`fecha_reserva_desde`) - to_days(curdate()) AS `dias_faltantes` FROM ((((`reservas` `r` join `turistas` `t` on(`r`.`id_turista` = `t`.`id_turista`)) join `presupuesto_reservas` `pr` on(`r`.`id_presupuesto_reserva` = `pr`.`id_presupuesto_reserva`)) join `tarifarios` `tr` on(`pr`.`id_tarifario` = `tr`.`id_tarifario`)) join `hoteles` `h` on(`tr`.`id_hotel` = `h`.`id_hotel`)) WHERE `pr`.`fecha_reserva_desde` >= curdate() ORDER BY `pr`.`fecha_reserva_desde` ASC ;

-- --------------------------------------------------------

--
-- Structure for view `v_demanda_habitaciones`
--
DROP TABLE IF EXISTS `v_demanda_habitaciones`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_demanda_habitaciones`  AS SELECT `th`.`descripcion` AS `tipo_habitacion`, count(`r`.`id_reserva`) AS `veces_reservada`, sum(`r`.`monto_pagar`) AS `dinero_generado` FROM (((`reservas` `r` join `presupuesto_reservas` `pr` on(`r`.`id_presupuesto_reserva` = `pr`.`id_presupuesto_reserva`)) join `tarifarios` `t` on(`pr`.`id_tarifario` = `t`.`id_tarifario`)) join `tipo_habitaciones` `th` on(`t`.`id_tipo_habitacion` = `th`.`id_tipo_habitacion`)) GROUP BY `th`.`id_tipo_habitacion` ORDER BY count(`r`.`id_reserva`) DESC ;

-- --------------------------------------------------------

--
-- Structure for view `v_finanzas_diarias`
--
DROP TABLE IF EXISTS `v_finanzas_diarias`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_finanzas_diarias`  AS SELECT cast(`reservas`.`creado_en` as date) AS `fecha_venta`, count(`reservas`.`id_reserva`) AS `cantidad_ventas`, sum(`reservas`.`monto_pagar`) AS `total_ingresos`, round(avg(`reservas`.`monto_pagar`),2) AS `ticket_promedio` FROM `reservas` GROUP BY cast(`reservas`.`creado_en` as date) ORDER BY cast(`reservas`.`creado_en` as date) DESC ;

-- --------------------------------------------------------

--
-- Structure for view `v_reservas_detallada`
--
DROP TABLE IF EXISTS `v_reservas_detallada`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_reservas_detallada`  AS SELECT `r`.`id_reserva` AS `id_reserva`, `r`.`codigo_reserva` AS `codigo_reserva`, `r`.`monto_pagar` AS `monto_pagar`, `r`.`creado_en` AS `creado_en`, `r`.`referencia_pago` AS `referencia_pago`, `t`.`id_turista` AS `id_turista`, `t`.`nombre` AS `cliente_nombre`, `t`.`apellido` AS `cliente_apellido`, concat(`t`.`nombre`,' ',`t`.`apellido`) AS `cliente_completo`, `t`.`numero_documento` AS `cliente_doc`, `t`.`telefono` AS `cliente_tel`, `t`.`correo` AS `cliente_email`, `h`.`nombre` AS `hotel_nombre`, `h`.`ubicacion` AS `hotel_ubicacion`, `th`.`descripcion` AS `habitacion_tipo`, `pr`.`fecha_reserva_desde` AS `check_in`, `pr`.`fecha_reserva_hasta` AS `check_out`, to_days(`pr`.`fecha_reserva_hasta`) - to_days(`pr`.`fecha_reserva_desde`) AS `noches`, ifnull(`mp`.`nombre`,'No Especificado') AS `metodo_pago` FROM ((((((`reservas` `r` join `turistas` `t` on(`r`.`id_turista` = `t`.`id_turista`)) join `presupuesto_reservas` `pr` on(`r`.`id_presupuesto_reserva` = `pr`.`id_presupuesto_reserva`)) join `tarifarios` `ta` on(`pr`.`id_tarifario` = `ta`.`id_tarifario`)) join `tipo_habitaciones` `th` on(`ta`.`id_tipo_habitacion` = `th`.`id_tipo_habitacion`)) join `hoteles` `h` on(`ta`.`id_hotel` = `h`.`id_hotel`)) left join `metodos_pago` `mp` on(`r`.`id_metodo_pago` = `mp`.`id_metodo_pago`)) ;

-- --------------------------------------------------------

--
-- Structure for view `v_stats_clientes`
--
DROP TABLE IF EXISTS `v_stats_clientes`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_stats_clientes`  AS SELECT `t`.`nombre` AS `nombre`, `t`.`apellido` AS `apellido`, `t`.`ubicacion` AS `ubicacion`, count(`r`.`id_reserva`) AS `viajes`, sum(`r`.`monto_pagar`) AS `gastado` FROM (`reservas` `r` join `turistas` `t` on(`r`.`id_turista` = `t`.`id_turista`)) GROUP BY `t`.`id_turista` ORDER BY sum(`r`.`monto_pagar`) DESC ;

-- --------------------------------------------------------

--
-- Structure for view `v_stats_hoteles`
--
DROP TABLE IF EXISTS `v_stats_hoteles`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_stats_hoteles`  AS SELECT `h`.`nombre` AS `hotel`, count(`r`.`id_reserva`) AS `ventas` FROM (((`reservas` `r` join `presupuesto_reservas` `pr` on(`r`.`id_presupuesto_reserva` = `pr`.`id_presupuesto_reserva`)) join `tarifarios` `t` on(`pr`.`id_tarifario` = `t`.`id_tarifario`)) join `hoteles` `h` on(`t`.`id_hotel` = `h`.`id_hotel`)) GROUP BY `h`.`id_hotel` ORDER BY count(`r`.`id_reserva`) DESC ;

-- --------------------------------------------------------

--
-- Structure for view `v_tarifas_activas`
--
DROP TABLE IF EXISTS `v_tarifas_activas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_tarifas_activas`  AS SELECT `t`.`id_tarifario` AS `id_tarifario`, `t`.`id_hotel` AS `id_hotel`, `t`.`precio` AS `precio`, `t`.`fecha_desde` AS `fecha_desde`, `t`.`fecha_hasta` AS `fecha_hasta`, `h`.`nombre` AS `hotel_nombre`, `h`.`ubicacion` AS `hotel_ubicacion`, `th`.`descripcion` AS `habitacion_tipo`, `th`.`cantidad_personas` AS `capacidad` FROM ((`tarifarios` `t` join `hoteles` `h` on(`t`.`id_hotel` = `h`.`id_hotel`)) join `tipo_habitaciones` `th` on(`t`.`id_tipo_habitacion` = `th`.`id_tipo_habitacion`)) WHERE `t`.`activo` = 1 AND `h`.`activo` = 1 ;

-- --------------------------------------------------------

--
-- Structure for view `v_turistas_completo`
--
DROP TABLE IF EXISTS `v_turistas_completo`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_turistas_completo`  AS SELECT `t`.`id_turista` AS `id_turista`, `t`.`nombre` AS `nombre`, `t`.`apellido` AS `apellido`, `t`.`telefono` AS `telefono`, `t`.`ubicacion` AS `ubicacion`, `t`.`correo` AS `correo`, `t`.`actualizado_en` AS `actualizado_en`, `t`.`creado_en` AS `creado_en`, `t`.`id_tipo_documento` AS `id_tipo_documento`, `t`.`numero_documento` AS `numero_documento`, `t`.`activo` AS `activo`, `td`.`codigo` AS `tipo_doc_codigo`, `td`.`descripcion` AS `tipo_doc_desc` FROM (`turistas` `t` join `tipo_documentos` `td` on(`t`.`id_tipo_documento` = `td`.`id_tipo_documento`)) WHERE `t`.`activo` = 1 ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `hoteles`
--
ALTER TABLE `hoteles`
  ADD PRIMARY KEY (`id_hotel`);

--
-- Indexes for table `metodos_pago`
--
ALTER TABLE `metodos_pago`
  ADD PRIMARY KEY (`id_metodo_pago`);

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
-- AUTO_INCREMENT for table `metodos_pago`
--
ALTER TABLE `metodos_pago`
  MODIFY `id_metodo_pago` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `presupuesto_reservas`
--
ALTER TABLE `presupuesto_reservas`
  MODIFY `id_presupuesto_reserva` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `reservas`
--
ALTER TABLE `reservas`
  MODIFY `id_reserva` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

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
