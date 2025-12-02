<?php
include("../config/seguridad.php");
include("../config/conexion.php");

$por_pagina = 5;
$pagina_actual = isset($_GET['page']) ? (int)$_GET['page'] : 1;
if ($pagina_actual < 1) $pagina_actual = 1;
$inicio = ($pagina_actual - 1) * $por_pagina;

$buscar    = $_GET["buscar"] ?? "";
$ubicacion = $_GET["ubicacion"] ?? "";

$ciudades = $con->query("SELECT DISTINCT ubicacion FROM turistas WHERE activo = 1 ORDER BY ubicacion ASC");

$where = "WHERE t.activo = 1";
$params = [];
$tipos = "";

if (!empty($buscar)) {
    $where .= " AND (t.nombre LIKE ? OR t.apellido LIKE ? OR t.numero_documento LIKE ?)";
    $wildcard = "%$buscar%";
    $params[] = $wildcard;
    $params[] = $wildcard;
    $params[] = $wildcard;
    $tipos .= "sss";
}

if (!empty($ubicacion)) {
    $where .= " AND t.ubicacion = ?";
    $params[] = $ubicacion;
    $tipos .= "s";
}


$sql_total = "SELECT COUNT(*) as total FROM turistas t $where";
$stmt_total = $con->prepare($sql_total);
if (!empty($params)) {
    $stmt_total->bind_param($tipos, ...$params);
}
$stmt_total->execute();
$fila_total = $stmt_total->get_result()->fetch_assoc();
$total_registros = $fila_total['total'];
$total_paginas = ceil($total_registros / $por_pagina);

$sql_datos = "SELECT 
                t.id_turista, t.nombre, t.apellido, t.telefono, 
                t.ubicacion, t.correo, td.codigo, t.numero_documento
              FROM turistas t
              INNER JOIN tipo_documentos td ON td.id_tipo_documento = t.id_tipo_documento
              $where
              ORDER BY t.id_turista DESC
              LIMIT ?, ?";

$params[] = $inicio;
$params[] = $por_pagina;
$tipos .= "ii";

