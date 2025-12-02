<?php
include("../config/seguridad.php");
include("../config/conexion.php");

$resultados = [];
$error = "";
$dias = 0;
$noches = 0;

$turistas = $con->query("SELECT id_turista, nombre, apellido FROM turistas WHERE activo = 1 ORDER BY nombre ASC");
$hoteles  = $con->query("SELECT id_hotel, nombre, ubicacion FROM hoteles");

if (isset($_GET['cotizar'])) {

    $id_turista = $_GET['id_turista'];
    $fecha_in   = $_GET['fecha_desde'];
    $fecha_out  = $_GET['fecha_hasta'];
    $personas   = (int)$_GET['personas'];
    $id_hotel   = $_GET['id_hotel'];

    if ($fecha_in >= $fecha_out) {
        $error = "La fecha de salida debe ser posterior a la fecha de entrada.";
    } else {
        $date1 = new DateTime($fecha_in);
        $date2 = new DateTime($fecha_out);
        $diff  = $date1->diff($date2);
        $noches = $diff->days;
        $dias   = $noches + 1;

        $sql = "SELECT 
                    t.id_tarifario,
                    t.precio,
                    h.nombre as nombre_hotel,
                    h.ubicacion,
                    th.descripcion as tipo_habitacion,
                    th.cantidad_personas as capacidad
                FROM tarifarios t
                INNER JOIN hoteles h ON t.id_hotel = h.id_hotel
                INNER JOIN tipo_habitaciones th ON t.id_tipo_habitacion = th.id_tipo_habitacion
                WHERE 
                    t.fecha_desde <= '$fecha_in' 
                    AND t.fecha_hasta >= '$fecha_out'
                    AND th.cantidad_personas >= $personas";

        if (!empty($id_hotel)) {
            $sql .= " AND t.id_hotel = $id_hotel";
        }

        $sql .= " ORDER BY t.precio ASC";

        $query_res = $con->query($sql);

        if ($query_res->num_rows > 0) {
            while ($row = $query_res->fetch_assoc()) {
                $resultados[] = $row;
            }
        } else {
            $error = "No se encontraron habitaciones disponibles para esas fechas o capacidad.";
        }
    }
}
?>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <title>Cotizador de Viajes</title>
    <link rel="icon" href="../assets/img/Icono.png">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>

