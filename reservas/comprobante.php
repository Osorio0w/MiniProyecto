<?php
include("../config/seguridad.php");
include("../config/conexion.php");

if (!isset($_GET['id'])) {
    die("Error: Falta el ID de la reserva.");
}

$id_reserva = $_GET['id'];

$sql = "SELECT 
            r.codigo_reserva,
            r.monto_pagar,
            r.creado_en,
            t.nombre, t.apellido, t.numero_documento, t.telefono, t.correo,
            h.nombre as hotel, h.ubicacion,
            th.descripcion as habitacion,
            pr.fecha_reserva_desde,
            pr.fecha_reserva_hasta
        FROM reservas r
        INNER JOIN turistas t ON r.id_turista = t.id_turista
        INNER JOIN presupuesto_reservas pr ON r.id_presupuesto_reserva = pr.id_presupuesto_reserva
        INNER JOIN tarifarios ta ON pr.id_tarifario = ta.id_tarifario
        INNER JOIN tipo_habitaciones th ON ta.id_tipo_habitacion = th.id_tipo_habitacion
        INNER JOIN hoteles h ON ta.id_hotel = h.id_hotel
        WHERE r.id_reserva = ?";

$stmt = $con->prepare($sql);
$stmt->bind_param("i", $id_reserva);
$stmt->execute();
$reserva = $stmt->get_result()->fetch_assoc();

if (!$reserva) die("Reserva no encontrada.");

$noches = (new DateTime($reserva['fecha_reserva_desde']))->diff(new DateTime($reserva['fecha_reserva_hasta']))->days;
?>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <title>Recibo #<?= $reserva['codigo_reserva'] ?></title>
    <link rel="icon" href="../assets/img/Icono.png">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css">
    <link rel="stylesheet" href="../css/estilos_recibos.css">
</head>

<body class="has-background-white-ter">
    <section class="section">
        <div class="container ticket-container">

            <div class="buttons is-centered no-print mb-5">
                <button onclick="window.print()" class="button is-primary is-medium">
                    🖨️ Imprimir Comprobante
                </button>
                <button onclick="window.close()" class="button is-light is-medium">
                    Cerrar
                </button>
            </div>

            <div class="box p-6">
                <div class="has-text-centered mb-5">
                    <h1 class="title-agencia title is-3">🌊 Caribe Azul Travel</h1>
                    <p class="subtitle is-6">Comprobante de Reserva Turística</p>
                    <p><strong>Código: <?= $reserva['codigo_reserva'] ?></strong></p>
                    <p class="is-size-7">Fecha de Emisión: <?= date('d/m/Y H:i A', strtotime($reserva['creado_en'])) ?></p>
                </div>

                <hr>

                <div class="columns">
                    <div class="column is-6">
                        <p class="section-title">Cliente</p>
                        <p><strong><?= $reserva['nombre'] ?> <?= $reserva['apellido'] ?></strong></p>
                        <p>CI/Pass: <?= $reserva['numero_documento'] ?></p>
                        <p>Tel: <?= $reserva['telefono'] ?></p>
                        <p>Email: <?= $reserva['correo'] ?></p>
                    </div>

                    <div class="column is-6 has-text-right">
                        <h3 class="title is-6 has-text-grey">DETALLES DEL VIAJE</h3>
                        <p class="is-size-4"><?= $reserva['hotel'] ?></p>
                        <p><?= $reserva['ubicacion'] ?></p>
                        <p>Habitación: <?= $reserva['habitacion'] ?></p>
                    </div>
                </div>

                <table class="table is-fullwidth is-bordered mt-4">
                    <thead>
                        <tr class="has-background-light">
                            <th class="has-text-centered">Check-In (Llegada)</th>
                            <th class="has-text-centered">Check-Out (Salida)</th>
                            <th class="has-text-centered">Duración</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td class="has-text-centered is-size-5"><?= date('d/m/Y', strtotime($reserva['fecha_reserva_desde'])) ?></td>
                            <td class="has-text-centered is-size-5"><?= date('d/m/Y', strtotime($reserva['fecha_reserva_hasta'])) ?></td>
                            <td class="has-text-centered"><?= $noches ?> Noches</td>
                        </tr>
                    </tbody>
                </table>

                <hr>

                <div class="level">
                    <div class="level-left">
                        <p class="is-size-7 has-text-grey">
                            * Este documento sirve como constancia de su reserva.<br>
                            * Presentar al momento del Check-In en el hotel.
                        </p>
                    </div>
                    <div class="level-right has-text-right">
                        <div>
                            <p class="heading">Monto Total Pagado</p>
                            <p class="title is-2 has-text-success">$<?= number_format($reserva['monto_pagar'], 2) ?></p>
                        </div>
                    </div>
                </div>

                <div class="has-text-centered mt-6 pt-4 is-size-7 has-text-grey-light" style="border-top: 1px dashed #ccc;">
                    <p>Agencia Caribe Azul Travel - RIF: J-12345678-9</p>
                    <p>Gracias por viajar con nosotros</p>
                </div>

            </div>
        </div>
    </section>
</body>

</html>