$stmt = $con->prepare($sql_datos);
$stmt->bind_param($tipos, ...$params);
$stmt->execute();
$resultado = $stmt->get_result();
?>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <title>Listado de Turistas</title>
    <link rel="icon" href="../assets/img/Icono.png">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
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
                    <li class="is-active"><a href="#" aria-current="page">Turistas</a></li>
                </ul>
            </nav>
            <div class="level">
                <div class="level-left">
                    <h1 class="title">Listado de Turistas</h1>
                </div>
                <div class="level-right">
                    <a href="registrar.php" class="button is-primary">
                        <span class="icon"><i class="fas fa-user-plus"></i></span>
                        <span>Nuevo Turista</span>
                    </a>
                </div>
            </div>

            <?php if (isset($_GET["ok"])): ?>
                <div class="notification is-success is-light"><button class="delete"></button>✅ Turista registrado.</div>
            <?php endif; ?>
            <?php if (isset($_GET["edit"])): ?>
                <div class="notification is-info is-light"><button class="delete"></button>✅ Turista actualizado.</div>
            <?php endif; ?>
            <?php if (isset($_GET["msg"]) && $_GET["msg"] == "eliminado"): ?>
                <div class="notification is-danger is-light"><button class="delete"></button>🗑️ Turista eliminado.</div>
            <?php endif; ?>

            <div class="box has-background-light">
                <form method="GET">
                    <div class="columns is-vcentered">

                        <div class="column is-5">
                            <label class="label is-small">Buscar</label>
                            <div class="control has-icons-left">
                                <input type="text" name="buscar" class="input"
                                    placeholder="Nombre, apellido o cédula..."
                                    value="<?php echo htmlspecialchars($buscar); ?>">
                                <span class="icon is-small is-left"><i class="fas fa-search"></i></span>
                            </div>
                        </div>

                        <div class="column is-3">
                            <label class="label is-small">Filtrar por Ciudad</label>
                            <div class="select is-fullwidth">
                                <select name="ubicacion" onchange="this.form.submit()">
                                    <option value="">Todas las ciudades</option>
                                    <?php while ($c = $ciudades->fetch_assoc()): ?>
                                        <option value="<?= $c['ubicacion'] ?>" <?= ($ubicacion == $c['ubicacion']) ? 'selected' : '' ?>>
                                            <?= $c['ubicacion'] ?>
                                        </option>
                                    <?php endwhile; ?>
                                </select>
                            </div>
                        </div>

                        <div class="column is-4 has-text-right">
                            <label class="label is-small">&nbsp;</label>
                            <button class="button is-info">
                                <span class="icon"><i class="fas fa-filter"></i></span>
                                <span>Filtrar</span>
                            </button>
                            <a href="listar.php" class="button is-white">Limpiar</a>
                            <a href="exportar_csv.php" class="button is-success is-outlined" title="Descargar Excel">
                                <span class="icon"><i class="fas fa-file-excel"></i></span>
                            </a>
                        </div>
                    </div>
                </form>
            </div>

            <div class="box">
                <div class="table-container">
                    <table class="table is-fullwidth is-striped is-hoverable">
                        <thead>
                            <tr>
                                <th>Nombre</th>
                                <th>Documento</th>
                                <th>Teléfono</th>
                                <th>Correo</th>
                                <th>Ubicación</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if ($resultado->num_rows == 0): ?>
                                <tr>
                                    <td colspan="6" class="has-text-centered py-5">
                                        <p class="subtitle is-5 has-text-grey">No se encontraron resultados 🔍</p>
                                    </td>
                                </tr>
                            <?php else: ?>
                                <?php while ($t = $resultado->fetch_assoc()): ?>
                                    <tr>
                                        <td><strong><?php echo $t["nombre"] . " " . $t["apellido"]; ?></strong></td>
                                        <td><?php echo $t["codigo"] . "-" . $t["numero_documento"]; ?></td>
                                        <td><?php echo $t["telefono"]; ?></td>
                                        <td><?php echo $t["correo"]; ?></td>
                                        <td>
                                            <span class="tag is-info is-light">
                                                <i class="fas fa-map-marker-alt mr-1"></i> <?= $t["ubicacion"]; ?>
                                            </span>
                                        </td>
                                        <td>
                                            <div class="buttons are-small">
                                                <a href="historial.php?id=<?= $t['id_turista']; ?>" class="button is-info" title="Ver Historial">
                                                    <span class="icon"><i class="fas fa-history"></i></span>
                                                </a>
                                                <a href="editar.php?id=<?= $t['id_turista']; ?>" class="button is-warning is-light">
                                                    <span class="icon"><i class="fas fa-edit"></i></span>
                                                </a>
                                                <a href="eliminar.php?id=<?= $t['id_turista']; ?>"
                                                    class="button is-danger is-light"
                                                    onclick="return confirm('¿Seguro que deseas eliminar a este turista?');">
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
                    <hr>
                    <nav class="pagination is-centered is-rounded" role="navigation">
                        <a href="?page=<?= $pagina_actual - 1 ?>&buscar=<?= $buscar ?>&ubicacion=<?= $ubicacion ?>"
                            class="pagination-previous"
                            <?= ($pagina_actual <= 1) ? 'disabled' : '' ?>>Anterior</a>

                        <a href="?page=<?= $pagina_actual + 1 ?>&buscar=<?= $buscar ?>&ubicacion=<?= $ubicacion ?>"
                            class="pagination-next"
                            <?= ($pagina_actual >= $total_paginas) ? 'disabled' : '' ?>>Siguiente</a>

                        <ul class="pagination-list">
                            <?php for ($i = 1; $i <= $total_paginas; $i++): ?>
                                <li>
                                    <a href="?page=<?= $i ?>&buscar=<?= $buscar ?>&ubicacion=<?= $ubicacion ?>"
                                        class="pagination-link <?= ($i == $pagina_actual) ? 'is-current' : '' ?>">
                                        <?= $i ?>
                                    </a>
                                </li>
                            <?php endfor; ?>
                        </ul>
                    </nav>
                <?php endif; ?>
            </div>

        </div>
    </section>
</body>

</html>