<?php
include("../config/seguridad.php");
include("../config/conexion.php");

$por_pagina = 10;
$pagina_actual = isset($_GET['page']) ? (int)$_GET['page'] : 1;
if ($pagina_actual < 1) $pagina_actual = 1;
$inicio = ($pagina_actual - 1) * $por_pagina;

$buscar = $_GET['buscar'] ?? '';

$where = "WHERE activo = 1"; 

if ($buscar != "") {
    $where .= " AND (nombre LIKE '%$buscar%' OR apellido LIKE '%$buscar%' OR numero_documento LIKE '%$buscar%')";
}

$sql_total = "SELECT COUNT(*) as total FROM v_turistas_completo $where";
$total_registros = $con->query($sql_total)->fetch_assoc()['total'];
$total_paginas = ceil($total_registros / $por_pagina);

$sql = "SELECT * FROM v_turistas_completo 
        $where 
        ORDER BY id_turista DESC 
        LIMIT $inicio, $por_pagina";

$resultado = $con->query($sql);
?>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <title>Gestión de Turistas</title>
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
                    <li><a href="../index.php">Inicio</a></li>
                    <li class="is-active"><a href="#" aria-current="page">Turistas</a></li>
                </ul>
            </nav>

            <div class="level">
                <div class="level-left">
                    <h1 class="title">Directorio de Clientes</h1>
                </div>
                <div class="level-right">
                    <a href="registrar.php" class="button is-primary">
                        <span class="icon"><i class="fas fa-user-plus"></i></span>
                        <span>Nuevo Turista</span>
                    </a>
                </div>
            </div>

            <?php if (isset($_GET['msg'])): ?>
                <div class="notification is-success is-light">
                    <button class="delete" onclick="this.parentElement.style.display='none'"></button>
                    <?php
                    if ($_GET['msg'] == 'guardado') echo "Turista registrado correctamente.";
                    if ($_GET['msg'] == 'actualizado') echo "Datos actualizados correctamente.";
                    if ($_GET['msg'] == 'eliminado') echo "Turista eliminado correctamente.";
                    ?>
                </div>
            <?php endif; ?>

            <div class="box has-background-light">
                <form method="GET">
                    <div class="field has-addons">
                        <div class="control is-expanded has-icons-left">
                            <input class="input" type="text" name="buscar" placeholder="Buscar por nombre, apellido o cédula..." value="<?= htmlspecialchars($buscar) ?>">
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
                                <th>Nombre Completo</th>
                                <th>Documento</th>
                                <th>Contacto</th>
                                <th>Ubicación</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if ($resultado->num_rows == 0): ?>
                                <tr>
                                    <td colspan="5" class="has-text-centered py-5">
                                        <p class="subtitle is-5 has-text-grey">No se encontraron turistas 🔍</p>
                                    </td>
                                </tr>
                            <?php else: ?>
                                <?php while ($row = $resultado->fetch_assoc()): ?>
                                    <tr>
                                        <td>
                                            <strong><?= $row['nombre'] ?> <?= $row['apellido'] ?></strong>
                                        </td>
                                        <td>
                                            <span class="tag is-light is-info"><?= $row['tipo_doc_codigo'] ?></span>
                                            <?= $row['numero_documento'] ?>
                                        </td>
                                        <td>
                                            <span class="icon is-small has-text-grey"><i class="fas fa-envelope"></i></span>
                                            <?= $row['correo'] ?><br>
                                            <span class="icon is-small has-text-grey"><i class="fas fa-phone"></i></span>
                                            <?= $row['telefono'] ?>
                                        </td>
                                        <td><?= $row['ubicacion'] ?></td>
                                        <td>
                                            <div class="buttons are-small">
                                                <a href="historial.php?id=<?= $row['id_turista'] ?>" class="button is-info is-outlined" title="Ver Historial">
                                                    <span class="icon"><i class="fas fa-history"></i></span>
                                                </a>
                                                <a href="editar.php?id=<?= $row['id_turista'] ?>" class="button is-warning is-outlined" title="Editar">
                                                    <span class="icon"><i class="fas fa-edit"></i></span>
                                                </a>
                                                <a href="eliminar.php?id=<?= $row['id_turista'] ?>" class="button is-danger is-outlined" onclick="return confirm('¿Seguro que desea eliminar a este turista?');" title="Eliminar">
                                                    <span class="icon"><i class="fas fa-trash"></i></span>
                                                </a>
                                            </div>
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