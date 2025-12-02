<?php
include("../config/seguridad.php");
include("../config/conexion.php");


$kpi_ingresos = $con->query("SELECT SUM(monto_pagar) as total FROM reservas")->fetch_assoc()['total'];
$kpi_reservas = $con->query("SELECT COUNT(*) as total FROM reservas")->fetch_assoc()['total'];

$kpi_hotel = $con->query("SELECT hotel FROM v_stats_hoteles LIMIT 1")->fetch_assoc();
$nombre_top_hotel = $kpi_hotel ? $kpi_hotel['hotel'] : 'N/A';

$res_hoteles = $con->query("SELECT * FROM v_stats_hoteles LIMIT 5");
$labels_h = [];
$data_h = [];
while ($row = $res_hoteles->fetch_assoc()) {
    $labels_h[] = $row['hotel'];
    $data_h[] = $row['ventas'];
}

$res_meses = $con->query("SELECT DATE_FORMAT(creado_en, '%Y-%m') as mes, SUM(monto_pagar) as total FROM reservas GROUP BY mes ORDER BY mes ASC LIMIT 6");
$labels_m = [];
$data_m = [];
while ($row = $res_meses->fetch_assoc()) {
    $dateObj = DateTime::createFromFormat('!Y-m', $row['mes']);
    $labels_m[] = $dateObj->format('M Y');
    $data_m[] = $row['total'];
}

$res_vip = $con->query("SELECT * FROM v_stats_clientes LIMIT 5");

$res_caja = $con->query("SELECT * FROM v_finanzas_diarias LIMIT 7"); 

$res_llegadas = $con->query("SELECT * FROM v_agenda_llegadas LIMIT 5");

$res_habs = $con->query("SELECT * FROM v_demanda_habitaciones");
?>


<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <title>Reportes - Caribe Azul</title>
    <link rel="icon" href="../assets/img/Icono.png">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="../css/estilos.css">
    <link rel="stylesheet" href="../css/estilos_reportes.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>

