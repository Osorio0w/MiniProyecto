<?php
include("../config/seguridad.php");
include("../config/conexion.php");

if ($_SERVER['REQUEST_METHOD'] != 'POST') {
    header("Location: ../presupuestos/crear.php");
    exit;
}

$id_turista   = $_POST['id_turista'];
$id_tarifario = $_POST['id_tarifario'];
$fecha_desde  = $_POST['fecha_desde'];
$fecha_hasta  = $_POST['fecha_hasta'];
$personas     = $_POST['personas'];
$monto_base   = $_POST['monto_base'];

$hotel_nombre = $_POST['hotel_nombre'];
$habitacion   = $_POST['habitacion'];
$noches       = $_POST['noches'];

$sql_t = $con->query("SELECT * FROM turistas WHERE id_turista = $id_turista");
$turista = $sql_t->fetch_assoc();

$sql_h = $con->query("SELECT id_hotel FROM tarifarios WHERE id_tarifario = $id_tarifario");
$row_h = $sql_h->fetch_assoc();
$id_hotel_real = $row_h['id_hotel'];
?>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <title>Confirmar Reserva</title>
    <link rel="icon" href="../assets/img/Icono.png">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>

<body class="has-background-white-ter">
    <section class="section">
        <div class="container">

            <div class="columns is-centered">
                <div class="column is-6">

                    <nav class="breadcrumb" aria-label="breadcrumbs">
                        <ul>
                            <li><a href="../presupuestos/crear.php">Volver al Cotizador</a></li>
                            <li class="is-active"><a href="#" aria-current="page">Confirmar</a></li>
                        </ul>
                    </nav>

                    <div class="box">
                        <div class="has-text-centered mb-5">
                            <span class="icon is-large has-text-success">
                                <i class="fas fa-check-circle fa-3x"></i>
                            </span>
                            <h1 class="title is-4 mt-2">Confirmar Reserva</h1>
                            <p class="subtitle is-6">Verifique los detalles antes de procesar</p>
                        </div>

                        <div class="notification is-link is-light">
                            <p class="heading">Cliente</p>
                            <p class="title is-5"><?= $turista['nombre'] ?> <?= $turista['apellido'] ?></p>
                            <p>Doc: <?= $turista['numero_documento'] ?></p>
                        </div>

                        <table class="table is-fullwidth is-bordered is-striped">
                            <tbody>
                                <tr>
                                    <th>Hotel</th>
                                    <td><?= $hotel_nombre ?></td>
                                </tr>
                                <tr>
                                    <th>Alojamiento</th>
                                    <td><?= $habitacion ?> (<?= $personas ?> Pers.)</td>
                                </tr>
                                <tr>
                                    <th>Fechas</th>
                                    <td>
                                        Del <strong><?= date('d/m/Y', strtotime($fecha_desde)) ?></strong> <br>
                                        al <strong><?= date('d/m/Y', strtotime($fecha_hasta)) ?></strong>
                                    </td>
                                </tr>
                                <tr>
                                    <th>Duración</th>
                                    <td><?= $noches ?> Noches</td>
                                </tr>
                                <tr class="is-selected">
                                    <th>Costo Base</th>
                                    <td class="has-text-weight-bold">$<?= number_format($monto_base, 2) ?></td>
                                </tr>
                            </tbody>
                        </table>

                        <form action="guardar.php" method="POST" id="formReserva">

                            <input type="hidden" name="id_tarifario" value="<?= $id_tarifario ?>">
                            <input type="hidden" name="id_turista" value="<?= $id_turista ?>">
                            <input type="hidden" name="id_hotel" value="<?= $id_hotel_real ?>">
                            <input type="hidden" name="fecha_desde" value="<?= $fecha_desde ?>">
                            <input type="hidden" name="fecha_hasta" value="<?= $fecha_hasta ?>">
                            <input type="hidden" name="personas" value="<?= $personas ?>">
                            <input type="hidden" name="monto_alojamiento" value="<?= $monto_base ?>">

                            <div class="field box has-background-warning-light mt-4">
                                <label class="label">
                                    <span class="icon is-small mr-1"><i class="fas fa-bus"></i></span>
                                    Costo de Traslado (Opcional)
                                </label>
                                <div class="control has-icons-left has-icons-right">
                                    <input class="input is-medium has-text-centered has-text-weight-bold"
                                        type="number" step="0.01" name="traslado" id="traslado"
                                        placeholder="0.00" value="0">
                                    <span class="icon is-left"><i class="fas fa-dollar-sign"></i></span>
                                </div>
                                <p class="help">Ingrese monto si solicitó transporte.</p>
                            </div>

                            <hr>

                            <div class="level is-mobile">
                                <div class="level-left">
                                    <p class="title is-5">Total a Pagar:</p>
                                </div>
                                <div class="level-right">
                                    <p class="title is-2 has-text-success" id="totalDisplay">
                                        $<?= number_format($monto_base, 2) ?>
                                    </p>
                                </div>
                            </div>

                            <button type="submit" class="button is-success is-large is-fullwidth mt-2">
                                <span class="icon"><i class="fas fa-save"></i></span>
                                <span>Confirmar Venta</span>
                            </button>
                        </form>

                    </div>
                </div>
            </div>

        </div>
    </section>

    <script>
        const base = <?= $monto_base ?>;
        const inputTraslado = document.getElementById('traslado');
        const display = document.getElementById('totalDisplay');

        inputTraslado.addEventListener('input', function() {
            let extra = parseFloat(this.value);
            if (isNaN(extra)) extra = 0;

            let total = base + extra;
            display.innerText = '$' + total.toFixed(2);
        });
    </script>
</body>

</html>