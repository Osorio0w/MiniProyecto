<?php
include("../config/seguridad.php");
include("../config/conexion.php");

$id = isset($_GET['id']) ? (int)$_GET['id'] : 0;

$stmt = $con->prepare("SELECT * FROM turistas WHERE id_turista = ?");
$stmt->bind_param("i", $id);
$stmt->execute();
$turista = $stmt->get_result()->fetch_assoc();

if (!$turista) {
    die("Turista no encontrado.");
}

$tipos = $con->query("SELECT * FROM tipo_documentos");
?>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <title>Editar Turista</title>
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
                    <li><a href="listar.php">Turistas</a></li>
                    <li class="is-active"><a href="#" aria-current="page">Editar</a></li>
                </ul>
            </nav>

            <h1 class="title">Editar Turista</h1>
            <h2 class="subtitle is-6">Modificando a: <strong><?= $turista['nombre'] . ' ' . $turista['apellido'] ?></strong></h2>

            <form action="actualizar.php" method="POST" class="box">

                <input type="hidden" name="id" value="<?= $turista['id_turista'] ?>">

                <div class="columns">
                    <div class="column">
                        <label class="label">Nombre</label>
                        <div class="control has-icons-left">
                            <input class="input" type="text" name="nombre" required
                                value="<?= $turista['nombre'] ?>">
                            <span class="icon is-small is-left"><i class="fas fa-user"></i></span>
                        </div>
                    </div>
                    <div class="column">
                        <label class="label">Apellido</label>
                        <div class="control has-icons-left">
                            <input class="input" type="text" name="apellido" required
                                value="<?= $turista['apellido'] ?>">
                            <span class="icon is-small is-left"><i class="fas fa-user"></i></span>
                        </div>
                    </div>
                </div>

                <div class="columns">
                    <div class="column is-one-third">
                        <label class="label">Tipo Doc</label>
                        <div class="select is-fullwidth">
                            <select name="documento">
                                <?php while ($t = $tipos->fetch_assoc()): ?>
                                    <option value="<?= $t['id_tipo_documento'] ?>"
                                        <?= ($t['id_tipo_documento'] == $turista['id_tipo_documento']) ? 'selected' : '' ?>>
                                        <?= $t['codigo'] ?> - <?= $t['descripcion'] ?>
                                    </option>
                                <?php endwhile; ?>
                            </select>
                        </div>
                    </div>
                    <div class="column">
                        <label class="label">Número Documento</label>
                        <div class="control has-icons-left">
                            <input class="input" type="text" name="numero" required
                                value="<?= $turista['numero_documento'] ?>">
                            <span class="icon is-small is-left"><i class="fas fa-id-card"></i></span>
                        </div>
                    </div>
                </div>

                <div class="columns">
                    <div class="column">
                        <label class="label">Correo</label>
                        <div class="control has-icons-left">
                            <input class="input" type="email" name="correo" required
                                value="<?= $turista['correo'] ?>">
                            <span class="icon is-small is-left"><i class="fas fa-envelope"></i></span>
                        </div>
                    </div>
                    <div class="column">
                        <label class="label">Teléfono</label>
                        <div class="control has-icons-left">
                            <input class="input" type="text" name="telefono"
                                value="<?= $turista['telefono'] ?>">
                            <span class="icon is-small is-left"><i class="fas fa-phone"></i></span>
                        </div>
                    </div>
                </div>

                <div class="field">
                    <label class="label">Ubicación</label>
                    <div class="control has-icons-left">
                        <input class="input" type="text" name="ubicacion"
                            value="<?= $turista['ubicacion'] ?>">
                        <span class="icon is-small is-left"><i class="fas fa-map-marker-alt"></i></span>
                    </div>
                </div>

                <div class="buttons is-right">
                    <a href="listar.php" class="button is-text">Cancelar</a>
                    <button type="submit" class="button is-success">
                        <span class="icon"><i class="fas fa-save"></i></span>
                        <span>Guardar Cambios</span>
                    </button>
                </div>

            </form>
        </div>
    </section>
</body>

</html>