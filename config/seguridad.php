<?php
session_start();

if (!isset($_SESSION['id_usuario'])) {
    $ruta_login = (basename($_SERVER['PHP_SELF']) == 'index.php' && !strpos($_SERVER['PHP_SELF'], '/turistas/') && !strpos($_SERVER['PHP_SELF'], '/reservas/') && !strpos($_SERVER['PHP_SELF'], '/presupuestos/') && !strpos($_SERVER['PHP_SELF'], '/reportes/')) ? 'login.php' : '../login.php';

    if (file_exists("login.php")) {
        header("Location: login.php");
    } else {
        header("Location: ../login.php");
    }
    exit;
}
