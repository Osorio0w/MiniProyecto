<?php
include("../config/seguridad.php");
include("../config/conexion.php");

$mensaje = "";
$tipo_mensaje = "";

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $nombre    = trim($_POST['nombre']);
    $apellido  = trim($_POST['apellido']);
    $id_doc    = $_POST['documento'];
    $num_doc   = trim($_POST['numero']);
    $correo    = trim($_POST['correo']);
    $ubicacion = trim($_POST['ubicacion']);

    $prefijo    = $_POST['prefijo'];       
    $tlf_cuerpo = trim($_POST['telefono']); 

    if (!preg_match("/^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$/", $nombre)) {
        $mensaje = "El nombre solo puede contener letras.";
        $tipo_mensaje = "is-danger";
    } elseif (!preg_match("/^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$/", $apellido)) {
        $mensaje = "El apellido solo puede contener letras.";
        $tipo_mensaje = "is-danger";
    } elseif (!ctype_digit($num_doc)) {
        $mensaje = "El documento solo puede contener números.";
        $tipo_mensaje = "is-danger";
    } elseif (!ctype_digit($tlf_cuerpo)) {
        $mensaje = "El teléfono debe contener solo números (sin guiones ni espacios).";
        $tipo_mensaje = "is-danger";
    } elseif (!filter_var($correo, FILTER_VALIDATE_EMAIL)) {
        $mensaje = "El formato del correo no es válido.";
        $tipo_mensaje = "is-danger";
    } else {

        $telefono_final = $prefijo . $tlf_cuerpo; 

        try {
            $sql = "INSERT INTO turistas (nombre, apellido, id_tipo_documento, numero_documento, telefono, correo, ubicacion, activo) 
                    VALUES (?, ?, ?, ?, ?, ?, ?, 1)";

            $stmt = $con->prepare($sql);
            $stmt->bind_param("ssissss", $nombre, $apellido, $id_doc, $num_doc, $telefono_final, $correo, $ubicacion);

            if ($stmt->execute()) {
                header("Location: listar.php?msg=guardado");
                exit;
            }
        } catch (mysqli_sql_exception $e) {
            if ($e->getCode() == 1062) {
                $mensaje = "¡Error! Ya existe un turista registrado con ese documento.";
                $tipo_mensaje = "is-warning";
            } else {
                $mensaje = "Ocurrió un error técnico: " . $e->getMessage();
                $tipo_mensaje = "is-danger";
            }
        }
    }
}

$tipos = $con->query("SELECT * FROM tipo_documentos");
?>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <title>Registrar Turista</title>
    <link rel="icon" href="../assets/img/Icono.png">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="../css/estilos.css">
</head>

<body>

    <section class="section">
        <div class="container">

            <nav class="breadcrumb" aria-label="breadcrumbs">
                <ul>
                    <li><a href="../index.php">Inicio</a></li>
                    <li><a href="listar.php">Turistas</a></li>
                    <li class="is-active"><a href="#" aria-current="page">Nuevo</a></li>
                </ul>
            </nav>

            <h1 class="title">Registrar Nuevo Turista</h1>

            <?php if ($mensaje): ?>
                <div class="notification <?= $tipo_mensaje ?>">
                    <button class="delete" onclick="this.parentElement.style.display='none'"></button>
                    <?= $mensaje ?>
                </div>
            <?php endif; ?>

            <form method="POST" class="box">

                <div class="columns">
                    <div class="column">
                        <label class="label">Nombre</label>
                        <div class="control has-icons-left">
                            <input class="input" type="text" name="nombre" required
                                placeholder="Ej. Ana" value="<?= $_POST['nombre'] ?? '' ?>">
                            <span class="icon is-small is-left"><i class="fas fa-user"></i></span>
                        </div>
                    </div>
                    <div class="column">
                        <label class="label">Apellido</label>
                        <div class="control has-icons-left">
                            <input class="input" type="text" name="apellido" required
                                placeholder="Ej. Pérez" value="<?= $_POST['apellido'] ?? '' ?>">
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
                                    <option value="<?= $t['id_tipo_documento'] ?>">
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
                                placeholder="Solo números" value="<?= $_POST['numero'] ?? '' ?>">
                            <span class="icon is-small is-left"><i class="fas fa-id-card"></i></span>
                        </div>
                    </div>
                </div>

                <div class="columns">
                    <div class="column">
                        <label class="label">Correo Electrónico</label>
                        <div class="control has-icons-left">
                            <input class="input" type="email" name="correo" required
                                placeholder="nombre@correo.com" value="<?= $_POST['correo'] ?? '' ?>">
                            <span class="icon is-small is-left"><i class="fas fa-envelope"></i></span>
                        </div>
                    </div>

                    <div class="column">
                        <label class="label">Teléfono Móvil</label>
                        <div class="field has-addons">
                            <p class="control">
                                <span class="select">
                                    <select name="prefijo">
                                        <option value="+58" selected>🇻🇪 +58</option>
                                        <option value="+1">🇺🇸 +1</option>
                                        <option value="+34">🇪🇸 +34</option>
                                        <option value="+57">🇨🇴 +57</option>
                                        <option value="+55">🇧🇷 +55</option>
                                        <option value="+54">🇦🇷 +54</option>
                                    </select>
                                </span>
                            </p>
                            <p class="control is-expanded has-icons-left">
                                <input class="input" type="text" name="telefono"
                                    placeholder="Ej: 4141234567"
                                    pattern="[0-9]+"
                                    maxlength="15"
                                    title="Solo números"
                                    required
                                    value="<?= $_POST['telefono'] ?? '' ?>">
                                <span class="icon is-small is-left">
                                    <i class="fas fa-mobile-alt"></i>
                                </span>
                            </p>
                        </div>
                        <p class="help">Sin el cero inicial (Ej: 412...)</p>
                    </div>
                </div>

                <div class="field">
                    <label class="label">Ubicación (Ciudad)</label>
                    <div class="control has-icons-left">
                        <input class="input" type="text" name="ubicacion" required
                            placeholder="Ej. Caracas" value="<?= $_POST['ubicacion'] ?? '' ?>">
                        <span class="icon is-small is-left"><i class="fas fa-map-marker-alt"></i></span>
                    </div>
                </div>

                <div class="buttons is-right">
                    <a href="listar.php" class="button is-text">Cancelar</a>
                    <button type="submit" class="button is-primary">Guardar Turista</button>
                </div>
            </form>

        </div>
    </section>
</body>

</html>