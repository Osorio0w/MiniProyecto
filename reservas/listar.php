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
    $where = "WHERE (codigo_reserva LIKE '%$buscar%' OR cliente_completo LIKE '%$buscar%')";
}

$sql_total = "SELECT COUNT(*) as total FROM v_reservas_detallada $where";
$total_registros = $con->query($sql_total)->fetch_assoc()['total'];
$total_paginas = ceil($total_registros / $por_pagina);

$sql = "SELECT * FROM v_reservas_detallada 
        $where 
        ORDER BY creado_en DESC 
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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="../css/estilos.css">
</head>

<body>

    <section class="section">
        <div class="container">

            <nav class="breadcrumb" aria-label="breadcrumbs">
                <ul>
                    <li>
                        <a href="../index.php" class="has-text-info">
                            <span class="icon is-small"><i class="fas fa-home"></i></span>
                            <span>Inicio</span>
                        </a>
                    </li>
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

            <div class="box has-background-light">
                <form method="GET">
                    <div class="field has-addons">
                        <div class="control is-expanded has-icons-left">
                            <input class="input" type="text" name="buscar" placeholder="Buscar por código o nombre..." value="<?= htmlspecialchars($buscar) ?>">
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
                                <th>Fecha</th>
                                <th>Cliente</th>
                                <th>Detalles Pago</th>
                                <th>Hotel</th>
                                <th>Total</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if ($resultado->num_rows == 0): ?>
                                <tr>
                                    <td colspan="7" class="has-text-centered py-5">
                                        <p class="subtitle is-5 has-text-grey">No hay ventas registradas aún 📉</p>
                                    </td>
                                </tr>
                            <?php else: ?>
                                <?php while ($row = $resultado->fetch_assoc()): ?>
                                    <tr>
                                        <td>
                                            <span class="tag is-black"><?= $row['codigo_reserva'] ?></span>
                                        </td>
                                        <td class="is-size-7">
                                            <?= date('d/m/Y', strtotime($row['creado_en'])) ?>
                                        </td>
                                        <td>
                                            <strong><?= $row['cliente_completo'] ?></strong><br>
                                            <span class="is-size-7 has-text-grey"><?= $row['cliente_doc'] ?></span>
                                        </td>

                                        <td>
                                            <?php
                                            $clase_pago = "is-light";
                                            $icono_pago = "fas fa-money-bill-wave";
                                            $metodo = strtolower($row['metodo_pago']);

                                            if (strpos($metodo, 'zelle') !== false) {
                                                $clase_pago = "is-link is-light";
                                                $icono_pago = "fab fa-cc-amazon-pay";
                                            } elseif (strpos($metodo, 'efectivo') !== false) {
                                                $clase_pago = "is-success is-light";
                                                $icono_pago = "fas fa-coins";
                                            }
                                            ?>

                                            <span class="tag <?= $clase_pago ?>">
                                                <i class="<?= $icono_pago ?> mr-1"></i>
                                                <?= $row['metodo_pago'] ?>
                                            </span>

                                            <?php if (!empty($row['referencia_pago'])): ?>
                                                <div class="is-size-7 has-text-grey mt-1">
                                                    Ref: <span class="has-text-weight-bold"><?= $row['referencia_pago'] ?></span>
                                                </div>
                                            <?php endif; ?>
                                        </td>

                                        <td>
                                            <?= $row['hotel_nombre'] ?>
                                            <br>
                                            <span class="is-size-7">
                                                <?= date('d/m', strtotime($row['check_in'])) ?> -
                                                <?= date('d/m', strtotime($row['check_out'])) ?>
                                            </span>
                                        </td>
                                        <td class="has-text-success has-text-weight-bold">
                                            $<?= number_format($row['monto_pagar'], 2) ?>
                                        </td>
                                        <td>
                                            <a href="comprobante.php?id=<?= $row['id_reserva'] ?>" target="_blank" class="button is-small is-info is-outlined" title="Imprimir Ticket">
                                                <span class="icon"><i class="fas fa-print"></i></span>
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