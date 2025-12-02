<?php
include("../config/seguridad.php");
include("../config/conexion.php");

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $id_turista   = $_POST['id_turista'];
    $id_tarifario = $_POST['id_tarifario'];
    $f_desde      = $_POST['fecha_desde'];
    $f_hasta      = $_POST['fecha_hasta'];
    $personas     = $_POST['personas'];

    $traslado = isset($_POST['traslado']) && $_POST['traslado'] !== '' ? floatval($_POST['traslado']) : 0;

    try {
        $con->begin_transaction();

        $sql_sp = "CALL sp_generar_presupuesto($id_tarifario, $personas, '$f_desde', '$f_hasta', @id_presupuesto, @total_calculado)";

        if (!$con->query($sql_sp)) {
            throw new Exception("Error MySQL: " . $con->error);
        }

        $res = $con->query("SELECT @id_presupuesto as id, @total_calculado as total");
        $row = $res->fetch_assoc();

        $id_presupuesto = $row['id'];
        $monto_sp       = floatval($row['total']);

        $monto_final = $monto_sp + $traslado;

        $stmt = $con->prepare("INSERT INTO reservas (id_turista, id_presupuesto_reserva, monto_pagar) VALUES (?, ?, ?)");
        $stmt->bind_param("iid", $id_turista, $id_presupuesto, $monto_final);

        if (!$stmt->execute()) {
            throw new Exception("Error al guardar: " . $stmt->error);
        }

        $con->commit();
        header("Location: listar.php?msg=exito");
        exit;
    } catch (Exception $e) {
        $con->rollback();
        die("Error: " . $e->getMessage());
    }
}
