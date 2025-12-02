<?php
include("config/seguridad.php");
include("config/conexion.php");
$ruta = "";
?>

<!DOCTYPE html>
<html lang="es" class="has-navbar-fixed-top">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inicio - Caribe Azul Travel</title>
    <link rel="icon" href="assets/img/Icono.png">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/estilos.css">
</head>

<body>

    <nav class="navbar is-fixed-top has-shadow" role="navigation" aria-label="main navigation">
        <div class="container">
            <div class="navbar-brand">
                <a class="navbar-item" href="index.php">
                    <span class="icon is-medium has-text-info">
                        <i class="fas fa-umbrella-beach fa-2x"></i>
                    </span>
                    <span class="ml-2 is-size-4 has-text-weight-bold has-text-info">Caribe Azul</span>
                </a>

                <a role="button" class="navbar-burger" aria-label="menu" aria-expanded="false" data-target="navbarBasic">
                    <span aria-hidden="true"></span>
                    <span aria-hidden="true"></span>
                    <span aria-hidden="true"></span>
                </a>
            </div>

            <div id="navbarBasic" class="navbar-menu">
                <div class="navbar-start">
                    <a href="index.php" class="navbar-item is-active">Inicio</a>
                    <a href="turistas/listar.php" class="navbar-item">Turistas</a>
                    <a href="reportes/index.php" class="navbar-item">Reportes</a>
                    <div class="navbar-item has-dropdown is-hoverable">
                        <a class="navbar-link">Gestión</a>
                        <div class="navbar-dropdown">
                            <a href="presupuestos/crear.php" class="navbar-item">Nuevo Presupuesto</a>
                            <a href="reservas/listar.php" class="navbar-item">Ver Reservas</a>
                        </div>
                    </div>
                </div>

                <div class="navbar-item has-dropdown is-hoverable">
                    <a class="navbar-link">
                        <span class="icon"><i class="fas fa-user-circle"></i></span>
                        <span><?= $_SESSION['nombre'] ?? 'Usuario' ?></span>
                    </a>
                    <div class="navbar-dropdown is-right">
                        <a href="<?= $ruta ?>logout.php" class="navbar-item has-text-danger">
                            <span class="icon"><i class="fas fa-sign-out-alt"></i></span>
                            <span>Cerrar Sesión</span>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </nav>

    <section class="hero is-medium hero-background is-bold has-text-white">
        <div class="hero-body">
            <div class="container has-text-centered">
                <h1 class="title is-1 has-text-white">
                    <i class="fas fa-plane-departure mr-3"></i>
                    Sistema de Gestión
                </h1>
                <p class="subtitle is-3 has-text-white-ter">
                    Agencia Caribe Azul Travel
                </p>
                <p class="is-size-5">Gestiona turistas, cotizaciones y reservas de forma eficiente.</p>
            </div>
        </div>
    </section>

    <section class="section" style="margin-top: -3rem;">
        <div class="container">
            <div class="columns is-multiline">

                <div class="column is-3">
                    <div class="card card-hover">
                        <div class="card-content has-text-centered">
                            <span class="icon is-large has-text-success mb-3">
                                <i class="fas fa-users fa-3x"></i>
                            </span>
                            <p class="title is-4">Turistas</p>
                            <p class="subtitle is-6">Base de datos de clientes</p>
                            <div class="content">
                                Registra, actualiza y busca información de tus clientes frecuentes.
                            </div>
                        </div>
                        <footer class="card-footer">
                            <a href="turistas/listar.php" class="card-footer-item has-text-success has-text-weight-bold">Gestionar Clientes</a>
                        </footer>
                    </div>
                </div>

                <div class="column is-3">
                    <div class="card card-hover">
                        <div class="card-content has-text-centered">
                            <span class="icon is-large has-text-info mb-3">
                                <i class="fas fa-calculator fa-3x"></i>
                            </span>
                            <p class="title is-4">Cotizador</p>
                            <p class="subtitle is-6">Calcular Paquetes</p>
                            <div class="content pb-5">
                                Realiza cálculos automáticos de hoteles, días y tarifas por persona.
                            </div>
                        </div>
                        <footer class="card-footer">
                            <a href="presupuestos/crear.php" class="card-footer-item has-text-info has-text-weight-bold">Crear Presupuesto</a>
                        </footer>
                    </div>
                </div>

                <div class="column is-3">
                    <div class="card card-hover">
                        <div class="card-content has-text-centered">
                            <span class="icon is-large has-text-warning mb-3">
                                <i class="fas fa-ticket-alt fa-3x"></i>
                            </span>
                            <p class="title is-4">Reservas</p>
                            <p class="subtitle is-6">Ventas Confirmadas</p>
                            <div class="content pb-5">
                                Genera reservas finales, códigos de confirmación y comprobantes.
                            </div>
                        </div>
                        <footer class="card-footer">
                            <a href="reservas/listar.php" class="card-footer-item has-text-warning has-text-weight-bold">Ver Reservas</a>
                        </footer>
                    </div>
                </div>

                <div class="column is-3">
                    <div class="card card-hover">
                        <div class="card-content has-text-centered">
                            <span class="icon is-large has-text-danger mb-3">
                                <i class="fas fa-chart-pie fa-3x"></i>
                            </span>
                            <p class="title is-4">Reportes</p>
                            <p class="subtitle is-6">Estadísticas y Gráficos</p>
                            <div class="content">
                                Visualiza los hoteles más vendidos, ingresos mensuales y mejores clientes.
                            </div>
                        </div>
                        <footer class="card-footer">
                            <a href="reportes/index.php" class="card-footer-item has-text-danger has-text-weight-bold">Ver Estadísticas</a>
                        </footer>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <footer class="footer has-background-light mt-6">
        <div class="content has-text-centered">
            <p>
                <strong>Caribe Azul Travel</strong> diseñado con <a href="https://bulma.io" target="_blank">Bulma</a>.
                <br>Proyecto Universitario de Base de Datos.
            </p>
        </div>
    </footer>

    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const $navbarBurgers = Array.prototype.slice.call(document.querySelectorAll('.navbar-burger'), 0);
            if ($navbarBurgers.length > 0) {
                $navbarBurgers.forEach(el => {
                    el.addEventListener('click', () => {
                        const target = el.dataset.target;
                        const $target = document.getElementById(target);
                        el.classList.toggle('is-active');
                        $target.classList.toggle('is-active');
                    });
                });
            }
        });
    </script>
</body>

</html>