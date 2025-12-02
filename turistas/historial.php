<?php
include("../config/seguridad.php");
include("../config/conexion.php");

if (!isset($_GET['id'])) {
    header("Location: listar.php");
    exit;
}
$id = $_GET['id'];

$sql_turista = "SELECT * FROM turistas WHERE id_turista = ?";
$stmt = $con->prepare($sql_turista);
$stmt->bind_param("i", $id);
$stmt->execute();
$turista = $stmt->get_result()->fetch_assoc();

if (!$turista) die("Turista no encontrado");

$f_desde   = $_GET['desde'] ?? '';
$f_hasta   = $_GET['hasta'] ?? '';
$f_keyword = $_GET['keyword'] ?? '';

$sql = "SELECT * FROM v_reservas_detallada WHERE id_turista = ?";
$tipos = "i";
$params = [$id];

if (!empty($f_desde)) {
    $sql .= " AND DATE(creado_en) >= ?";
    $tipos .= "s";
    $params[] = $f_desde;
}
if (!empty($f_hasta)) {
    $sql .= " AND DATE(creado_en) <= ?";
    $tipos .= "s";
    $params[] = $f_hasta;
}
if (!empty($f_keyword)) {
    $sql .= " AND (hotel_nombre LIKE ? OR codigo_reserva LIKE ?)";
    $tipos .= "ss";
    $p = "%$f_keyword%";
    $params[] = $p;
    $params[] = $p;
}

$sql .= " ORDER BY creado_en DESC";

$stmt = $con->prepare($sql);
$stmt->bind_param($tipos, ...$params);
$stmt->execute();
$resultado = $stmt->get_result();

$total_dinero = 0;
$total_reservas = $resultado->num_rows;
while ($fila = $resultado->fetch_assoc()) {
    $total_dinero += $fila['monto_pagar'];
}
$resultado->data_seek(0);
?>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <title>Historial - <?= $turista['nombre'] ?></title>
    <link rel="icon" href="../assets/img/Icono.png">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="../css/estilos.css">
</head>

<body>

    <section class="section">
        <div class="container">
            <div class="level mb-4">
                <div class="level-left">
                    <div>
                        <h1 class="title is-4">Historial de Cliente</h1>
                        <h2 class="subtitle is-6">
                            <?= $turista['nombre'] . " " . $turista['apellido'] ?>
                            <span class="tag is-info is-light ml-2"><?= $turista['numero_documento'] ?></span>
                        </h2>
                    </div>
                </div>
                <div class="level-right">
                    <a href="listar.php" class="button is-dark is-outlined is-small">
                        <span class="icon"><i class="fas fa-arrow-left"></i></span>
                        <span>Volver</span>
                    </a>
                </div>
            </div>

            <div class="columns is-variable is-4 mb-5">
                <div class="column is-4">
                    <div class="box has-background-primary-light has-text-centered">
                        <span class="icon is-large has-text-primary mb-2">
                            <i class="fas fa-coins fa-2x"></i>
                        </span>
                        <p class="heading">Total Invertido</p>
                        <p class="title is-4">$<?= number_format($total_dinero, 2) ?></p>
                    </div>
                </div>
                <div class="column is-4">
                    <div class="box has-text-centered">
                        <span class="icon is-large has-text-info mb-2">
                            <i class="fas fa-ticket-alt fa-2x"></i>
                        </span>
                        <p class="heading">Reservas Encontradas</p>
                        <p class="title is-4"><?= $total_reservas ?></p>
                    </div>
                </div>
            </div>

            <div class="box has-background-light">
                <form method="GET">
                    <input type="hidden" name="id" value="<?= $id ?>">
                    <div class="columns is-vcentered is-mobile is-multiline">
                        <div class="column is-3-desktop is-6-mobile">
                            <label class="label is-small">Desde</label>
                            <input class="input is-small" type="date" name="desde" value="<?= $f_desde ?>">
                        </div>
                        <div class="column is-3-desktop is-6-mobile">
                            <label class="label is-small">Hasta</label>
                            <input class="input is-small" type="date" name="hasta" value="<?= $f_hasta ?>">
                        </div>
                        <div class="column is-4-desktop is-12-mobile">
                            <label class="label is-small">Palabra Clave</label>
                            <div class="control has-icons-left">
                                <input class="input is-small" type="text" name="keyword"
                                    placeholder="Hotel, Código..." value="<?= htmlspecialchars($f_keyword) ?>">
                                <span class="icon is-small is-left"><i class="fas fa-search"></i></span>
                            </div>
                        </div>
                        <div class="column is-2-desktop is-12-mobile has-text-right">
                            <label class="label is-small">&nbsp;</label>
                            <button class="button is-info is-small is-fullwidth">Filtrar</button>
                            <?php if ($f_desde || $f_keyword): ?>
                                <a href="historial.php?id=<?= $id ?>" class="button is-text is-small is-fullwidth mt-1">Limpiar</a>
                            <?php endif; ?>
                        </div>
                    </div>
                </form>
            </div>

            <div class="box">
                <?php if ($total_reservas > 0): ?>
                    <div class="table-container">
                        <table class="table is-fullwidth is-striped is-hoverable">
                            <thead>
                                <tr>
                                    <th>Código</th>
                                    <th>Fecha Venta</th>
                                    <th>Hotel</th>
                                    <th>Viaje</th>
                                    <th>Monto</th>
                                    <th>Ticket</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php while ($h = $resultado->fetch_assoc()): ?>
                                    <tr>
                                        <td><span class="tag is-black is-light"><?= $h['codigo_reserva'] ?></span></td>
                                        <td><?= date('d/m/Y', strtotime($h['creado_en'])) ?></td>
                                        <td><strong><?= $h['hotel_nombre'] ?></strong></td>
                                        <td>
                                            <span class="is-size-7">
                                                <?= date('d/m', strtotime($h['check_in'])) ?> -
                                                <?= date('d/m', strtotime($h['check_out'])) ?>
                                            </span>
                                        </td>
                                        <td class="has-text-success has-text-weight-bold">
                                            $<?= number_format($h['monto_pagar'], 2) ?>
                                        </td>
                                        <td>
                                            <a href="../reservas/comprobante.php?id=<?= $h['id_reserva'] ?>" target="_blank" class="button is-small is-info is-outlined">
                                                <span class="icon"><i class="fas fa-print"></i></span>
                                            </a>
                                        </td>
                                    </tr>
                                <?php endwhile; ?>
                            </tbody>
                        </table>
                    </div>
                <?php else: ?>
                    <div class="notification is-warning is-light has-text-centered">
                        <p>No se encontraron reservas con estos criterios.</p>
                    </div>
                <?php endif; ?>
            </div>

        </div>
    </section>
</body>

</html>