<?php
include("../config/seguridad.php");
include("../config/conexion.php");

if (!isset($_GET['id'])) {
    header("Location: listar.php");
    exit;
}

$id = $_GET['id'];

$sql = $con->prepare("UPDATE turistas SET activo = 0 WHERE id_turista = ?");
$sql->bind_param("i", $id);

if ($sql->execute()) {
    header("Location: listar.php?msg=oculto");
} else {
    echo "Error al ocultar: " . $con->error;
}
