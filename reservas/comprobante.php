<?php
include("../config/seguridad.php");
include("../config/conexion.php");

if (!isset($_GET['id'])) {
    die("Error: Falta el ID de la reserva.");
}

$id_reserva = $_GET['id'];

$stmt = $con->prepare("SELECT * FROM v_reservas_detallada WHERE id_reserva = ?");
$stmt->bind_param("i", $id_reserva);
$stmt->execute();
$reserva = $stmt->get_result()->fetch_assoc();

if (!$reserva) die("Reserva no encontrada.");
?>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <title>Recibo #<?= $reserva['codigo_reserva'] ?></title>
    <link rel="icon" href="../assets/img/Icono.png">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
                    <h1 class="title is-3 has-text-info">🌊 Caribe Azul Travel</h1>
                    <p class="subtitle is-6">Comprobante de Reserva Turística</p>
                    <p><strong>Código: <?= $reserva['codigo_reserva'] ?></strong></p>
                    <p class="is-size-7">Emisión: <?= date('d/m/Y H:i A', strtotime($reserva['creado_en'])) ?></p>
                </div>

                <hr>

                <div class="columns">
                    <div class="column is-6">
                        <h3 class="title is-6 has-text-grey">CLIENTE</h3>
                        <p class="is-size-5"><strong><?= $reserva['cliente_completo'] ?></strong></p>
                        <p>Doc: <?= $reserva['cliente_doc'] ?></p>
                        <p>Tel: <?= $reserva['cliente_tel'] ?></p>
                        <p>Email: <?= $reserva['cliente_email'] ?></p>
                    </div>

                    <div class="column is-6 has-text-right">
                        <h3 class="title is-6 has-text-grey">DETALLES DEL VIAJE</h3>
                        <p class="is-size-4"><?= $reserva['hotel_nombre'] ?></p>
                        <p><?= $reserva['hotel_ubicacion'] ?></p>
                        <p>Habitación: <?= $reserva['habitacion_tipo'] ?></p>
                    </div>
                </div>

                <table class="table is-fullwidth is-bordered mt-4">
                    <thead>
                        <tr class="has-background-light">
                            <th class="has-text-centered">Check-In</th>
                            <th class="has-text-centered">Check-Out</th>
                            <th class="has-text-centered">Duración</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td class="has-text-centered is-size-5"><?= date('d/m/Y', strtotime($reserva['check_in'])) ?></td>
                            <td class="has-text-centered is-size-5"><?= date('d/m/Y', strtotime($reserva['check_out'])) ?></td>
                            <td class="has-text-centered"><?= $reserva['noches'] ?> Noches</td>
                        </tr>
                    </tbody>
                </table>

                <hr>

                <div class="columns is-vcentered">
                    <div class="column is-6">
                        <p class="is-size-7 has-text-grey">Forma de Pago:</p>
                        <p class="is-size-5 has-text-dark has-text-weight-bold">
                            <?= $reserva['metodo_pago'] ?>
                        </p>
                        <?php if (!empty($reserva['referencia_pago'])): ?>
                            <p class="is-size-7">Ref: <?= $reserva['referencia_pago'] ?></p>
                        <?php endif; ?>
                    </div>
                    <div class="column is-6 has-text-right">
                        <p class="heading">Monto Total</p>
                        <p class="title is-2 has-text-success">$<?= number_format($reserva['monto_pagar'], 2) ?></p>
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