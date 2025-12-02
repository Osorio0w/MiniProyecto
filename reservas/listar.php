<?php
include("../config/seguridad.php");
include("../config/conexion.php");

$por_pagina = 10;
$pagina_actual = isset($_GET['page']) ? (int)$_GET['page'] : 1;
if ($pagina_actual < 1) $pagina_actual = 1;
$inicio = ($pagina_actual - 1) * $por_pagina;

$buscar = $_GET['buscar'] ?? '';

$where = "";
if ($buscar != "") {
    $where = "WHERE (r.codigo_reserva LIKE '%$buscar%' OR t.nombre LIKE '%$buscar%' OR t.apellido LIKE '%$buscar%')";
}

$sql_total = "SELECT COUNT(*) as total FROM reservas r 
              INNER JOIN turistas t ON r.id_turista = t.id_turista 
              $where";
$total_registros = $con->query($sql_total)->fetch_assoc()['total'];
$total_paginas = ceil($total_registros / $por_pagina);

$sql = "SELECT 
            r.id_reserva,
            r.codigo_reserva,
            r.monto_pagar,
            r.creado_en,
            t.nombre, t.apellido, t.numero_documento,
            h.nombre as hotel,
            pr.fecha_reserva_desde,
            pr.fecha_reserva_hasta
        FROM reservas r
        INNER JOIN turistas t ON r.id_turista = t.id_turista
        INNER JOIN presupuesto_reservas pr ON r.id_presupuesto_reserva = pr.id_presupuesto_reserva
        INNER JOIN tarifarios ta ON pr.id_tarifario = ta.id_tarifario
        INNER JOIN hoteles h ON ta.id_hotel = h.id_hotel
        $where
        ORDER BY r.creado_en DESC
        LIMIT $inicio, $por_pagina";

$resultado = $con->query($sql);
?>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <title>Listado de Reservas</title>
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
                    <li class="is-active"><a href="#" aria-current="page">Reservas</a></li>
                </ul>
            </nav>

            <div class="level">
                <div class="level-left">
                    <h1 class="title">Gestión de Reservas</h1>
                </div>
                <div class="level-right">
                    <a href="../presupuestos/crear.php" class="button is-success">
                        <span class="icon"><i class="fas fa-plus"></i></span>
                        <span>Nueva Venta</span>
                    </a>
                </div>
            </div>

            <?php if (isset($_GET['msg']) && $_GET['msg'] == 'exito'): ?>
                <div class="notification is-success is-light">
                    <button class="delete" onclick="this.parentElement.style.display='none'"></button>
                    <strong>¡Venta Exitosa!</strong> La reserva se ha guardado correctamente.
                </div>
            <?php endif; ?>

            <div class="box has-background-light">
                <form method="GET">
                    <div class="field has-addons">
                        <div class="control is-expanded has-icons-left">
                            <input class="input" type="text" name="buscar" placeholder="Buscar por código (RES-001) o cliente..." value="<?= htmlspecialchars($buscar) ?>">
                            <span class="icon is-small is-left"><i class="fas fa-search"></i></span>
                        </div>
                        <div class="control">
                            <button class="button is-info">Buscar</button>
                        </div>
                        <?php if ($buscar): ?>
                            <div class="control">
                                <a href="listar.php" class="button is-white">Limpiar</a>
                            </div>
                        <?php endif; ?>
                    </div>
                </form>
            </div>

            <div class="box">
                <div class="table-container">
                    <table class="table is-fullwidth is-striped is-hoverable">
                        <thead>
                            <tr>
                                <th>Código</th>
                                <th>Fecha Venta</th>
                                <th>Cliente</th>
                                <th>Hotel / Fechas</th>
                                <th>Total</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if ($resultado->num_rows == 0): ?>
                                <tr>
                                    <td colspan="6" class="has-text-centered py-5">
                                        <p class="subtitle is-5 has-text-grey">No hay ventas registradas aún 📉</p>
                                    </td>
                                </tr>
                            <?php else: ?>
                                <?php while ($row = $resultado->fetch_assoc()): ?>
                                    <tr>
                                        <td>
                                            <span class="tag is-black is-medium"><?= $row['codigo_reserva'] ?></span>
                                        </td>
                                        <td>
                                            <?= date('d/m/Y H:i', strtotime($row['creado_en'])) ?>
                                        </td>
                                        <td>
                                            <strong><?= $row['nombre'] . ' ' . $row['apellido'] ?></strong><br>
                                            <span class="is-size-7"><?= $row['numero_documento'] ?></span>
                                        </td>
                                        <td>
                                            <span class="icon has-text-info"><i class="fas fa-hotel"></i></span>
                                            <?= $row['hotel'] ?><br>
                                            <span class="tag is-light is-small">
                                                <?= date('d/m', strtotime($row['fecha_reserva_desde'])) ?> al
                                                <?= date('d/m', strtotime($row['fecha_reserva_hasta'])) ?>
                                            </span>
                                        </td>
                                        <td class="has-text-success has-text-weight-bold is-size-5">
                                            $<?= number_format($row['monto_pagar'], 2) ?>
                                        </td>
                                        <td>
                                            <a href="comprobante.php?id=<?= $row['id_reserva'] ?>" target="_blank" class="button is-small is-info is-outlined" title="Imprimir Ticket">
                                                <span class="icon"><i class="fas fa-print"></i></span>
                                                <span>Ticket</span>
                                            </a>
                                        </td>
                                    </tr>
                                <?php endwhile; ?>
                            <?php endif; ?>
                        </tbody>
                    </table>
                </div>

                <?php if ($total_paginas > 1): ?>
                    <nav class="pagination is-centered" role="navigation">
                        <a href="?page=<?= $pagina_actual - 1 ?>&buscar=<?= $buscar ?>" class="pagination-previous" <?= ($pagina_actual <= 1) ? 'disabled' : '' ?>>Anterior</a>
                        <a href="?page=<?= $pagina_actual + 1 ?>&buscar=<?= $buscar ?>" class="pagination-next" <?= ($pagina_actual >= $total_paginas) ? 'disabled' : '' ?>>Siguiente</a>
                    </nav>
                <?php endif; ?>
            </div>

        </div>
    </section>
</body>

</html>