<body>
    <section class="section">
        <div class="container">

            <nav class="breadcrumb" aria-label="breadcrumbs">
                <ul>
                    <li><a href="../index.php">Inicio</a></li>
                    <li class="is-active"><a href="#" aria-current="page">Cotizador</a></li>
                </ul>
            </nav>

            <h1 class="title">✈️ Cotizador de Paquetes</h1>
            <h2 class="subtitle">Calcula presupuestos en tiempo real</h2>

            <div class="box has-background-light">
                <form method="GET">

                    <?php if ($error): ?>
                        <div class="notification is-danger is-light">
                            <button class="delete" onclick="this.parentElement.style.display='none'"></button>
                            <?= $error ?>
                        </div>
                    <?php endif; ?>

                    <div class="columns is-multiline">
                        <div class="column is-3">
                            <label class="label">Cliente</label>
                            <div class="select is-fullwidth">
                                <select name="id_turista" required>
                                    <option value="" disabled selected>Seleccione...</option>
                                    <?php while ($t = $turistas->fetch_assoc()): ?>
                                        <option value="<?= $t['id_turista'] ?>" <?= (isset($_GET['id_turista']) && $_GET['id_turista'] == $t['id_turista']) ? 'selected' : '' ?>>
                                            <?= $t['nombre'] . ' ' . $t['apellido'] ?>
                                        </option>
                                    <?php endwhile; ?>
                                </select>
                            </div>
                        </div>

                        <div class="column is-3">
                            <label class="label">Hotel (Opcional)</label>
                            <div class="select is-fullwidth">
                                <select name="id_hotel">
                                    <option value="">Todos los hoteles</option>
                                    <?php while ($h = $hoteles->fetch_assoc()): ?>
                                        <option value="<?= $h['id_hotel'] ?>" <?= (isset($_GET['id_hotel']) && $_GET['id_hotel'] == $h['id_hotel']) ? 'selected' : '' ?>>
                                            <?= $h['nombre'] ?> (<?= $h['ubicacion'] ?>)
                                        </option>
                                    <?php endwhile; ?>
                                </select>
                            </div>
                        </div>

                        <div class="column is-2">
                            <label class="label">Entrada</label>
                            <input class="input" type="date" name="fecha_desde" required value="<?= $_GET['fecha_desde'] ?? '' ?>">
                        </div>
                        <div class="column is-2">
                            <label class="label">Salida</label>
                            <input class="input" type="date" name="fecha_hasta" required value="<?= $_GET['fecha_hasta'] ?? '' ?>">
                        </div>

                        <div class="column is-1">
                            <label class="label">Pers.</label>
                            <input class="input" type="number" name="personas" min="1" max="10" required value="<?= $_GET['personas'] ?? 1 ?>">
                        </div>

                        <div class="column is-1">
                            <label class="label">&nbsp;</label>
                            <button type="submit" name="cotizar" class="button is-info is-fullwidth">
                                <i class="fas fa-calculator"></i>
                            </button>
                        </div>
                    </div>
                </form>
            </div>

            <?php if (!empty($resultados)): ?>

                <div class="notification is-info is-light mb-5">
                    <p class="is-size-5">
                        <strong>Resumen del Plan:</strong>
                        <?= $noches ?> Noches / <?= $dias ?> Días para <strong><?= $_GET['personas'] ?> personas</strong>.
                    </p>
                </div>

                <div class="columns is-multiline">
                    <?php foreach ($resultados as $row):
                        $total_calculado = ($row['precio'] * $noches) * $_GET['personas'];
                    ?>
                        <div class="column is-4">
                            <div class="card card-hover">
                                <header class="card-header">
                                    <p class="card-header-title is-centered has-background-white-ter">
                                        <?= $row['nombre_hotel'] ?>
                                    </p>
                                </header>
                                <div class="card-content">
                                    <div class="content has-text-centered">
                                        <p class="subtitle is-6 mb-2">
                                            <i class="fas fa-map-marker-alt has-text-danger"></i> <?= $row['ubicacion'] ?>
                                        </p>
                                        <span class="tag is-primary is-light is-medium mb-3">
                                            <?= $row['tipo_habitacion'] ?>
                                        </span>

                                        <div class="columns is-mobile is-vcentered mt-2" style="border-top: 1px solid #eee; padding-top: 10px;">
                                            <div class="column has-text-left">
                                                <p class="is-size-7">Precio Unitario</p>
                                                <p class="has-text-weight-bold">$<?= $row['precio'] ?></p>
                                            </div>
                                            <div class="column has-text-right">
                                                <p class="is-size-7">Total a Pagar</p>
                                                <p class="title is-4 has-text-success">$<?= number_format($total_calculado, 2) ?></p>
                                            </div>
                                        </div>

                                        <form action="../reservas/confirmar.php" method="POST">
                                            <input type="hidden" name="id_turista" value="<?= $_GET['id_turista'] ?>">
                                            <input type="hidden" name="id_tarifario" value="<?= $row['id_tarifario'] ?>">
                                            <input type="hidden" name="fecha_desde" value="<?= $_GET['fecha_desde'] ?>">
                                            <input type="hidden" name="fecha_hasta" value="<?= $_GET['fecha_hasta'] ?>">
                                            <input type="hidden" name="personas" value="<?= $_GET['personas'] ?>">
                                            <input type="hidden" name="monto_base" value="<?= $total_calculado ?>">

                                            <input type="hidden" name="hotel_nombre" value="<?= $row['nombre_hotel'] ?>">
                                            <input type="hidden" name="habitacion" value="<?= $row['tipo_habitacion'] ?>">
                                            <input type="hidden" name="noches" value="<?= $noches ?>">

                                            <button class="button is-success is-fullwidth mt-3">
                                                <span>Reservar Ahora</span>
                                                <span class="icon is-small ml-2"><i class="fas fa-arrow-right"></i></span>
                                            </button>
                                        </form>

                                    </div>
                                </div>
                            </div>
                        </div>
                    <?php endforeach; ?>
                </div>

            <?php endif; ?>

        </div>
    </section>
</body>

</html>