<body class="has-background-white-ter">

    <section class="section">
        <div class="container">

            <nav class="breadcrumb has-succeeds-separator" aria-label="breadcrumbs">
                <ul>
                    <li>
                        <a href="../index.php" class="has-text-info">
                            <span class="icon is-small"><i class="fas fa-home"></i></span>
                            <span>Inicio</span>
                        </a>
                    </li>
                    <li class="is-active"><a href="#" aria-current="page">Reportes</a></li>
                </ul>
            </nav>

            <div class="level mb-5">
                <div class="level-left">
                    <div>
                        <h1 class="title is-3 has-text-info">📊 Reportes Gerenciales</h1>
                        <p class="subtitle is-6 has-text-grey">Indicadores clave de rendimiento</p>
                    </div>
                </div>
                <div class="level-right no-print">
                    <button onclick="window.print()" class="button is-dark is-outlined">
                        <span class="icon"><i class="fas fa-print"></i></span>
                        <span>Imprimir</span>
                    </button>
                </div>
            </div>

            <div class="columns mb-5">

                <div class="column is-4">
                    <div class="kpi-box kpi-primary">
                        <div class="heading">Ingresos Totales</div>
                        <div class="kpi-value">$<?= number_format($kpi_ingresos, 2) ?></div>
                    </div>
                </div>

                <div class="column is-4">
                    <div class="kpi-box kpi-info">
                        <div class="heading">Reservas Cerradas</div>
                        <div class="kpi-value"><?= $kpi_reservas ?></div>
                    </div>
                </div>

                <div class="column is-4">
                    <div class="kpi-box kpi-link">
                        <div class="heading">Hotel Estrella</div>
                        <div class="kpi-value"><?= $nombre_top_hotel ?></div>
                    </div>
                </div>

            </div>

            <div class="columns">

                <div class="column is-5">
                    <div class="box">
                        <h4 class="title is-5 has-text-centered">Demanda por Hotel</h4>
                        <div class="chart-container">
                            <canvas id="chartPie"></canvas>
                        </div>
                    </div>
                </div>

                <div class="column is-7">
                    <div class="box">
                        <h4 class="title is-5 has-text-centered">Evolución de Ingresos</h4>
                        <div class="chart-container">
                            <canvas id="chartBar"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <div class="box">
                <h3 class="title is-5">💰 Cierre de Caja (Última Semana)</h3>
                <table class="table is-fullwidth is-striped">
                    <thead>
                        <tr>
                            <th>Fecha</th>
                            <th>Ventas Cerradas</th>
                            <th>Ingreso Total</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php while ($dia = $res_caja->fetch_assoc()): ?>
                            <tr>
                                <td><?= date('d/m/Y', strtotime($dia['fecha_venta'])) ?></td>
                                <td><?= $dia['cantidad_ventas'] ?></td>
                                <td class="has-text-success has-text-weight-bold">
                                    $<?= number_format($dia['total_ingresos'], 2) ?>
                                </td>
                            </tr>
                        <?php endwhile; ?>
                    </tbody>
                </table>
            </div>

            <div class="columns">

                <div class="column is-7">
                    <div class="box" style="height: 100%;">
                        <div class="level mb-2">
                            <div class="level-left">
                                <h3 class="title is-5"><i class="fas fa-plane-arrival has-text-info mr-2"></i> Próximas Llegadas</h3>
                            </div>
                        </div>

                        <table class="table is-fullwidth is-hoverable is-narrow">
                            <thead>
                                <tr>
                                    <th>Fecha</th>
                                    <th>Cliente</th>
                                    <th>Hotel</th>
                                    <th>Estado</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php if ($res_llegadas->num_rows > 0): ?>
                                    <?php while ($l = $res_llegadas->fetch_assoc()):
                                        $dias = $l['dias_faltantes'];
                                        $clase = "is-info is-light";
                                        $texto = "En $dias días";

                                        if ($dias == 0) {
                                            $clase = "is-success";
                                            $texto = "¡LLEGA HOY!";
                                        } elseif ($dias == 1) {
                                            $clase = "is-warning";
                                            $texto = "Mañana";
                                        }
                                    ?>
                                        <tr>
                                            <td><?= date('d/m', strtotime($l['fecha_llegada'])) ?></td>
                                            <td>
                                                <strong><?= $l['cliente'] ?></strong><br>
                                                <small class="has-text-grey"><i class="fas fa-phone-alt"></i> <?= $l['telefono'] ?></small>
                                            </td>
                                            <td><?= $l['hotel'] ?></td>
                                            <td><span class="tag <?= $clase ?>"><?= $texto ?></span></td>
                                        </tr>
                                    <?php endwhile; ?>
                                <?php else: ?>
                                    <tr>
                                        <td colspan="4" class="has-text-grey has-text-centered">No hay llegadas próximas.</td>
                                    </tr>
                                <?php endif; ?>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="column is-5">
                    <div class="box" style="height: 100%;">
                        <h3 class="title is-5"><i class="fas fa-bed has-text-primary mr-2"></i> Habitaciones Top</h3>

                        <table class="table is-fullwidth is-striped">
                            <thead>
                                <tr>
                                    <th>Tipo</th>
                                    <th class="has-text-centered">Reservas</th>
                                    <th class="has-text-right">Ingresos</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php while ($h = $res_habs->fetch_assoc()): ?>
                                    <tr>
                                        <td><?= $h['tipo_habitacion'] ?></td>
                                        <td class="has-text-centered">
                                            <span class="tag is-rounded is-white border-tag">
                                                <?= $h['veces_reservada'] ?>
                                            </span>
                                        </td>
                                        <td class="has-text-right is-size-7">
                                            $<?= number_format($h['dinero_generado'], 0) ?>
                                        </td>
                                    </tr>
                                <?php endwhile; ?>
                            </tbody>
                        </table>
                        <p class="help mt-3">Total acumulado por categoría.</p>
                    </div>
                </div>

            </div>

            <div class="box mt-5">
                <h3 class="title is-5">🏆 Ranking de Clientes</h3>
                <table class="table is-fullwidth is-striped">
                    <thead>
                        <tr>
                            <th style="width: 80px;">Rank</th>
                            <th>Cliente</th>
                            <th>Ciudad</th>
                            <th class="has-text-centered">Viajes</th>
                            <th class="has-text-right">Total Invertido</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php
                        $pos = 1;
                        while ($c = $res_vip->fetch_assoc()):
                            if ($pos == 1) $medal = "🥇";
                            elseif ($pos == 2) $medal = "🥈";
                            elseif ($pos == 3) $medal = "🥉";
                            else $medal = "#" . $pos;
                        ?>
                            <tr>
                                <td class="is-size-5 has-text-centered"><?= $medal ?></td>
                                <td><strong><?= $c['nombre'] ?> <?= $c['apellido'] ?></strong></td>
                                <td><span class="tag is-light"><?= $c['ubicacion'] ?></span></td>
                                <td class="has-text-centered"><?= $c['viajes'] ?></td>
                                <td class="has-text-success has-text-weight-bold has-text-right">
                                    $<?= number_format($c['gastado'], 2) ?>
                                </td>
                            </tr>
                        <?php $pos++;
                        endwhile; ?>
                    </tbody>
                </table>
            </div>

        </div>
    </section>

    <script>
        Chart.defaults.font.family = "'Segoe UI', 'Helvetica', 'Arial', sans-serif";

        new Chart(document.getElementById('chartPie'), {
            type: 'doughnut',
            data: {
                labels: <?= json_encode($labels_h) ?>,
                datasets: [{
                    data: <?= json_encode($data_h) ?>,
                    backgroundColor: ['#00d1b2', '#209cee', '#3273dc', '#23d160', '#ffdd57'],
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'right'
                    }
                }
            }
        });

        new Chart(document.getElementById('chartBar'), {
            type: 'bar',
            data: {
                labels: <?= json_encode($labels_m) ?>,
                datasets: [{
                    label: 'Ventas ($)',
                    data: <?= json_encode($data_m) ?>,
                    backgroundColor: '#48c774',
                    borderRadius: 4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    </script>
</body>

</html>